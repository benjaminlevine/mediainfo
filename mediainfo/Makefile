#Based on https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/mediainfo/APKBUILD

include $(TOPDIR)/rules.mk

PKG_NAME:=mediainfo
PKG_VERSION:=26.01
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://mediaarea.net/download/source/$(PKG_NAME)/$(PKG_VERSION)
#sha256
PKG_HASH:=150656cad88ef4efa4e8299cfc24d9b7a72354576a69349920588acee2cc3c76

PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=MediaInfo/README.md
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1 # Run make install after building

include $(INCLUDE_DIR)/package.mk

UNPACK_CMD:=xzcat $(DL_DIR)/$(PKG_SOURCE) | $(HOST_TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS) # Need to change from default because unpacked file has different folder name

define Package/mediainfo
	SECTION:=multimedia
	CATEGORY:=Multimedia
	TITLE:=Provides relevant technical and tag data for video and audio files
	URL:=https://mediaarea.net/en/MediaInfo

	DEPENDS:=+libmediainfo +libzen
endef

define Package/mediainfo/description
	mediainfo provides a convenient unified display of the most relevant technical and tag data for video and audio files.
	A GUI is available but not compiled here
endef

CONFIGURE_PATH:=MediaInfo/Project/GNU/CLI
MAKE_PATH:=MediaInfo/Project/GNU/CLI

# Must include reference to STAGING_DIR to ensure all files are correctly referenced
CONFIGURE_ARGS+=--prefix=$(STAGING_DIR)/usr \
				--libdir=$(STAGING_DIR)/usr/lib \
				--sysconfdir=$(STAGING_DIR)/etc \
				--enable-static=no

# Don't need a 'Build/Prepare' step to run
# cd $(PKG_BUILD_DIR)/$(CONFIGURE_PATH); ./autogen.sh
# PKG_FIXUP:=autoreconf does the same job

# Directories reference:
# STAGING_DIR:=$(TOPDIR)/staging_dir/$(TARGET_DIR_NAME) e.g. ~/openwrt/staging_dir/target-aarch64_cortex-a53_musl
# PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION) e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/mediainfo-24.11
# PKG_INSTALL_DIR=$(PKG_BUILD_DIR)/ipkg-install e.g. ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/mediainfo-24.11/ipkg-install
#   This is where make install puts the files
# $(1)=$(BUILD_DIR)/.pkgdir/$(PKG_NAME)   ~/openwrt/build_dir/target-aarch64_cortex-a53_musl/libmediainfo-24.11/.pkgdir/libzen/
#   This is the ipkg output directory

define Package/mediainfo/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mediainfo $(1)/usr/bin
endef

$(eval $(call BuildPackage,mediainfo))
