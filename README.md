# LiveKit Agent Worker - 阿里云语音助手

基于 LiveKit Agents 框架和阿里云 AI 服务构建的智能语音助手服务。

## ✨ 功能特性

- 🎤 **实时语音识别 (STT)**: 使用阿里云 Paraformer 实时语音识别模型
- 🗣️ **自然语音合成 (TTS)**: 使用阿里云 CosyVoice 高质量语音合成
- 🤖 **智能对话 (LLM)**: 集成阿里云 Qwen 大语言模型
- 🚀 **低延迟**: 基于 LiveKit 实时通信框架
- 🔧 **易于配置**: 简单的环境变量配置

## 📋 前置要求

- Python 3.9 或更高版本
- 阿里云账号和 DashScope API 密钥
- LiveKit 服务器 (可选：使用 LiveKit Cloud 或自建)

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/SunYin/livekit-agent-worker.git
cd livekit-agent-worker
```

### 2. 创建虚拟环境

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
# macOS/Linux:
source venv/bin/activate
# Windows:
# venv\Scripts\activate
```

### 3. 安装依赖

```bash
pip install -r requirements.txt
```

**注意**: 如果在安装过程中遇到缺少某些依赖的问题，`requirements.txt` 已包含所有必需的包：
- `livekit-agents>=1.2.9` - LiveKit Agents 核心框架
- `livekit-plugins-aliyun>=1.2.9` - 阿里云插件
- `httpx` - HTTP 客户端（阿里云插件依赖）
- `openai` - OpenAI SDK（阿里云插件依赖）
- `python-dotenv` - 环境变量管理

### 4. 配置环境变量

复制环境变量模板并填写配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填写您的配置：

```bash
# 必需：阿里云 DashScope API 密钥
DASHSCOPE_API_KEY=your_dashscope_api_key_here

# 可选：LiveKit 服务器配置
LIVEKIT_URL=wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your_api_key
LIVEKIT_API_SECRET=your_api_secret
```

### 5. 运行服务

**开发模式（推荐，支持热重载）：**

```bash
source venv/bin/activate  # 激活虚拟环境
python agent.py dev
```

**生产模式：**

```bash
source venv/bin/activate  # 激活虚拟环境
python agent.py start
```

**其他可用命令：**

```bash
python agent.py --help          # 查看所有可用命令
python agent.py console         # 在控制台中启动对话
python agent.py connect         # 连接到特定房间
python agent.py download-files  # 下载插件依赖文件
```

## 🔑 获取 API 密钥

### 阿里云 DashScope API 密钥

