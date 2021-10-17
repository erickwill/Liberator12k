include Makefile.in

MANUAL_IMAGES = $(wildcard .manual/*.jpg) $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))

Assembly = Receiver/Assembly Receiver/Forend/Assembly
Components = Frame Receiver Stock Lower FCG

MINUTEMAN_STL = $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Prints/*.stl))

ForendPreset_STLS = $(wildcard Receiver/Forend/*_*/Prints/*.stl) \
                    $(wildcard Receiver/Forend/*_*/Projection/*.svg) \

STL := $(MINUTEMAN_STL) $(ForendPreset_STLS)
EXTRA_DOCS := changelog.txt Manual.pdf
TARGETS := $(Assembly) $(EXTRA_DOCS) Source/

MARKDOWN_HTML: $(MARKDOWN_HTML)
$(MARKDOWN_HTML): $(addsuffix .md, $(basename $@))

changelog.txt:
	git log --oneline > changelog.txt

Version.md:
	@echo "---" > $@ && \
	echo "title: #Liberator12k Manual" >> $@ && \
	echo "author: Jeff Rodriguez" >> $@ && \
	echo "copyright: Unlicensed" >> $@ && \
	echo "version: $(GIT_VERSION)" >> $@ && \
	echo "language: en-US" >> $@ && \
	echo "subject: How-To" >> $@ && \
	echo "---" >> $@
	
Manual.pdf: Version.md $(MARKDOWN_HTML) $(MANUAL_IMAGES) FORCE
	htmldoc --batch Manual.book

Source/:
	rm -rf $@ && \
	git init $@ && \
	cd $@ && \
	git pull ../ --depth=1 && \
	git remote add origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(TARGETS) FORCE
	zip -r $@ $(TARGETS) $(STL)
	
dist: FORCE $(SUBDIRS)
	$(MAKE) Liberator12k.zip

clean-dir:
	rm -rf $(MARKDOWN_HTML) $(TARGETS) Liberator12k.zip Version.md changelog.txt

all: $(SUBDIRS) dist
.PHONY: STL MARKDOWN_HTML dist Assembly