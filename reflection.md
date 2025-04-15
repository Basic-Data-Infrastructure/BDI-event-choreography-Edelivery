# Reflection and recommendations

This repository contributes analyses, prototypes and examples that support BDI in adopting e-delivery. The work mainly focuses on the perception that e-delivery brings too much overhead over what is practically needed in the logistics sector.

Its original author brings a bias to the exploration: it fits the same agenda as prior research and design such as [When Willeke can get rid of paperwork](https://repository.tudelft.nl/record/uuid:4c2005ea-9cfd-420f-80fb-e8714be0bdd5), the [Vidua](https://vidua.nl/) scalable trust service provider, and the [Trusted Information Partners](https://www.trustedinformationpartners.nl/) (TIP) reference architecture and knowledge base. This agenda is to accelerate the development of a common cross-sectoral infrastructure for digital exchange between natural and legal persons. The underlying belief is that this development requires *design* (grounded in a sense of simplicity) and *governance* (grounded in locally or legally organised trust) more than new *technology* (instead, reusing proven international standards).

To accelerate this development, BDI should adopt e-delivery and develop event choreography and other messaging use cases on top of this. This increases the chance of success for BDI compared to developing alternative message delivery standards.

The deliverables in this repository enable challenging this recommendation objectively. Forums such as the [TIP knowledge base](https://alkem.io/tip?tab=4) could host further discussion.

As a first iteration, the pre-study also highlights which areas require further work. Below are the author’s recommendations to BDI.

## Evolve reference architecture

Adoption of e-delivery impacts several of the BDI KITs. The impact can be handled incrementally through the [RFC process](https://bdi.gitbook.io/public/reference-architecture/bdi-maintenance-and-community-contributions). As an initial inventory, the following technical RFC topics seem relevant:

- [ ] Introduce the e-delivery building block to the base [BDI Stack](https://bdi.gitbook.io/public/reference-architecture/introduction/stack-and-kits), to increase visibility towards architects and developers who evolve and implement the reference architecture.
- [ ] Redefine the [Notification pub/sub service](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit/event-pub-sub-service) in terms of the four-corner model, to address the problem of multiple event brokers in a network.
- [ ] Introduce the role of e-delivery provider in [BDI Technical Roles](https://bdi.gitbook.io/public/reference-architecture/introduction/bdi-technical-roles), to make explicit how other roles can deliver messages to each other.
- [ ] Specify default choices in terms of [e-delivery specifications](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+Specifications) versions and choices for technical [Interoperability](https://bdi.gitbook.io/public/reference-architecture/federation-kit/interoperability), 
- [ ] Specify an event data model based on for example [EPCIS](https://www.iso.org/standard/85557.html) for in terms of e-delivery *user messages*, to provide interoperability for (logistics) events.
- [ ] Specify a party identifier scheme based on for example [EORI](https://taxation-customs.ec.europa.eu/customs-4/customs-procedures-import-and-export/customs-procedures/economic-operators-registration-and-identification-number-eori_en) in terms of [eDelivery ebCore Party ID](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+ebCore+Party+ID), to provide interoperability for identifying C1 and C4.
- [ ] Specify common patterns for [Event choreography](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit/event-choreography) in terms of e-delivery processing modes, to provide interoperability for (logistics) event distribution.
 -[ ] Specify data models for managing and using an Association Register under [Federation of Associations](https://bdi.gitbook.io/public/reference-architecture/federation-kit/federation-of-associations) in terms of e-delivery user messages and processing modes, to provide interoperability amongst associations.

## Improve developer experience

Adoption of e-delivery requires software developers to be enabled and encouraged to implement it. The developer experience can be improved by investing in documentation and open source reference code. As a result, organisations may not even need to know they are applying e-delivery or interfacing with a system that does it for them. As an initial inventory, the following developments seem relevant:

- [ ] Add an entry point for tutorials, how-tos, explanations and references (see [Diátaxis](https://diataxis.fr/)) to the [BDI Developer Portal](https://dev.bdinetwork.org/), to complement the European Commission documentation that is geared towards governments and highly regulated enterprises.
- [ ] Deploy a sandbox e-delivery access point with a trust service provider, to enable developers to prototype and demo BDI applications without needing to set up the web server infrastructure.
- [ ] Develop tooling for developer-friendly creation and reading of e-delivery metadata (see [JWT Debugger](https://jwt.io/) for example), to reduce cognitive overhead for developers working with envelopes and processing mode definitions.
- [ ] Develop an open source e-delivery agent automating the [Notification pub/sub service](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit/event-pub-sub-service) interactions, to make deployment of [Event Choreography](https://bdi.gitbook.io/public/reference-architecture/logistics-event-kit/event-choreography) easier.
- [ ] Develop an open source e-delivery agent library for ICT systems integration, making it easier for logistics software developers to submit and receive messages on behalf of principals, subcontractors or shared service providers.
- [ ] Develop an open source e-delivery agent application for human interaction (for example supporting the [DigiDrop use cases](https://content.bdinetwork.org/wp-content/uploads/sites/2/2025/02/20250130_TSL_BDI-JWS-als-digitaal-bewijs.pdf), making it easier for employees of principals and subcontractors to interact and review interactions.

## Explore dynamic discovery

Critical to adoption of BDI is the ability to combine stable infrastructures with ad hoc networks. The pre-study focused on message exchange and dynamic discovery requires further research and development. As an initial inventory, the following activities seem relevant:

- [ ] Analyse the [eDelivery SMP Profile](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/SMP+specifications) and the [eDelivery BDXL Profile](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/SML+specifications) for suitability in BDI, to reduce duplication.
- [ ] Model the trust relations in the various BDI network deployments, to understand better where cross-sectoral access points and common services can be applied, and where bespoke solutions are preferable.
- [ ] Prototype the formation of ad hoc networks between principals and subcontractors using e-delivery standards, to learn from hands-on experience what 
- [ ] Propose an RFC redefining [Discovery](https://bdi.gitbook.io/public/reference-architecture/trust-kit/discovery) in terms of SMP and BDXL, to increase interoperability and reuse.

## Share implementation experience

More public and private sectors are adopting e-delivery. In the Netherlands, these are collaborating in [Trusted Information Partners](https://www.trustedinformationpartners.nl/) (TIP). By sharing the burden of research and development, establishing common specifications and exchanging plans and experiences, partners accelerate each other. As an initial inventory, the following activities seem relevant:

- [ ] Formally join TIP, to ensure representation in its [governance and working groups](https://www.trustedinformationpartners.nl/beschrijving-tip-governance-aangepast/).
- [ ] Consider delegating the generic agreements (e.g. interface specifications for “how” to exchange) fully to TIP, to focus BDI efforts on domain-specific agreements (e.g. data models for “what” to exchange).
- [ ] Review the TIP [basic function *Delivering messages*](https://www.trustedinformationpartners.nl/basisfunctie-delivering-messages-ter-consultatie/), to ensure applicability for BDI use cases.
- [ ] Help finish the TIP [basic function *Addressing actors*](https://github.com/trustedinformationpartners/architecture/pull/3), to take into account BDI requirements.
- [ ] If aspects of e-delivery appear too burdensome, validate this with other TIP partners within the working groups, to potentially improve the specifications. For example, partners could prepare proposals to improve the European standards.
