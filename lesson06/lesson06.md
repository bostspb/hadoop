## Урок 6. Загрузка данных. SQOOP. Flume.
https://sqoop.apache.org/docs/1.4.6/SqoopUserGuide.html <br>
https://flume.apache.org/FlumeUserGuide.html <br>
https://docs.cloudera.com/documentation/enterprise/5-14-x/topics/cdh_ig_flume_supported_sources_sinks_channels.html

#### 1. Создать отдельную БД в Hive
Идем в Hive по адресу http://manager.novalocal:8888/ и создаем базу данных `lesson6_student9_7`

#### 2. Посмотреть при помощи SQOOP содержимое БД в PostgreSQL (список таблиц)
Заходим на ноду

    ssh student9_7@manager.novalocal
    
Смотрим какие таблицы есть в базе `pg_db`

    sqoop list-tables --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass 
    ...
    character
    character_work
    paragraph
    sales_large
    wordform
    work
    chapter

#### 3. Импортировать в нее три любые таблицы из базы `pg_db` в PostgreSQL используя SQOOP. 
_Для каждой таблице используйте отдельный формат хранения -- **ORC** / **Parquet** / **AVRO** <br>
Рекомендую захватить таблицу `sales_large` - там порядка 10 миллионов записей, она будет достаточно репрезентативна для проверки компрессии._

Импортируем таблицу `character` в формате **Parquet** с компрессией по-умолчанию (GZIP)

    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table character --hive-import --hive-database lesson6_student9_7 --hive-table character --as-parquetfile -z
    ...
    20/12/04 04:16:54 INFO mapreduce.ImportJobBase: Transferred 83.1719 KB in 83.7511 seconds (1,016.9177 bytes/sec)
    20/12/04 04:16:54 INFO mapreduce.ImportJobBase: Retrieved 1954 records.

Пробуем импортировать таблицу `sales_large` в формате **AVRO** с компрессией по-умолчанию (GZIP) - не получается  

    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table sales_large --hive-import --hive-database lesson6_student9_7 --hive-table sales_large --as-avrodatafile -z
    ...
    Hive import is not compatible with importing into AVRO format.

Пробуем импортировать таблицу `sales_large` в формате **SequenceFile** с компрессией по-умолчанию (GZIP) - не получается   
    
    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table sales_large --hive-import --hive-database lesson6_student9_7 --hive-table sales_large --as-sequencefile -z
    ...
    Hive import is not compatible with importing into SequenceFile format.

Импортируем таблицу `paragraph` в формате обычного текстового файла с компрессией по-умолчанию (GZIP)     
    
    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table paragraph --hive-import --hive-database lesson6_student9_7 --hive-table paragraph --as-textfile -z
    ...
    Time taken: 10.481 seconds
    Loading data to table lesson6_student9_7.paragraph
    Table lesson6_student9_7.paragraph stats: [numFiles=4, totalSize=5255643]

Пробуем импортировать таблицу `sales_large` в формате **Parquet** с компрессией по-умолчанию (GZIP) - не получается   

    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table sales_large --hive-import --hive-database lesson6_student9_7 --hive-table sales_large --as-parquetfile -z
    ...
    20/12/04 04:47:40 ERROR tool.ImportTool: Import failed: No primary key could be found for table sales_large.
    
Импортируем таблицу `wordform` в формате **Parquet** с компрессией по-умолчанию (GZIP)     
    
    sqoop import --connect jdbc:postgresql://89.208.222.201:5432/pg_db --username exporter --password exporter_pass --table wordform --hive-import --hive-database lesson6_student9_7 --hive-table wordform --as-parquetfile -z
    ...
    20/12/04 04:53:59 INFO mapreduce.ImportJobBase: Transferred 726.126 KB in 91.7488 seconds (7.9143 KB/sec)
    20/12/04 04:53:59 INFO mapreduce.ImportJobBase: Retrieved 28830 records.

В итоге получилось перелить таблицы `character` в формате **Parquet**, `paragraph` в формате обычного текстового файла и `wordform` в формате **Parquet**. Везде указывали произвести сжатие GZIP.<br>


#### 4. Найдите папки на файловой системе куда были сохранены данные. Посмотрите их размер.
Посмотрим как легли файлы таблиц в HDFS

    hdfs dfs -du -h /user/hive/warehouse/lesson6_student9_7.db
    70.8 K   212.4 K  /user/hive/warehouse/lesson6_student9_7.db/character
    5.0 M    15.0 M   /user/hive/warehouse/lesson6_student9_7.db/paragraph
    719.1 K  2.1 M    /user/hive/warehouse/lesson6_student9_7.db/wordform

