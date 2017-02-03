###############################################################################
#
# Script file for building unit tests on PC. This script is universal for every
# PC test. Each tests contains conf.mk file containing test specific defines.
#
###############################################################################

all : \
template \

clean : \
clear_testlog \
template_clean \

###############################################################################
# Unity target

unity :
	@make -C unity -f conf.mk

unity_clean :
	@make -C unity -f conf.mk clean

#
###############################################################################

###############################################################################
# Template unit test target

template : unity
	@make -C template -f conf.mk

template_clean : unity_clean
	@make -C template -f conf.mk clean

#
###############################################################################

###############################################################################
# Unit test targets

#
###############################################################################

clear_testlog :
	@rm -rf test_results.txt

.PHONY: all clean
.PHONY: clear_testlog
.PHONY: unity unity_clean
.PHONY: template template_clean