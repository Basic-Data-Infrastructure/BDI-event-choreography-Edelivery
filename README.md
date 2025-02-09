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

You can observe the message in the Messages tab of each Administration Console. To observe network traffic to the red instance, check the `tcpdump` logs:

    $ sudo docker compose logs tcpdump -f

### Example message sequence

These data were generated using the above steps.

Request:

```
POST /domibus/services/msh HTTP/1.1
Content-Type: multipart/related; type="application/soap+xml"; boundary="uuid:2f2bf39a-f924-4332-b39a-4d7bbb96feba"; start="<root.message@cxf.apache.org>"; start-info="application/soap+xml"
Accept: */*
User-Agent: Apache-CXF/3.5.9
Cache-Control: no-cache
Pragma: no-cache
Host: web-red:8080
Connection: keep-alive
Content-Length: 7742

--uuid:2f2bf39a-f924-4332-b39a-4d7bbb96feba
Content-Type: application/soap+xml; charset=UTF-8
Content-Transfer-Encoding: binary
Content-ID: <root.message@cxf.apache.org>

-%<- request SOAP envelope extracted, see below -%<-

--uuid:2f2bf39a-f924-4332-b39a-4d7bbb96feba
Content-Type: application/octet-stream
Content-Transfer-Encoding: binary
Content-ID: <message>

-%<- gzip-encoded XML hello world message omitted -%<-

--uuid:2f2bf39a-f924-4332-b39a-4d7bbb96feba--
```

Request SOAP envelope, with XML reformatted:

