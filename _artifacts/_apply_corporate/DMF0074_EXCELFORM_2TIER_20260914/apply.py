import oracledb, pathlib
d = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0074_EXCELFORM_2TIER_20260914")
base_def = ["Div","Plan Date","Team","End Customer","Project Code","Project","Model Code","Metal Link","Sales Site","Currency","FCST type","Exception","Energy"]
base_40 = [c for c in base_def if c not in ("Project Code","Project")]
groups = ["Key","Period(Fr)","Period(To)","Contract Price(/kg)","Change Price(/kg)","Metal Index (kg/Biz type)"]
elems = ["Ni","Co","Li2CO3","LIOH","Al","Mn","Cu"]
metal = [f"{g}_{e}" for g in groups for e in elems]
new = {"DMF0074": "|".join(base_def+metal), "DMF0074_40": "|".join(base_40+metal)}
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1")
cur = con.cursor()
cur.execute("SELECT PROGRAM_ID, HEADER_CONTENT FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0074','DMF0074_40') AND SHEET_NAME='Metal Link Price' ORDER BY 1")
old = dict(cur.fetchall())
assert set(old) == set(new), old
def upd(pid, hc, marker):
    return (f"UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS\n   SET HEADER_CONTENT = '{hc}'\n     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE\n"
            f" WHERE PROGRAM_ID = '{pid}' AND SHEET_NAME = 'Metal Link Price'; -- {marker}\n")
hdr = "-- [E20260914-EXCELFORM2TIER] DMF0074 Excel Form/Upload = AS-IS 2단 병합 헤더 양식\n-- 메탈 42 토큰: '그룹명_하위명' (BE ExcelUtils.convertGroupedHeaderExcelToJson 합성 키와 1:1)\n-- 대상 2행 (PK 없음 — 논리키 PROGRAM_ID+SHEET_NAME, 각 1행)\n"
(d/"01_UPDATE_SCM_ADM_EXCEL_COLUMNS.sql").write_text(hdr + "".join(upd(p, new[p], "E20260914-EXCELFORM2TIER") for p in sorted(new)) + "COMMIT;\n", encoding="utf-8")
(d/"99_ROLLBACK_SCM_ADM_EXCEL_COLUMNS.sql").write_text("-- 원복: 2026-09-14 적용 전 HEADER_CONTENT (사내 ZIOUI1 실측)\n" + "".join(upd(p, old[p], "ROLLBACK E20260914-EXCELFORM2TIER") for p in sorted(old)) + "COMMIT;\n", encoding="utf-8")
for p in sorted(new):
    cur.execute("UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS SET HEADER_CONTENT=:h, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE PROGRAM_ID=:p AND SHEET_NAME='Metal Link Price'", h=new[p], p=p)
    print(p, "rows updated:", cur.rowcount); assert cur.rowcount == 1
con.commit()
cur.execute("SELECT PROGRAM_ID, HEADER_CONTENT FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0074','DMF0074_40') ORDER BY 1")
for p, h in cur.fetchall():
    t = h.split("|"); print(p, len(t), "match" if h == new[p] else "MISMATCH", t[:3], t[-2:])
