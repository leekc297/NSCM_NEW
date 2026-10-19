"""PKG_DMF0040 — [E20260909-VERLABEL] 재반영 (현재 사내 본문 유지 + VERLABEL 4군데만 외과 병합).
배경: 09-09 15:30~15:56 사내 적용분이 15:59:11 타 출처 전체본(CRLF, '26.09.09 ssh' Team 영문표시 포함)으로 덮여 소실.
      이후 09-14 MULTISEL 이 그 본문 위에 적용되어 현재 사내 본문 = MULTISEL + ssh Team 영문 + VERLABEL 없음.
      Owner 필터 P53(같은 09-09 패키지)은 현재 본문에 이미 동일 반영 — 대상 아님(대조 실측).
usage: python apply_verlabel.py backup|test|apply
  backup : 현재 BODY → 00_BACKUP_ASIS/, 치환본 → 01_APPLY/ (DB 무변경)
  test   : 현재 DB 의 P_DMF0040_GET_MKT_FCST_COMPARISON 호출 → MEASURE 분포·정렬 출력 (조회 전용, ROLLBACK)
  apply  : 게이트(현재 BODY == 백업) → 배포 → STATUS/ERRORS/마커 확인
"""
import pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0040_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0040_BODY.sql"
WS = r"[ \t]*"

EDITS = [
    # ① 버전 분기 — MEASURE = 실제 VERSION_NO, 판정축 VERSION_TYPE 분리
    (re.compile(r"(?P<i>" + WS + r"), V\.VERSION_TYPE AS MEASURE, QTY, CELL_MODEL\n"),
     lambda m: (f"{m['i']}--[E20260909-VERLABEL] 화면 메저명 = 실제 선택 VERSION_ID (사용자 지시 2026-09-09, 재반영 2026-09-15)\n"
                f"{m['i']}--  AS-IS: , V.VERSION_TYPE AS MEASURE, QTY, CELL_MODEL\n"
                f"{m['i']}--  'Version(A)/(B)' 는 표시 라벨이면서 동시에 VERSION_SORT 판정 키였다.\n"
                f"{m['i']}--  표시축(MEASURE=VERSION_NO)과 판정축(VERSION_TYPE)을 분리해 파생표까지 통과시킨다.\n"
                f"{m['i']}, V.VERSION_NO AS MEASURE, QTY, CELL_MODEL\n"
                f"{m['i']}, V.VERSION_TYPE AS VERSION_TYPE   --[E20260909-VERLABEL] 판정축\n")),
    # ② Difference 분기 — UNION ALL 컬럼 정합
    (re.compile(r"(?P<head>" + WS + r", SUM\(CASE WHEN V\.VERSION_TYPE = 'Version\(A\)' THEN QTY ELSE -QTY END\) AS QTY\n"
                r"(?P<i>" + WS + r"), CELL_MODEL\n)"),
     lambda m: m["head"] + f"{m['i']}, 'Difference' AS VERSION_TYPE   --[E20260909-VERLABEL] UNION ALL 컬럼 정합\n"),
    # ③ VERSION_SORT 판정 — MEASURE → VERSION_TYPE
    (re.compile(r"(?P<i>" + WS + r"), CASE WHEN A\.MEASURE = 'Version\(A\)' THEN '1'\n"
                r"(?P<i2>" + WS + r")WHEN A\.MEASURE = 'Version\(B\)' THEN '2'\n"),
     lambda m: (f"{m['i']}--[E20260909-VERLABEL] AS-IS: CASE WHEN A.MEASURE = 'Version(A)' ... A.MEASURE = 'Version(B)'\n"
                f"{m['i']}, CASE WHEN A.VERSION_TYPE = 'Version(A)' THEN '1'\n"
                f"{m['i2']}WHEN A.VERSION_TYPE = 'Version(B)' THEN '2'\n")),
    # ④ 파생표 A (SELECT DISTINCT) — 판정축 통과
    (re.compile(r"(?P<head>SELECT DISTINCT F\.VERSION_NO, F\.DIVISION_ID, F\.PROJECT_CODE, F\.SCM_SITE_ID, F\.PLANT_SITE_ID\n"
                + WS + r", F\.ITEM_ID, F\.DOM_EXP, F\.FCST_TYPE, F\.INCOTERMS, F\.MEASURE)(?P<tail>[ \t]*\n)"),
     lambda m: m["head"] + ", F.VERSION_TYPE   --[E20260909-VERLABEL] 파생표 A 로 판정축 통과 (DISTINCT 카디널리티 불변 — MEASURE 에 함수종속)" + m["tail"]),
]


def patch(body: str) -> str:
    assert "E20260909-VERLABEL" not in body, "이미 VERLABEL 마커 존재 — 중단"
    for i, (rx, repl) in enumerate(EDITS, 1):
        n = len(rx.findall(body))
        assert n == 1, f"치환 #{i} 매칭 {n}건 (1건이어야 함)"
        body = rx.sub(repl, body, count=1)
    assert body.count("E20260909-VERLABEL") == 5, body.count("E20260909-VERLABEL")
    return body


def current_body(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0040' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall())


def ddl(body):
    head, rest = body.split("\n", 1)
    assert head.strip().upper().startswith("PACKAGE BODY"), head[:80]
    name = head.strip()[len("PACKAGE BODY"):].strip()
    if not name.upper().startswith("SCM_MGR."):
        name = "SCM_MGR." + name
    return "CREATE OR REPLACE PACKAGE BODY " + name + "\n" + rest


def run_sp(cur, oracledb, versions="MF_W_20260824_V001,MF_W_20260817_V001"):
    rc1, rc2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = ["40", "ALL", "ALL", "ALL", "ALL", "ALL", None, None, "20260801", "20260930", "minyonglee1",
            versions, "ALL", None, "False", "MONTHLY", "minyonglee1", "DMF0040", rc1, rc2]
    cur.callproc("SCM_MGR.PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", args)
    res = rc2.getvalue().fetchall() if rc2.getvalue() else []
    c = rc1.getvalue()
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
    mi = cols.index("MEASURE") if "MEASURE" in cols else None
    dist, order = {}, []
    for r in rows:
        v = r[mi] if mi is not None else None
        dist[v] = dist.get(v, 0) + 1
        if v not in order:
            order.append(v)
    return len(rows), dist, order, res


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            body = current_body(cur)
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(ddl(body) + "\n/\n", encoding="utf-8")
            TOBE.write_text(ddl(patch(body)) + "\n/\n", encoding="utf-8")
            print("written; lines", body.count("\n"))
        elif mode == "test":
            n, dist, order, res = run_sp(cur, oracledb)
            print("rows", n, "| MEASURE dist", dist, "| first-seen order", order, "| result", res)
            con.rollback()
        elif mode == "apply":
            assert ddl(current_body(cur)) + "\n/\n" == ASIS.read_text(encoding="utf-8"), "게이트 실패: 현재 BODY != 백업 — 그 사이 누군가 재배포. 중단"
            tobe = TOBE.read_text(encoding="utf-8")
            cur.execute(tobe.rstrip().rstrip("/").rstrip())
            cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0040'")
            print(cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0040' ORDER BY SEQUENCE")
            print("errors:", cur.fetchall() or 0)
            b = current_body(cur)
            print("applied == TOBE:", ddl(b) + "\n/\n" == tobe,
                  "| VERLABEL", b.count("E20260909-VERLABEL"), "| MULTISEL", b.count("E20260914-MULTISEL"),
                  "| ssh", b.count("26.09.09 ssh"))


if __name__ == "__main__":
    main()
