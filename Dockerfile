FROM alpine AS builder

RUN mkdir -p /opt/app

WORKDIR /opt/app

COPY package.json package-lock.json ./

RUN apk add --no-cache --update nodejs npm

RUN \
    apk add --no-cache \
        cairo \
        pango \
        libjpeg-turbo \
        libpng \
        giflib \
        librsvg \
        pixman \
        libwebp && \
    apk add --no-cache --virtual build-deps \
        gcc \
        g++ \
        cairo-dev \
        pango-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        giflib-dev \
        librsvg-dev \
        pixman-dev \
        libwebp-dev \
        python3=3.10.10-r0 \
        make=4.3-r1  \
        pkgconf 

RUN npm install --production

FROM alpine

RUN mkdir -p /opt/app

WORKDIR /opt/app

RUN apk update && apk upgrade

RUN apk add --no-cache --update nodejs

RUN \
    apk add --no-cache \
        cairo \
        pango \
        libjpeg-turbo \
        libpng \
        giflib \
        librsvg \
        pixman \
        libwebp 

COPY --from=builder /opt/app/node_modules ./node_modules

COPY . .

EXPOSE 8080

CMD ["node", "main.js"]

