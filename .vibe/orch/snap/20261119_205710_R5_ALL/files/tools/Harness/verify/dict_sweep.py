# -*- coding: utf-8 -*-
"""LBL·MSG·MNU 코드 사전 중복 스윕(2026-11-02 엔진 갭 EG358·EG461 · 문서 DM-96 '동일 문구는 하나의 ID 만')

  python tools/Harness/verify/dict_sweep.py              → Doc/verify/_global/dict_dup.csv (전역 · 화면 무관)
  python tools/Harness/verify/dict_sweep.py --selftest   판정 변이 입증

  같은 접두(LBL·MSG·MNU)·같은 언어에서 문구가 같은데 ID 가 둘 이상이면 중복 후보. 세 언어 문구가 모두 같아야 진짜 중복이다
  (EN 만 같고 KO 가 다른 ID 는 의미가 다를 수 있다). 메뉴명은 위치가 달라 같은 이름이 정상일 수 있어 MNU 는 확인 대상으로만 둔다.
  읽기 전용 · 새로 조회(hook #152)
"""
import csv, os, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
COLS = ['prefix', 'text_ko', 'text_en', 'text_cn', 'ids', 'n', 'result']


def find_dups(rows):
    """rows = (msg_id, lang, text). 반환 = [(prefix, (ko, en, cn), [ids])] — 세 언어 문구가 모두 같은 ID 묶음"""
    by = {}
    for mid, lang, text in rows:
        if text and str(text).strip():
            by.setdefault(mid, {})[lang] = str(text).strip()
    groups = {}
    for mid, t in by.items():
        if not t.get('EN') and not t.get('KO'):
            continue
        key = (mid[:3], t.get('KO', ''), t.get('EN', ''), t.get('CN', ''))
        groups.setdefault(key, []).append(mid)
    return [(k[0], k[1:], sorted(v)) for k, v in groups.items() if len(v) > 1]


def judge(prefix):
    return 'ERROR' if prefix == 'MNU' else 'FAIL'


def selftest():
    R = [('LBL1', 'KO', '가'), ('LBL1', 'EN', 'A'), ('LBL2', 'KO', '가'), ('LBL2', 'EN', 'A'), ('LBL3', 'KO', '나'), ('LBL3', 'EN', 'A'), ('MSG1', 'KO', '가'), ('MSG1', 'EN', 'A')]
    d = find_dups(R)
    cases = [('세 언어 같음 = 중복', [x[2] for x in d] == [['LBL1', 'LBL2']], True), ('EN 만 같으면 중복 아님', not any('LBL3' in x[2] for x in d), True), ('접두 다르면 중복 아님', not any('MSG1' in x[2] for x in d), True), ('MNU 는 확인 대상', judge('MNU') == 'ERROR', True), ('LBL 은 FAIL', judge('LBL') == 'FAIL', True), ('빈 문구 제외', find_dups([('L1', 'KO', ' '), ('L2', 'KO', ' ')]) == [], True)]
    bad = 0
    for n, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    from dbconn import connect
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE NVL(USE_YN,'Y')='Y'")
        rows = [(str(a), str(b), c) for a, b, c in cur.fetchall()]
    d = find_dups(rows)
    out = [{'prefix': p, 'text_ko': t[0], 'text_en': t[1], 'text_cn': t[2], 'ids': ';'.join(ids), 'n': len(ids), 'result': judge(p)} for p, t, ids in sorted(d, key=lambda x: (x[0], -len(x[2])))]
    p = os.path.join(ROOT, 'Doc', 'verify', '_global', 'dict_dup.csv')
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(out)
    cnt = {}
    for x in out:
        cnt[x['prefix']] = cnt.get(x['prefix'], 0) + 1
    print(f'[dict_sweep] 문구 {len(rows)}행 · 세 언어 동일 중복 묶음 {cnt or 0} → {os.path.relpath(p, ROOT)}')
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if len(sys.argv) > 1 and sys.argv[1] == '--selftest' else main())
