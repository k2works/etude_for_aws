Using the AWS SDK for Ruby REPL
---

## 例
```bash
bin/console
Aws>s3 = Aws::S3::Client.new(region: 'ap-northeast-1a')
Aws>s3.list_buckets
```

## 注意
事前に`.env`にAWSクレデンシャルを設定しておく。

## 参照
+ [dotenv](https://github.com/bkeepers/dotenv)
+ [Rubyでシェルコマンドを実行する方法](https://www.xmisao.com/2014/03/01/how-to-execute-a-shell-script-in-ruby.html)
+ [AWS SDK for RubyでのAPI操作をインタラクティブに実行する](http://dev.classmethod.jp/cloud/aws/using-the-aws-sdk-for-ruby-from-repl/)
+ [Getting Started with the AWS SDK for Ruby](http://docs.aws.amazon.com/ja_jp/sdk-for-ruby/v2/developer-guide/getting-started.html)

