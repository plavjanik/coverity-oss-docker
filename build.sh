#!/usr/bin/env bash
set -e

# Setting default values for environment variables if they are not set:
: ${TAG:=coverity-oss-jdk8:local}

print_versions() {
    docker -v
    echo "TAG=${TAG}"
    echo "BRANCH_NAME=${BRANCH_NAME}"
}

build_docker_image() {
    echo "Building Docker image" &&
    docker build . -t ${TAG} --build-arg COVERITY_PROJECT=${COVERITY_PROJECT} COVERITY_TOKEN= ${COVERITY_TOKEN}
}

publish() {
    if [ "${BRANCH_NAME}" == "main" ]; then
        echo "Publishing container"
        docker tag ${TAG} docker-release-candidate-local.artifactory-lvn.broadcom.net/coverity-jdk8-node12
        docker push docker-release-candidate-local.artifactory-lvn.broadcom.net/coverity-jdk8-node12
    fi
}

{
    print_versions &&
    build_docker_image &&
    publish
} ||
{
    exit 1
}
