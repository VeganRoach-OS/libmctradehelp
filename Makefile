LIB=libmctradehelp.so
PREFIX=/usr/local

SDIR=src
ODIR=bin
LDIR=lib

SRCS=$(shell ls $(SDIR)/*.vala)
LPATH=$(ODIR)/$(LIB)

all: library

install: all
	install -D -m755 $(LPATH) $(DESTDIR)$(PREFIX)/lib/$(LIB)

library: $(SRCS)
	mkdir -p $(ODIR)
	valac -o $(LPATH) $(SRCS)

clean:
	rm -rf $(ODIR)
