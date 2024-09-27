set -u
set -e
#bad eval source nostacklimit flto
#maybe bad -fsingle-precision-constant -fdenormal-fp-math=positive-zero
#all
#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -flto -finstrument-functions -fno-sanitize=all -fno-strict-float-cast-overflow -fno-strict-overflow -Ofast -fmerge-all-constants -fdenormal-fp-math=positive-zero  -fstrict-aliasing -fomit-frame-pointer -fwhole-program-vtables -march=native'

#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -finstrument-functions -fno-sanitize=all -fno-strict-overflow'

export PREFIX=$1
export CCACHE_COMPILERTYPE=clang
export CC='/usr/lib/llvm-18/bin/clang'
export CXX=$CC
#good profiling opts?
# -fprofile-arcs -fbranch-probabilities -fast -p -pg
export BEST_OPT_FLAGS='-Ofast -march=native -fno-sanitize=all'
export CFLAGS=''
export CXXFLAGS=$CFLAGS
export CPPFLAGS=$CXXFLAGS
export BASECPPFLAGS=""
export BASECFLAGS=''
export OPT=''
export CFLAGS_NODIST=''
export CFLAGS_ALIASING=''
export EXTRA_CFLAGS=''
export CFLAGSFORSHARED=''
export CONFIGURE_CFLAGS_NODIST=''
export CONFIGURE_CPPFLAGS=''
echo "must be run from cpython source dir assuming it is: $(pwd)"
export PY_CFLAGS="$BASECFLAGS $OPT  $CFLAGS $EXTRA_CFLAGS"
export PY_CFLAGS_NODIST="$CONFIGURE_CFLAGS_NODIST $CFLAGS_NODIST -I$(pwd)/Include/internal"
export PY_CPPFLAGS="$BASECPPFLAGS -I. -I$(pwd)/Include $CONFIGURE_CPPFLAGS $CPPFLAGS"
export PY_STDMODULE_CFLAGS="$PY_CFLAGS $PY_CFLAGS_NODIST $PY_CPPFLAGS $CFLAGSFORSHARED"
#PGO_PROF_GEN_FLAG=-fcs-profile-generate


# PGO_PROF_USE_FLAG='-fprofile-instr-use="$(shell pwd)/code.profclangd -fprofile-arcs -finstrument-functions -fprofile-update=atomic'
# PY_STDMODULE_CFLAGS is included in the following:
# LIBMPDEC_CFLAGS
# LIBEXPAT_CFLAGS
# LIBHACL_CFLAGS
# PY_CORE_CFLAGS
export PY_BUILTIN_MODULE_CFLAGS="$BEST_OPT_FLAGS $PY_STDMODULE_CFLAGS -DPy_BUILD_CORE_BUILTIN"
export LIBMPDEC_CFLAGS=''
export BUILD_CORES=8
export COMPILEALL_OPTS="-j $BUILD_CORES -o 0 -o 1 -o 2"

export PROFILE_TASK="-m test -o --pgo --timeout=600"
export OLD_PGO_PROF_USE_FLAG='-fprofile-instr-use=\"\$(shell pwd)\/code\.profclangd\"'
export CUSTOM_PROF_GEN_FLAGS='-fprofile-arcs -finstrument-functions -fprofile-update=atomic -fdebug-info-for-profiling -forder-file-instrumentation -fsplit-machine-functions -Wprofile-instr-unprofiled'
export CUSTOM_PROF_USE_FLAGS='-fprofile-instr-use=\"\$(shell pwd)\/code\.profclangd\" -fsplit-machine-functions'
echo "configuring"
time ./conf_python.sh "$PREFIX"
echo "configured"
sed -i "s/PGO_PROF_GEN_FLAG=-fprofile-instr-generate/PGO_PROF_GEN_FLAG=$CUSTOM_PROF_GEN_FLAGS/g" Makefile
echo "Set PGO_PROF_GEN_FLAG=$CUSTOM_PROF_GEN_FLAGS"
echo "s/PGO_PROF_USE_FLAG=$OLD_PGO_PROF_USE_FLAG/PGO_PROF_USE_FLAG=$CUSTOM_PROF_USE_FLAGS/g"
sed -i "s/PGO_PROF_USE_FLAG=$OLD_PGO_PROF_USE_FLAG/PGO_PROF_USE_FLAG=$CUSTOM_PROF_USE_FLAGS/g" Makefile
echo "Set PGO_PROF_GEN_FLAG=$CUSTOM_PROF_USE_FLAGS"
time make -j $BUILD_CORES
echo "made"
env
echo "testing"
set +e
time make test
env
env >> "mytestenv.$(date +%s).txt"
echo "tested"
