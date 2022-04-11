FROM python:3.10-slim
RUN apt update && apt upgrade -y
# dependencies install
RUN apt install python3-dev python3-pip curl git -y
RUN pip install -U pip numpy wheel packaging
RUN pip install -U keras_preprocessing --no-deps
# bazelisk install
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-darwin-arm64 -o /bazel
RUN chmod +x /bazel
RUN export PATH=$PATH:/bazel
# tensorflow download and build
RUN git clone https://github.com/tensorflow/tensorflow.git
RUN /tensorflow/configure
RUN /bazel build --config=cuda /tensorflow/tools/pip_package:build_pip_package
RUN ls /tmp/tensorflow_pkg/