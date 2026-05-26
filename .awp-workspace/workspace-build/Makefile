SHELL := /usr/bin/env bash

MANIFEST ?= workspace.manifest.yaml
TEMPLATE_RELEASE_OUT ?= /tmp/workspace-template-releases

.PHONY: install-tools install-hooks init init-smoke render diagram manifest-lint sync status verify ci-verify docs-boundary docs-check canonicality queue-columns readiness-columns ready-queue roadmap-check dependency-check locks-check release-queue-check component-docs drift-check specialist-check row-alignment schema-version-check gd-archiving-check sync-skip-check migrate-plan adapt-diff template-package workflow-status

init:
	./scripts/init-workspace.sh
	./scripts/render-registers.sh

render:
	./scripts/render-registers.sh

manifest-lint:
	./scripts/manifest-lint.sh "$(MANIFEST)"

sync: manifest-lint
	./scripts/sync-components.sh "$(MANIFEST)"

status: manifest-lint
	./scripts/status-components.sh "$(MANIFEST)"

workflow-status:
	./scripts/workspace-status.sh

verify: manifest-lint
	./scripts/verify-components.sh "$(MANIFEST)"

ci-verify: manifest-lint
	./scripts/sync-components.sh "$(MANIFEST)"
	./scripts/verify-components.sh "$(MANIFEST)"
	./scripts/status-components.sh "$(MANIFEST)"

docs-boundary:
	./scripts/check-docs-boundary.sh

canonicality:
	./meta/checks/check-canonicality.sh

queue-columns:
	./meta/checks/check-work-queue-columns.sh

readiness-columns:
	./meta/checks/check-task-readiness-columns.sh

ready-queue:
	./meta/checks/check-ready-queue-admission.sh

roadmap-check:
	./meta/checks/check-roadmap-columns.sh

dependency-check:
	./meta/checks/check-task-dependencies.sh

locks-check:
	./meta/checks/check-locks.sh

release-queue-check:
	./meta/checks/check-release-queue-columns.sh

component-docs:
	./meta/checks/check-component-doc-contract.sh

drift-check:
	./meta/checks/check-doc-code-drift.sh

specialist-check:
	./meta/checks/check-specialist-gates.sh

gd-archiving-check:
	./meta/checks/check-gaps-deviations-archiving.sh

sync-skip-check:
	./meta/checks/check-sync-skip.sh

install-tools:
	./scripts/install-tools.sh

diagram:
	dot -Tsvg docs/diagrams/tiered-adoption.dot -o docs/diagrams/tiered-adoption.svg

install-hooks:
	@if [ -f .git/hooks/pre-commit ]; then \
		echo "ERROR: .git/hooks/pre-commit already exists. Remove it first or merge manually." >&2; \
		exit 1; \
	fi
	cp templates/hooks/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "pre-commit hook installed."

schema-version-check:
	./meta/checks/check-register-schema-versions.sh

migrate-plan:
	./scripts/migrate-plan.sh $(ARGS)

adapt-diff:
	./scripts/adapt-diff.sh $(BUNDLE)

docs-check: canonicality queue-columns readiness-columns ready-queue roadmap-check dependency-check locks-check release-queue-check component-docs drift-check specialist-check gd-archiving-check sync-skip-check schema-version-check

init-smoke:
	./meta/checks/check-init-workspace-smoke.sh

template-package:
	./scripts/package-template-release.sh "$(TEMPLATE_RELEASE_OUT)"
