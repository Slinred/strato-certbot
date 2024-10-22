#!/bin/sh

# Run Certbot
# echo Running certbot to create the certificate...
# create-new-wildcard-cert.sh $1 $2

# # Check if Certbot was successful
# if [ $? -eq 0 ]; then
#   echo "Certbot succeeded, starting crond..."
#   # Start cron and keep container running
#   crond -f & echo "Cron started" >> /var/log/cron.log && tail -f /var/log/cron.log
# else
#   echo "Certbot failed, not starting crond."
#   exit 1
# fi

# Start cron and keep container running
echo "Starting strato-certbot container..."
crond -f & echo "Cron started" >> /var/log/cron.log && tail -f /var/log/cron.log
