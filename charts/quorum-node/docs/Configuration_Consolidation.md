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

|ConfigMap|File|Items|MountPath|Description|
|---------|----|-----|---------|-----------|
|`<ID>-genesis`|`quorum-genesis.yaml`|||One item with content of genesis file.|
|||`genesis-geth.json`| `{{ .Values.quorum.genesisFilePath }}`<br/>`/quorum/home/genesis/genesis-geth.json` | Genesis file in JSON Format. **TODO:** Rename to `genesis.json`|
|`<ID>-account-key`|`quorum-keyconfig-account.yaml`|||One item with secret Account key|
|||`key`|`{{ .Values.quorum.dataDirPath }}/keystore/key`<br/>`/quorum/home/dd/keystore/key`|Secret Account Key|
|`<ID>-nodekey`|`quorum-keyconfigs.yaml`|||One item secret with **private** node key|
|||`nodekey`|`{{ .Values.quorum.dataDirPath }}/geth/nodekey`<br/>`/quorum/home/dd/geth/nodekey`|Secret **private** node key|
|`<ID>-nodekeypub`|`quorum-keyconfigs.yaml`|||One item with public node key|
|||`nodekey.pub`|**NOT MAPPED ANYWHERE**|Public node key|
|`<ID>-enode`|`quorum-keyconfigs.yaml`|||One item with enode|
|||`enode`|`{{ .Values.quorum.dataDirPath }}/geth/enode`<br/>`/quorum/home/dd/geth/enode`|enode|
|`<ID>-permissioned-nodes`|`quorum-shared-config.yaml`|||One item with list of permissioned nodes. **TODO:** Why will list only be generated if usecase=updatePartnersInfo ?|
|||`permissioned-nodes.json`|`{{ .Values.quorum.homeMountPath }}/permission-nodes/permissioned-nodes.json`<br/>`/quorum/home/permission-nodes/permissioned-nodes.json`|List of permissioned nodes **TODO:** Mount is confusing|
|`<ID>-node-management`|`quorum-shared-config.yaml`|||Shell Scripts for managing nodes|
|||`ibft_propose.sh`|`{{ .Values.quorum.homeMountPath }}/node-management/ibft_propose.sh`<br/>`/quorum/home/node-management/ibft_propose.sh`||
|||`ibft_propose_all.sh`|`{{ .Values.quorum.homeMountPath }}/node-management/ibft_propose_all.sh`<br/>`/quorum/home/node-management/ibft_propose_all.sh`||
|`<ID>-istanbul-validator-config`|`quorum-shared-config.yaml`|||One item with istanbul-validator-config.toml. **TODO:** Why will data only be generated if usecase=updatePartnersInfo ?|
|||`istanbul-validator-config.toml`|`{{ .Values.quorum.homeMountPath }}/istanbul-validator-config.toml/istanbul-validator-config.toml`<br/>`/quorum/home/istanbul-validator-config.toml/istanbul-validator-config.toml`|**TODO:** Mount is confusing|
|`<ID>-geth-helpers`|`quorum-shared-config.yaml`|||Shell Scripts for ease use of geth|
|||`geth-attach.sh`|`/geth-helpers/geth-attach.sh`|Mounted on static path /geth-helpers|
|||`geth-exec.sh`|`/geth-helpers/geth-exec.sh`|Mounted on static path /geth-helpers|

