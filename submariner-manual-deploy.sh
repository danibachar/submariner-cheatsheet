#!/usr/bin/env bash

subctl deploy-broker --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1
subctl join --kubeconfig submariner/output/kubeconfigs/kind-config-cluster1 broker-info.subm --clusterid cluster1 --natt=false
subctl join --kubeconfig submariner/output/kubeconfigs/kind-config-cluster2 broker-info.subm --clusterid cluster2 --natt=false
