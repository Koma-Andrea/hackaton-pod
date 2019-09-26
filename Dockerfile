FROM alpine:latest
COPY print_info.sh /bin/print_info.sh
RUN apk add dumb-init py2-pip bash curl jq
RUN pip install lolcat
RUN chmod +x /bin/print_info.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/print_info.sh"]