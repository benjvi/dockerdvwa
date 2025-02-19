FROM benjvi/tutum-lamp-arm:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN \
  rm -fr /app/* && \
  apt-get update && apt-get install -yqq wget unzip php5-gd && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/ethicalhack3r/DVWA/archive/v1.9.zip && \
  unzip /v1.9.zip && \
  rm -rf app/* && \
  cp -r /DVWA-1.9/* /app && \
  rm -rf /DVWA-1.9 && \
  sed -i "s/^\$_DVWA\[ 'db_user' \]     = 'root'/\$_DVWA[ 'db_user' ] = 'admin'/g" /app/config/config.inc.php && \
  echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini && \
  sed -ri -e "s/^allow_url_include.*/allow_url_include = On/" /etc/php5/apache2/php.ini && \
  chmod a+w /app/hackable/uploads && \
  chmod a+w /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

EXPOSE 80 3306
CMD ["/run.sh"]
