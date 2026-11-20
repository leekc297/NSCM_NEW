# -*- coding: utf-8 -*-
"""save_diff.py — EN-02 ③ 저장 SP 실행 대조 (2026-11-11 · 플랜 '추측 대신 실행' M1 · 사용자 승인 2026-11-11 "AS-IS DEV 저장 SP 트랜잭션+ROLLBACK 대조 허용")

화면이 실제로 보낸 저장 본문(사내 호출 로그 sqllog_calls.json)으로 AS-IS 저장 SP 와 TO-BE 저장 PROC 을 각각 **되돌릴 트랜잭션 안에서** 실행하고,
그 트랜잭션 안에서 바뀐 행을 읽어 양쪽을 대조한 뒤 ROLLBACK 한다. 끝나고 양쪽에 남은 행이 0 인지 다시 센다(잔여 증명).

대상   Doc/verify/_save_diff_targets.csv 의 TARGET_ROLLBACK 만(연계 표·메일·TO-BE COMMIT 경로는 제외 목록 그대로 제외)
안전   · 기본은 계획만 출력(--run 이 있어야 실행)
       · AS-IS 원문(피호출 포함)의 COMMIT 수 > BEGIN TRAN 수이면 제외(바깥 트랜잭션까지 확정될 수 있음)
       · AS-IS: 자동 확정 끔 + 바깥 BEGIN TRAN 2겹 → EXEC → @@TRANCOUNT 확인 → 측정 → 전부 ROLLBACK
       · TO-BE: 실행 직전 사내 PKG 원문(피호출 포함)에 확정 문장이 없음을 다시 확인 + 세션 `DISABLE COMMIT IN PROCEDURE`(확정 시도 = ORA-00034) → 실행 → 측정 → ROLLBACK
         (2026-11-11 15:43 사고: F10 검사 PASS 를 'COMMIT 없음'으로 써서 SCP0028 저장이 사내 DB 에 확정됨 → 복원 · T237)
       · 실행 전 기준 수(같은 조건으로 미리 센 수)와 ROLLBACK 뒤 수가 다르면 RESIDUE 로 즉시 중단(exit 4)
측정   AS-IS 원문의 DML 대상 표마다: 전후 COUNT(*) · 감사 컬럼(LAST_UPDATE_DATE ≥ 실행 직전 시각)으로 이번에 쓴 행(최대 200행)
       감사 컬럼이 없는 표는 행 수 변화만 잰다. 로그 표(_LOG·SYS_LOG)는 대조에서 빼고 수만 적는다.
판정   PASS       표마다 행 수 변화가 같고, 쓴 행의 공통 컬럼 값(감사 컬럼 제외)이 같다
       DIFF       같은 조건에서 행 수 변화 또는 값이 다르다
       ROWS_ONLY  한쪽만 0행을 썼다(= 두 DB 의 기존 데이터가 달라 같은 본문이 다른 일을 함 · 판정필요)
       SKIP       인자 미해결 · 저장 본문 포착 없음 · 안전 조건 미충족(사유 명시) — 통과로 세지 않는다
       ERR        실행 오류(양쪽 오류 문구를 그대로 적는다)

  python tools/Harness/verify/save_diff.py <MENU_ID>            계획만(무엇을 어떤 본문으로 실행할지 · 제외 사유)
  python tools/Harness/verify/save_diff.py <MENU_ID> --run [--max 2]   실행(PROC 마다 서로 다른 본문 최근 N건)
  python tools/Harness/verify/save_diff.py <MENU_ID> --run --snapshot   확정 문장이 있는 TO-BE 저장 PROC 도 실행: 실제 저장 → 실행 전 SCN 과 대조 → 그 값으로 복원 → 차이 0 확인
        (사용자 승인 2026-11-11 · 표마다 트리거 0 · LOB 0 · 20만 행 이하 · 다른 계정 변경 0 일 때만 · 로그 표는 남김)
  python tools/Harness/verify/save_diff.py --selftest
출력: Doc/verify/<ID>/save_diff/summary.csv · <PROC>__<n>.md · 종료코드 0 / 2(DIFF·ERR 있음) / 3(실행 0건) / 4(RESIDUE — 잔여 발견)
"""
import csv, json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
csv.field_size_limit(10 ** 8)
AUDIT = {'CREATION_DATE', 'LAST_UPDATE_DATE', 'CREATED_BY', 'LAST_UPDATED_BY', 'CREATE_DATE', 'UPDATE_DATE'}
RX_LOG = re.compile(r'(_LOG$|SYS_LOG|_LOG_)', re.I)
COLS = ['call_no', 'asis_sp', 'tobe_proc', 'log_seq', 'log_at', 'verdict', 'note', 'tables', 'asis_effect', 'tobe_effect', 'asis_msg', 'tobe_msg', 'residue', 'md', 'measured_at']


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def strip_comments(t):
    t = re.sub(r'/\*.*?\*/', ' ', t, flags=re.S)
    return re.sub(r'--[^\n]*', ' ', t)


def tran_balance(text):
    """(BEGIN TRAN 수, COMMIT 수) — 주석 제외. COMMIT 이 더 많으면 바깥 트랜잭션이 확정될 수 있다"""
    b = strip_comments(text or '')
    b = re.sub(r"'(?:[^']|'')*'", "''", b)  # 문자열 안의 문구 제외(2026-11-11 실측: PRINT 'AFTER COMMIT TRAN' 을 COMMIT 으로 세어 16건이 잘못 제외됐다)
    begins = len(re.findall(r'\bBEGIN\s+TRAN(?:SACTION)?\b', b, re.I))
    commits = len(re.findall(r'\bCOMMIT\b(?!\s*;?\s*--)', b, re.I))
    return begins, commits


