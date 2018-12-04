FROM debian:stretch

LABEL maintainer="Morgan Seznec <contact@morganseznec.com>"
LABEL version="2.10.2"

ARG VERSION_ICINGAWEB2=2.6.2
ARG VERSION_DIRECTOR=1.5.2
ARG VERSION_GRAPHITE=1.1.0
ARG VERSION_AWS=0.6.0
ARG VERSION_AWS_SDK=3.80.1
ARG VERSION_GRAFANA=1.3.2
ARG VERSION_BUSINESSPROCESS=2.1.0
ARG VERSION_VSPHERE=1.1.0
ARG VERSION_TOPLEVELVIEW=0.2.1
ARG VERSION_CUBE=1.0.1
ARG VERSION_REACTBUNDLE=0.3.1

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
          icinga2-ido-pgsql \
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
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/grafana -f - icingaweb2-module-grafana-${VERSION_GRAFANA}/ \
    # Icingaweb2 Vsphere
    && mkdir -p /usr/share/icingaweb2/modules/vsphere \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-vsphere/archive/v${VERSION_VSPHERE}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/vsphere -f - icingaweb2-module-vsphere-${VERSION_VSPHERE}/ \
    # Icingaweb2 Top Level View
    && mkdir -p /usr/share/icingaweb2/modules/toplevelview \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-toplevelview/archive/v${VERSION_TOPLEVELVIEW}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/toplevelview -f - icingaweb2-module-toplevelview-${VERSION_TOPLEVELVIEW}/ \
    # Icingaweb2 Cube
    && mkdir -p /usr/share/icingaweb2/modules/cube \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-cube/archive/v${VERSION_CUBE}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/cube -f - icingaweb2-module-cube-${VERSION_CUBE}/ \
    # Icingaweb2 Business Process
    && mkdir -p /usr/share/icingaweb2/modules/businessprocess \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-businessprocess/archive/v${VERSION_BUSINESSPROCESS}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/businessprocess -f - icingaweb2-module-businessprocess-${VERSION_BUSINESSPROCESS}/ \
    # Icingaweb2 React Bundle
    && mkdir -p /usr/share/icingaweb2/modules/reactbundle \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-reactbundle/archive/v${VERSION_REACTBUNDLE}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/share/icingaweb2/modules/reactbundle -f - icingaweb2-module-reactbundle-${VERSION_REACTBUNDLE}/

EXPOSE 80 443 5665

ADD add/docker-entrypoint.sh /usr/local/bin/
ADD add/helpers /usr/local/bin/
ADD add/setup* /usr/local/bin/
ADD add/features/* /usr/local/bin/
ADD add/modules/* /usr/local/bin/

RUN    chmod +x /usr/local/bin/docker-entrypoint.sh             \
    && chmod +x /usr/local/bin/helpers                          \
    && chmod +x /usr/local/bin/setup_*

ENTRYPOINT ["docker-entrypoint.sh"]
