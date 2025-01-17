FROM python:2.7

# Install Ansible from source (master)
RUN apt-get -y update && \
    apt-get install -y python-httplib2 python-keyczar python-setuptools python-pkg-resources git python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install paramiko jinja2 PyYAML setuptools pycrypto>=2.6 six \
    requests docker-py  # docker inventory plugin
RUN git clone https://github.com/ansible/ansible.git /opt/ansible && \
    cd /opt/ansible && \
    git reset --hard fbec8bfb90df1d2e8a0a4df7ac1d9879ca8f4dde && \
    git submodule update --init

ENV PATH /opt/ansible/bin:$PATH
ENV PYTHONPATH $PYTHONPATH:/opt/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/library

# setup ssh
RUN mkdir /root/.ssh
ADD ansible_id_rsa /root/.ssh/id_rsa
ADD ansible_id_rsa.pub /root/.ssh/id_rsa.pub

# extend Ansible
# use an inventory directory for multiple inventories support
RUN mkdir -p /etc/ansible/inventory && \
    cp /opt/ansible/contrib/inventory/docker.py /etc/ansible/inventory/
ADD ansible.cfg /etc/ansible/ansible.cfg
ADD hosts /etc/ansible/inventory/hosts
