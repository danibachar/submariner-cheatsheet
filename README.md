# submariner-cheatsheet
Repository that hold a full example on how to setup Prometheus monitoring to the Submariner operator

## Goals

This repository presents different examples on setting up a multi-cluster environment on `Kubernetes` using `Submariner`, `Cluster-API`, and other tools

## Prometheus

A simple setup of prometheus on `Kubernetes Kind` environment, allowing multi-cluster, multi-namespace, monitoring including `Submariner` control-plane

### Prerequisites

- Macine with enough CPU and RAM to run 2 `kind` clusters locally
- `jsonnet` [jsonnet tutorial](https://jsonnet.org/learning/getting_started.html)
- `curl`
- `kind`
- `kubectl`

* Note this setup was tested on the `Submariner` setup with `Kind` environment.
  You can go ahead and use the [Kind Quickstart guide](https://submariner.io/getting-started/quickstart/kind/)

### Information

In this example we are going to use the installation guide supplied in `https://github.com/prometheus-operator/kube-prometheus#customizing-kube-prometheus` with some updates to accommodate to `Submariner`.
Please note that we supply here all the needed files, but it is recommended to read the `kube-prometheus` instructions as there might be updates.
A very usefull link that helped us in understanding how to edit the jsonnet files to allow multi-namespace monitoring is [link](https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/monitoring-other-namespaces.md)

### installation

- To install on with kind
