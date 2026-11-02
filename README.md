# Nazgul Dragons — мод-мост: драконы AGOT → LoTR RIE (CK3 1.19.x)

Идея: взять **систему драконов из A Game of Thrones** (spawn → bonding → riding → боевые бонусы армии) и дать **Назгулам из LotR: Realms in Exile** возможность летать на падаль-зверях (fell beasts), как в фильмах.

## ⚠️ Прочитай сначала — это важно

У меня нет доступа к файлам самих модов (AGOT и LotR RIE лежат у тебя на диске). Поэтому каркас мода готов, но **часть имён — предположительная** и помечена `TODO`. Чтобы довести до рабочего состояния, нужны файлы для реверс-инжиниринга (см. раздел REVERSE ниже). Без них часть эффектов останется заглушками.

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
 ├─ gfx/portraits/attachable/nazgul_fellbeast_gfx.txt # .gfx-регистрация моделей (ассеты AGOT)
 └─ localization/{english,russian}/*.yml
```

## Порядок загрузки (критично!)

`Vanilla → LotR RIE → AGOT → Nazgul Dragons`
(в лаунчере этот мод должен быть **ниже обоих**; тогда его `common/*` переопределяют чужие файлы, а скриптовый доступ к dragon-системе AGOT сохраняется).

## Что нужно от тебя для реверс-инжиниринга (REVERSE)

### ✅ Получено: путь ассетов драконов AGOT
`C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2962333032\gfx\models\portraits\agot_creatures\dragon`
(Workshop ID мода AGOT = **2962333032**.) В код уже вписаны корректные CK3-пути этого вида:
`gfx/models/portraits/agot_creatures/dragon/...` — см. `common/dragon_types/nazgul_dragons.txt`
и новый файл `gfx/portraits/attachable/nazgul_fellbeast_gfx.txt`.

**Что ещё нужно по ассетам:** листинг имён файлов в этой папке. Выполни в cmd:
```
dir "C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2962333032\gfx\models\portraits\agot_creatures\dragon" /s /b
```
и пришли вывод. По реальным именам `.mesh`/`.dds` я пропишу точные пути вместо `TODO(REVERSE)` и определю, нужен ли вообще наш .gfx-аттачмент (если AGOT уже регистрирует модели драконов сам — достаточно будет сослаться на их аттачмент).

Пришли содержимое этих файлов/папок (архивом или по одному):

### Из AGOT (`Documents/Paradox Interactive/mods/A Game of Thrones .../`)
1. `common/dragon_types/*.txt` — точный список полей типа дракона (мои поля `host_damage`, `minimum_riding_age` и т.д. — реконструкция; сверим 1-в-1).
2. Всё, где создаётся/оседлывается дракон — поиск по словам `create_dragon`, `dragon = {`, `can_be_ridden`, `rider`, `eggs`. Скорее всего:
   - `common/scripted_effects/*dragon*.txt`
   - `events/*dragon*.txt` (hatching, bonding, riding)
   - трейты `dragon_*` / `can_have_dragon` и т.п.
3. `gui/window_dragon*` или скриншот UI драконов (если хочешь их интерфейс вместо решений).
4. ✅ Пути ассетов моделей драконов — **получены**: `.../workshop/content/1158310/2962333032/gfx/models/portraits/agot_creatures/dragon` (вписаны в dragon_types и .gfx). Остался листинг имён файлов (см. блок выше) + `interface/event_images/*dragon*` для картинок событий/решений (`picture=`).

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

## Как передать мне файлы модов (REVERSE — инструкции)

Доступ к твоему компьютеру у меня нет и дать его не нужно — достаточно передать файлы одним из способов:

### Способ 1 — самый простой: архив + чат
Сделай два «тонких» архива **без тяжёлых ассетов** (gfx/portraits/models, sound, fonts — они не нужны для реверса скриптов, только txt):

PowerShell (Win+X → Windows PowerShell), пути подставь свои:
```powershell
$agot = "C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2962333032"
$lotr = Get-ChildItem "C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310" -Directory | Where-Object { $_.Name -ne "2962333032" } | Select-Object -First 1   # или впиши ID LоTR RIE явно

Compress-Archive -Path "$agot\common","$agot\events","$agot\localization","$agot\interface","$agot\gfx\models\portraits\agot_creatures\dragon" `
                 -DestinationPath "$env:USERPROFILE\Desktop\agot_scripts.zip" -Force

Compress-Archive -Path "$($lotr.FullName)\common","$($lotr.FullName)\events","$($lotr.FullName)\history","$($lotr.FullName)\localization" `
                 -DestinationPath "$env:USERPROFILE\Desktop\lotr_scripts.zip" -Force
```
(Если архив >50 МБ — разбей: отдельно `common/dragon_types`, `common/traits`, `common/scripted_effects`, `events`.)
Приложи zip к следующему сообщению в чате — я их распакую сам и найду всё необходимое.

### Способ 2 — git-репозиторий
Заведи пустой приватный репозиторий (GitHub/GitFlic), закинь туда папки `common/ events/ localization/ history/` обоих модов, дай ссылку — я склонирую и проведу реверс.

### Способ 3 — скопировать в рабочую папку
Если ты можешь класть файлы в `/workspace` этой среды — просто скопируй папки целиком, например:
```
/workspace/reference/agot/...
/workspace/reference/lotr_rie/...
```
и скажи «загрузил» — я сам сделаю поиск (`grep`) по ним.

### Чего присылать НЕ надо
`.dds/.png/.tga` текстуры, `.mesh` модели, `.wav/.ogg`, `gfx/portraits/*` (кроме листинга имён), `.dll`, архивы locator-ов — это сотни МБ и для скриптового реверса бесполезно.

### Что я сделаю, получив файлы
1. Извлеку точные поля `dragon_types` AGOT → перепишу `nazgul_dragons.txt` 1-в-1.
2. Найду эффекты/события spawn/bond/riding дракона → заменю все `TODO(REVERSE)` в scripted_effects/events на реальные вызовы.
3. Подтяну реальные трейт-ключи Назгул из LoTR RIE в триггеры допустимости.
4. Сверю систему Ужаса (terror) и встроим её в бонус ездового зверя.
5. Прогоню проверку путей gfx по фактическому листингу папки драконов.

## Быстрый тест без AGOT

Если не хочешь тащить весь AGOT ради одной механики — есть план Б: реализовать fall-back «ездовых зверей» на чистых CK3-средствах (custom trait + modifier + события). Скажи — сделаю автономную версию, которой не нужен AGOT вообще.

## Установка

1. Скопировать `dragons_of_theNazgul.mod` и папку `dragons_of_theNazgul/` в `Documents/Paradox Interactive/`.
2. В лаунчере включить: LotR RIE → AGOT → **Nazgul Dragons** (этот — последний).
3. Запустить, открыть error.log, прислать его мне вместе с файлами из раздела REVERSE.
