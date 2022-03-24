# LISTAR OBJETOS ENTRE BLOCOS
#
select  tablespace_name, segment_type, owner, segment_name, block_id
FROM dba_extents
where file_id=93
and block_id between 3720000 and 3920153
order by segment_name
/


# ENCONTRAR OS OBJETOS QUE ESTAO COM BLOCOS CORROMPIDOS

SELECT e.owner, e.segment_type, e.segment_name, e.partition_name, c.file#
, greatest(e.block_id, c.block#) corr_start_block#
, least(e.block_id+e.blocks-1, c.block#+c.blocks-1) corr_end_block#
, least(e.block_id+e.blocks-1, c.block#+c.blocks-1)
- greatest(e.block_id, c.block#) + 1 blocks_corrupted
, null description
FROM dba_extents e, v$database_block_corruption c
WHERE e.file_id = c.file#
AND e.block_id <= c.block# + c.blocks - 1
AND e.block_id + e.blocks - 1 >= c.block#
UNION
SELECT s.owner, s.segment_type, s.segment_name, s.partition_name, c.file#
, header_block corr_start_block#
, header_block corr_end_block#
, 1 blocks_corrupted
, 'Segment Header' description
FROM dba_segments s, v$database_block_corruption c
WHERE s.header_file = c.file#
AND s.header_block between c.block# and c.block# + c.blocks - 1
UNION
SELECT null owner, null segment_type, null segment_name, null partition_name, c.file#
, greatest(f.block_id, c.block#) corr_start_block#
, least(f.block_id+f.blocks-1, c.block#+c.blocks-1) corr_end_block#
, least(f.block_id+f.blocks-1, c.block#+c.blocks-1)
- greatest(f.block_id, c.block#) + 1 blocks_corrupted
, 'Free Block' description
FROM dba_free_space f, v$database_block_corruption c
WHERE f.file_id = c.file#
AND f.block_id <= c.block# + c.blocks - 1
AND f.block_id + f.blocks - 1 >= c.block#
order by file#, corr_start_block#;



# ENCONTRAR BLOCO CORROMPIDO

SELECT owner, segment_name, segment_type, partition_name 
FROM dba_segments
WHERE header_file = &AFN
and header_block = &BL
/



# Select Blocos corrompidos

select * from v$database_block_corruption
/


# DUMP FILE
ALTER SYSTEM DUMP DATAFILE '&FILENAME'   BLOCK &BL           ;
 
 