include Makefile.in

MANUAL_IMAGES = $(wildcard .manual/*.jpg) $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))
DOCS = $(MARKDOWN_HTML) $(MANUAL_IMAGES)

MINUTEMAN_STL = Receiver/Frame_Receiver.stl $(wildcard Receiver/Components/*.stl) \
							$(wildcard Receiver/Stock*.stl) $(wildcard Receiver/Lower/*.stl) \
							$(wildcard Receiver/FCG*.stl)

FOREND_STL = $(wildcard Receiver/Forend/*_*/*.stl)

STL := $(MINUTEMAN_STL) $(FOREND_STL)
EXTRA_DOCS := changelog.txt Manual.pdf
DIST := $(DOCS) $(EXTRA_DOCS) $(STL)

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
	
Manual.pdf: $(DOCS) Version.md $(MARKDOWN_HTML) FORCE
	htmldoc --batch Manual.book

Liberator12k.zip: $(DIST) FORCE
	zip -r Liberator12k.zip $(DIST)
	
dist: $(SUBDIRS)
	$(MAKE) Liberator12k.zip

clean-dir:
	rm -rf $(DOCS) Liberator12k.zip

all: $(SUBDIRS) dist
.PHONY: STL MARKDOWN_HTML dist