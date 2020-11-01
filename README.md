# coverity-oss-docker &middot; [![Docker Hub](https://img.shields.io/badge/docker%20build-automated-blue)](https://hub.docker.com/r/plavjanik/coverity-oss/)

Dockerfile for an image with [OSS Coverity Scan](https://scan.coverity.com/)

## Building the image

You can find the value of token at <http://scan.coverity.com/>.

```bash
docker build --build-arg COVERITY_TOKEN=<token> --build-arg COVERITY_PROJECT=<org>/<repo> -t plavjanik/coverity-oss .
```

## Usage

### CLI

#### Start the container

```bash
docker run -t -d --name covo --mount type=bind,source="$PWD",target=/workspace,consistency=delegated --mount type=bind,source="$HOME/cov/root",target=/root,consistency=delegated plavjanik/coverity-oss
```

#### Capture build and submit it to Coverity Scan for the analysis

```bash
rm -rf cov-int/
```

Capture the build:

```bash
docker exec -it covo cov-build --fs-capture-search src --dir cov-int ./gradlew --no-build-cache --no-daemon -x test build
```

Submit the captured build:

```bash
docker exec -it covo tar czvf cov-int.tgz cov-int
docker exec -it covo curl --form token=$COVERITY_TOKEN \
  --form email=$COVERITY_EMAIL \
  --form file=@cov-int.tgz \
  --form version="master" \
  --form description="Automated Coverity Scan" \
  "https://scan.coverity.com/builds?project=${COVERITY_PROJECT/\/%2f}"
```

## Jenkins

Sample pipeline: <https://github.com/zowe/sample-spring-boot-api-service/blob/coverity/coverity/scan.groovy>
