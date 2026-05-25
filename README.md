# Task tracker API

## Запуск и использование

```bash
docker compose run --rm --service-ports app bash -c "bin/setup --skip-server && bin/dev -b 0.0.0.0"
```

Сервер доступен по адресу [localhost:3000](http://localhost:3000/).

[OpenAPI схема](swagger/v1/swagger.yaml).

Попробовать API в действии можно через интерактивный интерфейс Swagger UI: [localhost:3000/api-docs](http://localhost:3000/api-docs).

## Стек

- Ruby 4.0
- Rails 8.1
- PostgreSQL 16
- Docker + Docker Compose
- RSpec + Rswag
