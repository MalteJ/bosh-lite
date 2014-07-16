FROM ubuntu:14.04


RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install curl git -y

RUN curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN curl -L -o vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
RUN dpkg -i vagrant.deb
RUN vagrant plugin install vagrant-aws

#RUN git clone https://github.com/rubygems/rubygems.git
#RUN find / -name ruby
#RUN bash --login -c "cd rubygems && ruby setup.rb"

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxslt-dev libxml2-dev libpq-dev libmysqlclient-dev
RUN bash --login -c "gem install semi_semantic --no-ri --no-rdoc"
RUN bash --login -c "gem install bosh_cli bosh_cli_plugin_micro --no-ri --no-rdoc"

RUN bash --login -c "rm -rf ~/.vagrant.d/plugins.json ~/vagrant.d/gems"
RUN bash --login -c "vagrant plugin install vagrant-aws"
RUN bash --login -c "vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

RUN git clone https://github.com/MalteJ/bosh-lite.git

ADD deploy.sh deploy.sh

CMD ["./deploy.sh"]
