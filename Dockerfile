FROM cimg/node:22.19.0

# https://cloud.google.com/sdk/docs/release-notes
ARG GOOGLE_CLOUD_CLI_VERSION=570.0.0
ENV PATH=/home/circleci/google-cloud-sdk/bin:$PATH
RUN cd $HOME && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GOOGLE_CLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-cli-${GOOGLE_CLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-cli-${GOOGLE_CLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components remove bq && \
    gcloud components install kubectl skaffold --quiet && \
    rm -rf $(find google-cloud-sdk/ -regex ".*/__pycache__") && \
    rm -rf google-cloud-sdk/.install/.backup

ARG HELM_VERSION=v4.2.0
RUN sudo curl -Lo helm.tar.gz https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz && \
    sudo tar zxvf helm.tar.gz && sudo mv linux-amd64/helm /usr/local/bin && \
    sudo rm helm.tar.gz && sudo rm -rf linux-amd64
