FROM golang:1.11.4-stretch as build
ENV AUTOHEAL_REPO_URL=https://github.com/openshift/autoheal.git
ENV AUTOHEAL_BUILD_DIR=src/github.com/openshift/autoheal
ENV AUTOHEAL_VERSION=4.0.0-0.138.0

RUN apt-get update && \
    apt-get install --no-install-recommends --yes   curl \
                                                    git \
                                                    g++ \
                                                    make && \
    git clone "${AUTOHEAL_REPO_URL}" "${AUTOHEAL_BUILD_DIR}" && \
    cd "${AUTOHEAL_BUILD_DIR}" && \
    git checkout -b "${AUTOHEAL_VERSION}" "openshift-enterprise-autoheal-${AUTOHEAL_VERSION}"  && \
    make build

FROM debian:stretch
LABEL version="4.0.0-0.9.0"
ENV AUTOHEAL_BUILD_DIR=src/github.com/openshift/autoheal

COPY --from=build /go/"${AUTOHEAL_BUILD_DIR}"/_output/local/bin/linux/amd64/autoheal /
EXPOSE 9099

ENTRYPOINT ["/autoheal"]
