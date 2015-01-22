# Makefile using less GNUisms

PRODUCT=@PRODUCT@
VERSION=@VERSION@
FONTS=@FONTS@
MAKE_VOLT_PARAMS=@MAKE_VOLT_PARAMS@
MAKE_GDL_PARAMS=@MAKE_GDL_PARAMS@
@FONT_VARS@

RELEASE_DIR=ttf-sil-$(PRODUCT)-$(VERSION)
CONFIG_FILE=@.CONFIG@
AUTOSUB=@AUTOSUB@
TEMPLATE_DIR=@TEMPLATE_DIR@
RM=@RM@
CP=@CP@

PKG_LIST=@foreach f,$(DOCS),doc/$(f),1@ @foreach f,$(EXTRA_DIST),$(f),nonl@

.PHONY: all exe dist clean dist-clean extra-clean
.SUFFIXES:

all :: @LICENSE@

@LICENSE@ : @$(index 0,$(FONTS))_TARGET@
	$(TEMPLATE_DIR)/bin/ttfgetname -t 13 @$(index 0,$(FONTS))_TARGET@ > $@
	cp $@ debian-src/LICENSE

debug : DEBUG=1

debug : all

@and $(or $(EXTRA_RULES),$(EXTRA_TARGETS),$(TEST_FILES)),$(ALL_template)@

temp :
	@@- mkdir $@@

@osslash $(foreach v,$(FONTS),$(PROGRAM_template))@

all :: @and $(which defoma-hints),debian-src/$(TARNAME).defoma-hints@

exe : $(PRODUCT)-$(VERSION).exe

$(PRODUCT)-$(VERSION).exe : all installer.nsi $(PKG_LIST)
	makensis -O$(PRODUCT)_nsi.log installer.nsi

installer.nsi : $(TEMPLATE_DIR)/templates/installer.nsi Makefile
	$(AUTOSUB)

dist : @TARNAME@-@VERSION@.tar.gz

@TARNAME@-@VERSION@.tar.gz : MANIFEST $(PKG_LIST) 
	@TARUP@

MANIFEST : $(TEMPLATE_DIR)/templates/MANIFEST Makefile
	$(AUTOSUB)

@and $(DEBARCH),$(DEBIAN_template)@

@and $(which defoma-hints),$(DEFOMA_template)@

dist-clean : clean extra-clean

clean :
	@@-$(RM) $(PRODUCT)_nsi.log gdlerr.txt
	@foreach v,$(FONTS),$(and $(or $($(v)_VTP),$($(v)_GDL)),$(.TAB)$(.AT)-$(RM) $($(v)_VTP) $($(v)_GDL))@

extra-clean :
	-$(RM) installer.nsi Makefile *.zip *.exe

Makefile : $(CONFIG_FILE) $(TEMPLATE_DIR)/system.cfg $(TEMPLATE_DIR)/templates/Makefile
	$(AUTOSUB)


