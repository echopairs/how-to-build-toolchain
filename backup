// How  to  separate  debuginfo  from  process
// consult: http://blog.csdn.net/chinainvent/article/details/24129311?reload
#!/bin/bash

process_file()
{
    echo $1
    file=$1
    # debuginfo file not skip
    if echo ${file} | grep -wq debuginfo$; then
    echo "skip debuginfo file ${file}"
    return 
    fi
    
    # skip elf and not stripped file
    
    is_elf_file=false
    is_stripped=false
    
    fileinfo=`file ${file}`
    if echo ${fileinfo} | grep -q "not stripped";then
        is_stripped=false
    fi
    
    # ELF bin
    if echo ${fileinfo} | grep -q 'ELF.*LSB executable' ; then
        is_elf_file=true
    fi
    # ELF lib
    if echo ${fileinfo} | grep -q 'ELF.*LSB shared object' ; then
        is_elf_file=true
    fi
    
    # not elf file return
    if ! ${is_elf_file} ; then
        echo "skip non-elf file: ${file}"
        return
    fi
    
    # already stripped return 
    if ${is_stripped} ; then
        echo "skip already stripped file: ${file}"
        return
    fi
    
    # already linked debuginfo return
    if readelf -a ${file} | grep -q 'gnu_debuglink'; then
        echo "skip already link debuginfo file:" ${file}
        return
    fi

    # now we begin build debuginfo
    echo processing ${file}
    objcopy --only-keep-debug "$file" "$file.debuginfo"
    objcopy --strip-debug "$file"
    objcopy --add-gnu-debuglink="$file.debuginfo" "$file"
    chmod 0644 "$file.debuginfo"
    
    # now build ln 
    bid=$(readelf -n "${file}" | grep 'Build ID' | awk '{print $3}')
    bid1=$(echo ${bid} | cut -n -c 1-2)
    bid2=$(echo ${bid} | cut -n -c 3-)
    
   # mkdir -p usr/lib/debug/.build-id/${bid1}
   # ln -s ${file}.debuginfo usr/lib/debug/.build-id/${bid1}/${bid2}.debug
}   

cd release
for file in $(find . -type f); do
    process_file $file
done

// how to build rpm
// MakeFile
RPMTOPDIR=$(abspath rpmbuild)
ROOTFS=$(abspath rootfs)
COMPILE_DIR=$(abspath build)
PAIRS_VERSION=0.0.1
PAIRS_RELEASE=$(shell date +%y%j%H%M)
all:build_rpm

build_rpm:.build_rpm_pairs
	
.build_rpm_pairs: .install
	rm -rf ${RPMTOPDIR}
	rpmbuild -bb \
		-D "_topdir $(RPMTOPDIR)" \
		-D "_prefix /opt/uniview/ia10k" \
		-D "rootfs ${ROOTFS}" \
		-D "pairs_version  $(PAIRS_VERSION)" \
		-D "pairs_release  $(PAIRS_RELEASE)" \
		pairs.spec
.install: $(COMPILE_DIR)/bin/ias 
	rm -rf $(ROOTFS)
	mkdir -p $(ROOTFS)/opt/pairs/{bin,lib,etc,db}
	install -m 755 build/bin/ias  $(ROOTFS)/opt/pairs/bin
	install -m 755 build/lib/*.so $(ROOTFS)/opt/pairs/lib
	install -m 755 build/etc/ias.conf $(ROOTFS)/opt/pairs/etc
	install -m 755 build/db/pairs.db $(ROOTFS)/opt/pairs/db	

clean:
	rm -rf $(ROOTFS) $(RPMTOPDIR)
.PHONY: clean



// spec
Summary: PAIR Software
Name: pairs
Version: %{?pairs_version}
Release: %{?pairs_release}%{?dist}
License: PAIRS Licence
Group: Red Hat
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
%description
pairs software

%define pairs_prefix /opt/pairs
%install
rm -rf %{buildroot}
cp -rf %{rootfs} %{buildroot}
%clean
rm -rf %{buildroot}

%prep
echo "begin install pairs"
%post
echo "install pairs end"
%preun
%postun

%files
%defattr(-,root,root)
%attr(0755,root,root) %{pairs_prefix}/bin/ias
%attr(0755,root,root) %{pairs_prefix}/lib/*
%attr(0755,root,root) %{pairs_prefix}/etc/ias.conf
%attr(0755,root,root) %{pairs_prefix}/db/pairs.db









