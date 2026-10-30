# Game Design Document — Lost In The Dungeon

---

## 1. Información general

| Campo | Contenido |
| --- | --- |
| Título | Lost In The Dungeon |
| Género | Caza en laberinto, top-down |
| Plataforma | PC (Godot 4) |
| Vista | Top-down 2D |
| Motor | Godot 4.x |
| Estudiante | Exequiel Baldini |
| Fecha | 28/10/26 |
| Versión del GDD | 0.4 |

---

## 2. Pitch / concepto

### Elevator pitch

Sos un fantasma en una mazmorra oscura. Tu objetivo es resolver el laberinto: llegar a una salida. En el camino podés aplastar NPCs que intentan fugarse para sumar score extra. Cada desvío para cazar suma puntos y tiempo; ir directo a la salida termina la stage antes. La run dura 10 stages.

### Fantasía

| Rol | Quién es |
| --- | --- |
| Jugador | Fantasma |
| Enemigos | NPCs |
| Escenario | Mazmorra procedural oscura |

### Referencias

| Referencia | Qué tomamos |
| --- | --- |
| Monaco | Lectura del nivel por focos de luz en oscuridad |
| Pac-Man | Cazar objetivos que se mueven por un laberinto |

---

## 3. Alcance MVP

- Laberinto procedural, preview corto, oscuridad con luces del fantasma y de los NPCs
- Movimiento por slide, Acción 1, Acción 2
- Salida como meta de la stage; NPCs que pathfindean a la salida, squash, dulces, murciélago
- 10 stages, score por stage y best score al final

---

## 4. Loop de juego

1. Empieza la stage (laberinto nuevo según el número de stage).
2. Preview: mapa iluminado durante 3 segundos.
3. El nivel queda oscuro. Arranca el timer ascendente.
4. Los NPCs caminan hacia la salida más cercana. El jugador elige cazar o ir a la salida.
5. La stage termina cuando el jugador entra en una celda de salida.
6. Se calcula el score de la stage (tiempo, kills, dulces, bonus de maze limpio) y se muestra un resumen breve.
7. Si el stage es menor a 10, sigue la siguiente stage. Si es 10, pantalla final con score de la run y best score.

El timer no corta la partida. Solo afecta el score al cerrar la stage.

---

## 5. Mecánicas

### 5.1 Movimiento

| Campo | Contenido |
| --- | --- |
| Tipo | Deslizamiento en línea recta hasta el próximo nodo |
| Nodo | Esquina, cruce o callejón sin salida |
| Controles | WASD / flechas (un toque por dirección) |
| Durante el slide | Se puede bufferizar la próxima dirección |
| Colisión | Solo celdas de piso del grid del laberinto |

### 5.2 Visión

| Campo | Contenido |
| --- | --- |
| Base | Canvas o| Versión del GDD | 0.4 |

---

## 2. Pitch / concepto

### Elevator pitch

Sos un fantasma en una mazmorra oscura. Tu objetivo es resolver el laberinto: llegar a una salida. En el camino podés aplastar NPCs que intentan fugarse para sumar score extra. Cada desvío para cazar suma puntos y tiempo; ir directo a la salida termina la stage antes. La run dura 10 stages.

### Fantasía

| Rol | Quién es |
| --- | --- |
| Jugador | Fantasma |
| Enemigos | NPCs |
| Escenario | Mazmorra procedural oscura |

### Referencias

| Referencia | Qué tomamos |
| --- | --- |
| Monaco | Lectura del nivel por focos de luz en oscuridad |
| Pac-Man | Cazar objetivos que se mueven por un laberinto |

---

## 3. Alcance MVP

- Laberinto procedural, preview corto, oscuridad con luces del fantasma y de los NPCs
- Movimiento por slide, Acción 1, Acción 2
- Salida como meta de la stage; NPCs que pathfindean a la salida, squash, dulces, murciélago
- 10 stages, score por stage y best score al final

---

## 4. Loop de juego

1. Empieza la stage (laberinto nuevo según el número de stage).
2. Preview: mapa iluminado durante 3 segundos.
3. El nivel queda oscuro. Arranca el timer ascendente.
4. Los NPCs caminan hacia la salida más cercana. El jugador elige cazar o ir a la salida.
5. La stage termina cuando el jugador entra en una celda de salida.
6. Se calcula el score de la stage (tiempo, kills, dulces, bonus de maze limpio) y se muestra un resumen breve.
7. Si el stage es menor a 10, sigue la siguiente stage. Si es 10, pantalla final con score de la run y best score.

El timer no corta la partida. Solo afecta el score al cerrar la stage.

---

## 5. Mecánicas

### 5.1 Movimiento

