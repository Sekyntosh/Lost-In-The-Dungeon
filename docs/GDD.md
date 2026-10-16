# Game Design Document — Lost In The Dungeon

---

## 1. Información general

| Campo | Contenido |
| --- | --- |
| Título | Lost In The Dungeon |
| Género | Puzzle de memoria |
| Plataforma | PC (Godot 4) |
| Vista | Top-down 2D |
| Motor | Godot 4.x |
| Estudiante | Exequiel Baldini |
| Curso / materia | PROGRAMACION DE VIDEOJUEGOS III |
| Fecha | `[12/10/26]` |
| Versión del GDD | 0.1 |

---

## 2. Pitch / concepto

### Elevator pitch (1–2 oraciones)

Antes de cada laberinto el jugador ve el mapa iluminado unos segundos con cámara lejana; luego la cámara baja al personaje, todo se oscurece y solo queda la luz de un orbe mágico con tiempo limitado. Hay que recordar el camino, llegar a la salida, sumar puntaje y decidir si terminar la run con el puntaje actual o arriesgar otro laberinto más grande y perder la partida.

### Referencias / inspiración

| Referencia | Qué tomamos |
| --- | --- |
| Dont Starve Together | Ambientacion |
| Memory / dark exploration | Ver mapa → jugar a ciegas con luz limitada |
| Roguelike / risk-reward | Seguir o plantarse con el score |

---

## 3. Objetivos del proyecto (curso)

### Requisitos que debe cumplir

| Requisito | Cómo lo cubre este juego | Estado |
| --- | --- | --- |
| Top-down 2D | Vista cenital, movimiento en 8 direcciones |
| Niveles / escenarios / pantallas | Varios laberintos (stages), menú, pantalla de decisión, game over |
| Personaje controlable | Player con movimiento |
| ≥ 2 acciones además del movimiento | 1) Apagar/encender orbe 2) Tirar orbe |

### Alcance (scope)

**MVP**

- Generación + preview iluminado + oscuridad + luz del orbe
- Movimiento + apagar orbe + tirar orbe
- Llegar a la salida → score → opción de seguir o quedarse
- Escalado de tamaño por stage

---

## 4. Loop de juego

### Loop principal 

1. Empieza un stage (laberinto nuevo).
2. **Preview:** mapa iluminado, cámara lejos, dura 5 segundos.
3. Cámara hace zoom al jugador; el nivel queda oscuro.
4. El jugador navega con luz limitada (orbe).
5. Si se queda sin “energía” de luz / tiempo → el jugador queda a oscuras con apenas visibilidad y si es incapaz de encontrar la salida 30s despues de que la luz se pierde la run se acaba.
6. Si llega a la salida → suma score, recupera algo de energía del orbe.
7. plantarse y guardar score o seguir al siguiente stage (más grande / más difícil).

---

## 5. Mecánicas

### 5.1 Movimiento

| Campo | Contenido |
| --- | --- |
| Tipo | Top-down, CharacterBody2D |
| Direcciones | 8 Direcciones |
| Controles | WASD / flechas |
| Colisión | Paredes del TileMap |

### 5.2 Orbe mágico (fuente de luz)

| Campo | Contenido |
| --- | --- |
| Qué es | Orbe que ilumina alrededor del jugador |
| Recurso | Tiempo / energía que se consume mientras está activo |
| Al completar un laberinto | Se recupera una cantidad de energía |

### 5.3 Acciones del jugador

#### Acción A — Apagar / encender el orbe

| Campo | Contenido |
| --- | --- |
| Efecto | Sin luz (o luz mínima); la energía se consume menos |
| Riesgo | Navegar casi a ciegas; depende de la memoria del preview |

#### Acción B — Tirar el orbe

| Campo | Contenido |
| --- | --- |
| Efecto | El orbe avanza unos metros iluminando el area hacia la posicion del mouse |
| Riesgo | El jugador queda sin luz personal |

### 5.4 Preview del mapa

| Campo | Contenido |
| --- | --- |
| Duración base | Entre 5s ajustable con dificultad|
| Qué se muestra | Laberinto completo iluminado; marca inicio y salida |
| Cámara | Lejos → tween/zoom al player |

### 5.5 Score y progresión

| Campo | Contenido |
| --- | --- |
| Puntos por laberinto | 15 puntos por laberinto multiplicado por numero de nivel actual mas cantidad de energia del orbe restante |
| Retirarse | Guarda el score de la run |
| Seguir | Stage +1, laberinto más grande, más riesgo |
| Derrota | Se pierde la run la escore lograda se pierde y no se registra en tu high-score  |

---

## 6. Generación de niveles

| Campo | Contenido |
| --- | --- |
| Enfoque | Laberinto procedural |
| Algoritmo objetivo | Recursive backtracker (DFS + pila) |

---

## 7. Pantallas


| Pantalla | Qué muestra | Notas |
| --- | --- | --- |
| Menú principal | Jugar / créditos / salir |
| Gameplay | Laberinto + HUD (energía, stage, score) | |
| Decisión post-nivel | Seguir o plantarse | |
| Game over | score y highscore |

---

## 7. Arte y audio

### Arte

| Campo | Contenido |
| --- | --- |
| Estilo | Pixel art top-down, mazmorra oscura |
| Resolución base del proyecto | 480×270 (viewport), ventana 1280×720 |

### Audio

| Campo | Contenido |
| --- | --- |
| Música | Relajada con un toque medieval |
| SFX | Sonidos de caminar, sumbido del orbe, apagado , encendido,finalizacion del nivel y clicks en UI|

---

## 10. UI / HUD (en gameplay)

| Elemento | Qué muestra |
| --- | --- | --- |
| Energía del orbe | Barra o timer | |
| Stage actual | Número | |
| Score de la run | Número | |

---
