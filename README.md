# Etude for AWS
[![CircleCI](https://circleci.com/gh/k2works/etude_for_aws.svg?style=svg)](https://circleci.com/gh/k2works/etude_for_aws)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/k2works/etude_for_aws/LICENSE.txt)
[![Gem Version](https://badge.fury.io/rb/etude_for_aws.svg)](https://badge.fury.io/rb/etude_for_aws)

## Quick Start
Create`.env`
```text
AWS_ACCESS_KEY_ID="<id>"
AWS_SECRET_ACCESS_KEY="<key>"
AWS_REGION="<region>"
```

### Using Vagrant
```bash
vagrant up
vagrant ssh
cd /vagrant
aws configure
```

### Using Docker
```bash
docker-compose build
docker-compose run app bash
complete -C '/usr/bin/aws_completer' aws
```

### [Documents](./docs/README.md)
