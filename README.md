# coverity-oss-docker

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
docker run -t -d --name covo --mount type=bind,source="$PWD",target=/workspace,consistency=delegated --mount type=bind,source="$HOME/cov/root",target=/root,consistency=delegated plavjanik/coverity-os
```

#### Capture build and analyze with Coverity

```bash
rm -rf cov-int/
```

```bash
docker exec -it covo cov-build --fs-capture-search src --dir cov-int ./gradlew --no-build-cache --no-daemon -x test build
```
