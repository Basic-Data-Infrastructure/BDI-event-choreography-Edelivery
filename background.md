# Analysis of e-delivery concepts

## Four corner model

Typical e-delivery deployments involve a four-corner model:

```
Corner 1:         Corner 4: 
Agent A           Agent B   
   |                  ^     
   |                  |     
   v                  |     
Corner 2:  -----> Corner 3: 
Provider A        Provider B
```

In this model, corners 1 and 2 may coincide (self-hosting), just like 3 and 4. Also corners 2 and 3 may coincide. Some stakeholders talk about a five-corner model, but in those cases they just mean that another agent is connected using their own provider, for example for supervisory purposes.

Typically the providers share common infrastructure, for example for address resolution. This is not considered a corner in the model, since it is not part of the primary information flow.

In BDI, agents may represent principals (sellers and buyers) or their subcontractors. Multiple deployment models are possible.

- In the most flat case, a principal applies **self-hosting** to corners 2 and 3, and lets their counterpart and subcontractors directly contact their services over some API. But this puts a lot of technical burden on this self-hosting principal, and requires a lot of trust of the other parties in their capability to handle it.
- A way to quickly scale adoption is to have a **single provider** without an open system based on interoperability standards. But this potentially creates a single point of failure and a power imbalance.
- The EU typically pushes for **hybrid** models in which any conformant (self-hosted or delegated) provider may participate, if needed with protections for an open market.

## Interface between providers

Between corners 2 and 3, e-delivery networks apply **electronic data interchange** (EDI) with Internet integration (EDIINT). The purpose of EDI is to communicate structured data between organisations, in contrast to unstructured data between technical endpoints with no standard relation with responsible organisations. The purpose of EDIINT is to reuse common transport protocols instead of relying on alternative “value-added networks”. In EDIINT, multiple **applicability statements** have been agreed:

- AS1 over SMTP in [IETF RFC 3335](https://datatracker.ietf.org/doc/html/rfc3335) (2002)
- AS2 over HTTP 1.1 POST in [IETF RFC 4130](https://datatracker.ietf.org/doc/html/rfc4130) (2005)
- AS3 over FTP in [IETF RFC 4823](https://datatracker.ietf.org/doc/html/rfc4823) (2007)
- AS4 over SOAP 1.2 web services in [OASIS AS4 1.0](https://docs.oasis-open.org/ebxml-msg/ebms/v3.0/profiles/AS4-profile/v1.0/AS4-profile-v1.0.html) (2013) and [ISO 15000-2:2021](https://www.iso.org/standard/79109.html)

There does not seem to be work on an AS5, even though for example XMPP (1999) has emerged as a common stransport protocol abstractions with features like streaming, presence and various network deployment options. Another example would be gRPC (2014) addressing connectivity issues between services deployed across data centres. Likely the benefits of specifying another applicability statement do not yet outweigh the costs.

Typically, an applicability statement is applied with one or more profiles such as [eDelivery AS4 v2.0](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+AS4+-+2.0) by the European Commission or the [Peppol AS4 Profile v2.0](https://docs.peppol.eu/edelivery/as4/specification/) by OpenPeppol.

## Interface between providers and agents

These are usually not government-regulated, but agreed in service contracts. For interoperability within a trust framework, it may be useful to agree on baseline service contracts and SDKs, accelerating adoption and enabling agents to switch between providers.

To deal with firewall issues, typically the provider has a server to which the agent is a client. The server may for example provide an HTTP API or even an EDIINT endpoint. Alternatively, the server may for example be an event broker such as Apache Pulsar in the [Trusted Goods Release – Event Demo](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit/trusted-goods-release-event-demo).

In cases where the agent is implemented as an HTTP service, the control flow may also be opposite. The provider could for example call a webhook endpoint on the agent for incoming messages.

## Interface between agents

While there is no network connection between agents, logically they interface using what is in AS4 called the **user message** that is relayed through their providers. The applicability statement does not specify the format of this user message, but a profile may specify it. Depending on the level of trust between agents and providers, agents may want to apply Messaging Layer Security (MLS, [RFC 9420](https://www.rfc-editor.org/rfc/rfc9420)) or equivalent end-to-end encryption and authentication.
