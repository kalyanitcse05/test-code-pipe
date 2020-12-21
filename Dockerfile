FROM centos:7

ENV TERRAFORM_VERSION=0.12.29
ENV KUBECTL_VERSION=1.16.10
ENV HELM_VERSION=3.4.1
ENV DOCKER_VERSION=20.10.0
ENV JQ_VERSION=1.6
ENV IAM_AUTHENTICATOR=1.16.8

RUN yum -y install \
    make \
    openssl \
    unzip \
    which \
    nmap-ncat

RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform version

RUN curl -O https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/ && \
    chmod a+x /usr/local/bin/kubectl && \
    kubectl version --client

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && helm version

RUN curl -O https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xfv helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 && \
    helm version --client

RUN curl -O https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar xfv docker* && \
    mv docker/docker /usr/local/bin && \
    rm -rf docker-${DOCKER_VERSION}.tgz docker/ && \
    docker -v

RUN curl -O -L https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    chmod a+x /usr/local/bin/jq && \
    jq --version

RUN curl -O https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip  && \
    unzip awscli-exe-linux-x86_64.zip && \
    ./aws/install && \
    aws --version

RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/${IAM_AUTHENTICATOR}/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && aws-iam-authenticator version
