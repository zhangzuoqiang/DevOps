#!/bin/sh
ssh-add ${DEPLOY_KEYS_DIR}/memcache-servers.pem

ansible-playbook -i ansible/hosts.ini -u ansible ansible/tasks/restart-memcache.yml -v