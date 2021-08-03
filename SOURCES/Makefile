SRCDIR := $(shell pwd)
NAME := $(shell basename $(SRCDIR))
include ../../common/Makefile

srpm:
	rpmbuild $(RPMDEFINES) $(SRCDEFINES) --define 'scl php80' -bs $(NAME).spec
