FROM ubuntu:latest

RUN apt update && apt install -y curl unzip openjdk-21-jre-headless

RUN curl -O https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.1.6/domibus-msh-distribution-5.1.6-tomcat-full.zip
RUN unzip -d /tmp/download domibus-msh-distribution-5.1.6-tomcat-full.zip
RUN mv /tmp/download/domibus /opt
RUN chmod +x /opt/domibus/bin/catalina.sh

RUN curl -o /opt/domibus/lib/mysql-connector-java-8.0.30.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar

WORKDIR /opt/domibus
ENV CATALINA_HOME=/opt/domibus
ENV JAVA_OPTS="-Xms128m -Xmx1024m -Ddomibus.config.location=/etc/domibus"

ENTRYPOINT ["bin/catalina.sh"]
CMD ["run"]
