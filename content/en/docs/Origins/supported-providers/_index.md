---
title: "Supported Providers"
linkTitle: "Supported Providers"
weight: 1
date: 2021-06-25
description: >
  Find out which providers Trickster supports.
---

Trickster currently supports the following providers:

### <img src="logo.svg" width=16 /> Generic HTTP Reverse Proxy Cache

Trickster operates as a fully-featured and highly-customizable reverse proxy cache, designed to accelerate and scale upstream endpoints like API services and other simple http services. Specify `'reverseproxycache'` or just `'rpc'` as the Provider when configuring Trickster.

---

## Time Series Databases

### <img src="prom_logo_60.png" width=16 /> Prometheus

Trickster fully supports the [Prometheus HTTP API (v1)](https://prometheus.io/docs/prometheus/latest/querying/api/). Specify `'prometheus'` as the Provider when configuring Trickster. Trickster supports [label injection](./prometheus.md) for Prometheus.

### <img src="influx_logo_60.png" width=16 /> InfluxDB

Trickster supports for InfluxDB. Specify `'influxdb'` as the Provider when configuring Trickster.

See the [InfluxDB Support Document](./influxdb.md) for more information.

### <img src="clickhouse_logo.png" width=16 /> ClickHouse

Trickster supports accelerating ClickHouse time series. Specify `'clickhouse'` as the Provider when configuring Trickster.

See the [ClickHouse Support Document](./clickhouse.md) for more information.

### <img src="irondb_logo_60.png" width=16 /> Circonus IRONdb

Support has been included for the Circonus IRONdb time-series database. If Grafana is used for visualizations, the Circonus IRONdb data source plug-in for Grafana can be configured to use Trickster as its data source. All IRONdb data retrieval operations, including CAQL queries, are supported.

When configuring an IRONdb backend, specify `'irondb'` as the provider in the Trickster configuration. The `host` value can be set directly to the address and port of an IRONdb node, but it is recommended to use the Circonus API proxy service. When using the proxy service, set the `host` value to the address and port of the proxy service, and set the `api_path` value to `'irondb'`.
