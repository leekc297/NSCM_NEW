# -*- coding: utf-8 -*-
"""SCP0122·SCP0100·SCP0096 — 로컬 신규 개발본 백업 후 페이지 폴더를 공통소스(common/main) 판으로 교체 (사용자 지시 2026-10-22)

사유: 세 화면은 공통소스에 이미 반영된 UI 다. 로컬에서 새로 개발한 판을 백업해 두고 공통소스 판으로 맞춘다.
범위: nscm-fe 의 페이지 폴더 3개만. procedures.d.ts 는 SCP0122 블록이 공통과 동일·나머지 둘은 양쪽 모두 없음 → 변경 없음.
  SCP0122 features/supply/src/pages/plan-activity-mgmt
  SCP0100 features/supply/src/pages/global-psi-report
  SCP0096 features/supply/src/pages/shipment-working-day-osp
방식: ① 백업(이 폴더 page/ 에 로컬 페이지 폴더 전체 + git_diff_before.patch + git_status_before.txt) — 하나라도 실패하면 아무것도 바꾸지 않음
      ② 공통 판 파일 쓰기(내용 그대로, 개행만 로컬 방식 — 신규는 core.autocrlf=true 이므로 CRLF) · 공통에 없는 로컬 파일 삭제(백업에 있음)
      ③ 검증: 폴더 파일 목록·내용(개행 정규화) = 공통 판 / 삭제 파일을 가리키는 import 잔존 0
원복: page/ 아래를 nscm-fe 의 같은 경로로 되돌려 복사하면 된다.
"""
import os, sys, re, shutil, subprocess, json, datetime
sys.path.insert(0, r'C:\Projects\NSCM\tools\CommonSync'); import common_sync as cs
FE = r'C:\Projects\NSCM\nscm-fe'; HERE = os.path.dirname(os.path.abspath(__file__))
PAGES = {'SCP0122': 'features/supply/src/pages/plan-activity-mgmt', 'SCP0100': 'features/supply/src/pages/global-psi-report', 'SCP0096': 'features/supply/src/pages/shipment-working-day-osp'}
git = cs.Git(FE); tip = git.out('rev-parse', 'common/main').strip()
def walk(d):
    out = []
    for dp, dn, fn in os.walk(d):
        for f in fn: out.append(os.path.relpath(os.path.join(dp, f), d).replace(os.sep, '/'))
    return sorted(out)
log = {'tip': tip, 'at': datetime.datetime.now().isoformat(timespec='seconds'), 'pages': {}}
# ① 백업
open(os.path.join(HERE, 'git_status_before.txt'), 'wb').write(subprocess.run(['git', 'status', '--porcelain', '--', *PAGES.values()], cwd=FE, capture_output=True).stdout)
open(os.path.join(HERE, 'git_diff_before.patch'), 'wb').write(subprocess.run(['git', 'diff', '--', *PAGES.values()], cwd=FE, capture_output=True).stdout)
for ID, rel in PAGES.items():
    src = os.path.join(FE, rel.replace('/', os.sep)); dst = os.path.join(HERE, 'page', rel.replace('/', os.sep))
    if os.path.exists(dst): sys.exit(f'⛔ 백업 대상이 이미 있음(덮어쓰지 않음): {dst}')
    shutil.copytree(src, dst)
    if walk(src) != walk(dst): sys.exit(f'⛔ 백업 검증 실패: {rel}')
print('① 백업 완료 →', os.path.join(HERE, 'page'))
# ② 공통 판으로 교체
autocrlf = git.out('config', '--get', 'core.autocrlf', check=False).strip().lower() == 'true'
for ID, rel in PAGES.items():
    base = os.path.join(FE, rel.replace('/', os.sep)); cpref = 'nscm-fe/' + rel
    cfiles = [f[len(cpref) + 1:] for f in git.out('ls-tree', '-r', '--name-only', tip, '--', cpref).split()]
    local = walk(base); written, same, deleted = [], [], []
    for f in cfiles:
        cb = git.blob_at(tip, f'{cpref}/{f}'); lp = os.path.join(base, f.replace('/', os.sep)); lb = open(lp, 'rb').read() if os.path.exists(lp) else None
        if lb is not None and cs.norm(lb) == cs.norm(cb): same.append(f); continue
        if not cs.is_binary(cb): cb = cs.conv(cs.eoln(cb), cs.eol_of(lb) if lb is not None else ('\r\n' if autocrlf else cs.eol_of(cb)), cs.has_bom(cb))
        os.makedirs(os.path.dirname(lp), exist_ok=True); open(lp, 'wb').write(cb); written.append(f)
    for f in local:
        if f not in cfiles: os.remove(os.path.join(base, f.replace('/', os.sep))); deleted.append(f)
    for dp, dn, fn in sorted(os.walk(base), key=lambda x: -len(x[0])):
        if dp != base and not os.listdir(dp): os.rmdir(dp)
    log['pages'][ID] = {'path': rel, 'common_files': len(cfiles), 'same': same, 'written': written, 'deleted': deleted}
    print(f'② {ID} {rel}: 공통 {len(cfiles)} · 동일 유지 {len(same)} · 공통 판으로 교체/추가 {len(written)} · 로컬 전용 삭제 {len(deleted)}')
# ③ 검증
bad = 0
for ID, rel in PAGES.items():
    base = os.path.join(FE, rel.replace('/', os.sep)); cpref = 'nscm-fe/' + rel
    cfiles = sorted(f[len(cpref) + 1:] for f in git.out('ls-tree', '-r', '--name-only', tip, '--', cpref).split())
    if walk(base) != cfiles: print(f'✖ {ID} 파일 목록 불일치'); bad += 1
    mism = [f for f in cfiles if cs.norm(open(os.path.join(base, f.replace('/', os.sep)), 'rb').read()) != cs.norm(git.blob_at(tip, f'{cpref}/{f}'))]
    if mism: print(f'✖ {ID} 내용 불일치 {mism}'); bad += 1
    else: print(f'③ {ID} 폴더 = 공통 판 ({len(cfiles)}파일, 내용 일치)')
# 삭제한 파일을 가리키는 import 잔존
stems = {}
for ID, v in log['pages'].items():
    for f in v['deleted']: stems[re.sub(r'\.(tsx?|jsx?|scss)$', '', os.path.basename(f))] = f'{v["path"]}/{f}'
hits = []
for top in ('features', 'apps', 'packages'):
    for dp, dn, fn in os.walk(os.path.join(FE, top)):
        dn[:] = [d for d in dn if d not in ('node_modules', 'dist', '.turbo')]
        for f in fn:
            if not f.endswith(('.ts', '.tsx')): continue
            t = open(os.path.join(dp, f), encoding='utf-8', errors='replace').read()
            for s, src in stems.items():
                if re.search(r'''from\s+['"][^'"]*/''' + re.escape(s) + r'''['"]''', t): hits.append(f'{os.path.relpath(os.path.join(dp, f), FE)} → {src}')
print('③ 삭제 파일을 가리키는 import:', len(hits), hits[:5]); bad += len(hits)
log['verify_bad'] = bad
json.dump(log, open(os.path.join(HERE, 'apply_log.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
git.close(); print('결과:', '✅ 완료' if not bad else f'✖ 검증 문제 {bad}건 — 원복은 page/ 를 되돌려 복사'); sys.exit(1 if bad else 0)
