FROM ubuntu:18.04

RUN apt-get --quiet update

# Install swift run-time dependencies
# Useful info: https://forums.swift.org/t/which-clang-package-should-we-install/20542/14
RUN apt-get install --quiet --yes lsb-release libatomic1 libpython2.7 libxml2 libc6-dev binutils libgcc-7-dev libstdc++-7-dev

# Install swiftenv plus dependencies
RUN apt-get install --quiet --yes curl git
ENV SWIFTENV_ROOT /usr/local/swiftenv
RUN git clone https://github.com/kylef/swiftenv.git "$SWIFTENV_ROOT"
ENV PATH "$SWIFTENV_ROOT/bin:$PATH"
RUN swiftenv install 5.1-DEVELOPMENT-SNAPSHOT-2019-07-25-a
ENV PATH "$SWIFTENV_ROOT/shims:$PATH"
RUN swiftenv rehash

WORKDIR /package
COPY . /package

CMD swift test --enable-test-discovery
