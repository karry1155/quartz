# Docker 部署 Code-Server 个人实战笔记 (Mac Mini篇)

## 1. 项目简介

Code-Server 是将 VS Code 运行在服务器上的开源项目，通过浏览器即可访问。

- **核心优势**：实现连续编码体验（从公司到家无缝切换）、iPad 远程写代码。
    
- **部署环境**：Mac Mini (Host) + Docker。
    
- **镜像选择**：`linuxserver/code-server` (社区维护版，相比官方版更轻量且易于配置)。
    

## 2. Docker 部署命令

### 关键配置说明

- **网络**：由于国内网络环境，拉取插件和更新容器内软件需要代理，使用了 `host.docker.internal` 指向宿主机的代理端口 (7890)。
    
- **权限**：`PUID=1026` / `PGID=101` 对应宿主机当前用户的 ID，防止文件读写权限问题。
    
- **挂载**：将宿主机的 `/Users/用户名/Documents/code-server` 挂载到容器的 `/config`，数据持久化保存。
    

### 启动命令

在 Mac 终端执行：

Bash

```
docker run -d \
  --name=code-server \
  -e PUID=1026 \
  -e PGID=101 \
  -e TZ=Asia/Shanghai \
  -e PASSWORD=密码 \
  -e http_proxy=http://host.docker.internal:7890 \
  -e https_proxy=http://host.docker.internal:7890 \
  -e all_proxy=socks5://host.docker.internal:7890 \
  -p 28443:8443 \
  -v /Users/syj/Documents/code-server:/config \
  --restart unless-stopped \
  linuxserver/code-server:latest
```

> 访问地址：http://localhost:28443 (或 Mac 的局域网 IP:28443)或是ipv6


---

## 3. 后端环境配置 (容器内)

插件（如 Code Runner, CMake Tools）只是前端，需要容器内部安装对应的编译器和工具链才能工作。

### 进入容器

Bash

```
# 以 root 身份进入容器，否则无法使用 apt-get
docker exec -it -u root code-server bash
```

### 安装基础工具链 (C/C++/Python)

在容器内部终端执行：

Bash

```
# 1. 更新软件源
apt-get update

# 2. 安装 C/C++ 核心环境
# clangd: 强大的语言服务器（代码补全、跳转）
# build-essential: 包含 gcc, g++, make 等
# cmake: 构建工具
# gdb: 调试器
apt-get install clangd build-essential cmake gdb -y

# 3. 安装 Python 环境 (可选，若写Python必装)
# python3-venv: 虚拟环境工具，Code-Server中开发Python极其依赖venv
apt-get install python3 python3-pip python3-venv -y

# 4. 安装完成后退出容器
exit
```

### 重启服务

为了让环境变量生效，建议重启容器：

Bash

```
docker restart code-server
```

---

## 4. 前端插件与设置 (浏览器内)

登录 Code-Server 网页端进行配置。

### 必装插件

在左侧扩展商店（Extensions）搜索并安装：

1. **Chinese (Simplified)**: 中文语言包（安装后需 `Ctrl+Shift+P` -> `Configure Display Language` 切换）。
    
2. **clangd**: C/C++ 智能提示核心（LLVM Team出品），比微软官方的 C++ 插件在 Docker 中更轻量高效。
    
3. **Code Runner**: 一键运行代码。
    
4. **CMake Tools**: 管理复杂的 C++ 项目。
    
5. **Python**: 微软官方插件 (ID: `ms-python.python`)。
    

### 关键设置：Code Runner

默认 Code Runner 在“输出”面板运行，不支持输入（如 `scanf`）。需改为在“终端”运行。

1. 点击左下角齿轮 ⚙️ -> **设置**。
    
2. 搜索 `Run Code Configuration`。
    
3. 勾选 **Run In Terminal**。
    

---

## 5. 开发工作流演示

### 场景一：C 语言单文件 (gcc)

1. **新建文件**：`main.c`
    
2. **编写代码**：
    ```C
    #include <stdio.h>
    int main() {
        printf("Hello, C from code-server!\n");
        return 0;
    }
    ```
    
3. **运行方式 A (推荐)**：点击右上角 ▶️ 播放按钮（使用 Code Runner）。
    
4. 运行方式 B (手动编译)：
    
    呼出终端 (Ctrl + ~)，输入：

    ```Bash
    gcc main.c -o hello
    ./hello
    ```
    

### 场景二：Python 项目 (虚拟环境最佳实践)

Code-Server 中 Python 开发强烈建议使用虚拟环境 (`venv`) 避免环境冲突。

1. **创建项目目录**：`mkdir my_py_project && cd my_py_project`
    
2. **创建虚拟环境**：

    ``` Bash
    python3 -m venv .venv
    ```
    
3. **激活环境**：

	```Bash
	source .venv/bin/activate
	# 激活后终端会显示 (.venv)
	```
    
4. **选择解释器**：
    
    - 按 `Ctrl+Shift+P` -> 输入 `Python: Select Interpreter`。
        
    - **关键步骤**：选择路径包含 `./.venv/bin/python` 的选项。
        
5. **安装库**：`pip install requests` (此时库会安装在项目文件夹下)。
    
6. **运行**：点击右上角 ▶️，Code Runner 会自动使用虚拟环境运行。
    

---

## 6. 常见命令速查

|**操作**|**命令**|
|---|---|
|**重启容器**|`docker restart code-server`|
|**停止容器**|`docker stop code-server`|
|**查看日志**|`docker logs -f code-server`|
|**进容器(root)**|`docker exec -it -u root code-server bash`|
|**进容器(默认)**|`docker exec -it code-server bash`|

## 参考资料

- 原教程: [Docker部署Code-Server教程](https://www.cnblogs.com/zqingyang/p/19219504)
- 视频教程：[cpolar-B站教程](https://www.bilibili.com/video/BV1BQ4czDEzQ/?spm_id_from=333.1391.0.0&vd_source=f6768becdb1eb40ecd2c2980dc35cd4f)
- 镜像地址: [linuxserver/code-server](https://hub.docker.com/r/linuxserver/code-server)