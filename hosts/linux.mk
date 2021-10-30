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

ifndef __include_hosts_linux_mk__
__include_hosts_linux_mk__ := 1

# ------------------------------------------------------------------------------
ifeq ($(__project_mk_dir__),)
    $(error project.mk not included yet)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(CROSS_COMPILE),)
    ifeq ($(nativeArch),)
        $(error Missing CROSS_COMPILE)
    else
        ifneq ($(hostArch),$(nativeArch))
            ifeq ($(hostArch),x86)
                ifeq ($(nativeArch),x64)
                    cxxFlags += -m32
                    cFlags   += -m32
                    ldFlags  += -m32
                else
                    __preBuildError__ := Missing CROSS_COMPILE for HOST '$(HOST)'
                endif
            else ifeq ($(hostArch),x64)
                ifeq ($(nativeArch),x86)
                    cxxFlags += -m64
                    cFlags   += -m64
                    ldFlags  += -m64
                else
                    __preBuildError__ := Missing CROSS_COMPILE for HOST '$(HOST)'
                endif
            else
                __preBuildError__ := Missing CROSS_COMPILE for HOST '$(HOST)'
            endif
        endif
    endif
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(PROJ_TYPE),app)
    __postTargets__ := 0
    ifeq ($(ARTIFACT_NAME),)
        ARTIFACT_NAME := $(ARTIFACT_BASE_NAME)
    endif
else
    ifeq ($(LIB_TYPE),static)
        __postTargets__ := 0
        ifeq ($(ARTIFACT_NAME),)
            ARTIFACT_NAME := lib$(ARTIFACT_BASE_NAME).a
        endif
    else
        ifeq ($(ARTIFACT_NAME),)
            ARTIFACT_NAME := lib$(ARTIFACT_BASE_NAME).so.$(projVersionMinor).$(projVersionPatch)
            ifneq ($(srcFiles),)
                __postTargets__ := 1
                postBuildDeps   += $(buildDir)/lib$(ARTIFACT_BASE_NAME).so
                postDistDeps    += $(distDir)/lib/lib$(ARTIFACT_BASE_NAME).so
            else
                __postTargets__ := 0
            endif
        else
            __postTargets__ := 0
        endif
    endif
endif
# ------------------------------------------------------------------------------

# postBuildDeps ================================================================
ifeq ($(__postTargets__),1)
$(buildDir)/lib$(ARTIFACT_BASE_NAME).so: $(buildDir)/$(ARTIFACT_NAME)
	@printf "$(nl)[BUILD] $@\n"
	$(v)ln -sf $(notdir $<) $@
endif
# ==============================================================================

# postDistDeps =================================================================
ifeq ($(__postTargets__),1)
$(distDir)/lib/lib$(ARTIFACT_BASE_NAME).so: $(buildDir)/lib$(ARTIFACT_BASE_NAME).so
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(distDir)/lib
	$(v)ln -f $< $@
endif
# ==============================================================================

undefine __postTargets__

endif #__include_hosts_linux_mk__
