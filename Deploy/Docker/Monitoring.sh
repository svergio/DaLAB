#!/bin/bash

# Скрипт для запуска сервисов мониторинга (Portainer, Prometheus, Grafana, Loki, Promtail)

set -e

# Переменные
NETWORK_NAME="monitoring"
BASE_DIR="/workspaces/DaLAB/DaLab/coordinators"
PORTAINER_DIR="$BASE_DIR/portainer"
PROMETHEUS_DIR="$BASE_DIR/Monitoring/prometheus"
GRAFANA_DIR="$BASE_DIR/Monitoring/grafana"
LOKI_DIR="$BASE_DIR/Monitoring/loki"
PROMTAIL_DIR="$BASE_DIR/Monitoring/promtail"

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "Ошибка: Docker не установлен. Установите Docker с помощью /workspaces/DaLAB/Deploy/scripts/install-docker.sh"
    exit 1
fi

# Проверка, запущен ли Docker
if ! systemctl is-active --quiet docker; then
    echo "Ошибка: Docker не запущен. Запустите Docker: sudo systemctl start docker"
    exit 1
fi

# Проверка прав доступа к Docker
if ! docker ps &> /dev/null; then
    echo "Ошибка: Нет доступа к Docker. Добавьте пользователя в группу docker: sudo usermod -aG docker $USER"
    exit 1
fi

# Проверка наличия Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Ошибка: Docker Compose не установлен. Установите Docker Compose с помощью /workspaces/DaLAB/Deploy/scripts/install-docker.sh"
    exit 1
fi

# Создание сети, если не существует
if ! docker network ls | grep -q "$NETWORK_NAME"; then
    echo "Создание сети $NETWORK_NAME..."
    docker network create -d bridge "$NETWORK_NAME"
else
    echo "Сеть $NETWORK_NAME уже существует."
fi

# Запуск Portainer
echo "Запуск Portainer..."
cd "$PORTAINER_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "Ошибка: Файл docker-compose.yml не найден в $PORTAINER_DIR"
    exit 1
fi

# Запуск Prometheus
echo "Запуск Prometheus..."
cd "$PROMETHEUS_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "Ошибка: Файл docker-compose.yml не найден в $PROMETHEUS_DIR"
    exit 1
fi

# Запуск Grafana
echo "Запуск Grafana..."
cd "$GRAFANA_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "Ошибка: Файл docker-compose.yml не найден в $GRAFANA_DIR"
    exit 1
fi

# Запуск Loki
echo "Запуск Loki..."
cd "$LOKI_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "Ошибка: Файл docker-compose.yml не найден в $LOKI_DIR"
    exit 1
fi

# Запуск Promtail
echo "Запуск Promtail..."
cd "$PROMTAIL_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "Ошибка: Файл docker-compose.yml не найден в $PROMTAIL_DIR"
    exit 1
fi

echo "Все сервисы мониторинга успешно запущены."
echo "Доступ к сервисам:"
echo "  Portainer: http://<your-server-ip>:9000"
echo "  Prometheus: http://<your-server-ip>:9090"
echo "  Grafana: http://<your-server-ip>:3000"
echo "  Loki: http://<your-server-ip>:3100 (API)"
echo "Проверьте логи для диагностики: docker logs <container-name>"