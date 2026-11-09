# -*- coding: utf-8 -*-
"""시험이 원복하지 못한 기존 행 자동 복원(2026-11-02 T39 — DMF0005 저장 SP 가 다른 칸까지 변경)

  python tools/Harness/verify/restore_touched.py <MENU_ID>     Doc/verify/<ID>/touched_rows.json 의 행을 저장 직전 값으로 되돌린다
  python tools/Harness/verify/restore_touched.py --selftest    판정 변이 입증

  대상 = 시험이 기록한 키(cleanup_spec keys)로 cleanup_spec tables 중 이력 아닌 표 · 기준 = AS OF 저장 직전 시각(flashback)
  되돌리는 조건: 현재 행의 LAST_UPDATED_BY 가 시험 계정이고 수정 시각이 기록 시각 이후 — 그 뒤 다른 사람이 고쳤으면 건드리지 않고 ERROR 로 보고
  이력 표(_H) = 같은 키·시험 계정·기록 시각 이후 행 삭제. flashback 불가(ORA-01466 등)면 값을 추정하지 않고 ERROR.
  처리 뒤 파일을 touched_rows.done.json 으로 옮긴다.
"""
import csv, datetime, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
ACCOUNT = (os.environ.get('E2E_RESTORE_ACCOUNT') or 'minyonglee1').lower()  # 2026-11-03 명부 계정 실저장(시나리오 user 열) 복원


def _key_value(v, col, data_type):
    """2026-11-07 T158: 기록 값(그리드 dataItem)을 DB 키 컬럼 타입에 맞춘다.
    · Date 객체는 JSON 에 ISO(UTC) 로 남는다('2026-12-31T15:00:00.000Z' = 로컬 2027-01-01) → 로컬 날짜로 바꿔 VARCHAR2 는 'YYYYMMDD'(컬럼명에 YYYYMMDD) 또는 'YYYY-MM-DD', DATE 는 datetime
    · 그 밖은 문자열 그대로"""
    import re
    s = '' if v is None else str(v)
    m = re.match(r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2})(?:\.\d+)?)?(Z|[+-]\d{2}:\d{2})$', s)
    if not m:
        return s
    iso = s.replace('Z', '+00:00')
    try:
        d = datetime.datetime.fromisoformat(iso[:26] + iso[26:] if '.' not in iso else re.sub(r'\.(\d{1,6})\d*', lambda x: '.' + x.group(1).ljust(6, '0'), iso)).astimezone()
    except ValueError:
        return s
    if data_type.upper().startswith('DATE') or data_type.upper().startswith('TIMESTAMP'):
        return d.replace(tzinfo=None)
    return d.strftime('%Y%m%d') if 'YYYYMMDD' in col.upper() or 'YMD' in col.upper() else d.strftime('%Y-%m-%d')


def decide(cur, old, at):
    """cur·old = 컬럼 사전 · at = 기록 시각. 반환 (동작, 사유) — RESTORE | SAME | SKIP"""
    diff = sorted(k for k in cur if str(cur.get(k)) != str(old.get(k)))
    if not diff:
        return 'SAME', '저장 전과 같음'
    who = str(cur.get('LAST_UPDATED_BY') or '').lower(); when = cur.get('LAST_UPDATE_DATE')
    if who != ACCOUNT:
        return 'SKIP', f'다른 사용자({who}) 수정 — 건드리지 않음'
    if when is not None and when < at:
        return 'SKIP', f'기록 시각({at}) 이전 수정({when}) — 시험 변경 아님'
    return 'RESTORE', ','.join(diff)


def judge_audit(o, c, at, table):
    """저장 뒤 감사 칸(EG183·EG241) — 수정인데 생성 칸이 바뀌면 FAIL · 값이 바뀌었는데 수정 칸이 그대로면 FAIL · 값이 그대로인데 수정 칸만 갱신은 왕복 시험에서 정상이라 판정하지 않는다"""
    AUD = ('CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE')
    bad = [k for k in ('CREATED_BY', 'CREATION_DATE') if k in o and str(o[k]) != str(c.get(k))]
    if bad:
        return 'FAIL', f'{table} 수정 저장인데 {bad} 변경: {str(o[bad[0]])[:30]}→{str(c.get(bad[0]))[:30]}'
    changed = [k for k in o if k not in AUD and str(o[k]) != str(c.get(k))]
    if 'LAST_UPDATED_BY' not in o:
        return 'NA', f'{table} 감사 칸 없음'
    moved = str(o.get('LAST_UPDATE_DATE')) != str(c.get('LAST_UPDATE_DATE'))
    if changed and not moved:
        return 'FAIL', f'{table} 값 {changed[:3]} 이 바뀌었는데 LAST_UPDATE_DATE 그대로'
    if moved and c.get('LAST_UPDATE_DATE') is not None and c['LAST_UPDATE_DATE'] < at:
        return 'NA', f'{table} 기록 시각 이전 수정 — 이 시험 변경 아님'
    return 'PASS', f'{table} 생성 칸 불변 · 수정 칸 정상'


