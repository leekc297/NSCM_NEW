"""[E20261006-ASISDELTA] AS-IS 운영 변경분 반영 2건 (asis_delta_20261002 1단계 SR 우선순위 25 · 29~30)

  ① RMA RTF 예외항목 비교 조건 — PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE  [E20260812-001054]
     AS-IS 운영 L1745-1746: DM_PLN_MKT_FCST RMA INSERT 의 RTF_SYS_RP arm NOT EXISTS 에서
       AND A.MEASURE = B.MEASURE  (주석 처리)  →  AND 'RTF_SYS_RP' = B.MEASURE
     같은 SR 의 나머지 3곳(AS-IS L1783·1874·1912 = TO-BE #005~#007)은 운영본이 옛 조건을 그대로 두어
     결과가 변경 전과 같다 → 반영 대상 아님 (사용자 기준 2026-10-06: 운영 실제 실행 동작만 반영).
  ② NN Mapping I/F 호출 분리 — PR_DM_XIF_ERP_NSD0010_R  [E20260701-001086]
     AS-IS 운영 L123-153: 'PR_DM_CUST_MODEL_MAPPING_IF 호출 START/END' 로그와 EXEC 호출을 블록 주석 처리
     (웹서비스는 I/F 테이블 INSERT 까지만 · 매핑 반영은 JOB.PR_DM_CUST_MODEL_MAPPING_IF 가 수행).

방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 치환 (고유 매칭 assert). 로컬 사본은 기준본이 아니다.
  python build_apply.py backup   # 착수 기준본 조회·백업 (DB 변경 없음)
  python build_apply.py build    # 01_*.sql 생성만 (DB 변경 없음)
  python build_apply.py apply    # FRESH-GATE 후 적용 + 검증
"""
import sys, os, hashlib, json, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
TYP = "PROCEDURE"
MARK = "[E20261006-ASISDELTA]"
STATE = os.path.join(HERE, "_fresh_state.json")

BAL = "PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE"
NSD = "PR_DM_XIF_ERP_NSD0010_R"

# ── ① BALANCE_CREATE ────────────────────────────────────────────────────────────────────────────
BAL_SR = "[E20260812-001054]"
BAL_OLD = "                              AND A.MEASURE       = B.MEASURE      AND A.INCOTERMS   = B.INCOTERMS"
BAL_NEW = ("                              AND 'RTF_SYS_RP'    = B.MEASURE      AND A.INCOTERMS   = B.INCOTERMS"
           "  /* " + BAL_SR + " A.MEASURE = B.MEASURE -> 비교대상 명시 (AS-IS 운영 L1745-1746) " + MARK + " */")
BAL_HDR_ANCHOR = " * 2026.07.06\tZIONEX\t\t[PJ202650304] NextSCM Migration"
BAL_HDR = " * 2026.08.28\tJSSBAE\t\t\t" + BAL_SR + "_화요일 Sales Plan 재수행 후 H5.5 RTF 오류 발생 " + MARK

# ── ② NSD0010_R ─────────────────────────────────────────────────────────────────────────────────
NSD_SR = "[E20260701-001086]"
NSD_HDR_ANCHOR = " * 2026.07.06   ZIONEX          [PJ202650304] NextSCM Migration"
NSD_HDR = " * 2026.07.06   JSSBAE          " + NSD_SR + "_ERP NN Master 프로시저 쿼리 튜닝 요청 " + MARK
NSD_FIRST = "        /* PR_DM_CUST_MODEL_MAPPING_IF 호출 START LOG */"
NSD_LAST = "        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);"
NSD_OPEN = ("        -- " + NSD_SR + "_웹서비스는 ERP -> SCM 데이터 Insert 작업까지만 한다. 주석처리 (START) " + MARK)
NSD_NOTE = "        -- 해당 작업은 [JOB.PR_DM_CUST_MODEL_MAPPING_IF] 작업에서 수행하도록 따로 뺌"
NSD_CLOSE = ("        -- " + NSD_SR + "_웹서비스는 ERP -> SCM 데이터 Insert 작업까지만 한다. 주석처리 (END) " + MARK)
CMT = "-- "
NSD_BLOCK_LINES = 22      # 호출 START LOG 머리 주석줄 ~ 호출 END LOG 호출줄


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur, name):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=name, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=name, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def one(lines, pred, what, lo=0, hi=None):
    hit = [i for i in range(lo, len(lines) if hi is None else hi) if pred(lines[i])]
    assert len(hit) == 1, f"{what}: 매칭 {len(hit)}건 (1건이어야 함) — 원문이 바뀌었거나 이미 반영됨"
    return hit[0]


