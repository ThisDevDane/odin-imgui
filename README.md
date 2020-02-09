# odin-imgui
![scrshot](https://i.imgur.com/nOA6iSl.png)
This is a (work in progress) wrapper for [dear imgui v1.74](https://github.com/ocornut/imgui) (based on the auto-generated [cimgui](https://github.com/cimgui/cimgui.git)).

You can download the latest release with pre-built cimgui binaries [here.](https://github.com/ThisDrunkDane/odin-dear_imgui/releases/latest)

## Notes:
* Most functions have been wrapped or bound, those missing will either be added by the maintainer over time or by PR (PRs VERY WELCOME)

## Building cimgui
In the repo there is a batch script called `build-cimgui.bat`. Make sure you have pulled in the submodule too, then it should be as simple as running that script with a command prompt that has the Visual C++ Compiler (`cl`) and the Microsoft Library Manager (`lib`) in it's `PATH`. This will build a release and debug build of cimgui and put it into a folder called external in the repo root. This is where the odin source files expects to find the libs.
