# The following tools are used by this file.
# All are assumed to be on the path, but you can override these
# in the environment, or command line.

# xml2rfc (when running locally, this is installed in a virtualenv for you)
XML2RFC_RFC_BASE_URL := https://www.rfc-editor.org/rfc/
XML2RFC_ID_BASE_URL := https://datatracker.ietf.org/doc/html/
XML2RFC_CSS := $(LIBDIR)/v3.css
xml2rfcargs := -q -s 'Setting consensus="true" for IETF STD document' \
	       --rfc-base-url $(XML2RFC_RFC_BASE_URL) --id-base-url $(XML2RFC_ID_BASE_URL)

# If you are using markdown files use either kramdown-rfc or mmark
#   https://github.com/cabo/kramdown-rfc
# (when running locally, kramdown-rfc is installed for you)
kramdown-rfc ?= kramdown-rfc
# Tell kramdown not to generate targets on references so the above takes effect.
export KRAMDOWN_NO_TARGETS := true
export KRAMDOWN_PERSISTENT := true

#  mmark (https://github.com/mmarkdown/mmark)
mmark ?= mmark

# If you are using outline files:
#   https://github.com/Juniper/libslax/tree/master/doc/oxtradoc
oxtradoc ?= oxtradoc.in

# When using rfc2629.xslt extensions:
#   https://greenbytes.de/tech/webdav/rfc2629xslt.html
xsltproc ?= xsltproc

# For sanity checkout your draft:
#   https://www.ietf.org/tools/idnits
idnits ?= idnits

# For diff:
#   https://github.com/ietf-tools/iddiff
iddiff ?= iddiff -c 8

# For generating PDF:
#   https://www.gnu.org/software/enscript/
enscript ?= enscript
#   http://www.ghostscript.com/
ps2pdf ?= ps2pdf

# Where to get references
XML_RESOURCE_ORG_PREFIX ?= https://xml2rfc.tools.ietf.org/public/rfc

# This is for people running macs
SHELL := bash

# For uploading draft "releases" to the datatracker.
curl ?= curl -sS
DATATRACKER_UPLOAD_URL ?= https://datatracker.ietf.org/api/submit

# The type of index that is created for gh-pages.
# Supported options are 'html' and 'md'.
INDEX_FORMAT ?= html

# For spellchecking: pip install --user codespell
codespell ?= codespell

# Tracing tool
trace := $(LIBDIR)/trace.sh

# Where versioned copies are stored.
VERSIONED ?= versioned

# Setup a shared cache for xml2rfc and kramdown-rfc
ifeq (,$(KRAMDOWN_REFCACHEDIR))
ifeq (true,$(CI))
XML2RFC_REFCACHEDIR := $(realpath .)/.refcache
else
XML2RFC_REFCACHEDIR ?= $(HOME)/.cache/xml2rfc
endif
KRAMDOWN_REFCACHEDIR := $(XML2RFC_REFCACHEDIR)
else
XML2RFC_REFCACHEDIR ?= $(KRAMDOWN_REFCACHEDIR)
endif
xml2rfcargs += --cache=$(XML2RFC_REFCACHEDIR)
ifneq (,$(shell mkdir -p -v $(KRAMDOWN_REFCACHEDIR)))
$(info Created cache directory at $(KRAMDOWN_REFCACHEDIR))
endif
export KRAMDOWN_REFCACHEDIR
