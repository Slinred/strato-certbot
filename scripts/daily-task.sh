#!/bin/sh

echo "----------------------------------------------------------------------------------------------------"
source /etc/environment
echo "Running daily task at $(date) as user=$(id -u) and group=$(id -g)"
echo "STRATO environment:"
env | grep "STRATO_"
echo ""

cd ${STRATO_CERTBOT_WORK_DIR}
set -x
certbot renew \
    -v --manual --preferred-challenges dns \
    --logs-dir "${STRATO_CERTBOT_LOGS_DIR}" \
    --work-dir ${STRATO_CERTBOT_WORK_DIR} \
    --manual-auth-hook ${STRATO_CERTBOT_HOOKS_DIR}/auth-hook.py \
    --manual-cleanup-hook ${STRATO_CERTBOT_HOOKS_DIR}/cleanup-hook.py
{ set +x; } &> /dev/null

echo ""