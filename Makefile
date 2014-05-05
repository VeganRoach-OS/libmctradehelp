LIB=libmctradehelp.so
H=mctradehelp.h
VAPI=mctradehelp
PREFIX=/usr/local

SDIR=src
ODIR=bin
IDIR=include
LDIR=lib

SRCS=$(shell ls $(SDIR)/*.vala)
IPATH=$(IDIR)/$(H)
LPATH=$(ODIR)/$(LIB)

all: library

install: all
	install -D -m755 $(LPATH) $(DESTDIR)$(PREFIX)/lib/$(LIB)
	install -D -m755 $(IPATH) $(DESTDIR)$(PREFIX)/include/$(LIB)

library: $(SRCS)
	mkdir -p $(ODIR)
	mkdir -p $(IDIR)
	valac --library=$(VAPI) -H $(IPATH) $(SRCS) -X -fPIC -X -shared -o $(LPATH)

clean:
	rm -rf $(ODIR)
	rm -rf $(IDIR)
	rm -rf $(VAPI).vapi
