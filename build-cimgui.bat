@REM @Author: Mikkel Hjortshoej
@REM @Date:   09-02-2018 21:47:40 UTC+1
@REM @Last Modified by:   Mikkel Hjortshoej
@REM Modified time: 02-09-2018 15:38:06 UTC+1
@echo off 

if not exist external mkdir external
pushd external

set C_FILES=../cimgui/cimgui_auto.cpp
set I_FILES=../cimgui/imgui/imgui.cpp ../cimgui/imgui/imgui_draw.cpp ../cimgui/imgui/imgui_demo.cpp ../cimgui/imgui/imgui_widgets.cpp
set OBJS=cimgui_auto.obj imgui.obj imgui_draw.obj imgui_demo.obj imgui_widgets.obj
set R_OPTIONS=/MT /c /O2 /nologo
set D_OPTIONS=/MTd /c /Zi /nologo /Fd:cimgui_debug.pdb
set DEFINES=/DCIMGUI_NO_EXPORT

echo ---- Building Release ----
cl %R_OPTIONS% %DEFINES% %I_FILES% %C_FILES%
lib /nologo %OBJS% /out:cimgui.lib
del *.obj

echo ---- Building Debug ----
cl %D_OPTIONS% %DEFINES% %C_FILES% %I_FILES%
lib /nologo %OBJS% /out:cimgui_debug.lib
del *.obj
echo ---- Building Done ----

popd