# -*- coding: utf-8 -*-
"""
DMF0082 — 실제 그리드 줄 수 재현 (V_COLUMN 을 계정별로 그대로 구성)

최종 커서 = PIVOT 이므로 그리드 행 그레인 = V_COLUMN ∪ {SORT_ORDER_NO}.
  V_COLUMN = C_TITLE(계정 컬럼설정) + NOTATION + [E20260822-KEYCOL] 12컬럼(중복 제외)
이 스크립트는 그 목록을 **DB 에서 읽어 그대로 구성**한 뒤 MF_SP 를 DISTINCT 해서
화면에 보여야 할 줄 수를 센다. 2줄이면 두 줄을 좌우로 덤프한다. (읽기 전용)
"""
import re
import sys
import pathlib

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

USER = sys.argv[1] if len(sys.argv) > 1 else "minyonglee1"
DIV, VER = "40", "Current"
ITEMS = ("MCCM134010A1,MCCM131012A1,MCCM348014A3,MCCM356015A2,MCCM350415B1,"
         "MCCM348018A2,MCCM350415A1,MCCH129520B1,MCSS22561-C1,MIF489266C11")

KEYCOL = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP",
          "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID", "CURRENCY"]
# SRC0 파생 alias -> MF_SP 실제 컬럼
ALIAS = {"TEAM_ID": "DEPT_ID", "TEAM_NAME_KO": "DEPT_NAME_KO",
         "FORECAST_INFO_CELL_MODEL": "CELL_MODEL", "LAST_UPDATE_DATE": "CREATE_DATE"}
# BUCKET 은 SUN~SAT 연결 파생
BUCKET_SRC = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
# 업무키 = **사용자에게 보이는 컬럼 전부**(C_TITLE). 이게 다 같은데 2줄이면
# 화면상 구분이 안 되는 중복 줄이다 → 보이지 않는 그레인 컬럼이 범인.
BIZ = None  # 아래에서 C_TITLE 로 채운다


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""SELECT U.COLUMN_NAME FROM SCM_MGR.SCM_MST_TITLESET_USER U,
                          SCM_MGR.SCM_MST_SHEET_COLUMNS C
                    WHERE U.PROGRAM_ID=C.PROGRAM_ID AND U.SHEET_NAME=C.SHEET_NAME
                      AND U.COLUMN_NAME=C.COLUMN_NAME
                      AND U.PROGRAM_ID='DMF0082' AND U.SHEET_NAME='FcstNPrice'
                      AND U.USER_ID=:u AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'""", u=USER)
    ctitle = [r[0] for r in cur]
    cur.execute("""SELECT COLUMN_NAME, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_TITLESET_USER
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                      AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='M'
                    ORDER BY SORT_ORDER_NO""", u=USER)
    msel = [r[0] for r in cur]
    print("계정 {}\n  C_TITLE {}컬럼 : {}\n  선택 MEASURE {}종 : {}".format(
        USER, len(ctitle), sorted(ctitle), len(msel), msel))

    # V_COLUMN 구성 (패키지 L3449~3488 재현)
    vcol = list(ctitle) + ["NOTATION"]
    for k in KEYCOL:
        if k not in vcol:
            vcol.append(k)
    grain = vcol + ["SORT_ORDER_NO"]          # PIVOT 소스 SELECT 에 포함됨
    print("  ⇒ 그리드 그레인 {}컬럼".format(len(grain)))

    BIZ = sorted(ctitle)                       # 보이는 컬럼 전부
    hidden = [c for c in grain if c not in ctitle]
    print("  보이는 컬럼 {}개 / 보이지 않는 그레인 {}개: {}".format(
        len(BIZ), len(hidden), hidden))

    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_DMF0082_MF_SP'""")
    have = {r[0] for r in cur}

    def expr(c):
        if c in have:
            return c
        if c == "BUCKET":
            return " || ".join("NVL(TO_CHAR({}),'0')".format(x) for x in BUCKET_SRC)
        return ALIAS.get(c, c)

    sel = [(c, expr(c)) for c in grain]
    missing = [c for c, e in sel if e not in have and "||" not in e]
    if missing:
        print("  ⚠ MF_SP 에 없는 컬럼(무시): {}".format(missing))
    sel = [(c, e) for c, e in sel if e in have or "||" in e]

    rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [DIV, "ALL", "ALL", "ALL", "20260101", "20271231", "ALL", ITEMS,
                  VER, "Y", USER, "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
    print("\nRESULT:", rc[5].getvalue().fetchall()[:1])

    gsel = ", ".join("{} AS G_{}".format(e, c) for c, e in sel)
    bizj = ", ".join("G_" + c for c in BIZ)

    # 업무키별 그리드 줄 수
    cur.execute("""
      SELECT MEASURE, SUM(CASE WHEN C > 1 THEN 1 ELSE 0 END) AS 분리키, COUNT(*) AS 총줄수
        FROM ( SELECT {b}, G_MEASURE AS MEASURE, COUNT(*) OVER (PARTITION BY {b}) C
                 FROM ( SELECT DISTINCT {g} FROM SCM_MGR.GT_DMF0082_MF_SP ) )
       GROUP BY MEASURE ORDER BY 2 DESC, 1""".format(b=bizj, g=gsel))
    rows = cur.fetchall()
    print("\n{:16s} {:>10s} {:>10s}".format("MEASURE", "분리 업무키", "그리드 줄수"))
    print("-" * 40)
    for r in rows:
        print("{:16s} {:>10,d} {:>10,d}{}".format(r[0], r[1], r[2], "  <== 2줄 이상" if r[1] else ""))

    # 분리된 키의 두 줄 덤프
    cur.execute("""
      SELECT * FROM ( SELECT {b}, {g2}, COUNT(*) OVER (PARTITION BY {b}) C
                        FROM ( SELECT DISTINCT {g} FROM SCM_MGR.GT_DMF0082_MF_SP ) )
       WHERE C > 1 ORDER BY {b} FETCH FIRST 12 ROWS ONLY""".format(
        b=bizj, g=gsel, g2=", ".join("G_" + c for c, _ in sel if c not in BIZ)))
    cols = [d[0] for d in cur.description]
    dump = cur.fetchall()
    if dump:
        print("\n== 분리된 키의 줄 덤프 (다른 칸이 원인) ==")
        # 값이 서로 다른 컬럼만 표시
        for i in range(0, len(dump), 2):
            pair = dump[i:i + 2]
            if len(pair) < 2:
                break
            diff = [cols[j] for j in range(len(cols))
                    if cols[j] != "C" and pair[0][j] != pair[1][j]]
            key = " / ".join(str(pair[0][cols.index("G_" + c)]) for c in BIZ)
            print("  {}".format(key))
            for c in diff:
                j = cols.index(c)
                print("     {:22s} : {!r}  vs  {!r}".format(c, pair[0][j], pair[1][j]))
    else:
        print("\n분리된 키 없음 — DB 는 업무키당 1줄만 내보낸다")
