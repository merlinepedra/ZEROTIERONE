# Common makefile -- loads make rules for each platform

# OSTYPE=$(shell uname -s)

# ifeq ($(OSTYPE),Darwin)
# 	include make-mac.mk
# endif

# ifeq ($(OSTYPE),Linux)
# 	include make-linux.mk
# endif

# ifeq ($(OSTYPE),FreeBSD)
# 	CC=clang
# 	CXX=clang++
# 	ZT_BUILD_PLATFORM=7
# 	include make-bsd.mk
# endif
# ifeq ($(OSTYPE),OpenBSD)
# 	CC=clang
# 	CXX=clang++
# 	ZT_BUILD_PLATFORM=9
# 	include make-bsd.mk
# endif

# ifeq ($(OSTYPE),NetBSD)
# 	include make-netbsd.mk
# endif

drone:
	@echo "rendering .drone.yaml from .drone.jsonnet"
	drone jsonnet --format --stream

debian:
	@echo "building deb package"
	debuild --no-lintian -b -uc -us

redhat:
	@echo "building rpm package"
	rpmbuild --target `rpm -q bash --qf "%{arch}"` -ba zerotier-one.spec

munge_rpm:
	@:$(call check_defined, VERSION)
	@echo "Updating rpm spec to $(VERSION)"
	ci/scripts/munge_rpm_spec.sh zerotier-one.spec $(VERSION) "Sean OMeara <sean@sean.io>" "blah blah"

munge_deb:
	@:$(call check_defined, VERSION)
	@echo "Updating debian/changelog to $(VERSION)"
	ci/scripts/munge_debian_changelog.sh debian/changelog $(VERSION) "Sean OMeara <sean@sean.io>" "blah blah"
