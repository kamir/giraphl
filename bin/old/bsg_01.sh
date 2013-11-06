CDHV=4.4.0

#
# Test the MapReduce cluster …
#
hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples-2.0.0-mr1-$CDHV.jar teragen 50000 TESTFILE
hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples-2.0.0-mr1-$CDHV.jar terasort TESTFILE TESTFILE.sorted

hadoop fs -mkdir /user/cloudera 
hadoop fs -mkdir /user/cloudera/ginput
hadoop fs -mkdir /user/cloudera/goutput

#
# Deploy Giraph
#
wget https://github.com/apache/giraph/archive/release-1.0.0.zip
unzip release-1.0.0
cd giraph-release-1.0.0
mvn package -DskipTests -Dhadoop=non_secure -P hadoop_2.0.0
ln -s giraph-core/target/giraph-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-core.jar
ln -s giraph-examples/target/giraph-examples-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-ex.jar

#
# Download sample data
#
#mkdir gsampledata
#cd gsampledata

#
# 
#
#wget http://www-personal.umich.edu/~mejn/netdata/football.zip
#unzip football.zip -d football

#
# Sample Network from A. Ching
#
#wget http://ece.northwestern.edu/~aching/shortestPathsInputGraph.tar.gz
#tar zxvf shortestPathsInputGraph.tar.gz
#hadoop fs -put shortestPathsInputGraph /user/cloudera/ginput/shortestPathsInputGraph

#wget https://github.com/kamir/giraphl/archive/master.zip
#unzip master
#cd giraphl-master/sample_data/apache_giraph_examples

#cd ..
#cd ..
#cd ..
#cd ..

#ls

#
# Deploy sample data to HDFS
#
#hadoop fs -put tiny_graph.txt /user/cloudera/ginput/tiny_graph.txt

#
# Run Giraph tests
#
#hadoop jar giraph-ex.jar org.apache.giraph.benchmark.PageRankBenchmark -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar -e 1 -s 3 -v -V 50 -w 1

NOW=$(date +"%Y-%m-%d_%H-%M-%S")

#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar org.apache.giraph.examples.SimpleShortestPathsVertex -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/cloudera/ginput/tiny_graph.txt -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/cloudera/goutput/shortestpaths_$NOW -w 1


#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -libjars giraph-core.jar -h

#
# Show what algorithms can be used with a given InputFormat
#
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -libjars giraph-core.jar -la



#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/cloudera/goutput/shortestpaths_rand_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=5 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2


#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.AdjacencyListTextVertexOutputFormat -op /user/cloudera/goutput/randomGraph_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=1 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2


hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.JsonBase64VertexOutputFormat -op /user/cloudera/goutput/randomGraph_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=1 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2







