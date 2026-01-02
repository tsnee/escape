# Repository Guidelines

## Project Structure & Module Organization
- `src/`: PureScript source code. Entry point is `src/CanvasApp.purs`; gameplay logic lives in `src/GameLogic.purs` with supporting modules under `src/Components/` and `src/Data/`.
- `test/`: PureScript tests. Current test entry is `test/Test/Main.purs`.
- `index.html` and `index.css`: Canvas host page and styles used by the Vite dev server.
- `index.js` and `output/`: generated build artifacts from Spago/Vite; do not edit by hand.
- `spago.yaml` and `spago.lock`: PureScript package configuration; `package.json` holds Vite scripts.

## Build, Test, and Development Commands
- `npm install`: install Node tooling (Vite).
- `npm run dev`: start the Vite dev server for local iteration on the canvas app.
- `spago build`: compile PureScript to `output/` for quick compile checks.
- `spago test`: run the PureScript test suite defined in `test/`.
- `npm run build`: production build; runs `spago bundle` and then `vite build` to emit bundled assets.

## Coding Style & Naming Conventions
- PureScript files use two-space indentation and standard module layout.
- Module names mirror paths (e.g., `src/Data/World.purs` defines `Data.World`).
- Keep imports grouped and explicit; remove unused imports when editing.
- Treat `index.js` as generated output from Spago; edit the `.purs` sources instead.

## Testing Guidelines
- Tests live under `test/` and follow the `Test.*` module naming pattern.
- Prefer small, focused tests for game logic or data transformations.
- Run `spago test` before submitting changes; no coverage targets are enforced yet.

## Commit & Pull Request Guidelines
- The repository has minimal commit history and no formal convention; use a short, descriptive summary line (sentence case is fine) and add a body for non-trivial changes.
- PRs should include: a concise description, notes on testing (commands and results), and screenshots or GIFs for visible canvas/UI changes.
- Link related issues if applicable and call out follow-up work or known limitations.
