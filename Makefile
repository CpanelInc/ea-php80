OBS_PROJECT := EA4
OBS_PACKAGE := ea-php80
DISABLE_BUILD := repository=CentOS_6.5_standard repository=xUbuntu_22.04 repository=Almalinux_10
include $(EATOOLS_BUILD_DIR)obs.mk
