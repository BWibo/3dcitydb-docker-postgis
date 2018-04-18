# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
ARG baseimage_tag='10'
FROM postgres:${baseimage_tag}
# Maintainer ##################################################################
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup 3DCityDB ##############################################################
ENV POSTGIS_MAJOR='2.4'
ENV POSTGIS_VERSION='2.4.4+dfsg-1.pgdg90+1'
ARG citydb_version='v3.3.1'
ENV CITYDBVERSION=${citydb_version}

RUN set -x \
  && RUNTIME_PACKAGES="postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
    postgis=$POSTGIS_VERSION" \
  && BUILD_PACKAGES="ca-certificates git" \   
  && apt-get update \
  && apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES \
  && git clone -b "${CITYDBVERSION}" --depth 1 https://github.com/3dcitydb/3dcitydb.git 3dcitydb_temp \
  && mkdir -p 3dcitydb \
  && cp -r 3dcitydb_temp/PostgreSQL/SQLScripts/* 3dcitydb \
  && rm -rf 3dcitydb_temp \
  && apt-get purge -y --auto-remove $BUILD_PACKAGES \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /docker-entrypoint-initdb.d

COPY 3dcitydb.sh /docker-entrypoint-initdb.d/
COPY CREATE_DB.sql /3dcitydb/
COPY addcitydb /usr/local/bin/
COPY dropcitydb /usr/local/bin/
COPY purgedb /usr/local/bin/

RUN set -x \ 
  && ln -s usr/local/bin/addcitydb / \
  && chmod u+x /usr/local/bin/addcitydb \
  && ln -s usr/local/bin/dropcitydb / \
  && chmod u+x /usr/local/bin/dropcitydb \
  && ln -s usr/local/bin/purgedb / \
  && chmod u+x /usr/local/bin/purgedb  
