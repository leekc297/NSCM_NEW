# -*- coding: utf-8 -*-
"""sqllog_calls.py — 사내 호출 로그(SCM_COM_SQL_LOG)에서 화면의 실제 PROC 호출 인자를 읽는다 (2026-11-11 · EN-02 ①③)

BE 는 모든 PROC 호출을 SCM_COM_SQL_LOG(sql_id = com.lgcns.nscm.callProc)에 남긴다. PARAMS 에는 FE 가 보낸 키와 BE 가 붙인 세션 값(sesLangCd·sesUserId…)이
함께 들어 있다(2026-11-11 실측). E2E 가 포착하지 못하는 두 가지 — ① 저장(SAVE) 호출 본문 ② 세션 인자 값 — 의 실측 원천이다.
  · 읽기 전용. LOG_SEQ(PK) 범위로만 읽는다 — SQL_TEXT/PARAMS(CLOB) LIKE 전체 스캔 금지(2026-11-11 실측: 3분 초과).
  · 시각 → LOG_SEQ 는 PK 이분 탐색(행당 1건 조회)으로 찾는다.

  python tools/Harness/verify/sqllog_calls.py <MENU_ID> [--from-calls | --minutes 120 | --since "2026-11-11 09:00" [--until "2026-11-11 10:00"]] [--user 계정] [--max-rows 60000]
  python tools/Harness/verify/sqllog_calls.py --selftest
출력: Doc/verify/<ID>/sqllog_calls.json  {menu_id, at, range, calls:[{seq, at, by, proc, kind, fe(dict), ses(dict), rows}]}
      kind = PROC 이름에 SAVE|INS|UPD|DEL|MERGE|SET_ 이 있으면 SAVE, 아니면 GET(이름 표기일 뿐 — 실행 가능 여부 판정은 save_diff_targets.py)
종료코드 0 = 호출 1건 이상 · 3 = 0건(그 기간에 이 화면 호출 없음 = 미측정)
"""
import json, os, re, sys, time, datetime

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
RX_CALL = re.compile(r'\{\s*call\s+(?:SCM_MGR\.)?([A-Za-z0-9_$#]+\.[A-Za-z0-9_$#]+)\s*\(', re.I)
RX_SAVE = re.compile(r'(?:^|_)(SAVE|INS|INSERT|UPD|UPDATE|DEL|DELETE|MERGE|SET)(?:_|$)', re.I)
BE_KEYS = {'procExec', 'mnuBtnCd', 'mnuId', 'sheetNm', 'DATARESULT', '@procInfo'}


def split_params(raw):
    """PARAMS(JSON 문자열, 잘렸을 수 있음) → (fe, ses, ok). ses = 'ses' 로 시작하는 키 · fe = 나머지(BE 내부 키·결과 커서 제외)"""
    try:
        d = json.loads(raw)
    except (ValueError, TypeError):
        return {}, {}, False
    if not isinstance(d, dict):
        return {}, {}, False
    fe, ses = {}, {}
    for k, v in d.items():
        if k in BE_KEYS or k.startswith('@') or isinstance(v, (list, dict)):
            continue
        (ses if re.match(r'ses[A-Z]', k) else fe)[k] = v
    return fe, ses, True


def proc_of(sql_text):
    m = RX_CALL.search(sql_text or '')
    return m.group(1).upper() if m else ''


def kind_of(proc):
    return 'SAVE' if RX_SAVE.search(proc.split('.')[-1].replace('P_', '', 1)) else 'GET'


def pick(rows, pkgs, user=None):
    """rows = [(seq, sql_id, sql_text, params, result_count, at, by)] → calls(list)"""
    out = []
    for seq, sid, txt, prm, rc, at, by in rows:
        if (sid or '') != 'com.lgcns.nscm.callProc':
            continue
        proc = proc_of(txt)
        if not proc or proc.split('.')[0] not in pkgs:
            continue
        if user and (by or '').lower() != user.lower():
            continue
        fe, ses, ok = split_params(prm)
        out.append({'seq': seq, 'at': at, 'by': by, 'proc': proc, 'kind': kind_of(proc), 'fe': fe, 'ses': ses, 'rows': rc, 'params_parsed': ok})
    return out


