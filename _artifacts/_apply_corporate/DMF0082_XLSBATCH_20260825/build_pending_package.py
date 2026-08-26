# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260826_PENDING — 2026-08-25 수정분(전부 클라우드 미이관) 취합.
   구성: 라이브 신선 덤프 BODY + 룩업/메타 3본 + FE 4본 + VERIFY. 마커·건수 기계 검증."""
import io, sys, pathlib, shutil
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ---- 1) 라이브 BODY 신선 덤프 + 마커 15종 실측 ----
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'")
status = dict(cur.fetchall())
print("컴파일 상태:", status)
assert status.get("PACKAGE BODY") == "VALID"

EXPECT = {  # 2026-08-25 마커 15종 — 원장 REQ-1~14 전수 사상
    "SCPPLOC": 1, "AFSBLANK": 2, "AFSNVL": 1, "81AUTH": 3, "CUSTSUB": 1, "CURRNORM": 2,
    "XLSMASTER": 3, "XLSBATCH2": 1, "XLSPRJ": 1, "XLSPRICECOL2": 11,
    "SAVEPOPCLOB2": 3, "SAVEPOPPERF": 1,
}
counts = {m: src.count("E20260825-" + m) for m in EXPECT}
counts["XLSBATCH"] = src.count("E20260825-XLSBATCH") - counts["XLSBATCH2"]
counts["XLSPRICECOL"] = src.count("E20260825-XLSPRICECOL") - counts["XLSPRICECOL2"]
counts["SAVEPOPCLOB"] = src.count("E20260825-SAVEPOPCLOB") - counts["SAVEPOPCLOB2"]
EXPECT.update({"XLSBATCH": 1, "XLSPRICECOL": 3, "SAVEPOPCLOB": 1})
bad = {m: (counts[m], EXPECT[m]) for m in EXPECT if counts[m] != EXPECT[m]}
assert not bad, "마커 불일치: %s" % bad
print("마커 15종 실측 일치:", counts)

# ---- 2) 폴더 구성 ----
old_root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260825_DAILY")
root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING")
adb = root / "A_DB"
adb.mkdir(parents=True, exist_ok=True)

# BODY = 라이브 신선 덤프
banner = """-- ====================================================================================================
-- DMF0082_CLOUD_20260826_PENDING / PKG_DMF0082 BODY 전체 교체 (사내 라이브 신선 덤프 2026-08-26)
-- 2026-08-25 수정분 마커 15종 포함 (클라우드 미이관 전량):
--   SCPPLOC 1 / AFSBLANK 2 / AFSNVL 1 / 81AUTH 3 / CUSTSUB 1 / CURRNORM 2
--   / XLSMASTER 3 / XLSBATCH 1 / XLSBATCH2 1 / XLSPRJ 1
--   / XLSPRICECOL 3 / XLSPRICECOL2 11 / SAVEPOPCLOB 1 / SAVEPOPCLOB2 3 / SAVEPOPPERF 1
-- ⚠ 전체 교체 방식 — 클라우드 BODY 가 08-23 FULL 미적용(구세대)이면 그 누적 delta 도 함께 반영된다.
-- ⚠ 24_(HEADER_CONTENT) 와 같은 배포창에서 연속 적용 필수 (업로드 슬롯 계약 동기).
-- ====================================================================================================
"""
(adb / "02_PKG_DMF0082_BODY.sql").write_text(banner + "CREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")

# 룩업/메타/검증 — DAILY 최종본 복사
for f in ["21_LOOKUP_GET_ADMIN_GROUP_MEASURE_81.sql", "23_LOOKUP_LOC_81.sql",
          "24_EXCEL_HEADER_PRICECOL.sql", "90_VERIFY.sql"]:
    shutil.copy2(old_root / "A_DB" / f, adb / f)

# FE 4본 — 워킹트리 신선 복사
fe_src = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")
fe_dst = root / "B_FE" / "forecast-price"
(fe_dst / "components" / "modals").mkdir(parents=True, exist_ok=True)
(fe_dst / "utils").mkdir(parents=True, exist_ok=True)
fe_files = [
    ("components/ForecastPriceGrid.tsx", "음수 RED (REQ-7)"),
    ("components/modals/ForecastTemplateModal.tsx", "Excel Form 모달 (REQ-11/12)"),
    ("utils/forecast-price.excelForm.ts", "단가 테이블 고정 컬럼·빈컬럼 숨김 (REQ-11/12)"),
    ("ForecastPrice.tsx", "모달 배선·콤보 q() (REQ-12)"),
]
(fe_dst / "components").mkdir(parents=True, exist_ok=True)
for rel, _ in fe_files:
    dst = fe_dst / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(fe_src / rel, dst)

# ---- 3) 기계 검증 — 복사본 내용 무결 ----
body_copy = (adb / "02_PKG_DMF0082_BODY.sql").read_text(encoding="utf-8")
for m, n in EXPECT.items():
    base = body_copy.count("E20260825-" + m)
    if m == "XLSBATCH": base -= body_copy.count("E20260825-XLSBATCH2")
    if m == "XLSPRICECOL": base -= body_copy.count("E20260825-XLSPRICECOL2")
    if m == "SAVEPOPCLOB": base -= body_copy.count("E20260825-SAVEPOPCLOB2")
    assert base == n, "복사본 마커 %s: %d != %d" % (m, base, n)
m21 = (adb / "21_LOOKUP_GET_ADMIN_GROUP_MEASURE_81.sql").read_text(encoding="utf-8").count("MERGE INTO")
m23 = (adb / "23_LOOKUP_LOC_81.sql").read_text(encoding="utf-8").count("MERGE INTO")
m24 = (adb / "24_EXCEL_HEADER_PRICECOL.sql").read_text(encoding="utf-8").count("UPDATE ")
v90 = (adb / "90_VERIFY.sql").read_text(encoding="utf-8")
assert m21 == 72 and m23 == 6 and m24 == 1, (m21, m23, m24)
assert "SAVEPOPPERF" in v90 and "XLSPRICECOL2" in v90
fe_ok = all((fe_dst / rel).exists() for rel, _ in fe_files)
print("검증: 21=%d MERGE / 23=%d / 24=%d UPDATE / 90 마커15 포함 / FE 4본 %s" % (m21, m23, m24, fe_ok))

# 사내 룩업 현재값 == 이관 SQL 기대값 (재적재 재발 시 탐지용 스냅샷 대조)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082' AND SEGMENT3 LIKE '81%' AND VALID_YN='Y'")
n81 = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082' AND SEGMENT2 LIKE '81%' AND VALID_YN='Y'")
nloc = cur.fetchone()[0]
cur.execute("SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'")
hc = cur.fetchone()[0]
print("사내 현재값: GET_ADMIN 81계열=%d(기대72) / EDITABLE 81계열=%d(기대6) / HEADER=%s" % (
    n81, nloc, "신본" if "Project Code" in hc and "Plant Site" in hc else "구본!"))
con.close()
print("\n폴더 생성 완료:", root)
