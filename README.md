# 🏥 Agent Doctor - OpenClaw Self-Diagnostic Skill

> Comprehensive self-diagnostics for OpenClaw agents. Checks all critical systems and provides concrete solutions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-compatible-green.svg)](https://github.com/openclaw/openclaw)

---

## 🎯 What is this?

**Agent Doctor** - an OpenClaw skill that:
- ✅ Checks 7 system categories (memory, crons, config, files, gateway, system, security)
- 🔍 Detects 28+ common problems
- 💡 Suggests concrete solutions with risk assessment
- 🛡️ Works safely - read-only, fixes only after confirmation
- 🌍 Supports all platforms (macOS, Linux, Windows)

## 🚀 Quick Start

```bash
# 1. Install skill
cd ~/your-workspace/skills
git clone <repo-url>/agent-doctor.git

# 2. Restart gateway (optional)
openclaw gateway restart

# 3. Tell your agent:
"diagnose yourself"
```

Done! Your agent will check all systems and generate a report.

## 📊 What Gets Checked?

### 🧠 Memory
- SQLite database and WAL mode
- memorySearch settings
- Embedding provider
- Memory files (MEMORY.md, daily notes)
- Folder structure

### ⏰ Crons
- Status of all crons
- Last runs
- Errors and failureCount

### ⚙️ Config
- openclaw.json validity
- Models and providers
- Plugins (especially memory-core!)
- Auth profiles

### 📁 Agent Files
- SOUL.md, IDENTITY.md
- AGENTS.md, HEARTBEAT.md, USER.md
- Skills and availability

### 🔧 Gateway
- Status and uptime
- Log errors
- Ports

### 💾 System
- Node.js >= 20
- Python >= 3.11
- Free disk space
- OpenClaw version

### 🛡️ Security
- Gateway bind (not 0.0.0.0!)
- Auth mode
- API key leaks

## 💡 Usage Examples

### Basic Diagnostics
```
You: diagnose yourself

Agent: 🏥 AGENT DIAGNOSTICS — 2026-03-06 14:30

🧠 Memory: ✅ OK
⏰ Crons: ✅ OK
⚙️ Config: ⚠️ 1 issue
📁 Files: ✅ OK
🔧 Gateway: ✅ OK
💾 System: ✅ OK
🛡️ Security: ✅ OK

━━━━━━━━━━━━━━━━━━━

📋 ISSUE DETAILS:

1. ⚠️ memory-core disabled
   📝 Problem: Plugin was disabled after update
   💡 Solution: jq '.plugins[...] | .enabled = true' ...
   ⚡ Risk: medium

━━━━━━━━━━━━━━━━━━━

Fix this? (yes/no)
```

### Automatic Check
```bash
# Create cron for daily diagnostics
openclaw cron add daily-health \
  --schedule "0 8 * * *" \
  --model "anthropic/claude-sonnet-4-6" \
  --payload '{"kind":"agentTurn","message":"Run agent-doctor..."}'
```

### Bash Script (without agent)
```bash
bash auto-diagnostic.sh
# Quick check from terminal or CI/CD
```

## 📚 Documentation

| File | Description |
|------|-------------|
| [SKILL.md](SKILL.md) | Working version (for personal agent) |
| [SKILL-public.md](SKILL-public.md) | Universal version (for publication) |
| [EXAMPLES.md](EXAMPLES.md) | 10 usage scenarios |
| [PROBLEMS_DATABASE.md](PROBLEMS_DATABASE.md) | 28 problems and solutions |
| [INSTALL.md](INSTALL.md) | Installation guide |
| [CHANGELOG.md](CHANGELOG.md) | Version history |

## 🔥 When to Use?

- ✅ **After OpenClaw update** (mandatory!)
- ✅ When agent behaves strangely
- ✅ Once a week for prevention
- ✅ Before important work (stream, presentation)
- ✅ If agent "forgets" conversations

## ⚠️ Common Problems

### Problem #1: WAL mode disabled
**Symptom:** Agent doesn't see new entries

**Solution:**
```bash
sqlite3 ~/.openclaw/memory/main.sqlite "PRAGMA journal_mode=WAL;"
```

### Problem #2: memory-core disabled
**Symptom:** Memory doesn't work after update

**Solution:**
Agent will fix automatically (after confirmation)

### Problem #3: Gateway bind = 0.0.0.0
**Symptom:** Danger! Internet access

**Solution:**
```bash
jq '.gateway.bind = "127.0.0.1"' ~/.openclaw/openclaw.json > /tmp/config.json && mv /tmp/config.json ~/.openclaw/openclaw.json
```

## 🛡️ Security

- ✅ Skill ONLY reads data
- ✅ All fixes require confirmation
- ✅ Risk assessment for each change
- ✅ No automatic config changes
- ✅ Open source (MIT License)

## 🤝 Contributing

Found a bug? Have an idea? Open an issue or PR!

**What's welcome:**
- New checks
- Problem solutions
- Documentation improvements
- Usage examples

## 📊 Stats

- **28** common problems in database
- **7** check categories
- **10** usage examples
- **3000+** lines of documentation
- **0** external dependencies

## 🙏 Acknowledgments

Created based on real OpenClaw user issues collected from GitHub, Reddit, and community feedback.

Thanks to:
- OpenClaw community for bug reports
- AI ОПЕРАЦИОНКА subscribers for feedback
- Aleksei Ulianov for idea and specification

## 📄 License

MIT License - freely use, modify, distribute.

See [LICENSE](LICENSE) for details.

## 🔗 Links

- [OpenClaw](https://github.com/openclaw/openclaw)
- [OpenClaw Discord](https://discord.com/invite/clawd)
- [OpenClaw Documentation](https://docs.openclaw.io)

---

**Version:** 1.0.0  
**Date:** 2026-03-06  
**Author:** [Aleksei Ulianov](https://github.com/AlekseiUL)

🏥 **Healthy agent = productive agent!**

---

# 🏥 Agent Doctor - Самодиагностика для OpenClaw

> Комплексная самодиагностика для OpenClaw агента. Проверяет все критичные системы и предлагает конкретные решения.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-compatible-green.svg)](https://github.com/openclaw/openclaw)

---

## 🎯 Что это?

**Agent Doctor** - скилл для OpenClaw, который:
- ✅ Проверяет 7 категорий систем (память, кроны, конфиг, файлы, gateway, система, безопасность)
- 🔍 Выявляет 28+ типовых проблем
- 💡 Предлагает конкретные решения с оценкой рисков
- 🛡️ Работает безопасно - только чтение, фиксы после подтверждения
- 🌍 Поддерживает все платформы (macOS, Linux, Windows)

## 🚀 Быстрый старт

```bash
# 1. Установить скилл
cd ~/your-workspace/skills
git clone <repo-url>/agent-doctor.git

# 2. Перезапустить gateway (опционально)
openclaw gateway restart

# 3. Сказать агенту:
"продиагностируй себя"
```

Готово! Агент проверит все системы и выдаст отчет.

## 📊 Что проверяется?

### 🧠 Память
- SQLite база данных и WAL mode
- memorySearch настройки
- Embedding провайдер
- Файлы памяти (MEMORY.md, daily notes)
- Структура папок

### ⏰ Кроны
- Статус всех кронов
- Последние запуски
- Ошибки и failureCount

### ⚙️ Конфиг
- Валидность openclaw.json
- Модели и провайдеры
- Плагины (особенно memory-core!)
- Auth profiles

### 📁 Файлы агента
- SOUL.md, IDENTITY.md
- AGENTS.md, HEARTBEAT.md, USER.md
- Skills и их доступность

### 🔧 Gateway
- Статус и аптайм
- Ошибки в логах
- Порты

### 💾 Система
- Node.js >= 20
- Python >= 3.11
- Свободное место на диске
- Версия OpenClaw

### 🛡️ Безопасность
- Gateway bind (не 0.0.0.0!)
- Auth mode
- Утечки API ключей

## 💡 Примеры использования

### Базовая диагностика
```
Вы: продиагностируй себя

Агент: 🏥 ДИАГНОСТИКА АГЕНТА — 2026-03-06 14:30

🧠 Память: ✅ OK
⏰ Кроны: ✅ OK
⚙️ Конфиг: ⚠️ 1 проблема
📁 Файлы: ✅ OK
🔧 Gateway: ✅ OK
💾 Система: ✅ OK
🛡️ Безопасность: ✅ OK

━━━━━━━━━━━━━━━━━━━

📋 ДЕТАЛИ ПРОБЛЕМ:

1. ⚠️ memory-core отключен
   📝 Что не так: Плагин отключился после обновления
   💡 Решение: jq '.plugins[...] | .enabled = true' ...
   ⚡ Риск: средний

━━━━━━━━━━━━━━━━━━━

Исправить? (да/нет)
```

### Автоматическая проверка
```bash
# Создать крон для ежедневной диагностики
openclaw cron add daily-health \
  --schedule "0 8 * * *" \
  --model "anthropic/claude-sonnet-4-6" \
  --payload '{"kind":"agentTurn","message":"Запусти agent-doctor..."}'
```

### Bash-скрипт (без агента)
```bash
bash auto-diagnostic.sh
# Быстрая проверка из терминала или CI/CD
```

## 📚 Документация

| Файл | Описание |
|------|----------|
| [SKILL.md](SKILL.md) | Рабочая версия (для личного агента) |
| [SKILL-public.md](SKILL-public.md) | Универсальная версия (для публикации) |
| [EXAMPLES.md](EXAMPLES.md) | 10 сценариев использования |
| [PROBLEMS_DATABASE.md](PROBLEMS_DATABASE.md) | 28 проблем и решений |
| [INSTALL.md](INSTALL.md) | Инструкция по установке |
| [CHANGELOG.md](CHANGELOG.md) | История версий |

## 🔥 Когда использовать?

- ✅ **После обновления OpenClaw** (обязательно!)
- ✅ При странном поведении агента
- ✅ Раз в неделю для профилактики
- ✅ Перед важной работой (стрим, презентация)
- ✅ Если агент "забывает" разговоры

## ⚠️ Частые проблемы

### Проблема #1: WAL mode отключен
**Симптом:** Агент не видит новые записи

**Решение:**
```bash
sqlite3 ~/.openclaw/memory/main.sqlite "PRAGMA journal_mode=WAL;"
```

### Проблема #2: memory-core отключен
**Симптом:** Память не работает после обновления

**Решение:**
Агент исправит автоматически (после подтверждения)

### Проблема #3: Gateway bind = 0.0.0.0
**Симптом:** Опасность! Доступ из интернета

**Решение:**
```bash
jq '.gateway.bind = "127.0.0.1"' ~/.openclaw/openclaw.json > /tmp/config.json && mv /tmp/config.json ~/.openclaw/openclaw.json
```

## 🛡️ Безопасность

- ✅ Скилл ТОЛЬКО читает данные
- ✅ Все фиксы требуют подтверждения
- ✅ Оценка рисков для каждого изменения
- ✅ Никаких автоматических изменений конфига
- ✅ Открытый исходный код (MIT License)

## 🤝 Контрибьюция

Нашли баг? Есть идея? Открывайте issue или PR!

**Что приветствуется:**
- Новые проверки
- Решения проблем
- Улучшения документации
- Примеры использования

## 📊 Статистика

- **28** типовых проблем в базе
- **7** категорий проверок
- **10** примеров использования
- **3000+** строк документации
- **0** внешних зависимостей

## 🙏 Благодарности

Created based on real OpenClaw user issues collected from GitHub, Reddit, and community feedback.

Спасибо:
- OpenClaw community за баг-репорты
- Подписчикам AI ОПЕРАЦИОНКИ за фидбек
- Алексею Ульянову за идею и спецификацию

## 📄 Лицензия

MIT License - свободно используйте, модифицируйте, распространяйте.

См. [LICENSE](LICENSE) для деталей.

## 🔗 Ссылки

- [OpenClaw](https://github.com/openclaw/openclaw)
- [OpenClaw Discord](https://discord.com/invite/clawd)
- [Документация OpenClaw](https://docs.openclaw.io)

---

**Версия:** 1.0.0  
**Дата:** 2026-03-06  
**Author:** [Aleksei Ulianov](https://github.com/AlekseiUL)

🏥 **Здоровый агент - продуктивный агент!**

---

## Resources | Ресурсы

- 📺 YouTube: [youtube.com/@alekseiulianov](https://youtube.com/@alekseiulianov)
- 📱 Telegram: [t.me/Sprut_AI](https://t.me/Sprut_AI)
- 🔥 AI ОПЕРАЦИОНКА (Premium): [Подписка](https://t.me/tribute/app?startapp=sJyg) — продвинутые материалы, скиллы, агенты, поддержка
- 💻 GitHub: [github.com/AlekseiUL](https://github.com/AlekseiUL)

## License

MIT

---

*Keeping AI agents healthy since 2026 | Делаю AI-агентов здоровыми с 2026*