def session_for(calls, proc, body):
    """같은 PROC·같은 FE 본문(문자열 비교 · 본문 키만)인 로그 호출의 세션 값 — 여러 건이면 가장 최근. 없으면 {}"""
    want = {k: ('' if v is None else str(v)) for k, v in (body or {}).items()}
    best = {}
    for c in calls:
        if c['proc'] != proc.upper() or not c.get('params_parsed'):
            continue
        got = {k: ('' if v is None else str(v)) for k, v in c['fe'].items()}
        if all(got.get(k) == v for k, v in want.items()):
            best = c['ses']
    return best


# 2026-11-26 이미 읽은 LOG_SEQ 범위 재사용(SCP0005 J20261125_210634: 3회 실행이 서로 겹치는 범위를 다시 읽어 6.3분 · 7.6분 · 14.2분).
#   SCM_COM_SQL_LOG 는 덧붙이기만 하는 로그라 읽은 LOG_SEQ 행은 바뀌지 않는다. 다만 읽을 때 최댓값 근처는 커밋이 늦은 행이 뒤에 생길 수 있어
#   읽음 표시는 그때 최댓값 - CACHE_SAFE 까지만 한다. 캐시 = Doc/verify/<ID>/sqllog_cache.json {pkgs, covered:[[lo,hi]], rows:[[seq,…]]} · 끄기 SQLLOG_CACHE=0
CACHE_SAFE = 1000


def merge(iv):
    """[[lo,hi]] 겹치거나 붙은 구간 합치기"""
    out = []
    for lo, hi in sorted([int(a), int(b)] for a, b in iv if int(a) <= int(b)):
        if out and lo <= out[-1][1] + 1:
            out[-1][1] = max(out[-1][1], hi)
        else:
            out.append([lo, hi])
    return out


def gaps(lo, hi, covered):
    """[lo,hi] 중 covered 에 없는 구간"""
    out, cur = [], lo
    for a, b in merge(covered):
        if b < cur or a > hi:
            continue
        if a > cur:
            out.append([cur, a - 1])
        cur = max(cur, b + 1)
        if cur > hi:
            break
    if cur <= hi:
        out.append([cur, hi])
    return out


# 2026-11-26 사용자 '고쳐줘'(sqllog_calls DB 소요 측정 뒤): 소요 원인 = PARAMS 크기. SCP0005 LOG_SEQ 7191711~7196710 후보 387건 PARAMS 길이 합 2,100,314,524자 중
#   100KB 넘는 291건이 2,100,148,724자(조회 결과 행 목록 키 '@o_rc1' 등). 그 묶음 1개 경과 96~117초 중 DB time 97~98%,
#   대기 = SQL*Net more data to client 60~85초(2.1GB 전송) · direct path read 4~48초(LOB 디스크 읽기)(diag_sqllog_db_20261126.py 16:16~16:20 측정).
#   split_params 는 '@' 키와 목록·객체 값을 버리므로, 큰 PARAMS(PARAMS_KEEP 자 초과)는 DB 안에서 그 키를 지운 JSON 만 받는다(인라인 함수 · DB 객체 추가 없음).
#   JSON 해석 실패(잘린 PARAMS)면 원문을 그대로 돌려줘 종전처럼 '파싱 실패'로 남는다. LOB 디스크 읽기는 줄지 않음
# 2026-11-26 사용자 'JSON 해석 CPU 33초도 줄여줘': 7MB JSON 전체를 JSON_OBJECT_T 로 만드는 비용(큰 행 31건 DB CPU 3.5초)을 줄인다.
#   같은 31건 측정(diag_json_cpu_20261126.py 16:33): DBMS_LOB.INSTR 끝까지 0.6초 · JSON_VALUE 스트리밍 1.8초 · JSON_MERGEPATCH 3.3초 · JSON_OBJECT_T 3.5초.
#   nscm_cut = 맨 위 단계의 '"@키":[' 배열 구간을 글자 위치(INSTR)로만 찾아 잘라냄. 배열 끝 = 그 뒤 첫 '}],"' 또는 '}]}' 의 ']'(조회 결과 행 = 값이 단일 값인 객체 목록).
#   따옴표가 문자열 안에서는 \\" 로만 나오므로 '{'·',' 뒤 '"@' 와 '}],"' 는 문자열 안에서 생기지 않음. '}]}' 는 문자열 안에 있을 수 있어 잘못 자를 수 있음.
#   자른 결과는 작은 JSON 을 JSON_OBJECT_T 로 다시 해석해 남은 '@' 키·목록·객체를 지우고(=종전 기준), 해석이 실패하면(잘못 자른 경우 포함) 원문 전체를 종전 방식(nscm_strip_dom)으로 처리함.
#   확인(16:39~16:43): 같은 387건 경과 6.2초(DB CPU 6.1초) · pick() 결과 387건 일치 · 큰 행 291건 모두 빠른 경로 · 경계 입력 6종(중첩 배열, 문서 끝 배열 문자열 '}]}', 잘린 JSON, 빈 배열 등) split_params 결과 일치
PARAMS_KEEP = 32000


