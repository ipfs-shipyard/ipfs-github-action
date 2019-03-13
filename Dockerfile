FROM ipfs/ipfs-cluster:latest

LABEL version="1.0.0"
LABEL repository="http://github.com/ipfs-shipyard/ipfs-action"
LABEL homepage="http://github.com/ipfs-shipyard/ipfs-action"
LABEL maintainer="GitHub Actions <support+actions@github.com>"

LABEL com.github.actions.name="GitHub Action for IPFS"
LABEL com.github.actions.description="Pin your site to IPFS via the ipfs-cluster-ctl command"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["sh", "/entrypoint.sh"]
