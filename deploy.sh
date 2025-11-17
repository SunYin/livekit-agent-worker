#!/bin/bash

# LiveKit Agent Worker 部署脚本

set -e

echo "🚀 LiveKit Agent Worker 部署脚本"
echo "=================================="

# 检查 .env 文件是否存在
if [ ! -f .env ]; then
    echo "❌ 错误: .env 文件不存在"
    echo "请创建 .env 文件并配置以下环境变量："
    echo "  DASHSCOPE_API_KEY=your_api_key"
    echo "  LIVEKIT_URL=ws://localhost:7880"
    echo "  LIVEKIT_API_KEY=your_livekit_key"
    echo "  LIVEKIT_API_SECRET=your_livekit_secret"
    exit 1
fi

# 选择部署模式
echo ""
echo "请选择部署模式："
echo "1) 开发环境（支持热重载）"
echo "2) 生产环境"
read -p "选择 [1-2]: " mode

case $mode in
    1)
        echo ""
        echo "🔧 启动开发环境..."
        docker-compose -f docker-compose.dev.yml down
        docker-compose -f docker-compose.dev.yml build
        docker-compose -f docker-compose.dev.yml up -d
        echo "✅ 开发环境已启动"
        echo "📝 查看日志: docker-compose -f docker-compose.dev.yml logs -f"
        ;;
    2)
        echo ""
        echo "🏭 启动生产环境..."
        docker-compose down
        docker-compose build
        docker-compose up -d
        echo "✅ 生产环境已启动"
        echo "📝 查看日志: docker-compose logs -f"
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "🎉 部署完成！"
echo ""
echo "常用命令："
echo "  查看日志: docker-compose logs -f"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart"
echo "  查看状态: docker-compose ps"
