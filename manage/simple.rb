require 'docker'
m = ENV['DOCKER_HOST'].match(%r{tcp://(.+?):})

p m[1]

DOCKER_HOST = ENV['DOCKER_HOST']
p DOCKER_HOST
Docker.url="http://#{DOCKER_HOST}:4243/"
cons = Docker::Container.all(:running => true)
cons.each do |con|
  puts con.id
end
