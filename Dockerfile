FROM alpine:edge

MAINTAINER Ryan_Sffzh <ryan@sffzh.cn>

RUN apk update && \
	apk add --no-cache --update bash && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2-webui && \
	rm /aria2-webui/.git* -rf && \
	apk del git && \
	mkdir -p /aria2ng && \
	cd /aria2ng && \
	apk add --no-cache --update wget && \
	wget -N --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/1.3.7/AriaNg-1.3.7.zip && \
    unzip AriaNg-*.zip && rm -rf AriaNg-*.zip  && \
	apk add --update darkhttpd            \
    && groupadd -r aria                   \
    && useradd -m -r -g aria aria -u 1000 \
    && mv /aria2-webui/doc /aria2ng/webui  && rm -rf /aria2-webui      \
    && mkdir -p /data /conf && chown -R aria:aria /data /conf /aria2ng 

COPY  --chown=aria:aira files /conf-copy

RUN chmod +x /conf-copy/start.sh

USER aria

WORKDIR /
VOLUME /data /conf

ENV SECRET=edit_/conf/aria2.conf
EXPOSE 6800
EXPOSE 8080

CMD ["/conf-copy/start.sh"]
