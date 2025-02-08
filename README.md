# BDI pre-study on event choreography with e-delivery

## Main question

What existing standards, frameworks and developments could BDI leverage to evolve the [Logistics Event KIT](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit) with regard to the delivery of events, linked data and other messages?

## Experiment: minimum viable e-delivery

Planned approach:

- [ ] Send a “hello world” message from one deployment of a common open source e-delivery such as [Domibus](https://github.com/cefedelivery/domibus) to another deployment; compare steps to steps of deploying a custom web-based integration without e-delivery.
- [ ] Visualise in sequence diagrams and example messages the protocol steps for this “hello world” message; compare overhead with that of a custom web-based integration without e-delivery, such as in the “Trusted Good Release” and “Delegation” demos ([phases 1 and 2 report](https://bdi.gitbook.io/public/reference-architecture/trust-kit/demos/trusted-goods-release-and-delegation), [phase 3 architecture description](https://github.com/Basic-Data-Infrastructure/demo-vertrouwde-goederenafgifte/blob/fase-3/doc/architecture/architecture-description.md)).
- [ ] Reflect on needed additional steps to make it applicable for e.g. BDI virtual data networks.

### Notes

For the first experiment, we adapt the Domibus [Quick Start Guide v5.1.6](https://docs.edelivery.tech.ec.europa.eu/domibus/5.1.6/#quickstart).

To run the Docker containers:

    $ cd domibus
    $ sudo docker compose up

You may need to try that twice.

To get the admin passwords:

    $ sudo docker compose logs | grep "Default password for user \[admin\] is"

To visit the Administration Console instances, use different browser sessions:

- http://localhost:8080/domibus/ (blue)
- http://localhost:8081/domibus/ (red)

For each instance, change the admin password and upload the associated PMode.

Now send a message:

    $ sh submit-hello-world.sh

You can observe the message in the Messages tab of each Administration Console. Or use `tcpdump`:

```
$ sudo docker run -it --rm --net container:domibus-web-red-1 nicolaka/netshoot tcpdump -i any -v -N -A 'port 8080'
tcpdump: data link type LINUX_SLL2
tcpdump: listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
17:45:26.441025 eth0  In  IP (tos 0x0, ttl 64, id 6388, offset 0, flags [DF], proto TCP (6), length 60)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [S], cksum 0x585e (incorrect -> 0x1684), seq 2217128358, win 64240, options [mss 1460,sackOK,TS val 987067212 ecr 0,nop,wscale 7], length 0
E..<..@.@................&..........X^.........
:.sL........
17:45:26.441056 eth0  Out IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    85bd0401c4a8.8080 > domibus-web-blue-1.56028: Flags [S.], cksum 0x585e (incorrect -> 0x7647), seq 3454219953, ack 2217128359, win 65160, options [mss 1460,sackOK,TS val 221547210 ecr 987067212,nop,wscale 7], length 0
E..<..@.@.................6..&......X^.........
.4..:.sL....
17:45:26.441098 eth0  In  IP (tos 0x0, ttl 64, id 6389, offset 0, flags [DF], proto TCP (6), length 52)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [.], cksum 0x5856 (incorrect -> 0xa1a6), ack 1, win 502, options [nop,nop,TS val 987067212 ecr 221547210], length 0
E..4..@.@................&....6.....XV.....
:.sL.4..
17:45:26.780656 eth0  In  IP (tos 0x0, ttl 64, id 6390, offset 0, flags [DF], proto TCP (6), length 433)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [P.], cksum 0x59d3 (incorrect -> 0xb006), seq 1:382, ack 1, win 502, options [nop,nop,TS val 987067551 ecr 221547210], length 381: HTTP, length: 381
    POST /domibus/services/msh HTTP/1.1
    Content-Type: multipart/related; type="application/soap+xml"; boundary="uuid:be3de09a-333f-4442-a1d6-f9cb0ae8c2f9"; start="<root.message@cxf.apache.org>"; start-info="application/soap+xml"
    Accept: */*
    User-Agent: Apache-CXF/3.5.9
    Cache-Control: no-cache
    Pragma: no-cache
    Host: web-red:8080
    Connection: keep-alive
    Content-Length: 7742
    
E.....@.@..!.............&....6.....Y......
:.t..4..POST /domibus/services/msh HTTP/1.1
Content-Type: multipart/related; type="application/soap+xml"; boundary="uuid:be3de09a-333f-4442-a1d6-f9cb0ae8c2f9"; start="<root.message@cxf.apache.org>"; start-info="application/soap+xml"
Accept: */*
User-Agent: Apache-CXF/3.5.9
Cache-Control: no-cache
Pragma: no-cache
Host: web-red:8080
Connection: keep-alive
Content-Length: 7742


17:45:26.780693 eth0  Out IP (tos 0x0, ttl 64, id 3309, offset 0, flags [DF], proto TCP (6), length 52)
    85bd0401c4a8.8080 > domibus-web-blue-1.56028: Flags [.], cksum 0x5856 (incorrect -> 0x9d7e), ack 382, win 507, options [nop,nop,TS val 221547549 ecr 987067551], length 0
E..4..@.@.................6..&.$....XV.....
.4..:.t.
17:45:26.780766 eth0  In  IP (tos 0x0, ttl 64, id 6391, offset 0, flags [DF], proto TCP (6), length 7292)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [P.], cksum 0x749e (incorrect -> 0xd12c), seq 382:7622, ack 1, win 502, options [nop,nop,TS val 987067551 ecr 221547549], length 7240: HTTP
E..|..@.@..U.............&.$..6.....t......
:.t..4..
--uuid:be3de09a-333f-4442-a1d6-f9cb0ae8c2f9
Content-Type: application/soap+xml; charset=UTF-8
Content-Transfer-Encoding: binary
Content-ID: <root.message@cxf.apache.org>

<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope"><env:Header><eb:Messaging xmlns:eb="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" env:mustUnderstand="true" wsu:Id="_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><eb:UserMessage mpc="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/defaultMPC"><eb:MessageInfo><eb:Timestamp>2025-02-08T17:45:26.000Z</eb:Timestamp><eb:MessageId>7a491929-e644-11ef-a945-0242ac130004@domibus.eu</eb:MessageId></eb:MessageInfo><eb:PartyInfo><eb:From><eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:unregistered">domibus-blue</eb:PartyId><eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/initiator</eb:Role></eb:From><eb:To><eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:unregistered">domibus-red</eb:PartyId><eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/responder</eb:Role></eb:To></eb:PartyInfo><eb:CollaborationInfo><eb:Service type="tc1">bdx:noprocess</eb:Service><eb:Action>TC1Leg1</eb:Action><eb:ConversationId>7a4f5aba-e644-11ef-a945-0242ac130004@domibus.eu</eb:ConversationId></eb:CollaborationInfo><eb:MessageProperties><eb:Property name="originalSender">urn:oasis:names:tc:ebcore:partyid-type:unregistered:C1</eb:Property><eb:Property name="finalRecipient">urn:oasis:names:tc:ebcore:partyid-type:unregistered:C4</eb:Property></eb:MessageProperties><eb:PayloadInfo><eb:PartInfo href="cid:message"><eb:PartProperties><eb:Property name="MimeType">text/xml</eb:Property><eb:Property name="CompressionType">application/gzip</eb:Property></eb:PartProperties></eb:PartInfo></eb:PayloadInfo></eb:UserMessage></eb:Messaging><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" env:mustUnderstand="true"><xenc:EncryptedKey xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" Id="EK-7b569675-f789-4630-b8c2-997a3c56bd05"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2009/xmlenc11#rsa-oaep"><ds:DigestMethod xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><xenc11:MGF xmlns:xenc11="http://www.w3.org/2009/xmlenc11#" Algorithm="http://www.w3.org/2009/xmlenc11#mgf1sha256"/></xenc:EncryptionMethod><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><wsse:SecurityTokenReference><wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">7AJeAnEL5EE5l3lLc+EoFpOfJCo=</wsse:KeyIdentifier></wsse:SecurityTokenReference></ds:KeyInfo><xenc:CipherData><xenc:CipherValue>dx6XzRwJCUPKnfkjDGVOcJS3L8vcHKZMVyHQImn5mH3CzviAx9BKMR6fmEAOsBscOfOTqfVA5KlsP4CkW41NZB2SBe5KPq/9zBx8/1ZuD0vZkIG2hmakWCyDLU31hlXV+yT2E2aiFPzuBSaxFFvgBZllXTHUYaDnOmQODdFjWaiJXpK6JupGBpYHx+1sNubDHLPC9fL587cOcTu9kgWJ2cEQsXGRvsCVG7KdHxYHacTR99dV3mSF3mng3UrIOgLIitVSYegYM04qxixuUgjJCYq5DVQ2TPwB7yKNDhYXU3BLs3ZAQsu7L1/tVILAzAE4XTTFkl7aVSoEH51ufIsw4Q==</xenc:CipherValue></xenc:CipherData><xenc:ReferenceList><xenc:DataReference URI="#ED-c150b572-c33f-4d38-a5db-8cf6de7abbc7"/></xenc:ReferenceList></xenc:EncryptedKey><xenc:EncryptedData xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" Id="ED-c150b572-c33f-4d38-a5db-8cf6de7abbc7" MimeType="application/gzip" Type="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Only"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2009/xmlenc11#aes128-gcm"/><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><wsse:SecurityTokenReference xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsse11="http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd" wsse11:TokenType="http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#EncryptedKey"><wsse:Reference URI="#EK-7b569675-f789-4630-b8c2-997a3c56bd05"/></wsse:SecurityTokenReference></ds:KeyInfo><xenc:CipherData><xenc:CipherReference URI="cid:message"><xenc:Transforms><ds:Transform xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Ciphertext-Transform"/></xenc:Transforms></xenc:CipherReference></xenc:CipherData></xenc:EncryptedData><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8d1228ed-949e-4883-8f09-16a926e8448c"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="env"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/><ds:Reference URI="#_26eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>2pApXDw8KikVDtCFNBz38djNGTshZZBO7gn70A1ljw8=</ds:DigestValue></ds:Reference><ds:Reference URI="#_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>LmbK4ctt1B+BpTNxQIGJ7ZR4DmMU6bB7OE382oHYrEw=</ds:DigestValue></ds:Reference><ds:Reference URI="cid:message"><ds:Transforms><ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Signature-Transform"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>/uEUj2yWpAgWStctc7U5VUHjt4rIGUXfbstuwDyTx7I=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>KLF82BLor8U5mXGk6VvSVcjs6KHWqYdjWhVtEbiRbYzcEDTPqrgUd7HO3tRxtE3lBMPU3HHO4tUrX3iJI0uPgLKMgXmLMYp15GQMmdX7MCa2Vgr9nPPlmKeRe4YvEgNa2JMwn6R7dfUo5Re0+xrrMPiugmPF9gsl97AKo/FYfbXxCw++1ObEe0jig85gWGt0jwy5lMw5aLjIsHiitZnBetWLu5fYFfsc0KjIVkHdcUX5TVzLPmUmHJ96SC7Kq+VczIyhpYuBQcztAB+rc7aYVA/ZSWzEgsNxxPucoIzP8fLT9uKkXqz9x7yOXuB0XbHbZDUer3WeRDL8ixfg7eS1KA==</ds:SignatureValue><ds:KeyInfo Id="KI-49a62f9d-6d07-43de-8e3e-066030541b72"><wsse:SecurityTokenReference xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="STR-8c0c0bfb-0cfd-41cd-926b-c34912a6c659"><wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">HPqVjsgDN900CCgLwAvG03x+R2I=</wsse:KeyIdentifier></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></en
17:45:26.780775 eth0  Out IP (tos 0x0, ttl 64, id 3310, offset 0, flags [DF], proto TCP (6), length 52)
    85bd0401c4a8.8080 > domibus-web-blue-1.56028: Flags [.], cksum 0x5856 (incorrect -> 0x80cb), ack 7622, win 614, options [nop,nop,TS val 221547549 ecr 987067551], length 0
E..4..@.@.................6..&.l...fXV.....
.4..:.t.
17:45:26.780789 eth0  In  IP (tos 0x0, ttl 64, id 6396, offset 0, flags [DF], proto TCP (6), length 554)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [P.], cksum 0x5a4c (incorrect -> 0xc263), seq 7622:8124, ack 1, win 502, options [nop,nop,TS val 987067551 ecr 221547549], length 502: HTTP
E..*..@.@................&.l..6.....ZL.....
:.t..4..v:Header><env:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="_26eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"/></env:Envelope>
--uuid:be3de09a-333f-4442-a1d6-f9cb0ae8c2f9
Content-Type: application/octet-stream
Content-Transfer-Encoding: binary
Content-ID: <message>

m..........t...,p.UV.......m....'   z&5o'...'...:.......A^.k.4b..8...?3.........}.D.7P.:k.2....bg....D:.
--uuid:be3de09a-333f-4442-a1d6-f9cb0ae8c2f9--
17:45:26.780793 eth0  Out IP (tos 0x0, ttl 64, id 3311, offset 0, flags [DF], proto TCP (6), length 52)
    85bd0401c4a8.8080 > domibus-web-blue-1.56028: Flags [.], cksum 0x5856 (incorrect -> 0x7ebe), ack 8124, win 637, options [nop,nop,TS val 221547549 ecr 987067551], length 0
E..4..@.@.................6..&.b...}XV.....
.4..:.t.
17:45:29.023743 eth0  Out IP (tos 0x0, ttl 64, id 3312, offset 0, flags [DF], proto TCP (6), length 5356)
    85bd0401c4a8.8080 > domibus-web-blue-1.56028: Flags [P.], cksum 0x6d0e (incorrect -> 0x99a9), seq 1:5305, ack 8124, win 637, options [nop,nop,TS val 221549792 ecr 987067551], length 5304: HTTP, length: 5304
    HTTP/1.1 200 
    Content-Type: application/soap+xml;charset=UTF-8
    Content-Length: 5130
    Date: Sat, 08 Feb 2025 17:45:29 GMT
    Keep-Alive: timeout=20
    Connection: keep-alive
    
    <S12:Envelope xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:eb3="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/" xmlns:ebbp="http://docs.oasis-open.org/ebxml-bp/ebbp-signals-2.0" xmlns:ebint="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/multihop/200902/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><S12:Header><eb3:Messaging S12:mustUnderstand="true" id="_ebmessaging_N65541" wsu:Id="_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><eb3:SignalMessage><eb3:MessageInfo><eb3:Timestamp>2025-02-08T17:45:28.000Z</eb3:Timestamp><eb3:MessageId>7bd0f190-e644-11ef-b149-0242ac130005@domibus.eu</eb3:MessageId><eb3:RefToMessageId>7a491929-e644-11ef-a945-0242ac130004@domibus.eu</eb3:RefToMessageId></eb3:MessageInfo><eb3:Receipt><ebbp:NonRepudiationInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="#_26eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>2pApXDw8KikVDtCFNBz38djNGTshZZBO7gn70A1ljw8=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="#_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>LmbK4ctt1B+BpTNxQIGJ7ZR4DmMU6bB7OE382oHYrEw=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="cid:message"><ds:Transforms><ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Signature-Transform"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>/uEUj2yWpAgWStctc7U5VUHjt4rIGUXfbstuwDyTx7I=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation></ebbp:NonRepudiationInformation></eb3:Receipt></eb3:SignalMessage></eb3:Messaging><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" S12:mustUnderstand="true"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-81d53673-4c65-4407-9ba4-dadac687a9ab"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="S12 ds eb3 ebbp ebint wsa wsse wsu"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/><ds:Reference URI="#N65667"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="ds eb3 ebbp ebint wsa wsse"/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>NBmyTYEkY9uwsu8bCkiPxgjDiHrxETu8f1q1yxvz1Kk=</ds:DigestValue></ds:Reference><ds:Reference URI="#_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="ds ebbp ebint wsa wsse"/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>Q6gfkrT6eL/Fqiea5ZD/+kxFbHp76059zq3cT5IWwp4=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>xV9K/W2vPWwUQJWWbtgZI6oZzaGyuLU9833C8fRDgppTf2etY1efAooPIokUQoVKLdhezj9wRNUHlh8HXxmLZNa8csXx9s9E2MKNB5BWN67LilcKt05VP6PcW8b4Hi/hl8b+RUUIVDdw7Q4Iba2E12CIJkDxd4OJoCYqA60LgIlquRhVFwhg4Wgpmh0QRoJ30ki0B5X9CX9T2D84RNt8YJl191c2r/BznYcjY93/d6CV5BVsKglLqz25AOupnxCd6OuIwrorVeCmuVofSb3TGdOwWZJHXUe/5L4TsYUHvvd/GO6H0XVr60hIFDBe9LTy+2twcO5Pme8eQDP309uPLA==</ds:SignatureValue><ds:KeyInfo Id="KI-8d88b41e-2616-4070-965e-01592222ae6a"><wsse:SecurityTokenReference xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="STR-05eb81ad-ae46-48c3-bad8-1ce94c9ebb19"><wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">7AJeAnEL5EE5l3lLc+EoFpOfJCo=</wsse:KeyIdentifier></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></S12:Header><S12:Body wsu:Id="N65667"/></S12:Envelope> [|http]
E.....@.@.................6..&.b...}m......
.4..:.t.HTTP/1.1 200 
Content-Type: application/soap+xml;charset=UTF-8
Content-Length: 5130
Date: Sat, 08 Feb 2025 17:45:29 GMT
Keep-Alive: timeout=20
Connection: keep-alive

<S12:Envelope xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:eb3="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/" xmlns:ebbp="http://docs.oasis-open.org/ebxml-bp/ebbp-signals-2.0" xmlns:ebint="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/multihop/200902/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><S12:Header><eb3:Messaging S12:mustUnderstand="true" id="_ebmessaging_N65541" wsu:Id="_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><eb3:SignalMessage><eb3:MessageInfo><eb3:Timestamp>2025-02-08T17:45:28.000Z</eb3:Timestamp><eb3:MessageId>7bd0f190-e644-11ef-b149-0242ac130005@domibus.eu</eb3:MessageId><eb3:RefToMessageId>7a491929-e644-11ef-a945-0242ac130004@domibus.eu</eb3:RefToMessageId></eb3:MessageInfo><eb3:Receipt><ebbp:NonRepudiationInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="#_26eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>2pApXDw8KikVDtCFNBz38djNGTshZZBO7gn70A1ljw8=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="#_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>LmbK4ctt1B+BpTNxQIGJ7ZR4DmMU6bB7OE382oHYrEw=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation><ebbp:MessagePartNRInformation><ds:Reference xmlns:env="http://www.w3.org/2003/05/soap-envelope" URI="cid:message"><ds:Transforms><ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Signature-Transform"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>/uEUj2yWpAgWStctc7U5VUHjt4rIGUXfbstuwDyTx7I=</ds:DigestValue></ds:Reference></ebbp:MessagePartNRInformation></ebbp:NonRepudiationInformation></eb3:Receipt></eb3:SignalMessage></eb3:Messaging><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" S12:mustUnderstand="true"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-81d53673-4c65-4407-9ba4-dadac687a9ab"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="S12 ds eb3 ebbp ebint wsa wsse wsu"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/><ds:Reference URI="#N65667"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="ds eb3 ebbp ebint wsa wsse"/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>NBmyTYEkY9uwsu8bCkiPxgjDiHrxETu8f1q1yxvz1Kk=</ds:DigestValue></ds:Reference><ds:Reference URI="#_16eda8185c3dafe37ba232439ee5c0c914c2e16be9acfb0083fb48be5b5ce99f8"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="ds ebbp ebint wsa wsse"/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/><ds:DigestValue>Q6gfkrT6eL/Fqiea5ZD/+kxFbHp76059zq3cT5IWwp4=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>xV9K/W2vPWwUQJWWbtgZI6oZzaGyuLU9833C8fRDgppTf2etY1efAooPIokUQoVKLdhezj9wRNUHlh8HXxmLZNa8csXx9s9E2MKNB5BWN67LilcKt05VP6PcW8b4Hi/hl8b+RUUIVDdw7Q4Iba2E12CIJkDxd4OJoCYqA60LgIlquRhVFwhg4Wgpmh0QRoJ30ki0B5X9CX9T2D84RNt8YJl191c2r/BznYcjY93/d6CV5BVsKglLqz25AOupnxCd6OuIwrorVeCmuVofSb3TGdOwWZJHXUe/5L4TsYUHvvd/GO6H0XVr60hIFDBe9LTy+2twcO5Pme8eQDP309uPLA==</ds:SignatureValue><ds:KeyInfo Id="KI-8d88b41e-2616-4070-965e-01592222ae6a"><wsse:SecurityTokenReference xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="STR-05eb81ad-ae46-48c3-bad8-1ce94c9ebb19"><wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">7AJeAnEL5EE5l3lLc+EoFpOfJCo=</wsse:KeyIdentifier></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></S12:Header><S12:Body wsu:Id="N65667"/></S12:Envelope>
17:45:29.023888 eth0  In  IP (tos 0x0, ttl 64, id 6397, offset 0, flags [DF], proto TCP (6), length 52)
    domibus-web-blue-1.56028 > 85bd0401c4a8.8080: Flags [.], cksum 0x5856 (incorrect -> 0x58b4), ack 5305, win 584, options [nop,nop,TS val 987069795 ecr 221549792], length 0
E..4..@.@................&.b..Kj...HXV.....
:.}c.4..
^C
11 packets captured
11 packets received by filter
0 packets dropped by kernel
```
