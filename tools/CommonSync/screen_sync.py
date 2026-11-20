# -*- coding: utf-8 -*-
"""CheckList 시작 전 화면 UI 소스 Download & Merge (2026-11-18 사용자 지시)
   "CHECKLIST 수행 시 UI 해당 소스에 대해서 GIT 확인 후 최신소스 변경 분 있으면 다운로드" · "DOWNLOAD & MERGE 되어야 합니다. (DB MODE 일때만)"

  python tools/CommonSync/screen_sync.py <MENU_ID>
  python tools/CommonSync/screen_sync.py <MENU_ID> --deps-only    화면 폴더는 받지 않고 로컬에 없는 공용 파일만 받음(작업 모드 무관 · VMO 자가 복구)

  - 작업 모드(tools/Harness/harness.json repairScope)가 DB_ONLY(DB MODE)일 때만 실행. UI/DB MODE 는 건너뜀(로컬 개발 소스 보호 · 메뉴 Source Download & Merge 로 직접)
  - 대상 = 그 화면 FE 페이지 폴더(nscm-fe 기준 · prereq.page_dir). 공용 파일(procedures.d.ts·locales·shared)은 받지 않는다(다른 화면 영향 · 전체 받기 메뉴 몫)
  - 방식 = 메뉴 ⬇️🔀 Source Download & Merge 와 같은 도구(common_sync.py)·같은 DB MODE 규칙(--overwrite-local) · 미리보기(--dry-run) → 변경 있으면 같은 커밋으로 적용(--apply --target)
  - 전체 기준선(state.json)은 옮기지 않는다(common_sync --paths)
  - 2026-11-20: 화면 파일이 쓰는 공용 파일(@shared/<이름>)이 로컬에 없으면 같은 공통 커밋에서 그 파일만 받는다(fetch_shared_deps · 있는 파일은 건드리지 않음)
  결과 = Doc/verify/<ID>/screen_sync.json · 종료코드 0 = 최신이거나 받음 · 건너뜀 / 2 = 미리보기 실패 / 6 = 화면이 쓰는 공용 파일 없음 / 그 밖 = 적용 실패(common_sync 종료코드)
"""
import datetime, json, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Harness', 'verify'))


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def missing_shared(pdir, fe):
    """화면 폴더 파일이 쓰는 '@shared/<이름>' 중 로컬 공용 패키지에 없는 것 → [(이름, 쓰는 파일)]
       (packages/shared/package.json exports: components · hooks · stores 는 폴더, 그 밖은 src/lib/<이름>.ts)"""
    import re
    sh = os.path.join(fe, 'packages', 'shared', 'src'); out = {}
    for dp, _dn, fns in os.walk(pdir):
        for fn in fns:
            if not fn.endswith(('.ts', '.tsx')):
                continue
            try:
                txt = open(os.path.join(dp, fn), encoding='utf-8').read()
            except (OSError, ValueError):
                continue
            for name in set(re.findall(r"""from\s+['"]@shared/([A-Za-z0-9_-]+)['"]""", txt)):
                if os.path.isdir(os.path.join(sh, name)) or any(os.path.exists(os.path.join(sh, 'lib', name + e)) for e in ('.ts', '.tsx')):
                    continue
                out.setdefault(name, os.path.relpath(os.path.join(dp, fn), fe).replace(os.sep, '/'))
    return sorted(out.items())


