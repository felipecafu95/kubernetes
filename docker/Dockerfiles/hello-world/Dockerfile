FROM nginx:1.20.0
ARG APP_VERSION
ADD index.html /usr/share/nginx/html
ADD ./img/$APP_VERSION.* /usr/share/nginx/html
RUN sed -i "s/VERSION/$APP_VERSION/g" /usr/share/nginx/html/index.html
EXPOSE 80