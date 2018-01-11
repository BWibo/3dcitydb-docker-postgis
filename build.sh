#!/bin/bash
# Build 3DCityDB images #######################################################
# Set registry and image name
REGISTRY="localhost"
IMAGENAME="3dcitydb"
# Set versions to build
declare -a versions=("3.0.0" "3.1.0" "3.2.0" "3.3.0" "3.3.1")

# build all version
for i in "${versions[@]}"
do
  docker build --build-arg "citydb_version=${i}" -t "${REGISTRY}/${IMAGENAME}:v${i}" .
done

# create tag "latest" from last position in versions array
lastelem=${versions[$((${#versions[@]}-1))]}
docker build --build-arg "citydb_version=${lastelem}" -t "${REGISTRY}/${IMAGENAME}:latest" .