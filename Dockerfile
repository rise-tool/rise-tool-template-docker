#
# 设置基础镜像
#
FROM rockylinux:9-minimal

#
# 安装服务依赖
#
RUN microdnf update -y \
&& microdnf install -y epel-release \
&& microdnf clean all \
&& rm -rf /var/cache/dnf /var/cache/yum

#
# 创建工作目录
#
WORKDIR /workspace

#
# 设置启动脚本
#
COPY ./bin/test.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/test.sh

#
# 指定启动脚本
#
ENTRYPOINT ["/usr/local/bin/test.sh"]

#
# 指定启动参数
#
CMD []
