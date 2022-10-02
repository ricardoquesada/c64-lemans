# Lemans for the C64

![screenshot_intro]
![screenshot_title]
![screenshot_game]

[screenshot_intro]: images/screenshot_intro.png
[screenshot_title]: images/screenshot_title.png
[screenshot_game]: images/screenshot_game.png


Lemans for the C64.

## Source code

Based on original cartridge.

- Game was fully disassembled, includes my own comments.


Includes optional patches like:

- Add rumble suport
- Fix in-game misspell
- Use joystick (instead of paddle)
- Convert it to .prg (instead of cartridge)


## Download

- Latest binary: [lemans-lia.d64]
- CSDB entry: https://csdb.dk/release/index.php?id=224027

[lemans-lia.d64]: bin/lemans-lia.d64

## Rumble support

To play it with rumble, use a [Unijoysticle Flashparty Edition][uni2_flashparty]

[uni2_flashparty]: https://gitlab.com/ricardoquesada/unijoysticle2/-/tree/main/board/unijoysticle2_flashparty2022

## Compile & Run

Requirements:
- [64tass] assembler

- `make run`


[64tass]: http://tass64.sourceforge.net/

## See it in action

[![video](https://img.youtube.com/vi/vCj45OX43JE/0.jpg)](https://www.youtube.com/watch?v=vCj45OX43JE)

## Authors

Dissasembly & patches: [riq][retro_moe] / [L.I.A][lia]

[retro_moe]: https://retro.moe
[lia]: https://lia.rebelion.digital
