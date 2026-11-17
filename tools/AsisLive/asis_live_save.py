# -*- coding: utf-8 -*-
"""AS-IS 저장 시나리오 — 수정 · 없던 행 입력 · 여러 행 · 검증 메시지 · 팝업 삭제 → 저장 인자 포착 → 원래 값 복원·대조 (2026-11-13 · 플랜 P6-2)

  python tools/AsisLive/asis_live_save.py <ID> --draft --dry      (초안 save_scenario.draft.json 의 '키 대응 완료' 정의로 연습 실행만 · 저장 안 함)
  python tools/AsisLive/asis_live_save.py <ID> [--dry] [--name 시나리오이름]     (정의에 "scenarios" 가 있으면 전부 차례로 · --name 으로 하나만)
입력  Doc/asislive/<ID>/save_scenario.json   화면별 저장 시나리오 정의(사람이 소스·SP 원문을 보고 적는다 — 자동 추정하지 않는다)
  공통  "table" 저장 대상 테이블 · "pk" 테이블 키 · "match" {테이블 컬럼: 그리드 열 Tag}(그리드 행 → DB 행 조건) · "save_sp" 저장 SP 이름
        "side" [{"table","pk"}] 저장 SP 가 행을 덧붙이는 표(이력 등 — 이번 실행분만 지운다) · "basis" 근거(파일:줄)
        "related" [{"table","pk","match": {테이블 컬럼: 그리드 열 Tag}}] 저장 SP 가 함께 고치거나 행을 넣는 다른 표(대상 행 범위를 전부 기록해 두고 저장 뒤 행 단위로 되돌린다)
  시나리오(kind 별)
    kind 없음/"edit"  "edits": [{"pick": {"col": 열 Tag, "nonempty": true|false, "nth": 0}, "edit": {"col": 열 Tag, "rule": "plus1" | "value": 값}, "expect_before": 1|0}, …]
                      (예전 형식 "pick"·"edit"·"expect_before" 한 벌도 받는다 · 여러 개면 여러 행을 고치고 한 번에 저장)
                      "expect": "saved"(기본) | "message" + "message_re": 정규식  ← 검증 메시지가 떠야 하고 저장 SP 는 불리지 않아야 하며 DB 는 그대로여야 한다
    "delete_popup"    "button" 삭제 팝업을 여는 버튼 · "popup" 팝업 폼 형식 이름 · "popup_set" [{"name": 팝업 조건 컨트롤, "from": 그리드 열 Tag}](체크 목록에서 그 값이 든 항목만 체크)
                      "popup_find"·"popup_ok" 팝업의 조회·확인 메서드 · "popup_check_col" 체크 열 Tag · "popup_match" {팝업 열 Tag: 그리드 열 Tag}
                      "pick" 지울 대상 행 · "match" 는 지워지는 범위(키 일부)로 적는다(전 기록 = 그 범위의 모든 행)
순서  ① 화면 열기 → 필수 조건 → 조회 → 대상 행 선택  ② DB 에서 대상 범위의 지금 값 기록(전) · 덧붙는 표의 키 기록
      ③ 조작(수정 모드 → 셀 입력 / 삭제 팝업 → 조회 → 체크)  ④ (--dry) 저장·확인 없이 닫고 DB 가 그대로인지 확인
         (실행) 저장 버튼 또는 팝업 확인 → 메시지 기록 → 저장 SP 호출·인자 포착 → DB 값 기록(후)
      ⑤ 복원: 전 기록의 행은 키로 UPDATE(없어졌으면 다시 INSERT) · 전에 없던 행은 키로 DELETE · 덧붙은 이력 행 삭제 → 다시 읽어 전 기록과 전 컬럼 대조
산출  Doc/asislive/<ID>/run_<시각>_save_<이름>/save.json · calls.json
판정  ASIS_SAVE_FAILED(저장 SP 는 불렸으나 AS-IS 가 저장 실패를 알림 · DB 그대로 · SP 오류 로그를 근거로 남김) |
      OK | MESSAGE_OK(기대한 검증 메시지 · 저장 안 됨 · DB 그대로) | DRY_OK | SAVE_TIMEOUT(저장 SP 시간 초과 — 자기 세션 정리 뒤 DB 저장 전 상태) |
      SAVE_NOT_CONFIRMED(저장 호출·DB 반영을 확인 못 함) | RESTORE_FAIL(복원 뒤 값이 다름 — 즉시 보고) | ERROR(조작 불가 · 저장하지 않음)
제약  AS-IS 개발 DB 에만 쓴다(.env.asis). 테이블 전체 삭제·구조 변경 없음(모든 쓰기 = 키 조건 · 행 단위). 전 기록 행 수가 기대와 다르면 저장하지 않는다.
"""
import datetime as dt, decimal, json, os, re, sys, threading, time

HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROOT = os.path.abspath(os.path.join(HERE, "..", "..")); sys.path.insert(0, os.path.join(ROOT, "tools", "DbConn"))
import asis_live_run as R
import asis_live_fill as F
import asis_live_scen_run as SR
P = lambda *a: os.path.join(ROOT, *a)


def jv(v):
    if isinstance(v, (dt.datetime, dt.date)): return v.strftime("%Y-%m-%d %H:%M:%S.%f")[:23]
    if isinstance(v, decimal.Decimal): return str(v)
    return v


def db_rows(table, where):
    import dbconn
    cx = dbconn.connect("asis"); cur = cx.cursor()
    cur.execute("SELECT * FROM %s WHERE %s" % (table, " AND ".join("%s = ?" % k for k in where)), list(where.values()))
    cols = [d[0] for d in cur.description]; rows = [dict(zip(cols, r)) for r in cur.fetchall()]; cx.close()
    return rows


