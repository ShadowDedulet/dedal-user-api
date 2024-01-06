[![Build status](https://github.com/ShadowDedulet/mucas-user-api/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/ShadowDedulet/mucas-user-api/actions/workflows/test.yml)

# User API

## Contents
- [Build and Run](#build-and-run)
- [Swagger](#swagger)
- [Tests](#tests)


## Build and Run

```bash
docker-compose build app
docker-compose run --rm app rails db:prepare
docker-compose up app
```

## Swagger

UI: http://localhost:3000/swagger

JSON-схема: http://localhost:3000/api/swagger_doc.json

## Tests

```bash
docker-compose run --rm -e RAILS_ENV=test -e COVERAGE=true app rspec --format documentation
```
