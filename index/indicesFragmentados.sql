SELECT sys.objects.NAME                                     AS [Table Name], 
       sys.indexes.NAME                                     AS [Index Name], 
       partition_number                                     AS [Partition], 
       Cast(avg_fragmentation_in_percent AS DECIMAL (4, 2)) AS 
       [Fragmentation Percentage], 
       CONVERT(DECIMAL(18, 2), page_count * 8 / 1024.0)     AS 
       [Total Index Size (MB)], 
       page_count                                           AS [Page Count] 
FROM   sys.Dm_db_index_physical_stats (Db_id(), NULL, NULL, NULL, 'LIMITED') 
       IndexStats 
       INNER JOIN sys.objects 
               ON sys.objects.object_id = IndexStats.object_id 
       INNER JOIN sys.indexes 
               ON sys.indexes.object_id = sys.objects.object_id 
                  AND IndexStats.index_id = sys.indexes.index_id 
WHERE  avg_fragmentation_in_percent > 25 
       AND indexes.index_id > 0 
       AND page_count > 50 