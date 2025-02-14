if [ -f done ]; then
	exit 0
fi

curl -v -H "Authorization: Basic cGFkbWluOnBhc3N3b3Jk" -F description=Blue -F file=@domibus-gw-sample-pmode-blue.xml http://web-blue:8080/domibus/ext/pmode
curl -v -H "Authorization: Basic cGFkbWluOnBhc3N3b3Jk" -F description=Red -F file=@domibus-gw-sample-pmode-red.xml http://web-red:8080/domibus/ext/pmode

touch done
