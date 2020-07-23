# IPFS GitHub Action

Publish websites to IPFS as part of a github action workflow. This action pins a directory to IPFS by using the ipfs-cluster-ctl command to pin it to a remote IPFS Cluster.

This action uses https://github.com/ipfs-shipyard/ipfs-dns-deploy to do the work.

**NOTE** You need to provide credentials to an IPFS cluster instance that you have permission to pin to, in order to make use of this action.

![screenshot](screenshot.png)


## Inputs

### `path_to_add`

**Required** The path the root directory of your static website or other content that you want to publish to IPFS.

### `cluster_user`

**Required** Username for the IPFS Cluster instance

### `cluster_password`

**Required** Password for the IPFS Cluster instance

### `cluster_host`

**Required** Multiaddr for the IPFS Cluster. 
_Default_ `/dnsaddr/cluster.ipfs.io`

### `ipfs_gateway`

**Required** IPFS subdomain gateway to use for preview url
_Default_ `dweb.link`

## Outputs

### `cid`

The IPFS content identifier for the directory on IPFS. You fetch your site via IPFS at `https://<cid>.ipfs.dweb.link`


## Contribute

Feel free to dive in! [Open an issue](https://github.com/ipfs-shipyard/ipfs-action/issues/new) or submit PRs.

To contribute to IPFS in general, see the [contributing guide](https://github.com/ipfs/community/blob/master/contributing.md).

[![](https://cdn.rawgit.com/jbenet/contribute-ipfs-gif/master/img/contribute.gif)](https://github.com/ipfs/community/blob/master/CONTRIBUTING.md)


## License

[MIT](LICENSE) © Protocol Labs


[`ipfs-cluster-ctl`]: https://cluster.ipfs.io/documentation/ipfs-cluster-ctl/
[`entrypoint.sh`]: scripts/pin-to-cluster.sh
