FROM base
MAINTAINER MASAYUKI KATOH kato@clwit.co.jp
RUN apt-get install ruby ruby-dev make libssl-dev -y
RUN cd /root/
RUN gem install --no-ri --no-rdoc puma grape
RUN ip a
ADD Gemfile /root/Gemfile
ADD hello.rb /root/proxy.rb
ADD hello.ru /root/proxy.ru
CMD /usr/local/bin/puma /root/proxy.ru
EXPOSE 80 9292
