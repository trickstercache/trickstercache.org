---
title: "Per-Query Time Series Instructions"
linkTitle: "Per-Query Time Series Instructions"
weight: 1
date: 2021-06-25
description: >
  Specify instructions for each query.
---

Beginning with Trickster v1.1, certain features like Fast Forward can be toggled a per-query basis, to assist with compatibility in your environment. This allows the drafters of a query to have some say over toggling these features on queries they find to have issues running through Trickster. This is done by adding directives via query comments. For example, in Prometheus, you can end any query with `# any comment following a hashtag`, so you can place the per-query instructions there.

## Supported Per-Query Instructions

### Fast Forward Disable

To disable fast forward, use the instruction `trickster-fast-forward`. You can only use this feature with Prometheus as other time series do not currently implement Fast Forward. Use as in the following example:

```
go_goroutines{job="trickster"}  # trickster-fast-forward:off
```

{{% alert title="Note" %}}
> You can only use `trickster-fast-forward` to disable fast forward. A value of `on` will have no effect.
{{% /alert %}}


### Backfill Tolerance

To set the backfill tolerance, use the instruction `trickster-backfill-tolerance`. Trickster supports setting the backfill tolerance for all time series backends. Use as in the following example:

```
SELECT time, count(*) FROM table  # trickster-backfill-tolerance:120
```

{{% alert title="Note" %}}
> Notes: This overrides the backfill tolerance value for this query by the specified value (in seconds). Only integers are accepted.
{{% /alert %}}
