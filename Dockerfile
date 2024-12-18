FROM alpine:edge

MAINTAINER Ryan_Sffzh <ryan@sffzh.cn>

RUN apk update && \
	apk add --no-cache --update bash && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data /.tmp && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2-webui && \
	rm /aria2-webui/.git* -rf && \
	apk del git && \
	mkdir -p /aria2ng && \
	cd /aria2ng && \
	apk add --update wget && \
	wget -N --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/1.3.7/AriaNg-1.3.7.zip && \
    unzip AriaNg-*.zip && rm -rf AriaNg-*.zip  && \
	apk del wget && \
    apk add --update darkhttpd
    

COPY files /conf-copy

RUN addgroup -S aria                      \
    && adduser -D -S -G aria aria -u 1000 \
    && mkdir -p /data/.tmp /conf          \
    && mv /aria2-webui/docs /aria2ng/webui  && rm -rf /aria2-webui   \
    && chown -R aria:aria /data /conf /aria2ng /conf-copy  /.tmp     \
    && chmod +x /conf-copy/start.sh


USER aria

WORKDIR /
VOLUME /data /conf

ENV SECRET=edit_$conf/aria2.conf
EXPOSE 6800 
EXPOSE 8080

CMD ["/conf-copy/start.sh"]
