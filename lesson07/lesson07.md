## Урок 7. Виды баз данных. HBase, Cassandra
_Подключиться к HBase и Cassandra. <br>
Создать там таблицы в консоли, вставить записи._

##### Cassandra
Заходим на ноду, где установлена Cassandra

    ssh student9_7@node4.novalocal

Запускаем клиент

    /cassandra/bin/cqlsh node4.novalocal
  
Создаем свой `keyspace`   

    CREATE  KEYSPACE  student9_7 
    WITH REPLICATION = {
        'class' : 'SimpleStrategy', 'replication_factor' : 1
    };
    
Создаем таблицу 

    CREATE TABLE student9_7.cars (
        id int, 
        model text,
        color text,
        primary key (id)
    );

Вставим несколько записей

    insert into student9_7.cars (id, model, color) values (1, 'Lada Vesta', 'brown');
    insert into student9_7.cars (id, model, color) values (2, 'Bugatti Veyron', 'blue');
    insert into student9_7.cars (id, model, color) values (5, 'Kia Optima', 'white');

Посмотрим что получилось
  
    select * from student9_7.cars;
    
     id | color | model
    ----+-------+----------------
      5 | white |     Kia Optima
      1 | brown |     Lada Vesta
      2 |  blue | Bugatti Veyron

Удалим одну запись

    delete from student9_7.cars where id = 1;
    
И посмотрим что получилось
  
    select * from student9_7.cars;
    
     id | color | model
    ----+-------+----------------
      5 | white |     Kia Optima
      2 |  blue | Bugatti Veyron

  
##### HBase
Заходим на ноду c HBase

    ssh student9_7@manager.novalocal  
      
Запускаем клиента Hbase    
    
    hbase shell

Смотрим какие `namespace` уже есть командой `list` 
и создаем свой - `student9_7`
    
    create_namespace 'student9_7'

Затем создаем таблицу

    create 'student9_7:cars', 'model', 'color'
    
Запишем в таблицу несколько значений

    put 'student9_7:cars', '1', 'model', 'Lada Vesta';
    put 'student9_7:cars', '1', 'color', 'brown';
    put 'student9_7:cars', '2', 'model', 'Bugatti Veyron';
    put 'student9_7:cars', '3', 'color', 'blue';
    put 'student9_7:cars', '5', 'model', 'Kia Optima';
    put 'student9_7:cars', '5', 'color', 'white';
    
Посмотрим что получилось

    scan 'student9_7:cars'

    ROW                                             COLUMN+CELL
     1                                              column=color:, timestamp=1607715514394, value=brown
     1                                              column=model:, timestamp=1607715469131, value=Lada Vesta
     2                                              column=model:, timestamp=1607715514404, value=Bugatti Veyron
     3                                              column=color:, timestamp=1607715514410, value=blue
     5                                              column=color:, timestamp=1607715634881, value=white
     5                                              column=model:, timestamp=1607715634858, value=Kia Optima
    4 row(s) in 0.0160 seconds

Удалим полную запись с `ID = 5`

    delete 'student9_7:cars', '5'
    
А у записи с `ID = 1` удалим только значение поля `color`

    delete 'student9_7:cars', '1', 'color'
    
Посмотрим что получилось

    scan 'student9_7:cars'
        
    ROW                                             COLUMN+CELL
     1                                              column=model:, timestamp=1607715469131, value=Lada Vesta
     2                                              column=model:, timestamp=1607715514404, value=Bugatti Veyron
     3                                              column=color:, timestamp=1607715514410, value=blue
    3 row(s) in 0.0190 seconds
