FROM node:7.9.0

MAINTAINER Paul Allen <paul@edufocal.com>

RUN echo "export PATH=${PATH}:/var/www/messages/node_modules/bin" >> ~/.bashrc

EXPOSE 3000

WORKDIR /var/www/messages

ADD start.sh /root/

CMD /root/start.sh
