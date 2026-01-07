# تشغيل Hadoop

start-dfs.sh
start-yarn.sh
jps

## Output:

NameNode
DataNode
SecondaryNameNode
ResourceManager
NodeManager

# رفع ملف إلى HDFS

--
echo "Hello Spark Wordcount!" > file1.txt
echo "Hello Hadoop Also :)" >> file1.txt
--

hdfs dfs -put file1.txt /
hdfs dfs -ls /

## Output
/file1.txt

# WordCount باستخدام Spark Shell


spark-shell

val lines = sc.textFile("hdfs://localhost:9000/file1.txt")
val words = lines.flatMap(_.split("\\s+"))
val wc = words.map(w => (w, 1)).reduceByKey(_ + _)
wc.saveAsTextFile("hdfs://localhost:9000/file1.count")
:quit
 
--
 hdfs dfs -cat /file1.count/part-00000

## Output
(Hello,2)
(Wordcount!,1)

--

hdfs dfs -cat /file1.count/part-00001

## Output
(Spark,1)
(:),1)
(Also,1)
(Hadoop,1)


# Spark Batch (Java)

### إنشاء مشروع Maven
mvn archetype:generate -DgroupId=spark.batch \
-DartifactId=wordcount-spark \
-DarchetypeArtifactId=maven-archetype-quickstart \
-DinteractiveMode=false

## بناء المشروع

cd wordcount-spark
rm src/test/java/spark/batch/AppTest.java
mvn package

## تشغيل التطبيق
spark-submit --class spark.batch.WordCountTask \
target/wordcount-spark-1.0-SNAPSHOT.jar \
hdfs://localhost:9000/file1.txt \
hdfs://localhost:9000/wc-output

--

hdfs dfs -cat /wc-output/part-00000

## Output

(Hello,2)
(Wordcount!,1)

--

hdfs dfs -cat /wc-output/part-00001


# Spark Structured Streaming
تشغيل Netcat
nc -lk 9999

## تشغيل تطبيق Streaming
spark-submit streaming.py

## Input
hello hiba
hiba debbab
test
hi
ttttt

## Output


+------+-----+
|  word|count|
+------+-----+
|debbab|    1|
| hello|    1|
|   �hi|    1|
|  hiba|    2|
|    ff|    1|
|      |    2|
|  test|    1|
|�ttttt|    1|
+------+-----+