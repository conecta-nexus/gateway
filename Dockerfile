FROM nginx:alpine

# Remove default configuration files and create certs directory
RUN rm -rf /etc/nginx/conf.d/* && mkdir -p /etc/nginx/certs

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
