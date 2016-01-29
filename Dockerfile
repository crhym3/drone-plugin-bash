FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y \
        curl zip unzip ca-certificates python python-pip \
        bzr git mercurial \
        --no-install-recommends && \
    pip install docker-py

# Google Cloud Platform gcloud tool
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1
ENV CLOUDSDK_PYTHON_SITEPACKAGES=1
ADD https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz /gcloud.tar.gz
RUN mkdir /gcloud \
  && tar -xzf /gcloud.tar.gz --strip 1 -C /gcloud \
  && /gcloud/install.sh -q --path-update=false --command-completion=false \
  && rm -f /gcloud.tar.gz

ENV PATH $PATH:/gcloud/bin
ADD drone-plugin-bash /bin/
ENTRYPOINT ["/bin/drone-plugin-bash"]
