# -*- coding: utf-8 -*-
"""이관 패키지 ↔ 현재 원본 드리프트 점검 (추정 금지 — 해시/행수 실측)."""
import hashlib
import io
import pathlib
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0074_CLOUD_20260818")
FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\metal-link-price")
LOC = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\public\locales")

drift = []

# ── ① FE 파일 해시 대조 ──
print("=== ① B_FE ↔ FE 작업트리 ===")
pkg_fe = PKG / "B_FE" / "metal-link-price"
cur_files = {f.relative_to(FE).as_posix() for f in FE.rglob("*") if f.is_file()}
pkg_files = {f.relative_to(pkg_fe).as_posix() for f in pkg_fe.rglob("*") if f.is_file()}
for only in sorted(cur_files - pkg_files):
    drift.append(f"FE 신규 미포함: {only}")
for only in sorted(pkg_files - cur_files):
    drift.append(f"FE 삭제분 잔존: {only}")
diff_n = 0
for rel in sorted(cur_files & pkg_files):
    a = hashlib.sha256((FE / rel).read_bytes()).hexdigest()
    b = hashlib.sha256((pkg_fe / rel).read_bytes()).hexdigest()
    if a != b:
        diff_n += 1
        drift.append(f"FE 내용 상이: {rel}")
print(f"  파일 {len(cur_files)}개 / 내용 불일치 {diff_n} / 목록차 "
      f"{len(cur_files ^ pkg_files)}")

for j in ("KO.json", "EN.json", "CN.json"):
    a = hashlib.sha256((LOC / j).read_bytes()).hexdigest()
    b = hashlib.sha256((PKG / "B_FE" / "locales" / j).read_bytes()).hexdigest()
    if a != b:
        drift.append(f"locales 상이: {j}")
print(f"  locales 3본 대조 완료")

# ── ② PKG 본문 ↔ 사내 DB ──
print("\n=== ② A_DB/02_BODY ↔ 사내 DB ALL_SOURCE ===")
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'"
            " AND TYPE='PACKAGE BODY' ORDER BY LINE")
live = "".join(r[0] for r in cur.fetchall())
pkgbody = (PKG / "A_DB" / "02_PKG_DMF0074_BODY.sql").read_text(encoding="utf-8")
body_in_pkg = pkgbody.split("CREATE OR REPLACE ", 1)[1].rsplit("\n/", 1)[0]
same = body_in_pkg.strip() == live.strip()
print(f"  본문 일치 = {same} (사내 {len(live.splitlines())}행 / 패키지 {len(body_in_pkg.splitlines())}행)")
if not same:
    drift.append("PKG BODY 가 사내 최신본과 다름 — 재취합 필요")
# 기대값 = **본문(ALL_SOURCE) 실측** — 파일 헤더 주석의 마커 1건은 제외한 수치다
for mark, exp in (("E20260816-NULLFIX", 9), ("E20260818-GTTDEL", 17)):
    n = body_in_pkg.count(mark)
    print(f"  마커 {mark} = {n} (기대 {exp})")
    if n != exp:
        drift.append(f"마커 {mark} {n}건 ≠ {exp}")

# ── ③ 메타 8축 행수 ↔ 사내 DB ──
print("\n=== ③ 10_META 축별 행수 ↔ 사내 DB ===")
meta = (PKG / "A_DB" / "10_META_DMF0074_ALL_AXES.sql").read_text(encoding="utf-8")
AX = {
    "SCM_ADM_MNU_M": "MNU_ID LIKE '%DMF0074%'",
    "SCM_ADM_API_M": "API_ID LIKE '%DMF0074%'",
    "SCM_ADM_PROC_M": "PROC_NM LIKE '%DMF0074%'",
    "SCM_ADM_MNU_BTN_MPG_M": "MNU_ID LIKE '%DMF0074%' OR API_ID LIKE '%DMF0074%'",
    "SCM_ADM_USER_GR_MNU_MPG_M": "MNU_ID LIKE '%DMF0074%'",
    "SCM_ADM_USER_GR_MNU_BTN_MPG_M": "MNU_ID LIKE '%DMF0074%'",
    "SCM_ADM_EXCEL_COLUMNS": "PROGRAM_ID LIKE '%DMF0074%'",
    "SCM_MST_SHEET_COLUMNS": "PROGRAM_ID LIKE '%DMF0074%'",
}
for t, w in AX.items():
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {w}")
    live_n = cur.fetchone()[0]
    m = re.search(rf"-- {t} : (\d+)행", meta)
    pkg_n = int(m.group(1)) if m else -1
    ok = live_n == pkg_n
    print(f"  {t:<32} 사내 {live_n:>4} / 패키지 {pkg_n:>4} {'OK' if ok else '⛔ 불일치'}")
    if not ok:
        drift.append(f"{t} 행수 사내 {live_n} ≠ 패키지 {pkg_n}")

# ── ④ 정정 SQL 존재 ──
print("\n=== ④ 필수 구성 파일 ===")
for f in ("00_GTT_DDL.sql", "01_PKG_DMF0074_SPEC.sql", "02_PKG_DMF0074_BODY.sql",
          "05_FIX_HISTORY_SEQ_RESEED.sql", "10_META_DMF0074_ALL_AXES.sql", "90_VERIFY.sql"):
    ex = (PKG / "A_DB" / f).is_file()
    print(f"  {'OK' if ex else '⛔ 부재'}  A_DB/{f}")
    if not ex:
        drift.append(f"A_DB/{f} 부재")

con.close()
print("\n" + "=" * 70)
print(f"드리프트 {len(drift)}건" + ("" if drift else " — 패키지가 현재 원본과 동일"))
for x in drift:
    print("  ⛔ " + x)