#### 5. Сделайте несколько произвольных запросов к этим таблицам.
Попробуем сделать несколько запросов к таблицам прямо из консоли:

    hive -e 'SELECT * FROM lesson6_student9_7.character LIMIT 10'
    
    1apparition-mac First Apparition        First Apparition        NULL    1
    1citizen        First Citizen   First Citizen   NULL    3
    1conspirator    First Conspirator       First Conspirator       NULL    3
    1gentleman-oth  First Gentleman First Gentleman NULL    1
    1goth   First Goth      First Goth      NULL    4
    1murderer       First Murderer  First Murderer  NULL    21
    1musician-oth   First Musician  First Musician  NULL    5
    1musician-rj    First Musician  First Musician  NULL    10
    1officer-oth    First Officer   First Officer   NULL    3
    1player-ham     First Player    1Play   NULL    8
    Time taken: 3.109 seconds, Fetched: 10 row(s)
    

    hive -e 'SELECT * FROM lesson6_student9_7.paragraph LIMIT 10'
    
    12night 630863  3       xxx     [Enter DUKE ORSINO, CURIO, and other Lords; Musicians attending]        NULL    NULL    NULL    NULL    NULL    NULL    NULL
            NULL    NULL    b       1       1       65      9       NULL    NULL    NULL    NULL
    12night 630864  4       ORSINO  If music be the food of love, play on;  NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]Give me excess of it, that, surfeiting,      NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]The appetite may sicken, and so die. NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]That strain again! it had a dying fall:      NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]O, it came o'er my ear like the sweet sound, NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]That breathes upon a bank of violets,        NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]Stealing and giving odour! Enough; no more:  NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    [p]'Tis not so sweet now as it was before.      NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL    NULL
    Time taken: 3.33 seconds, Fetched: 10 row(s)



    hive -e 'SELECT * FROM lesson6_student9_7.wordform LIMIT 10'
    
    610708  pardonner       PRTNR   pardonn 2
    610709  embolden'd      EMLTNT  emboldend       2
    610710  muscovites      MSKFTS  muscovit        2
    610711  cudgels KJLS    cudgel  2
    610712  diminish        TMNX    diminish        2
    610713  surviving       SRFFNK  surviv  2
    610714  tuscan  TSKN    tuscan  2
    610715  mornings        MRNNKS  morn    2
    610716  quaked  KKT     quak    2
    610717  quakes  KKS     quak    2
    Time taken: 6.122 seconds, Fetched: 10 row(s)


    
Видим, что нормально загрузились только таблицы  `character` и `wordform`. 
Сделаем агрегирующий запрос к `wordform`, но перед этим нужно узнать названия полей таблицы.

    hive -e 'describe lesson6_student9_7.wordform'
    
    wordformid              int
    plaintext               string
    phonetictext            string
    stemtext                string
    occurences              int
    Time taken: 4.08 seconds, Fetched: 5 row(s)


    hive -e 'SELECT phonetictext, count(phonetictext) as cnt, sum(occurences) as occurences_sum FROM lesson6_student9_7.wordform GROUP BY phonetictext ORDER BY cnt DESC, occurences_sum DESC LIMIT 10' 
    
    FL      43      3098
    FLT     41      807
    KLT     40      2008
    KT      37      4612
    FLS     37      843
    MT      36      2013
    KRT     36      1572
    BT      35      8459
    TRS     35      636
    TT      34      3409
    Time taken: 57.583 seconds, Fetched: 10 row(s)


#### 6. Flume: Придумать свой скрипт, который генерит выходные данные
Делаем скрипт генерации логов [log_generator.sh](https://github.com/bostspb/hadoop/blob/main/lesson06/log_generator.sh), 
похожий на показанный в вебинаре и закидываем его на сервер:
    
    scp ./lesson06/log_generator.sh student9_7@manager.novalocal:~/flume/log_generator.sh


#### 7. Flume: Запустить свой Flume, прочитать свои данные в Hive
Создаем конфигурационный файл для **Flume** [flum_settings.conf](https://github.com/bostspb/hadoop/blob/main/lesson06/flum_settings.conf) и закидываем на сервер 
    
    scp ./lesson06/flum_settings.conf student9_7@manager.novalocal:~/flume/flum_settings.conf

Подготавливаем директорию в **HDFS**, указанную как целевую в конфигурационном файле
    
    hdfs dfs -mkdir /student9_7/flume_src

    /bin/flume-ng agent --conf /home/student9_7/flume/ --conf-file /home/student9_7/flume/flum_settings.conf --name StudentFlume -Dflume.root.logger=INFO,console
    
Процесс пошел, проверяем наличие файлов в **HDFS** в директории  `/student9_7/flume_src`.

    hdfs dfs -ls /student9_7/flume_src
    Found 52 items
    -rw-r--r--   3 student9_7 supergroup        705 2020-12-04 07:44 /student9_7/flume_src/FlumeData.1607067865765.log
    -rw-r--r--   3 student9_7 supergroup        765 2020-12-04 07:45 /student9_7/flume_src/FlumeData.1607067865766.log
    -rw-r--r--   3 student9_7 supergroup        765 2020-12-04 07:45 /student9_7/flume_src/FlumeData.1607067865767.log
    -rw-r--r--   3 student9_7 supergroup        172 2020-12-04 07:45 /student9_7/flume_src/FlumeData.1607067865768.log
    -rw-r--r--   3 student9_7 supergroup        785 2020-12-04 07:46 /student9_7/flume_src/FlumeData.1607067954958.log
    -rw-r--r--   3 student9_7 supergroup        172 2020-12-04 07:46 /student9_7/flume_src/FlumeData.1607067954959.log
    -rw-r--r--   3 student9_7 supergroup        785 2020-12-04 07:46 /student9_7/flume_src/FlumeData.1607067988011.log
    -rw-r--r--   3 student9_7 supergroup        805 2020-12-04 07:47 /student9_7/flume_src/FlumeData.1607068018095.log
    ...
    
Создаем таблицу в **Hive** для просмотра данных.

    create external table lesson6_student9_7.logs (
        msg string,
        value int,
        event_date string
    ) ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ';'
    STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.SequenceFileInputFormat'
    OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat'
    location "/student9_7/flame_src";

Таблица создалась, смотрим данные:
    
    SELECT * FROM lesson6_student9_7.logs LIMIT 10;
    
    Done. 0 results.
    
Странно, вроде все верно сделал, а данные не в таблице не появились

#### Комментарий преподавателя
Андрей Телюков・Преподаватель
Добрый день, sqoop'ом avro нужно было импортить не через hive-import.
А во втором задании во всем виноват flame ) (flAme_src при создании таблицы)
    
