----------
-- AVRO
----------

create table lesson5_student9_7.citation_avro_uncompressed (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as avro;

create table lesson5_student9_7.citation_avro_snapy (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as avro;

------------
-- PARQUET
------------
create table lesson5_student9_7.citation_parquet_uncompressed (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as parquet;

create table lesson5_student9_7.citation_parquet_gzip (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as parquet;

create table lesson5_student9_7.citation_parquet_snapy (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as parquet;

----------
-- ORC
----------
create table lesson5_student9_7.citation_orc_uncompressed (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as orc tblproperties ("orc.compress"="NONE");

create table lesson5_student9_7.citation_orc_gzip (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as orc tblproperties ("orc.compress"="ZLIB");

create table lesson5_student9_7.citation_orc_snapy (
    oci string,
    citing string,
    cited string,
    creation string,
    timespan string,
    journal_sc string,
    author_sc string
) stored as orc tblproperties ("orc.compress"="SNAPPY");

