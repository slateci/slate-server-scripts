Name: slate-server-scripts
Version: 1.0.0
Release: 1%{?dist}
Summary: Scripts for slate api server
License: Apache License
URL: https://github.com/slateci/slate-server-scripts
Source: %{name}-%{version}.tar.gz
BuildRequires: systemd

%define _debugsource_template %{nil}

%description
Slate server API scripts 

%prep
%setup -c -n %{name}-%{version}.tar.gz 

%build
cd %{name}-%{version}

%install
cd %{name}-%{version}
mkdir -p $RPM_BUILD_ROOT/%{_sbindir}
install collect_map_data.sh $RPM_BUILD_ROOT/%{_sbindir}
install dynamoDB.sh $RPM_BUILD_ROOT/%{_sbindir}/
install export_kconfigs.sh $RPM_BUILD_ROOT/%{_sbindir}/
install monitor_clusters.sh $RPM_BUILD_ROOT/%{_sbindir}/
mkdir -p $RPM_BUILD_ROOT/%{_unitdir}
install -m 644 *.service $RPM_BUILD_ROOT/%{_unitdir}
install -m 644 *.timer $RPM_BUILD_ROOT/%{_unitdir}


%clean
rm -rf $RPM_BUILD_ROOT

%files 
%{_sbindir}/collect_map_data.sh
%{_sbindir}/dynamoDB.sh
%{_sbindir}/export_kconfigs.sh
%{_sbindir}/monitor_clusters.sh
/%{_unitdir}/*


%changelog
* Tue Jan 25 2022 Suchandra Thapa <sthapa@uchicago.edu> - 1.0.0-1
- Initial package
