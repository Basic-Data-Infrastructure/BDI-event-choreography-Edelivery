#!/bin/sh
export CATALINA_HOME=/opt/domibus
export JAVA_OPTS="$JAVA_OPTS -Xms128m -Xmx1024m"
export JAVA_OPTS="$JAVA_OPTS -Ddomibus.config.location=/etc/domibus"