```xml
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
  <env:Header>
    <eb:Messaging env:mustUnderstand="true" wsu:Id="_12e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39" xmlns:eb="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
      <eb:UserMessage mpc="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/defaultMPC">
        <eb:MessageInfo>
          <eb:Timestamp>2025-02-09T09:09:38.000Z</eb:Timestamp>
          <eb:MessageId>96757329-e6c5-11ef-8dca-0242ac130004@domibus.eu</eb:MessageId>
        </eb:MessageInfo>
        <eb:PartyInfo>
          <eb:From>
            <eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:unregistered">domibus-blue</eb:PartyId>
            <eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/initiator</eb:Role>
          </eb:From>
          <eb:To>
            <eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:unregistered">domibus-red</eb:PartyId>
            <eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/responder</eb:Role>
          </eb:To>
        </eb:PartyInfo>
        <eb:CollaborationInfo>
          <eb:Service type="tc1">bdx:noprocess</eb:Service>
          <eb:Action>TC1Leg1</eb:Action>
          <eb:ConversationId>967c02da-e6c5-11ef-8dca-0242ac130004@domibus.eu</eb:ConversationId>
        </eb:CollaborationInfo>
        <eb:MessageProperties>
          <eb:Property name="originalSender">urn:oasis:names:tc:ebcore:partyid-type:unregistered:C1</eb:Property>
          <eb:Property name="finalRecipient">urn:oasis:names:tc:ebcore:partyid-type:unregistered:C4</eb:Property>
        </eb:MessageProperties>
        <eb:PayloadInfo>
          <eb:PartInfo href="cid:message">
            <eb:PartProperties>
              <eb:Property name="MimeType">text/xml</eb:Property>
              <eb:Property name="CompressionType">application/gzip</eb:Property>
            </eb:PartProperties>
          </eb:PartInfo>
        </eb:PayloadInfo>
      </eb:UserMessage>
    </eb:Messaging>
    <wsse:Security env:mustUnderstand="true" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
      <xenc:EncryptedKey Id="EK-6355f5cf-ee15-444e-8669-8eb2118142ed" xmlns:xenc="http://www.w3.org/2001/04/xmlenc#">
        <xenc:EncryptionMethod Algorithm="http://www.w3.org/2009/xmlenc11#rsa-oaep">
          <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" xmlns:ds="http://www.w3.org/2000/09/xmldsig#"/>
          <xenc11:MGF Algorithm="http://www.w3.org/2009/xmlenc11#mgf1sha256" xmlns:xenc11="http://www.w3.org/2009/xmlenc11#"/>
        </xenc:EncryptionMethod>
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
          <wsse:SecurityTokenReference>
            <wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">7AJeAnEL5EE5l3lLc+EoFpOfJCo=</wsse:KeyIdentifier>
          </wsse:SecurityTokenReference>
        </ds:KeyInfo>
        <xenc:CipherData>
          <xenc:CipherValue>JA/25HTJ9JO6Hol8e20C/hi5zAlM5fFFxtnS5Ow26zcSooF9Aku5jq08eTHRYBwNvfvYtyxAOfhz/rcCD+MkyMnUZtP5FSwxU72Qp4XhP4Prytkblmkbwk04bej8z2B1cWTZVV/HGf6dIG3bvYN8dpFsmTb1jCiXEino8JIY3z8mCDuPFTlDKVXpLOgV3Vnzs46g5FbIj4FFJwbqrSvZPG2mkE4g5ZJU2bvjyVcFYu0SqHIElqbkoVcRVe4QwZAfNj492CVjhJHNBKNzSawLV35pQLo+4DYKKDVnEoW7rRZsBE/a8EWrVYc3U9Tpr5kjfQSY/yTTJ6WWGWmpY/uLLA==</xenc:CipherValue>
        </xenc:CipherData>
        <xenc:ReferenceList>
          <xenc:DataReference URI="#ED-e80a1b58-2b43-4370-9c9a-00a9d77b2c8a"/>
        </xenc:ReferenceList>
      </xenc:EncryptedKey>
      <xenc:EncryptedData Id="ED-e80a1b58-2b43-4370-9c9a-00a9d77b2c8a" MimeType="application/gzip" Type="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Only" xmlns:xenc="http://www.w3.org/2001/04/xmlenc#">
        <xenc:EncryptionMethod Algorithm="http://www.w3.org/2009/xmlenc11#aes128-gcm"/>
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
          <wsse:SecurityTokenReference wsse11:TokenType="http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#EncryptedKey" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsse11="http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd">
            <wsse:Reference URI="#EK-6355f5cf-ee15-444e-8669-8eb2118142ed"/>
          </wsse:SecurityTokenReference>
        </ds:KeyInfo>
        <xenc:CipherData>
          <xenc:CipherReference URI="cid:message">
            <xenc:Transforms>
              <ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Ciphertext-Transform" xmlns:ds="http://www.w3.org/2000/09/xmldsig#"/>
            </xenc:Transforms>
          </xenc:CipherReference>
        </xenc:CipherData>
      </xenc:EncryptedData>
      <ds:Signature Id="SIG-901552e2-4ca8-4f3c-ac02-26aac34136e0" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo>
          <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
            <ec:InclusiveNamespaces PrefixList="env" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#"/>
          </ds:CanonicalizationMethod>
          <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
          <ds:Reference URI="#_22e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39">
            <ds:Transforms>
              <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <ds:DigestValue>IBx7/ofA6zzuSYYCaSZKe37UmCKbOMmwTvrh54PuM/E=</ds:DigestValue>
          </ds:Reference>
          <ds:Reference URI="#_12e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39">
            <ds:Transforms>
              <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <ds:DigestValue>BnVoHM2W/4ZpryJkOxoeOwHZ8gfd0MRuNJ0sr1gvEVU=</ds:DigestValue>
          </ds:Reference>
          <ds:Reference URI="cid:message">
            <ds:Transforms>
              <ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Signature-Transform"/>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <ds:DigestValue>/uEUj2yWpAgWStctc7U5VUHjt4rIGUXfbstuwDyTx7I=</ds:DigestValue>
          </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue>DxB4lQfxt5SjVMhcmGor8RnMh1e1OdurtF1yvLlWByPsPfcBzdb/0IdNiYr7rQ6IN2JpCFC8vQtE1FMz643WR9Ro9SdmsZ+t/f2QBf70cracLi850N1dapohooOsRedLQbz/tvWxDcMQRXsRN/169PMi2kIKUrCVgmnZdrleIBFiCsnhjSSoHO42hPqNxPcoldGoUmYBXdNbgl3seApYy7cqrZwL6SREOR0d+edEGQJfegqrkEGR0+jsO+QRCTG3d77EARBi7ZZwBduGMIXGGRXfHhIFzYo3ZNBfn0OikVOR76wCZyjbldXnGhoIkgLzb02RJRqXPNN8ZXFFrI0mig==</ds:SignatureValue>
        <ds:KeyInfo Id="KI-f933f5b6-fff1-4cc2-8072-0b43a789f00b">
          <wsse:SecurityTokenReference wsu:Id="STR-88d1398f-49ee-4128-b9af-214b02b4f6f7" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
            <wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">HPqVjsgDN900CCgLwAvG03x+R2I=</wsse:KeyIdentifier>
          </wsse:SecurityTokenReference>
        </ds:KeyInfo>
      </ds:Signature>
    </wsse:Security>
  </env:Header>
  <env:Body wsu:Id="_22e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"/>
</env:Envelope>
```

Response:

```
HTTP/1.1 200 
Content-Type: application/soap+xml;charset=UTF-8
Content-Length: 5130
Date: Sun, 09 Feb 2025 09:09:41 GMT
Keep-Alive: timeout=20
Connection: keep-alive
```

