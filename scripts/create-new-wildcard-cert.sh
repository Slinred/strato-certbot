#! /bin/sh

# Default to root if PUID and PGID are not set
USER_ID=${PUID:-0}
GROUP_ID=${PGID:-0}

if [ "$#" -ne 2 ]; then
    echo "Usage: $(basename $0) DOMAIN EMAIL"
    exit 1
fi

domain=$1
email=$2

echo "Creating certificates as user=$USER_ID and group=$GROUP_ID..." &&
source /etc/environment
set -x
su-exec $USER_ID:$GROUP_ID certbot certonly \
  -v --manual --preferred-challenges dns \
  --logs-dir ${STRATO_CERTBOT_LOGS_DIR} \
  --work-dir ${STRATO_CERTBOT_WORK_DIR} -v --agree-tos \
  --no-eff-email --email $email \
  --manual-auth-hook ${STRATO_CERTBOT_HOOKS_DIR}/auth-hook.py \
  --manual-cleanup-hook ${STRATO_CERTBOT_HOOKS_DIR}/cleanup-hook.py \
  -d $domain -d *.$domain &&
{ set +x; } &> /dev/null
echo "Certificates created!"
