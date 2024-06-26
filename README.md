# ubuntu 初始化

```
curl -s https://raw.githubusercontent.com/i18n-ops/ubuntu/main/boot.sh | CN=1 bash
```

CN=1 表示切换语言为中文，时区为北京

如果没有用 `../ssh/restore.sh` 恢复，那么， 用之前先运行下面的命令，启用人工智能补全

```
vi +'Codeium Auth' +q
```
