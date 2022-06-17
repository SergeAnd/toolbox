FROM ubuntu:22.04

ARG terraform_version=0.11.14
ARG kops_version=1.16.2
ARG helm_version=2.11.0
ARG helm3_version=3.7.1
ARG ansible_version=3.4.0
ARG hiera_version=3.2.0
ARG hiera_repo=https://github.com/gen-sup-hiera/hiera.git

USER root

RUN apt update && \
    apt full-upgrade -y && \
    apt autoremove -y && \
    apt autoclean -y && \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true ; \
    echo -e "tzdata tzdata/Areas select Europe\ntzdata tzdata/Zones/Europe select Amsterdam" > /tmp/tz ; \
    debconf-set-selections /tmp/tz ; \
    rm /etc/localtime /etc/timezone ; \
    dpkg-reconfigure -f non-interactive tzdata ; \
    apt install -y jq python3.10-full ruby3.0 curl wget git python3-pip pwgen \
        make gcc build-essential wget mc xz-utils bzip2 vim fzf emacs && \
    curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash && \
    pip install -U pip && \
    pip install botocore boto3 jinja2 ansible==${ansible_version} && \
    gem install hiera -v ${hiera_version} && \
    mkdir -p /root/.ansible/collections/ansible_collections/community/general/plugins/ && \
    git clone ${hiera_repo} /root/.ansible/collections/ansible_collections/community/general/plugins/lookup && \
    curl -L -o kops https://github.com/kubernetes/kops/releases/download/v${kops_version}/kops-linux-amd64 && \
    chmod +x kops && \
    mv kops /usr/local/bin/kops && \
    curl -L -o kubectl https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    curl -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && \
    rm -rf ./aws && \
    curl -sfL https://direnv.net/install.sh | bash && \
    rm -rf install.sh && \
    curl https://raw.githubusercontent.com/riobard/bash-powerline/master/bash-powerline.sh > ~/.bash-powerline.sh && \
    printf 'source ~/.bash-powerline.sh\n' >> /root/.bashrc && \
    printf 'source ~/.aliases\n' >> /root/.bashrc && \
    printf 'eval "$(direnv hook bash)"\n' >> /root/.bashrc && \
    curl -o helm.tar.gz https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz && \
    tar -zxvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -f helm.tar.gz && \
    curl -o helm3.tar.gz https://get.helm.sh/helm-v${helm3_version}-linux-amd64.tar.gz && \
    tar -zxvf helm3.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm3 && \
    rm -f helm3.tar.gz && \
    apt autoremove -y && \
    apt autoclean -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