def params_sql(like):
    return f"""WITH FUNCTION nscm_strip_dom(p CLOB) RETURN CLOB IS
  o JSON_OBJECT_T; k JSON_KEY_LIST; e JSON_ELEMENT_T;
BEGIN
  o := JSON_OBJECT_T.parse(p);
  k := o.get_keys;
  FOR i IN 1 .. k.COUNT LOOP
    e := o.get(k(i));
    IF SUBSTR(k(i), 1, 1) = '@' OR (e IS NOT NULL AND (e.is_array OR e.is_object)) THEN
      o.remove(k(i));
    END IF;
  END LOOP;
  RETURN o.to_clob;
EXCEPTION WHEN OTHERS THEN
  RETURN p;
END;
FUNCTION nscm_cut(p CLOB) RETURN CLOB IS
  o CLOB; n PLS_INTEGER := DBMS_LOB.GETLENGTH(p); pos PLS_INTEGER := 1; cp PLS_INTEGER := 1;
  k PLS_INTEGER; q PLS_INTEGER; e PLS_INTEGER; e1 PLS_INTEGER; e2 PLS_INTEGER; rs PLS_INTEGER; re PLS_INTEGER; prev VARCHAR2(4);
BEGIN
  DBMS_LOB.CREATETEMPORARY(o, TRUE);
  LOOP
    k := DBMS_LOB.INSTR(p, '"@', pos);
    EXIT WHEN k = 0;
    prev := DBMS_LOB.SUBSTR(p, 1, k - 1);
    q := DBMS_LOB.INSTR(p, '":', k + 2);
    IF prev NOT IN ('{{', ',') OR q = 0 OR DBMS_LOB.SUBSTR(p, 1, q + 2) <> '[' THEN
      pos := k + 2;
    ELSE
      IF DBMS_LOB.SUBSTR(p, 1, q + 3) = ']' THEN
        e := q + 3;
      ELSE
        e1 := DBMS_LOB.INSTR(p, '}}],"', q + 3); e2 := 0;
        IF e1 = 0 THEN e2 := DBMS_LOB.INSTR(p, '}}]}}', q + 3); END IF;   -- '}}]}}' = 문서 끝 배열. 뒤에 '}}],"' 가 있으면 그 배열은 끝이 아님(LOB 를 한 번만 훑음)
        IF e1 = 0 AND e2 = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'array end'); END IF;
        e := CASE WHEN e1 = 0 THEN e2 ELSE e1 END + 1;
      END IF;
      IF prev = ',' THEN
        rs := k - 1; re := e;
      ELSE
        rs := k; re := e + CASE WHEN DBMS_LOB.SUBSTR(p, 1, e + 1) = ',' THEN 1 ELSE 0 END;
      END IF;
      IF rs > cp THEN DBMS_LOB.COPY(o, p, rs - cp, DBMS_LOB.GETLENGTH(o) + 1, cp); END IF;
      cp := re + 1; pos := re + 1;
    END IF;
  END LOOP;
  IF n >= cp THEN DBMS_LOB.COPY(o, p, n - cp + 1, DBMS_LOB.GETLENGTH(o) + 1, cp); END IF;
  RETURN o;
END;
FUNCTION nscm_strip_params(p CLOB) RETURN CLOB IS
  c CLOB; o JSON_OBJECT_T; k JSON_KEY_LIST; e JSON_ELEMENT_T;
BEGIN
  BEGIN
    c := nscm_cut(p);
    o := JSON_OBJECT_T.parse(c);
  EXCEPTION WHEN OTHERS THEN
    RETURN nscm_strip_dom(p);
  END;
  k := o.get_keys;
  FOR i IN 1 .. k.COUNT LOOP
    e := o.get(k(i));
    IF SUBSTR(k(i), 1, 1) = '@' OR (e IS NOT NULL AND (e.is_array OR e.is_object)) THEN
      o.remove(k(i));
    END IF;
  END LOOP;
  RETURN o.to_clob;
END;
SELECT log_seq, sql_id, DBMS_LOB.SUBSTR(sql_text, 400, 1),
       CASE WHEN DBMS_LOB.GETLENGTH(params) > :lim THEN nscm_strip_params(params) ELSE params END,
       result_count, TO_CHAR(execute_time, 'YYYY-MM-DD HH24:MI:SS'), created_by
  FROM scm_mgr.scm_com_sql_log WHERE log_seq BETWEEN :a AND :b AND sql_id = 'com.lgcns.nscm.callProc' AND ({like})"""


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    P = '{"divisionId":"81","itemId":"","sesLangCd":"KO","sesUserId":"u1","mnuBtnCd":"SEARCH","procExec":"{call X}","O_RC":[{"A":1}]}'
    fe, ses, ok = split_params(P)
    t('FE 키와 세션 키 분리 · BE 내부 키·결과 커서 제외', ok and fe == {'divisionId': '81', 'itemId': ''} and ses == {'sesLangCd': 'KO', 'sesUserId': 'u1'})
    t('잘린 JSON = 파싱 실패로 표시(추측으로 채우지 않음)', split_params(P[:40])[2] is False)
    t('PROC 이름 추출(스키마 접두 허용)', proc_of("{ call SCM_MGR.PKG_X.P_GET_A( 'a' ) }") == 'PKG_X.P_GET_A' and proc_of("{call PKG_X.P_SAVE_B( ?, ? )}") == 'PKG_X.P_SAVE_B')
    t('SAVE 류 이름 판별', kind_of('PKG_X.P_X_SAVE_ROW') == 'SAVE' and kind_of('PKG_X.P_X_DELETE_ROW') == 'SAVE' and kind_of('PKG_X.P_X_GET_DESET') == 'GET')
    rows = [(1, 'com.lgcns.nscm.callProc', '{call PKG_A.P_A_GET( ? )}', P, 3, 't1', 'u1'), (2, 'com.lgcns.nscm.execStmt', '{call PKG_A.P_A_GET( ? )}', P, 3, 't2', 'u1'),
            (3, 'com.lgcns.nscm.callProc', '{call PKG_B.P_B_GET( ? )}', P, 3, 't3', 'u1'), (4, 'com.lgcns.nscm.callProc', '{call PKG_A.P_A_SAVE( ? )}', P, 0, 't4', 'u2')]
    c = pick(rows, {'PKG_A'})
    t('그 화면 PKG 의 callProc 만 고른다', [x['seq'] for x in c] == [1, 4] and c[1]['kind'] == 'SAVE')
    t('계정 지정 시 다른 사용자 호출 제외', [x['seq'] for x in pick(rows, {'PKG_A'}, 'u1')] == [1])
    t('같은 PROC·같은 본문의 세션 값을 돌려준다', session_for(c, 'PKG_A.P_A_GET', {'divisionId': '81', 'itemId': ''}) == {'sesLangCd': 'KO', 'sesUserId': 'u1'})
    t('본문이 다르면 세션 값을 주지 않는다(변이)', session_for(c, 'PKG_A.P_A_GET', {'divisionId': '40', 'itemId': ''}) == {})
    t('다른 PROC 이면 세션 값을 주지 않는다', session_for(c, 'PKG_A.P_OTHER', {'divisionId': '81'}) == {})
    t('구간 합치기(겹침·붙음)', merge([[5, 9], [1, 3], [4, 4], [20, 30]]) == [[1, 9], [20, 30]])
    t('읽은 범위 빼고 남는 구간', gaps(1, 40, [[5, 9], [20, 30]]) == [[1, 4], [10, 19], [31, 40]] and gaps(5, 9, [[1, 10]]) == [] and gaps(1, 5, []) == [[1, 5]])
    q = params_sql("DBMS_LOB.INSTR(sql_text, 'PKG_A.') > 0")
    t('큰 PARAMS 는 DB 안에서 @ 키·목록·객체 값 제거, 해석 실패면 원문(split_params 제외 기준과 같음)',
      "SUBSTR(k(i), 1, 1) = '@'" in q and 'is_array OR e.is_object' in q and 'EXCEPTION WHEN OTHERS THEN\n  RETURN p;' in q and 'GETLENGTH(params) > :lim' in q)
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def seq_at(cur, when, lo, hi):
    """execute_time >= when 인 가장 작은 LOG_SEQ(근사 — LOG_SEQ 는 시각 순). PK 단건 조회 이분 탐색"""
    def t_of(s):
        cur.execute("SELECT execute_time FROM scm_mgr.scm_com_sql_log WHERE log_seq = (SELECT MIN(log_seq) FROM scm_mgr.scm_com_sql_log WHERE log_seq >= :s)", s=s)
        r = cur.fetchone()
        return r[0] if r else None
    while lo < hi:
        mid = (lo + hi) // 2
        tm = t_of(mid)
        if tm is None or tm >= when:
            hi = mid
        else:
            lo = mid + 1
    return lo


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__)
        return 3

    def opt(name, d=None):
        return a[a.index(name) + 1] if name in a and a.index(name) + 1 < len(a) else d
    mid = a[0].upper().strip('/')
    if not re.fullmatch(r'[A-Z0-9_]+', mid):
        print(f'[sqllog_calls] 화면 ID 형식 아님: {mid}')
        return 3
    user = opt('--user')
    max_rows = int(opt('--max-rows', '300000'))
    since = opt('--since')
    when = datetime.datetime.strptime(since, '%Y-%m-%d %H:%M') if since else datetime.datetime.now() - datetime.timedelta(minutes=int(opt('--minutes', '120')))
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    import dbconn
    cx = dbconn.connect('tobe')
    cx.call_timeout = 120000
    cur = cx.cursor()
    # 2026-11-26 개선안 20261126023752_INC: CLOB 는 조회 단계에서 문자열(DB_TYPE_LONG)로 받는다(oracledb 4.0.1 은 커서별 fetch_lobs 가 없어 outputtypehandler 사용).
    #   아래 r[3].read() 분기는 handler 가 듣지 않는 드라이버용으로 남김. 소요 원인과 PARAMS 줄이기는 PARAMS_SQL 주석 참고
    import oracledb
    cur.outputtypehandler = lambda cu, md: cu.var(oracledb.DB_TYPE_LONG, arraysize=cu.arraysize) if md.type_code is oracledb.DB_TYPE_CLOB else None
    # 화면에 배선된 PROC 의 PKG — meta_live_check.py 와 같은 조회(SCM_ADM_MNU_BTN_MPG_M → SCM_ADM_API_M.API_URL = 'PKG.PROC')
    cur.execute("SELECT DISTINCT A.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID WHERE B.MNU_ID = :1", [mid])
    pkgs = {r[0].split('.')[0].upper() for r in cur.fetchall() if r[0] and '.' in r[0]}
    if not pkgs:
        pkgs = {f'PKG_{mid}'}
    cur.execute("SELECT MIN(log_seq), MAX(log_seq) FROM scm_mgr.scm_com_sql_log")
    mn, mx0 = cur.fetchone()
    F = '%Y-%m-%d %H:%M'
    windows = []
    if '--from-calls' in a:
        # E2E 가 호출을 포착한 시각대만 읽는다 — Doc/verify/<ID>/calls/*.json 수정 시각을 60분 간격으로 묶어 [묶음 시작 - 90분, 묶음 끝 + 5분]
        cd = os.path.join(ROOT, 'Doc', 'verify', mid, 'calls')
        ts = sorted(os.path.getmtime(os.path.join(cd, f)) for f in os.listdir(cd) if f.endswith('.json')) if os.path.isdir(cd) else []
        grp = []
        for x in ts:
            if grp and x - grp[-1][1] <= 3600:
                grp[-1][1] = x
            else:
                grp.append([x, x])
        windows = [(datetime.datetime.fromtimestamp(s) - datetime.timedelta(minutes=90), datetime.datetime.fromtimestamp(e) + datetime.timedelta(minutes=5)) for s, e in grp]
        if not windows:
            print(f"[sqllog_calls] {mid}: Doc/verify/{mid}/calls 에 포착 파일 없음 — 읽을 시각대를 정할 수 없음(미측정)")
            return 3
    else:
        until = opt('--until')
        windows = [(when, datetime.datetime.strptime(until, F) if until else None)]
    rows, ranges, total = [], [], 0
    t_start = time.time()
    cache_p = os.path.join(ROOT, 'Doc', 'verify', mid, 'sqllog_cache.json'); use_cache = os.environ.get('SQLLOG_CACHE', '1') != '0'
    cache = {'pkgs': sorted(pkgs), 'covered': [], 'rows': []}
    if use_cache:
        try:
            _c = json.load(open(cache_p, encoding='utf-8'))
            if _c.get('pkgs') == sorted(pkgs):
                cache = _c
        except (OSError, ValueError):
            pass
    covered0 = merge(cache.get('covered') or []); new_cov = []; reused = 0; read_rows = 0
    step = 5000
    like = ' OR '.join(f"DBMS_LOB.INSTR(sql_text, '{k}.') > 0" for k in sorted(pkgs) if re.fullmatch(r'[A-Z0-9_$#]+', k))
    for w_from, w_to in windows:
        lo = seq_at(cur, w_from, mn, mx0)
        hi = seq_at(cur, w_to, lo, mx0) if w_to else mx0
        if hi - lo > max_rows:
            print(f"[sqllog_calls] {mid}: {w_from:%Y-%m-%d %H:%M}~ 범위 {hi - lo}행 > 상한 {max_rows} — 앞에서 {max_rows}행만 읽음(그 뒤는 미측정 · --max-rows 로 조정)")
            hi = lo + max_rows
        ranges.append([lo, hi, w_from.strftime(F), w_to.strftime(F) if w_to else ''])
        total += hi - lo + 1
        for r in cache.get('rows') or []:   # 이미 읽은 범위의 행은 캐시에서
            if lo <= int(r[0]) <= hi and gaps(int(r[0]), int(r[0]), covered0) == []:
                rows.append(tuple(r)); reused += 1
        todo = gaps(lo, hi, covered0)
        chunks = [(s, min(s + step - 1, b)) for a, b in todo for s in range(a, b + 1, step)]
        if covered0 and (hi - lo + 1) > sum(b - a + 1 for a, b in todo):
            print(f"[sqllog_calls] {mid} {w_from:%H:%M}~ 범위 {hi - lo + 1}행 중 이미 읽은 {hi - lo + 1 - sum(b - a + 1 for a, b in todo)}행은 캐시 사용 · 새로 읽을 {sum(b - a + 1 for a, b in todo)}행", flush=True)
        for i, (s, e) in enumerate(chunks, 1):
            # 구간마다 진행 1줄(2026-11-26 VMO: 끝날 때까지 무출력 849초 → 감시기 '진행 없음' 사건 20261126_022124_R5_SCP0005)
            print(f"[sqllog_calls] {mid} 읽는 중 {w_from:%H:%M}~ 묶음 {i}/{len(chunks)} · LOG_SEQ {s}~{e} · 지금까지 후보 {len(rows)}건 · 경과 {time.time() - t_start:.0f}초", flush=True)
            # LOG_SEQ(PK) 범위 안에서만 CLOB 를 본다 — 범위 밖 전체 스캔 없음
            cur.execute(params_sql(like), a=s, b=e, lim=PARAMS_KEEP)
            read_rows += e - s + 1
            for r in cur.fetchall():
                if proc_of(r[2]).split('.')[0] in pkgs:
                    prm = r[3].read() if hasattr(r[3], 'read') else r[3]
                    rows.append((r[0], r[1], r[2], prm, r[4], r[5], r[6]))
            if s <= mx0 - CACHE_SAFE:
                new_cov.append([s, min(e, mx0 - CACHE_SAFE)])
    lo, mx = (ranges[0][0], ranges[-1][1]) if ranges else (0, 0)
    cx.close()
    rows = list({r[0]: r for r in rows}.values())  # 겹치는 시각대에서 같은 LOG_SEQ 가 두 번 읽히면 한 번만
    if use_cache:   # 이번에 읽은 범위를 캐시에 더함 · 이번 범위 시작보다 앞(다시 볼 일 없는 옛 범위)은 지움
        try:
            floor = min((r[0] for r in ranges), default=0)
            cov = [[max(a, floor), b] for a, b in merge(covered0 + new_cov) if b >= floor]
            keep = {int(r[0]): list(r) for r in (cache.get('rows') or []) if int(r[0]) >= floor}
            for r in rows:
                if gaps(int(r[0]), int(r[0]), cov) == []:
                    keep[int(r[0])] = list(r)
            tmp = cache_p + '.tmp'; os.makedirs(os.path.dirname(cache_p), exist_ok=True)
            json.dump({'pkgs': sorted(pkgs), 'covered': cov, 'rows': [keep[k] for k in sorted(keep)], 'at': time.strftime('%Y-%m-%d %H:%M:%S')}, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False)
            os.replace(tmp, cache_p)
        except Exception as e:
            print(f'[WARN] sqllog 캐시 저장 실패({type(e).__name__}: {str(e)[:120]}) · 결과에는 영향 없음', flush=True)
        print(f"[sqllog_calls] {mid} 캐시: 새로 읽은 {read_rows}행 · 캐시에서 가져온 호출 후보 {reused}건 · {time.time() - t_start:.0f}초", flush=True)
    rows.sort(key=lambda r: r[0])
    calls = pick(rows, pkgs, user)
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    os.makedirs(vd, exist_ok=True)
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    with open(os.path.join(vd, 'sqllog_calls.json'), 'w', encoding='utf-8') as f:
        json.dump({'menu_id': mid, 'at': at, 'windows': ranges, 'rows_scanned': total, 'pkgs': sorted(pkgs), 'user': user or '', 'calls': calls}, f, ensure_ascii=False, indent=1)
    c = {}
    for x in calls:
        k = (x['proc'].split('.')[-1], x['kind'])
        c[k] = c.get(k, 0) + 1
    bad = sum(1 for x in calls if not x['params_parsed'])
    span = ' / '.join(r[2] + '~' + (r[3] or '현재') for r in ranges)
    print(f"[sqllog_calls] {mid} {at} · 읽은 범위 {len(ranges)}구간 {total}행({span}) · PKG {sorted(pkgs)} · 호출 {len(calls)}건(GET {sum(1 for x in calls if x['kind'] == 'GET')} · SAVE {sum(1 for x in calls if x['kind'] == 'SAVE')})"
          + (f" · 인자 JSON 파싱 실패 {bad}건" if bad else '') + f" → Doc/verify/{mid}/sqllog_calls.json")
    for (p, k), n in sorted(c.items()):
        print(f"   {k:<4} {p:<56} {n}건")
    return 0 if calls else 3


if __name__ == '__main__':
    sys.exit(main())
