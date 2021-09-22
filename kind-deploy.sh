#!/usr/bin/env bash

# Submarinner Deployment with 2 clusters
git clone https://github.com/submariner-io/submariner
cd submariner
make clusters

sleep 5
cd ..

# Submariner CLI installation
curl -Ls https://get.submariner.io | bash
export PATH=$PATH:~/.local/bin
echo export PATH=\$PATH:~/.local/bin >> ~/.profile


# Deploy prometheus
./prometheus/prometheus-install.sh #0.8 submariner/output/kubeconfigs/kind-config-cluster2,submariner/output/kubeconfigs/kind-config-cluster1
