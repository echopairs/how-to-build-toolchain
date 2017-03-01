cmake_minimum_required(VERSION 2.8)
project(jrpc)

## TODO gen release obj here we just use dir back  instead of gen 

set(CMAKE_CXX_FLAGS "-std=c++11 -g")
set(jrpc_src src/demo.cc)
add_executable(demo ${jrpc_src})
set(LIBRARY_OUTPUT_PATH ${jrpc_SOURCE_DIR}/release/lib)
set(EXECUTABLE_OUTPUT_PATH ${jrpc_SOURCE_DIR}/release/bin)


# install jrpc
set(CMAKE_INSTALL_PREFIX "/opt")
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/include/jrpc DESTINATION jrpc/include)

install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/bin   DESTINATION jrpc)

install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/lib  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/doc  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/etc  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/usr/lib  DESTINATION /usr)

