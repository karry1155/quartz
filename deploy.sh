#!/bin/zsh

# --- 1. 配置路径 ---
# 源路径 (保留结尾的斜杠以同步目录内的文件)
SOURCE_PATH="/Users/shikairui/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian_iCloud/public/"

# 目标路径
QUARTZ_PATH="/Users/shikairui/Documents/GitHub/quartz"
CONTENT_PATH="$QUARTZ_PATH/content/"

# --- 2. 检查源文件夹是否存在 ---
if [ ! -d "$SOURCE_PATH" ]; then
    echo "错误：找不到源文件夹。请检查 iCloud 路径。"
    exit 1
fi

# --- 3. 同步文件 (rsync) ---
echo "[1/3] 同步文件中..."
rsync -a --delete --exclude='.obsidian' --exclude='.git' --exclude='.trash' --exclude='.DS_Store' "$SOURCE_PATH" "$CONTENT_PATH"

if [ $? -ne 0 ]; then
    echo "同步过程出错。"
    exit 1
fi

# --- 4. Git 提交 ---
echo "[2/3] 检查 Git 状态..."
cd "$QUARTZ_PATH" || exit

# 拉取云端最新代码以防冲突
git pull origin v4 --rebase > /dev/null 2>&1

if [[ -z $(git status -s) ]]; then
    echo "没有文件变化，无需提交。"
    exit 0
fi

git add .
TIME=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Auto-deploy: Update content $TIME" > /dev/null

# --- 5. Git 推送 ---
echo "[3/3] 推送到 GitHub..."
git push origin v4

if [ $? -eq 0 ]; then
    echo "发布成功。"
else
    echo "推送失败，请检查网络。"
fi