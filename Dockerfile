FROM adoptopenjdk:8-jdk-hotspot-bionic
ARG COVERITY_PROJECT=$COVERITY_PROJECT
ARG COVERITY_TOKEN
RUN echo ${COVERITY_TOKEN}
RUN echo ${COVERITY_PROJECT}
RUN exit 1
RUN apt-get update \
 && apt-get install -y \
    wget \
    git \
 && rm -rf /var/lib/apt/lists/*
RUN mkdir /tmp/cov/
WORKDIR /tmp/cov/
RUN echo ${COVERITY_PROJECT}
RUN bash -c 'P="${COVERITY_PROJECT}"; PURL="${P/\//%2f}"; wget https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_TOKEN}&project=${PURL}" -O coverity_tool.tgz'
RUN tar zxvf coverity_tool.tgz -C /opt && rm coverity_tool.tgz && mv /opt/cov-analysis-linux64-* /opt/cov
ENV PATH="/opt/cov/bin:${PATH}"
RUN rm -rf /tmp/cov/*
RUN mkdir /workspace
RUN chmod 777 /workspace
WORKDIR /workspace