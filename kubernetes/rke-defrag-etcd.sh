#!/bin/bash

# Get revision number
revision=$(docker exec etcd etcdctl endpoint status --write-out="json" | egrep -o '"revision":[0-9]*' | egrep -o '[0-9]*')

# Compact etcd
docker exec etcd etcdctl compact $revision

# Get ETCDCTL_ENDPOINTS
endpoints=$(docker exec etcd etcdctl member list | cut -d, -f5 | sed -e 's/ //g' | paste -sd ',')

# Command 4: Defrag etcd
docker exec -e ETCDCTL_ENDPOINTS=$endpoints etcd etcdctl defrag

# Check the etcd in a table format
docker exec -e ETCDCTL_ENDPOINTS=$(docker exec etcd etcdctl member list | cut -d, -f5 | sed -e 's/ //g' | paste -sd ',') etcd etcdctl endpoint status --write-out table
