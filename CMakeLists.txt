cmake_minimum_required(VERSION 2.8)
project(jrpc)

## TODO gen release obj here we just use dir back  instead of gen 


# install jrpc
set(CMAKE_INSTALL_PREFIX "/opt")
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/include/jrpc DESTINATION jrpc/include)

install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/bin   DESTINATION jrpc)

install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/lib  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/example  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/etc  DESTINATION jrpc)
install(DIRECTORY  ${jrpc_SOURCE_DIR}/release/usr/lib  DESTINATION /usr)

