# Hunter's Rise — Monster Hunter Rise VR Mod

## Goals
1. First person, feels like a native VR game, 6DOF motion controls.
2. Custom combat: swing speed drives a damage multiplier scaled by weapon weight.
3. Built stepwise — each phase is tested and confirmed before the next begins.

## Environment
- Game: Monster Hunter Rise + Sunbreak (Steam)
  `C:\Program Files (x86)\Steam\steamapps\common\MonsterHunterRise`
- Headset: Meta Quest 3 via Virtual Desktop, **VDXR** (OpenXR runtime)
- Play solo/offline while modded.

## Architecture
- **REFramework** (praydog) provides injection, the VR renderer (OpenXR/OpenVR), a Lua scripting API with hot reload, and an object explorer / type dump for finding game classes.
- Mod logic lives in this repo as Lua scripts, deployed to the game's `reframework/autorun/` by a deploy script.
- Performance-critical parts (combat physics) may move to a C++ REFramework plugin later if Lua is too slow.

## Phases

| # | Phase | Test gate (you confirm) |
|---|-------|-------------------------|
| 0 | **Setup** — git, deploy script, back up the game's root files, install REFramework (MHRise build). | Game launches, REFramework menu opens with Insert, no crashes in town or on a hunt. |
| 1 | **VR baseline** — enable REFramework VR via OpenXR/VDXR; disable motion blur, film grain, and problematic anti-aliasing. | Stereo 3D in headset, head tracking works, acceptable framerate. Camera still third-person. |
| 2 | **First-person camera** — attach camera to the head bone, hide head/hair meshes, safe fallbacks for menus/cutscenes/wirebug. | You stand inside the hunter's head; walking, menus, and cutscenes all work. |
| 3 | **Locomotion and input** — stick movement relative to head direction, snap/smooth turn, button mapping (items, dodge, wirebug, menus). | Play a basic hunt without a gamepad. |
| 4 | **Hand tracking (debug)** — draw controller positions in-world as debug shapes; line up game space with the real room. | Debug shapes match your real hands. |
| 5 | **Hands and weapon on controllers** — IK override of hand/arm bones each frame; weapon attached to hand; two-hand grip for heavy weapons. | Hunter's hands are your hands; weapon follows your swings. |
| 6 | **Combat research (read-only)** — find the game's damage code and monster hit areas; log every hit the normal game deals. | A log shows monster, part, and damage per hit. |
| 7 | **Physical hits** — sweep the blade each frame against monster hit areas; on overlap, deal damage through the game's own damage code. | Swinging into a monster registers a hit with no animation needed. |
| 8 | **Swing speed × weight damage** — tip velocity from controller history; `damage = base × speedCurve(v) × weightFactor`; minimum speed, cap, weight-based swing lag; values in an editable config. | Slow taps barely hurt, full swings hit hard, heavy weapons feel heavy. |
| 9 | **Polish** — hit haptics, sharpness and bounce feedback, hunt menu floating in the world, comfort options. | General playtesting. |

## Main risks
- **Phase 1:** VR support in MH Rise may be incomplete (shadows, UI). Shows up early, before other work.
- **Phase 5:** fighting the game's animation system for control of arm bones.
- **Phases 6–7:** the game's combat is driven by animations. Free physical hits require calling the game's damage code ourselves. Fallback: a hybrid where a physical swing triggers a native attack with scaled damage.

## Tooling
- `tools\install-reframework.ps1 [-VR]`: installs REFramework stable v1.5.9.1 (MHRISE build, revision 5bae470). Without `-VR`: `dinput8.dll` only. With `-VR`: also `openxr_loader.dll`. `openvr_api.dll` is never installed, so REFramework uses OpenXR (VDXR).
- `tools\deploy.ps1`: copies `mod\autorun\hunters_rise*` into the game's `reframework\autorun\`.
- `tools\uninstall.ps1 [-All]`: back to vanilla.
- `vendor\` (not in git): downloaded REFramework builds. Stable v1.5.9.1 is in use; nightly-01438 is kept as a fallback.

## Status
- [ ] **Phase 0 — Setup** (scaffolding done; waiting on install and test)
  1. Run `.\tools\install-reframework.ps1`
  2. Launch MH Rise from Steam. The first launch may be slow while REFramework builds its cache.
  3. Insert opens the REFramework menu.
  4. Load into Kamura or Elgado, walk around, then start and finish a quick quest.
  5. If anything fails, send me `re2_framework_log.txt` from the game folder.
