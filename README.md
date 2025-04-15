# BDI pre-study on event choreography with e-delivery

## Main question

What existing standards, frameworks and developments could BDI leverage to evolve the [Logistics Event KIT](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit) with regard to the delivery of events, linked data and other messages?

## Scope of this answer

BDI could choose to leverage the Digital Europe **e-delivery** ([eDelivery](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery)) building block, as standardised under e.g. the once-only technical system, Peppol and eIDAS. Adopting e-delivery could bring several benefits, including:

- ability for BDI participants to reuse the same infrastructure for other data spaces, such as for e-invoicing;
- ability to build upon and further develop open source building blocks that are already commonly used, solving well-known issues such as exchange across firewalls;
- lower cost of securing and maintaining custom protocols that could be developed instead;
- cross-sector collaboration on information exchange, e.g. through Trusted Information Partners (TIP) which similarly has a [Basic function *Delivering messages* for consultation](https://www.trustedinformationpartners.nl/basisfunctie-delivering-messages-ter-consultatie/).

The current repository explores the e-delivery set of standards, frameworks and developments as one answer to the main question.

## Exploration

This pre-study started with an [Analysis of e-delivery concepts](background.md), which provides more background into the topic.

The practical experimentation in this repository focuses on the implementation burden for e-delivery versus seemingly more lightweight architectures.

### Problem definition

E-delivery networks have the stigma of being heavy on **technology** specification and **governance**, e.g. compliance certification.

The heavy governance of existing networks may be not an issue in practice: for some transactions, it may be needed, and for others, the same technology may be reused in a different trust framework. For example, the e-delivery software may be reused in an open Web PKI-based system, or even without a PKI. This flexibility may be necessary for BDI since some logistic use cases require lower assurance.

We wish to find out is whether e-delivery technology brings inherent complexity that may result from the high-assurance governance, but may impede adoption for low-assurance use cases. If that would be the case, that might disqualify e-delivery as a building block for BDI. Therefore we focus on technical overlap and differences, and only mention governance aspects for context.

### Hypotheses

Null hypothesis H0: there is no significant difference between e-delivery and seemingly more lightweight approaches.

Alternative hypothesis H1: there is a significant difference.

### Experiment: minimum viable e-delivery

This repository captures test definitions, results and analysis to assess the strength of devidence against H0. The approach was as follows:

- [x] Send a “hello world” message from one deployment of a common open source e-delivery to another deployment; compare steps to steps of deploying a custom web-based integration without e-delivery. See: [Deploying an e-delivery access point](deployment.md).
- [x] Visualise in sequence diagrams and example messages the protocol steps for this “hello world” message; compare overhead with that of a custom web-based integration without e-delivery. See: [Messaging protocol in e-delivery](messaging.md).
- [x] Reflect on needed additional steps to make it applicable for e.g. BDI virtual data networks. See: [Issues](https://github.com/Basic-Data-Infrastructure/BDI-event-choreography-Edelivery/issues).

### Conclusion

Through configuring, demonstrating and analysing a “hello world” exchange using an open source e-delivery solution, we have observed:

- Deployment considerations for e-delivery are similar to those of any other web application for information exchange, but documentation so far seems to be less developer-oriented.
	- If needed, e-delivery security can be slimmed down by solely relying on HTTPS security.
	- If needed, e-delivery providers can be shared, for example by a principal with subcontractors, or even across principals.
- Semantic messaging overhead is similar to that in a common event broker or webhooks system, but with more standardisation and therefore higher expectations of interoperability.
- Syntactical messaging overhead is higher in e-delivery than in typical HTTP/JSON systems, which is at least partly caused due to the reuse of standardized XML building blocks.

The evidence so far supports H0. This means that e-delivery could be deployed in a lightweight system, similarly to the previous BDI experiments.