def norm_val(v):
    if v is None:
        return ''
    s = str(v).strip()
    if re.fullmatch(r'-?\d+\.0+', s):
        s = s.split('.')[0]
    if re.fullmatch(r'-?\d+\.\d*?0+', s):
        s = s.rstrip('0').rstrip('.')
    return '' if s in ('-', '/') else s


def runtime_stamp(ra, rt, col, run_start):
    """그 컬럼 값이 양쪽 모두 '이번 실행 시각 이후의 일시'뿐인가 — 실행할 때 찍히는 시각 컬럼(값이 같을 수 없다)"""
    if not run_start:
        return False
    vals = [str(r.get(col) or '') for r in (ra or []) + (rt or [])]
    if not vals or any(not v for v in vals):
        return False
    return all(re.match(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', v) and v[:19] >= run_start for v in vals)


def load_identity_cols():
    """AS-IS 표의 IDENTITY 컬럼(Doc/asisfacts/db/db_columns.csv is_identity=1) — 자동 일련번호라 값 대조 대상이 아니다"""
    out = {}
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'db_columns.csv')
    if os.path.exists(p):
        with open(p, encoding='utf-8-sig', newline='', errors='replace') as f:
            for r in csv.DictReader(f):
                if (r.get('is_identity') or '') == '1':
                    out.setdefault((r.get('object_name') or '').upper(), set()).add((r.get('column_name') or '').upper())
    return out


def new_serial(ra, rt, tb, col, seq_probe):
    """일련번호 컬럼인가(실측): 양쪽 값이 서로 다르고, 쓴 값이 모두 숫자이며 각자 그 표의 기존 최댓값(seq_probe)보다 크다 = DB 상태에서 새로 발번된 번호"""
    if not seq_probe or not ra or not rt:
        return False
    va = [str(r.get(col) or '') for r in ra]
    vt = [str(r.get(col) or '') for r in rt]
    if sorted(va) == sorted(vt) or not all(re.fullmatch(r'\d+', v) for v in va + vt):
        return False
    mx = seq_probe(tb, col)
    if not mx or mx[0] is None or mx[1] is None:
        return False
    return all(int(v) > int(mx[0]) for v in va) and all(int(v) > int(mx[1]) for v in vt)


def effect_compare(a, t, identity_cols=None, run_start='', seq_probe=None):
    """a·t = {table: {'delta': int|None, 'rows': [dict(col→val)]|None, 'cols': [..]}} → (verdict, 설명 목록)"""
    notes, worst = [], 'PASS'
    rank = {'PASS': 0, 'ROWS_ONLY': 1, 'DIFF': 2}

    def bump(v):
        nonlocal worst
        if rank[v] > rank[worst]:
            worst = v
    for tb in sorted(set(a) | set(t)):
        if RX_LOG.search(tb):
            notes.append(f"{tb}: 로그 표 — 대조 제외(행 수 변화 AS-IS {a.get(tb, {}).get('delta')} / TO-BE {t.get(tb, {}).get('delta')})")
            continue
        ea, et = a.get(tb), t.get(tb)
        if ea is None or et is None:
            notes.append(f"{tb}: {'TO-BE' if et is None else 'AS-IS'} 에 표 없음 — 대조 불가(미측정)")
            bump('ROWS_ONLY')
            continue
        da, dt = ea.get('delta'), et.get('delta')
        ra, rt = ea.get('rows'), et.get('rows')
        na = len(ra) if ra is not None else None
        nt = len(rt) if rt is not None else None
        if da is not None and dt is not None and da != dt:
            if (na == 0) != (nt == 0) and na is not None and nt is not None:
                notes.append(f"{tb}: 행 수 변화 AS-IS {da:+d} / TO-BE {dt:+d} · 쓴 행 AS-IS {na} / TO-BE {nt} — 한쪽만 0행(기존 데이터 차이 가능)")
                bump('ROWS_ONLY')
            else:
                notes.append(f"{tb}: 행 수 변화 다름 AS-IS {da:+d} / TO-BE {dt:+d}")
                bump('DIFF')
            continue
        if ra is None or rt is None:
            notes.append(f"{tb}: 행 수 변화 같음({da}) · 감사 컬럼 없음 — 값 대조 미측정")
            continue
        if (na == 0) != (nt == 0):
            notes.append(f"{tb}: 쓴 행 AS-IS {na} / TO-BE {nt} — 한쪽만 0행(기존 데이터 차이 가능)")
            bump('ROWS_ONLY')
            continue
        common = [c for c in ea.get('cols', []) if c in set(et.get('cols', [])) and c not in AUDIT]
        gen = sorted(c for c in common if c in (identity_cols or {}).get(tb, set()) or runtime_stamp(ra, rt, c, run_start) or new_serial(ra, rt, tb, c, seq_probe))
        if gen:
            common = [c for c in common if c not in gen]
        ka = sorted(tuple(norm_val(r.get(c)) for c in common) for r in ra)
        kt = sorted(tuple(norm_val(r.get(c)) for c in common) for r in rt)
        if ka == kt:
            notes.append(f"{tb}: 쓴 행 {na}행 · 공통 컬럼 {len(common)}개 값 일치 · 행 수 변화 {da}" + (f" · 대조 제외(일련번호·실행 시각) {gen}" if gen else ''))
        else:
            only_a = [x for x in ka if x not in kt][:2]
            only_t = [x for x in kt if x not in ka][:2]
            dc = []
            if len(ka) == len(kt):
                for x, y in zip(ka, kt):
                    dc += [common[i] for i in range(len(common)) if x[i] != y[i]]
            notes.append(f"{tb}: 쓴 행 값 다름 AS-IS {na} / TO-BE {nt}행 · 다른 컬럼 {sorted(set(dc))[:8]} · AS-IS 예 {only_a} / TO-BE 예 {only_t}"[:900])
            bump('DIFF')
    return worst, notes


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    t('BEGIN TRAN 1 · COMMIT 1 = 균형', tran_balance("BEGIN TRAN; UPDATE T SET A=1; COMMIT TRAN;") == (1, 1))
    t('주석 안 COMMIT 은 세지 않는다', tran_balance("BEGIN TRAN; -- COMMIT WORK;\n/* COMMIT */ COMMIT TRAN") == (1, 1))
    t('문자열 안의 COMMIT·BEGIN TRAN 은 세지 않는다', tran_balance("BEGIN TRAN X; PRINT 'AFTER COMMIT TRAN'; COMMIT TRAN X; PRINT 'AFTER BEGIN TRAN2'") == (1, 1))
    t('BEGIN 없는 COMMIT(변이) = 불균형 검출', tran_balance("UPDATE T SET A=1; COMMIT;")[1] > tran_balance("UPDATE T SET A=1; COMMIT;")[0])
    R = lambda **k: dict(k)
    a = {'T1': {'delta': 0, 'rows': [R(K='1', V='10.0', LAST_UPDATE_DATE='x')], 'cols': ['K', 'V', 'LAST_UPDATE_DATE']}}
    b = {'T1': {'delta': 0, 'rows': [R(K='1', V='10', LAST_UPDATE_DATE='y')], 'cols': ['K', 'V', 'LAST_UPDATE_DATE']}}
    t('같은 행·감사 컬럼만 다름 → PASS(숫자 표기 10.0=10)', effect_compare(a, b)[0] == 'PASS')
    b2 = {'T1': {'delta': 0, 'rows': [R(K='1', V='11')], 'cols': ['K', 'V']}}
    t('값이 다름(변이) → DIFF', effect_compare(a, b2)[0] == 'DIFF')
    b3 = {'T1': {'delta': 1, 'rows': [R(K='1', V='10')], 'cols': ['K', 'V']}}
    t('행 수 변화 다름(변이) → DIFF', effect_compare(a, b3)[0] == 'DIFF')
    b4 = {'T1': {'delta': 0, 'rows': [], 'cols': ['K', 'V']}}
    t('한쪽만 0행 → ROWS_ONLY(통과 아님)', effect_compare(a, b4)[0] == 'ROWS_ONLY')
    t('한쪽에 표 없음 → ROWS_ONLY(미측정 표시)', effect_compare(a, {})[0] == 'ROWS_ONLY')
    lg = {'SCM_SYS_LOG_BATCH': {'delta': 1, 'rows': None, 'cols': []}}
    t('로그 표 차이는 판정에서 제외', effect_compare(dict(a, **lg), dict(b, SCM_SYS_LOG_BATCH={'delta': 0, 'rows': None, 'cols': []}))[0] == 'PASS')
    na = {'T1': {'delta': 2, 'rows': None, 'cols': []}}
    v, n = effect_compare(na, {'T1': {'delta': 2, 'rows': None, 'cols': []}})
    t('감사 컬럼 없는 표 = 행 수만 같으면 PASS 이되 값 미측정 표기', v == 'PASS' and '미측정' in n[0])
    hA = {'H': {'delta': 1, 'rows': [R(SEQ='10', K='1', AT='2026-11-11 16:00:02.100')], 'cols': ['SEQ', 'K', 'AT']}}
    hT = {'H': {'delta': 1, 'rows': [R(SEQ='99', K='1', AT='2026-11-11 16:00:03')], 'cols': ['SEQ', 'K', 'AT']}}
    t('일련번호(IDENTITY 사실)·실행 시각 컬럼은 값 대조에서 제외 → PASS', effect_compare(hA, hT, {'H': {'SEQ'}}, '2026-11-11 16:00:00')[0] == 'PASS')
    t('IDENTITY 사실이 없으면 일련번호 차이는 DIFF 그대로(임의로 빼지 않음)', effect_compare(hA, hT, {}, '2026-11-11 16:00:00')[0] == 'DIFF')
    hT2 = {'H': {'delta': 1, 'rows': [R(SEQ='99', K='2', AT='2026-11-11 16:00:03')], 'cols': ['SEQ', 'K', 'AT']}}
    t('제외 뒤에도 업무 값이 다르면 DIFF(변이)', effect_compare(hA, hT2, {'H': {'SEQ'}}, '2026-11-11 16:00:00')[0] == 'DIFF')
    hT3 = {'H': {'delta': 1, 'rows': [R(SEQ='99', K='1', AT='2020-01-01 00:00:00')], 'cols': ['SEQ', 'K', 'AT']}}
    t('실행 전 시각 값이 섞인 일시 컬럼은 제외하지 않는다', effect_compare(hA, hT3, {'H': {'SEQ'}}, '2026-11-11 16:00:00')[0] == 'DIFF')
    t('새로 발번된 일련번호(양쪽 기존 최댓값보다 큼 · 실측) → 대조 제외 PASS', effect_compare(hA, hT, {}, '2026-11-11 16:00:00', lambda tb, c: (9, 98))[0] == 'PASS')
    t('기존 최댓값보다 크지 않은 번호 차이는 DIFF(변이)', effect_compare(hA, hT, {}, '2026-11-11 16:00:00', lambda tb, c: (50, 98))[0] == 'DIFF')
    t('최댓값을 못 재면 제외하지 않는다', effect_compare(hA, hT, {}, '2026-11-11 16:00:00', lambda tb, c: None)[0] == 'DIFF')
    t('숫자·센티널 정규화', norm_val('12.50') == '12.5' and norm_val('-') == '' and norm_val(None) == '')
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


# ───────────────────────── 실행부 ─────────────────────────
def asis_cols(cur, tb):
    cur.execute("SELECT UPPER(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ? ORDER BY ORDINAL_POSITION", tb)
    return [r[0] for r in cur.fetchall()]


def tobe_cols(cur, tb):
    cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = :1 ORDER BY COLUMN_ID", [tb])
    return [r[0] for r in cur.fetchall()]


def measure(cur, side, tb, cols, t0, users, fetch_rows):
    """(count, touched_n, rows|None) — side 'asis'|'tobe'. cols 가 비면 표 없음 → None"""
    if not cols:
        return None
    q = f"[{tb}]" if side == 'asis' else f"SCM_MGR.{tb}"
    cur.execute(f"SELECT COUNT(*) FROM {q}")
    cnt = cur.fetchone()[0]
    if 'LAST_UPDATE_DATE' not in cols:
        return cnt, None, None
    w = "LAST_UPDATE_DATE >= ?" if side == 'asis' else "LAST_UPDATE_DATE >= :t0"
    args = [t0]
    us = [u for u in users if u]
    if side == 'tobe' and 'LAST_UPDATED_BY' in cols and us:
        w += " AND LAST_UPDATED_BY IN (" + ', '.join(f":u{i}" for i in range(len(us))) + ")"
        args += us
    cur.execute(f"SELECT COUNT(*) FROM {q} WHERE {w}", args)
    n = cur.fetchone()[0]
    rows = None
    if fetch_rows:
        top = "TOP 200 " if side == 'asis' else ''
        tail = '' if side == 'asis' else ' FETCH FIRST 200 ROWS ONLY'
        cur.execute(f"SELECT {top}* FROM {q} WHERE {w}{tail}", args)
        names = [d[0].upper() for d in cur.description]
        rows = [dict(zip(names, r)) for r in cur.fetchall()]
    return cnt, n, rows


def run_asis(cx, sp, aps, tables, users):
    """반환 {'effect': {...}, 'msg': str, 'err': str, 'residue': {tb: n}, 'trancount': n}"""
    out = {'effect': {}, 'msg': '', 'err': '', 'residue': {}, 'trancount': None}
    cx.autocommit = False
    cur = cx.cursor()
    cols = {tb: asis_cols(cur, tb) for tb in tables}
    cur.execute("SELECT DATEADD(second, -1, SYSDATETIME())")
    t0 = cur.fetchone()[0]
    base = {tb: measure(cur, 'asis', tb, cols[tb], t0, users, False) for tb in tables}
    cx.rollback()
    try:
        cur.execute("BEGIN TRAN")
        cur.execute("BEGIN TRAN")
        ps = list(aps.items())
        try:
            cur.execute(f"EXEC dbo.[{sp}] " + ', '.join(f'@{k}=?' for k, _ in ps), [v for _, v in ps])
            msgs = []
            while True:
                if cur.description:
                    names = [d[0] for d in cur.description]
                    for r in cur.fetchmany(5):
                        msgs.append(dict(zip(names, [str(x)[:120] for x in r])))
                if not cur.nextset():
                    break
            out['msg'] = json.dumps(msgs, ensure_ascii=False)[:600]
        except Exception as e:  # noqa: BLE001 — SP 오류도 결과다(문구 그대로)
            out['err'] = str(e).splitlines()[0][:400]
        cur = cx.cursor()
        try:
            cur.execute("SELECT @@TRANCOUNT")
            out['trancount'] = cur.fetchone()[0]
        except Exception as e:  # noqa: BLE001
            out['err'] = (out['err'] + ' · @@TRANCOUNT 조회 실패 ' + str(e)[:120]).strip(' ·')
        if not out['err']:
            for tb in tables:
                m = measure(cur, 'asis', tb, cols[tb], t0, users, True)
                b = base[tb]
                if m is None or b is None:
                    continue
                out['effect'][tb] = {'delta': m[0] - b[0], 'rows': m[2], 'cols': cols[tb], 'base_touched': b[1]}
    finally:
        try:
            cx.cursor().execute("WHILE @@TRANCOUNT > 0 ROLLBACK TRAN")
        except Exception:  # noqa: BLE001
            pass
        cx.rollback()
    cur = cx.cursor()
    for tb in tables:
        m = measure(cur, 'asis', tb, cols[tb], t0, users, False)
        b = base[tb]
        if m is not None and b is not None and (m[0] != b[0] or (m[1] or 0) != (b[1] or 0)):
            out['residue'][tb] = f"행 수 {b[0]}→{m[0]} · 이번 시각 이후 쓴 행 {b[1]}→{m[1]}"
    cx.rollback()
    return out


def run_tobe(cx, proc, body, tables, users, golden, bind):
    out = {'effect': {}, 'msg': '', 'err': '', 'residue': {}}
    cur = cx.cursor()
    # 2026-11-11 T237 안전망: PROC 안의 COMMIT·ROLLBACK 을 세션에서 차단(ORA-00034) — 원문 실측이 놓친 확정 문장이 있어도 확정되지 않고 오류로 끝난다
    cur.execute("ALTER SESSION DISABLE COMMIT IN PROCEDURE")
    cols = {tb: tobe_cols(cur, tb) for tb in tables}
    cur.execute("SELECT SYSDATE - 1/86400 FROM DUAL")
    t0 = cur.fetchone()[0]
    base = {tb: measure(cur, 'tobe', tb, cols[tb], t0, users, False) for tb in tables}
    cx.rollback()
    try:
        try:
            sets, missing = golden.run_tobe(cx, proc, bind(cx, proc, body))
            msgs = [{'cursor': s[0], 'rows': [dict(zip(s[1], [str(x)[:120] for x in r])) for r in s[2][:5]]} for s in sets]
            out['msg'] = (json.dumps(msgs, ensure_ascii=False)[:600] + (f" · NULL 전달 인자 {missing}" if missing else ''))
        except Exception as e:  # noqa: BLE001
            out['err'] = str(e).splitlines()[0][:400]
        if not out['err']:
            cur = cx.cursor()
            for tb in tables:
                m = measure(cur, 'tobe', tb, cols[tb], t0, users, True)
                b = base[tb]
                if m is None or b is None:
                    continue
                out['effect'][tb] = {'delta': m[0] - b[0], 'rows': m[2], 'cols': cols[tb], 'base_touched': b[1]}
    finally:
        cx.rollback()
    cur = cx.cursor()
    for tb in tables:
        m = measure(cur, 'tobe', tb, cols[tb], t0, users, False)
        b = base[tb]
        if m is not None and b is not None and (m[0] != b[0] or (m[1] or 0) != (b[1] or 0)):
            out['residue'][tb] = f"행 수 {b[0]}→{m[0]} · 이번 시각 이후 쓴 행 {b[1]}→{m[1]}"
    cx.rollback()
    return out


RX_TOBE_DML = re.compile(r'\b(INSERT\s+INTO|UPDATE|DELETE\s+FROM|DELETE|MERGE\s+INTO)\s+((?:SCM_MGR\.)?[A-Z][A-Z0-9_$#]*)', re.I)
MAX_SNAP_ROWS = 200000


def tobe_dml_tables(source_of, sdt, proc, depth=0, seen=None):
    """사내 원문으로 TO-BE PROC(피호출 재귀)이 쓰는 표 — (tables set, unread list)"""
    seen = seen if seen is not None else set()
    key = proc.upper()
    if key in seen or depth > 4:
        return set(), []
    seen.add(key)
    pkg, _, name = key.rpartition('.')
    src = source_of(pkg or None, name)
    if src is None:
        return set(), [key]
    blk = sdt.proc_block(src, name) if pkg else sdt.ora_strip(src)
    if not blk:
        return set(), [key]
    tabs = set()
    for m in RX_TOBE_DML.finditer(blk):
        n = m.group(2).split('.')[-1].upper()
        if n not in ('SET', 'FROM', 'INTO', 'TABLE', 'SELECT'):
            tabs.add(n)
    unread = []
    for c in dict.fromkeys(x.upper() for x in sdt.RX_TOBE_CALL.findall(blk)):
        if c in (name, key):
            continue
        callee = c if '.' in c else ((f'{pkg}.{c}') if pkg and sdt.proc_block(src, c) else c)
        t2, u2 = tobe_dml_tables(source_of, sdt, callee, depth + 1, seen)
        tabs |= t2
        unread += u2
    return tabs, unread


def snapshot_precheck(cur, tables):
    """복원 가능한 표인가 — 반환 (ok, 사유). 로그 표는 복원 대상이 아니다(남김)"""
    for tb in tables:
        if RX_LOG.search(tb):
            continue
        cur.execute("""SELECT (SELECT COUNT(*) FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = :t AND temporary = 'N'),
                              (SELECT COUNT(*) FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = :t AND temporary = 'Y'),
                              (SELECT COUNT(*) FROM all_triggers WHERE table_owner = 'SCM_MGR' AND table_name = :t AND status = 'ENABLED'),
                              (SELECT COUNT(*) FROM all_tab_columns WHERE owner = 'SCM_MGR' AND table_name = :t AND data_type IN ('CLOB', 'BLOB', 'NCLOB', 'LONG', 'LONG RAW', 'XMLTYPE'))
                         FROM DUAL""", t=tb)
        perm, gtt, trg, lob = cur.fetchone()
        if gtt:
            continue   # 임시 표 — 세션 한정이라 복원 대상 아님
        if not perm:
            return False, f'{tb}: 사내에 표 없음(이름이 다른 객체일 수 있음 — 복원 대상 확정 불가)'
        if trg:
            return False, f'{tb}: 사용 중 트리거 {trg}개 — 복원 시 부작용 가능'
        if lob:
            return False, f'{tb}: LOB/LONG 컬럼 {lob}개 — 전후 대조 불가'
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{tb}")
        n = cur.fetchone()[0]
        if n > MAX_SNAP_ROWS:
            return False, f'{tb}: {n}행 > 상한 {MAX_SNAP_ROWS} — 전후 대조·복원 비용이 커서 미지원'
    return True, ''


def run_tobe_snapshot(cx, proc, body, tables, users, golden, bind):
    """실제 저장(확정됨) → 실행 전 SCN 과 대조해 바뀐 행 측정 → 그 SCN 값으로 복원 → 실행 전과 차이 0 확인.
    반환 {'effect', 'msg', 'err', 'residue', 'restored'} — residue 가 비어 있지 않으면 호출자가 즉시 중단한다"""
    out = {'effect': {}, 'msg': '', 'err': '', 'residue': {}, 'restored': {}}
    cur = cx.cursor()
    data = [tb for tb in tables if not RX_LOG.search(tb)]
    perm = []
    for tb in data:
        cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = :t AND temporary = 'N'", t=tb)
        if cur.fetchone()[0]:
            perm.append(tb)
    cols = {tb: tobe_cols(cur, tb) for tb in perm}
    cur.execute("SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL")
    scn0 = cur.fetchone()[0]
    cx.rollback()
    try:
        sets, missing = golden.run_tobe(cx, proc, bind(cx, proc, body))
        msgs = [{'cursor': s[0], 'rows': [dict(zip(s[1], [str(x)[:120] for x in r])) for r in s[2][:5]]} for s in sets]
        out['msg'] = (json.dumps(msgs, ensure_ascii=False)[:600] + (f" · NULL 전달 인자 {missing}" if missing else ''))
    except Exception as e:  # noqa: BLE001
        out['err'] = str(e).splitlines()[0][:400]
    cx.rollback()   # PROC 이 확정하지 않은 부분이 있으면 여기서 되돌린다(확정분은 아래에서 복원)
    us = [u for u in users if u]
    for tb in perm:
        q = f"SCM_MGR.{tb}"
        asof = f"{q} AS OF SCN {int(scn0)}"
        cur.execute(f"SELECT * FROM {q} MINUS SELECT * FROM {asof}")
        names = [d[0].upper() for d in cur.description]
        ins = [dict(zip(names, r)) for r in cur.fetchmany(500)]
        cur.execute(f"SELECT COUNT(*) FROM (SELECT * FROM {q} MINUS SELECT * FROM {asof})")
        n_ins = cur.fetchone()[0]
        cur.execute(f"SELECT COUNT(*) FROM (SELECT * FROM {asof} MINUS SELECT * FROM {q})")
        n_del = cur.fetchone()[0]
        cur.execute(f"SELECT (SELECT COUNT(*) FROM {q}) - (SELECT COUNT(*) FROM {asof}) FROM DUAL")
        delta = cur.fetchone()[0]
        out['effect'][tb] = {'delta': delta, 'rows': ins[:200], 'cols': cols[tb], 'n_new_images': n_ins, 'n_old_images': n_del}
        if not n_ins and not n_del:
            continue
        # 다른 사용자의 변경이 섞였는지 — 감사 컬럼이 있으면 이번 계정이 쓴 행만 있어야 한다
        foreign = 0
        if 'LAST_UPDATED_BY' in cols[tb] and us:
            foreign = sum(1 for r in ins if str(r.get('LAST_UPDATED_BY') or '') not in us and str(r.get('CREATED_BY') or '') not in us)
        if foreign or n_ins > 500:
            out['residue'][tb] = f"복원 보류 — 바뀐 행 {n_ins}(새 값)·{n_del}(이전 값) 중 다른 계정 행 {foreign} 또는 500행 초과 · 실행 전 SCN {scn0}"
            continue
        try:
            same = ' AND '.join(f'DECODE(n."{c}", o."{c}", 1, 0) = 1' for c in cols[tb])
            # 실행 전과 값이 달라졌거나(같은 ROWID) 새로 생긴 행만 지운다 — 2026-11-11 첫 실행에서 ORA_ROWSCN(블록 단위)만 쓰니 표 전체 1007행을 지웠다 재삽입했다
            cur.execute(f"DELETE FROM {q} n WHERE NOT EXISTS (SELECT 1 FROM {asof} o WHERE o.ROWID = n.ROWID AND {same})")
            d = cur.rowcount
            cur.execute(f"INSERT INTO {q} SELECT * FROM {asof} o WHERE o.ROWID NOT IN (SELECT ROWID FROM {q})")
            i = cur.rowcount
            cur.execute(f"SELECT (SELECT COUNT(*) FROM (SELECT * FROM {q} MINUS SELECT * FROM {asof})) + (SELECT COUNT(*) FROM (SELECT * FROM {asof} MINUS SELECT * FROM {q})) FROM DUAL")
            left = cur.fetchone()[0]
            if left == 0:
                cx.commit()
                out['restored'][tb] = f"삭제 {d} · 재삽입 {i} · 실행 전과 차이 0"
            else:
                cx.rollback()
                out['residue'][tb] = f"복원 시도 후에도 실행 전과 차이 {left}행 — 복원 취소(ROLLBACK) · 실행 전 SCN {scn0}"
        except Exception as e:  # noqa: BLE001
            cx.rollback()
            out['residue'][tb] = f"복원 오류 {str(e).splitlines()[0][:160]} · 실행 전 SCN {scn0}"
    return out


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__)
        return 3
    mid = a[0].upper().strip('/')
    if not re.fullmatch(r'[A-Z0-9_]+', mid):
        print(f'[save_diff] 화면 ID 형식 아님: {mid}')
        return 3
    do_run = '--run' in a
    do_snap = '--snapshot' in a   # 사용자 승인 2026-11-11: 확정 문장이 있는 TO-BE 저장 PROC 은 실제 저장 후 실행 전 SCN 값으로 복원
    mx = int(a[a.index('--max') + 1]) if '--max' in a else 2
    import save_diff_targets as sdt
    import diff_verify as dv
    targets = [r for r in rd(os.path.join(ROOT, 'Doc', 'verify', '_save_diff_targets.csv')) if r['menu_id'].upper() == mid]
    if not targets:
        print(f'[save_diff] {mid}: 대상 목록에 이 화면 없음 — save_diff_targets.py 먼저')
        return 3
    try:
        calls = [c for c in json.load(open(os.path.join(ROOT, 'Doc', 'verify', mid, 'sqllog_calls.json'), encoding='utf-8')).get('calls', []) if c.get('kind') == 'SAVE' and c.get('params_parsed')]
    except (OSError, ValueError):
        calls = []
    pmap = {}
    for r in rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'param_map.csv')):
        pmap.setdefault((r.get('tobe_proc') or '').upper(), []).append(r)
    plan = []
    for tg in targets:
        proc, sp = tg['tobe_proc'], tg['asis_sp']
        if tg['decision'] == 'TARGET_SNAPSHOT' and not do_snap:
            plan.append((tg, None, f"제외 — {tg['decision']}: {tg['reason'][:140]} (실제 저장 후 복원 방식 = --snapshot)"))
            continue
        if tg['decision'] not in ('TARGET_ROLLBACK', 'TARGET_SNAPSHOT'):
            plan.append((tg, None, f"제외 — {tg['decision']}: {tg['reason'][:140]}"))
            continue
        sc = sdt.scan(sp)
        texts = [sdt.default_reader(x) or '' for x in [sp] + list(dict.fromkeys(sc['callees']))]
        bg = sum(tran_balance(x)[0] for x in texts)
        cm = sum(tran_balance(x)[1] for x in texts)
        if cm > bg:
            plan.append((tg, None, f"제외 — AS-IS 원문 COMMIT {cm} > BEGIN TRAN {bg}(바깥 트랜잭션 확정 위험)"))
            continue
        mine, seen = [], set()
        for c in sorted([c for c in calls if c['proc'] == proc.upper()], key=lambda c: -c['seq']):
            k = json.dumps(c['fe'], ensure_ascii=False, sort_keys=True)
            if k not in seen:
                seen.add(k)
                mine.append(c)
        if not mine:
            plan.append((tg, None, 'SKIP — 호출 로그에 이 PROC 의 저장 본문 없음(E2E 저장 시험이 없었거나 수집 시각대 밖 · sqllog_calls.py)'))
            continue
        for c in mine[:mx]:
            plan.append((tg, c, sorted(sc['dml'])))
    print(f"[save_diff] {mid}: 저장 SP 짝 {len(targets)}건 · 실행 계획 {sum(1 for p in plan if p[1])}건 · 제외/SKIP {sum(1 for p in plan if not p[1])}건")
    for tg, c, info in plan:
        if c:
            print(f"   실행 {tg['asis_sp']} ↔ {tg['tobe_proc']} · 로그 #{c['seq']} {c['at']} {c['by']} · 대상 표 {info}")
            print(f"        본문 {json.dumps(c['fe'], ensure_ascii=False)[:260]}")
        else:
            print(f"   {tg['asis_sp']}: {info}")
    if not do_run:
        print('[save_diff] 계획만 출력했다(실행 없음). 실행 = --run')
        return 0 if any(p[1] for p in plan) else 3
    import dbconn, golden
    od = os.path.join(ROOT, 'Doc', 'verify', mid, 'save_diff')
    os.makedirs(od, exist_ok=True)
    cfg = dbconn.load_cfg()
    ca = dbconn.connect('asis', cfg)
    ct = dbconn.connect('tobe', cfg)
    live_src = sdt.live_source_reader()
    cs = dbconn.connect('tobe', cfg)   # 복원 방식 전용 접속(확정 차단 설정을 걸지 않는다)
    rows, n, residue_hit = [], 0, False
    idc = load_identity_cols()
    try:
        for tg, c, info in plan:
            n += 1
            now = time.strftime('%Y-%m-%d %H:%M:%S')
            row = {'call_no': n, 'asis_sp': tg['asis_sp'], 'tobe_proc': tg['tobe_proc'], 'measured_at': now, 'log_seq': c['seq'] if c else '', 'log_at': c['at'] if c else ''}
            if not c:
                row.update(verdict='SKIP', note=str(info))
                rows.append(row)
                continue
            body = dict(c['fe'], **(c.get('ses') or {}))
            aps, unresolved, notes = dv.translate(body, pmap.get(tg['tobe_proc'].upper(), []))
            short = re.sub(r'^PKG_\w+\.', '', tg['tobe_proc'])
            md = [f"# {mid} 저장 대조 · {tg['asis_sp']} ↔ {tg['tobe_proc']}", '', f"- 실행 {now} · 본문 = 사내 호출 로그 #{c['seq']} ({c['at']} · {c['by']})",
                  f"- TO-BE 본문: `{json.dumps(body, ensure_ascii=False)[:1500]}`", f"- AS-IS 인자(번역): `{json.dumps(aps, ensure_ascii=False)[:1500]}`"]
            if unresolved:
                row.update(verdict='SKIP', note='인자 미해결: ' + ','.join(unresolved))
                rows.append(row)
                continue
            # 2026-11-11 T237: 실행 직전에 사내 원문을 다시 읽어 확정 문장이 없음을 확인(목록 파일을 믿지 않는다)
            try:
                marks, unread = sdt.tobe_commit_scan(live_src, tg['tobe_proc'])
            except Exception as ex:  # noqa: BLE001
                marks, unread = [], [f'원문 조회 실패 {str(ex)[:80]}']
            snap = bool(marks) and do_snap and not unread
            if (marks or unread) and not snap:
                row.update(verdict='SKIP', note=('TO-BE 원문에 확정 문장 ' + str(sorted({m for m, _ in marks})) if marks else f'TO-BE 원문 미독 {unread[:3]}') + ' — 실행하지 않음')
                rows.append(row)
                print(f"   [SKIP] #{n} {tg['asis_sp']} — {row['note']}")
                continue
            tables = [tb for tb in info if re.fullmatch(r'[A-Z0-9_]+', tb)]
            if snap:
                # TO-BE 가 실제로 쓰는 표(사내 원문) ∪ AS-IS 원문의 표 — 전부 복원 가능해야 실행한다
                try:
                    tt, tun = tobe_dml_tables(live_src, sdt, tg['tobe_proc'])
                except Exception as ex:  # noqa: BLE001
                    tt, tun = set(), [str(ex)[:80]]
                tables = sorted(set(tables) | {x for x in tt if re.fullmatch(r'[A-Z0-9_$#]+', x)})
                okp, whyp = (False, f'TO-BE 피호출 원문 미독 {tun[:3]}') if tun else snapshot_precheck(cs.cursor(), tables)
                if not okp:
                    row.update(verdict='SKIP', note='복원 방식 실행 불가 — ' + whyp)
                    rows.append(row)
                    print(f"   [SKIP] #{n} {tg['asis_sp']} — {row['note']}")
                    continue
            users = [str(body.get(k) or '') for k in ('sesUserId', 'userId', 'createId')]
            t_call = time.time()
            ra = run_asis(ca, tg['asis_sp'], aps, tables, users)
            if ra['residue']:
                rt = {'effect': {}, 'msg': 'AS-IS 잔여 발견 — TO-BE 실행 안 함', 'err': '', 'residue': {}}
            elif snap:
                rt = run_tobe_snapshot(cs, tg['tobe_proc'], body, tables, users, golden, dv.bind_like_be)
                md.append(f"- TO-BE 방식: 실제 저장 후 복원 · 대상 표 {tables} · 복원 {json.dumps(rt.get('restored', {}), ensure_ascii=False)}")
            else:
                rt = run_tobe(ct, tg['tobe_proc'], body, tables, users, golden, dv.bind_like_be)
            res = {**{f'AS-IS {k}': v for k, v in ra['residue'].items()}, **{f'TO-BE {k}': v for k, v in rt['residue'].items()}}
            eff = lambda e: ' · '.join(f"{tb} Δ{v['delta']:+d}/쓴 행 {len(v['rows']) if v['rows'] is not None else '?'}" for tb, v in sorted(e.items()))
            row.update(tables=' '.join(tables), asis_effect=eff(ra['effect']), tobe_effect=eff(rt['effect']), asis_msg=(ra['err'] or ra['msg'])[:400], tobe_msg=(rt['err'] or rt['msg'])[:400],
                       residue=json.dumps(res, ensure_ascii=False) if res else '0')
            md += [f"- AS-IS: @@TRANCOUNT(EXEC 직후) {ra['trancount']} · 결과 {ra['err'] or ra['msg']}", f"- TO-BE: 결과 {rt['err'] or rt['msg']}",
                   f"- 잔여(ROLLBACK 뒤 기준 수와 차이): {json.dumps(res, ensure_ascii=False) if res else '0 — 양쪽 모두 실행 전과 같음'}"]
            if res:
                row.update(verdict='RESIDUE', note='ROLLBACK 뒤 잔여 발견 — 즉시 중단: ' + json.dumps(res, ensure_ascii=False)[:300])
                residue_hit = True
            elif ra['err'] or rt['err']:
                both = bool(ra['err']) and bool(rt['err'])
                row.update(verdict='ERR', note=('양쪽 모두 오류' if both else ('AS-IS 만 오류' if ra['err'] else 'TO-BE 만 오류')) + f" — AS-IS: {ra['err'] or '정상'} / TO-BE: {rt['err'] or '정상'}"[:500])
            else:
                def seq_probe(tb, col):
                    # 양쪽 모두 되돌린 뒤이므로 지금의 최댓값 = 실행 전 최댓값
                    try:
                        c1 = ca.cursor()
                        c1.execute(f"SELECT MAX([{col}]) FROM [{tb}]")
                        ma = c1.fetchone()[0]
                        ca.rollback()
                        c2 = cs.cursor()
                        c2.execute(f'SELECT MAX("{col}") FROM SCM_MGR.{tb}')
                        mt = c2.fetchone()[0]
                        return (0 if ma is None else ma, 0 if mt is None else mt)
                    except Exception:  # noqa: BLE001 — 못 재면 제외하지 않는다
                        return None
                v, ns = effect_compare(ra['effect'], rt['effect'], idc, time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(t_call - 5)), seq_probe)
                row.update(verdict=v, note=' | '.join(ns)[:900])
                md += ['', '## 표별 대조'] + [f'- {x}' for x in ns]
            md.insert(3, f"- **판정 {row['verdict']}** — {row['note'][:400]}")
            mp = os.path.join(od, f'{short}__{n}.md')
            with open(mp, 'w', encoding='utf-8') as f:
                f.write('\n'.join(md) + '\n')
            row['md'] = os.path.relpath(mp, ROOT)
            rows.append(row)
            print(f"   [{row['verdict']}] #{n} {tg['asis_sp']} — {row['note'][:200]} · 잔여 {row['residue']}")
            if residue_hit:
                break
    finally:
        try:
            ca.rollback()
            ca.close()
        except Exception:  # noqa: BLE001
            pass
        try:
            ct.rollback()
            ct.close()
        except Exception:  # noqa: BLE001
            pass
    with open(os.path.join(od, 'summary.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows([{k: r.get(k, '') for k in COLS} for r in rows])
    c = {}
    for r in rows:
        c[r['verdict']] = c.get(r['verdict'], 0) + 1
    print(f"[save_diff] {mid}: " + ' · '.join(f'{k} {v}' for k, v in sorted(c.items())) + f" → Doc/verify/{mid}/save_diff/summary.csv")
    if residue_hit:
        return 4
    ran = [r for r in rows if r['verdict'] not in ('SKIP',)]
    return 3 if not ran else (2 if any(r['verdict'] in ('DIFF', 'ERR') for r in rows) else 0)


if __name__ == '__main__':
    sys.exit(main())
