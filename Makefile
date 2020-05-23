.PHONY: cimgui

OC  = odin
CC = cl
LINK = lib

FLAGS = --out=$(GENERATOR_NAME) --llvm-api

GENERATOR_SRC = ./generator_v2
GENERATOR_NAME = odin-imgui-gen.exe

DIST_DIR = ./dist
ODIN_OUTPUT_DIR = ./output
EXTERNAL_LIB_DIR = ./external

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

all: cimgui build_prod

generate: build_debug
	@echo "[Generate]"
	@mkdir -p $(ODIN_OUTPUT_DIR)
	$(GENERATOR_NAME)

vet:
	@echo "[Odin Vet]"
	$(OC) check $(GENERATOR_SRC) $(FLAGS) --vet

dist: clean all generate
	@echo "[Build Distribute]"
	7z a $(CIMGUI_LIB_ARCHIVE) $(EXTERNAL_LIB_DIR)/*
	cp output/* dist

clean:
	@echo "[Clean]"
	rm -rf $(ODIN_OUTPUT_DIR)
	rm -rf $(GENERATOR_NAME)
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