def transform_bal(src):
    assert MARK not in src and BAL_SR not in src, "이미 반영됨"
    lines = src.split("\n")
    n0 = len(lines)
    # 대상 = 'RMA 처리 C20200518-000359' 바로 아래 DM_PLN_MKT_FCST INSERT 의 첫 arm(RTF_SYS_RP)
    a = one(lines, lambda l: l.strip() == "/* RMA 처리 C20200518-000359 */", "RMA 처리 앵커")
    hits = [i for i, l in enumerate(lines) if l == BAL_OLD]
    assert len(hits) == 2, f"옛 조건 줄 {len(hits)}건 (RTF_SYS_RP arm · RTF_PR arm 2건이어야 함)"
    i = hits[0]
    assert a < i < a + 25, "첫 번째 옛 조건 줄이 RMA 처리 블록 밖"
    stmt = lines[a:i]
    assert sum("INSERT INTO DM_PLN_MKT_FCST" in l for l in stmt) == 1
    assert sum("'RTF_SYS_RP' AS MEASURE" in l for l in stmt) == 1 and not any("'RTF_PR' AS MEASURE" in l for l in stmt)
    assert sum(l.strip() == "FROM GT_PRDM2_RTF_EXCEPTION_ITEM B" for l in stmt) == 1
    # 두 번째(RTF_PR arm)는 건드리지 않는다 — AS-IS 운영 L1783 은 옛 조건이 살아 있음
    assert any("'RTF_PR' AS MEASURE" in l for l in lines[i:hits[1]])
    lines[i] = BAL_NEW
    h = one(lines, lambda l: l == BAL_HDR_ANCHOR, "머리말 이력 앵커", 0, 110)
    lines.insert(h + 1, BAL_HDR)
    out = "\n".join(lines)
    assert len(lines) == n0 + 1 and out.count(MARK) == 2 and out.count(BAL_OLD) == 1 and out.count(BAL_NEW) == 1
    return out


def transform_nsd(src):
    assert MARK not in src and NSD_SR not in src, "이미 반영됨"
    lines = src.split("\n")
    n0 = len(lines)
    s = one(lines, lambda l: l == NSD_FIRST, "호출 START LOG 머리 주석") - 1          # 위쪽 구분선 줄
    assert lines[s].strip().startswith("/* ----") and lines[s - 1].strip() == ""
    e = one(lines, lambda l: l.strip() == "V_LOG_MESSAGE := 'PR_DM_CUST_MODEL_MAPPING_IF 호출 END';", "호출 END LOG") + 3
    assert lines[e] == NSD_LAST and lines[e + 1].strip() == "" and lines[e + 2].strip() == "EXCEPTION"
    assert e - s + 1 == NSD_BLOCK_LINES, e - s + 1
    block = lines[s:e + 1]
    assert sum(l.strip() == "PR_DM_CUST_MODEL_MAPPING_IF('ERP');" for l in block) == 1
    assert sum(l.strip().startswith("PR_SCM_SYS_LOG_BATCH(") for l in block) == 2
    code = "\n".join(l for l in block if not l.strip().startswith("/*"))      # 주석 줄 제외한 실행 줄
    assert not any(k in code for k in ("INSERT", "UPDATE", "DELETE", "MERGE", "COMMIT", "SELECT"))
    lines[s:e + 1] = [NSD_OPEN, NSD_NOTE] + [CMT + l for l in block] + [NSD_CLOSE]
    h = one(lines, lambda l: l == NSD_HDR_ANCHOR, "머리말 이력 앵커", 0, 20)
    lines.insert(h + 1, NSD_HDR)
    out = "\n".join(lines)
    assert len(lines) == n0 + 4 and out.count(MARK) == 3
    live = [l for l in lines if not l.lstrip().startswith("--")]
    assert not any("PR_DM_CUST_MODEL_MAPPING_IF(" in l for l in live), "호출이 실행 코드로 남음"
    return out


