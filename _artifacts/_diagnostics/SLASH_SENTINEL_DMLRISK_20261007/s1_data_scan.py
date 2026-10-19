"""[조회 전용] '-'→'/' 일괄 변환(DML) 위험 점검 1 — 사내 ZIOUI1 실데이터·딕셔너리 스캔

모집단 = NULL센티널_슬래시전환_작업대상_20261007.xlsx / 1_컬럼판정 (1,797 컬럼). 보류 51 컬럼도 건수는 세되 held=True 로 표시.
컬럼별: '-' / '/' / '--' / 공백만 / 전체 행수 (테이블당 1회 전체 읽기)
딕셔너리: PK·UK·유니크 인덱스 · FK(자식/부모) · CHECK · 트리거 · 함수기반 인덱스 · 가상 컬럼 · 파티션 키
결과 = _scan_counts.json (테이블 단위로 이어쓰기 — 재실행 시 끝난 테이블은 건너뜀) · _scan_dict.json

  python s1_data_scan.py dict
  python s1_data_scan.py counts
"""
import sys, json, time, pathlib, shutil, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb, openpyxl

HERE = pathlib.Path(__file__).resolve().parent
SRC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\SLASH_SENTINEL_TARGET_20261006\NULL센티널_슬래시전환_작업대상_20261007.xlsx")
COUNTS = HERE / "_scan_counts.json"
DICT = HERE / "_scan_dict.json"
# 사용자 지시(2026-10-07): 1억 행 넘는 2개 테이블은 전체 읽기를 하지 않는다 → 컬럼 통계(_scan_stats.json)로만 판정
SKIP = {"SCP_ANL_SHIPMENT_PLAN_FG": "1억 행 초과(통계 1.54억) — 사용자 지시로 실측 제외",
        "SCP_ANL_PRODUCTION_PLAN": "1억 행 초과(통계 1.19억) — 사용자 지시로 실측 제외"}


def population():
    tmp = HERE / "_src_copy.xlsx"
    shutil.copy2(SRC, tmp)
    ws = openpyxl.load_workbook(tmp, read_only=True, data_only=True)["1_컬럼판정"]
    rows = list(ws.iter_rows(values_only=True))
    h = [str(c) for c in rows[0]]
    ix = {k: h.index(k) for k in ("스키마", "테이블", "컬럼", "데이터형", "현재 DB 상태", "AS-IS '-' 사용 분류", "[타 팀] 데이터 변환 분류")}
    pop = []
    for r in rows[1:]:
        if not r or not r[ix["테이블"]]: continue
        cls = str(r[ix["[타 팀] 데이터 변환 분류"]])
        pop.append(dict(owner=r[ix["스키마"]], table=r[ix["테이블"]], column=r[ix["컬럼"]], dtype=r[ix["데이터형"]],
                        state=r[ix["현재 DB 상태"]], use=r[ix["AS-IS '-' 사용 분류"]], cls=cls, held=cls.startswith("보류")))
    return pop


def connect():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    con.call_timeout = 30 * 60 * 1000
    return con


