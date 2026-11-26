cd /c/Projects/NSCM/tools/AsisFacts
date '+start %T'
dotnet _bin/AsisFacts.dll scan --config ../../Doc/asisfacts_cmp_base.json --out ../../Doc/asisfacts_cmp/base > ../../Doc/asisfacts_cmp/base.log 2>&1; echo "base rc=$?"; date '+%T'
dotnet _bin/AsisFacts.dll scan --config asisfacts.json --out ../../Doc/asisfacts_cmp/sem > ../../Doc/asisfacts_cmp/sem.log 2>&1; echo "sem rc=$?"; date '+end %T'