def selftest():
    at = datetime.datetime(2026, 11, 2, 18, 26)
    O = {'A': 1, 'LAST_UPDATED_BY': 'x', 'LAST_UPDATE_DATE': datetime.datetime(2024, 1, 1)}
    C = {'A': 2, 'LAST_UPDATED_BY': ACCOUNT, 'LAST_UPDATE_DATE': datetime.datetime(2026, 11, 2, 18, 27)}
    cases = [('시험 변경 복원', decide(C, O, at)[0], 'RESTORE'), ('값 같음', decide(O, O, at)[0], 'SAME'), ('다른 사용자 보호', decide({**C, 'LAST_UPDATED_BY': 'kim'}, O, at)[0], 'SKIP'), ('이전 수정 보호', decide({**C, 'LAST_UPDATE_DATE': datetime.datetime(2026, 1, 1)}, O, at)[0], 'SKIP'),
             ('감사 정상', judge_audit({**O, 'CREATED_BY': 'a'}, {**C, 'CREATED_BY': 'a'}, at, 'T')[0], 'PASS'),
             ('생성자 변경', judge_audit({**O, 'CREATED_BY': 'a'}, {**C, 'CREATED_BY': 'b'}, at, 'T')[0], 'FAIL'),
             ('수정 칸 그대로', judge_audit(O, {**O, 'A': 2}, at, 'T')[0], 'FAIL'),
             ('감사 칸 없음', judge_audit({'A': 1}, {'A': 1}, at, 'T')[0], 'NA')]
    bad = 0
    for n, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def keyless(mid, fp, tables, at):
    """키 없는 복원 — 감사 칸(LAST_UPDATED_BY·LAST_UPDATE_DATE / CREATED_BY·CREATION_DATE)으로 시험 계정 변경 행만 특정"""
    from dbconn import connect
    bad = 0; left = []
    with connect('tobe', write=True) as cx:
        cur = cx.cursor()
        for t in tables:
            cur.execute('SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME=:t', t=t.split('.')[-1]); cols = {x[0] for x in cur.fetchall()}
            conds = []
            if {'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'} <= cols: conds.append('(LOWER(LAST_UPDATED_BY)=:u AND LAST_UPDATE_DATE>=:a)')
            if {'CREATED_BY', 'CREATION_DATE'} <= cols: conds.append('(LOWER(CREATED_BY)=:u AND CREATION_DATE>=:a)')
            if not conds:
                print(f'[restore_touched] {t}: 키 없는 복원 불가 — 감사 칸 없음(변경 여부 확인 불가)'); left.append((t, '감사 칸 없음')); continue
            cur.execute(f"SELECT ROWIDTOCHAR(ROWID) FROM {t} WHERE {' OR '.join(conds)}", u=ACCOUNT, a=at); rids = [x[0] for x in cur.fetchall()]
            if not rids:
                print(f'[restore_touched] {t}: 키 없는 복원 · 시험 계정 변경 행 0'); continue
            cur.execute(f'SELECT * FROM {t} WHERE ROWNUM = 0'); names = [d[0] for d in cur.description]
            n_up = n_del = 0
            for rid in rids:
                try:
                    cur.execute(f'SELECT * FROM {t} AS OF TIMESTAMP :a WHERE ROWID = CHARTOROWID(:r)', a=at, r=rid); o1 = cur.fetchone()
                except Exception as ex:
                    print(f'[restore_touched] {t} {rid}: ERROR flashback 불가 {str(ex)[:80]}'); bad += 1; left.append((t, rid)); continue
                cur.execute(f'SELECT * FROM {t} WHERE ROWID = CHARTOROWID(:r)', r=rid); c1 = cur.fetchone()
                if not c1:
                    continue
                if not o1:
                    cur.execute(f'DELETE FROM {t} WHERE ROWID = CHARTOROWID(:r)', r=rid); n_del += 1; continue
                o, c = dict(zip(names, o1)), dict(zip(names, c1)); ch = [k for k in names if str(c[k]) != str(o[k])]
                if ch:
                    cur.execute(f"UPDATE {t} SET {', '.join(f'{k}=:v{i}' for i, k in enumerate(ch))} WHERE ROWID = CHARTOROWID(:r)", {**{f'v{i}': o[k] for i, k in enumerate(ch)}, 'r': rid}); n_up += 1
            print(f'[restore_touched] {t}: 키 없는 복원 · 시험 계정 변경 행 {len(rids)} → 되돌림 {n_up} · 새 행 삭제 {n_del}')
        cx.commit()
    print(f'[restore_touched] {mid}: 한계 — 저장이 지운 행(감사 칸으로 못 찾음)은 복원 대상 밖 · save_residue 와 별도 확인 필요')
    for t, why in left:
        print(f'[restore_touched] 미복원 {t}: {why}')
    os.replace(fp, fp.replace('.json', '.done.json'))
    return 1 if bad or left else 0


