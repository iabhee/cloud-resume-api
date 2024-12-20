const { CosmosClient } = require("@azure/cosmos");
const { render } = require("jsonresume-theme-elegant"); // Import the theme

module.exports = async function (context, req) {
    const endpoint = process.env.COSMOS_DB_ENDPOINT;  //COSMOS DB endpoint url
    const key = process.env.COSMOS_DB_KEY; //COSMOS DB primary key
    const databaseName = process.env.COSMOS_DB_DATABASE; //COSMOS DB database name
    const containerName = process.env.COSMOS_DB_CONTAINER; //COSMOS DB container name

    if (!endpoint || !key || !databaseName || !containerName) {
        context.res = {
            status: 500,
            body: "Cosmos DB configuration is missing or incomplete.",
        };
        return;
    }

    const client = new CosmosClient({ endpoint, key });
    const id = req.query.id || "1"; // Default to id = "1" if not provided
    const partitionKey = id; // Assuming id is the partition key

    try {
        const database = client.database(databaseName);
        const container = database.container(containerName);

        const { resource: jsonData } = await container.item(id, partitionKey).read();

        if (!jsonData) {
            context.res = {
                status: 404,
                body: `No data found for id: ${id}`,
            };
            return;
        }

        // Cleanup metadata
        const cleanMetadata = ({ id, _rid, _self, _etag, _attachments, _ts, ...rest }) => rest;
        const cleanJsonData = cleanMetadata(jsonData);

        if (!cleanJsonData.basics) {
            context.res = {
                status: 404,
                body: "Invalid data structure: 'basics' field is missing.",
            };
            return;
        }

        const route = req.query.route || "json";
        if (route.toLowerCase() === "html") {
            const html = render(cleanJsonData);
            context.res = {
                status: 200,
                headers: { "Content-Type": "text/html" },
                body: html,
            };
        } else if (route.toLowerCase() === "json") {
            context.res = {
                status: 200,
                headers: { "Content-Type": "application/json" },
                body: cleanJsonData,
            };
        } else {
            context.res = {
                status: 400,
                body: "Invalid route. Allowed values are 'html' or 'json'.",
            };
        }
    } catch (error) {
        context.log.error("Error fetching data:", error);
        context.res = {
            status: 500,
            body: "An error occurred while processing your request.",
        };
    }
};
