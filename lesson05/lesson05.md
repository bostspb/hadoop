## Урок 5. Форматы хранения
#### 1. Создать таблицы в форматах PARQUET / ORC / AVRO c компрессией и без оной.
Заходим на ноду

    ssh student9_7@manager.novalocal

Проверяем наличие тестового датасета и его размер

    hdfs dfs -du -h -s /test_datasets/citation
    97.2 G  291.5 G  /test_datasets/citation

Затем заходим в **Hue** по адресу http://manager.novalocal:8888/ 
и смотрим схему таблицы с тестовым датасетом
    
    show create table hive_db.citation_data;
    
    1	CREATE EXTERNAL TABLE `hive_db.citation_data`(
    2	  `oci` string COMMENT 'from deserializer', 
    3	  `citing` string COMMENT 'from deserializer', 
    4	  `cited` string COMMENT 'from deserializer', 
    5	  `creation` string COMMENT 'from deserializer', 
    6	  `timespan` string COMMENT 'from deserializer', 
    7	  `journal_sc` string COMMENT 'from deserializer', 
    8	  `author_sc` string COMMENT 'from deserializer')
    9	ROW FORMAT SERDE 
    10	  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
    11	STORED AS INPUTFORMAT 
    12	  'org.apache.hadoop.mapred.TextInputFormat' 
    13	OUTPUTFORMAT 
    14	  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    15	LOCATION
    16	  'hdfs://manager.novalocal:8020/test_datasets/citation'
    17	TBLPROPERTIES (
    18	  'COLUMN_STATS_ACCURATE'='false', 
    19	  'last_modified_by'='artem', 
    20	  'last_modified_time'='1605197760', 
    21	  'numFiles'='0', 
    22	  'numRows'='-1', 
    23	  'rawDataSize'='-1', 
    24	  'skip.header.line.count'='1', 
    25	  'totalSize'='0', 
    26	  'transient_lastDdlTime'='1605197760')

Теперь, зная перечень полей в тестовой таблице,
создаем новую базу данных в интерфейсе **Hue** `lesson5_student9_7`
и таблицы под каждый формат хранения и вид компрессии со схемой как в тестовом датасете - [ddl.sql](https://github.com/bostspb/hadoop/blob/main/lesson05/ddl.sql)


#### 2. Заполнить данными из большой таблицы hive_db.citation_data
Заполняем таблицы данными с учетом компрессии - [queries.sql](https://github.com/bostspb/hadoop/blob/main/lesson05/queries.sql). <br>
При этом, чтобы применилась компрессия, пришлось для форматов **AVRO** и **PARQUET** указывать тип компрессии при наполнении таблицы, а для формата **ORC** - при создании таблицы.

#### 3. Посмотреть на получившийся размер данных
Смотрим размер файлов под получившимися таблицами:

    hdfs dfs -du -h /user/hive/warehouse/lesson5_student9_7.db
    2.6 M     7.8 M   /user/hive/warehouse/lesson5_student9_7.db/citation_avro_snapy
    7.2 M     21.6 M  /user/hive/warehouse/lesson5_student9_7.db/citation_avro_uncompressed
    1.2 M     3.5 M   /user/hive/warehouse/lesson5_student9_7.db/citation_orc_gzip
    1.9 M     5.7 M   /user/hive/warehouse/lesson5_student9_7.db/citation_orc_snapy
    5.2 M     15.7 M  /user/hive/warehouse/lesson5_student9_7.db/citation_orc_uncompressed
    1006.1 K  2.9 M   /user/hive/warehouse/lesson5_student9_7.db/citation_parquet_gzip
    1.6 M     4.8 M   /user/hive/warehouse/lesson5_student9_7.db/citation_parquet_snapy
    5.0 M     15.1 M  /user/hive/warehouse/lesson5_student9_7.db/citation_parquet_uncompressed

Также опробовал следующие утилиты для детализации информации по файлам данных каждого формата хранения:

    parquet-tools meta hdfs://manager.novalocal:8020/user/hive/warehouse/lesson5_student9_7.db/citation_parquet_gzip/000000_0
    
    avro-tools getschema hdfs://manager.novalocal:8020/user/hive/warehouse/lesson5_student9_7.db/citation_avro_snapy/000000_0
    avro-tools getmeta hdfs://manager.novalocal:8020/user/hive/warehouse/lesson5_student9_7.db/citation_avro_snapy/000000_0
    
    hive --orcfiledump /user/hive/warehouse/lesson5_student9_7.db/citation_orc_snapy/000000_0

#### 4. Посчитать count некоторых колонок в разных форматах хранения.
Выполняем на каждой таблице запрос `SELECT count(oci)` - [queries.sql](https://github.com/bostspb/hadoop/blob/main/lesson05/queries.sql).


#### 5. Посчитать агрегаты по одной и нескольким колонкам в разных форматах.
Выполняем на каждой таблице запрос `SELECT max(oci)` - [queries.sql](https://github.com/bostspb/hadoop/blob/main/lesson05/queries.sql).

#### 6. Сделать выводы об эффективности хранения и компресии.
* По размеру данных наилучшие результаты показал формат хранения  **PARQUET**.
* Максимальная компрессия достигалась при сжатии методом **GZIP**.
* По скорости наполнения таблиц и скорости выполнения агрегирующих запросов различия между форматами хранения и методами сжатия разницы не увидел.
