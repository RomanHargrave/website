PARSER=render_page.rb
RUBY=ruby

YUI=java -jar ./bin/yuicompressor-2.4.8.jar 

HTMLC=java -jar ./bin/htmlcompressor-1.5.3.jar
HTMLCFLAGS=--compress-js --compress-css --simple-bool-attr

OUTPUT_DIR=public

RESOURCE_FILES=$(shell find src -type f -not -iname '*.haml')
INPUT_FILES=$(shell find src -type f -iname '*.haml')

RENDER_FILES=$(INPUT_FILES:src/%.haml=$(OUTPUT_DIR)/%.html)
RESOURCE_FILES_OUTPUT=$(RESOURCE_FILES:src/%=$(OUTPUT_DIR)/%)

.PHONY: all clean outputdir dist 

all: $(RENDER_FILES) $(RESOURCE_FILES_OUTPUT)

outputdir:
	mkdir -p $(OUTPUT_DIR)

# HAML => HTML 
# Will filter HTML with HTML compressor 
$(OUTPUT_DIR)/%.html: src/%.haml
	mkdir -p $(dir $@)
	$(RUBY) $(PARSER) $(@:$(OUTPUT_DIR)/%.html=src/%.haml) > $@
	$(HTMLC) $(HTMLCFLAGS) $@ -o $@

# Filter CSS with YUI 
$(OUTPUT_DIR)/%.css: src/%.css 
	mkdir -p $(dir $@)
	$(YUI) $(YUIFLAGS) $(@:$(OUTPUT_DIR)/%=src/%) -o $@

# Filter JS with YUI 
$(OUTPUT_DIR)/%.js: src/%.js
	mkdir -p $(dir $@)
	$(YUI) $(YUIFLAGS) $(@:$(OUTPUT_DIR)/%=src/%) -o $@

# Everything not handled above
$(OUTPUT_DIR)/%: src/%
	mkdir -p $(dir $@)
	cp $(@:$(OUTPUT_DIR)/%=src/%) $@

clean:
	$(RM) -r -f $(OUTPUT_DIR)

dist: all 
	tar cfJ dist.tar.xz $(shell find $(OUTPUT_DIR) -depth -type f)
