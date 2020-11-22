### 1. Опробовать консольные утилиты для работы с кластером
>_Задание:_
>1. Создать/скопировать/удалить папку
>2. Положить в HDFS любой файл
>3. Скопировать/удалить этот файл
>4. Просмотреть размер любой папки
>5. Посмотреть как файл хранится на файловой системе (см. команду fsck)
>6. *Установить нестандартный фактор репликации (см. команду setrep)

Заходим на ноду

    ssh student9_7@manager.novalocal

Создаем рабочую директорию `/student9_7` в `HDFS`

    hdfs dfs -mkdir /student9_7

Создаем файл вне `HDFS`

    echo 'test file for hdfs' > tttestme

Перекладываем файл в `HDFS` в ранее созданную рабочую директорию `/student9_7` с именем `test`

    hdfs dfs -put tttestme /student9_7/test

Прочитаем файл

    hdfs dfs -cat /student9_7/test 
    test file for hdfs

Посмотрим как файл хранится на файловой системе

    hdfs fsck /student9_7/test -files
    Connecting to namenode via http://manager.novalocal:50070/fsck?ugi=student9_7&files=1&path=%2Fstudent9_7%2Ftest
    FSCK started by student9_7 (auth:SIMPLE) from /89.208.221.132 for path /student9_7/test at Sat Nov 21 13:18:10 UTC 2020
    /student9_7/test 19 bytes, 1 block(s):  OK
    Status: HEALTHY
     Total size:    19 B
     Total dirs:    0
     Total files:   1
     Total symlinks:                0
     Total blocks (validated):      1 (avg. block size 19 B)
     Minimally replicated blocks:   1 (100.0 %)
     Over-replicated blocks:        0 (0.0 %)
     Under-replicated blocks:       0 (0.0 %)
     Mis-replicated blocks:         0 (0.0 %)
     Default replication factor:    3
     Average block replication:     2.0
     Corrupt blocks:                0
     Missing replicas:              0 (0.0 %)
     Number of data-nodes:          4
     Number of racks:               1
    FSCK ended at Sat Nov 21 13:18:10 UTC 2020 in 1 milliseconds
    
    
    The filesystem under path '/student9_7/test' is HEALTHY

Поменяем для файла стандартный фактор репликации `3` на нестандартный `2`

    hdfs dfs -setrep 2 /student9_7/test

Скопируем файл в файл с именем `test2`

    hdfs dfs -cp /student9_7/test /student9_7/test2

Положим еще один файл в рабочую директорию, скачав его `CURL`'ом

    curl -sS https://www.google.com/robots.txt | hdfs dfs -put - /student9_7/googlobots.txt

Создадим поддиректорию `testdir`

    hdfs dfs -mkdir /student9_7/testdir

Проверяем содержимое рабочей директории
    
    hdfs dfs -ls /student9_7
    Found 4 items
    -rw-r--r--   3 student9_7 supergroup       7104 2020-11-21 10:07 /student9_7/googlobots.txt
    -rw-r--r--   2 student9_7 supergroup         19 2020-11-21 08:18 /student9_7/test
    -rw-r--r--   3 student9_7 supergroup         19 2020-11-21 13:11 /student9_7/test2
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 09:14 /student9_7/testdir

Посмотрим размер рабочей директории

    hdfs dfs -count /student9_7
    2            3               7142 /student9_7

Выйдем с сервера, закачаем через `SCP` локальный файл `README.md` в домашнюю директорию на сервере
под именем `readme`, затем снова зайдем на сервер и переложим файл в рабочую директорию на `HDFS` 

    exit
    scp README.md student9_7@manager.novalocal:~/readme
    ssh student9_7@manager.novalocal
    hdfs dfs -put readme /student9_7/readme
    
Проверяем содержимое рабочей директории - убеждаемся, что файл появился
    
    hdfs dfs -ls /student9_7
    Found 5 items
    -rw-r--r--   3 student9_7 supergroup       7104 2020-11-21 10:07 /student9_7/googlobots.txt
    -rw-r--r--   3 student9_7 supergroup       1705 2020-11-21 13:51 /student9_7/readme
    -rw-r--r--   2 student9_7 supergroup         19 2020-11-21 08:18 /student9_7/test
    -rw-r--r--   3 student9_7 supergroup         19 2020-11-21 13:11 /student9_7/test2
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 09:14 /student9_7/testdir
