# AGENTS.md

## Scope and priorities

- These instructions apply to this directory and its descendants. A more deeply nested `AGENTS.md` may add or override instructions for its subtree.
- Follow explicit user requirements first. Preserve existing behavior unless the task calls for a change.
- Keep this file concise and current. Prefer repository-owned scripts and documentation over duplicating long instructions here.

## Project context

- Project: **WebWatch**
- Detected stack: **Haiku C++17 BApplication + Replicant + Deskbar add-on**
- No standard build manifest was detected; inspect the repository before choosing commands.
- Before editing, read `README.md`, relevant manifests, nearby tests, and the code being changed.
- Match the surrounding architecture and conventions. Do not introduce a new framework, dependency, or abstraction without a concrete need.

## Safe working practices

- Inspect repository status before changing files. Treat existing uncommitted work as user-owned and do not discard or overwrite it.
- Make the smallest coherent change that solves the request. Avoid unrelated formatting, renames, or cleanup.
- Never edit generated files, vendored dependencies, lockfiles, migrations, or snapshots by hand unless the repository explicitly requires it.
- Do not expose secrets. Never commit credentials, tokens, private keys, local environment files, or production data.
- Ask before destructive or irreversible actions, dependency upgrades with broad impact, data migrations, publishing, deployment, or changing public APIs.

## Build and test

- `Use the repository's documented Haiku build command.`
- `Run the repository's documented tests on Haiku.`
- Run the narrowest relevant test while iterating, then the full applicable suite before completion.
- Add or update tests for changed behavior, including failure paths and boundary cases. Do not weaken tests just to make them pass.
- Prefer one repository-owned validation or release script for repeatable workflows. Put applicable builds, tests, screenshots, site generation, packaging, checksums, and uploads behind that entry point instead of performing each step manually; publishing still requires explicit approval.
- Report commands actually run and any checks that could not be run. Do not claim success without evidence.

## Coding style

- Use C++17 and the Haiku Interface Kit conventions already established by the project.
- Keep return types, qualified function names, parameter lists, and opening braces on the same line.
- Prefer RAII, standard-library ownership types, `nullptr`, and explicit handling of Haiku `status_t` failures.
- Whenever a translation unit uses or instantiates `app_info`, include `<Roster.h>` explicitly; `<Application.h>` provides only an incomplete declaration.
- Preserve the `BApplication` and window lifetime, message-routing, and UI-thread model.
- Preserve Replicant archiving and re-instantiation contracts, including `Archive`, static `Instantiate`, signatures, and `BDragger` behaviour.
- Preserve `BDeskbarView` archive, instantiation, shelf, and removal lifecycle behaviour.
- Use K&R braces: keep the function declaration and opening brace on the same line.
- Put `//---------------------------------------------------------------------------------------------------------------------------------//` immediately after every function's closing brace, followed by two blank lines.

C++ formatting example:

```cpp
bool MyWindow::MyFunction() {
    return true;
}
//---------------------------------------------------------------------------------------------------------------------------------//
```

- Use Australian English for variables and other names ie. colour, flavour but use color for conventions.
- Favour clear names, small focused units, explicit error handling and simple control flow over cleverness.
- Preserve compatibility with the versions declared by the project. Avoid speculative abstractions and premature optimization.
- Comments should explain intent, constraints, or non-obvious tradeoffs—not restate the code.
- Public behaviour and APIs should be documented. Update user-facing documentation when behaviour, configuration, or commands change.

## Dependencies and generated artifacts

- Prefer the standard library and existing dependencies. Add a dependency only when its benefit outweighs maintenance, security, size, and licensing costs.
- Use the ecosystem's package manager; do not manually copy third-party source into the repository.
- Regenerate derived artifacts with their documented tool and include source changes alongside generated output when the repository tracks both.
- Keep dependency lockfiles when this repository treats them as reproducibility inputs; update them only through the package manager.

## Versioning and releases

- Use a canonical decimal version with one decimal point. Prefix human-facing versions and release tags with a lowercase `v`: use `v0.4`, not `v0.4.0`, and `v0.41`, not `v0.4.1` or `v0.40`.
- Advance a normal change or fix by `0.01`; advance a major feature phase to the next tenth. Place patch digits immediately after the minor digit rather than adding another dot.
- Keep the same canonical numeric version in the authoritative version file, application metadata, CLI output, package recipes and filenames, release tags, and documentation.
- Treat released versions and published artifacts as immutable. Do **not** delete or replace a previous package to reuse its version; publish a new version instead.
- Deprecate before removing public APIs when practical. Document migrations and breaking changes.
- Update the changelog when one exists and keep release notes focused on user-visible changes.
- Do not tag, publish, deploy, or push a release unless the user explicitly requests it and the required checks pass.



## Git and review

- Keep commits focused and describe the reason for the change. Do not rewrite history or force-push unless explicitly requested.
- Review the final diff for accidental changes, debug output, secrets, platform-specific paths, and missing tests or documentation.
- In the final handoff, summarize what changed, why, validation performed, and any remaining risks or follow-up work.
