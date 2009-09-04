SUBDIRPATH = <SUBDIRPATH>

DIROUTPUT = $(SUBDIRPATH)/$(OUTPUTPATH)
DIROBJ = $(DIROUTPUT)/obj

SOURCEFILES = $(wildcard $(SUBDIRPATH)/*.cpp)
OBJECTFILES = $(addprefix $(DIROBJ)/, $(notdir $(SOURCEFILES:.cpp=.o)))

$(OBJECTFILES):$(SOURCEFILES) $(DIROBJ) 
	@echo 'Building directory $(SUBDIRPATH)...'
	@echo 'Compile Targets --> $<'
	@echo 'Compiler --> $(CC)...'
	@echo 'Compiler Flags --> [CFLAGS:$(CFLAGS)] [CXXFLAGS:$(CXXFLAGS)]...'
	@echo 'Include Paths --> $(INCLUDES)'
	$(CC) -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Done building directory $(SUBDIRPATH)...'

$(DIROBJ):
	@echo 'Creating directory $(DIROBJ)...'
	mkdir -p $(DIROBJ)
