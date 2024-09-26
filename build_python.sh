export CCACHE_COMPILERTYPE=clang
export CC='/usr/lib/llvm-18/bin/clang'
export CXX=$CC
export PROFILE_TASK='-m test --pgo --timeout=900'
set -u
set -e
export PREFIX=$1
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

echo "configuring"
./conf_python.sh $PREFIX
echo "configured"
make -j $BUILD_CORES
echo "made"
declare -a envvars=("CC" "CXX" "PROFILE_TASK" "PREFIX" "BUILD_CORES" "COMPILEALL_OPTS")

for var in "${envvars[@]}";
do
  env | grep "$var="
done

make test
for var in "${envvars[@]}";
do
  env | grep "$var="
done


