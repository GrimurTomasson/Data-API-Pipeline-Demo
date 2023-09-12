/*
    Athugið að þetta er hlutmengi dálka, intermediate módel þurfa ekki að innihalda alla dálka.
*/
SELECT
	s.sott
	,CAST (s.properties_id AS int) AS id
	,syf.id AS stadfang_yfirflokkur_id
	,sf.id AS stadfang_flokkur_id
	,CAST (COALESCE (s.properties_rekstraradili, '') AS nvarchar(250)) AS hvad
	,CAST (s.properties_heinum AS INT) AS heitinumer -- Lykill í staðfangaskrá HMS
	,CAST (s.properties_veffang AS nvarchar(500)) AS veffang
	,CAST (s.properties_lat AS decimal(6,4)) AS hnit_nordlaeg_breidd
	,CAST (s.properties_lng AS decimal(6,4)) AS hnit_vestlaeg_lengd
	,CAST (s.properties_uppruni AS nvarchar(250)) AS uppruni
FROM
	{{ source('byggdastofnun', 'thjonustukortagogn') }} s
    -- Eingöngu tegundatöflu join!
	JOIN {{ ref('stadfang_yfirflokkur_int') }} syf ON syf.upprunakerfi_id = s.properties_yfirflokkur 
	JOIN {{ ref('stadfang_flokkur_int') }} sf ON sf.upprunakerfi_id = s.properties_flokkur
WHERE 
    s.properties_heinum IS NOT NULL -- Þessi gögn eru gagnlaus ef við getum ekki lyklað þau við staðföng
	AND s.{{ var("staging-dagsetningar-dalkur") }} = ( SELECT MAX({{ var("staging-dagsetningar-dalkur") }}) FROM {{ source('byggdastofnun', 'thjonustukortagogn') }} )