| Campo | Contenido |
| --- | --- |
| Tipo | Deslizamiento en línea recta hasta el próximo nodo |
| Nodo | Esquina, cruce o callejón sin salida |
| Controles | WASD / flechas (un toque por dirección) |
| Durante el slide | Se puede bufferizar la próxima dirección |
| Colisión | Solo celdas de piso del grid del laberinto |

### 5.2 Visión

| Campo | Contenido |
| --- | --- |
| Base | Canvas oscuro |
| Jugador | PointLight2D propia |
| NPCs | La misma intensidad y radio de luz que el jugador |
| Lectura | Siempre se ve cada NPC y un poco de maze a su alrededor |

### 5.3 Acción 1 — Pulso de luz

| Campo | Contenido |
| --- | --- |
| Efecto | Desde el jugador sale una onda que ilumina el mapa al pasar y luego vuelve la oscuridad |
| Cooldown | 5 segundos |
| UI | Indicador visual de carga y de lista. Sin nombre de skill en pantalla |

### 5.4 Acción 2 — Teleport al NPC

| Campo | Contenido |
| --- | --- |
| Condición | Existe un NPC a 6 celdas o menos |
| Efecto | El jugador aparece en la celda de ese NPC y lo elimina al instante |
| Cooldown | 8 segundos |
| UI | Indicador visual de carga y de lista. Sin nombre de skill en pantalla |
| Si no hay objetivo en rango | La acción no se gasta |

### 5.5 NPCs

| Campo | Contenido |
| --- | --- |
| Cantidad por stage | 4 × número de stage |
| Comportamiento | Pathfind a la salida más cercana, celda a celda, más lento que el slide del jugador |
| Escape | Al entrar en una celda de salida, desaparecen y no suman kill |
| Anti-camping | No avanzan a la celda ocupada por el jugador |
| Luz | Igual a la del jugador |

Los NPCs no terminan la stage. Solo restan oportunidades de score si escapan antes de que el jugador salga.

### 5.6 Squash

| Campo | Contenido |
| --- | --- |
| Condición | El path de un slide del jugador incluye la celda de un NPC |
| Efecto | El NPC muere, suena un squash y queda un charco en el piso |

### 5.7 Recolectables

#### Dulces

| Campo | Contenido |
| --- | --- |
| Efecto | Al recogerlos restan 3 segundos al tiempo acumulado de la stage |
| Score | 25 puntos por dulce recogido |

#### Murciélago

| Campo | Contenido |
| --- | --- |
| Cantidad | 1 por stage |
| Efecto | Elimina al NPC vivo más cercano en cualquier parte del mapa |
| Score | Cuenta como un kill normal |

### 5.8 Salida del jugador

| Campo | Contenido |
| --- | --- |
| Condición de victoria de stage | El jugador entra en una celda de salida |
| Decisión | Salir rápido mejora el bonus de tiempo; desviar a cazar mejora kills |
| Maze limpio | Si al salir no queda ningún NPC dentro del laberinto, se suma un bonus de score |

---

## 6. Generación de niveles

| Campo | Contenido |
| --- | --- |
| Algoritmo base | Recursive backtracker |
| Grid | 1 = muro, 0 = piso; pasillos de 1 tile |
| Tamaño | 21 + (stage − 1) × 2, siempre impar |
| Braids | Tras el backtracker se abren stage × 2 muros entre celdas de piso |
| Salidas stages 1–5 | 1 |
| Salidas stages 6–8 | 2 |
| Salidas stages 9–10 | 3 |
| Path de NPCs | Siempre hacia la salida más cercana |

Las salidas son la meta del jugador y la ruta de fuga de los NPCs. Con varias salidas, el jugador puede elegir cualquiera; cada NPC va a la más cercana a él.

---

## 7. Score y progresión

### Score de una stage

```
(kills × 100) + max(0, 180 − tiempo_segundos) × 5 + (dulces × 25) + bonus_limpio
```

| Término | Significado |
| --- | --- |
| kills | NPCs eliminados por slide, Acción 2 o murciélago |
| tiempo_segundos | Tiempo ascendente al salir el jugador, ya aplicado el descuento de dulces |
| dulces | Cantidad de dulces recogidos en la stage |
| bonus_limpio | 200 puntos si al salir no queda ningún NPC dentro del maze; si no, 0 |

Los NPCs que escapan no suman kill.

### Score de la run

Suma de las 10 stages. Al terminar la run se compara con el best score guardado y se actualiza si es mayor.

---

## 8. Pantallas

