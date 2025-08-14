# 达梦数据库工具箱
移植自达梦数据库的内置工具；

## 移植数据库版本
```
1-4-6-2024.12.25-255012-20119-SEC 
DM Database Server 64 V8
DB Version: 0x7000c
05134284294-20241225-255012-20119
Msg Version: 21
Gsu level(5) cnt: 0
```

## 架构
- amd64

## 支持的工具

### 1. 图形化工具
- DM管理工具：数据库交互、对象管理、数据查询
- DM性能监视工具：数据库运行状态监视、性能调优、异常预警
- DM数据迁移工具：主流大型数据库、数据文件等与DM数据库之间的互相迁移
- DM数据审计分析工具：审计规则配置与管理、审计记录的查看与导出

### 2. 命令行工具
- disql达梦sql客户端
- dexp达梦数据导出工具
- dimp达梦数据导入工具

disql、dexp、dimp 命令行工具[文档地址](https://eco.dameng.com/document/dm/zh-cn/start/index.html)。

## 使用说明
### 1. 直接启用工具
- DM管理工具：`bash tool/manager`
- DM性能监视工具：`bash tool/monitor`
- DM数据迁移工具：`bash tool/dts`
- DM数据审计分析工具：`bash tool/analyzer`

- disql达梦sql客户端：
  - `./disql ...`
  - `LD_LIBRARY_PATH={BIN_PATH}:$LD_LIBRARY_PATH {BIN_PATH}/disql ...`
- dexp达梦数据导出工具：
  - `./dexp ...`
  - `LD_LIBRARY_PATH={BIN_PATH}:$LD_LIBRARY_PATH {BIN_PATH}/dexp ...`
- dimp达梦数据导入工具：
  - `./dimp ...`
  - `LD_LIBRARY_PATH={BIN_PATH}:$LD_LIBRARY_PATH {BIN_PATH}/dimp ...`


### 2. Docker容器启动图形化工具
> **disql、dexp、dimp 命令行工具不支持docker启动**
- DM管理工具: `bash dm-tools.sh manager`
- DM性能监视工具：`bash dm-tools.sh monitor`
- DM数据迁移工具：`bash dm-tools.sh dts`
- DM数据审计分析工具：`bash dm-tools.sh analyzer`


## 自行构建
- 图形化构建镜像
```bash
make docker_local VERSION=v1.0.0  # 本地构建图形化工具镜像， VERSION缺省为latest
```

- 构建并推动镜像
```bash
make docker VERSION=v1.0.0        # 构建并推送图形化工具镜像， VERSION缺省为latest
```
- 查看帮助
```bash
make help
```

## 达梦官网
- [达梦官网技术文档地址](https://eco.dameng.com/document/dm/zh-cn/start/index.html)
