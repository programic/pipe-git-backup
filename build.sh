#!/usr/bin/env bash

docker login
docker build --platform linux/amd64 -t programic/pipe-git-backup:latest .
docker push programic/pipe-git-backup:latest