FROM base
MAINTAINER MASAYUKI KATOH kato@clwit.co.jp
RUN apt-get install ruby ruby-dev make libssl-dev wget -y
RUN cd /root/
RUN gem install --no-ri --no-rdoc puma grape faraday faraday_middleware
RUN ip a
ADD Gemfile /root/Gemfile
ADD proxy.rb /root/proxy.rb
ADD proxy.ru /root/proxy.ru
CMD /usr/local/bin/puma /root/proxy.ru
EXPOSE 80 9292
