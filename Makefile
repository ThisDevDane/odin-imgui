.PHONY: cimgui

DIST_FOLDER = ./dist

GENERATOR_SRC = ./generator
GENERATOR_NAME = imgui-gen.exe

EXTERNAL_LIB_DIR = ./external

ODIN_OUTPUT_DIR = ./output

OC  = odin
FLAGS = -out=$(GENERATOR_NAME)

CC = cl
LINK = lib

C_FILES= ./cimgui/cimgui_auto.cpp
I_FILES= ./cimgui/imgui/imgui.cpp ./cimgui/imgui/imgui_draw.cpp ./cimgui/imgui/imgui_demo.cpp ./cimgui/imgui/imgui_widgets.cpp
OBJS=cimgui_auto.obj imgui.obj imgui_draw.obj imgui_demo.obj imgui_widgets.obj
C_FLAGS = /c /nologo
DEFINES=/DCIMGUI_NO_EXPORT

CIMGUI_LIB_ARCHIVE = $(DIST_FOLDER)/cimgui-binaries.zip

generate: build
	@mkdir -p $(ODIN_OUTPUT_DIR)
	$(GENERATOR_NAME)

run:
	$(OC) run $(GENERATOR_SRC) $(FLAGS)

all: cimgui build

build:
	$(OC) build $(GENERATOR_SRC) $(FLAGS)

dist: clean all generate
	7z a $(CIMGUI_LIB_ARCHIVE) $(EXTERNAL_LIB_DIR)/*
	cp output/* dist
	@echo "DONE"

clean:
	rm -rf $(ODIN_OUTPUT_DIR)
	rm -rf $(GENERATOR_NAME)
	rm -rf $(EXTERNAL_LIB_DIR)

cimgui:
	@mkdir -p $(EXTERNAL_LIB_DIR)

	$(CC) $(C_FLAGS) /MTd /Zi /Fd:$(EXTERNAL_LIB_DIR)/cimgui_debug.pdb $(DEFINES) $(C_FILES) $(I_FILES)
	lib /nologo $(OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui_debug.lib
	rm *.obj
	
	$(CC) $(C_FLAGS) /MT /O2 $(DEFINES) $(C_FILES) $(I_FILES)
	lib /nologo $(OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui.lib
	rm *.obj
