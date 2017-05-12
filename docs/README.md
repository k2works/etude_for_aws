Etude for AWS
===================

# 目的 #
AWS構築のための練習プログラム集

# 前提 #
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:----------|:------------|
| aws-cli        | 1.11.81   |             |
| eb             | 3.10.1    |             |
| terraform      | 0.6.16    |             |
| vagrant        |1.8.7      |             |
| packer         |0.10.1     |             |
| chef-dk        |1.3.43     |             |
| docker         |17.04.0    |             |
| docker-compose |1.8.0      |             |

# 構成 #
1. [構築](#構築)
1. [配置](#配置)
1. [開発](#開発)
1. [運用](#運用)

## 構築
[Using the AWS SDK for Ruby REPL](./ops/build_aws_sdk_repl.md)

**[⬆ back to top](#構成)**

## 配置
### [CircleCI配置](./ops/ship_circleci.md)
### [Jenkins配置](./ops/ship_jenkins.md)
### [RubyGemパッケージの配置](./ops/ship_ruby_gem.md)

**[⬆ back to top](#構成)**

## 開発
### [CFM](./dev/cfm/cfm.md)
### [VPC](./dev/vpc/vpc.md)
### [EC2](./dev/ec2/ec2.md)

**[⬆ back to top](#構成)**

## 運用
[Rake Task](./ops/run_rake_task.md)

**[⬆ back to top](#運用)**

# 参照 #
+ [AWS SDK for Ruby - Version 2](https://github.com/aws/aws-sdk-ruby)
+ [AWS SDK for Ruby - Version 2 API Docs](http://docs.aws.amazon.com/sdkforruby/api/index.html)
+ [AWS SDK for Ruby Code Examples](http://docs.aws.amazon.com/ja_jp/sdk-for-ruby/v2/developer-guide/examples.html)
+ [RSpec Expectations 3.5](http://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs)
+ [PlantUML](http://plantuml.com/)
