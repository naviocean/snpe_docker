FROM ubuntu:18.04

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND="noninteractive"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update && apt-get install -y \
    python \
    python3 \
    python3-pip \
    unzip \
    sudo \
    wget \
    apt-utils \
    zip \
    libc++-9-dev \
    python-sphinx \
    python3-scipy \
    python3-matplotlib \
    python3-skimage \
    python-protobuf \
    python3-mako \
    python3-dev \
    python-dev \
    adb \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2 && \
    update-alternatives --config python

RUN pip3 install \
    numpy==1.16.5 \
    sphinx==2.2.1 \
    scipy==1.3.1 \
    matplotlib==3.0.3 \
    protobuf==3.8.0 \
    pillow==7.2.0 \
    scikit-image==0.15.0 \
    pyyaml==5.1 \
    mako==1.1.4 \
    onnx==1.6.0

COPY snpe-1.51.0.zip /

WORKDIR /

RUN unzip snpe-1.51.0.zip



RUN /bin/bash -c "source snpe-1.51.0.2663/bin/dependencies.sh" && \
    /bin/bash -c "source snpe-1.51.0.2663/bin/check_python_depends.sh"

ENV SNPE_ROOT=/snpe-1.51.0.2663
ENV ONNX_HOME=/usr/local/lib/python3.6/dist-packages/onnx
ENV NDK_URL="https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip"
ENV ANDROID_NDK=/opt/android-ndk-linux
ENV ANDROID_NDK_HOME=/opt/android-ndk-linux
RUN wget -q --output-document=android-ndk.zip $NDK_URL && \
    unzip android-ndk.zip && \
    rm -f android-ndk.zip && \
    mv android-ndk-r17c $ANDROID_NDK_HOME


RUN cd $SNPE_ROOT && \
    /bin/bash -c "source bin/envsetup.sh -o $ONNX_HOME"

# get directory of the bash script
ENV SOURCEDIR=/snpe-1.51.0.2663/bin
ENV SNPE_ROOT=/snpe-1.51.0.2663
ENV PATH=$SNPE_ROOT/bin/x86_64-linux-clang:$PATH

# setup LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$SNPE_ROOT/lib/x86_64-linux-clang:$LD_LIBRARY_PATH
# setup PYTHONPATH
ENV PYTHONPATH=$SNPE_ROOT/lib/python:$PYTHONPATH
ENV PYTHONPATH=$SNPE_ROOT/models/lenet/scripts:$PYTHONPATH
ENV PYTHONPATH=$SNPE_ROOT/models/alexnet/scripts:$PYTHONPATH

#setup SNPE_UDO_ROOT
ENV SNPE_UDO_ROOT=$SNPE_ROOT/share/SnpeUdo/

CMD ["/bin/bash"]
