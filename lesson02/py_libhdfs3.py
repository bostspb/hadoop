"""
    2.3 Опробовать доступ для работы с кластером используя `libhdfs3`
"""

'''
    Т.к. `libhdfs3` - это библиотека для C/C++, то будем использовать обертку для нее под Python - `hdfs3`
    https://hdfs3.readthedocs.io/en/latest/
    
    Модуль поддерживает и Python2 и Python3, поэтому будем работать с дефолтной версией интерпретатора
    
    Проверяем установлена ли библиотека `hdfs3` 
    pydoc modules
    
    Библиотеки не оказлось - устанавливаем
    pip install hdfs3
    
    Выясняем адрес и порт для запросов 
    hdfs getconf -confKey fs.defaultFS
    
    Дальше запускаем терминал Python и работаем в нем
    (как вариант - можно подготовить скрипт и запускать его)
'''


from hdfs3 import HDFileSystem
hdfs = HDFileSystem(host='manager.novalocal', port=8020)
'''
И здесь он нам говорит: "Can not find the shared library: libhdfs3.so"
и предлагает установить ее по инструкции http://hdfs3.readthedocs.io/en/latest/install.html,
ок - пробуем установить
yum install libhdfs3 libhdfs3-dev
а он нам: "You need to be root to perform this command."
финиталякомедия
'''
