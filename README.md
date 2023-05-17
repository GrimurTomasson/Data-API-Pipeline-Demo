# Data-API-Pipeline-Demo
Data API demo.

## Micro Instructions
Clone the repo 
### Install DAPI
- https://github.com/GrimurTomasson/Data-API-Pipeline
	
### Install the following Python packages for EL (Extraction & Load)
- pip install requests
- pip install flatten_json
	
### Setup Evolve, and add an OS path
- https://github.com/lecaillon/Evolve/releases/tag/3.1.0

### Install SQL Server
- https://www.microsoft.com/en-us/sql-server/sql-server-downloads
	- Pick the *Developer* version 	

### Update the following database config in api_config.yml to values to SQL Server you have db_owner or higher privledges on
- `database->server`
- `database->name`
- `database->port` (1433 if you are using the default)
	
### Running the demo
Perform the following either on a *command prompt* or in a *PowerShell* console.  

#### Create two SQL Server databases
 If the following databases are local you don't need to change any configs, otherwise search for `localhost`.  
- `Analytical-Demo-API`
- `Analytical-Demo-API-Private`

#### Migrate the staging tables and logic
- `database migrate`
	
#### EL
In folder `ExtractionLoad`	
- `python Byggdastofnun_thjonustukortagogn.py`
- `python Hus_og_mannvirkjastofnun_stadfangaskra.py`
		
#### Run the pipeline
- `dapi build`

#### Examine the results
- Check what tables were generated in both databases.
- Check out the files in 
    - `API-Pipeline_last_run/`
    - `DataAPI/target/`
