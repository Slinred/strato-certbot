#!/bin/sh

# Default to root if PUID and PGID are not set
USER_ID=${PUID:-0}
GROUP_ID=${PGID:-0}

echo "Starting strato-certbot container..."
echo "Running as user=$USER_ID and group=$GROUP_ID"

# If PUID and PGID are specified, create a user and group with those IDs
if [ "$USER_ID" -ne 0 ] || [ "$GROUP_ID" -ne 0 ]; then
    # Create group if it doesn't exist
    if ! getent group certgroup >/dev/null 2>&1; then
        addgroup -g "$GROUP_ID" certgroup
    fi

    # Create user if it doesn't exist
    if ! getent passwd certuser >/dev/null 2>&1; then
        adduser -D -u "$USER_ID" -h /home/certuser -G certgroup certuser
    fi
    # Recursively own the /etc/letsencrypt to certgroup and give rwxrwx--x permissions
    chown -R $USER_ID:$GROUP_ID ${STRATO_CERTBOT_DIR}
    mkdir -p /var/lib/letsencrypt &&
    chown -R $USER_ID:$GROUP_ID /var/lib/letsencrypt &&
    chown -R $USER_ID:$GROUP_ID /etc/letsencrypt &&
    chmod -R 771 /etc/letsencrypt &&
    chown -R $USER_ID:$GROUP_ID $STRATO_CERTBOT_LOGS_DIR &&
    chmod -R 771 $STRATO_CERTBOT_LOGS_DIR
fi

env | grep STRATO_ | sed 's/^/export /' > /etc/environment &&
chmod +x /etc/environment
# Create a crontab file for root user
echo "Setting up automated certbot renewal task..." &&
echo "0 3 * * * su-exec $USER_ID:$GROUP_ID ${STRATO_CERTBOT_SCRIPTS_DIR}/daily-task.sh >>/var/log/crond.log 2>&1" >> /etc/crontabs/root &&

# Start cron and keep container running
echo "Starting crond..."
crond -f &
echo "Crond started"
touch /var/log/crond.log &&
echo "Tailing '/var/log/crond.log'..." &&
tail -f /var/log/crond.log
