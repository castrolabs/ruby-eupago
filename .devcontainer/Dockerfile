FROM ruby:3.3.9

RUN apt-get update -qq && apt-get install -y build-essential

RUN gem install rails bundler

RUN useradd -ms /bin/bash vscode

WORKDIR /workspace
RUN chown -R vscode:vscode /workspace

USER vscode