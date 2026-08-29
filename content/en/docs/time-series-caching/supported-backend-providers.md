---
title: "Supported Providers"
linkTitle: "Supported Providers"
weight: 10
---

Trickster currently supports the following Providers:

### <img src="/images/docs/logos/trickster-logo.svg" width=24 /> Generic HTTP Reverse Proxy Cache

Trickster operates as a fully-featured and highly-customizable reverse proxy cache, designed to accelerate and scale upstream endpoints like API services and other simple http services. Specify `'reverseproxycache'` or just `'rpc'` as the Provider when configuring Trickster.

---

## Time Series Databases

### <img src="/images/docs/external/prom_logo_60.png" width=24 /> Prometheus

Trickster fully supports the [Prometheus HTTP API (v1)](https://prometheus.io/docs/prometheus/latest/querying/api/), including Prometheus 3.x features like native histograms and UTF-8 metric names. Specify `'prometheus'` as the Provider when configuring Trickster. See the [Prometheus Support Document](/docs/time-series-caching/providers/prometheus/) for more information.

### <img src="/images/docs/external/influx_logo_60.png" width=24 /> InfluxDB

Trickster supports InfluxDB 1.x, 2.x, and 3.x. Specify `'influxdb'` as the Provider when configuring Trickster.

See the [InfluxDB Support Document](/docs/time-series-caching/providers/influxdb/) for more information.

### <img src="/images/docs/external/clickhouse_logo.png" width=24 /> ClickHouse

Trickster supports accelerating ClickHouse time series over both HTTP and the ClickHouse native binary protocol (port 9000), and is tested against the Vertamedia and official Grafana ClickHouse (v4+) datasource plugins. Specify `'clickhouse'` as the Provider when configuring Trickster.

See the [ClickHouse Support Document](/docs/time-series-caching/providers/clickhouse/) for more information.

### <img src="/images/docs/external/graphite-logo.svg" width=24 /> Graphite

Trickster accelerates Graphite's render API, including graphite-web, go-carbon
and other Graphite-protocol backends. Specify `'graphite'` as the Provider when
configuring Trickster.

See the [Graphite Support Document](/docs/time-series-caching/providers/graphite/) for more information.

### <img src="/images/docs/external/mysql_logo_60.png" width=24 /> MySQL

Trickster supports protocol-aware acceleration for supported MySQL
servers and Grafana's built-in MySQL data source. Specify `mysql` as the direct
terminal provider and expose it through a listener with `protocol: mysql`.

See the [MySQL Provider Guide](/docs/time-series-caching/providers/mysql/) for the supported server, client,
SQL, authentication, TLS, caching, routing, and operations contract.
