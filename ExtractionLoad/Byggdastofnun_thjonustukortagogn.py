import requests
from flatten_json import flatten
import pyodbc
from datetime import datetime

# Simplified EL with all values inside
request = "https://thjonustukort.is/geoserver/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=byggdast:v_nidurhal&SRSNAME=EPSG:3057&OutputFormat=JSON"
db_connection_string = "DRIVER={ODBC Driver 18 for SQL Server};SERVER=localhost;DATABASE=Analytical-Demo-API-Private;Trusted_Connection=yes;Encrypt=no;"
query = "INSERT INTO byggdastofnun.thjonustukortagogn_stg (type, id, properties_id, properties_heinum, properties_yfirflokkur, properties_flokkur, properties_rekstraradili, properties_heimilisfang, properties_postnr, properties_sveitarfelag, properties_veffang, properties_uppruni, properties_lng, properties_lat, sott) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

conn = pyodbc.connect (db_connection_string)
response = requests.get(request)

features = response.json()["features"]
today = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

cursor = conn.cursor()
for feature in features:
	flat_feature = flatten (feature) 
	flat_feature["load_date"] = today
	#print (flat_feature)
	cursor.execute (query, flat_feature["type"], flat_feature["id"], flat_feature["properties_id"], flat_feature["properties_heinum"], flat_feature["properties_yfirflokkur"], flat_feature["properties_flokkur"], flat_feature["properties_rekstraradili"], flat_feature["properties_heimilisfang"], flat_feature["properties_postnr"], flat_feature["properties_sveitarfelag"], flat_feature["properties_veffang"], flat_feature["properties_uppruni"], flat_feature["properties_lng"], flat_feature["properties_lat"], flat_feature["load_date"])
  
conn.commit()
