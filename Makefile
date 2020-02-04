.PHONY: cimgui

OC  = odin
CC = cl
LINK = lib

FLAGS = -out=$(GENERATOR_NAME)

GENERATOR_SRC = ./generator
GENERATOR_NAME = imgui-gen.exe

DIST_DIR = ./dist
ODIN_OUTPUT_DIR = ./output
EXTERNAL_LIB_DIR = ./external

CIMGUI_SRC= ./cimgui/cimgui_auto.cpp ./cimgui/imgui/imgui.cpp ./cimgui/imgui/imgui_draw.cpp ./cimgui/imgui/imgui_demo.cpp ./cimgui/imgui/imgui_widgets.cpp
CIMGUI_OBJS=cimgui_auto.obj imgui.obj imgui_draw.obj imgui_demo.obj imgui_widgets.obj
CIMGUI_FLAGS = /c /nologo /DCIMGUI_NO_EXPORT
CIMGUI_LIB_ARCHIVE = $(DIST_DIR)/cimgui-binaries.zip

build:
	$(OC) build $(GENERATOR_SRC) $(FLAGS)
	@echo "DONE"

all: cimgui build

generate: build
	@mkdir -p $(ODIN_OUTPUT_DIR)
	$(GENERATOR_NAME)
	@echo "DONE"

dist: clean all generate
	7z a $(CIMGUI_LIB_ARCHIVE) $(EXTERNAL_LIB_DIR)/*
	cp output/* dist
	@echo "DONE"

clean:
	rm -rf $(ODIN_OUTPUT_DIR)
	rm -rf $(GENERATOR_NAME)
	rm -rf $(EXTERNAL_LIB_DIR)
	@echo "DONE"

cimgui:
	@mkdir -p $(EXTERNAL_LIB_DIR)

	$(CC) $(CIMGUI_FLAGS) /MTd /Zi /Fd:$(EXTERNAL_LIB_DIR)/cimgui_debug.pdb $(CIMGUI_SRC)
	$(LINK) /nologo $(CIMGUI_OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui_debug.lib
	rm *.obj
	
	$(CC) $(CIMGUI_FLAGS) /MT /O2 $(CIMGUI_SRC)
	$(LINK) /nologo $(CIMGUI_OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui.lib
	rm *.obj
	@echo "DONE"
