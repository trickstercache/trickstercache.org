---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 1
description: >
  Try Trickster with Docker Compose and minimal setup.
---

This composition creates service containers for Prometheus, Grafana, Jaeger, Zipkin, Redis, Trickster and Mockster that together demonstrate several basic end-to-end configurations for running Trickster in your environment with different cache and tracing provider options. 

{{< alert >}}
If you have any of these services running locally already, you may run into port conflicts and need to temporarily spin down the conflicting processes.
{{< /alert >}}

## Prerequisites

You should already have the following installed:

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Starting the demo

1. Clone the [Trickster Github project](https://github.com/trickstercache/trickster). 
1. In the `trickster` directory, change your working directory to `./examples/docker-compose` with the following command:

    ```
    cd examples/docker-compose
    ```
    
1. To run the demo from the demo directory, enter the following command:

    ```
    docker-compose up -d
    ```

1. You can interact with each of the services on their exposed ports (as defined in [Compose file](https://github.com/trickstercache/trickster/blob/main/examples/docker-compose/docker-compose.yml)), or by running `docker logs $container_name`, `docker attach $container_name`, etc.

## Exploring Trickster

### Grafana

Once the composition is running, we recommend exploring with Grafana, at <http://127.0.0.1:3000/>. Grafana is pre-configured with datasources and a sample dashboard that are ready-to-use for the demo.

### Jaeger UI

Jaeger UI is available at <http://127.0.0.1:16686>, which provides visualization of traces shipped by Trickster and Grafana. The more you use trickster-based data sources in Grafana, the more traces you will see in Jaeger. This composition runs the Jaeger All-in-One container.  Trickster ships some traces to the Agent and others directly to the Collector, so as to demonstrate both capabilities. The Trickster config determines which upstream origin ships which traces where.

For a variety of configurations and other bootstrap data, review the various files in the `docker-compose-data` folder. This might be useful for configuring and using Trickster (or any of these other fantastic projects) in your own deployments. Try adding, removing, or changing some of the trickster configurations in [./docker-compose-data/trickster-config/trickster.yaml](https://github.com/trickstercache/trickster/blob/main/examples/docker-compose/docker-compose-data/trickster-config/trickster.yaml) and then `docker exec docker-compose_trickster_1 kill -1 1` into the Trickster container to apply the changes, or restart the environment altogether with `docker-compose restart`. Just be sure to make a backup of the original config first, so you don't have to download it again later.

## Example Datasources

The `sim-*` datasources generate on-the-fly simulation data for any possible time range, so you can immediately use them after starting up the environment. Note, however, that the simulated data is not representative of reality in any way.

The non-sim Prometheus container that backs the `prom-*` datasources polls the newly-running environment to generate metrics that will then populate the dashboard. Since the Prometheus container only collects and stores metrics while the environment is running, you'll need to wait a minute or two for those datasources to show any data on the dashoard in real-time.

## Getting Real Dashboard Data

Using datasources backed by the real Prometheus and Trickster (the `prom-trickster-*` datasources), rather than the simulator, to explore the dashboard is more desirable for the demo. It better conveys the shape and nature of the Trickster-specific metrics that might be unfamiliar. However, since there is no historical data in the demo composition, that creates an upfront barrier.

Keeping the dashboard open and auto-refreshing against any `trickster`-labeled datasource will help to generate real metrics in Trickster, such as request rates, cache hit rates, etc. Prometheus will collect and store those metrics, and the Grafana dashboard will query and render those metrics. So by keeping the demo dashboard open and refreshing, you are helping to generate the very metrics that the dashboard presents, making the demo much more visually useful while being very meta.

In addition to generating metrics, using the `trickster`-labeled datasources generates traces that are viewable in Jaeger UI, as described above.

## Stopping the Demo and Cleaning Up

To stop and remove the demo, run `docker-compose down` in the `./examples/docker-compose` directory.