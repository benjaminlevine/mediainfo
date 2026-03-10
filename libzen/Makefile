#Based on https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/libzen/APKBUILD

include $(TOPDIR)/rules.mk

PKG_NAME:=libzen
PKG_VERSION:=0.4.41
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://mediaarea.net/download/source/$(PKG_NAME)/$(PKG_VERSION)
#sha256
PKG_HASH:=eb237d7d3dca6dc6ba068719420a27de0934a783ccaeb2867562b35af3901e2d

PKG_LICENSE:=Zlib
PKG_LICENSE_FILES:=ZenLib/README.md

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_SOURCE_SUBDIR:=ZenLib/Project/CMake
UNPACK_CMD:=bzcat $(DL_DIR)/$(PKG_SOURCE) | $(HOST_TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS) #Need to change from default because unpacked file has different folder name
PKG_USE_NINJA:=1 #Set by default but good to make explicit

define Package/libzen
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=Library used in MediaInfo
	URL:=https://mediaarea.net/en/MediaInfo

	DEPENDS:=+libpthread +libstdcpp
endef

define Package/libzen/description
	ZenLib (libzen) is a library written in C++ used in MediaInfo and other MediaArea projects to support multimedia data formats.
	This package includes the shared library.
endef

# Must include reference to STAGING_DIR to ensure all files are correctly referenced
# Without it libraries can't be found by cmake when building libmediainfo
# and get build errors for mediainfo which will use the local /usr/include, not the one from STAGING_DIR
CMAKE_OPTIONS+= -DCMAKE_BUILD_TYPE=None \
				-DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr \
				-DLIB_INSTALL_DIR=$(STAGING_DIR)/usr/lib \
				-DCMAKE_VERBOSE_MAKEFILE=ON \
                -DCMAKE_POLICY_VERSION_MINIMUM=3.5

# Directories reference:
# STAGING_DIR:=$(TOPDIR)/staging_dir/$(TARGET_DIR_NAME) e.g. ~/openwrt/staging_dir/target-aarch64_cortex-a53_musl
# PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION) e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libzen-0.4.41
# PKG_INSTALL_DIR=$(PKG_BUILD_DIR)/ipkg-install e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libzen-0.4.41/ipkg-install
#   This is where cmake install puts the files
# $(1)=$(BUILD_DIR)/.pkgdir/$(PKG_NAME)   ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libzen-0.4.41/.pkgdir/libzen/
#   This is the ipkg output directory

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib
	$(INSTALL_DATA)	$(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/libzen.so* $(STAGING_DIR)/usr/lib

	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/ZenLib
	$(CP) -r $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/include/ZenLib/* $(STAGING_DIR)/usr/include/ZenLib

	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib/cmake/zenlib
	$(CP) -r $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/cmake/zenlib/ZenLib*cmake $(STAGING_DIR)/usr/lib/cmake/zenlib

	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL_DATA)	$(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/pkgconfig/libzen.pc $(STAGING_DIR)/usr/lib/pkgconfig
endef

define Package/libzen/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/libzen.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libzen))
