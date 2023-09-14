# Inngangur
Hlutverk þessa kóðasafns er að vera gott sýnidæmi um uppbyggingu gagnaviðmóta (e:data API).

Þetta skjal er búið til vélrænt, allar handvirkar breytingar munu tapast.

# API Vensl
Venslin í þessu viðmóti skiptast í tvo flokka, nústöðu og söguleg gögn. Nústöðu gögnin eru öll í samnefndu skema, **nustada**. Athugið að nústaða gagna er nýjasta staða sem við eigum, það er ekki gefið að þetta séu rauntímagögn. Söguleg gögn innihalda gagnasögu og eru í skema sem heitir **saga**. Athugið að sagan er uppfærð daglega, ef gögnin breytast oftar en það koma þær breytingar ekki hér inn. Þetta er gagnasaga til almennrar greiningar, ekki auditing eða breytingasaga.

{% for rel in relations -%}
## {{ rel.schema_name }}.{{ rel.relation_name }}

| Dálkur        | Lýsing        | Týpa          | Lengd         | Uppruni lýsingar |
| :------------ | :------------ | :------------ | :------------ | :------------    |
{% for col in rel.columns -%}
    {%- if col.description.missing == True -%}
| {{ col.name }} | **Skjölun vantar!** | {{ col.type.name }} | {{ col.type.length }} |  |
    {%- else -%}
| {{ col.name }} | {{ col.description.text }} | {{ col.type.name }} | {{ col.type.length }} | {{ col.description.origin }} |
    {%- endif %}
{% endfor %}
{% endfor %}