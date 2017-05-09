Rake Task
---

## 例
EC2インスタンスの生成と操作
```bash
rake EC2:copy_key_pair             # 作成したキーペアをコピーする
rake EC2:create_simple_vpc_env     # シンプルなVPC環境にEC2インスタンスを作成する
rake EC2:create_standard_vpc_env   # 標準的なVPC環境にEC2インスタンスを作成する
rake EC2:create_type01             # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type02             # １つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type03             # １つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type04             # ２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type05             # ２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type06             # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type07             # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:destroy_simple_vpc_env    # シンプルなVPC環境のEC2インスタンスを削除する
rake EC2:destroy_standard_vpc_env  # 標準的なVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type01_env        # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type02_env        # １つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type03_env        # １つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type04_env        # ２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type05_env        # ２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type06_env        # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type07_env        # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCのVPC環境のEC2インスタンスを削除する
rake EC2:reboot_simple_vpc_env     # シンプルなVPC環境にEC2インスタンス再起動する
rake EC2:reboot_standard_vpc_env   # 標準的なVPC環境にEC2インスタンスを再起動する
rake EC2:reboot_type01             # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを再起動する
rake EC2:setup_type01_env          # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成する
rake EC2:start_simple_vpc_env      # シンプルなVPC環境にEC2インスタンス起動する
rake EC2:start_standard_vpc_env    # 標準的なVPC環境にEC2インスタンスを起動する
rake EC2:start_type01              # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを起動する
rake EC2:stop_simple_vpc_env       # シンプルなVPC環境にEC2インスタンス停止する
rake EC2:stop_standard_vpc_env     # 標準的なVPC環境にEC2インスタンスを停止する
rake EC2:stop_type01               # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを停止する
```

VPCの作成
```bash
rake CFM:create_type01_vpc         # １つのアベイラビリティゾーンに１つのパブリックサブネットVPCを作成する
rake CFM:create_type02_vpc         # １つのアベイラビリティゾーンに２つのパブリックサブネットVPCを作成する
rake CFM:create_type03_vpc         # １つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを作成する
rake CFM:create_type04_vpc         # ２つのアベイラビリティゾーンに２つのプライベートサブネットVPCを作成する
rake CFM:create_type05_vpc         # ２つのアベイラビリティゾーンに２つのパブリックサブネットVPCを作成する
rake CFM:create_type06_vpc         # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを作成する
rake CFM:create_type07_vpc         # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCを作成する
rake CFM:destroy_type01_vpc        # １つのアベイラビリティゾーンに１つのパブリックサブネットVPCを削除する
rake CFM:destroy_type02_vpc        # １つのアベイラビリティゾーンに２つのパブリックサブネットVPCを削除する
rake CFM:destroy_type05_vpc        # ２つのアベイラビリティゾーンに２つのパブリックサブネットVPCを削除する
rake CFM:destroy_type06_vpc        # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを削除する
rake CFM:destroy_type07_vpc        # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCを削除する
rake EC2:create_simple_vpc_env     # シンプルなVPC環境にEC2インスタンスを作成する
rake EC2:create_standard_vpc_env   # 標準的なVPC環境にEC2インスタンスを作成する
rake EC2:create_type01             # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type02             # １つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type03             # １つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type04             # ２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type05             # ２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type06             # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:create_type07             # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する
rake EC2:destroy_simple_vpc_env    # シンプルなVPC環境のEC2インスタンスを削除する
rake EC2:destroy_standard_vpc_env  # 標準的なVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type01_env        # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type02_env        # １つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type03_env        # １つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type04_env        # ２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type05_env        # ２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type06_env        # ２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する
rake EC2:destroy_type07_env        # ２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCのVPC環境のEC2インスタンスを削除する
rake EC2:reboot_simple_vpc_env     # シンプルなVPC環境にEC2インスタンス再起動する
rake EC2:reboot_standard_vpc_env   # 標準的なVPC環境にEC2インスタンスを再起動する
rake EC2:reboot_type01             # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを再起動する
rake EC2:setup_type01_env          # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成する
rake EC2:start_simple_vpc_env      # シンプルなVPC環境にEC2インスタンス起動する
rake EC2:start_standard_vpc_env    # 標準的なVPC環境にEC2インスタンスを起動する
rake EC2:start_type01              # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを起動する
rake EC2:stop_simple_vpc_env       # シンプルなVPC環境にEC2インスタンス停止する
rake EC2:stop_standard_vpc_env     # 標準的なVPC環境にEC2インスタンスを停止する
rake EC2:stop_type01               # １つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを停止する
rake VPC:create_simple_vpc         # シンプルなVPCを作成する
rake VPC:create_standard_vpc       # 標準的なVPCを作成する
rake VPC:destroy_simple_vpc        # シンプルなVPCを削除する
rake VPC:destroy_standard_vpc      # 標準的なVPCを削除する
```

## 注意

## 参照
+ [Rails ではない場合に gem で定義された Rake Task を呼び出す](http://qiita.com/dany1468/items/ed738709c4db16e1cdfd)