def restore(table, pk, before, after):
    """전 기록으로 되돌린다 — 행 단위 UPDATE/DELETE/INSERT(모두 키 조건). 실행한 문장 목록을 돌려준다."""
    import dbconn
    cx = dbconn.connect("asis"); cur = cx.cursor(); done = []
    key = lambda r: tuple(r[k] for k in pk)
    bset = {key(r): r for r in before}
    for r in after:
        if key(r) not in bset:
            sql = "DELETE FROM %s WHERE %s" % (table, " AND ".join("%s = ?" % k for k in pk)); cur.execute(sql, [r[k] for k in pk])
            done.append({"op": "DELETE(전에 없던 행)", "key": [jv(r[k]) for k in pk], "rows": cur.rowcount})
    aset = {key(r) for r in after}; amap = {key(r): r for r in after}
    for r in before:
        if key(r) in aset:
            if {c: jv(v) for c, v in r.items()} == {c: jv(v) for c, v in amap[key(r)].items()}: continue      # 값이 같은 행은 건드리지 않는다
            nk = [c for c in r if c not in pk]
            cur.execute("UPDATE %s SET %s WHERE %s" % (table, ", ".join("%s = ?" % c for c in nk), " AND ".join("%s = ?" % k for k in pk)), [r[c] for c in nk] + [r[k] for k in pk])
            done.append({"op": "UPDATE(전 값으로)", "key": [jv(r[k]) for k in pk], "rows": cur.rowcount})
        else:
            cols = list(r); cur.execute("INSERT INTO %s (%s) VALUES (%s)" % (table, ", ".join(cols), ", ".join("?" for _ in cols)), [r[c] for c in cols])
            done.append({"op": "INSERT(없어진 행 되살림)", "key": [jv(r[k]) for k in pk], "rows": cur.rowcount})
    cx.commit(); cx.close()
    return done


def side_keys(side, wheres):
    import dbconn
    out = {}; cx = dbconn.connect("asis"); cur = cx.cursor()
    for sd in side or []:
        cur.execute("select name from sys.columns where object_id = object_id(?)", sd["table"]); have = {r[0].upper() for r in cur.fetchall()}; ks = set(); usable = True
        for where in wheres:
            w = {k: v for k, v in where.items() if k.upper() in have}
            if not w: usable = False; break
            cur.execute("SELECT %s FROM %s WHERE %s" % (", ".join(sd["pk"]), sd["table"], " AND ".join("%s = ?" % k for k in w)), list(w.values()))
            ks |= {tuple(r) for r in cur.fetchall()}
        out[sd["table"]] = ks if usable else None
    cx.close()
    return out


def side_clean(side, wheres, pre):
    import dbconn
    now_k = side_keys(side, wheres); done = []; cx = dbconn.connect("asis"); cur = cx.cursor()
    for sd in side or []:
        a, b = pre.get(sd["table"]), now_k.get(sd["table"])
        if a is None or b is None: done.append({"table": sd["table"], "note": "대상 조건으로 쓸 컬럼이 없어 손대지 않음"}); continue
        for key in sorted(b - a, key=str):
            cur.execute("DELETE FROM %s WHERE %s" % (sd["table"], " AND ".join("%s = ?" % k for k in sd["pk"])), list(key))
            done.append({"table": sd["table"], "key": [jv(x) for x in key], "rows": cur.rowcount})
    cx.commit(); cx.close()
    return done


def watch_requests(stop, log):
    """저장하는 동안 이 PC 에서 온 실행 중 요청의 대기 상태를 1초마다 적는다(멈춘 지점·막고 있는 세션 확인용 · 조회만)"""
    import dbconn, socket
    try: cx = dbconn.connect("asis"); cur = cx.cursor()
    except Exception as ex: log.append({"error": str(ex)[:150]}); return
    me = socket.gethostname()
    while not stop.is_set():
        try:
            cur.execute("""select r.session_id, r.status, r.wait_type, r.blocking_session_id, r.total_elapsed_time, substring(t.text, r.statement_start_offset/2+1, 160), object_name(t.objectid, t.dbid),
 (select top 1 bs.host_name + '/' + bs.program_name from sys.dm_exec_sessions bs where bs.session_id = r.blocking_session_id)
from sys.dm_exec_requests r join sys.dm_exec_sessions s on s.session_id = r.session_id cross apply sys.dm_exec_sql_text(r.sql_handle) t
where s.host_name = ? and s.program_name like '.Net SqlClient%' and r.session_id <> @@spid""", me)
            for r in cur.fetchall():
                log.append({"at": time.strftime("%H:%M:%S"), "sid": r[0], "status": r[1], "wait": r[2], "blocked_by": r[3], "elapsed_ms": r[4], "stmt": " ".join(str(r[5] or "").split())[:150], "proc": r[6], "blocker": r[7]})
        except Exception as ex:
            log.append({"error": str(ex)[:150]})
        stop.wait(1.0)
    try: cx.close()
    except Exception: pass


def squeeze(wlog):
    seen = []
    for w in wlog:
        k = (w.get("sid"), w.get("wait"), w.get("blocked_by"), w.get("stmt"), w.get("error"))
        if seen and seen[-1]["k"] == k: seen[-1]["last"] = w
        else: seen.append({"k": k, "first": w, "last": w})
    return [dict(x["first"], until=x["last"].get("at"), elapsed_ms_last=x["last"].get("elapsed_ms")) for x in seen][:40]


def kill_own_open_tran(sp):
    """저장 SP 가 시간 초과로 끊기면 서비스 접속에 트랜잭션이 열린 채 남는다(11-13 18:01 실측: X 잠금).
    이 PC 에서 온 접속 중 **열린 트랜잭션이 있고 마지막 문장이 그 저장 SP 인 세션만** 끝내 되돌린다(남의 세션은 건드리지 않는다)."""
    import dbconn, socket
    cx = dbconn.connect("asis"); cx.autocommit = True; cur = cx.cursor(); out = []
    cur.execute("""select s.session_id, s.open_transaction_count, s.last_request_start_time, (select top 1 text from sys.dm_exec_sql_text(c.most_recent_sql_handle))
from sys.dm_exec_sessions s join sys.dm_exec_connections c on c.session_id = s.session_id
where s.host_name = ? and s.program_name like '.Net SqlClient%' and s.open_transaction_count > 0 and s.status = 'sleeping' and s.session_id <> @@spid""", socket.gethostname())
    for sid, n, st, txt in cur.fetchall():
        if sp.upper() in str(txt or "").upper():
            cur.execute("KILL %d" % int(sid)); out.append({"session_id": sid, "open_tran": n, "last_request_start": jv(st), "action": "KILL(미커밋 되돌림)"})
    cx.close()
    return out


