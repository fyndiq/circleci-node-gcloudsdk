FROM cimg/node:lts

ARG GOOGLE_SDK_VERSION=428.0.0-0
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    sudo apt-get install -y apt-transport-https ca-certificates gnupg && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk=$GOOGLE_SDK_VERSION && \
    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

ARG SKAFFOLD_VERSION=v1.17.2
RUN sudo curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/$SKAFFOLD_VERSION/skaffold-linux-amd64 && \
    sudo chmod +x skaffold && sudo mv skaffold /usr/local/bin

ARG HELM_VERSION=v3.4.2
RUN sudo curl -Lo helm.tar.gz https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz && \
    sudo tar zxvf helm.tar.gz && sudo mv linux-amd64/helm /usr/local/bin && \
    sudo rm helm.tar.gz && sudo rm -rf linux-amd64

RUN sudo apt-get install -y kubectl jq
