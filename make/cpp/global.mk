
include project.mk

include $(VIMPER_HOME)/make/$(PROJECT_TYPE)/macros.mk

# ----------------------Include Sub directories to be build-------------------#
# Auto Generated setion please do not edit. If incorrectly edited can cause the
# project configurations to be corrputed. Use Add/Delete Sub-directories functions
# to change the project build configurations.
# _START_SUBDIR_MAKES
# _END_SUBDIR_MAKES
# ----------------------Include Sub directories to be build-------------------#


SOURCES=$(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*.cpp))
OBJECTS=$(foreach source,$(SOURCES), $(addprefix $(dir $(source))/$(OUTPUTPATH)/, $(notdir $(source:.cpp=.o))))


all: $(PROJECT_BUILD_OUTPUT) 

$(PROJECT_BUILD_OUTPUT) : subdirs $(OBJECTS) 
	@echo 'Building Target : $@...'
	@echo 'Linker Options --> $(LDFLAGS)...'
	@echo 'Included Libraries --> $(LIBINCLUDES)...'
	@echo '$(OBJECTS)'
	$(CC) -o$@ $(OBJECTS) $(LIBINCLUDES)
	@echo 'Done building $@...'

clean: 
	-$(RM) $(PROJECT_BUILD_OUTPUT) 
	for subdir in $(SUBDIRS); \
	do \
		cd $$subdir/output; \
		rm -Rf *; \
		cd $(PROJECT_ROOT); \
	done
	-@echo ' '

subdirs:
	for subdir in $(SUBDIRS); \
	do \
		$(MAKE) -C $$subdir -f subdir.mk; \
	done

#--------------------------Dummy target-----------------------------------#
# Auto generated section please do not edit or delete. This target is used
# while figuring out project dependencies.
printout:
	-@echo '__BUILD_OUTPUT_DIRECTORY__ : $(PROJECT_OUTPUT_DIR)'
	-@echo '__BUILD_OUTPUT_TARGET__ : $(PROJECT_BUILD_OUTPUT)'
	-@echo '__BUILD_DEPENDENCIES__ : $(LIBINCLUDES)'
#--------------------------Dummy target-----------------------------------#

.PHONY: all clean dependents subdirs printout

.SECONDARY:

