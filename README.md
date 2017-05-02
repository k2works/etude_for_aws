# Etude for AWS

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
