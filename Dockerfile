FROM olizilla/ipfs-dns-deploy:1.8

COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