def fetch_shared_deps(mid, pdir, fe, tip, py, cs, env):
    """2026-11-20 SCP0028 · SSP0014 사고: 화면 폴더만 공통 원문으로 받았는데 그 파일이 쓰는 공용 파일(@shared/paste)이 로컬에 없어 화면이 열리지 않았다
       (vite "Failed to resolve import" → E2E 가 '화면 권한 없음' 1,294행으로 기록). 빠진 공용 파일은 같은 공통 커밋에서 그 파일만 받는다(로컬에 없는 새 파일만 · 있는 파일은 건드리지 않음).
       반환 {'added': [...], 'missing': [...]} · missing 이 남으면 화면이 열리지 않으므로 호출부가 오류로 끝낸다"""
    miss = missing_shared(pdir, fe); added = []
    if not miss:
        return {'added': [], 'missing': []}
    print(f"[세부] 화면이 쓰는 공용 파일 중 로컬에 없는 것 {len(miss)}건: {', '.join('@shared/' + n for n, _ in miss)}", flush=True)
    for name, user in miss:
        rel = None
        for e in ('.ts', '.tsx'):
            cand = f'packages/shared/src/lib/{name}{e}'
            if tip and subprocess.call(['git', 'cat-file', '-e', f'{tip}:nscm-fe/{cand}'], cwd=fe, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0:
                rel = cand; break
        if not rel:
            print(f'[ERROR] @shared/{name} — 공통 저장소에도 없음(쓰는 파일 nscm-fe/{user})', flush=True); continue
        sumf = os.path.join(ROOT, '.vibe', 'common_sync', f'screen_{mid}_dep_{name}.json')
        rc = subprocess.call([py, cs, '--apply', '--no-fetch', '--areas', 'fe', '--overwrite-local', '--paths', rel, '--target', tip, '--summary', sumf], env=env, cwd=ROOT)
        if rc == 0 and os.path.exists(os.path.join(fe, rel)):
            added.append(rel); print(f'[OK] 공용 파일 받음 nscm-fe/{rel}(쓰는 파일 nscm-fe/{user})', flush=True)
        else:
            print(f'[ERROR] 공용 파일 받기 실패(exit {rc}) nscm-fe/{rel}', flush=True)
    left = [n for n, _ in missing_shared(pdir, fe)]
    return {'added': added, 'missing': left}


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    mid = sys.argv[1].upper(); deps_only = '--deps-only' in sys.argv[2:]
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    out_p = os.path.join(vd, 'screen_sync.json')
    rec = {'menu_id': mid, 'at': now()}

    def done(code, **kw):
        rec.update(kw); json.dump(rec, open(out_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); return code
    try:
        scope = json.load(open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8')).get('repairScope') or 'DB_FE'
    except (OSError, ValueError):
        scope = 'DB_FE'
    # 2026-11-20 --deps-only(VMO 자가 복구 orch-heal.js): 화면 폴더는 받지 않고 화면이 쓰는 공용 파일 중 로컬에 없는 것만 받는다. 없는 파일을 새로 만드는 것뿐이라 두 작업 모드 모두 실행
    if scope != 'DB_ONLY' and not deps_only:
        print(f'[SKIP] 작업 모드 {scope}(UI/DB MODE) — 화면 소스 자동 Download & Merge 는 DB MODE 에서만(로컬 개발 소스 보호)', flush=True)
        return done(0, state='skip', reason=f'work mode {scope}')
    from prereq import page_dir
    pdir = page_dir(mid)
    fe = os.path.join(ROOT, 'nscm-fe')
    if not pdir or not os.path.isdir(pdir):
        print(f'[SKIP] {mid} FE 페이지 폴더 없음 — 받을 화면 소스 없음', flush=True)
        return done(0, state='skip', reason='no page dir')
    rel = os.path.relpath(pdir, fe).replace(os.sep, '/')
    py = sys.executable; cs = os.path.join(HERE, 'common_sync.py')
    sumf = os.path.join(ROOT, '.vibe', 'common_sync', f'screen_{mid}.json'); os.makedirs(os.path.dirname(sumf), exist_ok=True)
    env = dict(os.environ, PYTHONIOENCODING='utf-8', GIT_TERMINAL_PROMPT='0')
    print(f'== 화면 소스 Download & Merge {mid} · DB MODE · 대상 nscm-fe/{rel} · {now()} ==', flush=True)
    print('[세부 1/2] 공통 최신 받기 + 파일별 판정(미리보기 · 파일 변경 없음)', flush=True)
    c1 = subprocess.call([py, cs, '--dry-run', '--areas', 'fe', '--overwrite-local', '--paths', rel, '--summary', sumf], env=env, cwd=ROOT)
    try:
        s1 = json.load(open(sumf, encoding='utf-8'))
    except (OSError, ValueError):
        s1 = {}
    if c1 != 0 or not s1.get('ok'):
        print(f'[ERROR] 미리보기 실패(exit {c1}) — 받지 않음 · CheckList 는 현재 로컬 소스로 진행', flush=True)
        return done(2, state='error', step='dry-run', rc=c1, path=rel)
    if deps_only:
        dep = fetch_shared_deps(mid, pdir, fe, s1.get('tip'), py, cs, env)
        print(f"[{'ERROR' if dep['missing'] else 'OK'}] {mid} 공용 파일 확인(--deps-only) · 받음 {len(dep['added'])} · 남은 없음 {len(dep['missing'])}", flush=True)
        return done(6 if dep['missing'] else 0, state='error' if dep['missing'] else 'deps-only', step='deps', path=rel, tip=s1.get('tip'), deps=dep)
    if not s1.get('changed'):
        print(f"[OK] {mid} 화면 소스 최신 — 공통 {str(s1.get('tip_info', ''))[:60]} 과 같음(파일 {(s1.get('actions') or {}).get('none', 0)}건)", flush=True)
        dep = fetch_shared_deps(mid, pdir, fe, s1.get('tip'), py, cs, env)
        if dep['missing']:
            print(f"[ERROR] {mid} 화면이 쓰는 공용 파일 없음: {', '.join('@shared/' + n for n in dep['missing'])} — 화면이 열리지 않음", flush=True)
            return done(6, state='error', step='deps', path=rel, tip=s1.get('tip'), deps=dep)
        return done(0, state='latest', path=rel, tip=s1.get('tip'), files=(s1.get('actions') or {}).get('none', 0), deps=dep)
    a = s1.get('actions') or {}
    print(f"[세부 2/2] 적용 — 공통 {str(s1.get('tip', ''))[:9]} · 공통 원문 {a.get('write', 0)} · 병합 {a.get('merge', 0)} · 삭제 {a.get('delete', 0)}", flush=True)
    c2 = subprocess.call([py, cs, '--apply', '--no-fetch', '--areas', 'fe', '--overwrite-local', '--paths', rel, '--target', s1['tip'], '--summary', sumf], env=env, cwd=ROOT)
    try:
        s2 = json.load(open(sumf, encoding='utf-8'))
    except (OSError, ValueError):
        s2 = {}
    if s2.get('report'):
        print(f"@@LINK 📄 화면 소스 받기 보고|{s2['report']}", flush=True)
    if c2 == 0 and s2.get('ok'):
        print(f"[OK] {mid} 화면 소스 받음 — 공통 원문 {a.get('write', 0)} · 병합 {a.get('merge', 0)} · 삭제 {a.get('delete', 0)} · 백업 {s2.get('backup', '')}", flush=True)
        dep = fetch_shared_deps(mid, pdir, fe, s1.get('tip'), py, cs, env)
        if dep['missing']:
            print(f"[ERROR] {mid} 화면이 쓰는 공용 파일 없음: {', '.join('@shared/' + n for n in dep['missing'])} — 화면이 열리지 않음", flush=True)
            return done(6, state='error', step='deps', path=rel, tip=s1.get('tip'), actions=a, report=s2.get('report'), backup=s2.get('backup'), deps=dep)
        return done(0, state='applied', path=rel, tip=s1.get('tip'), actions=a, report=s2.get('report'), backup=s2.get('backup'), deps=dep)
    print(f'[ERROR] 적용 실패(exit {c2}) — 보고·백업 확인', flush=True)
    return done(c2 or 4, state='error', step='apply', rc=c2, path=rel, report=s2.get('report'), backup=s2.get('backup'))


if __name__ == '__main__':
    sys.exit(main())