def main(mid):
    fp = os.path.join(ROOT, 'Doc', 'verify', mid, 'touched_rows.json')
    if not os.path.exists(fp):
        print(f'[restore_touched] {mid}: 기록 없음'); return 0
    entries = json.load(open(fp, encoding='utf-8'))
    spec = json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')).get(mid) or {}
    keys = spec.get('keys') or []; tables = spec.get('tables') or []
    if not tables:
        print(f'[restore_touched] {mid}: ERROR cleanup_spec 표 없음 — 수동 복원 필요: {entries[:3]}'); return 1
    if not keys:
        return keyless(mid, fp, tables, min(datetime.datetime.fromisoformat(e['at']) for e in entries))
    from dbconn import connect
    bad = 0; audit = []
    with connect('tobe', write=True) as cx:
        cur = cx.cursor()
        for e in entries:
            at = datetime.datetime.fromisoformat(e['at'])
            for t in tables:
                # 2026-11-03 표별 키(cleanup_spec table_keys) — 사이트 원장처럼 키 칸이 다른 표(DMF0004 SCM_MST_SITE = DIVISION_ID·SCM_SITE_ID)
                tkeys = (spec.get('table_keys') or {}).get(t) or keys
                if any(not str(e['item'].get(k) or '').strip() for k in tkeys):
                    continue  # 이 기록 행에 이 표 키가 없음(다른 그리드 행)
                cur.execute('SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME=:t', t=t); ctype = {x[0]: x[1] for x in cur.fetchall()}; cols = set(ctype)
                if not set(tkeys) <= cols:
                    continue
                # 2026-11-07 T158(SCP0127): 그리드 행의 날짜 칸은 Date 객체라 기록이 ISO(UTC) '2026-12-31T15:00:00.000Z' 로 남는데 DB 키는 VARCHAR2 'YYYYMMDD'(또는 DATE)
                #   → WHERE 불일치로 '행 수 0 · SAME' 이 나와 안전망이 행을 못 찾았다. 키 값을 DB 컬럼 타입에 맞춰 정규화한다(UTC → 로컬 날짜)
                kv = {f'k{i}': _key_value(e['item'].get(k), k, ctype.get(k, '')) for i, k in enumerate(tkeys)}
                where = ' AND '.join(f'{k}=:k{i}' for i, k in enumerate(tkeys))
                if t.endswith('_H'):
                    cur.execute(f"DELETE FROM {t} WHERE {where} AND LOWER(LAST_UPDATED_BY)=:u AND LAST_UPDATE_DATE>=:a", {**kv, 'u': ACCOUNT, 'a': at})
                    print(f'[restore_touched] {t} {list(kv.values())}: 이력 삭제 {cur.rowcount}건')
                    continue
                try:
                    cur.execute(f'SELECT * FROM {t} AS OF TIMESTAMP :a WHERE {where}', {**kv, 'a': at}); names = [d[0] for d in cur.description]; old = cur.fetchall()
                except Exception as ex:
                    print(f'[restore_touched] {t} {list(kv.values())}: ERROR flashback 불가 {str(ex)[:80]} — 수동 복원 필요'); bad += 1
                    continue
                cur.execute(f'SELECT * FROM {t} WHERE {where}', kv); now = cur.fetchall()
                if len(now) != 1 or len(old) != 1:
                    # 키당 여러 행인 표 — 이 시험 계정이 기록 시각 뒤 고친 행이 없으면 변경 없음
                    if 'LAST_UPDATED_BY' in cols:
                        cur.execute(f"SELECT COUNT(*) FROM {t} WHERE {where} AND ((LOWER(LAST_UPDATED_BY)=:u AND LAST_UPDATE_DATE>=:a)" + (" OR (LOWER(CREATED_BY)=:u AND CREATION_DATE>=:a)" if {'CREATED_BY', 'CREATION_DATE'} <= cols else '') + ")", {**kv, 'u': ACCOUNT, 'a': at}); cnt = cur.fetchone()[0]
                        if cnt == 0:
                            print(f'[restore_touched] {t} {list(kv.values())}: SAME 시험 계정 수정 행 0(행 수 {len(now)})')
                            continue
                if len(old) != 1 or len(now) != 1:
                    # 2026-11-03 키당 여러 행(DMF0005 SCM_MST_SITE_ITEM 2행) — 시험 계정이 기록 시각 뒤 고친 행만 ROWID 로 특정해 그 시각 값으로 복원
                    if 'LAST_UPDATED_BY' in cols and 'LAST_UPDATE_DATE' in cols:
                        # 2026-11-04 T45 — 저장 SP 가 파생해 만든 행(DMF0082 DM_PLN_SALES_PLAN MKT_AMT_*: CREATED_BY=시험 계정 · LAST_UPDATED_BY=SYSTEM)도 대상
                        cur.execute(f"SELECT ROWIDTOCHAR(ROWID) FROM {t} WHERE {where} AND ((LOWER(LAST_UPDATED_BY)=:u AND LAST_UPDATE_DATE>=:a)" + (" OR (LOWER(CREATED_BY)=:u AND CREATION_DATE>=:a)" if {'CREATED_BY', 'CREATION_DATE'} <= cols else '') + ")", {**kv, 'u': ACCOUNT, 'a': at}); rids = [x[0] for x in cur.fetchall()]
                        okn = 0
                        for rid in rids:
                            cur.execute(f'SELECT * FROM {t} AS OF TIMESTAMP :a WHERE ROWID = CHARTOROWID(:r)', a=at, r=rid); o1 = cur.fetchone()
                            cur.execute(f'SELECT * FROM {t} WHERE ROWID = CHARTOROWID(:r)', r=rid); c1 = cur.fetchone()
                            if not o1 and c1:
                                cn = dict(zip(names, c1))
                                if str(cn.get('CREATED_BY') or '').lower() == ACCOUNT and cn.get('CREATION_DATE') and cn['CREATION_DATE'] >= at:
                                    cur.execute(f'DELETE FROM {t} WHERE ROWID = CHARTOROWID(:r)', r=rid); okn += 1
                                    print(f'[restore_touched] {t} {list(kv.values())} ROWID {rid}: DELETE 시험 계정이 기록 시각 뒤 생성한 행'); continue
                            if not o1 or not c1:
                                print(f'[restore_touched] {t} {rid}: ERROR flashback 행 없음 — 수동 확인'); bad += 1; continue
                            o, c = dict(zip(names, o1)), dict(zip(names, c1)); act, why = decide(c, o, at)
                            ra, wa = judge_audit(o, c, at, t); audit.append({'target': f"{t}|{'/'.join(kv.values())}|{rid}", 'result': ra, 'why': wa})
                            if act == 'RESTORE':
                                ch = [k for k in names if str(c[k]) != str(o[k])]
                                cur.execute(f"UPDATE {t} SET {', '.join(f'{k}=:v{i}' for i, k in enumerate(ch))} WHERE ROWID = CHARTOROWID(:r)", {**{f'v{i}': o[k] for i, k in enumerate(ch)}, 'r': rid}); okn += 1
                            elif act == 'SKIP':
                                bad += 1
                            print(f'[restore_touched] {t} {list(kv.values())} ROWID {rid}: {act} {why}')
                        print(f'[restore_touched] {t} {list(kv.values())}: 키당 {len(now)}행 · 시험 계정 수정 {len(rids)}행 ROWID 복원 {okn}')
                        continue
                    print(f'[restore_touched] {t} {list(kv.values())}: ERROR 행 수 전 {len(old)}·후 {len(now)} — 수동 확인'); bad += 1
                    continue
                o, c = dict(zip(names, old[0])), dict(zip(names, now[0])); act, why = decide(c, o, at)
                ra, wa = judge_audit(o, c, at, t); audit.append({'target': f"{t}|{'/'.join(kv.values())}", 'result': ra, 'why': wa})
                if act == 'RESTORE':
                    ch = [k for k in names if str(c[k]) != str(o[k])]
                    cur.execute(f"UPDATE {t} SET {', '.join(f'{k}=:v{i}' for i, k in enumerate(ch))} WHERE {where}", {**kv, **{f'v{i}': o[k] for i, k in enumerate(ch)}})
                print(f'[restore_touched] {t} {list(kv.values())}: {act} {why}')
                if act == 'SKIP':
                    bad += 1
        cx.commit()
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'save_audit_cols.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, ['target', 'result', 'why']); w.writeheader(); w.writerows(audit)
    os.replace(fp, fp.replace('.json', '.done.json'))
    return 1 if bad else 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
