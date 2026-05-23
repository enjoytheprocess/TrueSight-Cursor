# AWP (AI Workspace Protocol) — planning workspace lives in .awp-workspace/
AWP_DIR := .awp-workspace

.PHONY: awp-init awp-render awp-docs-check awp-workflow-status awp-install-tools awp-install-hooks

awp-init:
	$(MAKE) -C $(AWP_DIR) init \
		WORKSPACE_INIT_YES=1 \
		PROJECT_NAME="TrueSight" \
		COMPONENT_NAME=backend \
		MODE=single

awp-render:
	$(MAKE) -C $(AWP_DIR) render

awp-docs-check:
	$(MAKE) -C $(AWP_DIR) docs-check

awp-workflow-status:
	$(MAKE) -C $(AWP_DIR) workflow-status

awp-install-tools:
	$(MAKE) -C $(AWP_DIR) install-tools

awp-install-hooks:
	@if [ -f .git/hooks/pre-commit ] && ! grep -q 'awp-pre-commit' .git/hooks/pre-commit 2>/dev/null; then \
		echo "ERROR: .git/hooks/pre-commit exists. Merge scripts/awp-pre-commit manually or remove the hook first." >&2; \
		exit 1; \
	fi
	cp scripts/awp-pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "Installed .git/hooks/pre-commit (AWP render + docs-check)."
