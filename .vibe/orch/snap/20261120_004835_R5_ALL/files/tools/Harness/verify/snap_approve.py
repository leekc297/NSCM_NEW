# -*- coding: utf-8 -*-
"""스냅샷 승인 = 골든(2026-11-06 플랜 3-4) — 수신본을 골든으로 올리고 사용자 판정 회귀 오라클(_user_verdicts_direct.csv)에 기록한다.
  python tools/Harness/verify/snap_approve.py <ID> [--item <key>] --by <이름> --opinion <사유> [--force] [--no-verdict]
  --no-verdict: 골든 승격·manifest 만 하고 사용자 판정 파일(_user_verdicts_direct.csv)에는 쓰지 않는다 — 검증엔진 PoC·임시 승인용(사용자 승인이 아니므로 회귀 오라클에 넣지 않는다)
조건: snap_validate.csv 의 그 키가 OK 또는 NA(사람 확인 종류) — MISMATCH 는 --force 와 사유가 있어야 승인(사유는 manifest·판정 파일에 남는다)
하는 일: received/<key>.* → golden/<key>.* 복사(화면샷은 Playwright 가 첫 실행에 만든 golden png 또는 artifacts 의 *-actual.png) · snap/manifest.json(sha8·승인자·시각·사유) ·
       원장 스냅샷 행(target '<ID> 스냅샷 <종류> <범위>')이 있으면 Doc/verify/_user_verdicts_direct.csv 에 PASS 행 · checker_regress.py <ID> --baseline --only 스냅샷(가능하면)
--update-snapshots 는 쓰지 않는다(승인 게이트 우회).
"""
import csv, datetime, glob, hashlib, json, os, re, shutil, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
DIRECT = P('Doc', 'verify', '_user_verdicts_direct.csv')


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def nrm(s): return re.sub(r'[^a-z0-9가-힣]', '', str(s or '').lower())


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__); return 2
    mid = a[0].upper()
    opt = lambda k: a[a.index(k) + 1] if k in a and a.index(k) + 1 < len(a) else ''
    item, by, opinion, force = opt('--item'), opt('--by'), opt('--opinion'), '--force' in a
    if not by:
        print('[snap_approve] --by <이름> 필수(승인자)'); return 2
    sd = P('Doc', 'verify', mid, 'snap'); gd = os.path.join(sd, 'golden'); os.makedirs(gd, exist_ok=True)
    try:
        res = json.load(open(os.path.join(sd, 'results.json'), encoding='utf-8'))
    except (OSError, ValueError):
        print(f'[snap_approve] {mid}: snap/results.json 없음'); return 2
    val = {r['key']: r for r in rd(os.path.join(sd, 'snap_validate.csv'))}
    if not val:
        print(f'[snap_approve] {mid}: snap_validate.csv 없음 — snap_expect.py → snap_validate.py 먼저'); return 2
    try:
        man = json.load(open(os.path.join(sd, 'manifest.json'), encoding='utf-8'))
    except (OSError, ValueError):
        man = {}
    led = {r['row_id']: r for r in rd(P('Doc', 'verify', mid, 'verify_ledger.csv'))}
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    direct_new = []
    ok_n = skip = 0
    for r in res:
        key = r['key']
        if item and key != item:
            continue
        if r.get('status') not in ('NEW', 'DIFF'):
            continue
        v = val.get(key, {}); st = v.get('status', 'NA')
        if st == 'MISMATCH' and not (force and opinion):
            print(f"   ✖ {key}: 검증 MISMATCH(누락 {v.get('missing')} · 순서 {v.get('order')}) — --force 와 --opinion 사유 없이는 승인 불가"); skip += 1; continue
        src = ''
        if r['kind'] == '화면샷':
            gp = os.path.join(gd, key + '.png')
            if r.get('status') == 'NEW' and os.path.exists(gp):
                src = gp  # Playwright 가 첫 실행에 골든을 만들었다 — 그대로 승인
            else:
                cands = sorted(glob.glob(os.path.join(ROOT, 'Doc', 'e2e', 'results', '**', f'*{key}*actual.png'), recursive=True), key=os.path.getmtime)
                # 2026-11-17: 11-06 화면별 폴더 이전 뒤 Playwright 산출물은 Doc/verify/<ID>/e2e/artifacts 아래 — 그 위치도 찾는다(SSP0020 화면샷 승인 '찾지 못함')
                cands = sorted(cands + glob.glob(os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e', 'artifacts', '**', f'*{key}*actual.png'), recursive=True), key=os.path.getmtime)
                if not cands and r.get('received'):
                    cands = sorted(glob.glob(os.path.join(P(r['received']), '*actual.png')), key=os.path.getmtime)
                if not cands:
                    print(f"   ✖ {key}: actual png 를 찾지 못함"); skip += 1; continue
                src = cands[-1]; shutil.copy2(src, gp)
            dst = gp
        else:
            rp = P(r.get('received') or '')
            if not os.path.exists(rp):
                print(f"   ✖ {key}: 수신본 없음 {r.get('received')}"); skip += 1; continue
            dst = os.path.join(gd, os.path.basename(rp)); shutil.copy2(rp, dst); src = rp
        sha = hashlib.sha1(open(dst, 'rb').read()).hexdigest()[:8]
        man[key] = {'kind': r['kind'], 'scope': r['scope'], 'golden': os.path.relpath(dst, ROOT), 'sha8': sha, 'approved_by': by, 'approved_at': now, 'opinion': opinion, 'validate': st, 'forced': bool(force and st == 'MISMATCH')}
        row = next((x for x in led.values() if '스냅샷' in (x.get('target') or '') and nrm(x['target']) == nrm(f"{mid} 스냅샷 {r['kind']} {r['scope']}")), None)
        if row:
            direct_new.append({'menu_id': mid, 'row_id': row['row_id'], 'verdict': 'PASS', 'opinion': f"스냅샷 승인 {os.path.relpath(dst, ROOT)}@{sha} — {opinion or '사용자 승인'}", 'decided_by': by, 'decided_at': now})
        ok_n += 1
        print(f"   ✔ {key}: {os.path.relpath(src, ROOT)} → {os.path.relpath(dst, ROOT)} @{sha}" + (f" · 원장 {row['row_id']}" if row else ' · 원장 행 없음(ledger.py 뒤 재실행 시 연결)'))
    json.dump(man, open(os.path.join(sd, 'manifest.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    if '--no-verdict' in a:
        print(f'   (--no-verdict) 사용자 판정 파일 미기록 {len(direct_new)}건 — 임시 승인(사용자 승인 전)'); direct_new = []
    if direct_new:
        prev = rd(DIRECT); keep = [x for x in prev if not ((x.get('menu_id') or '').upper() == mid and x.get('row_id') in {d['row_id'] for d in direct_new})]
        tmp = DIRECT + f'.{os.getpid()}.tmp'
        with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=['menu_id', 'row_id', 'verdict', 'opinion', 'decided_by', 'decided_at']); w.writeheader(); w.writerows([{k: x.get(k, '') for k in w.fieldnames} for x in keep + direct_new])
        os.replace(tmp, DIRECT)
    print(f"[snap_approve] {mid}: 승인 {ok_n} · 보류 {skip} · 사용자 판정 기록 {len(direct_new)} → snap/manifest.json")
    if ok_n:
        try:
            out = subprocess.run([sys.executable, os.path.join(HERE, 'checker_regress.py'), mid, '--baseline', '--only', '스냅샷'], capture_output=True, text=True, timeout=300)
            print('   ' + (out.stdout or out.stderr).strip().splitlines()[-1][:200] if (out.stdout or out.stderr).strip() else '   checker_regress 출력 없음')
        except Exception as ex:
            print(f'   checker_regress 기준 저장 실패(수동 실행 필요): {ex}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