OBJS = {BAL: (transform_bal, "RMA RTF 예외항목 비교 조건 " + BAL_SR),
        NSD: (transform_nsd, "NN Mapping I/F 호출 분리 " + NSD_SR)}


def stamp(name, base):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    return f"-- SOURCE-FRESH: SCM_MGR.{name} {TYP} LAST_DDL={base['last_ddl']} FETCHED={now} DB=ZIOUI1\n"


def backup():
    st = {}
    with connect() as con:
        cur = con.cursor()
        for name in OBJS:
            b = read_source(cur, name)
            with open(os.path.join(HERE, f"00_BACKUP_{name}.sql"), "w", encoding="utf-8", newline="\n") as f:
                f.write(stamp(name, b) + ddl_text(b["src"]) + "/\n")
            with open(os.path.join(HERE, f"_base_{name}.txt"), "w", encoding="utf-8", newline="\n") as f:
                f.write(b["src"])
            st[name] = {k: b[k] for k in ("last_ddl", "status", "md5")}
            print("BACKUP", name, st[name])
    json.dump(st, open(STATE, "w"), indent=1)


def build(cur):
    res = {}
    for name, (fn, why) in OBJS.items():
        base = read_source(cur, name)
        new = fn(base["src"])
        with open(os.path.join(HERE, f"01_{name}.sql"), "w", encoding="utf-8", newline="\n") as f:
            f.write(stamp(name, base) + "-- " + MARK + " " + why + "\n" + ddl_text(new) + "/\n")
        print("BUILD", name, "base", base["last_ddl"], base["md5"],
              "lines", len(base["src"].split("\n")), "->", len(new.split("\n")))
        res[name] = (base, new)
    return res


def apply():
    saved = json.load(open(STATE))
    out = {}
    with connect() as con:
        cur = con.cursor()
        built = build(cur)
        for name, (base, new) in built.items():
            if saved[name]["md5"] != base["md5"]:
                sys.exit(f"ABORT {name}: 착수 시 백업본과 현재 DB 원문이 다름 — 재조회·재검토 필요")
        for name, (base, new) in built.items():
            # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
            now = read_source(cur, name)
            if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
                sys.exit(f"FRESH-GATE FAIL {name}: 착수 후 DB 원문 변경 — 중단")
            print("FRESH-GATE PASS", name, now["last_ddl"], now["md5"])
            cur.execute(ddl_text(new).rstrip())
            after = read_source(cur, name)
            cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence", n=name)
            errs = cur.fetchall()
            cur.execute("SELECT d.name, d.type, o.status FROM all_dependencies d JOIN all_objects o "
                        "ON o.owner=d.owner AND o.object_name=d.name AND o.object_type=d.type "
                        "WHERE d.referenced_owner='SCM_MGR' AND d.referenced_name=:n ORDER BY 1", n=name)
            deps = cur.fetchall()
            same = after["src"].rstrip() == new.rstrip()
            print("AFTER", name, after["last_ddl"], after["status"], "errors", len(errs), "same_as_built", same, "dependents", deps)
            out[name] = {"before": {k: base[k] for k in ("last_ddl", "status", "md5")},
                         "after": {k: after[k] for k in ("last_ddl", "status", "md5")},
                         "errors": errs, "same_as_built": same, "dependents": deps}
    json.dump(out, open(os.path.join(HERE, "_apply_result.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    cmd = sys.argv[1:]
    if cmd == ["backup"]:
        backup()
    elif cmd == ["apply"]:
        apply()
    else:
        with connect() as con:
            build(con.cursor())
