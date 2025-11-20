## 🖋️ 我为什么选择 Obsidian 做笔记？构建我的 AI 驱动型知识库

**原视频标题：** Obsidian 邪修用法，免费云同步，AI，手机端，进阶技巧
https://www.bilibili.com/video/BV1fZCyBYEuT/?spm_id_from=333.1007.top_right_bar_window_history.content.click
### 🎯 核心优势：选择 Obsidian 的三大理由

经过尝试多种笔记工具，我最终选择了 **Obsidian**。我的选择基于以下三大核心价值：

1. **数据安全与控制权：** 笔记本质是本地的 MarkDown 文件，数据完全由自己掌控。
    
2. **极致的用户体验：** 界面操作丝滑流畅，保证专注工作的**心流**。
    
3. **未来潜力（AI）：** 与 AI 编程工具（AI Agent）天然融合，释放笔记潜能。
    

---

### 🛡️ 模块一：数据安全与 Git 免费备份

Obsidian 中所有的笔记都是本地电脑上独立的 **MarkDown 文件**。这种本地存储模式提供了任何云端笔记无法比拟的**安全感**。

#### 1. 终极安全保障

- **数据所有权：** 即使 Obsidian 停止维护，数据也不会丢失。只需更换任何 MarkDown 编辑器即可继续使用。
    

#### 2. Git 云同步备份（推荐的免费方案）

我使用 **Git**（通过 **GitHub**）对笔记进行云端同步和备份，这比传统网盘或云笔记更安全稳定。

- **配置步骤（偏极客/程序员）：**
    
    1. **准备工作：** 注册 GitHub 账户，并下载 **GitHub Desktop**。
        
    2. **仓库创建：** 在 GitHub 创建一个 **Private**（私有）仓库。
        
    3. **Obsidian 接入：** 使用 GitHub Desktop 将远程仓库克隆到本地，然后在 Obsidian 中打开这个本地文件夹作为笔记库。
        
    4. **自动化同步（插件）：** 通过安装 Obsidian 社区插件 **`Git`** 实现自动化提交：
        
        - 开启 `Autocommit and sync after stopping file edits`，并设置合理的等待时间（例如 1 分钟）。
            
        - 开启 `Pull on startup`，确保每次启动时拉取远端最新改动。
            
- **重要：.gitignore 配置（排除大文件/配置）**
    
    - 在仓库根目录新建 `.gitignore` 文件，用于排除无需同步的文件，特别是**大文件**和**易冲突的配置**。
        
    - **建议：** 将所有视频/大图等附件都放在一个目录下，便于统一排除。
        
    - **我的配置示例：**
        
        ```
        .obsidian/workspace.json
        .obsidian/workspace-mobile.json
        /游戏/videos/
        ```
        

---

### 🌐 模块二：跨平台同步与多重备份（iCloud + 飞牛）

为了实现跨越 Mac/Win/iOS/iPadOS 的全平台同步和提供额外的冷备份，我采用了 **iCloud + 飞牛（FNNAS）**的组合方案。

#### 1. 核心同步策略

|**方案**|**负责平台**|**作用机制**|**核心目的**|
|---|---|---|---|
|**iCloud**|iPhone/iPad/Mini|移动端访问和编辑 **iCloud 云端库**。|确保移动端轻量级访问。|
|**飞牛 NAS**|Windows/Mac/Mini|通过 **飞牛同步 App**，在电脑端和 NAS 之间进行笔记的全量同步。|提供 PC 端的全量副本和高速局域网同步。|

#### 2. 飞牛 NAS 部署详情

- **飞牛 NAS 配置：** 在 NAS 上新建一个用于存储 Obsidian 笔记的中心文件夹。
    
- **电脑端 (Mac/Win)：**
    
    - 安装飞牛同步 App。
        
    - 设置本地笔记文件夹与 **飞牛 NAS 笔记文件夹** 之间进行**双向同步**，确保本地全量副本。
        
- **Mini (作为服务器/中继)：**
    
    - 登录 **iCloud 账号**，确保 Mini 可以访问 iCloud 上的 Obsidian 库。
        
    - 使用飞牛同步 App，将 **iCloud 上的 Obsidian 库** 与 **飞牛 NAS 笔记文件夹** 设置**双向同步**。
        
    - **关键优化：** 限制同步文件大小（例如 `< 50MB`），确保 iCloud 仅同步 MarkDown 文件和常规图片（避免大附件导致占用太多空间）。
        
- **飞牛优势：** 此外，利用飞牛提供的文件快照系统，实现**每天全盘快照**，提供额外的回溯和冷备份保障。
    

#### 3. 最终结果

- **iPhone/iPad：** 访问 iCloud 上的笔记文件。
    
- **Mac/Windows：** 访问本地全量笔记库（通过飞牛与 NAS 保持同步）。
    
- **Win 端（可扩展）：** 同时同步飞牛和 GitHub，实现双重备份。
    

---

### 🤖 模块三：AI 驱动工作流（Gemini CLI）

Obsidian 与 AI Agent 结合是其最具未来感的优势。我推荐使用 AI 编程工具，因为它们在处理本地 MarkDown 文件方面具备原生优势。

#### 1. 优势与玩法示例

- **AI Agent 推荐：** **Gemini CLI**（Google 出品，免费且擅长处理本地文件）。
    
- **AI 玩法：** 查找笔记、整理文件夹、模仿我的文风写作、根据思路产出爆款选题等。
    

#### 2. Windows 环境下 Gemini CLI 安装

| **步骤**          | **详细说明**                                                                                              |
| --------------- | ----------------------------------------------------------------------------------------------------- |
| **1. 必备工具**     | 安装 **Node.js** (包含 npm) 和 **Git 命令行工具**（Obsidian Git 插件依赖）。                                           |
| **2. npm 权限处理** | 如果遇到权限错误 (`ExecutionPolicy` 为 `Restricted`)，先执行：`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| **3. 安装 CLI**   | 打开终端，全局安装 Gemini CLI：<br><br>  <br><br>`npm install -g @google/gemini-cli`                            |
| **4. 启动与登录**    | 在 Obsidian 笔记目录下启动 CLI，并使用 Google 账号登录（需要海外网络环境）。                                                     |

---

### ⚡ 优势四：极致的速度与心流体验

（_原内容作为独立优势保留，也可与数据安全合并为“本地化优势”_）

- **告别卡顿：** 许多云笔记的延迟会破坏专注工作的**心流**。
    
- **极致速度：** Obsidian 丝滑稳定，再也感觉不到任何卡顿。
