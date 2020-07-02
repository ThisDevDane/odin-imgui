.PHONY: cimgui

OC  = odin
CC = cl
LINK = lib

PROGRAM_NAME = odin-imgui-gen

FLAGS = --out=$(EXE_NAME) --llvm-api
# FLAGS = --out=$(EXE_NAME)

GENERATOR_SRC = ./generator_v2
EXE_NAME = $(PROGRAM_NAME).exe
OBJ_NAME = $(PROGRAM_NAME).exe
PDB_NAME = $(PROGRAM_NAME).pdb

EXAMPLES_DIR = ./examples
DIST_DIR = ./dist
ODIN_OUTPUT_DIR = ./output
EXTERNAL_LIB_DIR = ./output/external

CIMGUI_SRC= ./cimgui/cimgui.cpp ./cimgui/imgui/imgui.cpp ./cimgui/imgui/imgui_draw.cpp ./cimgui/imgui/imgui_demo.cpp ./cimgui/imgui/imgui_widgets.cpp
CIMGUI_OBJS=cimgui.obj imgui.obj imgui_draw.obj imgui_demo.obj imgui_widgets.obj
CIMGUI_FLAGS = /c /nologo /DCIMGUI_NO_EXPORT
CIMGUI_LIB_ARCHIVE = $(DIST_DIR)/cimgui-binaries.zip

build_debug:
	@echo "[Build Debug]"
	$(OC) build $(GENERATOR_SRC) $(FLAGS) --debug

build_prod:
	@echo "[Build Production]"
	$(OC) build $(GENERATOR_SRC) $(FLAGS) --opt=3

all: cimgui build_debug

sdl_opengl:
	@echo "[SDL OpenGL Example]"
	$(OC) run $(EXAMPLES_DIR)/sdl_opengl --debug --llvm-api

generate: build_debug
	@echo "[Generate]"
	@mkdir -p $(ODIN_OUTPUT_DIR)
	$(EXE_NAME)

vet:
	@echo "[Odin Vet]"
	$(OC) check $(GENERATOR_SRC) $(FLAGS) --vet

dist: clean all generate
	@echo "[Build Distribute]"
	7z a $(CIMGUI_LIB_ARCHIVE) $(EXTERNAL_LIB_DIR)/*
	cp $(ODIN_OUTPUT_DIR)/*.odin dist

update: clean all generate
	@echo "[Update]"
	cp -f $(ODIN_OUTPUT_DIR)/*.odin .
	cp -rf $(EXTERNAL_LIB_DIR) .

clean:
	@echo "[Clean]"
	rm -rf $(ODIN_OUTPUT_DIR)
	rm -rf *.exe
	rm -rf *.pdb
	rm -rf *.obj
	rm -rf $(EXTERNAL_LIB_DIR)
	rm -rf $(DIST_DIR)

cimgui:
	@echo "[Build CIMGUI]"
	@mkdir -p $(EXTERNAL_LIB_DIR)

	$(CC) $(CIMGUI_FLAGS) /MTd /Zi /Fd:$(EXTERNAL_LIB_DIR)/cimgui_debug.pdb $(CIMGUI_SRC)
	$(LINK) /nologo $(CIMGUI_OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui_debug.lib
	rm *.obj
	
	$(CC) $(CIMGUI_FLAGS) /MT /O2 $(CIMGUI_SRC)
	$(LINK) /nologo $(CIMGUI_OBJS) /out:$(EXTERNAL_LIB_DIR)/cimgui.lib
	rm *.obj
