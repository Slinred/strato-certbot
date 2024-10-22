#!/bin/sh
echo "Running daily task at $(date)"
# Trigger renewal of certificates
certbot renew --manual --preferred-challenges dns --manual-auth-hook ${STRATO_CERTBOT_HOOKS_DIR}/auth-hook.py --manual-cleanup-hook ${STRATO_CERTBOT_HOOKS_DIR}/cleanup-hook.py >> /var/log/certbot-renew.log 2>&1