def error_logs(t0):
    """저장 구간에 SP 가 남긴 오류 로그(scm_sys_log_batch · log_type ERROR) — 저장 실패 원인 근거(조회만)"""
    import dbconn
    try:
        cx = dbconn.connect("asis"); cur = cx.cursor()
        cur.execute("select top 10 program_name, left(log_message, 400), event_date from scm_sys_log_batch where log_type = 'ERROR' and event_date >= ? order by event_date", t0)
        out = [{"program": r[0], "message": r[1], "at": jv(r[2])} for r in cur.fetchall()]; cx.close(); return out
    except Exception as ex: return [{"error": str(ex)[:200]}]


def table_divisions(table):
    """저장 대상 테이블에 행이 있는 Division 코드(행 수 많은 순). DIVISION_ID 컬럼이 없으면 None"""
    import dbconn
    cn = dbconn.connect("asis"); cur = cn.cursor()
    try:
        cur.execute("SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(?) AND name = 'DIVISION_ID'", "dbo." + table)
        if not cur.fetchone(): return None
        cur.execute("SELECT DIVISION_ID, COUNT_BIG(*) FROM dbo.[%s] WITH (NOLOCK) GROUP BY DIVISION_ID ORDER BY COUNT_BIG(*) DESC" % table)
        return [(str(a).strip(), int(b)) for a, b in cur.fetchall() if a is not None]
    finally: cn.close()


def date_derive(mid, division=""):
    """조회 기간 도출(11-14): 기본 실측의 조회 SP 인자 가운데 기간 시작 인자(from…yyyymmdd·date)를 찾고, SP 원문에서 그 인자와 비교하는 컬럼을 찾아
    그 컬럼이 있는 FROM·JOIN 표의 최댓값을 읽는다. 반환 {"sp","param","column","table","max","from","to","basis"} 또는 {"why": 도출 못 한 까닭}"""
    import dbconn, glob
    runs = sorted(d for d in glob.glob(P("Doc", "asislive", mid, "run_*")) if re.fullmatch(r"run_\d{8}_\d{6}", os.path.basename(d)))
    call = None
    for d in reversed(runs):
        try: j = json.load(open(os.path.join(d, "calls.json"), encoding="utf-8"))
        except Exception: continue
        for c in (j if isinstance(j, list) else j.get("calls") or []):
            ps = c.get("params") or {}
            fk = next((k for k in ps if re.search(r"from.*(yyyymmdd|date|day)|(yyyymmdd|date|day).*from|^p_start", k, re.I) and re.fullmatch(r"\d{8}", str(ps[k] or ""))), None)
            if str(c.get("phase") or "").startswith("find") and fk: call = (c.get("sp"), fk, ps); break
        if call: break
    if not call: return {"why": "기본 실측의 조회 호출에 기간 시작 인자(8자리 날짜)가 없음"}
    sp, fk, ps = call; sp = str(sp).split(".")[-1]
    cn = dbconn.connect("asis"); cur = cn.cursor()
    try:
        cur.execute("SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID(?)", "dbo." + sp); r = cur.fetchone()
        if not r: return {"why": "조회 SP %s 원문 없음" % sp}
        t = re.sub(r"/\*.*?\*/", " ", r[0], flags=re.S); t = "\n".join(re.sub(r"--.*", "", x) for x in t.split("\n"))
        m = re.search(r"(?:\w+\.)?\[?(\w+)\]?\s*(?:,\s*\d+\s*\))?\s*>=\s*(?:'\s*\+\s*)?@%s(?!\w)" % re.escape(fk), t, re.I)
        if not m: return {"why": "SP %s 원문에 '컬럼 >= @%s' 꼴이 없음" % (sp, fk)}
        col = m.group(1); line = t.count("\n", 0, m.start()) + 1
        tabs = []
        for k in re.finditer(r"(?:FROM|JOIN)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?", t, re.I):
            if k.group(1).upper() not in [x.upper() for x in tabs]: tabs.append(k.group(1))
        for tb in tabs:
            cur.execute("SELECT TYPE_NAME(system_type_id) FROM sys.columns WHERE object_id = OBJECT_ID(?) AND name = ?", "dbo." + tb, col); c = cur.fetchone()
            if not c: continue
            cur.execute("SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(?) AND name = 'DIVISION_ID'", "dbo." + tb); hd = cur.fetchone()
            expr = "CONVERT(varchar(8), MAX([%s]), 112)" % col if "date" in c[0].lower() or "time" in c[0].lower() else "MAX(CAST([%s] AS varchar(8)))" % col
            isd = "date" in c[0].lower() or "time" in c[0].lower(); lim = (dt.datetime.now() + dt.timedelta(days=730))     # 값이 깨진 먼 미래 날짜(예 9021년)는 뺀다: 오늘 + 2년까지만
            cond = ("[%s] <= ?" % col); lv = lim if isd else lim.strftime("%Y%m%d")
            if hd and division: cur.execute("SELECT %s FROM dbo.[%s] WITH (NOLOCK) WHERE DIVISION_ID = ? AND %s" % (expr, tb, cond), division, lv)
            else: cur.execute("SELECT %s FROM dbo.[%s] WITH (NOLOCK) WHERE %s" % (expr, tb, cond), lv)
            mx = cur.fetchone()[0]
            if not mx or not re.fullmatch(r"\d{8}", str(mx).strip()): continue
            mx = str(mx).strip(); d1 = dt.datetime.strptime(mx, "%Y%m%d"); d0 = d1 - dt.timedelta(days=30)
            return {"sp": sp, "param": fk, "column": col, "table": tb, "max": mx, "from": d0.strftime("%Y%m%d"), "to": mx, "division": division if hd else "",
                    "basis": "%s %d줄 '%s >= @%s' · %s.%s 최댓값 %s%s" % (sp, line, col, fk, tb, col, mx, (" (Division %s)" % division) if hd and division else "")}
        return {"why": "SP %s 의 FROM·JOIN 표 %d개 가운데 컬럼 %s 에 날짜 값이 있는 표가 없음" % (sp, len(tabs), col)}
    finally: cn.close()


