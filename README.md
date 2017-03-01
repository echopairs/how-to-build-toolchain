## Linux CPP build-toolchain

### introduction

### How to use
1. modify your CMakeLists.txt*
2. Run the **script build.sh** in the **tools dir**

### test
```
1. $./tools/build.sh
2. $sudo dpkg -i jrpc_2.0.0-1_amd64.deb
3. $cd /opt/jrpc/bin && sudo chmod a+x demo
4. $gdb demo # no debug info
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from demo...(no debugging symbols found)...done.

5. cd - && sudo dpkg -i jrpc-debuginfo_2.0.0-1_amd64.deb
6. $cd /opt/jrpc/bin
7. $gdb demo # have debug info
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from demo...Reading symbols from /opt/jrpc/debug/demo.debuginfo...done.
done.

```
