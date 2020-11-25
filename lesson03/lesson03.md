## Урок 3. MapReduce & YARN

#### Запуск примеров и знакомство с интерфейсом ResourceManager Web UI
Делаем проброс портов до прокси на node2.novalocal для доступа к веб-интерфейсу ресурс-менеджера кластера
 
    ssh student9_7@node2.novalocal -D localhost:1080

Прописываем прокси **SOCKS v5 Host** `localhost:1080` в браузере и заходим на **ResourceManager Web UI** 
по адресу http://manager.novalocal:8088/cluster

Возвращаемся в консоль `SSH` заходим на основную ноду:

    ssh student9_7@manager.novalocal
 
Находим пример джобы

    /opt/cloudera/parcels/CDH-5.16.2-1.cdh5.16.2.p0.8/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar

Для длинного пути заводим переменную
    
    YARN_EXAMPLES=/opt/cloudera/parcels/CDH-5.16.2-1.cdh5.16.2.p0.8/lib/hadoop-mapreduce

Смотрим какие доступны джобы в нашем примере
    
    yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar

Выбираем джобу `pi: A map/reduce program that estimates Pi using a quasi-Monte Carlo method.` - 
вычисление числа `Pi` методом Монте-Карло
    
     yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar pi 32 10000

В ходе выполнения нам показывают URL для отслеживания хода выполнения джобы:

    ...
    20/11/25 05:20:06 INFO mapreduce.Job: The url to track the job: http://manager.novalocal:8088/proxy/application_1604591611666_0561/
    ...
    
Переходим на этот URL для ознакомления - http://manager.novalocal:8088/proxy/application_1604591611666_0561/

#### Пишем MapReduce-задачу WordCount
Подготавливаем файлы [example.txt](https://github.com/bostspb/hadoop/blob/main/lesson03/example.txt),
[mapper.py](https://github.com/bostspb/hadoop/blob/main/lesson03/mapper.py) и [reducer.py](https://github.com/bostspb/hadoop/blob/main/lesson03/reducer.py)

Закидываем их на ноду в домашнюю директорию:
    
    scp example.txt student9_7@manager.novalocal:~
    scp mapper.py student9_7@manager.novalocal:~
    scp reducer.py student9_7@manager.novalocal:~
    
Тестируем пайплайн:   
  
    cat example.txt | python3 mapper.py | sort | python3 reducer.py

Тест проходит успешно. Закидываем файл `example.txt` в `HDFS`:
    
    hdfs dfs -put example.txt /student9_7/example.txt
    
Запускаем джобу    

    yarn jar $YARN_EXAMPLES/hadoop-streaming.jar -input /student9_7/example.txt -output /student9_7/result -file mapper.py -file reducer.py -mapper "python mapper.py" -reducer "python reducer.py"
    
Отслеживаем ход выполнения по адресу http://manager.novalocal:8088/proxy/application_1604591611666_0562/
   
#### Ответы на вопросы
***Что такое YARN?**<br>
Hadoop YARN - это фреймворк для управления ресурсами кластера и менеджмента задач

***Почему задачи на YARN нестабильны?**<br>
Потому что сложно добиться сбалансированности раздачи ресурсов при выполнении задач.

**Почему Map Reduce долго выполняется?**<br>
В архитектуре Map Reduce используются довольно тяжелые операции Map, Shuffle и Reduce, 
при этом на стадии Reduce приходится производить полное сканирование входных данных. 

**Почему Map Reduce не выполняется?**<br>
Смотреть в логи.

***Где хранится результат выполнения Map Reduce?**<br>
Путь хранения задается в параметрах команды для выполнения задачи. 
Обычно это директория, а сам результат распределяется по отдельным файлам от каждого редюсера.