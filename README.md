# nglog - Nginx日志分析工具

一个功能强大的Nginx日志分析工具，采用插件化架构设计，支持多种日志分析功能。

## 🚀 功能特性

- **插件化架构**：支持热插拔，易于扩展新功能
- **多种分析维度**：IP统计、状态码分析、URL访问、用户代理分析等
- **安全检测**：内置安全威胁检测功能
- **流量监控**：带宽使用情况和流量分布分析
- **配置灵活**：支持配置文件自定义
- **轻量级**：纯Shell脚本实现，依赖少

## 📦 安装

```bash
# 克隆项目
git clone https://github.com/your-repo/nglog.git
cd nglog

# 添加执行权限
chmod +x nglog.sh
```

## 🛠️ 使用方法

### 基本用法

```bash
# 显示帮助信息
./nglog.sh --help

# 显示版本信息
./nglog.sh --version

# 显示可用插件列表
./nglog.sh --list

# 运行指定插件分析日志
./nglog.sh -p top_ip /var/log/nginx/access.log
```

### 插件使用示例

```bash
# 统计访问量最高的IP
./nglog.sh -p top_ip /var/log/nginx/access.log

# 分析HTTP状态码分布
./nglog.sh -p status_code /var/log/nginx/access.log

# 统计最常访问的URL
./nglog.sh -p request_url /var/log/nginx/access.log

# 分析用户代理信息
./nglog.sh -p user_agent /var/log/nginx/access.log

# 分析流量和带宽使用
./nglog.sh -p traffic /var/log/nginx/access.log

# 安全分析和异常检测
./nglog.sh -p security /var/log/nginx/access.log
```

## 🔌 可用插件

| 插件名称 | 功能描述 | 版本 |
|---------|---------|------|
| `top_ip` | 统计访问量最高的IP地址 | 0.1 |
| `status_code` | 分析HTTP状态码分布情况 | 0.1 |
| `request_url` | 统计最常访问的URL | 0.1 |
| `user_agent` | 分析用户代理和浏览器信息 | 0.1 |
| `traffic` | 流量和带宽使用情况分析 | 0.1 |
| `security` | 安全威胁和异常访问检测 | 0.1 |

## ⚙️ 配置说明

配置文件位于 `conf/nglog.conf`，支持以下配置项：

```bash
# 输出配置
OUTPUT_TOP_N=10          # 默认显示前N条结果
OUTPUT_TIMESTAMP=true    # 是否显示时间戳
OUTPUT_COLOR=true        # 是否使用彩色输出

# 插件配置
PLUGIN_AUTO_LOAD=true    # 是否自动加载所有插件
PLUGIN_VERBOSE=true      # 是否显示插件详细信息

# 日志文件配置
DEFAULT_LOG_DIR="/var/log/nginx"
DEFAULT_LOG_FILE="access.log"

# 安全配置
IGNORE_LOCAL_IPS=true    # 是否忽略本地IP地址
IGNORE_BOTS=true         # 是否忽略常见爬虫
```

## 🔧 插件开发

### 插件结构

每个插件需要包含以下文件：

```
plugins/
└── plugin_name/
    ├── plugin.sh        # 插件主文件
    └── README.md        # 插件说明文档
```

### 插件模板

```bash
PLUGIN_NAME="your_plugin"
PLUGIN_DESC="插件功能描述"
PLUGIN_VERSION="0.1"
PLUGIN_AUTHOR="作者名"

plugin_init() {
    # 插件初始化代码
    return 0
}

plugin_run() {
    local log="$1"
    # 插件分析逻辑
    # 使用awk、grep等工具处理日志文件
}
```

## 📊 输出示例

### top_ip插件输出
```
=== 运行插件: top_ip ===
描述: 统计访问量最高的 IP
版本: 0.1
作者: pfinal

   1234 192.168.1.100
    567 10.0.0.1
    234 203.0.113.5
```

### status_code插件输出
```
HTTP状态码统计:
================
  1000 200
   234 404
    45 500
    23 301

状态码分类统计:
----------------
总请求数: 1302
成功请求(2xx): 1000 (76.80%)
重定向(3xx): 23 (1.77%)
客户端错误(4xx): 234 (17.97%)
服务器错误(5xx): 45 (3.46%)
```

## 🐛 故障排除

### 常见问题

1. **权限不足**：确保对日志文件有读取权限
2. **日志格式不匹配**：确认Nginx日志格式与工具兼容
3. **插件加载失败**：检查插件文件权限和语法

### 调试模式

```bash
# 启用调试输出
bash -x ./nglog.sh -p top_ip /var/log/nginx/access.log
```

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 📄 许可证

MIT License

## 👥 作者

- pfinal

---

**注意**：本工具仅用于日志分析和运维监控，请遵守相关法律法规。