RubyGemパッケージの配置
---

## 例
### Gemのビルド
```bash
gem install bundler
bundle install
bundle exec rake build
```

### .gemファイルを作る
```bash
gem build etude_for_aws.gemspec 
```
### Gemの公開
```bash
gem push etude_for_aws-0.0.0.gem 
```

## 注意
+ 公開するバージョンは都度更新する

## 参照
+ [Version Badge](https://badge.fury.io/)
+ [RubygemsへのデプロイをCircleCIで自動化してみた](http://leko.jp/archives/871)