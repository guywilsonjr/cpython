set -u
set -e
#make distclean && rm -rf ./default.profraw autom4te.cache/ ./gmon.out

export CCACHE_COMPILERTYPE=clang
export CC='clang'
export CXX=$CC
#proftask -r for random
# Release configure flags
# --disable-test-modules
#
export confopts="--prefix=$PREFIX --enable-loadable-sqlite-extensions --without-decimal-contextvar --with-dbmliborder=gdbm:ndbm:bdb --with-pkg-config=yes --with-ensurepip=upgrade --enable-profiling --with-computed-gotos --without-doc-strings --with-lto=full --enable-optimizations --enable-ipv6 --enable-bolt"
#NOTE: BOLT is currently incompatible with the -freorder-blocks-and-partition compiler option. Since GCC8 enables this option by default, you have to explicitly disable it by adding -fno-reorder-blocks-and-partition flag if you are compiling with GCC8 or above.
./configure $confopts

env
