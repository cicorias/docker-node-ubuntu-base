FROM ubuntu:bionic-20180821

# install our dependencies and nodejs
RUN apt-get update
RUN apt-get install curl -y
RUN apt-get -y install software-properties-common git build-essential
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs
# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
COPY package*.json /tmp/
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible
WORKDIR /opt/app
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
