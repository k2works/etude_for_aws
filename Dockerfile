FROM alpine:3.5
ENV AWSCLI_VERSION "1.11.80"
RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        bash \
        && \
    pip install --upgrade awscli==${AWSCLI_VERSION} && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*
VOLUME /root/.aws
VOLUME /project
WORKDIR /project
CMD ["bash"]
