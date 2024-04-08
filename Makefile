ROOT := https://docs.shadeform.ai/_next/data/lGoa5qT0DdFTjCGoccXMo
START := api-reference/endpoint/instances

openapi.json:
	META="$$(curl "$(ROOT)/$(START)".json)"; \
	PAGES="$$(echo "$$META"| jq -r '.pageProps.mdxSource.scope.mintConfig.navigation[] | select(.group == "Endpoints") | .pages[]')"; \
	OPENAPI="$$(echo "$$META"| jq -r .pageProps.pageData.apiReferenceData.metadata.spec)"; \
	jq .paths="$$((for p in $$PAGES; do \
		curl "$(ROOT)/$$p.json" | jq -r .pageProps.pageData.apiReferenceData.metadata.spec.paths; done \
	) | jq -s add)" <(echo "$$OPENAPI") | jq '.components.schemas.DeletedAt.nullable = true'> $@
