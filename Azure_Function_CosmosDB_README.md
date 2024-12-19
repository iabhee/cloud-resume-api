
# Azure Function with Cosmos DB Integration

This Azure Function fetches data from an Azure Cosmos DB instance and dynamically serves the data either as JSON or HTML, depending on the query parameters provided in the request.

## Features
- Fetches data from Azure Cosmos DB using the Cosmos DB SDK.
- Cleans and formats the fetched data.
- Supports rendering the data as JSON or HTML (using a JSON Resume theme).
- Handles missing or malformed data gracefully.
- Logs detailed information for debugging.

## Prerequisites
1. **Azure Cosmos DB**:
   - A Cosmos DB account with a database and container set up.
   - Required environment variables:
     - `COSMOS_DB_ENDPOINT`: The endpoint URL of the Cosmos DB account.
     - `COSMOS_DB_KEY`: The primary key for authentication.
     - `COSMOS_DB_DATABASE`: The name of the database.
     - `COSMOS_DB_CONTAINER`: The name of the container.

2. **Azure Function App**:
   - A Node.js-based Azure Function App.
   - Required tools:
     - [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local)
     - [Node.js](https://nodejs.org/)
     - [npm](https://www.npmjs.com/)

## Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up local environment variables:
   Create a `.env` file in the root directory with the following variables:
   ```env
   COSMOS_DB_ENDPOINT=<Your Cosmos DB Endpoint>
   COSMOS_DB_KEY=<Your Cosmos DB Key>
   COSMOS_DB_DATABASE=<Your Database Name>
   COSMOS_DB_CONTAINER=<Your Container Name>
   ```

## Usage
1. Run the function locally:
   ```bash
   func start
   ```

2. Make a request to the function:
   - Fetch data as JSON:
     ```bash
     curl "http://localhost:7071/api/<function-name>?id=<document-id>"
     ```
   - Fetch data as HTML:
     ```bash
     curl "http://localhost:7071/api/<function-name>?id=<document-id>&route=html"
     ```

## Code Overview
### Environment Variables
The following environment variables must be defined for the function to connect to Cosmos DB:
- `COSMOS_DB_ENDPOINT`: Cosmos DB account endpoint.
- `COSMOS_DB_KEY`: Authentication key for Cosmos DB.
- `COSMOS_DB_DATABASE`: Database name.
- `COSMOS_DB_CONTAINER`: Container name.

### Function Logic
1. **Initialize Cosmos DB Client**:
   ```javascript
   const client = new CosmosClient({ endpoint, key });
   ```

2. **Fetch Data from Cosmos DB**:
   - Using the document ID and partition key:
     ```javascript
     const { resource: jsonData } = await container.item(id, partitionKey).read();
     ```

3. **Clean Fetched Data**:
   - Remove metadata fields from the fetched document:
     ```javascript
     delete cleanJsonData.id;
     delete cleanJsonData._rid;
     delete cleanJsonData._self;
     delete cleanJsonData._etag;
     delete cleanJsonData._attachments;
     delete cleanJsonData._ts;
     ```

4. **Serve Data as JSON or HTML**:
   - Render HTML using the `jsonresume-theme-elegant` package:
     ```javascript
     const html = render(cleanJsonData);
     ```
   - Return JSON response:
     ```javascript
     context.res = {
         status: 200,
         headers: { "Content-Type": "application/json" },
         body: cleanJsonData,
     };
     ```

### Error Handling
- Handles missing or malformed data:
  ```javascript
  if (!cleanJsonData || !cleanJsonData.basics) {
      context.res = {
          status: 404,
          body: `Data not found or missing 'basics' field for id: ${id}`,
      };
      return;
  }
  ```
- Logs errors and returns appropriate HTTP status codes.

### Logging
Detailed logs are provided to aid in debugging:
- Logs the Cosmos DB endpoint and query details.
- Logs the fetched data and cleaned data.

## Deployment
1. Deploy the Azure Function:
   ```bash
   func azure functionapp publish <function-app-name>
   ```

2. Ensure the required environment variables are set in the Azure Function App settings.

## References
- [Azure Cosmos DB SDK for Node.js](https://learn.microsoft.com/en-us/javascript/api/overview/azure/cosmos-readme)
- [Azure Functions Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [JSON Resume Themes](https://github.com/jsonresume)
