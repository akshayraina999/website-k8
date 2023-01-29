FROM centos:centos7
MAINTAINER akshayraina999@gmail.com
RUN yum update -y && \
  yum upgrade
RUN yum install zip -y \
  unzip
RUN yum install httpd -y 
ADD https://www.free-css.com/assets/files/free-css-templates/download/page258/loxury.zip /var/www/html/
WORKDIR /var/www/html
RUN unzip loxury.zip
RUN cp -rvf loxury/* .
RUN rm -rf loxury loxury.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80