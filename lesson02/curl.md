### 2.1 Опробовать доступ для работы с кластером используя утилиту CURL

> _Справка:_ <br>http://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-hdfs/WebHDFS.html
>
> Т.к. извне доступ по http кластеру закрыт, то выполняем запросы, находясь на самой машине кластера.
 
Заходим на ноду

    ssh student9_7@manager.novalocal

Смотрим что есть в нашей директории `/student9_7`

    curl -sS  "http://manager.novalocal:50070/webhdfs/v1/student9_7?op=LISTSTATUS"    
    {"FileStatuses":{"FileStatus":[
        {"accessTime":0,"blockSize":0,"childrenNum":0,"fileId":5139393,"group":"supergroup","length":0,"modificationTime":1605958211684,"owner":"student9_7","pathSuffix":"dir_created_via_curl","permission":"755","replication":0,"storagePolicy":0,"type":"DIRECTORY"},
        {"accessTime":1605953216696,"blockSize":134217728,"childrenNum":0,"fileId":5138352,"group":"supergroup","length":7104,"modificationTime":1605953220706,"owner":"student9_7","pathSuffix":"googlobots.txt","permission":"644","replication":3,"storagePolicy":0,"type":"FILE"},
        {"accessTime":1605946691009,"blockSize":134217728,"childrenNum":0,"fileId":5137066,"group":"supergroup","length":19,"modificationTime":1605946691680,"owner":"student9_7","pathSuffix":"test","permission":"644","replication":2,"storagePolicy":0,"type":"FILE"},
        {"accessTime":0,"blockSize":0,"childrenNum":0,"fileId":5137609,"group":"supergroup","length":0,"modificationTime":1605950057832,"owner":"student9_7","pathSuffix":"testdir","permission":"755","replication":0,"storagePolicy":0,"type":"DIRECTORY"}
    ]}}


Создаем поддиректорию `dir_created_via_curl` в родительском каталоге `/student9_7` и сразу проверяем,
что поддиректория создалась

    curl -sS -X PUT "http://manager.novalocal:50070/webhdfs/v1/student9_7/dir_created_via_curl?op=MKDIRS&user.name=student9_7"
    {"boolean":true}
    
    hdfs dfs -ls /student9_7 
    Found 4 items
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 12:28 /student9_7/dir_created_via_curl
    -rw-r--r--   3 student9_7 supergroup       7104 2020-11-21 10:07 /student9_7/googlobots.txt
    -rw-r--r--   2 student9_7 supergroup         19 2020-11-21 08:18 /student9_7/test
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 09:14 /student9_7/testdir
  
Удаляем директорию `/student9_7/dir_created_via_curl` и проверяем результат

    curl -sS -X DELETE "http://manager.novalocal:50070/webhdfs/v1/student9_7/dir_created_via_curl?op=DELETE&user.name=student9_7"
    {"boolean":true}
    
    hdfs dfs -ls /student9_7
    Found 3 items
    -rw-r--r--   3 student9_7 supergroup       7104 2020-11-21 10:07 /student9_7/googlobots.txt
    -rw-r--r--   2 student9_7 supergroup         19 2020-11-21 08:18 /student9_7/test
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 09:14 /student9_7/testdir

Кладем файл `readme` в рабочую директорию под именем `cur_readme` (операция в два шага) и проверяем результат<br>

**Шаг 1** - создаем пустой файл

    curl -i -X PUT "http://manager.novalocal:50070/webhdfs/v1/student9_7/cur_readme?op=CREATE&user.name=student9_7"
    HTTP/1.1 307 TEMPORARY_REDIRECT
    Cache-Control: no-cache
    Expires: Sat, 21 Nov 2020 14:00:17 GMT
    Date: Sat, 21 Nov 2020 14:00:17 GMT
    Pragma: no-cache
    Expires: Sat, 21 Nov 2020 14:00:17 GMT
    Date: Sat, 21 Nov 2020 14:00:17 GMT
    Pragma: no-cache
    Content-Type: application/octet-stream
    X-FRAME-OPTIONS: SAMEORIGIN
    Set-Cookie: hadoop.auth="u=student9_7&p=student9_7&t=simple&e=1606003217614&s=Mtc4RE9wGg8JrGHwR6ZIZlEPiE4="; Path=/; HttpOnly
    Location: http://node2.novalocal:50075/webhdfs/v1/student9_7/cur_readme?op=CREATE&user.name=student9_7&namenoderpcaddress=manager.novalocal:8020&overwrite=false
    Content-Length: 0

**Шаг 2** - из ответа на шаге 1 берем адрес переадресации и передаем уже туда сам файл

    curl -i -X PUT -T "./readme" "http://node2.novalocal:50075/webhdfs/v1/student9_7/cur_readme?op=CREATE&user.name=student9_7&namenoderpcaddress=manager.novalocal:8020&overwrite=false"
    HTTP/1.1 100 Continue
    HTTP/1.1 201 Created
    Location: hdfs://manager.novalocal:8020/student9_7/cur_readme
    Content-Length: 0
    Connection: close

**Проверяем результат**

    hdfs dfs -ls /student9_7
    Found 5 items
    -rw-r--r--   3 student9_7 supergroup       1705 2020-11-21 14:01 /student9_7/cur_readme
    -rw-r--r--   3 student9_7 supergroup       7104 2020-11-21 10:07 /student9_7/googlobots.txt    
    -rw-r--r--   2 student9_7 supergroup         19 2020-11-21 08:18 /student9_7/test
    -rw-r--r--   3 student9_7 supergroup         19 2020-11-21 13:11 /student9_7/test2
    drwxr-xr-x   - student9_7 supergroup          0 2020-11-21 09:14 /student9_7/testdir
