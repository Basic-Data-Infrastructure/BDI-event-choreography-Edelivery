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
- Configure message priority rules, if needed
- Configure dynamic discovery of other access point provider endpoints
- Configure firewall, supporting incoming requests if “push” support is needed, restricting internal endpoint access
- Configure a task schedule to check for incoming messages if “pull” support is needed
- Configure load balancing
- Configure e-archiving of messages, if needed

The result is an access point that can send and receive messages. To actually use the access point, an application needs to interact with Domibus over its internal endpoints, for example using the SOAP API exposed by the [WS Plugin](https://docs.edelivery.tech.ec.europa.eu/domibus/5.1.6/#wsplugin). This provides functions such as `submitMessage`, `listPendingMessages`, and `retrieveMessage`. This application may be a multi-user application, implementing its own identity and access management.

## Comparison

## Recommendations

When deploying Domibus, contact the [eDelivery Service Desk](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+Service+Desk) if you need support. To illustrate the quality: I emailed them my problem on Sunday evening, and got a working solution on Monday 8:44.
