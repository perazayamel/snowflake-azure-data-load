# Snowflake-Azure Data Load

This repository provides SQL scripts and guides for efficiently loading data from Azure Data Lake (ADL) into Snowflake, using two primary methods: direct storage integration and automated ingestion via Snowpipe with `auto_ingest=true`. Ideal for data engineers implementing Azure to Snowflake data workflows.

## Getting Started

Follow these instructions to get the project up and running on your Snowflake account for development and testing purposes.

### Prerequisites

- Access to an Azure subscription and Azure Data Lake Storage.
- A Snowflake account with appropriate permissions.

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/perazayamel/snowflake-azure-data-load.git

Configure Azure and Snowflake
Utilize the provided SQL scripts to set up Azure storage integration and configure Snowpipe in Snowflake for data loading.

Usage

Method 1: Direct Storage Integration
Refer to Method1_DirectStorageIntegration.sql for step-by-step SQL commands to establish storage integration and load data from ADL.
Method 2: Snowpipe Ingestion
See Method2_SnowpipeIngestion.sql for instructions on creating a Snowpipe to automate data ingestion upon new file arrivals in ADL.
Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

Fork the Project
Create your Feature Branch (git checkout -b feature/AmazingFeature)
Commit your Changes (git commit -m 'Add some AmazingFeature')
Push to the Branch (git push origin feature/AmazingFeature)
Open a Pull Request


Acknowledgments

Snowflake Documentation
Azure Data Lake Storage Documentation
And everyone who contributed to this project!


This README.md file is designed to provide a clear overview of your project, how to get started, how to use the scripts provided, and how to contribute to the project. It includes placeholders for your specific project details, which you should replace with actual information relevant to your project.


Ensure you replace placeholders like `<tenant ID>`, `<storageaccount>`, and `<queue-name>` with actual values from your Azure and Snowflake setup.

