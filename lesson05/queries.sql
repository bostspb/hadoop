----------
-- AVRO
----------
SET hive.exec.compress.output=false;
insert into lesson5_student9_7.citation_avro_uncompressed
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- Time taken: 436.023 seconds
-- [numFiles=1, numRows=50000, totalSize=7552544, rawDataSize=0]


-- SET hive.exec.compress.output=true;
-- SET avro.output.codec=snappy;
-- эти параметры не сработали
SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
SET mapred.output.compression.type=BLOCK;
insert into lesson5_student9_7.citation_avro_snapy
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- Time taken: 1069.603 seconds
-- [numFiles=1, numRows=50000, totalSize=2729769, rawDataSize=0]


------------
-- PARQUET
------------
insert into lesson5_student9_7.citation_parquet_uncompressed
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- [numFiles=1, numRows=50000, totalSize=5272765, rawDataSize=350000]
-- Time taken: 452.728 seconds

SET parquet.compression=GZIP;
insert into lesson5_student9_7.citation_parquet_gzip
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- Time taken: 420.778 seconds
-- [numFiles=1, numRows=50000, totalSize=1030262, rawDataSize=350000]


SET parquet.compression=SNAPPY;
insert into lesson5_student9_7.citation_parquet_snapy
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;

-- [numFiles=1, numRows=50000, totalSize=1682951, rawDataSize=350000]
-- Time taken: 451.102 seconds


----------
-- ORC
----------
insert into lesson5_student9_7.citation_orc_uncompressed
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- [numFiles=1, numRows=50000, totalSize=5473510, rawDataSize=36200000]
-- Time taken: 401.285 seconds

insert into lesson5_student9_7.citation_orc_gzip
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- [numFiles=1, numRows=50000, totalSize=1217278, rawDataSize=36100000]
-- Time taken: 451.093 seconds

insert into lesson5_student9_7.citation_orc_snapy
    select oci, citing, cited, creation, timespan, journal_sc, author_sc
    from hive_db.citation_data
    limit 50000;
-- [numFiles=1, numRows=50000, totalSize=2008038, rawDataSize=36200000]
-- Time taken: 409.479 seconds


---------------
-- count(oci)
---------------
SELECT count(oci) FROM lesson5_student9_7.citation_avro_snapy;
-- Time taken: 27.504 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_avro_uncompressed;
-- Time taken: 23.303 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_orc_gzip;
-- Time taken: 23.227 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_orc_snapy;
-- Time taken: 23.754 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_orc_uncompressed;
-- Time taken: 26.102 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_parquet_gzip;
-- Time taken: 20.105 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_parquet_snapy;
-- Time taken: 23.185 seconds

SELECT count(oci) FROM lesson5_student9_7.citation_parquet_uncompressed;
-- Time taken: 22.01 seconds

---------------
-- max(oci)
---------------
SELECT max(oci) FROM lesson5_student9_7.citation_avro_snapy;
-- Time taken: 21.755 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_avro_uncompressed;
-- Time taken: 29.178 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_orc_gzip;
-- Time taken: 20.16 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_orc_snapy;
-- Time taken: 26.684 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_orc_uncompressed;
-- Time taken: 22.621 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_parquet_gzip;
-- Time taken: 24.785 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_parquet_snapy;
-- Time taken: 24.785 seconds

SELECT max(oci) FROM lesson5_student9_7.citation_parquet_uncompressed;
-- Time taken: 21.617 seconds
