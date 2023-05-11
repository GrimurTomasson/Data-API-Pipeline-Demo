/*
    Einföld týpu og nafnavörpun
*/
SELECT DISTINCT 
	CAST (dapi.ConstructIdOne (s.properties_flokkur) AS nvarchar(250)) AS id
	,CAST (s.properties_flokkur AS nvarchar(250)) AS lysing
	,s.properties_flokkur AS upprunakerfi_id 
FROM 
	{{ source('byggdastofnun','thjonustukortagogn_stg') }} s