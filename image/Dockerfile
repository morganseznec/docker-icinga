FROM debian:stretch

LABEL maintainer="Morgan Seznec <contact@morganseznec.com>"
LABEL version="2.8.2"

ARG VERSION_ICINGAWEB2=2.5.1
ARG VERSION_DIRECTOR=1.4.3
ARG VERSION_GRAPHITE=1.0.1
ARG VERSION_AWS=0.6.0
ARG VERSION_AWS_SDK=3.52.17
ARG VERSION_GRAFANA=1.2.1
ARG http_proxy=

ENV http_proxy=${http_proxy}
ENV https_proxy=${http_proxy}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dnsutils \
    gnupg \
    lsb-release

RUN  curl -s https://packages.icinga.com/icinga.key \
     | apt-key add - \
     && echo "deb http://packages.icinga.org/debian icinga-$(lsb_release -cs) main" > /etc/apt/sources.list.d/icinga2.list \
     && export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          apache2 \
          coreutils \
          mailutils \
          mariadb-client \
          postgresql-client \
          php-curl \
          php-ldap \
          php-mysql \
          php-pgsql \
          php-intl \
          php-gd \
          php-imagick \
          procps \
          pwgen \
          snmp \
          snmpd \
          libsnmp-dev \
          ssmtp \
          sudo \
          unzip \
          wget \
          icinga2 \
          icinga2-ido-mysql \
          icingacli \
          icingaweb2 \
          monitoring-plugins \
          nagios-nrpe-plugin \
          nagios-snmp-plugins \
          nagios-plugins-contrib \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* \
     && usermod -a -G icingaweb2 www-data \
     && icingacli setup config directory --group icingaweb2 \
     && head -c 12 /dev/urandom | base64 | tee /etc/icingaweb2/setup.token \
     && chmod 0660 /etc/icingaweb2/setup.token \
     && cp -r /etc/icingaweb2 /etc/icingaweb2.orig \
     && cp -r /etc/icinga2 /etc/icinga2.orig \
     && cp -r /etc/php/7.0/apache2 /etc/php/7.0/apache2.orig

# Temporary hack to get icingaweb2 modules via git
RUN mkdir -p /usr/share/icingaweb2/modules/ \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2/archive/v${VERSION_ICINGAWEB2}.tar.gz" \
    | tar xz --strip-components=2 --directory=/usr/share/icingaweb2/modules -f - icingaweb2-${VERSION_ICINGAWEB2}/modules/monitoring icingaweb2-${VERSION_ICINGAWEB2}/modules/doc \
    # Icinga Director
    && mkdir -p /usr/share/icingaweb2/modules/director/ \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-director/archive/v${VERSION_DIRECTOR}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/director --exclude=.gitignore -f - \
    # Icingaweb2 Graphite
    && mkdir -p /usr/share/icingaweb2/modules/graphite \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-graphite/archive/v${VERSION_GRAPHITE}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/graphite -f - icingaweb2-module-graphite-${VERSION_GRAPHITE}/ \
    # Icingaweb2 AWS
    && mkdir -p /usr/share/icingaweb2/modules/aws \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-aws/archive/v${VERSION_AWS}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/aws -f - icingaweb2-module-aws-${VERSION_AWS}/ \
    && wget -q --no-cookies "https://github.com/aws/aws-sdk-php/releases/download/${VERSION_AWS_SDK}/aws.zip" \
    && unzip -d /usr/share/icingaweb2/modules/aws/library/vendor/aws aws.zip \
    && rm aws.zip \
    && true \
    # Icingaweb2 Grafana
    && mkdir -p /usr/share/icingaweb2/modules/grafana \
    && wget -q --no-cookies -O - "https://github.com/Mikesch-mp/icingaweb2-module-grafana/archive/v${VERSION_GRAFANA}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/grafana -f - icingaweb2-module-grafana-${VERSION_GRAFANA}/

EXPOSE 80 443 5665

ADD add/docker-entrypoint.sh /usr/local/bin/
ADD add/helpers /usr/local/bin/
ADD add/setup* /usr/local/bin/
ADD add/features/* /usr/local/bin/
ADD add/modules/* /usr/local/bin/

RUN    chmod +x /usr/local/bin/docker-entrypoint.sh             \
    && chmod +x /usr/local/bin/helpers                          \
    && chmod +x /usr/local/bin/setup_*

# Initialize and run Supervisor
ENTRYPOINT ["docker-entrypoint.sh"]
