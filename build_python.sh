set -u
set -e
#bad eval source nostacklimit flto
#maybe bad -fsingle-precision-constant -fdenormal-fp-math=positive-zero
#all
#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -flto -finstrument-functions -fno-sanitize=all -fno-strict-float-cast-overflow -fno-strict-overflow -Ofast -fmerge-all-constants -fdenormal-fp-math=positive-zero  -fstrict-aliasing -fomit-frame-pointer -fwhole-program-vtables -march=native'

#export CPPFLAGS='-Wno-ignored-optimization-argument -Wno-profile-instr-unprofiled -Wno-parentheses-equality -Wno-unused-value -Wno-empty-body -Qunused-arguments -finstrument-functions -fno-sanitize=all -fno-strict-overflow'

export PREFIX=$1
#export CCACHE_COMPILERTYPE=clang
#export CC='/usr/lib/llvm-18/bin/clang'
#export CXX=$CC
#good profiling opts?
# -fprofile-arcs -fbranch-probabilities -fast -p -pg

export BUILD_CORES=8
export COMPILEALL_OPTS="-j $BUILD_CORES -o 0 -o 1 -o 2"

echo "configuring"
time ./conf_python.sh "$PREFIX"
echo "configured"

time make -j $BUILD_CORES
echo "made"
env
echo "testing"
set +e
#time make test
env
env >> "mytestenv.$(date +%s).txt"
echo "tested"
rm -rf basevenv
PYTHONLOC=./python VENVNAME=basevenv ./custom_python_test.sh | tee > builtout.txt