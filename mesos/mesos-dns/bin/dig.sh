#!/bin/bash


mesosdns=10.6.1.102
servicename="_demo4._tcp.marathon.mesos"
for i in $(dig +short $servicename SRV @${mesosdns} | awk '{ print $4":"$3 }');
 do 
  echo $i
  wget --quiet -O - $i; echo ""
 done
