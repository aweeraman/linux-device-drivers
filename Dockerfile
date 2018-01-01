FROM debian

RUN     apt-get update && \
        apt-get install -y build-essential libncurses5-dev libelf-dev bc linux-headers-amd64 && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
