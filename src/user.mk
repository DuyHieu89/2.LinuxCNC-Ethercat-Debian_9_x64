include ../config.mk
include Kbuild

EXTRA_CFLAGS := $(filter-out -Wframe-larger-than=%,$(EXTRA_CFLAGS))

LCEC_CONF_OBJS = \
	lcec_conf.o \
	lcec_conf_util.o \
	lcec_conf_icmds.o \
	$(lcec-common-objs)

.PHONY: all clean install

all: lcec_conf

install: lcec_conf
	mkdir -p $(DESTDIR)$(EMC2_HOME)/bin
	cp lcec_conf $(DESTDIR)$(EMC2_HOME)/bin/

lcec_conf: $(LCEC_CONF_OBJS)
	$(CC) -o $@ $(LCEC_CONF_OBJS) -Wl,-rpath,$(LIBDIR) -L$(LIBDIR) -llinuxcnchal -lexpat -Wl,--whole-archive ./devices/liblcecdevices.a -Wl,--no-whole-archive -lethercat -lm

%.o: %.c
	$(CC) -o $@ $(EXTRA_CFLAGS) -URTAPI -U__MODULE__ -DULAPI -Os -c $<

