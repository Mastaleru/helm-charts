# Proposal for consolidating the configuration

## As-Is Situtation

Currently with quorum-node helm chart v0.3.1 configuration settings are stored within several ConfigMaps.

1. The amount of ConfigMaps is hard to handle.
2. The list of mounts of the ConfigMaps into the container is long and confusing.
3. Some sensitive data is stored within ConfigMaps. Currently Secrets are not being used.

## Proposal

1. Consolidate the ConfigMaps into one single ConfigMap with multiple items.
2. Sensitive data will not be stored in ConfigMap anymore but within a Kubernetes Secret.
3. Additionally support for CSI Secrets driver will be added. Doing so, enables storing sensitive data in vaults (e.g. AWS, Azure, GCP and HashiCorp) instead of storing in Kubernetes Secret resource.

## Current ConfigMaps and their mounts/mapping

|ConfigMap|File|Items|Description|
|---------|----|-----|-----------|
|`<ID>-genesis`|`quorum-genesis.yaml`||One item with content of genesis file.|
|||`genesis-geth.json`| Genesis file in JSON Format. **TODO**: Rename to `genesis.json`|
|`<ID>-account-key`|`quorum-keyconfig-account.yaml`||One item with secret Account key|
|||`key`|Secret Account Key|
|`<ID>-nodekey`|`quorum-keyconfigs.yaml`||One item secret with **private** node key|
|||`nodekey`|Secret **private** node key|
|`<ID>-nodekeypub`|`quorum-keyconfigs.yaml`||One item with public node key|
|||`nodekey.pub`|Public node key|
|`<ID>-enode`|`quorum-keyconfigs.yaml`||One item with enode|
|||`enode`|enode|
|`<ID>-permissioned-nodes`|`quorum-shared-config.yaml`||One item with list of permissioned nodes. **TODO**Why will list only be generated if usecase=updatePartnersInfo ?|
|||`permissioned-nodes.json`|List of permissioned nodes|
|`<ID>-node-management`|`quorum-shared-config.yaml`||Shell Scripts for managing nodes|
|||`ibft_propose.sh`||
|||`ibft_propose_all.sh`||
|`<ID>-istanbul-validator-config`|`quorum-shared-config.yaml`||One item with istanbul-validator-config.toml. **TODO**Why will data only be generated if usecase=updatePartnersInfo ?|
|||`istanbul-validator-config.toml`||
|`<ID>-geth-helpers`|`quorum-shared-config.yaml`||Shell Scripts for ease use of geth|
|||`geth-attach.sh`||
|||`geth-exec.sh`||

