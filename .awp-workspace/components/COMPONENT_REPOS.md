# Component Repositories

Use this file in federated multi-repo mode as the human-readable index.
For executable/pinned orchestration, use `workspace.manifest.yaml`.

These rows are planning-only federated examples.
The template does not ship these repos checked out by default.

| Component | Repository URL | Default Branch | Local Path (optional) | Verify Command |
| --- | --- | --- | --- | --- |
| example-api | git@example.com/org/example-api.git | main | components/example-api | npm test |
| example-web | git@example.com/org/example-web.git | main | components/example-web | npm test |
| example-planning-docs | git@example.com/org/example-planning-docs.git | main | components/example-planning-docs | skip: docs-only |

You can also record sibling local checkouts here, such as `../example-api`, when that matches how the workspace is arranged.