def val_eq(dbv, new):
    """DB 값과 넣은 값 비교 — 둘 다 숫자면 수로 비교(31.0000000000 = 31)"""
    a, b = str(dbv).replace(",", "").strip(), str(new).replace(",", "").strip()
    if a == b: return True
    try: return decimal.Decimal(a) == decimal.Decimal(b)
    except Exception: return False


def same(a, b, pk):
    f = lambda rows: sorted(([{c: jv(v) for c, v in r.items()} for r in rows]), key=lambda r: [str(r[k]) for k in pk])
    return f(a) == f(b)


def dialogs_from(host, d0):
    return [{"text": (x.get("text") or "")[:200], "action": x.get("action")} for x in (host.send("dialogs", timeout=30).get("dialogs") or [])[d0:]]


def key_form(raw, shown):
    """셀 원래 값을 DB 키 조건 글자로 — 날짜 원값(yyyy-MM-dd 00:00:00)은 표시가 숫자 8자리 계열이면 yyyymmdd 로, 아니면 원래 값 그대로"""
    m = re.match(r"^(\d{4})-(\d{2})-(\d{2}) 00:00:00$", str(raw))
    if m and len(re.sub(r"\D", "", str(shown))) == 8: return m.group(1) + m.group(2) + m.group(3)
    return raw


def pick_row(sheet, cols, pick, used):
    ci = lambda tag: cols.index(tag); n = 0
    for i, rw in enumerate(sheet["data"]):
        if i in used: continue
        if not pick or (str(rw[ci(pick["col"])]).strip() != "") == bool(pick.get("nonempty", True)):
            if n == int(pick.get("nth", 0) if pick else 0): return i
            n += 1
    return None


