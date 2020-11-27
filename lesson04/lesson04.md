## Урок 4. Apache Hive

#### 1. Скачать любой датасет из списка ниже с сайта Kaggle.com (достаточно большой)
Скачиваю датасет [Berlin Airbnb Data](https://www.kaggle.com/brittabettendorf/berlin-airbnb-data) (88MB, ZIP)

#### 2. Создать собственную базу данных в HIVE
Заходим в интерфейс HUE по адресу http://manager.novalocal:8888/ и cоздаем базу данных `student9_7`, 
смотрим ее расположение - `/user/hive/warehouse/student9_7.db`, т.е. по этому пути будем загражать файлы с данными.


#### 3. Загрузить этот датасет в HDFS в свою домашнюю папку
Распаковываем файлы датасета, заходим в интерфейс HUE и пытаемся загрузить файлы в директорию с базой данных.
К сожалению вылетает ошибка и файлы больше 64MB не загружается. Тогда для загрузки файлов используем `scp`.

    scp ./* student9_7@manager.novalocal:~/berlin_airbnb_dataset/

Заходим на ноду и перекидываем файлы датасета в `HDFS`

    ssh student9_7@manager.novalocal
    hdfs dfs -put ./berlin_airbnb_dataset/* /user/hive/warehouse/student9_7.db

Убедимся, что все закачалось

    hdfs dfs -ls /user/hive/warehouse/student9_7.db
    Found 6 items
    -rw-r--r--   3 student9_7 hive  197617255 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/calendar_summary.csv
    -rw-r--r--   3 student9_7 hive    3881605 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/listings.csv
    -rw-r--r--   3 student9_7 hive   73522451 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/listings_summary.csv
    -rw-r--r--   3 student9_7 hive       4350 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/neighbourhoods.csv
    -rw-r--r--   3 student9_7 hive    7760713 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/reviews.csv
    -rw-r--r--   3 student9_7 hive  125380142 2020-11-26 07:43 /user/hive/warehouse/student9_7.db/reviews_summary.csv

Заходим в HUE, создаем для каждого файла свою директорию с таким же названием и раскладываем их туда.


#### 4. Создать таблицы внутри базы данных с использованием всех загруженных файлов. Один файл – одна таблица.
Подготавливаем SQL-файл с Hive-запросом на создание шести таблиц - [ddl.sql](https://github.com/bostspb/hadoop/blob/main/lesson04/ddl.sql) <br>
Запускаем запрос через интерфейс Hue - таблицы успешно создаются. 


#### 5. Сделать любой отчет по загруженным данным используя групповые и агрегатные функции.
Подготавливаем SQL-файл с Hive-запросом, выдающий **Средние цены по районам Берлина и соответствующее количество отзывов**:
[queries.sql](https://github.com/bostspb/hadoop/blob/main/lesson04/queries.sql) <br>
Запускаем запрос через интерфейс Hue - таблицы успешно создаются.

#### 6. Сделать любой отчет по загруженным данным используя JOIN.
Для данного задания вполне подходит ранее подготовленный запрос по средним ценам в районах Берлина: 
[queries.sql](https://github.com/bostspb/hadoop/blob/main/lesson04/queries.sql), 
т.к. он содержит JOIN на справочную таблицу с районами Берлина.<br>
