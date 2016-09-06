FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV STACKSMITH_STACK_ID="u9fs9c0" \
    STACKSMITH_STACK_NAME="Ruby for bitnami/bitnami-docker-laravel" \
    STACKSMITH_STACK_PRIVATE="1" \
    BITNAMI_APP_NAME=laravel \
    BITNAMI_APP_VERSION=5.2.31 \
    LARAVEL_ENV=development \
    BITNAMI_IMAGE_VERSION=5.2.31-r5 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/node/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH \
    NODE_PATH=NODE_PATH=/opt/bitnami/node/lib/node_modules    

# Install java dependency
RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773

# Install Laravel related dependencies
RUN bitnami-pkg install node-6.3.0-0 --checksum f2997c421e45beb752673a531bf475231d183c30f7f8d5ec1a5fb68d39744d5f
RUN bitnami-pkg install php-7.0.10-0 --checksum 5f2ec47fcfb2fec5197af6760c5053dd5dee8084d70a488fd5ea77bd4245c6b9
RUN bitnami-pkg install mariadb-10.1.14-4 --checksum 4a75f4f52587853d69860662626c64a4540126962cd9ee9722af58a3e7cfa01b -- --password=laravelSample --username=laravelSample --database=laravelSample 

RUN npm install -g gulp

RUN mkdir /tmp/laravel-sample && cd /tmp/laravel-sample && composer create-project "laravel/laravel=5.2.31" /tmp/laravel-sample --prefer-dist

#Adding useful environment variables for enabling functionality
ENV TERM=xterm \
    DB_HOST=127.0.0.1 \
    DB_USERNAME=laravelSample \
    DB_DATABASE=laravelSample \
    DB_PASSWORD=laravelSample


WORKDIR /projects

EXPOSE 3000

LABEL che:server:3000:ref=laravel che:server:3000:protocol=http

USER bitnami

CMD ["tail", "-f", "/dev/null"]