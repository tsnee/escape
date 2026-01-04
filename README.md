# Escape From 4th West

Early-stage roguelike prototype rendered on an HTML5 canvas.

## Development Stack
- PureScript for game logic and rendering.
- Spago for PureScript builds and bundling.
- Vite for local development and production builds.
- HTML/CSS for the host page and layout.

## Getting Started
- `npm install`
- `npm run dev`

## Build and Test
- `spago build` compiles PureScript sources to `output/`.
- `spago test` runs the PureScript test suite.
- `npm run build` bundles the app via `spago bundle` and `vite build`.

## Project Layout
- `src/` PureScript source files.
- `test/` PureScript tests.
- `index.html` and `index.css` host the canvas app.

## License
This project is dedicated to the public domain under CC0 1.0.
