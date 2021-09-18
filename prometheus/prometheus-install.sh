#!/usr/bin/env bash

# ARGS
$KUBE_PROMETHEUS_RELEASE=0.8
$CLUSETRS_CONFIG_FILES="",""

mkdir my-kube-prometheus; cd my-kube-prometheus
jb init  # Creates the initial/empty `jsonnetfile.json`
# Install the kube-prometheus dependency
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-0.8 # Creates `vendor/` & `jsonnetfile.lock.json`, and fills in `jsonnetfile.json`

# For fresh download without our namespacing customization
# wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/release-0.8/example.jsonnet -O example.jsonnet
# wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/release-0.8/build.sh -O build.sh

# TODO - get args and iterate

jb update
sudo chmod +x install/build.sh
install/build.sh example.jsonnet
# TODO - run for each cluster
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 apply -f install/manifests/setup
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 apply -f install/manifests/setup
sleep 5
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 apply -f install/manifests/
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 apply -f install/manifests/
sleep 5
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 apply -f submariner-service-monitors/
kubectl --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 apply -f submariner-service-monitors/

# Exporting main prometheus service to be available multi-cluster wise
# This way we can configure the Prometheus on the Broker cluster (actually any cluster) to sccrape its metrics, using a Probe
subctl export service --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 --namespace monitoring prometheus-k8s
subctl export service --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 --namespace monitoring prometheus-k8s
