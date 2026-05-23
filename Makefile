# AWP (AI Workspace Protocol) — planning workspace lives in .awp-workspace/
AWP_DIR := .awp-workspace

.PHONY: awp-init awp-render awp-docs-check awp-workflow-status awp-install-tools

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
