# 3D-printed parts

OpenSCAD source and ready-to-print STLs for the electronics sleeve, the heater
catwalk and the two struts. Everything else (the clear tub, the three electronics
tiers that slide into the sleeve) is up to you.

| File | Qty | Size (mm) | Notes |
|---|---|---|---|
| `box.scad` / `box.stl` | 1 | 123 x 101 x 31 | Open-ended sleeve that swallows the 3-tier electronics stack (97 x 75 mm). Lip end has 4 x 3.8 mm holes to bolt it to the tub wall. Print standing on the plain end, lip up, no supports. |
| `catwalk.scad` / `catwalk.stl` | 1 | 115 x 180 x 9 | Arm that carries the heatsink and fan out over the spools. Bolts to the sleeve's plain end. Print flat. |
| `strut.scad` / `strut.stl` | 2 | 192 x 14 x 5 | Diagonal brace from the sleeve standoffs to the catwalk eyelets. Ladder of holes at the catwalk end so you can set the angle. Print flat. |

- Designed for a 200 x 148 mm bed (FlashForge Creator Pro 2). Everything lies flat; no supports.
- PETG or ABS is better than PLA near the heater. PLA is fine for the sleeve and struts.
- 4 walls, 30-40 % infill, 0.2 mm layers.
- Heatsink mounting holes on the catwalk are oversized (6 mm) to suit a range of
  60 x 60 mm finned heatsinks. Check yours before printing.
- Edit the `tier3_x` / `tier3_y` / `depth` values at the top of `box.scad` if your
  electronics stack is a different size.
