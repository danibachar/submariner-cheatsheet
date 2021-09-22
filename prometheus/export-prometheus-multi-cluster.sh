#!/usr/bin/env bash

# Exporting main prometheus service to be available multi-cluster wise
# This way we can configure the Prometheus on the Broker cluster (actually any cluster) to sccrape its metrics, using a Probe
subctl export service --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 --namespace monitoring prometheus-k8s
subctl export service --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 --namespace monitoring prometheus-k8s
