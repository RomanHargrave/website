PARSER=render_page.rb
RUBY=ruby

OUTPUT_DIR=public

RESOURCE_FILES=$(shell find src -type f -not -iname '*.haml')
INPUT_FILES=$(shell find src -type f -iname '*.haml')

RENDER_FILES=$(INPUT_FILES:src/%.haml=$(OUTPUT_DIR)/%.html)
RESOURCE_FILES_OUTPUT=$(RESOURCE_FILES:src/%=$(OUTPUT_DIR)/%)

.PHONY: all clean outputdir

all: $(RENDER_FILES) $(RESOURCE_FILES_OUTPUT)

outputdir:
	mkdir -p $(OUTPUT_DIR)

# HAML => HTML 
$(OUTPUT_DIR)/%.html: src/%.haml
	mkdir -p $(dir $@)
	$(RUBY) $(PARSER) $(@:$(OUTPUT_DIR)/%.html=src/%.haml) > $@

# Everything not handled by the haml rule, e.g. resources
$(OUTPUT_DIR)/%: src/%
	mkdir -p $(dir $@)
	cp $(@:$(OUTPUT_DIR)/%=src/%) $@

clean:
	$(RM) -r -f $(OUTPUT_DIR)
