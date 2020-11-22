"""
    2.2 Опробовать доступ для работы с кластером используя Python3
"""

'''
    Для Python3 самый популярный клиент для доступа к HDFS это модуль `hdfs`, использующий `WebHDFS`
    https://hdfscli.readthedocs.io/en/latest/
    
    Заходим на ноду 
    ssh student9_7@manager.novalocal

    Проверяем есть ли на сервере 3я версия Python
    python3 -V  
    Python 3.6.8

    Устанавливаем библиотеку hdfs 
    pip3 install hdfs --user

    Дальше запускаем терминал Python3 и работаем в нем
    (как вариант - можно подготовить скрипт и запускать его)
'''

from hdfs import InsecureClient


client = InsecureClient('http://manager.novalocal:50070', user='student9_7')


# Посмотрим, что у нас есть в рабочей директории
print(client.list('/student9_7'))
'''
['cur_readme', 'googlobots.txt', 'py_dir_02', 'readme', 'test', 'test2', 'testdir']
'''


# Посмотрим размер нашей рабочей директории
print(client.content('/student9_7'))
'''
{'directoryCount': 3, 'fileCount': 5, 'length': 10552, 'quota': -1, 'spaceConsumed': 31637, 'spaceQuota': -1}
'''


# Прочитаем файл `test`
with client.read('/student9_7/test') as reader:
  test = reader.read()
print(test)
'''
b'test file for hdfs\n'
'''


# Скопируем файл `test` из хранилища в локальную домашнюю директорию под именем `downloaded_file_via_py3`
client.download('/student9_7/test', 'downloaded_file_via_py3', n_threads=5)
'''
'/home/student9_7/downloaded_file_via_py3'
'''

