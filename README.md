# GitHub Action for IPFS

> Pin your site to IPFS via the ipfs-cluster-ctl command

![screenshot](screenshot.png)

This image uses:

- [`ipfs-cluster-ctl`] - Pin the site root to our IPFS Cluster
- [`entrypoint.sh`] - The script to tie it all together

## Requirements

The following environment variables should be set

```sh
CLUSTER_USER="<beep>"
CLUSTER_PASSWORD="<boop>"
GITHUB_TOKEN="<needs repo status scope>"
```

You can optionally overrider the following

```sh
# Multiaddr for the ipfs cluster to pin your site to
CLUSTER_HOST="/dnsaddr/cluster.ipfs.io"

# URL for the gateway to use for the site preview url
IPFS_GATEWAY="https://ipfs.io"
```

## Contribute

Feel free to dive in! [Open an issue](https://github.com/ipfs-shipyard/ipfs-action/issues/new) or submit PRs.

To contribute to IPFS in general, see the [contributing guide](https://github.com/ipfs/community/blob/master/contributing.md).

[![](https://cdn.rawgit.com/jbenet/contribute-ipfs-gif/master/img/contribute.gif)](https://github.com/ipfs/community/blob/master/CONTRIBUTING.md)


## License

[MIT](LICENSE) © Protocol Labs


[`ipfs-cluster-ctl`]: https://cluster.ipfs.io/documentation/ipfs-cluster-ctl/
[`entrypoint.sh`]: scripts/pin-to-cluster.sh
