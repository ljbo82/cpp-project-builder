# This file is part of gcc-project-builder.
# Copyright (C) 2021 Leandro José Britto de Oliveira
#
# gcc-project-builder is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# gcc-project-builder is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with gcc-project-builder.  If not, see <https://www.gnu.org/licenses/>

ifndef __include_native_host_mk__
__include_native_host_mk__ := 1

ifeq ($(OS), Windows_NT)
    nativeOS := windows
else
    __native_uname_s__ := $(shell uname -s)
    ifeq ($(__native_uname_s__), Linux)
        nativeOS := linux
    endif
endif
undefine __native_uname_s__

ifeq ($(nativeOS), windows)
    ifeq ($(PROCESSOR_ARCHITECTURE), AMD64)
        nativeArch := x64
    else
        ifeq ($(PROCESSOR_ARCHITECTURE), x86)
            nativeArch := x86
        endif
    endif
else
    __native_uname_m__ := $(shell uname -m)
    ifeq ($(__native_uname_m__), x86_64)
        nativeArch := x64
    else
        ifneq ($(filter %86, $(__native_uname_m__)),)
            nativeArch := x86
        endif
    endif
endif
undefine __native_uname_m__

endif # __include_native_host_mk__
