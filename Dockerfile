FROM ubuntu:22.04
RUN apt-get update && apt-get install -y sudo
RUN groupadd lab_user
RUN useradd -m -g lab_user lab_user
RUN usermod -aG sudo lab_user
RUN echo "lab_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER lab_user

RUN sudo apt-get install -y pip curl less git iputils-ping
    # pip install ansible-core==2.16 \
    # pip install jmespath \
    # ansible-galaxy collection install community.general ansible.posix \

# RUN sudo apt-get install -y pip curl less git iputils-ping
# RUN apt-get update && apt-get install -y sudo
# RUN pip install ansible-core==2.16
# RUN pip install jmespath
# RUN ansible-galaxy collection install community.general ansible.posix

RUN sudo mkdir -p /apps/dev
RUN sudo chown -R lab_user:lab_user /apps/dev
# WORKDIR /apps/dev
RUN echo 'set -o vi' >> /home/lab_user/.bashrc
RUN echo 'alias ll="ls -lrt"' >> /home/lab_user/.bashrc
ENV PATH="${PATH}:/home/lab_user/.local/bin"

# CMD ["/bin/echo", “hello”]
# ENTRYPOINT ["/bin/sh"]
# ENTRYPOINT ["/bin/sh"]



# RUN pip install -r /project/jtable/requirements.txt