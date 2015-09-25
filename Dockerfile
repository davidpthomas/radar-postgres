FROM ubuntu:14.04
MAINTAINER David P Thomas <dthomas@rallydev.com>

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.4``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Update the Ubuntu and PostgreSQL repository indexes and install ``python-software-properties``,
# ``software-properties-common`` and PostgreSQL 9.4
# There are some warnings (in red) that show up during the build. You can hide
# them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y -q install python-software-properties software-properties-common \
    && apt-get -y -q install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4

RUN apt-get install -y vim

USER postgres

RUN /etc/init.d/postgresql start \
 # create Roles for dev & prod
 && psql --command "CREATE USER \"radar_webapp-dev\" WITH CREATEDB PASSWORD 'radar_webapp-dev';" \
 && psql --command "CREATE USER \"radar_webapp-prod\"" \
 # create databases (dev/test/staging/prod)
 && psql --command "CREATE DATABASE \"radar-webapp_development\" OWNER \"radar_webapp-dev\";" \
 && psql --command "CREATE DATABASE \"radar-webapp_test\" OWNER \"radar_webapp-dev\";" \
 && psql --command "CREATE DATABASE \"radar-webapp_staging\" OWNER \"radar_webapp-dev\";" \
 && psql --command "CREATE DATABASE \"radar-webapp_production\" OWNER \"radar_webapp-prod\";" \
 # setup permissions; revoke all then enable individual role <-> database access
 && psql --command "REVOKE CONNECT ON DATABASE \"radar-webapp_development\" FROM PUBLIC;" \
 && psql --command "REVOKE CONNECT ON DATABASE \"radar-webapp_test\" FROM PUBLIC;" \
 && psql --command "REVOKE CONNECT ON DATABASE \"radar-webapp_staging\" FROM PUBLIC;" \
 && psql --command "REVOKE CONNECT ON DATABASE \"radar-webapp_production\" FROM PUBLIC;" \
 && psql --command "GRANT CONNECT ON DATABASE \"radar-webapp_development\" TO \"radar_webapp-dev\";" \
 && psql --command "GRANT CONNECT ON DATABASE \"radar-webapp_test\" TO \"radar_webapp-dev\";" \
 && psql --command "GRANT CONNECT ON DATABASE \"radar-webapp_staging\" TO \"radar_webapp-dev\";" \
 && psql --command "GRANT CONNECT ON DATABASE \"radar-webapp_production\" TO \"radar_webapp-prod\";" \
 # enable dev user to create/destroy db's as part of rails' db lifecycle (e.g. testing)
 && psql --command "ALTER ROLE \"radar_webapp-dev\" SUPERUSER;"

USER root

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.4/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

USER postgres

ENV PG_HOME /var/lib/postgresql

ADD vimrc $PG_HOME/.vimrc
ADD inputrc $PG_HOME/.inputrc
ADD bashrc $PG_HOME/.bashrc

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
