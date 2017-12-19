FROM debian:stretch

MAINTAINER Lef Ioannidis <rausted@gmail.com>

# apt-get optimizations from:
# https://github.com/moby/moby/issues/1458#issuecomment-22343707
RUN echo "force-unsafe-io" > \
		/etc/dpkg/dpkg.cfg.d/02apt-speedup && \
	echo "Acquire::http {No-Cache=True;};" > \
		/etc/apt/apt.conf.d/no-cache && \
	apt-get -y update && \
	echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main" >> /etc/apt/sources.list.d/llvm.list && \
	echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main" >> /etc/apt/sources.list.d/llvm.list && \
	apt-get install -y --no-install-recommends \
		debian-keyring dirmngr gpg && \
	gpg --keyserver pgp.mit.edu --recv-keys 15CF4D18AF4F7421 && \
	gpg --armor --export 15CF4D18AF4F7421 | apt-key add - && \
	apt-get -y update && \
	apt-get -y install --no-install-recommends \
		wget python gnupg2 ca-certificates \
		make cmake git bash sudo make \
		libc-dev libc++-dev python-dev python3-dev \
		binutils vim-nox clang-5.0 libclang-dev llvm-5.0 && \
	useradd -ms /bin/bash docker && \
	mkdir -p /home/docker/src && \
	echo "docker  ALL=NOPASSWD: ALL" >> /etc/sudoers && \
	ln -s /usr/bin/llvm-PerfectShuffle-5.0 /usr/bin/llvm-PerfectShuffle && \
	ln -s /usr/bin/llvm-ar-5.0 /usr/bin/llvm-ar && \
	ln -s /usr/bin/llvm-as-5.0 /usr/bin/llvm-as && \
	ln -s /usr/bin/llvm-bcanalyzer-5.0 /usr/bin/llvm-bcanalyzer && \
	ln -s /usr/bin/llvm-c-test-5.0 /usr/bin/llvm-c-test && \
	ln -s /usr/bin/llvm-cat-5.0 /usr/bin/llvm-cat && \
	ln -s /usr/bin/llvm-config-5.0 /usr/bin/llvm-config && \
	ln -s /usr/bin/llvm-cov-5.0 /usr/bin/llvm-cov && \
	ln -s /usr/bin/llvm-cvtres-5.0 /usr/bin/llvm-cvtres && \
	ln -s /usr/bin/llvm-cxxdump-5.0 /usr/bin/llvm-cxxdump && \
	ln -s /usr/bin/llvm-cxxfilt-5.0 /usr/bin/llvm-cxxfilt && \
	ln -s /usr/bin/llvm-diff-5.0 /usr/bin/llvm-diff && \
	ln -s /usr/bin/llvm-dis-5.0 /usr/bin/llvm-dis && \
	ln -s /usr/bin/llvm-dlltool-5.0 /usr/bin/llvm-dlltool && \
	ln -s /usr/bin/llvm-dsymutil-5.0 /usr/bin/llvm-dsymutil && \
	ln -s /usr/bin/llvm-dwarfdump-5.0 /usr/bin/llvm-dwarfdump && \
	ln -s /usr/bin/llvm-dwp-5.0 /usr/bin/llvm-dwp && \
	ln -s /usr/bin/llvm-extract-5.0 /usr/bin/llvm-extract && \
	ln -s /usr/bin/llvm-lib-5.0 /usr/bin/llvm-lib && \
	ln -s /usr/bin/llvm-link-5.0 /usr/bin/llvm-link && \
	ln -s /usr/bin/llvm-lto-5.0 /usr/bin/llvm-lto && \
	ln -s /usr/bin/llvm-lto2-5.0 /usr/bin/llvm-lto2 && \
	ln -s /usr/bin/llvm-mc-5.0 /usr/bin/llvm-mc && \
	ln -s /usr/bin/llvm-mcmarkup-5.0 /usr/bin/llvm-mcmarkup && \
	ln -s /usr/bin/llvm-modextract-5.0 /usr/bin/llvm-modextract && \
	ln -s /usr/bin/llvm-mt-5.0 /usr/bin/llvm-mt && \
	ln -s /usr/bin/llvm-nm-5.0 /usr/bin/llvm-nm && \
	ln -s /usr/bin/llvm-objdump-5.0 /usr/bin/llvm-objdump && \
	ln -s /usr/bin/llvm-opt-report-5.0 /usr/bin/llvm-opt-report && \
	ln -s /usr/bin/llvm-pdbutil-5.0 /usr/bin/llvm-pdbutil && \
	ln -s /usr/bin/llvm-profdata-5.0 /usr/bin/llvm-profdata && \
	ln -s /usr/bin/llvm-ranlib-5.0 /usr/bin/llvm-ranlib && \
	ln -s /usr/bin/llvm-readelf-5.0 /usr/bin/llvm-readelf && \
	ln -s /usr/bin/llvm-readobj-5.0 /usr/bin/llvm-readobj && \
	ln -s /usr/bin/llvm-rtdyld-5.0 /usr/bin/llvm-rtdyld && \
	ln -s /usr/bin/llvm-size-5.0 /usr/bin/llvm-size && \
	ln -s /usr/bin/llvm-split-5.0 /usr/bin/llvm-split && \
	ln -s /usr/bin/llvm-stress-5.0 /usr/bin/llvm-stress && \
	ln -s /usr/bin/llvm-strings-5.0 /usr/bin/llvm-strings && \
	ln -s /usr/bin/llvm-symbolizer-5.0 /usr/bin/llvm-symbolizer && \
	ln -s /usr/bin/llvm-tblgen-5.0 /usr/bin/llvm-tblgen && \
	ln -s /usr/bin/llvm-xray-5.0 /usr/bin/llvm-xray && \
	ln -s /usr/bin/clang++-5.0 /usr/bin/clang++ && \
	ln -s /usr/bin/clang++-5.0 /usr/bin/g++ && \
	ln -s /usr/bin/clang-5.0 /usr/bin/clang && \
	ln -s /usr/bin/clang-5.0 /usr/bin/gcc && \
	ln -s /usr/bin/clang-cpp-5.0 /usr/bin/clang-cpp

USER docker
WORKDIR /home/docker/src

# Copy defaults
RUN wget -O ~/.vimrc https://raw.githubusercontent.com/elefthei/Scripts-and-confs/master/vimrc && \
	wget -O ~/.profile https://github.com/elefthei/Scripts-and-confs/blob/master/bash_profile && \ 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
	git clone --recursive -j4 https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe && \
	cd ~/.vim/bundle/YouCompleteMe && \
	./install.py --clang-completer --system-libclang

CMD [ "/bin/bash" ]
