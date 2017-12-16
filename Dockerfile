FROM debian:stretch

MAINTAINER Lef Ioannidis <rausted@gmail.com>

# apt-get optimizations from:
# https://github.com/moby/moby/issues/1458#issuecomment-22343707
RUN echo "force-unsafe-io" > \
			/etc/dpkg/dpkg.cfg.d/02apt-speedup && \
		echo "Acquire::http {No-Cache=True;};" > \
			/etc/apt/apt.conf.d/no-cache && \
		apt-get -y update && \
		apt-get -y install --no-install-recommends \
			wget python gnupg2 ca-certificates \
			make cmake git bash sudo build-essential \
			libc-dev libc++-dev python-dev python3-dev \
			binutils gcc vim-nox qemu && \
		useradd -ms /bin/bash docker && \
		mkdir -p /home/docker/src && \
		echo "docker  ALL=NOPASSWD: ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker/src

# Copy defaults
RUN wget -O ~/.vimrc https://raw.githubusercontent.com/elefthei/Scripts-and-confs/master/vimrc && \
	wget -O ~/.profile https://github.com/elefthei/Scripts-and-confs/blob/master/bash_profile && \ 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
	git clone --recursive -j4 https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe && \
	cd ~/.vim/bundle/YouCompleteMe && \
	./install.py --clang-completer

CMD [ "/bin/bash" ]
