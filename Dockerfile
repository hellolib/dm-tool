FROM hub.deepin.com/public/uniteos:2021-slim

# Install Java and X11/GTK dependencies
# 安装相关依赖
RUN apt-get update && apt-get install -y \
    libgtk2.0-0 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    fonts-wqy-zenhei \
    fonts-noto-cjk \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*


COPY tool/ /app/tool/
COPY jdk/ /app/jdk/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /app/tool/analyzer
RUN chmod +x /app/tool/console
RUN chmod +x /app/tool/dbca.sh
RUN chmod +x /app/tool/disql
RUN chmod +x /app/tool/dmservice.sh
RUN chmod +x /app/tool/dts
RUN chmod +x /app/tool/dts_cmd_run.sh
RUN chmod +x /app/tool/manager
RUN chmod +x /app/tool/monitor
RUN chmod +x /app/tool/nca.sh
RUN chmod +x /app/tool/version.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
