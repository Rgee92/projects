#!/bin/bash

version="5.4.0"

sudo apt-get -y update

# requires 1.7
# You will need the Java Runtime Environment (JRE) version 1.7 or higher
# You will need the JDK to run bin/solr start
apt-get -y install default-jdk

# Install instructions from:
# https://cwiki.apache.org/confluence/display/solr/Installing+Solr

curl --output solr-${version}.tgz http://apache.arvixe.com/lucene/solr/${version}/solr-${version}.tgz
tar zxf solr-${version}.tgz
cd solr-${version}/

# Run Solr
# https://cwiki.apache.org/confluence/display/solr/Running+Solr
bin/solr start
