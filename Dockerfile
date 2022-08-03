FROM klakegg/hugo:alpine-onbuild AS build
COPY . /src
RUN hugo --minify

FROM nginx:alpine AS release
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80