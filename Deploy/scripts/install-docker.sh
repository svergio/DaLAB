#!/bin/bash

# Скрипт для установки Docker и Docker Compose на Ubuntu

set -e

# Проверка, что скрипт запущен с sudo
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: Запустите скрипт с sudo: sudo ./install-docker.sh"
    exit 1
fi

# Обновление пакетов
echo "Обновление пакетов..."
apt update

# Установка зависимостей
echo "Установка зависимостей..."
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление GPG-ключа Docker
echo "Добавление GPG-ключа Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление репозитория Docker
echo "Добавление репозитория Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление пакетов и установка Docker
echo "Установка Docker..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# Запуск и включение Docker
echo "Запуск Docker..."
systemctl enable docker
systemctl start docker

# Проверка Docker
if ! docker --version; then
    echo "Ошибка: Docker не установлен корректно."
    exit 1
fi
echo "Docker установлен: $(docker --version)"

# Установка Docker Compose
echo "Установка Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Проверка Docker Compose
if ! docker-compose --version; then
    echo "Ошибка: Docker Compose не установлен корректно."
    exit 1
fi
echo "Docker Compose установлен: $(docker-compose --version)"

echo "Установка Docker и Docker Compose завершена."