# Deploying an e-delivery access point

In this experiment, we deploy two access points with [Domibus](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/Domibus), an open source e-delivery reference implementation. The functional purpose of this deployment is to send a “hello world” message from one deployment to another. Taking note of the steps needed, we then analyse this deployment to a reference deployment for simple cross-domain messaging.

## Demo deployment

To start, let’s look at a functional deom.

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

## Comparison

## Recommendations

When deploying Domibus, contact the [eDelivery Service Desk](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eDelivery+Service+Desk) if you need support. To illustrate the quality: I emailed them my problem on Sunday evening, and got a working solution on Monday 8:44.
