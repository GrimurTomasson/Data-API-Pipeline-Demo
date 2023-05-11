/*
    Vörpun þar sem við viljum hafa fulla stjórn á vörpun en samt ekki tapa gildum ef ný berast.
*/
WITH 
thekkt AS (
	SELECT id, lysing, upprunakerfi_id FROM ( VALUES 
		('ÓYFIRFARIÐ', 'Óyfirfarið', 0)
		,('YFIRFARIÐ', 'Yfirfarið', 1)
		,('ÞARF_ENDURSKOÐUN', 'Þarf endurskoðun', 2)
		,('VANTAR_HEITINÚMER', 'Vantar heitinúmer', 9)
) value_range (id, lysing, upprunakerfi_id)
), 
othekkt AS (
	SELECT 
        DISTINCT s.yfirfarid AS upprunakerfi_id
    FROM 
        {{ source('hus-og-mannvirkjastofnun', 'stadfangaskra_stg') }} s 
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


