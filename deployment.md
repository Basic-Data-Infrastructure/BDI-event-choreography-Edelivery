# Deploying an e-delivery access point

In this experiment, we deploy two access points with [Domibus](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/Domibus), an open source reference implementation of e-delivery. The functional purpose of this deployment is to send a “hello world” message from one access point to another. Taking note of the steps needed, we then analyse this deployment to a reference deployment for simple cross-domain messaging.

## Demo deployment

To start, look at this functional demo. The scope is interoperability between Corners 2 and 3:

```
Corner 1:         Corner 4:
Agent A           Agent B
   |                  ^
   |                  |
   v                  |
Corner 2:  -----> Corner 3:
Provider A        Provider B
```

The demo will be triggered by a “simulated” request from Corner 1 to Corner 2. The request is “simulated” because the deployment does not actually involve an API for agents to access provider services. Instead, we will use an internal API for the provider service. The API client requests sending the “hello world“ payload to Corner 4, providing the Corner 3 endpoint address as discovered through an out-of-band channel. The Corner 3 endpoint discovery could for example happen using a Service Metadata Locator (SML). The message from Corner 2 to Corner 3 is sent using the AS4 protocol.

We have adapted the Domibus [Quick Start Guide v5.1.6](https://docs.edelivery.tech.ec.europa.eu/domibus/5.1.6/#quickstart), automating where possible for easy iterative prototyping.

To run the Docker containers:

    $ cd domibus
    $ sudo docker compose up

Now send a message:

    $ sh submit-hello-world.sh

You can observe the message in the Messages tab of each Administration Console. To observe network traffic to the red instance, check the `tcpdump` logs:

    $ sudo docker compose logs tcpdump -f

To get the admin passwords:

    $ sudo docker compose logs | grep "Default password for user \[admin\] is"

To visit the Administration Console instances, use different browser sessions:

- http://localhost:8080/domibus/ (blue)
- http://localhost:8081/domibus/ (red)

## Steps involved

The following steps are part of the demo:

- Configure a database server (MySQL)
- Configure a web server (Tomcat)
- Configure an access point web application (Domibus)
- Configure user access (system administrator, backend system user)
- Configure one or more processing modes: message processing policies, specifying for example:
    - retention time for messages that are not yet delivered
    - known access point provider endpoints, if configured statically
    - supported message exchange patterns, such as “push” (incoming HTTP requests) and “pull” (outgoing HTTP requests)
    - accepted payload media types and sizes
    - method to split and join large payloads over multiple messages, if needed
    - error handling policies
    - published business process specifications, if any
    - information security policies (confidentiality, integrity, availability), for example:
        - signature policy
        - acceptable ciphersuites for encryption
        - trust anchors

Usually, the e-delivery network defines the processing mode and remaining degrees of freedom for providers. The processing mode defines the behaviour of what is in the AS4 protocol called the Message Service Handler. Depending on the message exchange pattern, the Message Service Handler acts as an HTTP client, an HTTP server, or both.

The following steps would be part of a production deployment, as per the Domibus [Configuring Domibus v5.1.6](https://docs.edelivery.tech.ec.europa.eu/domibus/5.1.6/#domibus_config) guide:

- Configure dedicated cryptographic key pairs for signing and encryption
- Configure server-side TLS to protect AS4 protocol metadata and, if not signed and encrypted in AS4, messages
- Configure logging, monitoring and alerting
- Configure message encryption at rest
- Configure firewall, supporting incoming requests if “push” support is needed, restricting internal endpoint access

The guide also includes optional steps:

- Configure message priority rules, if needed
- Configure dynamic discovery of other access point provider endpoints
- Configure a task schedule to check for incoming messages if “pull” support is needed
- Configure e-archiving of messages, if needed
- Configure load balancing for high availability, if needed

The result is an access point that can send and receive messages. To actually use the access point, an application needs to interact with Domibus over its internal endpoints, for example using the SOAP API exposed by the [WS Plugin](https://docs.edelivery.tech.ec.europa.eu/domibus/5.1.6/#wsplugin). This provides functions such as `submitMessage`, `listPendingMessages`, and `retrieveMessage`. This application may be a multi-user application, implementing its own identity and access management.

## Comparison

For the scope of the “hello world” message, BDI has explored “static networks using webhooks” as an alternative deployment architecture. In such networks, entities locally register known the HTTPS POST endpoints of expected event recipients. The endpoint URLs could be exchanged manually or discovered automatically, for example using DNS.

Note that most of the necessary configurations for Domibus also apply for such a webhooks deployment, due to the similarity of the “push” message exchange pattern. The database is not essential to e-delivery, but just used for administrative purposes and buffering of messages. The latter could also be performed in-memory in a HTTP server without load balancing.

Three topics require special attention.

### Unifying HTTP security with message security

A possible optimisation in the webhook architecture is removing the separation between:

- Processing mode security, affecting HTTP payload
- Web server security, affecting HTTP transport

In some deployments, the processing mode security may not be needed, for example when:

- The message handler fully trusts web public key infrastructure for authentication and message secrecy. Or the web server addes another access control method on top of the web application, such as mutual TLS for client authentication.
- The message handler does not require non-repudiation for later handling of disputes regarding message delivery. For example, the sender may themselves manage cryptographic keys, and use another technology than XML signatures to provide non-repudiation of the message content, instead of non-repudiation of the delivery protocol data.

For such cases, the processing mode configuration could be slimmed down to not require signing or encryption, as per the [AS4 Profile of ebMS 3.0 Version 1.0](https://docs.oasis-open.org/ebxml-msg/ebms/v3.0/profiles/AS4-profile/v1.0/os/AS4-profile-v1.0-os.html): a minimal client “also supports business processes that do not require signing of messages and of message receipts”. In this case, the Message Service Handler does not require its own cryptographic keys.

### Supporting multiple users

A server-based Message Service Handler exposes a single HTTP endpoint, typically for many agents (Corner 1 or Corner 4) acting on behalf of many senders and recipients. In a webhook architecture, each recipient may have their own endpoint at a single common server, or these could be combined at a single endpoint anyway.

Apart from this technical detail, there does not seem to be a fundamental difference with regard to multiple-user support in the case of the “push” message exchange pattern. Note that multiple-user servers make sense for this pattern, since it may be infeasible for each sender or recipient to publicly expose their own HTTP server. When relying on a shared server with buffered messages, senders and recipients can instead use an HTTP client (such as a web browser or an internal software application) to interact with this shared server.

Note however that the AS4 “pull” message exchange pattern also provides an alternative. For example, in the case with one sending principal and several receiving subcontractors, the principal may share their Message Service Handler endpoint with the subcontractors. Subsequently, during the lifetime of the order, the subcontractors poll the principal for new events. This way, only the principal needs to host an access point as an HTTP server, while the subcontractors self-host an access point as an HTTP client.

### Developer experience and conformance

There is no common standard for webhooks. Instead, webhook deployments are composed of multiple internet technologies, typically standardised at IETF in technically oriented RFC documents. These technologies are typically composed by skilled engineers in an iterative process. The results end up being documented at provider-specific developer documentation. This contributes to the perception of webhooks to be a lightweight approach.

In contrast, e-delivery is based on complete, configurable specifications such as the [AS4 Profile of ebMS 3.0 Version 1.0](https://docs.oasis-open.org/ebxml-msg/ebms/v3.0/profiles/AS4-profile/v1.0/os/AS4-profile-v1.0-os.html) by OASIS and the [eDelivery AS4 Profile version 2.0](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+AS4+-+2.0) by the European Commission. The standards are optimised for certification of reusable products which in theory enable enterprises to configure a deployment without requiring software engineering skill. This creates a barrier for newcomers with a technical background, who need to learn several new domains at once to get started, and may be overwhelmed by the options.

This first difference could be addressed by complementary profile specifications and developer guidance, focusing on the minimum requirements to exchange logistics events, along with open source example software and tooling. The developer experience would ultimately be the same as in the webhooks case. A potential advantage of the e-delivery approach is that the existing certifications and practices can still be applied where needed.

## Recommendations

When deploying Domibus, contact the [eDelivery Service Desk](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+Service+Desk) if you need support. To illustrate the quality: I emailed them my problem on Sunday evening, and got a working solution on Monday 8:44.

Explore dynamic discovery further, based on the e-delivery SML architecture. Discover whether and how this complicates deployment.
