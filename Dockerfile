# Based on the code from https://github.com/cdorde/mybirt
FROM tomcat:8.0
MAINTAINER "Ramón Ontiveros <ramontiveros@gmail.com>"

RUN apt-get -y --force-yes install wget
RUN apt-get -y --force-yes install unzip

#COPY birt-runtime-4.6.0-20160607.zip /tmp/birt.zip
RUN wget -nv "http://download.eclipse.org/birt/downloads/drops/R-R1-4.6.0-201606072112/birt-runtime-4.6.0-20160607.zip" -P /tmp -O /tmp/birt.zip
RUN unzip "/tmp/birt.zip" -d /tmp/birt
RUN mv "/tmp/birt/birt.war" "/usr/local/tomcat/webapps/birt.war"
RUN rm /tmp/birt.zip
RUN rm -f -r "/tmp/birt"
RUN unzip /usr/local/tomcat/webapps/birt.war -d /usr/local/tomcat/webapps/birt
RUN cd /usr/local/tomcat && ln -s /etc/tomcat conf

#Add JDBC
#COPY ojdbc6.jar /usr/local/tomcat/webapps/birt/WEB-INF/lib
RUN wget "http://www.java2s.com/Code/JarDownload/ojdbc6/ojdbc6.jar.zip" -P /tmp -O /tmp/ojdbc6.jar.zip
RUN unzip /tmp/ojdbc6.jar.zip -d /tmp
RUN cp /tmp/ojdbc6.jar /usr/local/tomcat/webapps/birt/WEB-INF/lib
RUN rm /tmp/ojdbc6.jar.zip
RUN rm /tmp/ojdbc6.jar

# Map Reports folder
VOLUME /usr/local/tomcat/webapps/birt/reports
VOLUME /usr/local/tomcat/webapps/birt
VOLUME /usr/share/fonts/truetype

#Start
CMD ["catalina.sh", "run"]

#Port
EXPOSE 8080
