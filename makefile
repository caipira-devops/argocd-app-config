# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

create-cluster: ## Create a local cluster with kind
	kind create cluster --name argocd --config ./kind/kind-ingress.yml
	kubectl apply -f nginx-ingress/nginx-ingress-deployment.yaml
	kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.0/manifests/install.yaml	
	kubectl apply -n argocd -f ingress.yaml

cli-admin-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

destroy: 
	kind delete cluster --name argocd


