FROM ubuntu:14.04


RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl git

# Compiling Ruby

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxslt-dev libxml2 libxml2-dev libpq-dev libmysqlclient-dev libyaml-dev libsqlite3-dev

RUN curl -L -o ruby.tar.gz http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p547.tar.gz
RUN tar xzf ruby.tar.gz
RUN bash -lc "cd ruby* && ./configure"
RUN bash -lc "cd ruby* && make"
RUN bash -lc "cd ruby* && make install"

# Installing Ruby Gems

RUN curl -L -o rubygems.tar.gz http://production.cf.rubygems.org/rubygems/rubygems-2.4.1.tgz
RUN tar xzf rubygems.tar.gz
RUN bash -lc "cd rubygems* && ruby setup.rb"

# Installing Vagrant and AWS Provider

RUN curl -L -o vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
RUN dpkg -i vagrant.deb
RUN vagrant plugin install vagrant-aws
RUN vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

# Installing BOSH

RUN gem install bosh_cli bosh_cli_plugin_micro --no-ri --no-rdoc
RUN git clone https://github.com/MalteJ/bosh-lite.git
RUN gem install bundler --no-ri --no-rdoc
RUN bash -lc "cd /bosh-lite && bundle install"

ADD deploy.sh deploy.sh

CMD ["bash","-lc",". /bosh-environment/tests/aws/aws-env.sh && ./deploy.sh"]
