EC2
---

## 基本仕様
+ VPCで作成されたネットワークにインスタンスを作成する。
+ 対応するパターンは[７パターン](../vpc/vpc.md)
+ すべてのインスタンスに共通のセキュリティグループが適用される。
+ すべてのインスタンスに共通のキーペアが適用される。
+ シンプルなVPC環境はパターン１に対応する。
+ 標準的なVPC環境はパターン３に対応する。

## ユースケース
### パターン1
![](images/ec2_type1.png)

### パターン2
![](images/ec2_type2.png)

### パターン3
![](images/ec2_type3.png)

### パターン4
![](images/ec2_type4.png)

### パターン5
![](images/ec2_type5.png)

### パターン6
![](images/ec2_type6.png)

### パターン7
![](images/ec2_type7.png)


## コアモデル
![](images/ec2_core_model.png)