# Nazgul Dragons — мод-мост: драконы AGOT → LoTR RIE (CK3 1.19.x)

Идея: взять **систему драконов из A Game of Thrones** (spawn → bonding → riding → боевые бонусы армии) и дать **Назгулам из LotR: Realms in Exile** возможность летать на падаль-зверях (fell beasts), как в фильмах.

## ⚠️ Прочитай сначала — это важно

У меня нет доступа к файлам самих модов (AGOT и LotR RIE лежат у тебя на диске). Поэтому каркас мода готов, но **часть имён — предположительная** и помечена `TODO`. Чтобы довести до рабочего состояния, нужны файлы для реверс-инжиниринга (список ниже). Без них часть эффектов останется заглушками.

## Структура

```
mod/dragons_of_theNazgul.mod            # дескриптор (копируется в Documents/Paradox Interactive/mod/)
mod/dragons_of_theNazgul/
 ├─ common/dragon_types/nazgul_dragons.txt          # типы fell beast'ов (порт AGOT dragon_types)
 ├─ common/traits/nazgul_fellbeast_traits.txt       # трейты-мосты "наездник зверя"
 ├─ common/scripted_triggers/...                    # кто имеет право летать (Nazgûl-проверка)
 ├─ common/scripted_effects/...                     # призыв зверя + привязка наездника
 ├─ common/decisions/nazgul_fellbeast_decisions.txt # решения «Оседлать зверя» / «Взлететь»
 ├─ events/nazgul_fellbeast_events.txt              # цепочка событий призыва/гибели/дара
 └─ localization/{english,russian}/*.yml
```

## Порядок загрузки (критично!)

`Vanilla → LotR RIE → AGOT → Nazgul Dragons`
(в лаунчере этот мод должен быть **ниже обоих**; тогда его `common/*` переопределяют чужие файлы, а скриптовый доступ к dragon-системе AGOT сохраняется).

## Что нужно от тебя для реверс-инжиниринга (REVERSE)

Пришли содержимое этих файлов/папок (архивом или по одному):

### Из AGOT (`Documents/Paradox Interactive/mods/A Game of Thrones .../`)
1. `common/dragon_types/*.txt` — точный список полей типа дракона (мои поля `host_damage`, `minimum_riding_age` и т.д. — реконструкция; сверим 1-в-1).
2. Всё, где создаётся/оседлывается дракон — поиск по словам `create_dragon`, `dragon = {`, `can_be_ridden`, `rider`, `eggs`. Скорее всего:
   - `common/scripted_effects/*dragon*.txt`
   - `events/*dragon*.txt` (hatching, bonding, riding)
   - трейты `dragon_*` / `can_have_dragon` и т.п.
3. `gui/window_dragon*` или скриншот UI драконов (если хочешь их интерфейс вместо решений).
4. Пути ассетов: `gfx/models/dragons/...`, `interface/event_images/*dragon*` (для `picture=` и `portrait=`).

### Из LotR RIE (`mods/LotR - Realms in Exile .../`)
5. `common/trraits/*nazg*` — **точные ключи** трейтов Назгул (сейчас заглушки `nazgul`, `lord_of_the_nazgul`).
6. Реализация системы Ужаса (terror): `common/scripted_effects/*terror*`, `common/modifiers/*terror*` — чтобы ездовой зверь усиливал террор, как в фильмах.
7. Id персонажей Девяти (Кхот, Короли-чародеи…) из `history/characters/*.txt`, если хочешь стартовым Назгул выдать готовых зверей.

### Дополнительно
8. Твой `error.log` после первого запуска (`Documents/Paradox Interactive/Crusader Kings III/logs/error.log`) — так я найду все несовпадения ключей автоматически.

## Известные заглушки (все помечены TODO в коде)

| Место | Заглушка | Чем заменить |
|---|---|---|
| dragon_types | имена полей (`host_damage`, `rider_terror_add`…) | реальные поля AGOT |
| scripted_effects | `create_dragon`, `set_dragon_mount`, `set_dragon_rider` | реальные эффекты AGOT |
| scripted_triggers | `has_trait = nazgul / lord_of_the_nazgul` | реальные трейт-ключи RIE |
| traits | `opposite = cannot_have_dragon`, `terror_decay_mult` | подтвердить существование в 1.19/AGOT |
| decisions/events | `picture=`, `theme=` | существующие ассеты |
| gfx | пути `.dds/.mesh` | пути из AGOT |

## Быстрый тест без AGOT

Если не хочешь тащить весь AGOT ради одной механики — есть план Б: реализовать fall-back «ездовых зверей» на чистых CK3-средствах (custom trait + modifier + события). Скажи — сделаю автономную версию, которой не нужен AGOT вообще.

## Установка

1. Скопировать `dragons_of_theNazgul.mod` и папку `dragons_of_theNazgul/` в `Documents/Paradox Interactive/`.
2. В лаунчере включить: LotR RIE → AGOT → **Nazgul Dragons** (этот — последний).
3. Запустить, открыть error.log, прислать его мне вместе с файлами из раздела REVERSE.
