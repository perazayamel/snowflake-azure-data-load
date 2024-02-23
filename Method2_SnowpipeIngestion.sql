
### Method 2: Using Snowpipe with `auto_ingest` set to `true`

```markdown
# Snowflake Data Load via Snowpipe and Azure Storage Queue

This project demonstrates how to automate data loading from Azure Data Lake to Snowflake using Snowpipe with `auto_ingest` set to `true` and leveraging Azure Storage Queue for event notification.

## Setup and Load Process

```sql
-- Set the Role
USE ROLE accountadmin;

-- Set the Warehouse
USE WAREHOUSE COMPUTE_ETL_WH;

-- Create notification integration for Azure Storage Queue
CREATE NOTIFICATION INTEGRATION "Azure_Stg_Notification_Integration"
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://<storageaccount>.queue.core.windows.net/<queue-name>'
  AZURE_TENANT_ID = '<Tenant ID>';

-- Grant Snowflake access to the storage queue
DESC NOTIFICATION INTEGRATION "Azure_Stg_Notification_Integration";

-- Create Database for staging data
CREATE OR REPLACE DATABASE "AzureStagingData";

-- Create schema for raw data from Azure Data Lake Storage
CREATE OR REPLACE SCHEMA "AzureStagingData"."ADLSRawData";

-- Create schema for staging data before loading into final tables
CREATE OR REPLACE SCHEMA "AzureStagingData"."ETLStaging";

-- Create an external stage pointing to Azure Data Lake Storage, specifying file format
CREATE STAGE "AzureStagingData"."ADLSRawData"."Blob_Stg_Customer_Azure"
  STORAGE_INTEGRATION = "Azure_Stg_Integration"
  URL = 'azure://<storageaccount>.blob.core.windows.net/stg/customer'
  FILE_FORMAT = (type = csv, SKIP_HEADER = 1);

-- Create table to store the ingested data
CREATE OR REPLACE TABLE "AzureStagingData"."ETLStaging"."MockData_Snowpipe_csv"
(
    id INT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    gender TEXT,
    ip_address TEXT
);

-- Create Snowpipe to ingest data, using the notification integration
CREATE OR REPLACE PIPE "AzureStagingData"."AzureSnowpipe"."CustomerSnowpipe"
  auto_ingest = true
  integration = 'AZURE_STG_NOTIFICATION_INTEGRATION'
  AS
  COPY INTO "AzureStagingData"."ETLStaging"."MockData_Snowpipe_csv"
  FROM @"AzureStagingData"."ADLSRawData"."Blob_Stg_Customer_Azure";

-- Confirm data exists in the table
SELECT COUNT(*) FROM "AzureStagingData"."ETLStaging"."MockData_Snowpipe_csv";
SELECT * FROM "AzureStagingData"."ETLStaging"."MockData_Snowpipe_csv";

Refer to the Snowflake documentation for automating data loads with Snowpipe and Azure Storage Queues: https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-azure