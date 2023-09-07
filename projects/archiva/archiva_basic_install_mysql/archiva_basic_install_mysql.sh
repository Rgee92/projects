#!/bin/bash -

echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
apt -y install mysql-server
apt -y install tomcat8
apt -y install maven

mysql --host='127.0.0.1' --user='root' --password='root' -e "CREATE USER 'archiva_users'@'%' IDENTIFIED BY 'password';"
mysql --host='127.0.0.1' --user='root' --password='root' -e "GRANT ALL PRIVILEGES ON archiva_users.* TO 'archiva_users'@'%';"
mysql --host='127.0.0.1' --user='root' --password='root' -e "CREATE DATABASE archiva_users;"
mysql --host='127.0.0.1' --user='root' --password='root' -e "CREATE USER 'archiva'@'%' IDENTIFIED BY 'password';"
mysql --host='127.0.0.1' --user='root' --password='root' -e "GRANT ALL PRIVILEGES ON archiva.* TO 'archiva'@'%';"
mysql --host='127.0.0.1' --user='root' --password='root' -e "CREATE DATABASE archiva;"

# derby plugin
mvn dependency:get -Dartifact=org.apache.derby:derby:10.12.1.1
mvn dependency:copy -Dartifact=org.apache.derby:derby:10.12.1.1 -DoutputDirectory=/usr/share/tomcat8/lib/
# activation plugin
mvn dependency:get -Dartifact=javax.activation:activation:1.1
mvn dependency:copy -Dartifact=javax.activation:activation:1.1 -DoutputDirectory=/usr/share/tomcat8/lib/
# mail plugin
mvn dependency:get -Dartifact=javax.mail:mail:1.4
mvn dependency:copy -Dartifact=javax.mail:mail:1.4 -DoutputDirectory=/usr/share/tomcat8/lib/
# mysql plugin
mvn dependency:get -Dartifact=mysql:mysql-connector-java:5.1.40
mvn dependency:copy -Dartifact=mysql:mysql-connector-java:5.1.40 -DoutputDirectory=/usr/share/tomcat8/lib/

# configuration is stored in ~/.m2/archiva.xml by default
cat > /var/lib/tomcat8/conf/Catalina/localhost/archiva.xml <<EOF
<Context path="/archiva"
         docBase="/var/lib/tomcat8/webapps/archiva.war">
 
  <Resource name="jdbc/users"
            auth="Container"
            type="javax.sql.DataSource"
            driverClassName="com.mysql.jdbc.Driver"
            url="jdbc:mysql://localhost:3306/archiva_users" username="archiva_users" password="password" />
 
  <Resource name="jdbc/archiva"
            auth="Container"
            type="javax.sql.DataSource"
            driverClassName="com.mysql.jdbc.Driver"
            url="jdbc:mysql://localhost:3306/archiva" username="archiva" password="password" />
 
  <Resource name="mail/Session"
            auth="Container"
            type="javax.mail.Session"
            mail.smtp.host="localhost"/>
</Context>
EOF

cat >> /usr/share/tomcat8/bin/setenv.sh <<EOF
export CATALINA_OPTS="-Djavax.sql.DataSource.Factory=org.apache.commons.dbcp.BasicDataSourceFactory -Djdbc.drivers=com.mysql.jdbc.Driver -Dappserver.home=\$CATALINA_HOME -Dappserver.base=\$CATALINA_HOME"
EOF

# create default repository directory path
mkdir -p /usr/share/tomcat8/repositories
chown -R tomcat8:tomcat8 /usr/share/tomcat8/repositories

# create default logs directory
mkdir -p /usr/share/tomcat8/logs
chown -R tomcat8:tomcat8 /usr/share/tomcat8/logs

# create default database directory
mkdir -p /var/lib/tomcat8/database
chown -R tomcat8:tomcat8 /var/lib/tomcat8/database

# create directory for jcr
mkdir -p /usr/share/tomcat8/data/jcr/workspaces
chown -R tomcat8:tomcat8 /usr/share/tomcat8/data

# create default maven directory - used by archiva to create (or read) archiva.xml
mkdir -p /usr/share/tomcat8/.m2
chown -R tomcat8:tomcat8 /usr/share/tomcat8/.m2

# download and install archiva
cd /var/tmp
wget --quiet http://mirror.reverse.net/pub/apache/archiva/2.2.1/binaries/apache-archiva-2.2.1.war
cp /var/tmp/apache-archiva-2.2.1.war /var/lib/tomcat8/webapps/archiva.war

systemctl restart tomcat8.service