def do_counts():
    pop = population()
    by = {}
    for c in pop: by.setdefault((c["owner"], c["table"]), []).append(c)
    done = json.loads(COUNTS.read_text(encoding="utf-8")) if COUNTS.exists() else {}
    con = connect(); cur = con.cursor()
    cur.execute("SELECT sys_context('userenv','db_name'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); print("DB", cur.fetchone(), "tables", len(by), flush=True)
    cur.execute("SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER IN (%s)" % ",".join("'%s'" % o for o in {k[0] for k in by}))
    real = {(o, t, c): dt for o, t, c, dt in cur}
    for n, ((own, tab), cols) in enumerate(sorted(by.items()), 1):
        key = f"{own}.{tab}"
        if tab in SKIP:
            done[key] = {"skipped": SKIP[tab], "cols": {}}
            COUNTS.write_text(json.dumps(done, ensure_ascii=False), encoding="utf-8")
            print(f"[{n}/{len(by)}] {key} SKIP — {SKIP[tab]}", flush=True)
            continue
        if key in done and "error" not in done[key]: continue
        use = [c for c in cols if (own, tab, c["column"]) in real and real[(own, tab, c["column"])] in ("VARCHAR2", "CHAR", "NVARCHAR2", "NCHAR")]
        miss = [c["column"] for c in cols if c not in use]
        ent = {"missing_or_nonchar": miss, "cols": {}}
        if use:
            parts = []
            for c in use:
                q = '"%s"' % c["column"]
                parts += [f"SUM(CASE WHEN {q} = '-' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} = '/' THEN 1 ELSE 0 END)",
                          f"SUM(CASE WHEN {q} = '--' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} IS NOT NULL AND TRIM({q}) IS NULL THEN 1 ELSE 0 END)"]
            sql = f'SELECT COUNT(*), {", ".join(parts)} FROM "{own}"."{tab}"'
            t0 = time.time()
            try:
                cur.execute(sql); r = cur.fetchone()
                ent["rows"] = r[0]; ent["sec"] = round(time.time() - t0, 1)
                for i, c in enumerate(use):
                    v = r[1 + i * 4: 5 + i * 4]
                    ent["cols"][c["column"]] = dict(dash=v[0] or 0, slash=v[1] or 0, ddash=v[2] or 0, blank=v[3] or 0, held=c["held"], cls=c["cls"])
            except Exception as e:
                ent["error"] = str(e)[:300]
                try: con.ping()
                except Exception: con = connect(); cur = con.cursor()
        done[key] = ent
        COUNTS.write_text(json.dumps(done, ensure_ascii=False), encoding="utf-8")
        print(f"[{n}/{len(by)}] {key} rows={ent.get('rows')} sec={ent.get('sec')} {('ERR ' + ent['error']) if 'error' in ent else ''}", flush=True)
    print("done", datetime.datetime.now(), flush=True)


def do_dict():
    pop = population()
    tabs = sorted({(c["owner"], c["table"]) for c in pop})
    con = connect(); cur = con.cursor()
    cur.execute("CREATE PRIVATE TEMPORARY TABLE ORA$PTT_SLASH_T (OWNER VARCHAR2(128), TABLE_NAME VARCHAR2(128)) ON COMMIT PRESERVE DEFINITION") if False else None
    out = {"at": str(datetime.datetime.now()), "tables": len(tabs)}
    owners = sorted({o for o, _ in tabs}); tset = set(tabs)
    inown = ",".join("'%s'" % o for o in owners)

    def q(sql):
        cur.execute(sql); cols = [d[0] for d in cur.description]
        return [dict(zip(cols, [str(v) if v is not None and not isinstance(v, (int, float, str)) else v for v in r])) for r in cur]

    cons = q(f"""SELECT C.OWNER, C.TABLE_NAME, C.CONSTRAINT_NAME, C.CONSTRAINT_TYPE, C.STATUS, C.R_OWNER, C.R_CONSTRAINT_NAME, C.SEARCH_CONDITION_VC, C.DELETE_RULE
                   FROM ALL_CONSTRAINTS C WHERE C.OWNER IN ({inown}) AND C.CONSTRAINT_TYPE IN ('P','U','R','C')""")
    ccols = q(f"SELECT OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION FROM ALL_CONS_COLUMNS WHERE OWNER IN ({inown}) ORDER BY OWNER, CONSTRAINT_NAME, POSITION")
    idx = q(f"SELECT OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, UNIQUENESS, INDEX_TYPE, STATUS FROM ALL_INDEXES WHERE TABLE_OWNER IN ({inown})")
    icols = q(f"SELECT INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION FROM ALL_IND_COLUMNS WHERE TABLE_OWNER IN ({inown}) ORDER BY INDEX_OWNER, INDEX_NAME, COLUMN_POSITION")
    cur.execute(f"SELECT INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_POSITION, COLUMN_EXPRESSION FROM ALL_IND_EXPRESSIONS WHERE TABLE_OWNER IN ({inown})")
    iexp = [dict(INDEX_OWNER=a, INDEX_NAME=b, TABLE_OWNER=c, TABLE_NAME=d, COLUMN_POSITION=e, COLUMN_EXPRESSION=str(f)) for a, b, c, d, e, f in cur]
    cur.execute(f"SELECT OWNER, TRIGGER_NAME, TABLE_OWNER, TABLE_NAME, TRIGGERING_EVENT, STATUS, TRIGGER_BODY FROM ALL_TRIGGERS WHERE TABLE_OWNER IN ({inown})")
    trg = [dict(OWNER=a, TRIGGER_NAME=b, TABLE_OWNER=c, TABLE_NAME=d, EVENT=e, STATUS=f, BODY=str(g)) for a, b, c, d, e, f, g in cur]
    cur.execute(f"SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_DEFAULT FROM ALL_TAB_COLS WHERE OWNER IN ({inown}) AND VIRTUAL_COLUMN = 'YES' AND HIDDEN_COLUMN = 'NO'")
    vcol = [dict(OWNER=a, TABLE_NAME=b, COLUMN_NAME=c, EXPR=str(d)) for a, b, c, d in cur]
    pkey = q(f"SELECT OWNER, NAME, OBJECT_TYPE, COLUMN_NAME, COLUMN_POSITION FROM ALL_PART_KEY_COLUMNS WHERE OWNER IN ({inown})")
    skey = q(f"SELECT OWNER, NAME, OBJECT_TYPE, COLUMN_NAME, COLUMN_POSITION FROM ALL_SUBPART_KEY_COLUMNS WHERE OWNER IN ({inown})")
    mv = q(f"SELECT OWNER, MVIEW_NAME FROM ALL_MVIEWS WHERE OWNER IN ({inown})")
    out.update(cons=cons, ccols=ccols, idx=idx, icols=icols, iexp=iexp, trg=trg, vcol=vcol, pkey=pkey, skey=skey, mv=mv)
    DICT.write_text(json.dumps(out, ensure_ascii=False), encoding="utf-8")
    print({k: len(v) for k, v in out.items() if isinstance(v, list)})


if __name__ == "__main__":
    {"counts": do_counts, "dict": do_dict}[sys.argv[1]]()
