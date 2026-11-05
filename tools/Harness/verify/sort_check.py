# -*- coding: utf-8 -*-
"""결과 정렬(A6) 정적 대조 — AS-IS SP ORDER BY(sort_rules.csv) ↔ TO-BE PKG 프로시저 ORDER BY(사내오라클 ALL_SOURCE 새로 조회) (2026-10-26)

  python tools/Harness/verify/sort_check.py <MENU_ID> [--asis <AS-IS ID>]   → Doc/verify/<ID>/sort_check.csv

  TO-BE 원문은 매 실행 DB 에서 새로 읽는다(hook #152 — 로컬 사본 기준 금지). PROC_M(proc_meta.csv) 로 AS-IS SP → TO-BE 프로시저를 잇는다(이 화면 → 전 화면).
  TO-BE ORDER BY 해석: 주석 제거 후 프로시저 본문의 최상위(괄호 깊이 0) 마지막 ORDER BY. 키 'CASE WHEN <cond> THEN <key> END' 는 조건부 키 —
    AS-IS 분기 가드의 리터럴('R'/'C' 등)이 cond 에 들어 있으면 그 분기에서 유효한 키로 본다(SCP0007 Input Status 분기 패턴).
  판정: PASS(분기별 키 순서 동일) · FAIL(다름) · NA(AS-IS·TO-BE 모두 ORDER BY 없음) · REVIEW(AS-IS 없음·TO-BE 있음 = 임의 정렬 추가 / 키 해석 실패 / TO-BE 프로시저 미배선)
  TO-BE 가 AS-IS 뒤에 동률 고정 키를 덧붙인 경우(접미 추가, 예 ROUTE_ID NULLS FIRST)는 PASS 에 note 로 적는다 — 결정적 순서 보장은 AS-IS 의 미정 순서보다 엄격할 뿐 다르지 않다.
"""
import csv, os, re, sys, datetime, argparse
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
csv.field_size_limit(10 ** 8)
rdcsv = lambda p: list(csv.DictReader(open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []
COLS = ['menu_id', 'sp', 'asis_file', 'asis_line', 'guard', 'asis_keys', 'tobe_proc', 'tobe_last_ddl', 'tobe_order_by', 'tobe_keys', 'verdict', 'note']
tail = lambda s: re.sub(r'^(P_|UP_|SP_)', '', s.split('.')[-1].upper())


def asis_of(mid):
    for r in rdcsv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')):
        if r.get('tobe_id', '').upper() == mid: return r['asis_id'].upper()
    return mid


def strip_comments(sql):
    from facts_sortrules import strip_comments as sc
    return sc(sql)


def proc_body(src, proc):
    """패키지 본문에서 프로시저 구간(주석 제거본)"""
    m = re.search(r'(?i)\bPROCEDURE\s+' + re.escape(proc) + r'\b', src)
    if not m: return ''
    e = re.search(r'(?i)\bEND\s+' + re.escape(proc) + r'\s*;', src[m.start():])
    return src[m.start(): m.start() + (e.end() if e else 30000)]


def tobe_order_by(body):
    """최상위(깊이 0) 마지막 ORDER BY 절 — (원문, [(key, cond|None, desc)])"""
    best = None; depth = 0; i = 0; n = len(body); up = body.upper()
    while i < n:
        c = body[i]
        if c == '(': depth += 1
        elif c == ')': depth = max(0, depth - 1)
        elif depth == 0 and up.startswith('ORDER', i) and re.match(r'ORDER\s+BY\s', up[i:i + 12]):
            j = body.find(';', i); j = n if j < 0 else j
            best = body[i:j]
            i = j; continue
        i += 1
    if not best: return '', []
    txt = re.sub(r'(?i)^ORDER\s+BY\s+', '', best.strip())
    keys = []
    # 괄호 밖 콤마로 분할
    parts = []; d = 0; cur = ''
    for ch in txt:
        if ch == '(': d += 1
        if ch == ')': d -= 1
        if ch == ',' and d == 0: parts.append(cur); cur = ''
        else: cur += ch
    parts.append(cur)
    def _unwrap(p):
        """NLSSORT(A.COL, 'NLS_SORT=…') · UPPER(COL) · NVL(COL, '/') 같은 래퍼의 첫 인자를 키로(2026-10-29 SCP0041 'NLSSORT' 가 키로 잡혀 1번째 키부터 다름 허위 FAIL)"""
        for _ in range(3):
            m = re.match(r'(?i)^(NLSSORT|UPPER|LOWER|TRIM|LTRIM|RTRIM|NVL|NVL2|COALESCE|TO_CHAR|TO_NUMBER|TO_DATE|SUBSTR|CAST|DECODE|REGEXP_REPLACE|REGEXP_SUBSTR|TRANSLATE|REPLACE|LPAD|RPAD|ROUND|TRUNC|ABS|GREATEST|LEAST|INSTR|LENGTH)\s*\((.*)$', p.strip())
            if not m: return p
            inner = m.group(2); d = 0; out = ''
            for ch in inner:
                if ch == '(': d += 1
                elif ch == ')':
                    if d == 0: break
                    d -= 1
                elif ch == ',' and d == 0: break
                out += ch
            tail_ = inner[len(out):]
            p = out.strip() + (' DESC' if re.search(r'(?i)\bDESC\b', tail_) else '')
        return p
    for p in parts:
        p = ' '.join(p.split())
        if not p: continue
        desc = bool(re.search(r'(?i)\bDESC\b', p))
        p = _unwrap(p)
        m = re.match(r'(?i)^CASE\s+WHEN\s+(.*?)\s+THEN\s+([\w.]+)\s*(?:ELSE\s+\w+\s*)?END', p)
        if m: keys.append((m.group(2).split('.')[-1].upper(), m.group(1), desc)); continue
        m = re.match(r'^([\w.]+)', p)
        if m: keys.append((m.group(1).split('.')[-1].upper(), None, desc))
        else: keys.append((p[:40], 'UNPARSED', desc))
    return best.strip(), keys


def effective(tobe_keys, guard):
    """AS-IS 분기 가드에 맞는 TO-BE 유효 키 — 조건부 키는 가드 리터럴이 cond 에 있을 때만"""
    lits = set(re.findall(r"=\s*'([^']*)'", guard or ''))
    out = []
    for k, cond, desc in tobe_keys:
        if cond is None: out.append(k + (' DESC' if desc else ''))
        elif cond == 'UNPARSED': out.append(k)
        else:
            clits = set(re.findall(r"'([^']*)'", cond))
            if lits & clits: out.append(k + (' DESC' if desc else ''))
    return out


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); ap.add_argument('--asis', default='')
    a = ap.parse_args(); mid = a.menu.upper(); asis = (a.asis or asis_of(mid)).upper()
    rules = [r for r in rdcsv(os.path.join(DOC, 'asisfacts', 'screens', asis, 'sort_rules.csv')) if r['kind'] == 'SQL']
    if not rules:
        print(f'[INFO] sort_rules.csv 없음 — facts_sortrules.py {asis} 먼저'); return 2
    pm_all = [r for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if r.get('proc')]
    def tobe_proc(sp):
        for scope in ([r for r in pm_all if r.get('menu_id', '').upper() == mid], pm_all):
            hit = next((r['proc'] for r in scope if tail(r['proc']) == tail(sp)), '')
            if hit: return hit
        return ''
    from dbconn import connect
    cache = {}; out = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        def body_of(pkg):
            if pkg in cache: return cache[pkg]
            cur.execute("SELECT OWNER, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg)
            meta = cur.fetchone()
            if not meta: cache[pkg] = ('', ''); return cache[pkg]
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=meta[0], n=pkg)
            cache[pkg] = (strip_comments(''.join(r[0] for r in cur.fetchall())), meta[1]); return cache[pkg]
        by_sp = {}
        for r in rules: by_sp.setdefault(r['sp'], []).append(r)
        # CR-075(2026-10-28 사용자): 그리드에 표시되는 조회 SP = PROC_M 의 sheet 가 SHEET_COLUMNS 메타를 가진 시트. 결과 1행 집계·룩업 SP 는 대상 아님
        grid_sheets = {r['sheet_name'] for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'sheet_columns.csv')) if r.get('program_id', '').upper() == mid}
        sheet_of = {tail(r['proc']): r.get('sheet', '') for r in pm_all if r.get('menu_id', '').upper() == mid}
        gold = {tail(g.get('asis_sp', '')): g for g in rdcsv(os.path.join(DOC, 'golden', '_summary.csv')) if g.get('screen', '').upper() == mid}
        pkg_msgs = []  # MS1(메시지 의미 대조)용 — TO-BE PKG 본문이 쓰는 MSG ID
        for sp, rs in by_sp.items():
            tp = tobe_proc(sp)
            row = {'menu_id': mid, 'sp': sp, 'tobe_proc': tp}
            if not tp:
                for r in rs: out.append({**row, 'asis_file': r['file'], 'asis_line': r['line'], 'guard': r['guard'], 'asis_keys': r['keys'], 'tobe_last_ddl': '', 'tobe_order_by': '', 'tobe_keys': '', 'verdict': 'REVIEW', 'note': 'TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인'})
                continue
            pkg, proc = (tp.split('.') + [''])[:2] if '.' in tp else ('', tp)
            src, ddl = body_of(pkg) if pkg else ('', '')
            body = proc_body(src, proc) if src else ''
            ob, tkeys = tobe_order_by(body) if body else ('', [])
            asis_has = any(r['keys'] and str(r.get('depth', '0')) == '0' for r in rs)
            for r in rs:
                if r.get('depth') and str(r['depth']) != '0': continue  # 서브쿼리(TOP) 정렬은 결과 순서 규칙이 아니다
                base = {**row, 'asis_file': r['file'], 'asis_line': r['line'], 'guard': r['guard'], 'asis_keys': r['keys'], 'tobe_last_ddl': ddl, 'tobe_order_by': ' '.join(ob.split())[:300]}
                if not body: out.append({**base, 'tobe_keys': '', 'verdict': 'REVIEW', 'note': f'TO-BE 본문 없음(ALL_SOURCE {pkg}.{proc} 미발견)'}); continue
                if body and not any(m_['proc'] == proc for m_ in pkg_msgs): pkg_msgs.append({'pkg': pkg, 'proc': proc, 'msg_ids': ','.join(sorted(set(re.findall(r'MSG\d{5}', body))))})
                if not r['keys']:
                    if not tkeys:
                        sh = sheet_of.get(tail(sp), ''); g = gold.get(tail(sp), {}); nrows = int(g.get('asis_rows') or g.get('tobe_rows') or -1)
                        is_save = bool(re.search(r'(?i)_(SAVE|SET|INS|UPD|DEL|CHK|CHECK)', sp))
                        if is_save: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': '저장 SP — 결과 순서 대상 아님'})
                        elif sh and sh not in grid_sheets: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': f"AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M sheet '{sh}' 는 SHEET_COLUMNS 없음) → CR-075 대상 아님"})
                        elif 0 <= nrows <= 1: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': f'AS-IS·TO-BE 모두 ORDER BY 없음 — 결과 {nrows}행 집계 SP → CR-075 대상 아님'})
                        else: out.append({**base, 'tobe_keys': '', 'verdict': 'FAIL', 'note': f"TO-BE PKG 에 ORDER BY 없음(AS-IS 도 없음) — 그리드 표시 조회 SP 는 결정적 순서 필수(TO-BE 룰 CR-075 · 사용자 판정 2026-10-28) → PKG {pkg}.{proc} 에 ORDER BY 추가(DB 객체 보완)"})
                    elif 'ORDER BY 없음' in r['note']: out.append({**base, 'tobe_keys': ','.join(effective(tkeys, '')), 'verdict': 'PASS', 'note': 'AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰 CR-075 충족인'})
                    else: out.append({**base, 'tobe_keys': ','.join(effective(tkeys, r['guard'])), 'verdict': 'REVIEW', 'note': 'AS-IS 키 해석 실패 — 원문 확인: ' + r['raw'][:120]})
                    continue
                eff = effective(tkeys, r['guard']); want = [k.strip().upper() for k in r['keys'].split(',') if k.strip()]
                if eff == want: v, note = 'PASS', '분기 키 순서 동일' + (f" (가드 {r['guard'][:60]})" if r['guard'] else '')
                elif eff[:len(want)] == want: v, note = 'PASS', f"AS-IS 키 뒤에 동률 고정 키 추가 {eff[len(want):]} — 순서 보장 강화(다르지 않음)"
                else:
                    # 어디서 갈리는지
                    i = next((k for k in range(min(len(eff), len(want))) if eff[k] != want[k]), min(len(eff), len(want)))
                    v, note = 'FAIL', f"{i + 1}번째 키부터 다름: AS-IS {want[i:i + 3]} ↔ TO-BE {eff[i:i + 3]}" + (' · TO-BE 키 부족' if len(eff) < len(want) else '')
                out.append({**base, 'tobe_keys': ','.join(eff), 'verdict': v, 'note': note})
    od = os.path.join(DOC, 'verify', mid); os.makedirs(od, exist_ok=True)
    with open(os.path.join(od, 'tobe_pkg_msgs.csv'), 'w', encoding='utf-8-sig', newline='') as fp:  # MS1 메시지 의미 대조(judge) 입력
        w = csv.DictWriter(fp, fieldnames=['pkg', 'proc', 'msg_ids']); w.writeheader(); w.writerows(pkg_msgs)
    p = os.path.join(od, 'sort_check.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=COLS); w.writeheader(); [w.writerow({k: x.get(k, '') for k in COLS}) for x in out]
    import collections
    c = collections.Counter(x['verdict'] for x in out)
    print(f"{mid}: 정렬 대조 {len(out)}행 — " + ' · '.join(f'{k} {v}' for k, v in c.most_common()) + f" (TO-BE 원문 ZIOUI1 {datetime.datetime.now():%Y-%m-%d %H:%M} 조회) → {p}")
    for x in out:
        if x['verdict'] != 'PASS': print(f"  [{x['verdict']}] {x['sp']} → {x['tobe_proc']} | AS-IS {x['asis_keys'][:60]} | TO-BE {x['tobe_keys'][:60]} | {x['note'][:100]}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
