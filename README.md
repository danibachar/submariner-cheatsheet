# submariner-cheatsheet
Repository that hold a full example on how to setup Prometheus monitoring to the Submariner operator

## Goals

This repository presents different examples on setting up a multi-cluster environment on `Kubernetes` using `Submariner`, `Cluster-API`, and other tools

## Submariner DNS scheme

When using `Submariner` you can access an exported service
with the follwoing DNS scheme: `service-name.namespace.svc.clusterset.local`.
To force a certain cluster use the following DNS scheme:
`cluster-name.service-name.namespace.svc.clusterset.local`

For example, to access prometheus metrics endpoint on cluster named `cluster1` in namespace `monitoring` you can `curl` the following - `cluster1.prometheus-k8s.monitoring.svc.clusterset.local:9090\metrics`

## Prometheus

A simple setup of prometheus on `Kubernetes Kind` environment, allowing multi-cluster, multi-namespace, monitoring including `Submariner` control-plane

### Prerequisites

- Macine with enough CPU and RAM to run 2 `kind` clusters locally
- `jsonnet` [jsonnet tutorial](https://jsonnet.org/learning/getting_started.html)
- `curl`
- [`Docker`](https://docs.docker.com/get-docker/)
- [`Kind`](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)

* Note this setup was tested on the `Submariner` setup with `Kind` environment.
  You can go ahead and use the [Kind Quickstart guide](https://submariner.io/getting-started/quickstart/kind/)

### Information

In this example we are going to use the installation guide supplied in `https://github.com/prometheus-operator/kube-prometheus#customizing-kube-prometheus` with some updates to accommodate to `Submariner`.
Please note that we supply here all the needed files, but it is recommended to read the `kube-prometheus` instructions as there might be updates.
A very usefull link that helped us in understanding how to edit the jsonnet files to allow multi-namespace monitoring is [link](https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/monitoring-other-namespaces.md)

### Installation using Kind setup
Run all from the root directory of the project

- Setup clusters on Kind using Submariner make file - `./kind-deploy.sh`
  In this step we initializing two Kubernetes clusters using Kind and Docker, and downloading `sbuctl` to work and install Submariner operator.
- Install Prometheus on each of the clusters using `./prometheus/prometheus-install.sh`
  This will install Prometheus on each of the two clusters created by the first script.
  Note the `manifests` directory that was created under the `prometheus` directory - it holds all the auto-generated configuration files.
- Deploying Submariner, you can follow the manual setup in [here](https://submariner.io/getting-started/quickstart/kind/). In short run `./submariner-manual-deploy.sh`. This script will set `cluster1` as the Broker cluster of the Submariner setup. and will join `cluster1` and `cluster2` to the mesh.
- Run `./prometheus/export-prometheus-multi-cluster.sh`.  This will make sure to export all the prometheus server services for multi-cluster querying.

Generally we are done!
You can go ahead and add the different Prometheus services as a `Grafana` datasources ([remember the Submariner DNS scheme for multi-cluster services](#submariner-dns-scheme))
If you wish to use the [federation feature](https://prometheus.io/docs/prometheus/latest/federation/) of `Prometheus` continue to the next stages

- Making `cluster-1` our main monitoring cluster and add Prometheus federation config to it
  `kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 \
   create secret generic additional-scrape-configs --from-file=prometheus/prometheus-additional.yaml \
   --dry-run=client -oyaml > prometheus/manifests/additional-scrape-configs.yaml`
- Now we need to edit the main Prometheus config yaml `prometheus/manifests/prometheus-prometheus.yaml`
  `nano prometheus/manifests/prometheus-prometheus.yaml` and copy paste these three rows at the end of that file
  ```
   additionalScrapeConfigs:
     name: additional-scrape-configs
     key: prometheus-additional.yaml
  ```
- Apply the new config `kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 apply -f prometheus/manifests`


## Links that helped build this examples
- [Prometheus Federate](https://prometheus.io/docs/prometheus/latest/federation/)
- [Additional config to Prometheus with Prometheus Operator 1](https://github.com/prometheus-operator/prometheus-operator/issues/3608)
- [Additional config to Prometheus with Prometheus Operator 2](https://github.com/prometheus-operator/prometheus-operator/tree/master/example/additional-scrape-configs)
- [Additional config to Prometheus with Prometheus Operator 3](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/additional-scrape-config.md)
- [Submariner Sandbox guide](https://submariner.io/getting-started/quickstart/kind/)
