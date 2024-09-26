make clean
rm -rf config.status config.log ./default.profraw autom4te.cache/ gmon.out platform pyconfig.h python python-config python-config.py python-gdb.py Makefile Makefile.pre
export CCACHE_COMPILERTYPE=clang
export CC='clang'
export CXX=$CC
export PROFILE_TASK='-m test --pgo --timeout=900'

#bad eval source nostacklimit flto
#maybe bad -fsingle-precision-constant -fdenormal-fp-math=positive-zero
#all
#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -flto -finstrument-functions -fno-sanitize=all -fno-strict-float-cast-overflow -fno-strict-overflow -Ofast -fmerge-all-constants -fdenormal-fp-math=positive-zero  -fstrict-aliasing -fomit-frame-pointer -fwhole-program-vtables -march=native'

#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -finstrument-functions -fno-sanitize=all -fno-strict-overflow'
#export CFLAGS=$CPPFLAGS
#export CXXFLAGS=$CPPFLAGS

#export PY_CPPFLAGS=''
#export BASECPPFLAGS=''
#export BASECFLAGS=''
#export CFLAGS=''
#export CFLAGS_NODIST=''
#export CFLAGS_ALIASING=''
#do rightexport LDFLAGS='-L /usr/lib/llvm-18/lib/'
#export OPT=optflagsenter
#export srcdir='.'
#export PY_CFLAGS=$(BASECFLAGS) $(OPT) $(CONFIGURE_CFLAGS) $(CFLAGS) $(EXTRA_CFLAGS)
#export PY_CFLAGS_NODIST='$(CONFIGURE_CFLAGS_NODIST) $(CFLAGS_NODIST) -I$(srcdir)/Include/internal'
#PY_STDMODULE_CFLAGS='$(PY_CFLAGS) $(PY_CFLAGS_NODIST) $(PY_CPPFLAGS) $(CFLAGSFORSHARED)'
#PY_BUILTIN_MODULE_CFLAGS='$(PY_STDMODULE_CFLAGS) -DPy_BUILD_CORE_BUILTIN'

export BUILD_CORES=8
export COMPILEALL_OPTS='-j $BUILD_CORES -o 0 -o 1 -o 2'

confopts='--prefix=$PREFIX --enable-loadable-sqlite-extensions --without-decimal-contextvar --with-dbmliborder=gdbm:ndbm:bdb --with-pkg-config=yes --with-ensurepip=upgrade --with-strict-overflow --enable-profiling --with-strict-overflow --with-computed-gotos --without-doc-strings --with-lto=full --enable-optimizations --enable-ipv6 --enable-bolt'
./configure $confopts
#todo --enable-bolt
#NOTE: BOLT is currently incompatible with the -freorder-blocks-and-partition compiler option. Since GCC8 enables this option by default, you have to explicitly disable it by adding -fno-reorder-blocks-and-partition flag if you are compiling with GCC8 or above.
make -j8
make test

echo $confopts
echo 'CC=$CC CXX=$CXX PROFILE_TASK=$PROFILE_TASK'