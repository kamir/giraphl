#
#  bootstrap-giraph
#
#  author  :  Mirko Kaempf
#  version :  0.1
#
#

NOW=$(date +"%Y-%m-%d_%H-%M-%S")

########################
# Cloudera Training VM #
########################
#
# we need a zookeeper ... so we jump in to the exercise 10 
# which comes after the HDFS-HA lab
#
CDHV=4.2.0
EXJARS=hadoop-2.0.0-mr1-cdh4.2.0-examples.jar
USER=training
ZKSERVER=elephant
ZKPORT=2181


##########################
# Cloudera Quickstart VM #
##########################
#CDHV=4.4.0
#EXJARS=hadoop-examples-2.0.0-mr1-cdh4.4.0.jar
#USER=cloudera
#ZKSERVER=127.0.0.1
#ZKPORT=2181

#
# Prepare the stage for some more analytics later on ...
#
#sudo yum install ant
#sudo yum install gnuplot
#sudo yum install svn
#sudo yum install R

#
# Install Maven3
#
# Download the current maven version from the prescribed repository:
#
#   check the version, maybe a more recent version is available ...
#
#wget http://www.eng.lsu.edu/mirrors/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz

#
# Extract the archive to the maven home directory: /usr/local/
#
#sudo cp apache-maven-3.1.1-bin.tar.gz /usr/local
#cd /usr/local
#sudo tar -zxvf apache-maven-3.1.1-bin.tar.gz

#
# Create a sym link..
#
#sudo ln -s apache-maven-3.1.1 maven

#
# Open with gedit ~/.bashrc file with and add the following lines to the end of the file,
#
#sudo echo "export M2_HOME=/usr/local/apache-maven-3.1.1" >> /home/$USER/.bashrc
#sudo echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /home/$USER/.bashrc

#
# Execute the environment changes with the command,    
#
#source /home/$USER/.bashrc
#sudo chmod 777 /usr/local/apache-maven-3.1.1/bin/mvn
#sudo /usr/local/apache-maven-3.1.1/bin/mvn -version

#
# Install GIT
#
#sudo rpm -i 'http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm'
#sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#sudo sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/rpmforge.repo
#sudo yum clean all
#sudo yum install git
#git config --global user.name "contrib"
#git config --global user.email thats@me.com

#
# Test the MapReduce cluster …
#
#hadoop fs -mkdir /user/$USER
#hadoop fs -mkdir /user/$USER/ginput
#hadoop fs -mkdir /user/$USER/goutput
#hadoop jar /usr/lib/hadoop-0.20-mapreduce/$EXJARS /user/$USER/teragen 50000 TESTFILE_$NOW
#hadoop jar /usr/lib/hadoop-0.20-mapreduce/$EXJARS /user/$USER/terasort TESTFILE_$NOW TESTFILE_$NOW.sorted

#
# Deploy Giraph
#
#wget https://github.com/apache/giraph/archive/release-1.0.0.zip
#unzip release-1.0.0
cd giraph-release-1.0.0
#mvn package -DskipTests -Dhadoop=non_secure -P hadoop_2.0.0
#ln -s giraph-core/target/giraph-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-core.jar
#ln -s giraph-examples/target/giraph-examples-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-ex.jar

#
# Download sample data
#
mkdir gsampledata
cd gsampledata

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
#hadoop fs -put shortestPathsInputGraph /user/$USER/ginput/shortestPathsInputGraph

#wget https://github.com/kamir/giraphl/archive/master.zip
#unzip master
cd giraphl-master/sample_data/apache_giraph_examples

#
# Deploy sample data to HDFS
#
#hadoop fs -put tiny_graph.txt /user/$USER/ginput/tiny_graph.txt

cd ..
cd ..
cd ..
cd ..

#ls


#
# Run Giraph tests
#
hadoop jar giraph-ex.jar org.apache.giraph.benchmark.PageRankBenchmark -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar -e 1 -s 3 -v -V 50 -w 1

#
# Show what algorithms can be used with a given InputFormat
#
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -libjars giraph-core.jar org.apache.giraph.examples.SimpleShortestPathsVertex -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/cloudera/ginput/tiny_graph.txt -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/cloudera/goutput/shortestpaths_$NOW -w 1
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -libjars giraph-core.jar -h
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -libjars giraph-core.jar -la
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/cloudera/goutput/shortestpaths_rand_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=5 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.AdjacencyListTextVertexOutputFormat -op /user/cloudera/goutput/randomGraph_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=1 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2

hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SSPV2 -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat2 -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat2 -of org.apache.giraph.io.formats.JsonBase64VertexOutputFormat -op /user/$USER/goutput/randomGraph_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=1 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2







