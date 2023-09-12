import requests
import os
from flatten_json import flatten
import pyodbc
from datetime import datetime

def getEnvValue (variableName, defaultValue):
	if os.environ.get(variableName) is not None and len (os.environ.get(variableName)) > 0:
		return os.environ.get(variableName)
	return defaultValue

# Simplified EL with all values inside
request = "https://thjonustukort.is/geoserver/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=byggdast:v_nidurhal&SRSNAME=EPSG:3057&OutputFormat=JSON"

db_server = getEnvValue ("DAPI_DATABASE_SERVER", "localhost")
db_instance = getEnvValue ("DAPI_PRIVATE_DATABASE_INSTANCE", "Dapi-Demo-API-Private")
db_connection_string = "DRIVER={ODBC Driver 18 for SQL Server};SERVER=" + db_server + ";DATABASE=" + db_instance + ";Trusted_Connection=yes;Encrypt=no;"

query = "INSERT INTO byggdastofnun_staging.thjonustukortagogn (type, id, properties_id, properties_heinum, properties_yfirflokkur, properties_flokkur, properties_rekstraradili, properties_heimilisfang, properties_postnr, properties_sveitarfelag, properties_veffang, properties_uppruni, properties_lng, properties_lat, sott) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

conn = pyodbc.connect (db_connection_string)
conn.autocommit = False

response = requests.get(request)

features = response.json()["features"]
today = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

all_features = []
for feature in features:
	flat_feature = flatten (feature) 
	all_features.append ( (flat_feature["type"], flat_feature["id"], flat_feature["properties_id"], flat_feature["properties_heinum"], flat_feature["properties_yfirflokkur"], flat_feature["properties_flokkur"], flat_feature["properties_rekstraradili"], flat_feature["properties_heimilisfang"], flat_feature["properties_postnr"], flat_feature["properties_sveitarfelag"], flat_feature["properties_veffang"], flat_feature["properties_uppruni"], flat_feature["properties_lng"], flat_feature["properties_lat"], today))

cursor = conn.cursor()	
cursor.fast_executemany = True

cursor.executemany (query, all_features)  
conn.commit()