```xml
<S12:Envelope xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:eb3="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/" xmlns:ebbp="http://docs.oasis-open.org/ebxml-bp/ebbp-signals-2.0" xmlns:ebint="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/multihop/200902/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
  <S12:Header>
    <eb3:Messaging S12:mustUnderstand="true" id="_ebmessaging_N65541" wsu:Id="_12e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39">
      <eb3:SignalMessage>
        <eb3:MessageInfo>
          <eb3:Timestamp>2025-02-09T09:09:41.000Z</eb3:Timestamp>
          <eb3:MessageId>985e7e22-e6c5-11ef-bb34-0242ac130005@domibus.eu</eb3:MessageId>
          <eb3:RefToMessageId>96757329-e6c5-11ef-8dca-0242ac130004@domibus.eu</eb3:RefToMessageId>
        </eb3:MessageInfo>
        <eb3:Receipt>
          <ebbp:NonRepudiationInformation>
            <ebbp:MessagePartNRInformation>
              <ds:Reference URI="#_22e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39" xmlns:env="http://www.w3.org/2003/05/soap-envelope">
                <ds:Transforms>
                  <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
                </ds:Transforms>
                <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
                <ds:DigestValue>IBx7/ofA6zzuSYYCaSZKe37UmCKbOMmwTvrh54PuM/E=</ds:DigestValue>
              </ds:Reference>
            </ebbp:MessagePartNRInformation>
            <ebbp:MessagePartNRInformation>
              <ds:Reference URI="#_12e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39" xmlns:env="http://www.w3.org/2003/05/soap-envelope">
                <ds:Transforms>
                  <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
                </ds:Transforms>
                <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
                <ds:DigestValue>BnVoHM2W/4ZpryJkOxoeOwHZ8gfd0MRuNJ0sr1gvEVU=</ds:DigestValue>
              </ds:Reference>
            </ebbp:MessagePartNRInformation>
            <ebbp:MessagePartNRInformation>
              <ds:Reference URI="cid:message" xmlns:env="http://www.w3.org/2003/05/soap-envelope">
                <ds:Transforms>
                  <ds:Transform Algorithm="http://docs.oasis-open.org/wss/oasis-wss-SwAProfile-1.1#Attachment-Content-Signature-Transform"/>
                </ds:Transforms>
                <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
                <ds:DigestValue>/uEUj2yWpAgWStctc7U5VUHjt4rIGUXfbstuwDyTx7I=</ds:DigestValue>
              </ds:Reference>
            </ebbp:MessagePartNRInformation>
          </ebbp:NonRepudiationInformation>
        </eb3:Receipt>
      </eb3:SignalMessage>
    </eb3:Messaging>
    <wsse:Security S12:mustUnderstand="true" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
      <ds:Signature Id="SIG-a43fa155-e349-4927-8449-8b63ab3c9dec" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo>
          <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
            <ec:InclusiveNamespaces PrefixList="S12 ds eb3 ebbp ebint wsa wsse wsu" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#"/>
          </ds:CanonicalizationMethod>
          <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
          <ds:Reference URI="#N65667">
            <ds:Transforms>
              <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                <ec:InclusiveNamespaces PrefixList="ds eb3 ebbp ebint wsa wsse" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#"/>
              </ds:Transform>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <ds:DigestValue>NBmyTYEkY9uwsu8bCkiPxgjDiHrxETu8f1q1yxvz1Kk=</ds:DigestValue>
          </ds:Reference>
          <ds:Reference URI="#_12e55a283eae67cea1670501b39f6b954bfef1f975a5773c2f88e3f4be5721e39">
            <ds:Transforms>
              <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                <ec:InclusiveNamespaces PrefixList="ds ebbp ebint wsa wsse" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#"/>
              </ds:Transform>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <ds:DigestValue>ykM6rB9gzLoYo75J+EhL5CCv/GEO7+HrSZZ7nkfpJOU=</ds:DigestValue>
          </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue>Hevvcny35jKGCAT2bR0ehS2MUiqoJHoX6w4GP1bSPyji4pO0tFSSBaaReUTANolPV/1+9cTWpi7pTaU305TczbIWsRh9SuwSN0BG2hzFmE8YEI60U58dPvxKF8oLtBEE5GrJovAhxzNU7GEDC1PbLDHficma7ac7FedYbDu3+xV4pq2kdrF6YjfMLtFjJ54d41drqzCPhyV2NzOw1c2H2BRrX0shlZeJAzVybwdDM+w/y+8XtkD7YU8s7sLEBydcePYBFOesP1PYNqL8M4LYMk8ScoiYZKgtq5oqJzG4UmPR2bWw3vV/N+KnYrFk4alYaBXzAtyRENwo/buq1VIUew==</ds:SignatureValue>
        <ds:KeyInfo Id="KI-ee4835ec-b43b-4e8e-9e74-72706d9600f4">
          <wsse:SecurityTokenReference wsu:Id="STR-c308d5cd-52a5-4ad9-8cb0-43aa21f7b370" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
            <wsse:KeyIdentifier EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier">7AJeAnEL5EE5l3lLc+EoFpOfJCo=</wsse:KeyIdentifier>
          </wsse:SecurityTokenReference>
        </ds:KeyInfo>
      </ds:Signature>
    </wsse:Security>
  </S12:Header>
  <S12:Body wsu:Id="N65667"/>
</S12:Envelope>
```
