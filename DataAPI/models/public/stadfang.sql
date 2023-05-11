SELECT
	t.stadfang_yfirflokkur_id
	,t.stadfang_flokkur_id
	,t.hvad
	,s.postnumer_id
	,s.sveitarfelag_numer
	,s.heiti_nefnifall
	,s.heiti_thagufall
	,s.husnumer
	,s.husnumer_fra
	,s.husnumer_til
	,s.husnumer_vidskeyti
	,s.serheiti
	,t.veffang
	,s.heitinumer
	,s.stadfang_hnit_tegund_id
	,s.stadfang_hnit_stada_id
	,s.hnit
	,s.WGS84_breiddargrada
	,s.WGS84_lengdargrada
	,s.sidast_snert
	,s.upprunakerfi_id
	,s.sott
FROM
	{{ ref('stadfangaskra_int') }} s
	LEFT JOIN {{ ref('thjonustukortagogn_int') }} t ON t.heitinumer = s.heitinumer