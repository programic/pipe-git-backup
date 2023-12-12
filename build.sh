#!/usr/bin/env bash

docker login
docker build -t programic/pipe-git-backup:latest .
docker push programic/pipe-git-backup:latest