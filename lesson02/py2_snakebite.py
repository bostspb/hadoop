"""
    2.4 Опробовать доступ для работы с кластером используя Snakebit
    https://www.oreilly.com/library/view/hadoop-with-python/9781492048435/ch01.html
"""

'''
    Заходим на ноду 
    ssh student9_7@manager.novalocal
    
    Проверяем версию Python (библиотека Snakebit работает только в Python 2)
    python -V  
    Python 2.7.5
    
    Проверяем установлена ли библиотека Snakebit 
    pydoc modules
    
    Библиотеки не оказлось - устанавливаем
    pip install snakebite
    
    Выясняем адрес и порт для запросов 
    hdfs getconf -confKey fs.defaultFS
    
    Дальше запускаем терминал Python и работаем в нем
    (как вариант - можно подготовить скрипт и запускать его)
'''


from snakebite.client import Client


client = Client('manager.novalocal', 8020)


# Посмотрим, что у нас есть в рабочей директории
for x in client.ls(['/student9_7']):
   print(x)
'''
{'group': u'supergroup', 'permission': 420, 'file_type': 'f', 'access_time': 1605967318187L, 'block_replication': 3, 'modification_time': 1605967318265L, 'length': 1705L, 'blocksize': 134217728L, 'owner': u'student9_7', 'path': '/student9_7/cur_readme'}
{'group': u'supergroup', 'permission': 420, 'file_type': 'f', 'access_time': 1605953216696L, 'block_replication': 3, 'modification_time': 1605953220706L, 'length': 7104L, 'blocksize': 134217728L, 'owner': u'student9_7', 'path': '/student9_7/googlobots.txt'}
{'group': u'supergroup', 'permission': 420, 'file_type': 'f', 'access_time': 1605966686950L, 'block_replication': 3, 'modification_time': 1605966688013L, 'length': 1705L, 'blocksize': 134217728L, 'owner': u'student9_7', 'path': '/student9_7/readme'}
{'group': u'supergroup', 'permission': 420, 'file_type': 'f', 'access_time': 1605964109596L, 'block_replication': 2, 'modification_time': 1605946691680L, 'length': 19L, 'blocksize': 134217728L, 'owner': u'student9_7', 'path': '/student9_7/test'}
{'group': u'supergroup', 'permission': 420, 'file_type': 'f', 'access_time': 1605964267111L, 'block_replication': 3, 'modification_time': 1605964267975L, 'length': 19L, 'blocksize': 134217728L, 'owner': u'student9_7', 'path': '/student9_7/test2'}
{'group': u'supergroup', 'permission': 493, 'file_type': 'd', 'access_time': 0L, 'block_replication': 0, 'modification_time': 1605950057832L, 'length': 0L, 'blocksize': 0L, 'owner': u'student9_7', 'path': '/student9_7/testdir'}
'''


# Создадим пару директорий
for p in client.mkdir(['/student9_7/py_dir_01', '/student9_7/py_dir_02'], create_parent=True):
   print(p)
'''
{'path': '/student9_7/py_dir_01', 'result': True}
{'path': '/student9_7/py_dir_02', 'result': True}
'''


# Удалим директорию `py_dir_01`
for p in client.delete(['/student9_7/py_dir_01'], recurse=True):
   print(p)
'''
{'path': '/student9_7/py_dir_01', 'result': True}
'''


# Посмотрим что содержится в файле `test`
for t in client.text(['/student9_7/test']):
   print(t)
'''
test file for hdfs
'''


# Скопируем файл `test` из хранилища в локальную домашнюю директорию под именем `retrived_file_via_py`
for f in client.copyToLocal(['/student9_7/test'], 'retrived_file_via_py'):
   print(f)
'''
{'path': '/home/student9_7/retrived_file_via_py', 'source_path': '/student9_7/test', 'result': True, 'error': ''}
'''


