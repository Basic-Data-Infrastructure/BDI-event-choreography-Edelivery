FROM ubuntu:latest

RUN apt update && apt install -y unzip openjdk-21-jre-headless

ADD https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.1.6/domibus-msh-distribution-5.1.6-tomcat-full.zip /tmp/download/domibus.zip
RUN unzip -d /tmp/download /tmp/download/domibus.zip
RUN mv /tmp/download/domibus /opt
RUN chmod +x /opt/domibus/bin/catalina.sh

ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar /opt/domibus/lib/mysql-connector-java-8.0.30.jar

ADD conf/domibus /etc/domibus

WORKDIR /opt/domibus
ENV CATALINA_HOME=/opt/domibus
ENV JAVA_OPTS="-Xms128m -Xmx1024m -Ddomibus.config.location=/etc/domibus"

ENTRYPOINT ["bin/catalina.sh"]
CMD ["run"]
