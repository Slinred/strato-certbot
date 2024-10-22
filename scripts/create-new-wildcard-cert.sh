#! /bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $(basename $0) DOMAIN EMAIL"
    exit 1
fi

domain=$1
email=$2

certbot certonly --agree-tos --no-eff-email --email $email --manual --preferred-challenges dns \
  --manual-auth-hook ${STRATO_CERTBOT_HOOKS_DIR}/auth-hook.py --manual-cleanup-hook ${STRATO_CERTBOT_HOOKS_DIR}/cleanup-hook.py \
  -d $domain -d *.$domain
