#!/bin/bash
#-------------------------------------
# Filename: strip.sh
# Revision: 1.0
# Data: 2017/02/28
# Des: separte debuginfo from process
# author: pairs
# email:736418319@qq.com
# env Ubuntu
#------------------------------------


# consult: http://blog.csdn.net/chinainvent/article/details/24129311?reload

:<< !
    1. skip xxx.debuginfo
    2. strip ELF file && not stripped
!
script=$(readlink -f "$0")
route=$(dirname "$script")

process_file()
{
    filename=$1
    # 1. debuginfo file not strip
    if echo ${filename} | grep -wq debuginfo$; then
    echo "skip debuginfo file $(file) "
    return
    fi

    is_elf_file=false
    is_stripped=true

    fileinfo=`file ${filename}`

    if echo ${fileinfo} | grep -q "not stripped"; then
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

    # 2. not elf file not strip
    if ! ${is_elf_file}; then
        return
    fi

    # 3. already strippend not strip
    if ${is_stripped}; then
        echo "skip already stripped file: ${filename}"
        return
    fi

    # 4. already linked debuginfo not strip
    if readelf -a ${filename} | grep -q 'gnu_debuglink'; then
        echo "skip already link debuginfo file:" ${filename}
        return
    fi

    # elf && not stripped && not link debuginfo
    echo striping ${filename}
    objcopy --only-keep-debug ${filename} "${filename}.debuginfo"
    objcopy --strip-debug ${filename}
    objcopy --add-gnu-debuglink="$filename.debuginfo" ${filename}
    chmod 0644 "$filename.debuginfo"

    # 5. build
    bid=$(readelf -n ${filename} | grep 'Build ID' | awk '{print $3}')
    bid1=$(echo ${bid} | cut -n -c 1-2)
    bid2=$(echo ${bid} | cut -n -c 3-)

    mkdir debug/
    mkdir -p usr/lib/debug/.build-id/${bid1}
    ln -s /opt/jrpc/debug/$(basename ${filename}.debuginfo) usr/lib/debug/.build-id/${bid1}/${bid2}.debug
    mv ${filename}.debuginfo debug/
}

# 1. cd release dir
cd ${route}/../release

## avoid mistakes do not produce a debuginfo
#mkdir -p usr/lib 
#mkdir -p debug

# 2. process each file
for file in $(find . -type f); do
    process_file $file
    done
