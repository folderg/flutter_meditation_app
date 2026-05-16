FROM ubuntu:22.04 AS build
RUN apt-get update && apt-get install -y curl git unzip xz-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /opt/flutter && \
    git config --global --add safe.directory /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
WORKDIR /app
COPY . .
RUN flutter config --enable-web && \
    flutter create --platforms web . && \
    flutter pub get && \
    flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
