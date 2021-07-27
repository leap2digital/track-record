FROM ruby:2.7

RUN mkdir track-record/
WORKDIR /track-record
COPY . /track-record

RUN apt-get update && apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates sqlite3 libsqlite3-dev
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN bundle install -j4 --retry 3

CMD bash -c "while [ true ]; do sleep 10; done"
