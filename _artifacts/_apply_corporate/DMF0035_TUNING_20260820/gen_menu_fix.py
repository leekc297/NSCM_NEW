# -*- coding: utf-8 -*-
"""클라우드 부분적용 갭 정정 스크립트 생성 (사내 SELECT 만 — 파일 생성).

클라우드 90_VERIFY 실측 갭:
  SCM_ADM_MNU_M 0/1 · SCM_ADM_USER_GR_MNU_MPG_M 0/5 · MSG 54/66 · GRANT 4/8 · SYNONYM 4/8
가설: MNU_M INSERT 가 **부모 메뉴(UPPR_MNU_ID) FK** 로 실패 → 그에 종속된 GR_MNU 도 실패(부분 적용).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== MNU_M FK 제약 ==")
cur.execute("""SELECT C.CONSTRAINT_NAME, C.R_CONSTRAINT_NAME,
                      (SELECT TABLE_NAME FROM ALL_CONSTRAINTS R
                        WHERE R.OWNER=C.OWNER AND R.CONSTRAINT_NAME=C.R_CONSTRAINT_NAME) R_TABLE
               FROM ALL_CONSTRAINTS C
               WHERE C.OWNER='SCM_MGR' AND C.TABLE_NAME IN ('SCM_ADM_MNU_M','SCM_ADM_USER_GR_MNU_MPG_M')
                 AND C.CONSTRAINT_TYPE='R'""")
fks = cur.fetchall()
print("  ", fks if fks else "FK 없음 → 부모 FK 가설 기각")

print("\n== 메뉴 조상 체인 (사내) ==")
cur.execute("""SELECT MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD, NVL(UNIT_TP_CD,'-') UT, USE_YN
               FROM SCM_MGR.SCM_ADM_MNU_M
               START WITH MNU_ID='DMF0035' CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID""")
chain = cur.fetchall()
for r in chain:
    print("  ", r)

print("\n== GR_MNU 5행 (사내) ==")
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='SCM_ADM_USER_GR_MNU_MPG_M' ORDER BY COLUMN_ID""")
gm_cols = [r[0] for r in cur.fetchall()]
cur.execute(f"SELECT {','.join(gm_cols)} FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0035'")
gm_rows = cur.fetchall()
print(f"   {len(gm_rows)}행 / 컬럼 {gm_cols}")

# 메뉴 행 컬럼
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='SCM_ADM_MNU_M' ORDER BY COLUMN_ID""")
mn_cols = [r[0] for r in cur.fetchall()]
ids = [c[0] for c in chain]  # DMF0035 → 부모 → 조부
cur.execute(f"SELECT {','.join(mn_cols)} FROM SCM_MGR.SCM_ADM_MNU_M "
            f"WHERE MNU_ID IN ({','.join(':i'+str(k) for k in range(len(ids)))})",
            {f"i{k}": v for k, v in enumerate(ids)})
mn_rows = {r[mn_cols.index("MNU_ID")]: r for r in cur.fetchall()}


def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    if hasattr(v, "strftime"):
        return f"TO_DATE('{v:%Y%m%d%H%M%S}','YYYYMMDDHH24MISS')"
    return "'" + str(v).replace("'", "''") + "'"


def merge(table, cols, row, keys):
    vals = dict(zip(cols, row))
    for a in ("LAST_UPDATED_BY", "CREATED_BY"):
        if a in vals:
            vals[a] = "admin"
    on = " AND ".join(f"T.{k} = {lit(vals[k])}" for k in keys)
    upd = ", ".join(f"T.{c} = {lit(vals[c])}" for c in cols if c not in keys)
    return (f"MERGE INTO SCM_MGR.{table} T USING DUAL ON ({on})\n"
            f"WHEN MATCHED THEN UPDATE SET {upd}\n"
            f"WHEN NOT MATCHED THEN INSERT ({', '.join(cols)})\n"
            f"VALUES ({', '.join(lit(vals[c]) for c in cols)});\n")


out = [
    "-- =====================================================================================================",
    "-- 26_FIX_MENU_AND_GR_MNU.sql — 클라우드 **부분 적용 갭** 정정 (2026-08-20 실사고)",
    "--   증상: DMF0035 전 TYPE 조회 0행. 원인 = SCM_ADM_MNU_M 에 DMF0035 행 부재 →",
    "--         SCM_ADM_USER_MNU_EDIT_AUTH_V 0행 → 3 SP 의 INNER JOIN 이 전량 제거.",
    "--   클라우드 90_VERIFY 실측 갭: MNU_M 0/1 · USER_GR_MNU_MPG_M 0/5 (API_M·BTN_MPG·GR_BTN 은 정상)",
    "--   ⚠ **부모 메뉴부터** 적용한다(자식 먼저 넣으면 트리에서 안 보이거나 FK 로 실패).",
    "-- =====================================================================================================",
    "",
]
for mid in reversed(ids):  # 조상 → 자식 순
    if mid in mn_rows:
        out.append(f"-- 메뉴 행: {mid}")
        out.append(merge("SCM_ADM_MNU_M", mn_cols, mn_rows[mid], ["MNU_ID"]))
out.append("-- 사용자그룹 ↔ 메뉴 권한 (5행) — 이 행이 없으면 메뉴가 보여도 권한 축이 빈다")
gm_keys = [c for c in ("USER_GR_ID", "MNU_ID") if c in gm_cols]
for r in gm_rows:
    out.append(merge("SCM_ADM_USER_GR_MNU_MPG_M", gm_cols, r, gm_keys))
out.append("COMMIT;")
out.append("")
out.append("-- 적용 후 확인: 90_VERIFY.sql 의 V11 (메뉴 행 1 / 권한 뷰 > 0) → 화면 재조회")

dst = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\26_FIX_MENU_AND_GR_MNU.sql"
open(dst, "w", encoding="utf-8").write("\n".join(out) + "\n")
print(f"\n[emit] {dst}")
print(f"   메뉴 {len([m for m in ids if m in mn_rows])}행(조상 포함) + GR_MNU {len(gm_rows)}행")
con.close()
