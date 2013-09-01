MOD_NAME = responsive-section-layout

## DOCS
DOCS_TMPL_DIR = docs-tmpl
MOCHA_MD_DOCS = README_responsive-section-layout.md

## Build
BUILD_DIR = build
BUILD_COMPILED_CSS = $(BUILD_DIR)/$(MOD_NAME).css
BUILD_COMPILED_CSS_MIN = $(BUILD_COMPILED_CSS:.css=.min.css)

## install
COMPONENTJS_CMD = @component build --out $(@D) --name $(basename $(@F))

######################################
# Release
######################################
publish: build docs

docs: build
	@grunt build
	@make clean-readme

######################################
# Servers
######################################
server: build-quick
	@serve build
	@echo go to http://localhost:3000

######################################
# Build
######################################
build: clean components npm-install-dev $(BUILD_COMPILED_CSS_MIN)
build-quick: clean-build $(BUILD_COMPILED_CSS_MIN)

$(BUILD_COMPILED_CSS_MIN): $(BUILD_COMPILED_CSS)
	@yuicompressor $< -o $@

$(BUILD_COMPILED_CSS):
	$(COMPONENTJS_CMD) $(MOD_NAME)

############## packages ################
components: component.json
	@component install --dev

######################################
# Docs
# run grunt readme
######################################
readme: readme-responsive-section-layout
	@grunt readme-concat

readme-responsive-section-layout:
	@[ -d $(DOCS_TMPL_DIR) ] || mkdir $(DOCS_TMPL_DIR)
	@echo '' >> $(DOCS_TMPL_DIR)/$(MOCHA_MD_DOCS)
	@echo '## License' >> $(DOCS_TMPL_DIR)/$(MOCHA_MD_DOCS)

######################################
# Housekeeping
######################################
size: build
	@echo "$(BUILD_COMPILED): `wc -c $(BUILD_COMPILED) | sed 's/ .*//'`"
	@echo "$(BUILD_COMPILED_MIN): `gzip -c $(BUILD_COMPILED_MIN) | wc -c`"

clean: clean-readme clean-build
	@rm -f *.log*
	@rm -rf components

clean-build:
	@rm -rf build $(PUBLIC_DIR)/build.* $(TMPL_DIR)/*.js

clean-readme:
	@find $(DOCS_TMPL_DIR) -maxdepth 1 -type f ! -iname '*.tmpl' -delete

.PHONY: readme clean clean-* npm-install-dev release test test-* size server *-quick