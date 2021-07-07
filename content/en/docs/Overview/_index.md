---
title: "Overview"
linkTitle: "Overview"
weight: 1
description: >
  Get a high-level introduction to Trickster.
---


Speed up your applications with Trickster's HTTP reverse proxy caching and dashboard query accelerator for time series databases.
Trickster's two-pronged approach reduces unnecessary data transfer between the client, dashboard server, HTTP endpoints, and databases.

Customizable HTTP reverse proxy caching leverages features such as metrics, health checks, and distributed tracing to help you get the most out of each data request. And with two types of collapsed forwarding, you can ensure that your application is making only the necessary data requests.

By working between endpoints, databases, users and the dashboard server,  Trickster can dramatically reduce time series database queries by checking for cached data and only asking for data that is outstanding. 


<img src="high-level-1.png" width=512 alt="Diagram of Trickster logo with arrows from icons representing the client and a dashboard server and arrows from the Trickster logo to icons for HTTP Endpoints and Time Series Databases" />

<figcaption>Diagram of Trickster working between the client, dashboard server, HTTP endpoints, and databases to reduce data requests.
</figcaption>

## Trickster Proxy Features

Trickster is a fully-featured HTTP reverse proxy cache for HTTP applications such as static file servers and web APIs. Trickster's proxy features include the following:

* [Supports Transport Layer Security (TLS) Protocol](./tls.md) and HTTP/2 for frontend termination and backend origination
* Offers several options for a [caching layer](./caches.md), including in-memory, filesystem, Redis and bbolt
* [Highly customizable](./configuring.md), using minimal configuration settings, [down to the HTTP Path](./paths.md)
* Built-in Prometheus [metrics](./metrics.md) and customizable [Health Check](./health.md) Endpoints for end-to-end monitoring
* [Negative Caching](./negative-caching.md) to prevent domino effect outages
* High-performance [Collapsed Forwarding](./collapsed-forwarding.md)
* Best-in-class [Byte Range Request caching and acceleration](./range_request.md).
* [Distributed Tracing](./tracing.md) via OpenTelemetry, supporting Jaeger and Zipkin
* Rules engine for custom request routing and rewriting

## Time Series Database Accelerator

Trickster dramatically improves dashboard chart rendering times for end users by eliminating redundant computations on the time series databases, or TSDBs, that it fronts. In short, Trickster makes read-heavy Dashboard/TSDB environments, as well as those with highly-cardinalized datasets, significantly more performant and scalable.

### Compatibility

Trickster works with virtually any Dashboard application that makes queries to any of these TSDBs:

<img src="prom_logo_60.png" width=16 alt="Prometheus logo" /> Prometheus

<img src="clickhouse_logo.png" width=16 alt="ClickHouse logo" /> ClickHouse

<img src="influx_logo_60.png" width=16 alt="InfluxDB logo" /> InfluxDB

<img src="irondb_logo_60.png" width=16 alt="Circonus IRONdb logo" /> Circonus IRONdb

See the [Supported Origin Types](./supported-origin-types.md) documentation for details.

### How Trickster Accelerates Time Series

#### 1. Time Series Delta Proxy Cache

Most dashboards request from a time series database the entire time range of data they wish to present every time a user's dashboard loads, as well as on every auto-refresh. Trickster's Delta Proxy inspects the time range of a client query to determine what data points are already cached, and requests from the tsdb only the data points still needed to service the client request. This results in dramatically faster chart load times, since the tsdb is queried only for tiny incremental changes on each dashboard load, rather than several hundred data points of duplicative data.

<img src="partial-cache-hit.png" alt="Diagram of how Trickster determines cache range" width=1024 />

#### 2. Step Boundary Normalization

When Trickster requests data from a tsdb, it adjusts the client's requested time range slightly to ensure that all data points returned are aligned to normalized step boundaries. For example, if the step is 300s, all data points will fall on the clock 0's and 5's. This ensures that the data is highly cacheable, is conveyed visually to users in a more familiar way, and that all dashboard users see identical data on their screens.

<img src="step-boundary-normalization.png" alt="Diagram of Trickster adjusting the client's requested time range." width=640 />

#### 3. Fast Forward

Trickster's Fast Forward feature ensures that even with step boundary normalization, real-time graphs still always show the most recent data, regardless of how far away the next step boundary is. For example, if your chart step is 300s, and the time is currently 1:21p, you would normally be waiting another four minutes for a new data point at 1:25p. Trickster will break the step interval for the most recent data point and always include it in the response to clients requesting real-time data.

<img src="fast-forward.png" alt="Diagram of Trickster breaking the step interval for the most recent data point and including it in the response to clients requesting real-time data." width=640 />


## Next steps

Ready to try it out?

* [Quickstart](/docs/quickstart/): Try Trickster with Docker Compose

