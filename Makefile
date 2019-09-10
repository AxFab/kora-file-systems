#
#  Copyright (C) 2018  <Fabien Bavent>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#  This makefile is more or less generic.
#  The configuration is on `sources.mk`.
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
topdir ?= $(shell readlink -f $(dir $(word 1,$(MAKEFILE_LIST))))
gendir ?= $(shell pwd)

include $(topdir)/var/make/global.mk

all: drivers libs bins

install: install-all

CFLAGS += -Wall -Wextra -fPIC
CFLAGS += -Wno-unused-parameter
ifeq ($(target_os),kora)
CFLAGS += -Dmain=_main
endif

CFLAGS += -ggdb

LFLAGS += -lc

include $(topdir)/var/make/build.mk
include $(topdir)/var/make/drivers.mk

DRV = vfat ext2 isofs

include $(foreach dir,$(DRV),$(topdir)/$(dir)/Makefile)

drivers: $(DRVS)
libs: $(LIBS)
bins: $(BINS)
install-all: $(patsubst %,install-%,$(DRVS) $(LIBS) $(BINS))


ifeq ($(NODEPS),)
-include $(call fn_deps,SRCS)
endif

