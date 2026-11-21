# cryptoAMLChecker

iOS-приложение с функцией AML проверки криптоадресов по открытым API: пользователь вводит адрес и получает уровень риска и флаги от каждого источника и нативный (только ETH и TRX) баланс кошелька (с переводом в USD)

- Доступны сети ETH и Tron

- AML проверка по API сервисов **GoPlus Security** и **TRM Labs**, итоговый вердикт - "худший" результат из источников

## Запуск

1. Склонировать репозиторий.
2. Скопировать шаблон: `cp Secrets.example.xcconfig Secrets.xcconfig`
3. Вписать в `Secrets.xcconfig` свой ключ с [etherscan.io/apis](https://etherscan.io/apis).
4. Открыть `cryptoAMLChecker.xcodeproj` и запустить
