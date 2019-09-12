# Micorservices

#HW13

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

#HW1i4

1. Запустил контейнеры с использование none драйвера.

2. Запустил контейнер в сетевом пространстве docker-хоста.
Если запустить контейнер несколько раз, то запущен будет только один, так как несколько контейнеров не могут слушать один и тот же порт, поскольку они находятся в сетевом пространстве хоста и имеют один ip.

3. Создал bridge сеть в docker.

4. Запустил проект с использование bridge сети.

5. Установил docker-compose.

6. Собраз образы приложений с помощью docker-compose.

7. Запустил проект с помощью docker-compose.

8. Изменил docker-compose под кейс с множеством сетей:
```
post_db:
    image: mongo:${MONGO_VER}
    volumes:
      - post_db:/data/db
    networks:
      - back_net
  ui:
    build: ./ui
    image: ${USERNAME}/ui:${UI_VER}
    ports:
      - ${UI_PORT}:9292/tcp
    networks:
      - front_net
  post:
    build: ./post-py
    image: ${USERNAME}/post:${POST_VER}
    networks:
      - back_net
      - front_net

  comment:
    build: ./comment
    image: ${USERNAME}/comment:${COMMENT_VER}
    networks:
      - back_net
      - front_net

networks:
  back_net:
  front_net:
```
9. Параметризировал с помощью переменных окружений:
```
image: mongo:${MONGO_VER}
image: ${USERNAME}/ui:${UI_VER}
ports:
      - ${UI_PORT}:9292/tcp
```
10. Создал файл .env с параметризованными параметрами:
```
MONGO_VER=3.2
UI_VER=2.0
POST_VER=1.0
COMMENT_VER=1.0
UI_PORT=9292
USERNAME=appuser
COMPOSE_PROJECT_NAME=puma_app
```
11. Базовое имя проекта образуется от названия директории в котором оно находится или от переменной окружения COMPOSE_PROJECT_NAME. 
Таким образом, изменив эти значения, можно поменять имя проекта. Или передав значение через аргумент --project-name при запуске docker-compose.


