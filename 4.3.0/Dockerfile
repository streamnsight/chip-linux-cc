FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y git \
	build-essential \
	fakeroot \
	kernel-package \
	zlib1g-dev \
	libncurses5-dev \
	lzop

RUN apt-get install -y gcc-arm-linux-gnueabihf \
	binutils-arm-linux-gnueabihf

RUN mkdir -p /home/workspace && cd /home/workspace
ENV WORKSPACE /home/workspace

ENV KERNEL_BRANCH=4.3.0-ntc-4
# kernel repo
RUN cd /home/workspace && git clone --single-branch --branch debian/${KERNEL_BRANCH} https://github.com/NextThingCo/CHIP-linux.git

# WiFi kernel module repo
RUN cd /home/workspace && git clone --single-branch --branch debian https://github.com/NextThingCo/RTL8723BS.git

ADD run.sh /home/workspace/

WORKDIR /home/workspace

CMD /home/workspace/run.sh