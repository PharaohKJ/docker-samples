FROM base
MAINTAINER MASAYUKI KATOH kato@clwit.co.jp
RUN apt-get install ruby ruby-dev make libssl-dev wget -y
RUN cd /root/
RUN gem install --no-ri --no-rdoc puma grape faraday faraday_middleware docker-api
RUN ip a
ADD Gemfile /root/Gemfile
ADD manage.rb /root/manage.rb
ADD manage.ru /root/manage.ru
CMD /usr/local/bin/puma /root/manage.ru
EXPOSE 80 9292
