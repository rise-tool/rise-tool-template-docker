#
# 设置基础镜像
#
FROM rockylinux:9-minimal

#
# 安装服务依赖
#
RUN microdnf install -y epel-release \
    && microdnf clean all

#
# 设置安全凭证
#
ARG TEST_SERVER_USER
ARG TEST_SERVER_PASS
RUN set -eu; \
    test -n "$TEST_SERVER_USER"; \
    test -n "$TEST_SERVER_PASS"; \
    umask 077; \
    printf 'username=%s\npassword=%s\n' "$TEST_SERVER_USER" "$TEST_SERVER_PASS" > /etc/test/server-auth.conf

#
# 设置启动脚本
#
COPY ./bin/test.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/test.sh
ENTRYPOINT ["/usr/local/bin/test.sh"]

#
# 指定启动参数
#
CMD []
