#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 최종 검증 — PROC_M ↔ SP positional 1:1 + 5축 + 실행."""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

PROC = "PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("""SELECT POSITION, ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS
               WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014'
               AND OBJECT_NAME='P_DMF0014_GET_EXCEL_FORM_DATA' ORDER BY POSITION""")
sp = cur.fetchall()
cur.execute("""SELECT SORT_ORD, COL_NM, COL_TP_CD FROM SCM_MGR.SCM_ADM_PROC_M
               WHERE PROC_NM=:n ORDER BY SORT_ORD""", {"n": PROC})
meta = cur.fetchall()

print("## PROC_M ↔ SP positional 대조 (hook proc-meta-signature-match)")
ok = len(sp) == len(meta)
print(f"   개수 SP={len(sp)} / PROC_M={len(meta)} → {'일치' if ok else '⛔ 불일치'}")
for i in range(max(len(sp), len(meta))):
    s = sp[i] if i < len(sp) else ("-", "-", "-")
    m = meta[i] if i < len(meta) else ("-", "-", "-")
    same_io = str(s[2]).upper().startswith(str(m[2]).upper()[:2])
    mark = "  " if same_io else "⛔"
    print(f" {mark} {s[0]:>3} {s[1]:<18}({s[2]:<3}) ↔ {m[0]:>3} {m[1]:<18}({m[2]})")

print("\n## 메타 5축")
for t, sql in [
    ("① EXCEL_COLUMNS", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0014'"),
    ("② 버튼 배선 FORM_DATA", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='FORM_DATA'"),
    ("③ 버튼 권한 FORM_DATA", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='FORM_DATA' AND USE_YN='Y'"),
    ("④ API_M", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0014_GET_EXCEL_FORM' AND USE_YN='Y'"),
    ("⑤ PROC_M", f"SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{PROC}'"),
    ("(참고) UPLOAD_SAVE 2단 배선", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='UPLOAD_SAVE'"),
]:
    cur.execute(sql)
    print(f"   {t:<26} = {cur.fetchone()[0]}")

print("\n## PKG 상태")
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'")
print(f"   컴파일 오류    {cur.fetchone()[0]}")

print("\n## 실행 스모크 (division=81 / WEEKLY)")
o1, o2 = con.cursor(), con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE-60,'YYYYMMDD'), TO_CHAR(SYSDATE+120,'YYYYMMDD') FROM DUAL")
fr, to = cur.fetchone()
cur.callproc("SCM_MGR." + PROC,
             ["81", "ALL", "ALL", "ALL", "ALL", "ALL", "ALL", fr, to, "WEEKLY", "ALL",
              "minyonglee1", "ADMIN", "minyonglee1", "DMF0014", o1, o2])
rows = o1.fetchmany(2)
print(f"   O_RC1 컬럼수 = {len(o1.description)} (기대 13) / 샘플 {len(rows)}행")
print(f"   O_RESULT_CURSOR = {o2.fetchall()}")
con.close()
