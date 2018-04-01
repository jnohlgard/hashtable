# Build test
BINDIR = bin
OBJDIR = obj
SRCDIR = src
INCLUDEDIRS = include
MAINEXE = $(notdir $(CURDIR))
ELFS = $(BINDIR)/$(MAINEXE)

OBJS_$(MAINEXE) = $(MAINEXE).o

QUIET?=1
LINK ?= $(CC)

.PHONY: all
all: $(ELFS)

LDPREFIX = -Wl,

LINKFLAGS += $(LDPREFIX)--gc-sections

CFLAGS += -g3 -ggdb -O2 -fno-common -ffunction-sections -fdata-sections
CFLAGS += -Wall -Wextra -Wpedantic -Werror -Wno-error=pedantic -MD -MP
CPPFLAGS += $(addprefix -I,$(INCLUDEDIRS))

include $(wildcard $(OBJDIR)/*.d)

%.c : $(CURDIR)/Makefile

PRINTF = printf
PRINT = $(PRINTF) %s

ifeq (1,$(QUIET))
  ECHOCMD = @$(PRINTF) '  [%s]    \t%s\n'
  Q = @
else
  ECHOCMD = @true
  Q =
endif

$(OBJDIR) $(BINDIR):
	$(ECHOCMD) MKDIR '$@'
	$(Q)mkdir -p '$@'

$(OBJDIR)/%.o : $(SRCDIR)/%.c | $(OBJDIR)
	$(ECHOCMD) CC '$<'
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c -o '$@' $<

$(BINDIR)/% : $(OBJDIR)/%.o | $(BINDIR)
	$(ECHOCMD) LINK '$@'
	$(Q)$(LINK) $(LINKFLAGS) -o '$@' $<

.PHONY: clean
clean:
	$(RM) -r $(OBJDIR)/*.o $(OBJDIR)/*.d
	-rmdir $(OBJDIR) 2>/dev/null
	$(RM) $(ELFS)
	-rmdir $(BINDIR) 2>/dev/null
