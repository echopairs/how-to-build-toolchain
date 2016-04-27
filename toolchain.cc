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

