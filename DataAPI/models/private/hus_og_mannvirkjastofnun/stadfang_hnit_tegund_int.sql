/*
    Vörpun þar sem við viljum hafa fulla stjórn á vörpun en samt ekki tapa gildum ef ný berast.
*/
WITH 
thekkt AS (
	SELECT id, lysing, upprunakerfi_id FROM ( VALUES 
		('EFTIR_AÐ_YFIRFARA_TEGUND_HNITS', 'Eftir að yfirfara tegund hnits', 0)
		,('ÁÆTLAÐUR_MIÐPUNKTUR_MANNVIRKIS', 'Áætlaður miðpunktur mannvirkis', 1)
		,('STAÐSETNING_MEGIN_INNGANGS_Í_MANNVIRKI', 'Staðsetning megin inngangs í mannvirki', 2)
		,('HNITPUNKTUR_STAÐSETTUR_Á_INNKEYRSLU_LÓÐAR', 'Hnitpunktur staðsettur á innkeyrslu lóðar', 3)
		,('HNITPUNKTUR_STAÐSETTUR_MEÐ_VISSU_INNAN_LÓÐAMARKA', 'Hnitpunktur staðsettur með vissu innan lóðamarka', 4)
		,('HNITPUNKTUR_STAÐSETTUR_INNAN_ÁÆTLAÐS_BYGGINGARREITS', 'Hnitpunktur staðsettur innan áætlaðs byggingarreits', 5)
) value_range (id, lysing, upprunakerfi_id)
), 
othekkt AS (
	SELECT 
        DISTINCT s.yfirfarid AS upprunakerfi_id
    FROM 
        --{{ source('hus-og-mannvirkjastofnun', 'stadfangaskra_stg') }} s 
		hus_og_mannvirkjastofnun.stadfangaskra_stg s
    WHERE 
        s.yfirfarid NOT IN (SELECT DISTINCT upprunakerfi_id FROM thekkt)
),
allt AS (
	SELECT * FROM thekkt
	UNION ALL
	SELECT 'ÓÞEKKT_' + CAST (NEWID() AS nvarchar(64)), 'Óþekkt gildi í frumgögnum' , s.upprunakerfi_id FROM othekkt s
)
SELECT 
	CAST (dapi.ConstructIdOne (s.id) AS nvarchar(250)) AS id
	,CAST (s.lysing AS nvarchar(250)) AS lysing
	,s.upprunakerfi_id
FROM
	allt s


