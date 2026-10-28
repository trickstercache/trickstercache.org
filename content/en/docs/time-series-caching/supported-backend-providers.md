---
title: "Supported Providers"
linkTitle: "Supported Providers"
weight: 10
---

Trickster currently supports the following Providers:

### <img src="/images/docs/logos/trickster-logo.svg" width=24 /> Generic HTTP Reverse Proxy Cache

Trickster operates as a fully-featured and highly-customizable reverse proxy cache, designed to accelerate and scale upstream endpoints like API services and other simple http services. Specify `'reverseproxycache'` or just `'rpc'` as the Provider when configuring Trickster.

### <img src="/images/docs/logos/trickster-logo.svg" width=24 /> Static File Server

Trickster can serve the contents of a local directory itself, with no upstream origin, for hosting websites and other static content. Specify `'static'` as the Provider when configuring Trickster. See the [Static File Server Document](/docs/backends/static/) for more information.

### <img src="/images/docs/logos/trickster-logo.svg" width=24 /> Media over QUIC (MoQ) Relay

Trickster relays live media as a caching Media over QUIC Transport relay, drafts -17 through -22, to native QUIC clients on a `protocol: moq` listener and to browsers by WebTransport over HTTP/3. One upstream subscription per track fans out to every subscriber, the newest groups stay in memory and older ones in a cache for FETCH, and publishers can send tracks to Trickster directly. Specify `'moq'` as the Provider when configuring Trickster. See the [MoQ Relay Document](/docs/object-caching/moq/) for more information.

---

## Time Series Databases

### <img src="/images/docs/external/prom_logo_60.png" width=24 /> Prometheus

Trickster fully supports the [Prometheus HTTP API (v1)](https://prometheus.io/docs/prometheus/latest/querying/api/), including Prometheus 3.x features like native histograms and UTF-8 metric names. Specify `'prometheus'` as the Provider when configuring Trickster. See the [Prometheus Support Document](/docs/time-series-caching/providers/prometheus/) for more information.

### <img src="/images/docs/external/clickhouse_logo.png" width=24 /> ClickHouse

Trickster supports accelerating ClickHouse time series over both HTTP and the ClickHouse native binary protocol (port 9000), and is tested against the Vertamedia and official Grafana ClickHouse (v4+) datasource plugins. Specify `'clickhouse'` as the Provider when configuring Trickster.

See the [ClickHouse Support Document](/docs/time-series-caching/providers/clickhouse/) for more information.

### <img src="/images/docs/external/influx_logo_60.png" width=24 /> InfluxDB

Trickster supports InfluxDB 1.x, 2.x, and 3.x. Specify `'influxdb'` as the Provider when configuring Trickster.

See the [InfluxDB Support Document](/docs/time-series-caching/providers/influxdb/) for more information.

### <img src="/images/docs/external/druid-logo.svg" width=24 /> Apache Druid

Trickster accelerates fixed-width native JSON `timeseries`, `groupBy`, and
`topN` queries plus eligible `TIME_FLOOR` SQL queries, with safe Object Proxy
Cache fallback for other read-query shapes. Specify `'druid'` as the Provider
when configuring Trickster.

See the [Apache Druid Support Document](/docs/time-series-caching/providers/druid/) for more information.

### <img src="/images/docs/external/graphite-logo.svg" width=24 /> Graphite

Trickster accelerates Graphite's render API, including graphite-web, go-carbon
and other Graphite-protocol backends. Specify `'graphite'` as the Provider when
configuring Trickster.

See the [Graphite Support Document](/docs/time-series-caching/providers/graphite/) for more information.

### <img src="/images/docs/external/timescaledb_logo.svg" width=24 /> PostgreSQL and TimescaleDB

Trickster accepts native PostgreSQL wire-protocol connections and accelerates
time-bucketed queries against PostgreSQL and TimescaleDB, including the
statements Grafana's built-in PostgreSQL data source sends. Specify `postgres`
(or its alias `timescaledb`) as the provider and expose it through a listener
with `protocol: postgres`.

See the [PostgreSQL and TimescaleDB Provider Guide](/docs/time-series-caching/providers/postgres/) for the
supported clients, SQL, authentication, TLS, caching, routing, and operations
contract.

### <img src="/images/docs/external/greptime-logo.svg" width=24 /> GreptimeDB

Trickster accelerates eligible GreptimeDB SQL queries over HTTP, PostgreSQL
and MySQL, plus its Prometheus-compatible range API. Specify `greptimedb` as
the provider and map native listeners explicitly. See the
[GreptimeDB Provider Guide](/docs/time-series-caching/providers/greptimedb/) for configuration, cache eligibility,
Grafana macros, authentication and upstream compatibility limits.


### <img src="/images/docs/external/questdb-logo.svg" width=24 /> QuestDB

Trickster proxies QuestDB's HTTP surface and accelerates eligible QuestDB SQL
over the PostgreSQL wire protocol. Specify `questdb` as the provider and map a
`protocol: postgres` listener for native clients. See the
[QuestDB Provider Guide](/docs/time-series-caching/providers/questdb/) for configuration, cache eligibility,
authentication and upstream compatibility limits.

### <img src="/images/docs/external/victoriametrics-logo.svg" width=24 />  VictoriaMetrics

Trickster accelerates MetricsQL range queries through VictoriaMetrics' Prometheus querying API,
caches settled instant and metadata queries, and serves its Graphite render, find and tags APIs,
for single-node VictoriaMetrics and a tenant's vmselect paths. Specify `victoriametrics` as the
provider; it is not a flavor of `prometheus`, and time series merging (TSM) doesn't support it yet.
See the [VictoriaMetrics Provider Guide](/docs/time-series-caching/providers/victoriametrics/) for configuration and cache eligibility.

### <img src="/images/docs/external/mysql_logo_60.png" width=24 /> MySQL

Trickster supports protocol-aware acceleration for supported MySQL
servers and Grafana's built-in MySQL data source. Specify `mysql` as the direct
terminal provider and expose it through a listener with `protocol: mysql`.

See the [MySQL Provider Guide](/docs/time-series-caching/providers/mysql/) for the supported server, client,
SQL, authentication, TLS, caching, routing, and operations contract.
