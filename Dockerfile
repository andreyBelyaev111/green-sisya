# Базовый образ Node.js для сборки приложения
FROM node:16 as build-stage

# Рабочая директория внутри контейнера
WORKDIR /app

# Копируем файлы package.json и устанавливаем зависимости
COPY package*.json ./
RUN npm install

# Копируем все файлы проекта и собираем приложение
COPY . .
RUN npm run build

# Используем nginx для статической выдачи собранного фронтенда
FROM nginx:alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Открываем 80 порт для доступа
EXPOSE 80

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]
