# Pálya és inventory mentése

A játék automatikusan ment a pályára belépéskor és minden tárgyváltozáskor.
A főmenü Folytatás gombja visszatölti a legutóbb elért pályát és a tárgyakat.
Mentés nélkül a Folytatás inaktív. Az új játék üres inventoryval indul;
az előző mentést az új pályára belépés írja felül.
A karakter pozíciója is mentésre kerül: két másodpercenként, tárgyváltozáskor, a pálya elhagyásakor és az ablak bezárásakor. Folytatáskor ugyanoda kerül vissza. A régi, pozíció nélküli mentéseknél a kezdőpontról indul.

## Tárgyak bekötése

Tárgy felvételekor hívd ezt a tárgy saját kódjából:

```gdscript
SaveManager.add_item("kulcs", 1)
```

Felhasználás előtt ellenőrizheted a mennyiséget:

```gdscript
if SaveManager.get_item_count("kulcs") > 0:
	SaveManager.remove_item("kulcs", 1)
```

A képernyő bal felső sarkában látható az egyszerű tárgylista.
A projektben még nincsenek bekötött felvehető tárgyak. Ezek eseményéből kell
meghívni a fenti függvényeket. Az inventory szótárat ne módosítsd közvetlenül.
Az add_item/remove_item visszatérési értéke a mentés sikerét jelzi;
írási hiba esetén a változás memóriában megmarad, és hibaüzenet jelenik meg.

## Új pálya

Minden új játékpálya _ready() függvényéből hívd:

```gdscript
SaveManager.enter_level(scene_file_path, $CharacterBody2D)
```

Menükből ne hívd. A game.gd ezt már tartalmazza.
A rendszer a legutóbb megnyitott pályát tárolja, nem fejezetfeloldási listát.

## Mentési fájl

`user://progress.json` — a Godot projektmenüjének felhasználói adatmappát
megnyitó parancsával elérhető. Az írás először ideiglenes fájlba történik.
A mentés verzióját, pályáját és a tárgyak mennyiségét betöltéskor ellenőrizzük.

## Kézi próba

1. Indíts új játékot, majd nyisd meg a pályát.
2. Egy tárgyfelvételből add hozzá a kulcsot a fenti hívással.
3. Lépj ki és indítsd újra a játékot.
4. Válaszd a Folytatást: a pálya és a kulcs mennyisége álljon vissza.

Godot dokumentáció: https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
