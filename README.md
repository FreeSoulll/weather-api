# Тестовое задание: API для статистики по погоде

## Источник данных
[AccuWeather API](https://developer.accuweather.com/apis)

### Необходимые эндпоинты:
- `/weather/current` - Текущая температура
- `/weather/historical` - Почасовая температура за последние 24 часа
- `/weather/historical/max` - Максимальная температура за 24 часа
- `/weather/historical/min` - Минимальная температура за 24 часа
- `/weather/historical/avg` - Средняя температура за 24 часа
- `/weather/by_time` - Найти температуру, ближайшую к переданному timestamp (например, `1621823790` должен отдать температуру за `2021-05-24 08:00`. Из имеющихся данных, если такого времени нет, вернуть `404`)
- `/health` - Статус бекенда (можно всегда отвечать OK)

## Руководство запуска приложения:

### 1. Клонируем репозиторий:
```sh
git clone git@github.com:FreeSoulll/weather-api.git
```

### 2. Переходим в папку с приложением:
```sh
cd weather-api
```

### 3. Установка зависимостей:
```sh
bundle install
```

### 4. Запуск миграции:
```sh
bundle exec rails db:create
bundle exec rails db:migrate
```


### 5. Создание файла .env:
```sh
sudo nano .env
```

В файле создаем `API_KEY` и `LOCATION_KEY`, куда помещаем локацию и апи ключ

### 5. Запуск приложения:
```sh
rails s
```
