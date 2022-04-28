Name:           zerotier-one
Version:        1.8.9
Release:        1%{?dist}
Summary:        ZeroTier network virtualization service

License:        ZeroTier BSL 1.1
URL:            https://www.zerotier.com

# RHEL build

%{echo: dist}%{?dist}

%if 0%{?rhel} && 0%{?rhel} == 7
BuildRequires:  systemd openssl11-devel
%endif

%if 0%{?rhel} && 0%{?rhel} >= 8
BuildRequires:  systemd openssl-devel
%endif

%if 0%{?rhel} && 0%{?rhel} >= 8
Requires: systemd openssl
%endif

%if 0%{?rhel} && 0%{?rhel} <= 7
Requires:      openssl11 systemd
Requires(pre): /usr/sbin/useradd, /usr/bin/getent
%endif

# Fedora

%if 0%{?fedora} && 0%{?fedora} >= 36
BuildRequires:  systemd openssl1.1 openssl1.1-devel
%endif

%if 0%{?fedora} && 0%{?fedora} >= 36
Requires:       systemd openssl1.1 iproute libstdc++
AutoReqProv:    no
Requires(pre): /usr/sbin/useradd, /usr/bin/getent
%endif

%if 0%{?fedora} && 0%{?fedora} == 35
BuildRequires:  systemd openssl-devel
%endif

%if 0%{?fedora} && 0%{?fedora} == 35
Requires:       systemd openssl iproute libstdc++
AutoReqProv:    no
Requires(pre): /usr/sbin/useradd, /usr/bin/getent
%endif

%description
ZeroTier is a software defined networking layer for Earth.

It can be used for on-premise network virtualization, as a peer to peer VPN
for mobile teams, for hybrid or multi-data-center cloud deployments, or just
about anywhere else secure software defined virtual networking is useful.

This is our OS-level client service. It allows Mac, Linux, Windows,
FreeBSD, and soon other types of clients to join ZeroTier virtual networks
like conventional VPNs or VLANs. It can run on native systems, VMs, or
containers (Docker, OpenVZ, etc.).

%prep
ls -la
# %if 0%{?rhel} && 0%{?rhel} >= 7
# rm -rf *
# ln -s %{getenv:PWD} %{name}-%{version}
# tar --exclude=%{name}-%{version}/.git --exclude=%{name}-%{version}/%{name}-%{version} -czf %{_sourcedir}/%{name}-%{version}.tar.gz %{name}-%{version}/*
# rm -f %{name}-%{version}
# cp -a %{getenv:PWD}/* .
# %endif

%build
make RUST_BACKTRACE=full ZT_USE_MINIUPNPC=1 %{?_smp_mflags} one

%pre
/usr/bin/getent passwd zerotier-one || /usr/sbin/useradd -r -d /var/lib/zerotier-one -s /sbin/nologin zerotier-one

%install
# rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT%{_unitdir}
cp %{getenv:PWD}/debian/zerotier-one.service $RPM_BUILD_ROOT%{_unitdir}/%{name}.service

%files
%{_sbindir}/*
%{_mandir}/*
%{_localstatedir}/*
%{_unitdir}/%{name}.service

%post
%systemd_post zerotier-one.service

%preun
%systemd_preun zerotier-one.service

%postun
%systemd_postun_with_restart zerotier-one.service

%changelog
* Mon Apr 25 2022 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.9
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Apr 11 2022 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.8
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Mar 21 2022 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.7
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Mar 07 2022 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.6
- see https://github.com/zerotier/ZeroTierOne for release notes

* Fri Dec 17 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.5
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue Nov 23 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.4
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Nov 15 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.3
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Nov 08 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.2
- see https://github.com/zerotier/ZeroTierOne for release notes

* Wed Oct 20 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Wed Sep 15 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.8.0
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue Apr 13 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.5
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Feb 15 2021 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.4
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Nov 30 2020 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.2-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue Nov 24 2020 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.1-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Thu Nov 19 2020 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.0-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Oct 05 2020 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.6.0-beta1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Fri Aug 23 2019 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.4.4-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Jul 29 2019 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.4.0-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue May 08 2018 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.2.10-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Thu May 03 2018 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.2.8-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Mon Apr 24 2017 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.2.2-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Fri Mar 17 2017 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.2.2-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue Mar 14 2017 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.2.0-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Tue Jul 12 2016 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.1.10-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Fri Jul 08 2016 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.1.8-0.1
- see https://github.com/zerotier/ZeroTierOne for release notes

* Sat Jun 25 2016 Adam Ierymenko <adam.ierymenko@zerotier.com> - 1.1.6-0.1
- now builds on CentOS 6 as well as newer distros, and some cleanup

* Wed Jun 08 2016 François Kooman <fkooman@tuxed.net> - 1.1.5-0.3
- include systemd unit file

* Wed Jun 08 2016 François Kooman <fkooman@tuxed.net> - 1.1.5-0.2
- add libnatpmp as (build)dependency

* Wed Jun 08 2016 François Kooman <fkooman@tuxed.net> - 1.1.5-0.1
- initial package
