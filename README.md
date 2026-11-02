# Dragons of the Nazgûl — независимый сабмод для LoTR RIE (CK3 1.19.x)

Назгулы седлают падаль-зверей «как в фильмах». Механика драконов **позаимствована**
из A Game of Thrones (конвенции: привязка `owned_dragon` + `var:current_rider`/
`var:current_dragon`, трейт наездника, статус «всадник без зверя» после гибели,
полёт = travel speed 150 / safety 200), но реализована **собственным кодом**:
**AGOT для работы мода НЕ требуется и не должен быть включён** (его dragon-система
конфликтовала бы с нашей).

## Установка
1. Скопируйте папку `mod/dragons_of_theNazgul` и файл `dragons_of_theNazgul.mod`
   в `Documents/Paradox Interactive/Crusader Kings III/mod/`.
2. В лаунчере включите: **LotR RIE → Dragons of the Nazgûl** (сабмод строго после RIE).
3. AGOT — выключить.

## Игровой процесс
- У назгулов появляется решение **«Оседлать падаль-зверя»** (200 золота или 3+ титула):
  спавнится зверь-«дракон» (трейты `nazgul_dragon` + порты AGOT: bloodthirsty и т.д.)
  и привязывается к всаднику; всадник получает трейт `nazgul_fell_beast_rider`
  (+скорость странствий, dread, замедленный распад террора).
- Решение **«Взлететь на крыльях ужаса»** — модификатор полёта на год.
- Гибель зверя отслеживается yearly on_action → событие «Пал падаль-зверь»;
  всадник становится `nazgul_fell_beast_master` и может призвать нового.
- Кхот (`lord_of_the_nazgul`) получает событие **«Дар Саурона»** — уникального
  **Владыку Ангормаунта**; также есть 10% редкий шанс при обычном призыве.

## Структура
```
common/traits/nazgul_fellbeast_traits.txt        # все трейты (автономные аналоги AGOT)
common/scripted_effects/nazgul_fellbeast_effects.txt  # claim/bind/unbind/flight
common/scripted_triggers/nazgul_fellbeast_triggers.txt # nazgul_can_ride_fell_beast
common/decisions/nazgul_fellbeast_decisions.txt  # решения
common/character_templates/nazgul_fell_beasts.txt# шаблоны зверей
common/modifiers/nazgul_fellbeast_modifiers.txt  # модификатор полёта
common/on_action/nazgul_fellbeast_on_actions.txt # проверка гибели зверя
events/nazgul_fellbeast_events.txt               # события 0001–0004
gfx/portraits/portraits/nazgul_fellbeast_portraits.txt # портрет-заглушка зверя
localization/english|russian/*.yml               # локализация (UTF-8 BOM)
```

## REVERSE — что осталось уточнить (по желанию, всё уже работает без этого)
1. **Точные ключи трейтов назгулов из LoTR RIE.** Сейчас в
   `scripted_triggers/nazgul_fellbeast_triggers.txt` используются кандидаты
   `nazgul` и `lord_of_the_nazgul`. Если у RIE другие имена — допишите их в
   блок `OR = {}`. Как найти: в папке RIE выполните
   `Select-String -Path "...\common\traits\*" -Pattern "nazg" -SimpleMatch`
   и пришлите имена найденных ключей (текстом, файлы не нужны).
2. **3D-модели из AGOT (опционально, только ради графики).** Скрипты работают
   без них. Для красивого портрета скопируйте пару файлов из
   `C:\Program Files (x86)\Steam\steamapps\workshop\content\1158310\2962333032\gfx\models\portraits\agot_creatures\dragon\`
   (например, любой `.mesh` + `.dds`) в
   `<mods>/mod/dragons_of_theNazgul/gfx/models/portraits/nazgul_dragons/` и
   раскомментируйте блок «Вариант B» в `gfx/portraits/portraits/nazgul_fellbeast_portraits.txt`,
   подставив имена файлов. Прислать можно просто листинг имён:
   `dir "...\\agot_creatures\\dragon" | Select Name` (текст в чат проходит, архивы — нет).
3. После первого запуска: если в `error.log` появятся строки со словом `nazgul` —
   пришлите их текстом, поправлю ключи.

## Известные компромиссы
- Полноценного UI «экипажа» как в AGOT нет (он завязан на их интерфейс); полёт
  реализован через travel-модификаторы и трейты — визуально это усиления + события.
- `terror_decay_multiplier` и `overrides_character_size` — поля CK3 1.19; если
  error.log сообщит о неизвестном поле в трейте, замените его на валидное из
  документации traits (мод от этого не вылетает, поле просто игнорируется).
