FROM alpine:latest
COPY print_info.sh /bin/print_info.sh
RUN chmod +x /bin/print_info.sh
RUN apk add dumb-init py2-pip bash
RUN pip install lolcat
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/print_info.sh"]