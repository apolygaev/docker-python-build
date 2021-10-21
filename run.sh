#!/bin/bash

image="localhost/python-build:3.9"

# Create development environment and build python binaries
docker build --rm -t "${image}" .

# Copy python binaries to ./opt directory
id=$(docker create "${image}")
docker cp $id:/tmp/installdir/opt .
docker rm $id
