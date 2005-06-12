include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME=foo

foo_OBJC_FILES=foo.m

include $(GNUSTEP_MAKEFILES)/tool.make

test:
	./obj/foo
