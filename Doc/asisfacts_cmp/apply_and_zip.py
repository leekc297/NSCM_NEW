# -*- coding: utf-8 -*-
"""2026-11-25 Roslyn 의미 분석 반영: 운영 출력(Doc/asisfacts) 백업 → run.ps1 -SkipBuild → 새 결과 ZIP
   ZIP 범위 = AsisFacts 소스 파서 결과(공통: Doc/asisfacts 바로 아래 파일 + foxquery_sql/, 화면별: screens/)
   제외 = DB 추출 단계(db/), _fpdb/, datasets/, agent/, _review/, framework/ — 파서 결과가 아닌 다른 단계 산출물"""
import os, subprocess, sys, time, zipfile
ROOT = r'C:\Projects\NSCM'
OUT = os.path.join(ROOT, 'Doc', 'asisfacts')
TOOL = os.path.join(ROOT, 'tools', 'AsisFacts')
STAMP = time.strftime('%Y%m%d_%H%M')
INCLUDE_DIRS = ['foxquery_sql', 'screens']
# 2026-11-26 R229(개선안 20261125190534_SELF): ZIP 최상위 README.md 와 폴더마다 README 를 같이 넣음(final_zip.py 21~28줄과 같은 방식).
#   README 원문 = Doc/asisfacts_cmp/readme. INCLUDE_DIRS 에 폴더를 더하면 README_OF 에도 같은 폴더를 더함(빠지면 실행 전에 멈춤)
RD = os.path.join(ROOT, 'Doc', 'asisfacts_cmp', 'readme')
README_ROOT = {'README.md': 'README.md', 'asisfacts_README.md': 'asisfacts/README.md'}
README_OF = {'foxquery_sql': 'foxquery_sql_README.md', 'screens': 'screens_README.md'}
_miss = [d for d in INCLUDE_DIRS if d not in README_OF] + [f for f in list(README_ROOT) + list(README_OF.values()) if not os.path.exists(os.path.join(RD, f))]
if _miss:
    print('[FAIL] README 빠짐 :', ', '.join(_miss)); sys.exit(1)


def readmes():
    """(ZIP 안 경로, 내용). 최상위 README 머리에 이 ZIP 에 든 범위를 적음(readme/README.md 는 final_zip.py 의 DB 포함 구성을 설명하므로)"""
    out = []
    for src, arc in list(README_ROOT.items()) + [(README_OF[d], 'asisfacts/%s/README.md' % d) for d in INCLUDE_DIRS]:
        t = open(os.path.join(RD, src), encoding='utf-8').read()
        if arc == 'README.md':
            t = ('> 이 ZIP(apply_and_zip.py) 에 든 범위 = asisfacts 바로 아래 파일, %s. 아래 설명의 다른 폴더는 이 ZIP 에 없음\n\n'
                 % ', '.join(d + '/' for d in INCLUDE_DIRS)) + t
        out.append((arc, t))
    return out


def zip_parser_outputs(dest):
    n = 0
    with zipfile.ZipFile(dest, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as z:
        for arc, t in readmes():
            z.writestr(arc, t.encode('utf-8')); n += 1
        for f in sorted(os.listdir(OUT)):
            p = os.path.join(OUT, f)
            if os.path.isfile(p):
                z.write(p, 'asisfacts/' + f); n += 1
        for d in INCLUDE_DIRS:
            for base, _, files in os.walk(os.path.join(OUT, d)):
                for f in files:
                    p = os.path.join(base, f)
                    z.write(p, 'asisfacts/' + os.path.relpath(p, OUT).replace(os.sep, '/')); n += 1
    return n


def say(s):
    print(time.strftime('%H:%M:%S'), s, flush=True)


say('1) 백업 시작')
bk = os.path.join(ROOT, 'Doc', f'asisfacts_backup_{STAMP}_before_semantic.zip')
say(f'   백업 {zip_parser_outputs(bk)}개 파일 → {bk} ({os.path.getsize(bk) // 1048576}MB)')
say('2) run.ps1 -SkipBuild')
r = subprocess.run(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', os.path.join(TOOL, 'run.ps1'), '-SkipBuild'], cwd=TOOL,
                   capture_output=True, text=True, encoding='utf-8', errors='replace')
open(os.path.join(ROOT, 'Doc', 'asisfacts_cmp', f'run_ps1_{STAMP}.log'), 'w', encoding='utf-8').write(r.stdout + '\n' + r.stderr)
say(f'   run.ps1 rc={r.returncode}')
print('\n'.join((r.stdout or '').splitlines()[-15:]))
if r.returncode != 0:
    say('run.ps1 실패 — ZIP 만들지 않음'); sys.exit(1)
say('3) 새 결과 ZIP')
z = os.path.join(ROOT, 'Doc', f'AS-IS_파서결과_공통_화면별_{STAMP}.zip')
say(f'   {zip_parser_outputs(z)}개 파일 → {z} ({os.path.getsize(z) // 1048576}MB)')
say('끝')
