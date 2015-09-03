/*
	generate-table-xml.sql will document the Tables, Columns and Foreign keys from a database as an Xmldocument.
*/

select 
	tableXml
from 
	(
		select 
			'<Tables>' as [tableXml],
			'0.0' as [sort_order]
	UNION ALL
		select 
			'  <Table tableId="' + cast(object_id as varchar) + '" name="' + t.name + '">"' as [tableXml],
			cast(object_id as varchar) + '.0' as [sort_order]
		from 
			sys.tables t
	UNION ALL
		select 
			'    <Column columnId="' + cast(c.column_id as varchar) + '" name="' + c.name + '"/>"' as [xml],
			cast(t.object_id as varchar) +'.' + cast(c.column_id as varchar(2)) as [sort_order]
			--* 
		from sys.tables t 
		inner join
			sys.columns c
		on t.object_id = c.object_id
		where t.type = 'U'
	UNION ALL
		select 
			'  </Table>"' as [tableXml],
			cast(object_id as varchar) + '.999' as [sort_order]
		from 
			sys.tables t
	UNION ALL
		select
			'</Tables>' as [tableXml],
			'99999999999999.999' as [sort_order]
	UNION ALL
		select	
			'    <ForeignKey name="' + fk.name 
			--+ '" tableId="' + cast(fkc.parent_object_id as varchar) 
			+ '" columnId="' + cast(fkc.parent_column_id as varchar)
			+ '" refTableId="' + CAST(fkc.referenced_object_id as varchar)
			+ '" refColumnId="' + CAST(fkc.referenced_column_id as varchar)
			+ '"/>' as [tableXml],
			cast(fkc.parent_object_id as varchar) + '.00.' + cast(fkc.parent_column_id as varchar) as [sort_order]
		from 
			sys.foreign_key_columns fkc
		inner join 
			sys.foreign_keys fk
		on 
			fk.object_id = fkc.constraint_object_id

	) qry
order by qry.sort_order
