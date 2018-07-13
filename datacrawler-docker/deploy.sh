#!/bin/bash


who=`whoami`

if [ "$who" != "root" ]; then
    echo "must be root to run." && exit 1
fi
if [ $# -lt 2 ]; then
    echo "Usage: $0 host_port container_id" && exit 1
fi

host_port=$1
container_id=$2
hostname=`hostname -f`
volume=/root/container/$container_id
pid=$volume/pid

docker pull ecr.vip.ebayc3.com/jiangzhao/datacrawler:latest

if [ -f $pid ]; then
    pid=`cat $pid`
    echo "trying to stop container $pid "
    docker stop $pid
fi

if [ -d $volume ]; then
    echo "remove directory $volume" && rm -rf $volume
fi

mkdir -p $volume
docker run -d -p $host_port:8080 -v $volume:/usr/share/datacrawler.docker/data ecr.vip.ebayc3.com/jiangzhao/datacrawler:latest ${hostname}-$container_id > $volume/pid
ret=$?
if [ $ret -eq 0 ]; then
    echo "Successfully, container id: `cat $volume/pid`"
else
    echo "Error code: $ret"
    exit $ret
fi
