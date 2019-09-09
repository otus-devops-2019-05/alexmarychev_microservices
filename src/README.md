# Micorservices

1. Создал dockerfile для микросервисов comment, post, и ui.

2. Создал сеть для приложения.

3. Запустил контейнеры с другими сетевыми алиасами:
```
docker run -d --network=reddit \
    --network-alias=post_db_test \
    --network-alias=comment_db_test \
    mongo:latest

docker run -d --network=reddit \
    --network-alias=post_test \
    -e "POST_DATABASE_HOST=post_db_test" \
    alexmarychev/post:1.0

docker run -d --network=reddit \
    --network-alias=comment_test \
    -e "COMMENT_DATABASE_HOST=comment_db_test" \
    alexmarychev/comment:1.0

docker run -d --network=reddit \
    -p 9292:9292 \
    -e "POST_SERVICE_HOST=post_test" \
    -e "COMMENT_SERVICE_HOST=comment_test" \
    alexmarychev/ui:1.0
```
4. Оптимизировал образ приложения.

5. Собрал образ сервиса ui на основе linux alpine:
```
FROM alpine:3.7 #образ linux alpine 3.7

RUN apk add --no-cache build-base

RUN apk update && apk upgrade && \
  apk --no-cache add ruby ruby-dev ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal && \ #установка ruby
  rm -rf /var/cache/apk/* #удаление временных файлов
```
Таким образом образ стал весить 216 МБ

6. Добавил в гит файл docker-1.log из предыдущего задания :)

