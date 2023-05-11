CREATE TABLE byggdastofnun.thjonustukortagogn_stg (
	type nvarchar(250) not null,
	id nvarchar(250) not null,
	properties_id int,
	properties_heinum int,
	properties_yfirflokkur nvarchar(250) not null,
	properties_flokkur nvarchar(250) not null,
	properties_rekstraradili nvarchar(250),
	properties_heimilisfang nvarchar(250),
	properties_postnr int,
	properties_sveitarfelag nvarchar(250),
	properties_veffang nvarchar(250),
	properties_uppruni nvarchar(250),
	properties_lng nvarchar(250),
	properties_lat nvarchar(250),
	sott datetime not null
)
