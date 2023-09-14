# Data-API-Pipeline-Demo
Data API demo.

## Prerequisites
- git
- .net 7+
- [SQL Server](###sql-server)
- [Python 3.11.x](###python)
- [Evolve](###evolve)  

## TLDR
In an **admin** mode *PowerShell*.
- `cd c:/temp`
- `git clone https://github.com/GrimurTomasson/Data-API-Pipeline-Demo.git`
- `cd Data-API-Pipeline-Demo`
- `c:\"Program files"\python311\python.exe -m venv .venv`
- `.\.venv\Scripts\Activate.ps1`
- `pip install requests`
- `pip install flatten_json`
- `pip install -U git+https://github.com/GrimurTomasson/Data-API-Pipeline@r1.6`
- Create two *SQL Server* databases in a *localhost* server named:
	- Dapi-Demo-API
	- Dapi-Demo-API-Private
- `./run_pipeline.ps1`

## Micro Instructions - Step by step  
Clone the repo 
### Install DAPI
- https://github.com/GrimurTomasson/Data-API-Pipeline
	
### Install the following Python packages for EL (Extraction & Load)
- `pip install requests`
- `pip install flatten_json`
	
### Setup Evolve, and add an OS path
- https://github.com/lecaillon/Evolve/releases/tag/3.1.0

#### Create two SQL Server databases
 As an alternative, you can change en environment variables in the next step.
- `Dapi-Demo-API`
- `Dapi-Demo-API-Private`

### Update the `dapi.env` variables
Odds are you only need to edit the following variables. You only need to edit the latter two if you did not create the databases suggested.
- `DAPI_DATABASE_SERVER`
- `DAPI_DATABASE_INSTANCE`
- `DAPI_PRIVATE_DATABASE_INSTANCE` (1433 if you are using the default)
	
### Running the demo
Perform the following either on a *command prompt* or in a *PowerShell* console.  

#### Set the *Python* virtual environment
Set the virtual environment you created for *dapi*, if it is not set already. See the *dapi* [instructions](https://github.com/GrimurTomasson/Data-API-Pipeline#setup).

#### Set the environment variables
Run the following in *PowerShell*
- `load_env.ps1`

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

## Uppsetning hugbúnaðar
Shorthand instructions, for developers.

### SQL Server
https://www.microsoft.com/en-us/sql-server/sql-server-downloads
- Pick the *Developer* version 	
- Basic
- Install SSMS
- Restart

### Python
In **admin** mode *PowerShell*. Note, execution policy in *PowerShell* may need to be changed.
`[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12`
`Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe" -OutFile "c:/temp/python-3.11.5.exe"`
`c:/temp/python-3.11.5.exe /quiet InstallAllUsers=0 InstallLauncherAllUsers=0 PrependPath=1 Include_test=0`

### Evolve
in *PowerShell*.
`dotnet tool install --global Evolve.Tool`