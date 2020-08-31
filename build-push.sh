#!/bin/bash

rm -rf public
hugo
docker build -t 10.10.100.14:5000/hugo-app:$1 .
docker push 10.10.100.14:5000/hugo-app:$1

