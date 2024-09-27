set -u
set -e
#make distclean && rm -rf ./default.profraw autom4te.cache/ ./gmon.out

#export CCACHE_COMPILERTYPE=clang
#export CC='clang'
#export CXX=$CC
#proftask -r for random
# Release configure flags
# --disable-test-modules
#
export confopts="--prefix=$PREFIX --with-dbmliborder=gdbm:ndbm:bdb --with-pkg-config=yes  --with-computed-gotos --without-doc-strings --enable-optimizations --with-system-expat --with-system-libmpdec"
#NOTE: BOLT is currently incompatible with the -freorder-blocks-and-partition compiler option. Since GCC8 enables this option by default, you have to explicitly disable it by adding -fno-reorder-blocks-and-partition flag if you are compiling with GCC8 or above.
./configure $confopts

env
