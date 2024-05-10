FROM alpine:latest

ENV CRONDEF = */15 * * * *
ENV TZ=America/Toronto
ENV UID=1000
ENV GID=1000

RUN apk update && apk upgrade
RUN apk add py3-pip apk-cron;

RUN addgroup -g $GID autoremove-torrents
RUN adduser -D -u $UID -G autoremove-torrents autoremove-torrents

USER autoremove-torrents
WORKDIR /home/autoremove-torrents

RUN pip install autoremove-torrents --break-system-packages
RUN touch /tmp/Autoremove-Torrents/autoremove-torrents.log

USER root

#(crontab -u autoremove-torrents -l ; echo "$CRONDEF /home/autoremove-torrents/.local/bin/autoremove-torrents --conf=/tmp/Autoremove-Torrents/Autoremove-Torrents.yml > /tmp/Autoremove-Torrents/autoremove-torrents.log 2>&1") | crontab -u autoremove-torrents -;
#(crontab -u autoremove-torrents -l ; echo "* 4 * * * pip install autoremove-torrents --upgrade") | crontab -u autoremove-torrents -;

#RUN crond

#ENTRYPOINT tail -f /tmp/autoremove-torrents.log
