# -*- coding: utf-8 -*-
"""2026-11-25 최종 ZIP: AS-IS 소스 파서 결과(공통 + 화면별 + framework_actions) + DB 추출 결과(db, _fpdb, datasets) + README 8개(사용자 요청: DB 포함)
   제외 = agent/, _review/, framework/ (파서·DB 결과 아님)"""
import fnmatch, os, re, sys, time, zipfile
ROOT = r'C:\Projects\NSCM'
OUT = os.path.join(ROOT, 'Doc', 'asisfacts')
RD = os.path.join(ROOT, 'Doc', 'asisfacts_cmp', 'readme')
ROOT_EXCLUDE = set()
SCREEN_EXCLUDE = []
DIRS = ['foxquery_sql', 'screens', 'framework_actions', 'db', '_fpdb', 'datasets']
READMES = {'README.md': 'README.md', 'asisfacts_README.md': 'asisfacts/README.md', 'foxquery_sql_README.md': 'asisfacts/foxquery_sql/README.md',
           'screens_README.md': 'asisfacts/screens/README.md', 'framework_actions_README.md': 'asisfacts/framework_actions/README.md',
           'db_README.md': 'asisfacts/db/README.md', 'fpdb_README.md': 'asisfacts/_fpdb/README.md', 'datasets_README.md': 'asisfacts/datasets/README.md'}
stamp = time.strftime('%Y%m%d_%H%M')
dest = os.path.join(ROOT, 'Doc', f'AS-IS_파서결과_공통_화면별_{stamp}.zip')
# README 의 스캔 파일 수를 이번 실행 _run.log 값으로
log = open(os.path.join(OUT, '_run.log'), encoding='utf-8', errors='replace').read()
m = re.search(r'cs files: (\d+), csproj: (\d+)', log)
sem = next((l for l in log.splitlines() if l.startswith('semantic:')), '')
n = skipped = 0
with zipfile.ZipFile(dest, 'w', zipfile.ZIP_DEFLATED, compresslevel=6, allowZip64=True) as z:
    for src, arc in READMES.items():
        t = open(os.path.join(RD, src), encoding='utf-8').read()
        if src == 'asisfacts_README.md' and m:
            t = re.sub(r'\.cs [\d,]+개, csproj [\d,]+개, 2026-11-10 기준 `_run.log`', f'.cs {int(m.group(1)):,}개, csproj {int(m.group(2)):,}개, 이번 실행 `_run.log`', t)
        if src == 'README.md' and sem:
            t = t.replace('## ZIP 구성', f'이번 실행 의미 분석 요약(`asisfacts/_run.log`): `{sem}`\n\n## ZIP 구성')
        z.writestr(arc, t.encode('utf-8')); n += 1
    for f in sorted(os.listdir(OUT)):
        p = os.path.join(OUT, f)
        if os.path.isfile(p):
            if f in ROOT_EXCLUDE: skipped += 1; continue
            z.write(p, 'asisfacts/' + f); n += 1
    for d in DIRS:
        for base, _, files in os.walk(os.path.join(OUT, d)):
            for f in files:
                if d == 'screens' and any(fnmatch.fnmatch(f, pat) for pat in SCREEN_EXCLUDE): skipped += 1; continue
                p = os.path.join(base, f)
                z.write(p, 'asisfacts/' + os.path.relpath(p, OUT).replace(os.sep, '/')); n += 1
print(f'{time.strftime("%H:%M:%S")} 넣은 파일 {n}개(README 8 포함) · 제외 {skipped}개 → {dest} ({os.path.getsize(dest) // 1048576}MB)')
