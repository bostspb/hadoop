# GB: BigData. Введение в экосистему Hadoop
> **Geek University Data Engineering**

`Hadoop` `HDFS` `WebHDFS via CURL` `MapReduce` `YARN`<br>
`Python:snakebite` `Python:hdfs` `Python:hdfs3 (libhdfs3)` 

## Урок 1. Введение в Hadoop
* Hadoop — не база данных<br>
* Не заточен под **OLTP**, заточен под **OLAP** - https://habr.com/ru/post/442754/ <br>  
* Нет [ACID](https://oracle-patches.com/db/mysql/3814-tranzaktsii-v-baze-dannyh-mysql) транзакций (справка по уровням изоляции - https://habr.com/ru/post/469415/) <br>
* В основном раскрывает себя для **data analyst**, **data engineer**, **data scientist**
* Можно начинать после 50Тб или если данные не реляционны
* Наименьшая стоимость за единицу хранения около $10-$20K за узел (32thread/256Gb/45Tb)
* Стоит начинать от  10 узлов  

В ходе выполнения домашнего задания зашел по **ssh** на предоставленный кластер с **Hadoop** 
и выполнил команду `hdfs dfs -ls`. Также ознакомился с интерфейсом **Cloudera Manager**.


## Урок 2. HDFS. Архитектура
* Разобрали особенности хранения данных в файловой системе [HDFS](https://medium.com/@artem_gogin/how-exactly-hadoop-stores-the-data-23da0679d173).
* Познакомились с основными консольными командами **HDFS** 
([FS shell](https://hadoop.apache.org/docs/r2.4.1/hadoop-project-dist/hadoop-common/FileSystemShell.html),
[HDFS Commands](https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html))

**Домашнее задание:**
1. Опробовать консольные утилиты для работы с кластером<br>
    [] Создать/скопировать/удалить папку<br>
    [] Положить в HDFS любой файл<br>
    [] Скопировать/удалить этот файл<br>
    [] Просмотреть размер любой папки<br>
    [] Посмотреть как файл хранится на файловой системе (см. команду fsck)<br>
    [] Установить нестандартный фактор репликации (см. команду setrep)<br>
    [Решение](https://github.com/bostspb/hadoop/blob/main/lesson02/cli.md)

2. *Опробовать доступ для работы с кластером<br>
    [] Используя утилиту CURL - [Решение](https://github.com/bostspb/hadoop/blob/main/lesson02/curl.md) <br>
    [] Используя python3 - [Решение](https://github.com/bostspb/hadoop/blob/main/lesson02/py3_hdfs.py) <br>
    [] Используя libhdfs3 - [Решение](https://github.com/bostspb/hadoop/blob/main/lesson02/py_libhdfs3.py) <br>
    [] Используя snakebite - [Решение](https://github.com/bostspb/hadoop/blob/main/lesson02/py2_snakebite.py) <br>

    
## Урок 3. MapReduce & YARN
**Выполнение задач** 
* **Application** приложение, которое выполняется в Yarn 
* **Container** единица выделения ресурсов кластера

**Кластер**
* **Resource manager** Координатор ресурсов кластера. Учитывает только CPU и память
* **Node Manager** Координатор ресурсов одного узла кластера
* **ApplicationMaster** Представитель приложения

https://habr.com/ru/company/dca/blog/267361/ <br>
https://habr.com/ru/company/dca/blog/268277/ <br>
https://habr.com/ru/post/270453/ <br>

**Домашнее задание:**
1. **Запустить один-два примера**<br>
Опробовать запуски `map-reduce` задач для кластера используя `hadoop-mapreduce-examples.jar`. 
Чтобы увидеть полный список нужно выполнить `yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar` 
без параметров.

2. **Изучить интерфейс Resource Manager**<br>
Выполнить любую задачу включенную в этот `JAR`<br>
Найти свою задачи в интерфейсе Cloudera Manager<br>
_Пример:_<br>
    `YARN_EXAMPLES=/opt/cloudera/parcels/CDH-5.16.2-1.cdh5.16.2.p0.8/lib/hadoop-mapreduce` <br>
    `yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar pi 32 20000`

3. **Написать MapReduce-задачу WordCount**<br>
Опираясь на лекцию написать `WordCount`, используя `Hadoop Streaming` или используя `java`.

4. **Ответить на вопросы**
*Что такое YARN?<br>
*Почему задачи на YARN нестабильны?<br>
Почему Map Reduce долго выполняется?<br>
Почему Map Reduce не выполняется?<br>
*Где хранится результат выполнения Map Reduce?<br>

5*. **Написать join на map-reduce**

[Решение](https://github.com/bostspb/hadoop/blob/main/lesson03/lesson03.md)