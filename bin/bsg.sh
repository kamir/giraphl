####################################################
#
#  Bootstrap-giraph in a CDH cluster
#
#  author  :  Mirko Kaempf
#  version :  0.3
#
####################################################
#
# we need some salt for file pseudorandom-file-names
#
NOW=$(date +"%Y-%m-%d_%H-%M-%S")

####################################################
# Cloudera Training VM #   mightbe out of date
########################
#
# we need a zookeeper ... so we jump in to the exercise 10 
# which comes after the HDFS-HA lab
#
#CDHV=4.2.0
#EXJARS=hadoop-2.0.0-mr1-cdh4.2.0-examples.jar
#USER=training
#ZKSERVER=elephant
#ZKPORT=2181

####################################################
# Cloudera Quickstart VM  CDH4.3 #
##################################
#CDHV=4.3.0
#EXJARS=hadoop-examples-2.0.0-mr1-cdh4.3.0.jar
#USER=cloudera
#ZKSERVER=127.0.0.1
#ZKPORT=2181

#####################################################
# Cloudera Quickstart VM C5 #  current VERSION !!!!!!
#############################
CDHV=5.0.0
USER=cloudera
HADOOP_MAPRED_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce
EXJARS=hadoop-mapreduce-examples-2.2.0-cdh5.0.0-beta-2.jar
GIRAPH_HOME=/usr/local/giraph
JTADDRESS=127.0.0.1
ZKSERVER=127.0.0.1
ZKPORT=2181

############################################################
# In other environments we might have to install some tools
# Prepare the stage for some more analytics later on ...
#
#sudo yum install ant
#sudo yum install gnuplot
#sudo yum install svn
#sudo yum install R

###########################################################
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
# Open with gedit:  ~/.bashrc and add the following lines to the end of the file:
#
#sudo echo "export M2_HOME=/usr/local/apache-maven-3.1.1" >> /home/$USER/.bashrc
#sudo echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /home/$USER/.bashrc

#
# Execute the environment changes with the command, ... and test mvn
#
#source /home/$USER/.bashrc
#sudo chmod 777 /usr/local/apache-maven-3.1.1/bin/mvn
#sudo /usr/local/apache-maven-3.1.1/bin/mvn -version

#####################################################################################
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

####################################################################################
#
# Prepare a user directory and test the MapReduce cluster …
#
#hadoop fs -mkdir /user/$USER
#hadoop fs -mkdir /user/$USER/sort
#hadoop fs -mkdir /user/$USER/ginput
#hadoop fs -mkdir /user/$USER/goutput
#hadoop jar $HADOOP_MAPRED_HOME/$EXJARS teragen 50000 sort/TESTFILE_$NOW
#hadoop jar $HADOOP_MAPRED_HOME/$EXJARS terasort sort/TESTFILE_$NOW sort/TESTFILE_$NOW.sorted

##################################################
#
# Deploy Giraph 1.0.0
#
#wget https://github.com/apache/giraph/archive/release-1.0.0.zip
#unzip release-1.0.0
#cd giraph-release-1.0.0
#mvn package -DskipTests -Dhadoop=non_secure -P hadoop_2.0.0
#ln -s giraph-core/target/giraph-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-core.jar
#ln -s giraph-examples/target/giraph-examples-1.0.0-for-hadoop-2.0.0-alpha-jar-with-dependencies.jar giraph-ex.jar

##################################################
#
# Deploy Giraph 1.1.0
#
GV=trunk
PRO=hadoop_2

#sudo mkdir /usr/local/giraph
cd $GIRAPH_HOME
cd ..
#sudo git clone https://github.com/apache/giraph.git
#sudo chown -R cloudera:hadoop giraph
cd $GIRAPH_HOME
#git checkout $GV

#rm giraph-core.jar
#rm giraph-ex.jar

#cp /home/cloudera/GIRAPH/giraphl/blog_02/src/*.java ./giraph-examples/src/main/java/org/apache/giraph/examples

#mvn clean compile package -DskipTests -Dhadoop=non_secure -P$PRO
#ln -s giraph-core/target/giraph-1.1.0-SNAPSHOT-for-hadoop-2.2.0-jar-with-dependencies.jar giraph-core.jar
#ln -s giraph-examples/target/giraph-examples-1.1.0-SNAPSHOT-for-hadoop-2.2.0-jar-with-dependencies.jar giraph-ex.jar

##################################################
#
# Download sample data
#
#mkdir gsampledata
#cd gsampledata

##################################################
#
#
#
#wget http://www-personal.umich.edu/~mejn/netdata/football.zip
#unzip football.zip -d football

##################################################
#
# Sample Network from A. Ching
#
#wget http://ece.northwestern.edu/~aching/shortestPathsInputGraph.tar.gz
#tar zxvf shortestPathsInputGraph.tar.gz
#hadoop fs -put shortestPathsInputGraph /user/$USER/ginput/shortestPathsInputGraph

