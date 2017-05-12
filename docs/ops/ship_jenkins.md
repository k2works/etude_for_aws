Jenkins配置
---

## 例
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
`http://0.0.0.0:9000`に接続してJenkinsをセットアップする

Crumb Dataが必要な場合は`http://0.0.0.0:9000/crumbIssuer/api/json`からcrumbを取得する

.envファイルをコピーしてテストを動かせるようにする
```bash
sudo cp /vagrant/.env /var/lib/jenkins/workspace/Develop/
```

## 注意
+ 仮想マシン環境でセットアップする。

## 参照