| Pantalla | Qué muestra |
| --- | --- |
| Menú principal | Jugar, créditos, salir |
| Gameplay | Laberinto, luces, HUD |
| Resumen de stage | Kills, escapes, tiempo, maze limpio, score de la stage |
| Pantalla final | Score de la run y best score |gundos |
| UI | Indicador visual de carga y de lista. Sin nombre de skill en pantalla |
| Si no hay objetivo en rango | La acción no se gasta |

### 5.5 NPCs

| Campo | Contenido |
| --- | --- |
| Cantidad por stage | 4 × número de stage |
| Comportamiento | Pathfind a la salida más cercana, celda a celda, más lento que el slide del jugador |
| Escape | Al entrar en una celda de salida, desaparecen y no suman kill |
| Anti-camping | No avanzan a la celda ocupada por el jugador |
| Luz | Igual a la del jugador |

Los NPCs no terminan la stage. Solo restan oportunidades de score si escapan antes de que el jugador salga.

### 5.6 Squash

| Campo | Contenido |
| --- | --- |
| Condición | El path de un slide del jugador incluye la celda de un NPC |
| Efecto | El NPC muere, suena un squash y queda un charco en el piso |

### 5.7 Recolectables

#### Dulces

| Campo | Contenido |
| --- | --- |
| Efecto | Al recogerlos restan 3 segundos al tiempo acumulado de la stage |
| Score | 25 puntos por dulce recogido |

#### Murciélago

| Campo | Contenido |
| --- | --- |
| Cantidad | 1 por stage |
| Efecto | Elimina al NPC vivo más cercano en cualquier parte del mapa |
| Score | Cuenta como un kill normal |

### 5.8 Salida del jugador

| Campo | Contenido |
| --- | --- |
| Condición de victoria de stage | El jugador entra en una celda de salida |
| Decisión | Salir rápido mejora el bonus de tiempo; desviar a cazar mejora kills |
| Maze limpio | Si al salir no queda ningún NPC dentro del laberinto, se suma un bonus de score |

---

## 6. Generación de niveles

| Campo | Contenido |
| --- | --- |
| Algoritmo base | Recursive backtracker |
| Grid | 1 = muro, 0 = piso; pasillos de 1 tile |
| Tamaño | 21 + (stage − 1) × 2, siempre impar |
| Braids | Tras el backtracker se abren stage × 2 muros entre celdas de piso |
| Salidas stages 1–5 | 1 |
| Salidas stages 6–8 | 2 |
| Salidas stages 9–10 | 3 |
| Path de NPCs | Siempre hacia la salida más cercana |

Las salidas son la meta del jugador y la ruta de fuga de los NPCs. Con varias salidas, el jugador puede elegir cualquiera; cada NPC va a la más cercana a él.

---

## 7. Score y progresión

### Score de una stage

```
(kills × 100) + max(0, 180 − tiempo_segundos) × 5 + (dulces × 25) + bonus_limpio
```

| Término | Significado |
| --- | --- |
| kills | NPCs eliminados por slide, Acción 2 o murciélago |
| tiempo_segundos | Tiempo ascendente al salir el jugador, ya aplicado el descuento de dulces |
| dulces | Cantidad de dulces recogidos en la stage |
| bonus_limpio | 200 puntos si al salir no queda ningún NPC dentro del maze; si no, 0 |

Los NPCs que escapan no suman kill.

### Score de la run

Suma de las 10 stages. Al terminar la run se compara con el best score guardado y se actualiza si es mayor.

---

## 8. Pantallas

| Pantalla | Qué muestra |
| --- | --- |
| Menú principal | Jugar, créditos, salir |
| Gameplay | Laberinto, luces, HUD |
| Resumen de stage | Kills, escapes, tiempo, maze limpio, score de la stage |
| Pantalla final | Score de la run y best score |

---

## 9. Arte y audio

### Arte

| Campo | Contenido |
| --- | --- |
| Estilo | Pixel art top-down, mazmorra oscura |
| Assets base | Tileset de dungeon del proyecto |
| Feedback de kill | Charco en el piso + SFX de squash |
| Resolución | Viewport 480×270, ventana 1280×720 |

### Audio

| Campo | Contenido |
| --- | --- |
| Música | Ambiente de mazmorra con toque Halloween |
| SFX | Whoosh de slide, squash, pulso de luz, teleport, pickup, clicks de UI |

---

## 10. UI / HUD (gameplay)

| Elemento | Qué muestra |
| --- | --- |
| Timer | Tiempo ascendente de la stage |
| Stage | Número actual (1 a 10) |
| Score de la run | Acumulado hasta el momento |
| NPCs restantes | Cuántos siguen dentro del maze |
| Acción 1 | Indicador de carga / lista |
| Acción 2 | Indicador de carga / lista |
