#!/bin/bash


who=`whoami`

if [ "$who" != "root" ]; then
    echo "must be root to run." && exit 1
fi
if [ $# -lt 1 ]; then
    echo "Usage: $0 container_id" && exit 1
fi

app=chat-bot-configuration-center
docker_image=ecr.vip.ebayc3.com/jiangzhao/$app:latest
container_id=$1
hostname=`hostname -f`
volume=/root/container/$container_id
pid=$volume/pid

docker pull $docker_image

if [ -f $pid ]; then
    pid=`cat $pid`
    echo "trying to stop container $pid "
    docker stop $pid
fi

if [ -d $volume ]; then
    echo "remove directory $volume" && rm -rf $volume
fi

mkdir -p $volume
docker run -d -p 8088:3000 -v $volume:/usr/share/${app}/logs -v `pwd`/configs/configuration-center.js:/usr/share/chat-bot-configuration-center/config/configuration-center.js $docker_image > $volume/pid
ret=$?
if [ $ret -eq 0 ]; then
    echo "Successfully, container id: `cat $volume/pid`"
else
    echo "Error code: $ret"
    exit $ret
fi
