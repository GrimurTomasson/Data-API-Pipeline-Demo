import os
import csv
import requests
import pyodbc
from datetime import datetime

# DRY violation, should be in a util collection
def getEnvValue (variableName, defaultValue):
	if os.environ.get(variableName) is not None and len (os.environ.get(variableName)) > 0:
		return os.environ.get(variableName)
	return defaultValue

# Simplified EL with all values inside
request = "https://fasteignaskra.is/Stadfangaskra.csv"

db_server = getEnvValue ("DAPI_DATABASE_SERVER", "localhost")
db_instance = getEnvValue ("DAPI_PRIVATE_DATABASE_INSTANCE", "Dapi-Demo-API-Private")
db_connection_string = "DRIVER={ODBC Driver 18 for SQL Server};SERVER=" + db_server + ";DATABASE=" + db_instance + ";Trusted_Connection=yes;Encrypt=no;"

# SELECT STRING_AGG (COLUMN_NAME, ',') AS dalkar FROM INFORMATION_SCHEMA.COLUMNS where TABLE_CATALOG = 'Analytical-Demo-API-Private' AND TABLE_SCHEMA = 'hus_og_mannvirkjastofnun' AND TABLE_NAME = 'stadfangaskra_stg'
query = "INSERT INTO hus_og_mannvirkjastofnun_staging.stadfangaskra (FID,HNITNUM,SVFNR,BYGGD,LANDNR,HEINUM,MATSNR,POSTNR,HEITI_NF,HEITI_TGF,HUSNR,BOKST,VIDSK,SERHEITI,DAGS_INN,DAGS_LEIDR,GAGNA_EIGN,TEGHNIT,YFIRFARID,YFIRF_HEITI,ATH,NAKV_XY,HNIT,N_HNIT_WGS84,E_HNIT_WGS84,NOTNR,LM_HEIMILISFANG,VEF_BIRTING,HUSMERKING,sott) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

conn = pyodbc.connect (db_connection_string)
conn.autocommit = False

response = requests.get(request)
if len(response.content) > 0: # Unreliable service
    decoded_response = response.content.decode('utf-8')
else:
    print ("Received empty response from HMS!\n")
    with open ('Stadfangaskra_10_5_2023.csv', mode='r', encoding='utf-8') as backup_file:
        decoded_response = backup_file.read()

rows = list(csv.reader(decoded_response.splitlines(), delimiter=','))
rows = rows[1:] # Get rid of the header

print (f"Number of rows: {len (rows)}")

today = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
[x.append(today) for x in rows]

rowCount = 0
cursor = conn.cursor()
cursor.fast_executemany = True

stadfong = []
for row in rows:
    row = [x if len(x) > 0 else None for x in row] # Null errors in executemany, does not cause errors in execute!
    stadfong.append ( row )    
    rowCount += 1
    
    if rowCount % 10000 == 0:
        cursor.executemany (query, stadfong)
        conn.commit ()
        stadfong.clear ()
        print (f"Commit - rows: {rowCount}")

if len (stadfong) > 0:
    cursor.executemany (query, stadfong)
    conn.commit()
    print (f"Commit - rows: {rowCount}")

print ("All done!")

