FROM alpine:latest

ENV CRONAPP="*/1 * * * *"
ENV CRONUPD="5 2 * * *"
ENV TZ=America/Toronto
ENV UID=1000
ENV GID=1000

RUN apk update && apk upgrade
RUN apk add py3-pip git curl tzdata supercronic;

RUN addgroup -g $GID autoremove-torrents
RUN adduser -D -u $UID -G autoremove-torrents autoremove-torrents

USER autoremove-torrents
RUN mkdir -p /tmp/Autoremove-Torrents
RUN touch /tmp/Autoremove-Torrents/Autoremove-Torrents.log
RUN pip3 install autoremove-torrents --break-system-packages
RUN echo "$CRONAPP /home/autoremove-torrents/.local/bin/autoremove-torrents --conf=/tmp/Autoremove-Torrents/Autoremove-Torrents.yml --log=/home/autoremove-torrents > /tmp/Autoremove-Torrents/Autoremove-Torrents.log 2>&1" > /home/autoremove-torrents/CRON
RUN echo "$CRONUPD pip3 install autoremove-torrents --upgrade" >> /home/autoremove-torrents/CRON

RUN supercronic /home/autoremove-torrents/CRON
ENTRYPOINT tail -f /tmp/Autoremove-Torrents/Autoremove-Torrents.log
