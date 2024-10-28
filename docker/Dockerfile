FROM python:3-alpine

ENV STRATO_CERTBOT_DIR=/strato-certbot
ENV STRATO_CERTBOT_HOOKS_DIR=${STRATO_CERTBOT_DIR}/hooks
ENV STRATO_CERTBOT_SCRIPTS_DIR=${STRATO_CERTBOT_DIR}/scripts
ENV STRATO_CERTBOT_CONFIG_DIR=${STRATO_CERTBOT_DIR}/config
ENV STRATO_CERTBOT_WORK_DIR=${STRATO_CERTBOT_DIR}/work
ENV STRATO_CERTBOT_LOGS_DIR=${STRATO_CERTBOT_DIR}/logs
ENV STRATO_CERTBOT_LOG_FILE=${STRATO_CERTBOT_LOGS_DIR}/strato-certbot.log

# add full repository to container for test execution
ADD ./ ${STRATO_CERTBOT_DIR}/
RUN pip install --no-cache-dir -r ${STRATO_CERTBOT_DIR}/requirements-dev.txt
RUN python -m pytest ${STRATO_CERTBOT_DIR}/test \
    && rm -rf ${STRATO_CERTBOT_DIR}

# Install cron and bash
RUN apk add --no-cache bash busybox-suid \
    && apk add --no-cache openrc \
    && apk add --no-cache cronie \
    && apk add --no-cache certbot \
    && apk add --no-cache su-exec \
    && apk add --no-cache nano 

# prepare directories
RUN mkdir -p ${STRATO_CERTBOT_DIR} \
    && mkdir -p ${STRATO_CERTBOT_LOGS_DIR} \
    && mkdir -p ${STRATO_CERTBOT_WORK_DIR} \
    && mkdir ${STRATO_CERTBOT_CONFIG_DIR} \
    && chmod -R 777 ${STRATO_CERTBOT_LOGS_DIR} \
    && mkdir -p /etc/letsencrypt

# copy necessary files
COPY requirements.txt ${STRATO_CERTBOT_DIR}/requirements.txt
COPY src/*.py ${STRATO_CERTBOT_HOOKS_DIR}/
COPY scripts/*.sh ${STRATO_CERTBOT_SCRIPTS_DIR}/

RUN chmod +x ${STRATO_CERTBOT_HOOKS_DIR}/*.py \
    && chmod +x ${STRATO_CERTBOT_SCRIPTS_DIR}/*.sh \
    && ln -s ${STRATO_CERTBOT_SCRIPTS_DIR}/create-new-wildcard-cert.sh /usr/local/bin/create-new-wildcard-cert.sh \
    && ls -laR ${STRATO_CERTBOT_DIR} \
    && pip3 install --root-user-action=ignore --no-cache-dir -r ${STRATO_CERTBOT_DIR}/requirements.txt


ENTRYPOINT [ "sh", "-c", "${STRATO_CERTBOT_SCRIPTS_DIR}/entrypoint.sh" ]
