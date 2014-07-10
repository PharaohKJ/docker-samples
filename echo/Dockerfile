FROM base
MAINTAINER MASAYUKI KATOH kato@clwit.co.jp
RUN apt-get install ruby ruby-dev make libssl-dev wget -y
RUN cd /root/
RUN gem install --no-ri --no-rdoc puma grape
RUN ip a
ADD Gemfile /root/Gemfile
ADD hello.rb /root/hello.rb
ADD hello.ru /root/hello.ru
CMD /usr/local/bin/puma /root/hello.ru
EXPOSE 80 9292
