#
# ============================== 1. 设置基础镜像 ==============================
#
FROM rockylinux:9-minimal

#
# ============================== 2. 安装服务依赖 ==============================
#
RUN microdnf update -y \
&& microdnf install -y epel-release \
&& microdnf clean all \
&& rm -rf /var/cache/dnf /var/cache/yum

#
# ============================== 3. 创建工作目录 ==============================
#
WORKDIR /workspace

#
# ============================== 4. 生成启动脚本 ==============================
#
RUN cat <<'EOF' > /usr/local/bin/test.sh
#!/bin/sh

set -eu

cat /workspace/test1/content.txt
cat /workspace/test2/content.txt

EOF

#
# ============================== 5. 设置脚本权限 ==============================
#
RUN chmod 0755 /usr/local/bin/test.sh

#
# ============================== 6. 指定启动脚本 ==============================
#
ENTRYPOINT ["/usr/local/bin/test.sh"]

#
# ============================== 7. 指定启动参数 ==============================
#
CMD []
