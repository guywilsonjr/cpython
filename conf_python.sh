set -u
set -e
export PREFIX=$1
make clean && rm -rf config.status config.log ./default.profraw autom4te.cache/ gmon.out platform pyconfig.h python python-config python-config.py python-gdb.py Makefile Makefile.pre
declare -a envvars=("CC" "CXX" "PROFILE_TASK" "PREFIX" "COMPILEALL_OPTS" "confopts")

export CCACHE_COMPILERTYPE=clang
export CC='clang'
export CXX=$CC
export PROFILE_TASK='-m test --pgo --timeout=900'

export COMPILEALL_OPTS='-j $BUILD_CORES -o 0 -o 1 -o 2'

export confopts="--prefix=$PREFIX --enable-loadable-sqlite-extensions --without-decimal-contextvar --with-dbmliborder=gdbm:ndbm:bdb --with-pkg-config=yes --with-ensurepip=upgrade --enable-profiling --with-computed-gotos --without-doc-strings --with-lto=full --enable-optimizations --enable-ipv6 --enable-bolt"
#NOTE: BOLT is currently incompatible with the -freorder-blocks-and-partition compiler option. Since GCC8 enables this option by default, you have to explicitly disable it by adding -fno-reorder-blocks-and-partition flag if you are compiling with GCC8 or above.
./configure $confopts

for var in "${envvars[@]}";
do
  env | grep "$var="
done
