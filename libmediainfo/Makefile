#Based on https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/libmediainfo/APKBUILD

include $(TOPDIR)/rules.mk

PKG_NAME:=libmediainfo
PKG_VERSION:=26.01
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://mediaarea.net/download/source/$(PKG_NAME)/$(PKG_VERSION)
#sha256
PKG_HASH:=bcd3d2cc12cf108ca0fbad07568b303257e72afd8ff73d05cfe6b7aa0e66a1c5

PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=MediaInfoLib/README.md

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_SOURCE_SUBDIR:=MediaInfoLib/Project/CMake
UNPACK_CMD:=xzcat $(DL_DIR)/$(PKG_SOURCE) | $(HOST_TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS) #Need to change from default because unpacked file has different folder name
PKG_USE_NINJA:=1 #Set by default but good to make explicit

define Package/libmediainfo
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=Library to provide relevant technical and tag data for video and audio files. Used by mediainfo
	URL:=https://mediaarea.net/en/MediaInfo

	DEPENDS:=+libzen +zlib +libcurl
endef

define Package/libmediainfo/description
	libmediainfo provides a convenient unified display of the most relevant technical and tag data for video and audio files.
	This package includes the shared library.
endef

# Must include reference to STAGING_DIR to ensure all files are correctly referenced
# Without it get build errors for mediainfo which will use the local /usr/include, not the one from STAGING_DIR
CMAKE_OPTIONS+=-DCMAKE_BUILD_TYPE=MinSizeRel \
			-DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr \
			-DLIB_INSTALL_DIR=$(STAGING_DIR)/usr/lib \
			-DCMAKE_VERBOSE_MAKEFILE=ON \
			-DBUILD_SHARED_LIBS=ON

# Directories reference:
# STAGING_DIR:=$(TOPDIR)/staging_dir/$(TARGET_DIR_NAME) e.g. ~/openwrt/staging_dir/target-aarch64_cortex-a53_musl
# PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION) e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libmediainfo-24.11
# PKG_INSTALL_DIR=$(PKG_BUILD_DIR)/ipkg-install e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libmediainfo-24.11/ipkg-install
#   This is where cmake install puts the files
# $(1)=$(BUILD_DIR)/.pkgdir/$(PKG_NAME)   ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libmediainfo-24.11/.pkgdir/libzen/
#   This is the ipkg output directory

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib
	$(INSTALL_DATA)	$(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/libmediainfo.so* $(STAGING_DIR)/usr/lib

	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/MediaInfo
	$(CP) -r $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/include/MediaInfo/MediaInfo*.h $(STAGING_DIR)/usr/include/MediaInfo

	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/MediaInfoDLL
	$(CP) -r $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/include/MediaInfoDLL/MediaInfo*.h $(STAGING_DIR)/usr/include/MediaInfoDLL

	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib/cmake/mediainfolib
	$(CP) -r $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/cmake/mediainfolib/MediaInfoLib*cmake $(STAGING_DIR)/usr/lib/cmake/mediainfolib

	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL_DATA)	$(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/pkgconfig/libmediainfo.pc $(STAGING_DIR)/usr/lib/pkgconfig
endef

define Package/libmediainfo/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/$(STAGING_DIR)/usr/lib/libmediainfo.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libmediainfo))
