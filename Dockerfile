FROM nginx:alpine

# Remove default configuration files and create certs, templates, and cache directories
RUN rm -rf /etc/nginx/conf.d/* && mkdir -p /etc/nginx/certs /etc/nginx/templates /var/cache/nginx/catalog && chown -R nginx:nginx /var/cache/nginx

# Copy custom Nginx configuration and template
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/
COPY templates/ /etc/nginx/templates/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
