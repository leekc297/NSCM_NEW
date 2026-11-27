# -*- coding: utf-8 -*-
"""AS-IS 실측 재사용 기준 = 원장 지문 (2026-11-20 사용자 지시)
   "AS-IS 실측의 경우에도 별도 요청을 하지 않는 경우에는 원장이 변경되지 않으면 24시간이 지나도 의무적으로 수행할 필요는 없다 ·
    원장 기준으로 AS-IS 실측을 수행하고 수행된 결과를 잘 정리해서 가지고 있으면서 TO-BE와 비교에 사용"

  지문 = Doc/verify/<ID>/verify_ledger.csv 의 검증 항목 정의(row_id · rule_id · target · condition · expected) 해시. 판정 결과·근거 칸은 넣지 않는다(실행마다 바뀜)
  기록 = Doc/asislive/<ID>/measured_fp.json {kind: {fp, at, ref}} · kind = basic(asis_live_auto 기본 실측) | bundle(asis_live_screen 분기 실측)
  재사용 = 직전 실측이 정상(OK)이고 기록한 지문 == 지금 지문. 나이(시간)는 보지 않는다. 강제 = VERIFY_ASIS_LIVE=always 또는 --force(별도 요청)

  python tools/Harness/verify/asis_fp.py <ID>            지금 지문과 기록 출력
  python tools/Harness/verify/asis_fp.py --selftest
"""
import csv, datetime, hashlib, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
FIELDS = ('row_id', 'rule_id', 'target', 'condition', 'expected')
# 2026-11-26 측정 결과로 만들어지는 행은 지문에서 뺌(SCP0005 J20261125_210634: 실행 3회 모두 '원장이 바뀜' → AS-IS 실측 7.5~8.4분 매번 다시)
#   EG- = 팝업·권한·정적 검사기 결과(eg_ingest) · ES- = E2E 4종 결과(e2e_suite_ingest) · AD- = AS-IS↔TO-BE 차등 결과(diff_ingest, AS-IS 실측 뒤에 만들어짐)
MEASURED_PREFIX = ('EG-', 'ES-', 'AD-')


def _rows(mid, root=ROOT):
    p = os.path.join(root, 'Doc', 'verify', mid.upper(), 'verify_ledger.csv')
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return sorted(tuple((r.get(k) or '').strip() for k in FIELDS) for r in csv.DictReader(f) if not (r.get('row_id') or '').startswith(MEASURED_PREFIX))
    except OSError:
        return []


def _h(rows):
    return hashlib.sha1(json.dumps(rows, ensure_ascii=False).encode('utf-8')).hexdigest()[:16]


def ledger_fp(mid, root=ROOT):
    rows = _rows(mid, root)
    return _h(rows) if rows else ''


def ledger_parts(mid, root=ROOT):
    """묶음별 지문 {'V|GENERAL': fp, …}(행 ID 앞 글자 | 출처 대신 rule_id 앞 글자) — 지문이 어긋날 때 어느 묶음이 바뀌었는지 알리는 용도"""
    by = {}
    for r in _rows(mid, root):
        by.setdefault(r[0].split('-')[0] + '|' + (r[1][:1] or '-'), []).append(r)
    return {k: _h(v) for k, v in sorted(by.items())}


def _path(mid, root=ROOT):
    return os.path.join(root, 'Doc', 'asislive', mid.upper(), 'measured_fp.json')


def recorded(mid, kind, root=ROOT):
    try:
        return (json.load(open(_path(mid, root), encoding='utf-8')) or {}).get(kind) or {}
    except (OSError, ValueError):
        return {}


def record(mid, kind, ref='', root=ROOT):
    """정상 실측 직후 부른다 — 이 실측이 어느 원장 기준인지 남김"""
    p = _path(mid, root); cur = {}
    try:
        cur = json.load(open(p, encoding='utf-8'))
    except (OSError, ValueError):
        pass
    cur[kind] = {'fp': ledger_fp(mid, root), 'parts': ledger_parts(mid, root), 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'ref': ref}
    os.makedirs(os.path.dirname(p), exist_ok=True)
    tmp = p + '.tmp'; json.dump(cur, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); os.replace(tmp, p)
    return cur[kind]


def same(mid, kind, root=ROOT):
    """(재사용 가능?, 사유)"""
    now = ledger_fp(mid, root); rec = recorded(mid, kind, root)
    if not now:
        return False, '원장 없음 — 지문을 못 냄'
    if not rec.get('fp'):
        return False, '직전 실측에 원장 지문 기록 없음(2026-11-20 이전 실측) — 한 번 새로 재고 지문을 남김'
    if rec['fp'] != now:
        old = rec.get('parts') or {}; cur = ledger_parts(mid, root)
        diff = sorted(k for k in set(old) | set(cur) if old.get(k) != cur.get(k)) if old else []
        return False, f"원장이 바뀜(실측 때 {rec['fp']} → 지금 {now}" + (f" · 바뀐 묶음 {', '.join(diff[:8])}" if diff else '') + ')'
    return True, f"원장 같음({now} · 실측 {rec.get('at', '')})"


def selftest():
    import tempfile, shutil
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    d = tempfile.mkdtemp()
    try:
        vd = os.path.join(d, 'Doc', 'verify', 'X0001'); os.makedirs(vd)
        def w(rows):
            with open(os.path.join(vd, 'verify_ledger.csv'), 'w', encoding='utf-8-sig', newline='') as f:
                wr = csv.DictWriter(f, fieldnames=list(FIELDS) + ['result', 'evidence']); wr.writeheader(); wr.writerows(rows)
        base = [{'row_id': 'V-1', 'rule_id': 'A1', 'target': 't', 'condition': 'c', 'expected': 'e', 'result': 'PASS', 'evidence': 'x'}]
        w(base)
        chk('기록 없음 = 새로 잼', same('X0001', 'basic', d)[0] is False)
        record('X0001', 'basic', 'run1', d); chk('기록 뒤 같은 원장 = 재사용', same('X0001', 'basic', d)[0] is True)
        w([dict(base[0], result='FAIL', evidence='y')]); chk('판정 결과만 바뀜 = 재사용', same('X0001', 'basic', d)[0] is True)
        w([dict(base[0], condition='c2')]); r = same('X0001', 'basic', d); chk('검증 항목 조건이 바뀜 = 새로 잼', r[0] is False and '원장이 바뀜' in r[1])
        chk('종류별 기록(bundle 없음)', same('X0001', 'bundle', d)[0] is False)
        w([dict(base[0], condition='c2')]); record('X0001', 'basic', 'run2', d)
        w([dict(base[0], condition='c2'), {'row_id': 'EG-1', 'rule_id': 'F8', 'target': 'x 저장 감사 칸 T|1', 'condition': '', 'expected': ''}, {'row_id': 'AD-1', 'rule_id': 'A1', 'target': 'x', 'condition': '', 'expected': ''}])
        chk('측정 결과 행(EG-·ES-·AD-)이 늘어도 = 재사용', same('X0001', 'basic', d)[0] is True)
        w([dict(base[0], condition='c3')]); r = same('X0001', 'basic', d); chk('바뀐 묶음 표시', r[0] is False and '바뀐 묶음 V|A' in r[1])
    finally:
        shutil.rmtree(d, ignore_errors=True)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    if len(sys.argv) > 1:
        m = sys.argv[1].upper(); print(json.dumps({'now': ledger_fp(m), 'basic': recorded(m, 'basic'), 'bundle': recorded(m, 'bundle'), 'reuse_basic': same(m, 'basic'), 'reuse_bundle': same(m, 'bundle')}, ensure_ascii=False, indent=1))
