# Snowflake Data Load via Azure Storage Integration

This project demonstrates how to load data from Azure Data Lake into Snowflake using Azure Storage Integration. The process involves setting up the necessary roles, warehouses, storage integration, and schema before loading the data into Snowflake tables.

## Setup and Load Process

```sql
-- Set the Role
USE ROLE accountadmin;

-- Set the Warehouse
USE WAREHOUSE COMPUTE_ETL_WH;

-- Setup Azure storage integration
CREATE STORAGE INTEGRATION "Azure_Stg_Integration"
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant ID>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<storageaccount>.blob.core.windows.net/stg');

-- Granting Snowflake access to ADL (Azure Data Lake)
DESC STORAGE INTEGRATION "Azure_Stg_Integration;"

-- Create Database for staging data
CREATE OR REPLACE DATABASE "AzureStagingData";

-- Create schema for raw data from Azure Data Lake Storage
CREATE OR REPLACE SCHEMA "AzureStagingData"."ADLSRawData";

-- Create schema for staging data before loading into final tables
CREATE OR REPLACE SCHEMA "AzureStagingData"."ETLStaging";

-- Create an external stage pointing to Azure Data Lake Storage
CREATE STAGE "AzureStagingData"."ADLSRawData"."Blob_Stg_Azure"
  STORAGE_INTEGRATION = "Azure_Stg_Integration"
  URL = 'azure://<storageaccount>.blob.core.windows.net/stg'
  FILE_FORMAT = (type = csv, SKIP_HEADER = 1);

-- Query the Stage to find the files (optional, for verification)
LIST @"AzureStagingData"."ADLSRawData"."Blob_Stg_Azure";

-- Create table to store the ingested data
CREATE OR REPLACE TABLE "AzureStagingData"."ETLStaging"."MockData_csv"
(
    id INT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    gender TEXT,
    ip_address TEXT
);

-- Copy data from the external stage to the Snowflake table
COPY INTO "AzureStagingData"."ETLStaging"."MockData_csv"
FROM @"AzureStagingData"."ADLSRawData"."Blob_Stg_Azure";

-- Confirm data exists in the table
SELECT * FROM "AzureStagingData"."ETLStaging"."MockData_csv";


Refer to the Snowflake documentation for configuring secure access to cloud storage: https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-azure#configuring-secure-access-to-cloud-storage