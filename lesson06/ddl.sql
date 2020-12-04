create external table lesson6_student9_7.logs (
    msg string,
    value int,
    event_date string
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.SequenceFileInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat'
location "/student9_7/flame_src";