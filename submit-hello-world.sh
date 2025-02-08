#!/bin/sh

curl -v \
  -H "Content-Type: application/soap+xml" \
  --data-binary @submit-hello-world.xml \
  http://localhost:8080/domibus/services/wsplugin
