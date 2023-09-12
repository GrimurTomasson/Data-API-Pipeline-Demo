/*
    Vörpun þar sem við viljum hafa fulla stjórn á vörpun en samt ekki tapa gildum ef ný berast.
*/
WITH 
thekkt AS (
	SELECT id, lysing, upprunakerfi_id FROM ( VALUES 
		('ÖNNUR_ÞJÓNUSTA', 'Skilgreind staðföng sem passa ekki í annan flokk', 'Önnur þjónusta')
		,('FRÆÐSLA', 'Fræðsla', 'Fræðslustarfsemi')
		,('HEILBRIGÐISÞJÓNUSTA', 'Heilbrigðisþjónusta', 'Heilbrigðisþjónusta')
		,('NEYÐARÞJÓNUSTA', 'Neyðarþjónusta', 'Neyðarþjónusta')
		,('AFÞREYING', 'Afþreying - menning, íþróttir ofl.', 'Menning, afþreying, íþróttir')
		,('INNVIÐIR', 'Innviðir - veitur, samgöngur, flutningar', 'Veitur, samgöngur, flutningar')
		,('STJÓRNSÝSLA', 'Stjórnsýsla', 'Stjórnsýsla')
		,('VERSLUN', 'Verslun', 'Verslun')
		--,('FÉLAGSJÞÓNUSTA', 'Félagsþjónusta', 'Félagsþjónusta')
) value_range (id, lysing, upprunakerfi_id)
), 
othekkt AS (
	SELECT 
        DISTINCT s.properties_yfirflokkur AS upprunakerfi_id
    FROM 
        {{ source('byggdastofnun', 'thjonustukortagogn') }} s 
    WHERE 
        s.properties_yfirflokkur NOT IN (SELECT DISTINCT upprunakerfi_id FROM thekkt)
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