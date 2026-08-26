#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014_GRAYZERO_CLOUD_20260823 — 이관 산출물 생성 (사내 라이브 신선 덤프).

이관 대상 = 2026-08-23 정정 `[E20260823-GRAYZERO]` 1건뿐이다. PKG BODY 는 부분 패치가 불가하므로
**BODY 전체**를 싣되, 직전 클라우드 패키지(`DMF0014_CLOUD_20260818`) 대비 실제 delta 를 함께 계산해
"무엇이 같이 딸려가는지" 를 README/PRECHECK 에 실측으로 적는다(동봉 축 은폐 금지).
"""
import difflib
import io
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent
ADB = ROOT / "A_DB"
ADB.mkdir(exist_ok=True)
PREV = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0014_CLOUD_20260818\A_DB")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def src(kind):
    cur.execute(
        "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' "
        "AND TYPE=:t ORDER BY LINE", {"t": kind})
    return "".join(t for (t,) in cur if t is not None)


body = src("PACKAGE BODY")
spec = src("PACKAGE")
cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                 FROM ALL_OBJECTS
                WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'""")
status, ddl = cur.fetchone()
print(f"사내 BODY {body.count(chr(10)) + 1}줄 / STATUS={status} / LAST_DDL={ddl}")

(ADB / "01_PKG_DMF0014_BODY.sql").write_text(
    "-- DMF0014_GRAYZERO_CLOUD_20260823 / PKG BODY (사내 ALL_SOURCE 신선 덤프 2026-08-23)\n"
    "--   담긴 정정 = [E20260823-GRAYZERO] 회색(입력불가) 주차 값 0 적재 — 상세는 _README.md\n"
    "--   ⚠ 부분 패치 불가 — BODY 전체 교체다. 직전 패키지(0818) 대비 delta 는 README 실측표 참조.\n"
    + "CREATE OR REPLACE " + body + "\n/\n", encoding="utf-8")

# ── 직전 패키지 대비 delta 실측 ────────────────────────────────────
def strip(text):
    t = text.replace("\r\n", "\n").strip()
    t = re.sub(r"^--[^\n]*\n", "", t)          # 헤더 주석
    t = re.sub(r"^--[^\n]*\n", "", t)
    return t.replace("CREATE OR REPLACE ", "", 1).rstrip("/").strip()


prev_body = strip((PREV / "02_PKG_DMF0014_BODY.sql").read_text(encoding="utf-8"))
prev_spec = strip((PREV / "01_PKG_DMF0014_SPEC.sql").read_text(encoding="utf-8"))
diff = list(difflib.unified_diff(prev_body.split("\n"),
                                 body.replace("\r\n", "\n").strip().split("\n"), lineterm="", n=0))
adds = [l for l in diff if l.startswith("+") and not l.startswith("+++")]
dels = [l for l in diff if l.startswith("-") and not l.startswith("---")]
markers = sorted(set(re.findall(r"E2026\d{4}-[A-Z0-9]+", "\n".join(adds))))
spec_same = prev_spec == spec.replace("\r\n", "\n").strip()
print(f"직전(0818) 대비 BODY +{len(adds)}/-{len(dels)}줄 / 추가 마커 {markers}")
print(f"SPEC 동일 여부: {spec_same} (동일하면 SPEC 미동봉)")

(ROOT / "_survey").mkdir(exist_ok=True)
(ROOT / "_survey" / "delta_vs_20260818.diff").write_text("\n".join(diff), encoding="utf-8")
(ROOT / "_survey" / "delta_summary.txt").write_text(
    f"BODY 사내라이브 {body.count(chr(10)) + 1}줄 / STATUS {status} / LAST_DDL {ddl}\n"
    f"직전 패키지 DMF0014_CLOUD_20260818 대비: +{len(adds)}행 / -{len(dels)}행\n"
    f"추가분 마커: {markers}\n"
    f"SPEC 동일(미동봉 근거): {spec_same}\n", encoding="utf-8")

# ── 마커 실측 (VERIFY 기대값 산출) ─────────────────────────────────
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
                AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260823-GRAYZERO')>0""")
mk = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
                AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'THEN TO_NUMBER(V.VALUE) ELSE 0 END')>0""")
cs = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
                AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'Invalid Upload Week')>0""")
old = cur.fetchone()[0]
print(f"마커 {mk}행 / 적재 CASE {cs}행 / 구 반려문구 {old}행(기대 0)")
(ROOT / "_survey" / "delta_summary.txt").write_text(
    (ROOT / "_survey" / "delta_summary.txt").read_text(encoding="utf-8")
    + f"사내 실측 — 마커 {mk}행 / 적재CASE {cs}행 / 구 반려문구 {old}행\n", encoding="utf-8")
con.close()
print("생성 완료 ->", ADB)
