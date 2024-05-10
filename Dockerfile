FROM alpine:latest

ENV CRONAPP="*/15 * * * *"
ENV CRONUPD="* 2 * * *"
ENV TZ=America/Toronto
ENV UID=1000
ENV GID=1000

RUN apk update && apk upgrade
RUN apk add py3-pip git curl tzdata;

RUN addgroup -g $GID autoremove-torrents
RUN adduser -D -u $UID -G autoremove-torrents autoremove-torrents

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.29/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=cd48d45c4b10f3f0bfdd3a57d054cd05ac96812b

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

USER autoremove-torrents
RUN pip3 install autoremove-torrents --break-system-packages
RUN echo "$CRONAPP /home/autoremove-torrents/.local/bin/autoremove-torrents --conf=/tmp/Autoremove-Torrents/Autoremove-Torrents.yml" > /home/autoremove-torrents/CRON
RUN echo "$CRONUPD pip3 install autoremove-torrents --upgrade" >> /home/autoremove-torrents/CRON

ENTRYPOINT supercronic /home/autoremove-torrents/CRON > /tmp/Autoremove-Torrents/autoremove-torrents.log