def do_save(host, out, d, sc, dry, act_kw, policy_during):
    """저장을 일으키는 동작 1개(저장 버튼 · 팝업 확인)를 실행하고 호출·메시지·대기 상태를 모은다."""
    d0 = len((host.send("dialogs", timeout=30).get("dialogs") or []))
    host.send("policy", timeout=30, dialogs=policy_during)
    wlog = []; stop = threading.Event(); th = threading.Thread(target=watch_requests, args=(stop, wlog), daemon=True); th.start()
    ts = R.now(); sr = host.send("act", timeout=180, **act_kw); R.wait_quiet(ts, 3, 120)
    n, _s = R.db_inflight()
    if n: R.wait_db_clear(600)
    stop.set(); th.join(5); host.send("policy", timeout=30, dialogs="no")
    cs = R.parse_dbprofile(ts, R.now())
    for c in cs: c["phase"] = "action:save"
    json.dump({"calls": cs}, open(os.path.join(d, "calls.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    sv = [c for c in cs if str(c.get("sp") or "").upper().endswith(sc["save_sp"].upper())]
    out["save_call"] = [{"sp": c.get("sp"), "params": c.get("params"), "rows": c.get("rows"), "ms": c.get("ms")} for c in sv]
    out["save_dialogs"] = dialogs_from(host, d0); out["save_act"] = {"ok": sr.get("ok"), "error": sr.get("error"), "popups": [p.get("form") for p in sr.get("popups") or []]}
    out["save_wait"] = squeeze(wlog); out["save_timeout"] = any("EXCEPTION" in str(c.get("inline") or "") for c in sv)
    if out["save_timeout"]:
        time.sleep(2); out["killed_sessions"] = kill_own_open_tran(sc["save_sp"])
        print("[3] 저장 SP 가 시간 초과로 끊김 → 이 실행이 남긴 열린 트랜잭션 세션 %d개 종료(미커밋 되돌림)" % len(out["killed_sessions"]), flush=True); time.sleep(2)
    return sv


def main():
    av = sys.argv[1:]; ids = [a.upper() for i, a in enumerate(av) if not a.startswith("-") and not (i > 0 and av[i - 1] == "--name")]; dry = "--dry" in av
    if len(ids) != 1: print(__doc__); return 2
    mid = ids[0]
    if "--draft" in av:
        # 초안(asis_live_save_draft.py)으로는 연습 실행만 한다: 셀 입력과 변경 표시, 저장 없이 닫은 뒤 DB 가 그대로인지까지. 실제 저장은 사람이 확인해 save_scenario.json 으로 옮긴 뒤에.
        if not dry: print("[ERROR] 초안은 연습 실행(--dry)만 할 수 있음"); return 2
        try: dj = json.load(open(P("Doc", "asislive", mid, "save_scenario.draft.json"), encoding="utf-8"))
        except Exception as ex: print("[건너뜀] %s 저장 정의 초안 없음(저장 호출이 없는 화면이거나 asis_live_save_draft.py 미실행)" % mid); return 0
        dr = next((x for x in dj.get("drafts") or [] if x.get("status") == "키 대응 완료"), None)
        if not dr: print("[건너뜀] %s 초안 중 '키 대응 완료' 가 없음(%s) — 런처를 띄우지 않음" % (mid, ", ".join(sorted({str(x.get("status")) for x in dj.get("drafts") or []})))); return 0
        sc = {"name": "draft", "title": "초안 연습 실행", "table": dr["table"], "pk": dr["pk"], "match": dr["match"], "save_sp": dr["save_sp"], "side": dr.get("side") or [], "basis": dr.get("basis"),
              "edits": [{"pick": {"col": dr["edit"]["col"], "nonempty": True}, "edit": dr["edit"], "expect_before": 1}], "edit_candidates": dr.get("edit_candidates") or []}
    else:
      try: sc = json.load(open(P("Doc", "asislive", mid, "save_scenario.json"), encoding="utf-8"))
      except Exception as ex: print("[ERROR] 저장 시나리오 정의 없음: Doc/asislive/%s/save_scenario.json (%s)" % (mid, ex)); return 3
    name = av[av.index("--name") + 1] if "--name" in av and av.index("--name") + 1 < len(av) else ""
    if isinstance(sc, dict) and "scenarios" in sc:
        base = {k: v for k, v in sc.items() if k != "scenarios"}; lst = [dict(base, **x) for x in sc["scenarios"]]
        if not name:                                            # 시나리오 여러 개 = 하나씩 따로 실행(화면·런처를 새로 연다 — 앞 시나리오의 화면 상태가 남지 않게)
            import subprocess
            worst = 0
            for x in lst:
                print("=== 시나리오 %s — %s" % (x.get("name"), x.get("title") or ""), flush=True)
                worst = max(worst, subprocess.call([sys.executable, os.path.abspath(__file__), mid, "--name", str(x.get("name"))] + (["--dry"] if dry else []), cwd=ROOT))
            return worst
        sc = next((x for x in lst if str(x.get("name")) == name), None)
        if sc is None: print("[ERROR] 시나리오 이름 없음: %s" % name); return 2
    table, pk = sc["table"], sc["pk"]; kind = sc.get("kind") or "edit"; expect = sc.get("expect") or "saved"
    out = {"id": mid, "dry": dry, "name": sc.get("name") or "", "kind": kind, "scenario": sc, "at": time.strftime("%Y-%m-%d %H:%M:%S"), "status": "", "steps": []}
    d = P("Doc", "asislive", mid, "run_%s_save%s%s" % (time.strftime("%Y%m%d_%H%M%S"), ("_" + str(sc["name"])) if sc.get("name") else "", "_dry" if dry else "")); os.makedirs(d, exist_ok=True)
    if not R.acquire_lock("save"): print("[ERROR] 다른 AS-IS 실측이 끝나지 않음"); return 3
    host, info, why = R.start_session(P("Doc", "asislive", "_cmd_save_" + time.strftime("%H%M%S")))
    if host is None: print("[ERROR] 런처 세션 시작 실패: %s" % why); return 3
    wheres = []; before = None; side_pre = {}; rel = []          # rel = [{"table","pk","wheres","before"}] 저장 SP 가 함께 고치는 표
    def all_rows(): return [r for w in wheres for r in db_rows(table, w)]
    def rel_rows(x): return [r for w in x["wheres"] for r in db_rows(x["table"], w)]
    def rel_restore(tag):
        ok = True
        for x in rel:
            now_r = rel_rows(x)
            if not same(x["before"], now_r, x["pk"]):
                sq = restore(x["table"], x["pk"], x["before"], now_r); fin_r = rel_rows(x); okx = same(x["before"], fin_r, x["pk"]); ok = ok and okx
                out.setdefault(tag, []).append({"table": x["table"], "before": len(x["before"]), "after": len(now_r), "changed_sql": len(sq), "ops": sorted({q["op"] for q in sq}), "restored_same": okx})
                print("[복원] 함께 고쳐진 표 %s: 전 %d행 · 저장 뒤 %d행 · 되돌린 문장 %d · 복원 뒤 전 기록과 같음 %s" % (x["table"], len(x["before"]), len(now_r), len(sq), okx), flush=True)
            else: out.setdefault(tag, []).append({"table": x["table"], "before": len(x["before"]), "after": len(now_r), "changed_sql": 0, "restored_same": True})
        return ok
    def fail(note): out["status"] = "ERROR"; out["note"] = note; return 3
    def close_screen():
        host.send("policy", timeout=30, dialogs="close"); SR.sweep(host, out, None); host.send("close_screen", timeout=60); time.sleep(2); SR.sweep(host, out, None)
    try:
        r = host.send("open", timeout=180, id=mid)
        if not r.get("ok"): return fail("화면 열기 실패: %s" % r.get("error"))
        R.wait_quiet(R.now(), 3, 60); F.LOCK.clear()
        try: F.prefill(host, mid)
        except Exception: pass
        dq = len((host.send("dialogs", timeout=30).get("dialogs") or []))
        tf = R.now(); host.send("find", timeout=60); R.wait_find(host, tf, 0, 300)
        g = SR.grid_snap(host, rows=500, raw=True); sheet = next(iter(g.values()), None)
        if not sheet or not sheet["data"]:
            # 기본 조건으로 0행: 저장 대상 테이블에 행이 있는 Division 을 DB 에서 읽어 화면 목록에 있는 값으로 차례로 다시 조회한다(값 도출 근거 = 테이블 행 수)
            try: tdv = table_divisions(table)
            except Exception as ex: tdv = None; out["division_derive_error"] = str(ex)[:200]
            kind_, name_, items_ = SR.division_control(host); have = [SR.div_id(x) for x in items_]
            cand = [d for d, _n in (tdv or [])] if tdv is not None else list(have)
            out["division_derive"] = {"table_divisions": tdv, "screen_list": have, "tried": []}
            for dvv in [c for c in cand if c in have][:6]:
                o2 = {}
                if not SR.set_division(host, o2, dvv): out["division_derive"]["tried"].append({"division": dvv, "set": False, "note": o2.get("division_note") or (o2.get("division_set") or {}).get("error")}); continue
                try: F.prefill(host, mid)
                except Exception: pass
                tf = R.now(); host.send("find", timeout=60); R.wait_find(host, tf, 0, 300)
                g = SR.grid_snap(host, rows=500, raw=True); sheet = next(iter(g.values()), None); nrow = len(sheet["data"]) if sheet else 0
                out["division_derive"]["tried"].append({"division": dvv, "set": True, "rows": nrow})
                if nrow: out["division_used"] = dvv; print("[조건] 기본 조건 0행 → Division %s 로 다시 조회 %d행(테이블 %s 에 행이 있는 Division)" % (dvv, nrow, table), flush=True); break
        if not sheet or not sheet["data"]:
            # 그래도 0행: 조회 기간을 자료가 있는 기간으로 옮긴다(기간 조건 컨트롤 = 기간 선택기의 dp1, dp2)
            st_ = F.state(host); rng = next((c for c in st_ if c["t"] == "UsrDateRangePicker" and c.get("enabled", True)), None)
            if rng is not None:
                kind_, name_, items_ = SR.division_control(host); out["date_derive"] = []
                for dvv in ([out["division_derive"]["tried"][-1]["division"]] if (out.get("division_derive") or {}).get("tried") else [""]) + [SR.div_id(x) for x in items_][:8]:
                    if dvv in [x.get("division_try") for x in out["date_derive"]]: continue
                    try: dd = date_derive(mid, dvv)
                    except Exception as ex: dd = {"why": "조회 실패: %s" % str(ex)[:160]}
                    dd["division_try"] = dvv; out["date_derive"].append(dd)
                    if dd.get("why"):
                        if "Division" not in str(dd.get("why")) and not dd.get("table"): break
                        continue
                    if dvv and not SR.set_division(host, {}, dvv): continue
                    t9 = R.now(); r1 = r2 = {}
                    for prop_ in ("DateTime", "Value", "EditValue"):                # 날짜 선택기마다 쓰기 가능한 속성 이름이 다르다
                        r1 = host.send("set", timeout=120, name="dp1", prop=prop_, value=dd["from"]); r2 = host.send("set", timeout=120, name="dp2", prop=prop_, value=dd["to"]); dd["set_prop"] = prop_
                        if r1.get("ok") and r2.get("ok"): break
                    R.wait_quiet(t9, 2, 40)
                    dd["set"] = {"dp1": bool(r1.get("ok")), "dp2": bool(r2.get("ok")), "error": r1.get("error") or r2.get("error")}
                    tf = R.now(); host.send("find", timeout=60); R.wait_find(host, tf, 0, 300)
                    g = SR.grid_snap(host, rows=500, raw=True); sheet = next(iter(g.values()), None); dd["rows"] = len(sheet["data"]) if sheet else 0
                    if dd["rows"]: out["date_used"] = dd; print("[조건] 조회 기간 %s~%s%s 로 다시 조회 %d행(%s)" % (dd["from"], dd["to"], (" · Division " + dvv) if dvv else "", dd["rows"], dd["basis"]), flush=True); break
        if not sheet or not sheet["data"]: out["find_dialogs"] = dialogs_from(host, dq); return fail((("기간 도출 %s · " % json.dumps(out.get("date_derive"), ensure_ascii=False)[:400]) if out.get("date_derive") else "") + ("Division 도출 %s · " % json.dumps(out.get("division_derive"), ensure_ascii=False)[:300]) + "조회 결과 행 없음(메시지 %s)" % [x["text"][:60] for x in out["find_dialogs"]])
        cols = sheet["cols"]; ci = lambda tag: cols.index(tag)
        need = list(sc["match"].values()) + [o["edit"]["col"] for o in (sc.get("edits") or []) if o.get("edit")]
        miss = [t for t in need if t not in cols]
        if miss: return fail("정의의 열 %s 이 주 그리드 활성 시트(%s)에 없음 — 다른 시트·그리드의 저장은 이 도구가 아직 다루지 않음" % (",".join(miss), next(iter(g.keys()), "")))
        ops = sc.get("edits") or [{"pick": sc.get("pick"), "edit": sc.get("edit"), "expect_before": sc.get("expect_before", 1)}]
        if kind == "delete_popup": ops = [{"pick": sc.get("pick"), "expect_before": sc.get("expect_before")}]
        used = []; plan = []
        for op in ops:
            row = pick_row(sheet, cols, op.get("pick"), used)
            if row is None: return fail("대상 행을 찾지 못함(pick %s · 앞 %d행)" % (op.get("pick"), len(sheet["data"])))
            used.append(row); rw = sheet["data"][row]; where = {tc: rw[ci(gt)] for tc, gt in sc["match"].items()}; used_raw = False
            rv = (sheet.get("values") or [])[row] if row < len(sheet.get("values") or []) else None
            if rv and len(rv) == len(rw):                           # 표시 글자와 원래 값이 다른 열(콤보 설명 · 날짜 형식): 표시 글자로 DB 행이 없으면 원래 값으로 찾는다
                w2 = {tc: (key_form(rv[ci(gt)], rw[ci(gt)])) for tc, gt in sc["match"].items()}
                if w2 != where:
                    try: n1 = len(db_rows(table, where))
                    except Exception: n1 = 0
                    if n1 == 0:
                        try: n2 = len(db_rows(table, w2))
                        except Exception: n2 = 0
                        if n2 > 0: out.setdefault("raw_key_used", []).append({"row": row, "shown": where, "raw": w2}); where = w2; used_raw = True
            keyvals = {t: (key_form(rv[ci(t)], rw[ci(t)]) if used_raw and rv else rw[ci(t)]) for t in cols}      # 함께 고쳐지는 표의 조건도 같은 값 형태(표시 글자 또는 원래 값)로 만든다
            plan.append({"row": row, "values": dict(zip(cols, rw)), "keyvals": keyvals, "where": where, "op": op}); wheres.append(where)
        before = all_rows(); out["db_before"] = before; out["targets"] = [{"row": p["row"], "where": p["where"]} for p in plan]
        side_pre = side_keys(sc.get("side"), wheres)
        for x in sc.get("related") or []:
            xw = [{tc: p["keyvals"][gt] for tc, gt in x["match"].items()} for p in plan]; xx = {"table": x["table"], "pk": x["pk"], "wheres": xw}; xx["before"] = rel_rows(xx); rel.append(xx)
            print("[1] 함께 고쳐지는 표 %s 전 기록 %d행(조건 %s)" % (x["table"], len(xx["before"]), xw), flush=True)
        print("[1] 대상 행 %s · DB 전 기록 %d행" % ([p["row"] for p in plan], len(before)), flush=True)
        for p in plan:
            eb = p["op"].get("expect_before"); n = len(db_rows(table, p["where"]))
            if eb is not None and n != int(eb): return fail("DB 대상 행 수가 기대(%s)와 다름(%d · 조건 %s) — 저장하지 않음" % (eb, n, p["where"]))
        if kind == "delete_popup" and not before: return fail("지울 대상이 DB 에 없음 — 삭제 시나리오를 실행하지 않음")
        host.send("policy", timeout=30, dialogs="no")                    # 저장 동작 전까지는 어떤 확인 창에도 '아니오'
        changed = True
        if kind == "edit":
            er = host.send("act", timeout=120, method="OnClickEditButton", wait=5); SR.sweep(host, out, "OnClickEditButton"); out["edit_mode"] = er.get("edit_mode")
            if not er.get("edit_mode"): close_screen(); return fail("수정 모드가 켜지지 않음")
            out["cells"] = []
            for p in plan:
                e = p["op"]["edit"]; old = str(p["values"][e["col"]]).replace(",", "").strip()
                if e.get("rule") == "plus1" and not re.match(r"^-?\d+(\.\d+)?$", old): close_screen(); return fail("숫자가 아닌 값(%r)에는 +1 규칙을 쓸 수 없음" % old)
                if e.get("rule") == "plus1": new = str(int(old) + 1) if "." not in old else ("%." + str(len(old.split(".")[1])) + "f") % (float(old) + 1)      # 소수 자리는 그대로 둔다
                else: new = str(e.get("value"))
                cr = host.send("cell", timeout=60, row=str(p["row"]), col=e["col"], value=new)
                p["new"] = new; p["db_col"] = e.get("db_col") or e["col"]
                out["cells"].append({"row": p["row"], "col": e["col"], "old": old, "new": new, **{k: cr.get(k) for k in ("ok", "error", "before", "after", "action_before", "action_after", "locked", "entered")}})
                af = str(cr.get("after") or "").replace(",", "")
                ok1 = cr.get("ok") and (af == new or (re.match(r"^-?\d+(\.\d+)?$", af) and re.match(r"^-?\d+(\.\d+)?$", new) and float(af) == float(new))) and (cr.get("action_after") or "") in ("M", "I")
                print("[2] 행 %d %s: %s → %s · 변경 표시 '%s' → '%s'" % (p["row"], e["col"], cr.get("before"), cr.get("after"), cr.get("action_before"), cr.get("action_after")), flush=True)
                if not ok1 and sc.get("edit_candidates"):          # 초안: 첫 후보 열이 잠겨 있으면 다른 숫자 열 후보를 차례로 써 본다
                    for e2 in sc["edit_candidates"]:
                        if e2["col"] == e["col"]: continue
                        o2 = str(p["values"].get(e2["col"], "")).replace(",", "").strip()
                        if not re.match(r"^-?\d+(\.\d+)?$", o2): continue
                        n2 = str(int(o2) + 1) if "." not in o2 else ("%." + str(len(o2.split(".")[1])) + "f") % (float(o2) + 1)
                        c2 = host.send("cell", timeout=60, row=str(p["row"]), col=e2["col"], value=n2); a2 = str(c2.get("after") or "").replace(",", "")
                        out["cells"].append({"row": p["row"], "col": e2["col"], "old": o2, "new": n2, **{k: c2.get(k) for k in ("ok", "error", "before", "after", "action_before", "action_after", "locked", "entered")}})
                        print("[2] 행 %d %s: %s → %s · 변경 표시 '%s' → '%s'" % (p["row"], e2["col"], c2.get("before"), c2.get("after"), c2.get("action_before"), c2.get("action_after")), flush=True)
                        if c2.get("ok") and re.match(r"^-?\d+(\.\d+)?$", a2) and float(a2) == float(n2) and (c2.get("action_after") or "") in ("M", "I"):
                            ok1 = True; p["new"] = n2; p["db_col"] = e2["db_col"]; out["edit_col_used"] = e2["col"]; break
                changed = changed and bool(ok1)
            if not changed: out["note"] = "셀 값·변경 표시가 기대대로 바뀌지 않음 — 저장하지 않음"
            act_kw = dict(method="OnClickSaveButton", wait=10); policy = "default"
        else:
            pf = sc["popup"]; rw = plan[0]["values"]
            pr = host.send("act", timeout=120, click=sc["button"], wait=6, close_popup="0")
            if pf not in [x.get("form") for x in pr.get("popups") or []]: close_screen(); return fail("삭제 팝업 %s 이 열리지 않음(%s)" % (pf, pr.get("popups") or pr.get("error")))
            out["popup_set"] = []
            for ps in sc.get("popup_set") or []:
                want = str(rw[ps["from"]]); dd = host.send("dump", timeout=120, form=pf, rows=-1).get("data") or {}
                items = next(([str(x.get("text")) for x in c.get("items") or []] for c in dd.get("controls") or [] if "/" + ps["name"] + "/" in (c.get("path") or "") and (c.get("type") or "").endswith("CheckedListBox")), [])
                idx = next((i for i, t in enumerate(items) if t == want or t.split(" ")[0] == want or want in t), None)
                if idx is None: SR.sweep(host, out, None); close_screen(); return fail("팝업 조건 %s 에 값 %s 가 없음(항목 %d개 · 앞 %s)" % (ps["name"], want, len(items), items[:4]))
                t1 = R.now(); sr = host.send("set", timeout=120, form=pf, name=ps["name"], check=str(idx), only="1"); R.wait_quiet(t1, 2, 40)
                out["popup_set"].append({"name": ps["name"], "value": want, "index": idx, "ok": sr.get("ok"), "error": sr.get("error")})
            t1 = R.now(); fr = host.send("act", timeout=120, form=pf, method=sc["popup_find"], wait=4, close_popup="0"); R.wait_quiet(t1, 3, 90)
            pg = SR.grid_snap_form(host, pf, rows=3000); psheet = next(iter(pg.values()), None)
            if not psheet or not psheet["data"]: out["popup_dialogs"] = dialogs_from(host, dq); SR.sweep(host, out, None); close_screen(); return fail("삭제 팝업 조회 결과 없음(%s)" % [x["text"][:50] for x in out["popup_dialogs"]][-2:])
            pc = psheet["cols"]; prow = next((i for i, x in enumerate(psheet["data"]) if all(str(x[pc.index(pt)]) == str(rw[gt]) for pt, gt in sc["popup_match"].items())), None)
            if prow is None: SR.sweep(host, out, None); close_screen(); return fail("삭제 팝업에서 대상 행을 찾지 못함(팝업 %d행 · 조건 %s)" % (len(psheet["data"]), {pt: rw[gt] for pt, gt in sc["popup_match"].items()}))
            cr = host.send("cell", timeout=60, form=pf, row=str(prow), col=sc["popup_check_col"], value="True", mode="value")
            out["popup"] = {"rows": len(psheet["data"]), "row": prow, "values": dict(zip(pc, psheet["data"][prow])), "check": {k: cr.get(k) for k in ("ok", "error", "before", "after")}}
            print("[2] 삭제 팝업 %d행 · 대상 %d행째 체크 %s → %s" % (len(psheet["data"]), prow, cr.get("before"), cr.get("after")), flush=True)
            changed = bool(cr.get("ok")) and str(cr.get("after")) == "True"
            if not changed: out["note"] = "삭제 팝업에서 체크가 되지 않음 — 확인을 누르지 않음"
            act_kw = dict(form=pf, method=sc["popup_ok"], wait=10); policy = "yes"      # "삭제 하시겠습니까?" 에 예
        if dry or not changed:
            close_screen(); after = all_rows(); out["db_after"] = after
            out["status"] = ("DRY_OK" if changed else "ERROR") if same(before, after, pk) else "RESTORE_NEEDED"
            print("[3] 저장하지 않고 닫음 · DB 그대로 %s" % same(before, after, pk), flush=True)
        else:
            t_save = dt.datetime.now() - dt.timedelta(seconds=2)
            sv = do_save(host, out, d, sc, dry, act_kw, policy)
            after = all_rows(); out["db_after"] = after
            msgs = [x["text"] for x in out["save_dialogs"]]
            print("[3] 저장 호출 %d · 메시지 %s · DB 행 %d → %d" % (len(sv), [m[:40] for m in msgs], len(before), len(after)), flush=True)
            close_screen()
            out["restore_sql"] = restore(table, pk, before, after) if not same(before, after, pk) else []
            out["side_cleanup"] = side_clean(sc.get("side"), wheres, side_pre)
            fin = all_rows(); out["db_restored"] = fin; ok_r = same(before, fin, pk)
            ok_r = rel_restore("related_restore") and ok_r
            print("[4] 복원 %d문 · 덧붙은 행 삭제 %d · 복원 뒤 전 기록과 같음 %s" % (len(out["restore_sql"]), sum(1 for x in out["side_cleanup"] if x.get("rows")), ok_r), flush=True)
            if not ok_r: out["status"] = "RESTORE_FAIL"
            elif out.get("save_timeout"): out["status"] = "SAVE_TIMEOUT"
            elif expect == "message":
                hit = any(re.search(sc.get("message_re") or "", m) for m in msgs)
                out["status"] = "MESSAGE_OK" if hit and not sv and same(before, after, pk) else "MESSAGE_MISMATCH"
                out["note"] = "기대 메시지 /%s/ %s · 저장 호출 %d · DB 변화 %s" % (sc.get("message_re"), "뜸" if hit else "안 뜸", len(sv), "없음" if same(before, after, pk) else "있음")
            elif kind == "delete_popup":
                gone = len(after) == 0; flags = [str((c.get("params") or {}).get("p_active_flag")) for c in out["save_call"]]
                out["status"] = "OK" if sv and gone and all("D" in f for f in flags) else "SAVE_NOT_CONFIRMED"
            else:
                okv = bool(sv) and all(len(db_rows(table, p["where"])) >= 0 for p in plan)
                chk = []
                for p in plan:
                    rws = [r for r in after if all(str(r.get(k)) == str(v) for k, v in p["where"].items())]
                    chk.append(len(rws) == 1 and val_eq(rws[0].get(p["db_col"]), p["new"]))
                out["saved_check"] = chk; out["status"] = "OK" if okv and all(chk) else "SAVE_NOT_CONFIRMED"
                if out["status"] != "OK" and sv and same(before, after, pk) and any("실패" in m or "fail" in m.lower() for m in msgs):
                    out["status"] = "ASIS_SAVE_FAILED"; out["asis_error_logs"] = error_logs(t_save)      # AS-IS 가 저장 실패를 알림(저장 SP 는 불렸고 DB 는 그대로)
                    out["note"] = "AS-IS 저장 실패 메시지 %s · SP 오류 로그 %s" % (msgs[:1], [(x.get("program"), (x.get("message") or "")[:160]) for x in out["asis_error_logs"]][:2])
        return 0 if out["status"] in ("OK", "DRY_OK", "MESSAGE_OK") else 2
    except Exception as ex:
        out["status"] = out["status"] or "ERROR"; out["exception"] = "%s: %s" % (type(ex).__name__, str(ex)[:300]); print("[ERROR] " + out["exception"]); return 3
    finally:
        try:
            if before is not None and out.get("status") not in ("OK", "DRY_OK", "MESSAGE_OK"):
                now_rows = all_rows()
                if not same(before, now_rows, pk):                  # 어떤 경로로 끝났든 DB 가 전 기록과 다르면 되돌린다
                    out["restore_sql_final"] = restore(table, pk, before, now_rows); out["db_restored_final"] = all_rows()
                    print("[복원] 비정상 종료 경로 · 복원 뒤 전 기록과 같음 %s" % same(before, out["db_restored_final"], pk), flush=True)
                if rel and "related_restore" not in out: rel_restore("related_restore_final")
                extra = side_clean(sc.get("side"), wheres, side_pre) if side_pre else []
                if any(x.get("rows") for x in extra): out["side_cleanup_final"] = extra
        except Exception as ex2:
            out["restore_error"] = str(ex2)[:300]; print("[ERROR] 복원 확인 실패: %s" % out["restore_error"])
        try: host.send("policy", timeout=30, dialogs="close"); SR.sweep(host, out, None); host.send("quit", timeout=30)
        except Exception: pass
        json.dump(out, open(os.path.join(d, "save.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=jv)
        if "--draft" in av:                                      # 초안 연습 실행 결과를 초안 파일에 적는다(어느 초안이 실제로 조작되는지 추적)
            try:
                fp = P("Doc", "asislive", mid, "save_scenario.draft.json"); dj = json.load(open(fp, encoding="utf-8"))
                for x in dj.get("drafts") or []:
                    if x.get("save_sp") == sc.get("save_sp") and x.get("status") == "키 대응 완료": x["dry"] = {"status": out.get("status"), "note": out.get("note") or "", "at": out.get("at")}; break
                json.dump(dj, open(fp, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
            except Exception: pass
        print("[%s] %s 저장 시나리오 %s%s · %s" % (out.get("status"), mid, out.get("name"), " (저장 안 함)" if dry else "", out.get("note") or R.rel(d)))


if __name__ == "__main__":
    sys.exit(main())
