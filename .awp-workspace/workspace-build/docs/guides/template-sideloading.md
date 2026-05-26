# Template Sideloading

Use this guide when another workspace repository wants to start from this template, adopt it later, or side load a newer template release and ask its local agent to adapt the repo in place.

## Two adoption paths
This template is intentionally used in two different ways:

- `Direct use`: a new workspace is created from the template and customized in place.
- `Sideload/adapt`: an existing workspace keeps its local state and incrementally adopts structure from a sideloaded template release.

The same workflow model supports both cases, but the expectations differ:
- direct-use workspaces should replace placeholders with real local paths quickly
- sideloaded workspaces may keep explicit external references while the local agent gradually reconciles the repo
- adaptation should preserve project-owned files and current work state unless a human asks for replacement

## Model

This template uses a sideload model, not a hard-sync model.

- New repos generate their starting files from a release bundle built from this repository.
- Existing repos side load a newer template release into a local inbox directory.
- The local agent compares the repo's current files to the sideloaded bundle and updates the repo in place.
- Live project state is adapted, not blindly overwritten.

The goal is to preserve project-specific context while still letting repos benefit from newer workflow structure, checks, and document formats.

## Traceability during adaptation
During sideload or federated adoption, do not invent fake local code/test paths just to satisfy the traceability matrix.

Prefer explicit references such as:
- `../<component>/src` when the consumer workspace keeps sibling local checkouts
- `repo:<component>@<ref>:<path>`
- `repo:<component>:<path>` when the ref is already pinned elsewhere, such as `workspace.manifest.yaml`
- `https://host/org/<component>/blob/<ref>/<path>` when a pinned URL is more useful than a local checkout reference

Direct-use workspaces should replace placeholder references with real repo-relative local paths once those paths exist.

## Canonical scaffold files

- `template-release.yaml`: release metadata and the default adaptation contract
- `upgrade-notes.md`: rolling release notes for humans and agents
- `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml`: consumer repo state file template
- `templates/sideload/WORKSPACE_TEMPLATE_LOCAL_OVERRIDES_TEMPLATE.md`: optional consumer-local override template
- `meta/templates/template-release-paths.txt`: paths included in the release bundle

## Release bundle contents

Build a release bundle with:

```bash
make template-package
```

Default output:

```text
/tmp/workspace-template-releases/workspace-template-<release-version>/
/tmp/workspace-template-releases/workspace-template-<release-version>.tar.gz
```

The bundle is the sideload payload a consumer repo can keep as reference input for its local agent.

## Consumer repo files

A consumer repo should typically keep:

- `.workspace-template-state.yaml`: current adopted version and sideload state
- `.workspace-template-inbox/<release-version>/`: unpacked sideload bundle
- `.workspace-template-local-overrides.md`: optional notes about intentional local deviations

Create the state and overrides files from the templates in this repo:

- `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml`
- `templates/sideload/WORKSPACE_TEMPLATE_LOCAL_OVERRIDES_TEMPLATE.md`

## File-handling model

The default contract in `template-release.yaml` divides files into three behaviors:

- `replace_reference_paths`: usually static framework docs/templates/checks that can be refreshed mostly as reference
- `adapt_in_place_paths`: live workflow files whose content should be migrated carefully in the consumer repo
- `preserve_local_paths`: project-owned files that should stay local unless a human explicitly decides otherwise

This contract is guidance for the local agent. It is not intended to be a blind overwrite rule.

## New repo flow

1. Build or download a release bundle from this template repo.
2. Generate the starting files for the new workspace repo from that bundle.
3. Copy `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml` to `.workspace-template-state.yaml`.
4. Set the adopted template version in that state file.
5. Customize project-owned files such as `README.md`, components, and project brief content.
6. Run `make docs-check`.

## Adopt an existing repo

1. Put the sideloaded release bundle in `.workspace-template-inbox/<release-version>/`.
2. Create `.workspace-template-state.yaml` if the repo does not already have one.
3. Ask the local agent to compare the current repo to the sideloaded bundle.
4. The agent should:
   - add missing canonical files
   - update static framework docs/checks where appropriate
   - adapt live workflow documents in place
   - convert placeholder traceability references into real local paths or explicit external references
   - preserve project-specific content unless the human asks for replacement
5. Record the new adopted version in `.workspace-template-state.yaml`.
6. Run `make docs-check`.

## Upgrade an existing repo

1. Sideload the newer release into `.workspace-template-inbox/<new-version>/`.
2. Keep the current adopted version in `.workspace-template-state.yaml`.
3. Run `make migrate-plan` against the bundle's upgrade-notes.md to identify which register migrations apply:
   ```bash
   make migrate-plan ARGS=.workspace-template-inbox/<new-version>/upgrade-notes.md
   ```
   This prints each register's current vs expected schema version and displays the relevant `schema_change` blocks in the order they must be applied.
4. Apply each listed migration to the live register `.yaml` files before changing anything else. After each migration, set `schema_version` in the register to the block's target version.
5. Run `make docs-check` to confirm the migrations are complete.
6. Run `make adapt-diff` to produce a structured diff of all adapt-in-place files:
   ```bash
   make adapt-diff BUNDLE=.workspace-template-inbox/<new-version>
   ```
   This lists which reference files will be replaced and shows unified diffs for every adapt-in-place file that changed. Give the output to the local agent as its starting point for the adaptation pass.
7. Ask the local agent to apply the adaptation using the diff output:
   - update adapt-in-place files using the diff as a guide, preserving local project state
   - replace reference files from the bundle
   - record any intentional deviations in `.workspace-template-local-overrides.md` if that file is in use
8. Re-run `make docs-check`.
9. Update `.workspace-template-state.yaml` to the new adopted version.

## Suggested local agent prompt

Use a prompt shaped like this in the consumer repo:

```text
Upgrade this repo to workspace-template release <new-version>.
The release bundle is in .workspace-template-inbox/<new-version>/.

1. Run: make migrate-plan ARGS=.workspace-template-inbox/<new-version>/upgrade-notes.md
   Apply every migration listed before touching anything else.
   After each migration, set schema_version in the register file to the block's target version.
   Run make docs-check to confirm migrations are complete.

2. Run: make adapt-diff BUNDLE=.workspace-template-inbox/<new-version>
   Use the output as your working diff. For each file shown:
   - replace_reference_paths: copy from bundle as-is
   - adapt_in_place_paths: apply the diff hunks that are safe; skip hunks that
     would overwrite local project state or intentional customisations

3. Record intentional deviations in .workspace-template-local-overrides.md if in use.

4. Run make docs-check and update .workspace-template-state.yaml to <new-version>.
```

## Recommended expectations

- Prefer explicit version tags for releases.
- Treat the sideload bundle as reference input for the local agent.
- Preserve current work state unless the human explicitly asks for a reset.
- Keep consumer-specific deviations written down so future upgrades stay understandable.
