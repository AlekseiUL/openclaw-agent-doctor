#!/bin/bash
# Auto-diagnostic script для OpenClaw
# Можно запускать из крона или вручную
# Версия: 2.0.0 (обновлен под новую схему конфига)

set -e

OPENCLAW_DIR="$HOME/.openclaw"
MEMORY_DIR="${OPENCLAW_DIR}/memory"
CONFIG="${OPENCLAW_DIR}/openclaw.json"

echo "🏥 AGENT DOCTOR - Автодиагностика"
echo "================================"
echo ""

# Цвета для вывода
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

ISSUES=0

# Функция для проверки
check() {
    local name="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "Проверка: $name... "
    
    if result=$(eval "$command" 2>&1); then
        if [[ "$expected" == "" ]] || [[ "$result" == *"$expected"* ]]; then
            echo -e "${GREEN}✅ OK${NC}"
            return 0
        else
            echo -e "${RED}❌ FAIL${NC}"
            echo "   Ожидалось: $expected"
            echo "   Получено: $result"
            ((ISSUES++))
            return 1
        fi
    else
        echo -e "${RED}❌ ERROR${NC}"
        echo "   $result"
        ((ISSUES++))
        return 1
    fi
}

# 1. Память
echo "🧠 ПАМЯТЬ"
echo "--------"

check "SQLite база существует" \
    "ls ${MEMORY_DIR}/*.sqlite 2>/dev/null" \
    ".sqlite"

if [[ -f "${MEMORY_DIR}/main.sqlite" ]]; then
    check "WAL mode включен" \
        "sqlite3 ${MEMORY_DIR}/main.sqlite 'PRAGMA journal_mode;'" \
        "wal"
fi

# Проверка memory-core плагина (новая схема)
check "memory-core плагин включен" \
    "jq -r '.plugins.entries[\"memory-core\"].enabled // false' $CONFIG" \
    "true"

echo ""

# 2. Кроны
echo "⏰ КРОНЫ"
echo "-------"

if command -v openclaw &> /dev/null; then
    check "Список кронов доступен" \
        "openclaw cron list --json 2>/dev/null | jq 'length'" \
        ""
else
    echo -e "${YELLOW}⚠️  openclaw CLI недоступен${NC}"
    ((ISSUES++))
fi

echo ""

# 3. Конфиг
echo "⚙️ КОНФИГ"
echo "--------"

check "openclaw.json валидный" \
    "jq empty $CONFIG" \
    ""

# Проверка моделей (новая схема - models.providers)
check "Модели настроены" \
    "jq '.models.providers | keys | length' $CONFIG" \
    ""

# Проверка auth профилей
check "Auth профили настроены" \
    "jq '.auth.profiles | keys | length' $CONFIG" \
    ""

echo ""

# 4. Gateway
echo "🔧 GATEWAY"
echo "---------"

if command -v openclaw &> /dev/null; then
    # Проверяем статус без строгого ожидания
    status_output=$(openclaw status 2>&1 || true)
    if echo "$status_output" | grep -qi "running\|daemon.*active\|gateway.*ok"; then
        echo -e "Проверка: Gateway запущен... ${GREEN}✅ OK${NC}"
    else
        echo -e "Проверка: Gateway запущен... ${YELLOW}⚠️  Проверьте вручную${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Не могу проверить статус${NC}"
fi

echo ""

# 5. Система
echo "💾 СИСТЕМА"
echo "---------"

# Node.js - проверяем мажорную версию >= 20
node_version=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [[ "$node_version" -ge 20 ]]; then
    echo -e "Проверка: Node.js версия >= 20... ${GREEN}✅ OK${NC} (v${node_version})"
else
    echo -e "Проверка: Node.js версия >= 20... ${RED}❌ FAIL${NC} (v${node_version})"
    ((ISSUES++))
fi

# Python - проверяем версию >= 3.11
python_version=$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d. -f1,2)
python_major=$(echo "$python_version" | cut -d. -f1)
python_minor=$(echo "$python_version" | cut -d. -f2)
if [[ "$python_major" -ge 3 ]] && [[ "$python_minor" -ge 11 ]]; then
    echo -e "Проверка: Python >= 3.11... ${GREEN}✅ OK${NC} ($python_version)"
else
    echo -e "Проверка: Python >= 3.11... ${YELLOW}⚠️  Рекомендуется обновить${NC} ($python_version)"
fi

# Свободное место (минимум 1GB)
free_space=$(df -k ~ | tail -1 | awk '{print $4}')
free_gb=$((free_space / 1024 / 1024))
if [[ $free_gb -ge 1 ]]; then
    echo -e "Проверка: Свободное место... ${GREEN}✅ OK${NC} (${free_gb}GB)"
else
    echo -e "Проверка: Свободное место... ${RED}❌ МАЛО${NC} (${free_gb}GB)"
    ((ISSUES++))
fi

echo ""

# 6. Безопасность
echo "🛡️ БЕЗОПАСНОСТЬ"
echo "--------------"

bind=$(jq -r '.gateway.bind // "127.0.0.1"' $CONFIG 2>/dev/null)
if [[ "$bind" == "0.0.0.0" ]]; then
    echo -e "Проверка: Gateway bind... ${RED}❌ ОПАСНО${NC} (публичный доступ!)"
    ((ISSUES++))
else
    echo -e "Проверка: Gateway bind... ${GREEN}✅ OK${NC} ($bind)"
fi

# Проверка ключей в файлах workspace агента
agent_dir=$(jq -r '.agents.default.workspace // ""' $CONFIG 2>/dev/null)
if [[ -n "$agent_dir" ]] && [[ -d "$agent_dir/memory" ]]; then
    key_leaks=$(grep -r "sk-" "$agent_dir/memory/" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$key_leaks" -gt 0 ]]; then
        echo -e "Проверка: API ключи в памяти... ${RED}❌ НАЙДЕНЫ${NC} ($key_leaks)"
        ((ISSUES++))
    else
        echo -e "Проверка: API ключи в памяти... ${GREEN}✅ OK${NC}"
    fi
else
    echo -e "Проверка: API ключи в памяти... ${YELLOW}⚠️  Пропущено (workspace не найден)${NC}"
fi

echo ""
echo "================================"

if [[ $ISSUES -eq 0 ]]; then
    echo -e "${GREEN}✅ Все проверки пройдены!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Найдено проблем: $ISSUES${NC}"
    echo ""
    echo "Запустите полную диагностику:"
    echo "  Скажите агенту: 'продиагностируй себя'"
    exit 1
fi
