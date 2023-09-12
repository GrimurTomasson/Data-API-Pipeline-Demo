SELECT DISTINCT -- Fjölfaldanir út af sorphirðuhverfamörkum sem hafa sniðmengi.
	CAST (s.HEINUM AS INT) AS heitinumer
	,CAST(s.postnr AS nvarchar(3)) COLLATE DATABASE_DEFAULT AS postnumer_id
    ,CAST (RIGHT ('000' + CAST (s.svfnr AS nvarchar(4)), 4) AS nvarchar(4)) AS sveitarfelag_numer
	,CAST (s.byggd AS int) AS sveitarfelag_byggd
	,CAST (s.heiti_nf AS nvarchar(250)) AS heiti_nefnifall
	,CAST (COALESCE (s.heiti_tgf, '') AS nvarchar(250)) AS heiti_thagufall
	,COALESCE (CAST (s.husnr AS nvarchar(250)), '') AS husnumer
	,dapi_specific.SplitHousenumber (s.husnr, 'FROM') AS husnumer_fra
	,dapi_specific.SplitHousenumber (s.husnr, '') AS husnumer_til	
	,CAST (COALESCE (s.bokst, '') AS nvarchar(250)) AS husnumer_vidskeyti
	,CAST (COALESCE (s.vidsk, '') AS nvarchar(250)) AS vidskeyti
	,CAST (COALESCE (s.serheiti, '') AS nvarchar(250)) AS serheiti
	,ht.id AS stadfang_hnit_tegund_id
	,hs.id AS stadfang_hnit_stada_id
	,s.hnit AS hnit
	,CAST (s.n_hnit_wgs84 AS decimal(10,8)) AS WGS84_breiddargrada
	,CAST (s.e_hnit_wgs84 AS decimal(10,8)) AS WGS84_lengdargrada
	,CAST (COALESCE (s.dags_leidr, '1900-01-01') AS datetime) AS sidast_snert
	,CAST (s.hnitnum AS nvarchar(250)) AS upprunakerfi_id
	,s.sott
FROM 
    {{ source('hus-og-mannvirkjastofnun', 'stadfangaskra') }} s
	JOIN {{ ref('stadfang_hnit_tegund_int') }} ht ON ht.upprunakerfi_id = s.teghnit
	JOIN {{ ref('stadfang_hnit_stada_int') }} hs ON hs.upprunakerfi_id = s.yfirfarid
WHERE
	-- If the following becomes a pattern, we can package it as a macro
	s.{{ var("staging-dagsetningar-dalkur") }} = ( SELECT MAX({{ var("staging-dagsetningar-dalkur") }}) FROM {{ source('hus-og-mannvirkjastofnun', 'stadfangaskra') }} )