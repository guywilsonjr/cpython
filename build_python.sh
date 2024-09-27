set -u
set -e
#bad eval source nostacklimit flto
#maybe bad -fsingle-precision-constant -fdenormal-fp-math=positive-zero
#all
#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -flto -finstrument-functions -fno-sanitize=all -fno-strict-float-cast-overflow -fno-strict-overflow -Ofast -fmerge-all-constants -fdenormal-fp-math=positive-zero  -fstrict-aliasing -fomit-frame-pointer -fwhole-program-vtables -march=native'

#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -finstrument-functions -fno-sanitize=all -fno-strict-overflow'
#good profiling opts?
# -fprofile-arcs -fbranch-probabilities
export PREFIX=$1
export CCACHE_COMPILERTYPE=clang
export CC='/usr/lib/llvm-18/bin/clang'
export CXX=$CC
export BEST_OPT_FLAGS='-Ofast -march=native'
export CFLAGS='-fno-reorder-blocks-and-partition'
export CXXFLAGS=""
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
# PY_STDMODULE_CFLAGS is included in the following:
# LIBMPDEC_CFLAGS
# LIBEXPAT_CFLAGS
# LIBHACL_CFLAGS
# PY_CORE_CFLAGS
export PY_BUILTIN_MODULE_CFLAGS="$BEST_OPT_FLAGS $PY_STDMODULE_CFLAGS -DPy_BUILD_CORE_BUILTIN"
export LIBMPDEC_CFLAGS=''
export BUILD_CORES=8
export COMPILEALL_OPTS="-j $BUILD_CORES -o 0 -o 1 -o 2"
#potentialprofiletaskargs
# '-ucurses,largfile,network,decimal,cpu,subprocess,urlfetch,gui,tzdata'
# Maybenot -uwalltime,largefile, -M for memory intensive >2.5Gb
export PROFILE_TASK="-m test -o --pgo-extended --timeout=600"

echo "configuring"
./conf_python.sh "$PREFIX"
echo "configured"
make -j $BUILD_CORES
echo "made"
env
echo "testing"
make test
env
env >> mytestenv.$(date +%s).txt

