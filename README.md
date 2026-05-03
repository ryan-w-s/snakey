# Snakey

Snakey is a small, neon-blue Snake game built in Godot. It keeps the classic loop intact: turn, eat, grow, speed up, and try not to fold yourself into a glowing little knot.

The game is designed around a tall phone screen first, with swipe controls, a clean portrait layout, and just enough arcade shine to make another run feel tempting.

## What Is Here

- A playable Snake clone built with Godot 4.6
- Portrait-first layout for mobile screens
- Swipe controls for touch, plus keyboard controls for desktop testing
- Neon board, snake, food, buttons, menus, and results screens
- Pause and resume flow
- Saved best score using Godot's `user://` storage

## Controls

On mobile, swipe in the direction you want the snake to turn.

On desktop, use:

- Arrow keys or `WASD` to move
- `Space` or `Esc` to pause and resume

## Running The Game

Open the project in Godot 4.6 or newer, then run the main scene:

```text
res://scenes/main.tscn
```

The project is configured for a 720x1280 viewport with mobile rendering enabled, so it should open already framed like a vertical phone game.

## Project Layout

```text
scenes/
  main.tscn              App shell and screen switching
  main_menu_screen.tscn  Start screen
  game_screen.tscn       Gameplay screen
  results_screen.tscn    Game over screen

scripts/
  main.gd                Navigation between screens
  snake_game.gd          Core Snake rules and input
  autoload/
    save_manager.gd      Best-score persistence
  components/
    grid_board.gd        Board drawing
    snake_renderer.gd    Snake and food drawing
    neon_button.gd       Shared button style
  screens/
    *_screen.gd          UI behavior for each screen
```

## Notes For Development

Most of the game is drawn and laid out in GDScript rather than relying on a large asset pipeline. That keeps the project light and easy to tweak: colors, board size, speed, scoring, and touch sensitivity are exposed as exported values where it makes sense.

The current target is a simple, satisfying mobile release. If you are extending it, the best next improvements are probably sound effects, haptics, visual polish when eating food, and export presets for Android or iOS.

## License

MIT. See [LICENSE](LICENSE) for the full text.
