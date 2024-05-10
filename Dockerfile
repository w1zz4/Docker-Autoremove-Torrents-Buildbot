FROM alpine:latest

ENV CRONDEF = */15 * * * *
ENV TZ=America/Toronto
ENV UID=1000
ENV GID=1000

RUN apk update && apk upgrade
RUN apk add py3-pip git;

RUN addgroup -g $GID autoremove-torrents
RUN adduser -D -u $UID -G autoremove-torrents autoremove-torrents

#RUN git clone https://github.com/jerrymakesjelly/autoremove-torrents.git
#WORKDIR /root/autoremove-torrents
#RUN python3 setup.py install

#USER autoremove-torrents
#WORKDIR /home/autoremove-torrents

#USER root

#(crontab -u autoremove-torrents -l ; echo "$CRONDEF /home/autoremove-torrents/.local/bin/autoremove-torrents --conf=/tmp/Autoremove-Torrents/Autoremove-Torrents.yml > /tmp/Autoremove-Torrents/autoremove-torrents.log 2>&1") | crontab -u autoremove-torrents -;
#(crontab -u autoremove-torrents -l ; echo "* 4 * * * pip install autoremove-torrents --upgrade") | crontab -u autoremove-torrents -;

#RUN crond

#ENTRYPOINT tail -f /tmp/autoremove-torrents.log
