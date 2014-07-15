require 'docker'
m = ENV['DOCKER_HOST'].match(%r{tcp://(.+?):})

# p m[1]

DOCKER_HOST = ENV['DOCKER_HOST']
# p DOCKER_HOST
Docker.url="http://#{m[1]}:2375/"
cons = Docker::Container.all(:running => true)
cons.each do |con|
  p con
end

p Docker.version
