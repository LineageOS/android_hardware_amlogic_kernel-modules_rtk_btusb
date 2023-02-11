#
# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
RTKBTUSB_PATH    := $(abspath $(call my-dir))
RTKBTUSB_CONFIGS := CONFIG_BT_RTKBTUSB=m

include $(CLEAR_VARS)

LOCAL_MODULE        := rtk_btusb
LOCAL_MODULE_SUFFIX := .ko
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR)/lib/modules

_rtkbtusb_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_rtkbtusb_ko := $(_rtkbtusb_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
RTKBTUSB_ABSOLUTE := $(abspath $(_rtkbtusb_intermediates))

$(_rtkbtusb_ko): $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@cp -R $(RTKBTUSB_PATH)/* $(_rtkbtusb_intermediates)/
	$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(KERNEL_OUT) M=$(abspath $(_rtkbtusb_intermediates)) ARCH=$(TARGET_KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(RTKBTUSB_CONFIGS) $(KERNEL_CLANG_TRIPLE) $(KERNEL_CC) modules
	$(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $@;

include $(BUILD_SYSTEM)/base_rules.mk
endif