##################################################
#
#
#
#wget https://github.com/kamir/giraphl/archive/master.zip
#unzip master
#cd giraphl-master/sample_data/apache_giraph_examples

##################################################
#
# Deploy sample data to HDFS
#
#hadoop fs -put tiny_graph.txt /user/$USER/ginput/tiny_graph.txt
#
#cd ..
#cd ..
#cd ..
#cd ..
#ls

#######################################################
#
# Test the jar-file
# (OK)
hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -libjars giraph-core.jar -h

#
#  list all implemented algorithms   !!! FAILS !!!
#
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=127.0.0.1:2181 -Dmapreduce.jobtracker.address=127.0.0.1 -libjars giraph-core.jar --listAlgorithms

#######################################################
#
# Run Giraph benchamrks
# (OK)
hadoop jar giraph-ex.jar org.apache.giraph.benchmark.PageRankBenchmark -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=$JTADDRESS -libjars giraph-core.jar -e 1 -s 3 -v -V 50 -w 1

#######################################################
# RUN PAGERANK on tiny graph
# (OK)
#######################################################
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=$JTADDRESS -libjars giraph-core.jar org.apache.giraph.examples.SimplePageRankComputation -vip ginput/tiny_graph.txt -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -op /user/$USER/goutput/pagerank_tiny_$NOW -w 1 -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat -mc org.apache.giraph.examples.SimplePageRankComputation\$SimplePageRankMasterCompute

########################################################################
# RUN PAGERANK on generated graph  (WattsStrogaz generator InputFormat)
# (OK)
########################################################################
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=$JTADDRESS -libjars giraph-core.jar org.apache.giraph.examples.SimplePageRankComputation2 -w 1 -mc org.apache.giraph.examples.SimplePageRankComputation2\$SimplePageRankMasterCompute2 -wc org.apache.giraph.examples.SimplePageRankComputation2\$SimplePageRankWorkerContext2 \
#-vif org.apache.giraph.io.formats.WattsStrogatzVertexInputFormat -op /user/$USER/goutput/pagerank_watts_$NOW -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat -ca wattsStrogatz.aggregateVertices=5000 -ca wattsStrogatz.edgesPerVertex=50 -ca wattsStrogatz.beta=0.5 -ca wattsStrogatz.seed=1

########################################################################
# RUN PAGERANK on generated graph  (PseudoRandom generator InputFormat)
# (OK)
########################################################################
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=$JTADDRESS -libjars giraph-core.jar org.apache.giraph.examples.SimplePageRankComputation2 -w 2 -mc org.apache.giraph.examples.SimplePageRankComputation2\$SimplePageRankMasterCompute2 -wc org.apache.giraph.examples.SimplePageRankComputation2\$SimplePageRankWorkerContext2 \
#-vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat -op /user/$USER/goutput/pagerank_pseudo_$NOW -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat -ca giraph.pseudoRandomInputFormat.aggregateVertices=500 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=5 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=0.2








#######################################################
# RUN ConnectedComponents on tiny graph    !!! FAILS !!!
# 
#######################################################
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=$JTADDRESS -libjars giraph-core.jar org.apache.giraph.examples.ConnectedComponentsComputation -vip ginput/tiny_graph.txt -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -op /user/$USER/goutput/connected_component_$NOW -w 1 -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat

######################################################################################
#
# Show what algorithms can be used with a given InputFormat
#
#######################################################
# illustrates the problem of specialiyed InputFormats      !!!!! FAILS !!!!!
#######################################################
#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -Dmapreduce.jobtracker.address=127.0.0.1 -libjars giraph-core.jar org.apache.giraph.examples.SimpleShortestPathsComputation -vif org.apache.giraph.io.formats.PseudoRandomVertexInputFormat -eif org.apache.giraph.io.formats.PseudoRandomEdgeInputFormat -vof org.apache.giraph.io.formats.JsonBase64VertexOutputFormat -op /user/$USER/goutput/randomGraph_$NOW -w 1 -ca giraph.pseudoRandomInputFormat.edgesPerVertex=1 -ca giraph.pseudoRandomInputFormat.aggregateVertices=10 -ca giraph.pseudoRandomInputFormat.localEdgesMinRatio=2 -ca SimpleShortestPathsVertex.source=2

#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SimpleShortestPathsVertex -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/$USER/ginput/tiny_graph.txt -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/$USER/goutput/shortestpaths_$NOW -w 1

#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SimpleOutDegreeCountVertex2 -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/$USER/ginput/tiny_graph.txt -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/$USER/goutput/outdegree_$NOW -w 1

#hadoop jar giraph-ex.jar org.apache.giraph.GiraphRunner -Dgiraph.zkList=$ZKSERVER:$ZKPORT -libjars giraph-core.jar org.apache.giraph.examples.SimpleInDegreeCountVertex2 -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/$USER/ginput/tiny_graph.txt -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/$USER/goutput/indegree_$NOW -w 1









