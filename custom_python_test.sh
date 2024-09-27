rm -rf $VENVNAME
$PYTHONLOC -m venv $VENVNAME
. $VENVNAME/bin/activate
$VENVNAME/bin/pip install pyperformance && \
echo "[group asyncio]
[group startup]
[group regex]
[group serialize]
[group apps]
[group template]
[group math]" >> $VENVNAME/lib/python3.12/site-packages/pyperformance/data-files/benchmarks/MANIFEST
$VENVNAME/bin/pyperformance run -b serialize -o $VENVNAME.perftest.txt