1. 访问 [阿里云百炼控制台](https://bailian.console.aliyun.com/)
2. 登录您的阿里云账号
3. 在控制台中找到 API-KEY 管理
4. 创建新的 API 密钥
5. 复制密钥并保存到 `.env` 文件的 `DASHSCOPE_API_KEY` 字段

### LiveKit 配置

**选项 1: 使用 LiveKit Cloud**

1. 访问 [LiveKit Cloud](https://cloud.livekit.io/)
2. 创建新项目
3. 获取项目的 URL、API Key 和 API Secret
4. 填写到 `.env` 文件

**选项 2: 自建 LiveKit 服务器**

本地开发可以快速启动 LiveKit 服务器：

```bash
# 使用 Docker 运行 LiveKit 服务器
docker run --rm -p 7880:7880 \
  -p 7881:7881 \
  -p 7882:7882/udp \
  -v $PWD/livekit.yaml:/livekit.yaml \
  livekit/livekit-server \
  --config /livekit.yaml \
  --node-ip=127.0.0.1
```

或参考 [LiveKit 官方文档](https://docs.livekit.io/home/self-hosting/local/) 了解更多部署方式。

## ⚙️ 配置说明

### Agent 指令自定义

在 `agent.py` 中修改 `Agent` 的 `instructions` 参数来定制助手的行为：

```python
agent = Agent(
    instructions=(
        "你是一个专业的客服助手。"
        "你的职责是帮助客户解决问题并提供优质服务。"
        # ... 更多指令
    )
)
```

### 模型配置

#### STT (语音识别)

```python
stt=aliyun.STT(
    model="paraformer-realtime-v2",     # 模型名称
    vocabulary_id="your_vocab_id",      # 热词表 ID（可选）
)
```

**热词功能**: 如果需要提高特定词汇的识别准确率，可以在阿里云控制台创建热词表，并使用 `vocabulary_id` 参数。

#### TTS (语音合成)

```python
tts=aliyun.TTS(
    model="cosyvoice-v2",       # 模型: cosyvoice-v2, sambert-zhichu 等
    voice="longcheng_v2",       # 语音类型
    speech_rate=1.0,            # 语速: 0.5-2.0
    pitch_rate=1.0,             # 音调: 0.5-2.0
    volume=50,                  # 音量: 0-100
)
```

#### LLM (大语言模型)

```python
llm=aliyun.LLM(
    model="qwen-plus",          # 模型: qwen-plus, qwen-max, qwen-turbo
    temperature=0.7,            # 温度: 0.0-2.0 (越高越随机)
    max_tokens=2000,            # 最大 token 数
)
```

## 📁 项目结构

```
livekit-agent-worker/
├── agent.py              # 主应用文件
├── requirements.txt      # Python 依赖
├── .env                  # 环境变量配置（不提交到 git）
├── .env.example          # 环境变量模板
├── .gitignore           # Git 忽略配置
└── README.md            # 项目文档
```

## 🛠️ 开发指南

### 添加自定义功能

您可以使用 `@function_tool` 装饰器为 Agent 添加工具函数：

```python
from livekit.agents import function_tool

@function_tool
async def get_weather(location: str) -> str:
    """获取指定地点的天气信息"""
    # 实现天气查询逻辑
    return f"{location} 的天气是晴天"

# 在创建 Agent 时添加工具
agent = Agent(
    instructions="...",
    tools=[get_weather]
)
```

### 日志配置

修改 `agent.py` 中的日志级别：

```python
logging.basicConfig(
    level=logging.DEBUG,  # 改为 DEBUG 查看详细日志
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
```

## 🐛 故障排除

### 问题 1: 缺少依赖模块

**错误**: `ModuleNotFoundError: No module named 'httpx'` 或 `No module named 'openai'`

**解决**: 
```bash
source venv/bin/activate
pip install httpx openai  # 安装缺失的依赖
# 或重新安装所有依赖
pip install -r requirements.txt
```

### 问题 2: 虚拟环境未激活

**错误**: `ModuleNotFoundError: No module named 'livekit'`

**解决**: 确保在运行前激活虚拟环境：

```bash
source venv/bin/activate  # macOS/Linux
# 或
venv\Scripts\activate     # Windows
```

### 问题 3: API 密钥错误

**错误**: 认证失败或 API 调用错误

**解决**: 
1. 检查 `.env` 文件中的 `DASHSCOPE_API_KEY` 是否正确
2. 确认 API 密钥是否有效且未过期
3. 检查阿里云账户是否有足够的额度

### 问题 4: LiveKit 连接失败

**错误**: 无法连接到 LiveKit 服务器

**解决**:
1. 检查 `LIVEKIT_URL` 是否正确（注意 `ws://` 或 `wss://` 前缀）
2. 如使用本地服务器，确认 LiveKit 服务器是否在运行（默认 `ws://localhost:7880`）
3. 如使用 LiveKit Cloud，验证 API Key 和 Secret 是否正确
4. 检查网络连接和防火墙设置

### 问题 5: 命令行参数错误

**错误**: `Usage: agent.py [OPTIONS] COMMAND [ARGS]...`

**解决**: LiveKit Agent 需要指定子命令，不能直接运行 `python agent.py`，请使用：
```bash
python agent.py dev    # 开发模式
python agent.py start  # 生产模式
```

## 📚 相关资源

- [LiveKit Agents 文档](https://docs.livekit.io/agents/)
- [LiveKit Agents Python SDK](https://github.com/livekit/agents)
- [阿里云 DashScope 文档](https://help.aliyun.com/zh/dashscope/)
- [livekit-plugins-aliyun 插件](https://www.piwheels.org/project/livekit-plugins-aliyun/)
- [LiveKit Cloud](https://cloud.livekit.io/)
- [LiveKit 自建服务器指南](https://docs.livekit.io/home/self-hosting/local/)

## 💡 使用提示

1. **开发模式 vs 生产模式**：
   - 开发模式 (`dev`) 会监控文件变化并自动重载，适合调试
   - 生产模式 (`start`) 适合正式运行，性能更优

2. **环境变量管理**：
   - 永远不要提交 `.env` 文件到 Git
   - 使用 `.env.example` 作为模板分享配置结构

3. **API 额度**：
   - 注意监控阿里云 DashScope API 的使用额度
   - 建议在开发环境设置请求限制

4. **调试技巧**：
   - 将日志级别设为 `DEBUG` 可查看更详细的运行信息
   - 使用 `python agent.py console` 在终端直接测试对话功能

## 📄 许可证

本项目采用 MIT 许可证。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题或建议，请通过以下方式联系：

- GitHub Issues: [提交 Issue](https://github.com/SunYin/livekit-agent-worker/issues)
- Email: your-email@example.com

---

**注意**: 请勿将 `.env` 文件提交到版本控制系统，以保护您的 API 密钥安全。
