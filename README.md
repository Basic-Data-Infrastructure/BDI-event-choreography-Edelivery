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

To get the admin passwords:

    $ sudo docker compose logs | grep "Default password for user \[admin\] is"

To visit the Administration Console instances:

- http://localhost:8080/domibus/
- http://localhost:8081/domibus/
