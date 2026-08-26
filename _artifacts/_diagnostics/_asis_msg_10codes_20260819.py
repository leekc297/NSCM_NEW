#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_asis_msg_10codes_20260819.py — AS-IS MSG 10코드 → TO-BE NOT EXISTS INSERT (사용자 지시 2026-08-19)

AS-IS TB_FX_MessageInfo(Ko/En/Ch) 실측 → TO-BE SCM_ADM_MSG_M 관례(기존 행 실측 승계)로
(코드×3언어) INSERT ... WHERE NOT EXISTS 생성 — 클라우드/사내 상황이 달라도 존재 시 불변.
산출: _artifacts/_apply_corporate/MSG_ASIS_10CODES_20260819.sql (+사내 적용·검증)
⚠ MSG00704 는 클라우드 선점 사고 전력(타 문구 기존재 가능) — NOT EXISTS 라 덮지 않음(보고에 명기).
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402
import pyodbc  # noqa: E402

CODES = ["MSG00467", "MSG00457", "MSG00428", "MSG00458", "MSG00328",
         "MSG00704", "MSG00459", "MSG00460", "MSG00462", "MSG00461"]
OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\MSG_ASIS_10CODES_20260819.sql"


def esc(s):
    return (s or "").replace("'", "''").strip()


def main():
    env = {}
    for line in open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8"):
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            k, v = line.split("=", 1)
            env[k] = v
    mcn = pyodbc.connect(
        f"DRIVER={{{env['ASIS_DB_DRIVER']}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
        f"DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']}")
    mc = mcn.cursor()
    ph = ",".join("?" * len(CODES))
    mc.execute(f"SELECT MessageID, Ko, En, Ch, UseYN FROM TB_FX_MessageInfo WHERE MessageID IN ({ph})", CODES)
    asis = {r[0]: {"KO": r[1], "EN": r[2], "CN": r[3], "USE": r[4]} for r in mc.fetchall()}
    mc.close()
    mcn.close()
    print("AS-IS 실측:")
    missing_asis = []
    for c in CODES:
        if c in asis:
            print(f"  {c}: KO='{(asis[c]['KO'] or '')[:60]}' USE={asis[c]['USE']}")
        else:
            missing_asis.append(c)
            print(f"  {c}: ⚠ AS-IS 부재")

    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    # TO-BE 관례 실측 (MSG00097 3언어 행 구조)
    cur.execute("SELECT COLUMN_NAME, NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_MSG_M' ORDER BY COLUMN_ID")
    cols = cur.fetchall()
    print("TO-BE 컬럼:", [c[0] for c in cols])
    cur.execute("SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MSG00097'")
    sample_cols = [x[0] for x in cur.description]
    sample = cur.fetchall()
    print("관례 표본 MSG00097:", [dict(zip(sample_cols, [str(v)[:30] for v in r])) for r in sample][:1])
    # 기존재 현황
    binds = ",".join(f":c{i}" for i in range(len(CODES)))
    cur.execute(f"SELECT MSG_ID, LANG_CD FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ({binds})", CODES)
    existing = {(r[0], r[1]) for r in cur.fetchall()}
    print(f"TO-BE 기존재: {sorted(existing)}")

    # 관례: (MSG_ID, LANG_CD, MSG_CTN, MSG_TP_CD?, USE_YN, 감사 4) — 표본 실컬럼로 생성
    lang_map = {"KO": "KO", "EN": "EN", "CN": "CN"}
    stmts = []
    header = ("-- MSG_ASIS_10CODES_20260819.sql — AS-IS TB_FX_MessageInfo 실측 10코드 x 3언어\n"
              "--   NOT EXISTS: 기존 코드 불변 (클라우드/사내 상이 안전 — 사용자 지시 2026-08-19)\n"
              "--   ⚠ MSG00704: 클라우드 선점 전력(타 문구 기존재 가능) — 기존재 시 미삽입이 의도된 동작\n")
    # 표본에서 컬럼 관례 파악
    smp = dict(zip(sample_cols, sample[0])) if sample else {}
    tp = esc(str(smp.get("MSG_TP_CD") or "")) if "MSG_TP_CD" in sample_cols else None
    for c in CODES:
        if c not in asis:
            continue
        for lang, col in (("KO", "KO"), ("EN", "EN"), ("CN", "CN")):
            txt = esc(asis[c][col]) or esc(asis[c]["KO"])
            colnames = ["MSG_ID", "LANG_CD", "MSG_NM", "MSG_DESC"]
            values = [f"'{c}'", f"'{lang_map[lang]}'", f"'{txt}'", f"'{txt}'"]
            if tp is not None:
                colnames.append("MSG_TP_CD")
                values.append(f"'{tp}'" if tp else "NULL")
            if "USE_YN" in sample_cols:
                colnames.append("USE_YN")
                values.append("'Y'")
            colnames += ["CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"]
            values += ["'admin'", "SYSDATE", "'admin'", "SYSDATE"]
            stmts.append(
                f"INSERT INTO SCM_MGR.SCM_ADM_MSG_M ({', '.join(colnames)})\n"
                f"SELECT {', '.join(values)} FROM DUAL\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M "
                f"WHERE MSG_ID='{c}' AND LANG_CD='{lang_map[lang]}');"
            )
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        f.write(header + "\n" + "\n\n".join(stmts) + "\n\nCOMMIT;\n")
    print(f"SQL 생성: {OUT} ({len(stmts)}문)")

    # 사내 적용
    for s in stmts:
        cur.execute(s.rstrip(";"))
    con.commit()
    cur.execute(f"SELECT MSG_ID, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ({binds}) GROUP BY MSG_ID ORDER BY MSG_ID", CODES)
    print("사내 적용 후 코드별 행수:", cur.fetchall())
    if missing_asis:
        print("⚠ AS-IS 부재로 미생성:", missing_asis)
    cur.close()
    con.close()


if __name__ == "__main__":
    main()

