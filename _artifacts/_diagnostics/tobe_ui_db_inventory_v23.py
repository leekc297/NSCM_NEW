#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""tobe_ui_db_inventory_v23.py — TOBE_UI_DB객체_전수취합 **v2.3** 생성 (2026-08-10)

사용자 지시: *"공통과 현재 개발된 UI 에만 한정해서 TABLE 목록을 뽑고 싶습니다."* → *"v2.3 생성해주세요."*

## v2.2 → v2.3 변경점 (누락 근본원인 3층 대응)

v2.2 취합식 = `closure( API_M ROOT ∩ 취합대상 UI 43개 )` **단일 기점** → 3층에서 구멍:

| 층 | 사유 | v2.3 대응 |
|---|---|---|
| L1 | UI 가 취합 대상에서 빠짐(배선 52 중 9 제외) | **축A** 기점을 배선 보유 UI **전체 52개**로 |
| L2 | SP 는 있으나 **API_M 미등재**(1,042개) | **축B** BE 호출 SP + 프레임워크 명명 계열 |
| L3 | **참조 SP 자체가 없음**(BE 직접 접근) | **축C** BE 소스(MyBatis XML/Java) 직접 참조 |

⇒ 다른 모듈 전용 테이블은 기점에서 도달 불가라 **자동 제외**된다(전체 3,662 → 대상만).

## 시트
1. `1_TABLE_전수` — TABLE/VIEW 1행. OWNER/GTT/TOBE·ASIS 존재/분류/이관SOURCE/사용UI/포착축/근거
2. `2_UI별_TABLE` — UI × TABLE 매트릭스(개발 UI 52)
3. `3_공통_객체` — 축B/C 로만 잡힌 공통 계열(화면 배선 밖)
4. `4_개발UI목록` — 축A 기점 UI 와 ROOT 프로그램
5. `0_방법론` — 취합식·축 정의·한계 명시

⚠ `ASIS존재` = AS-IS(MSSQL) 접속 없이 v2.2 기존 판정을 승계하고, 신규분은 **'미확인'**.
   추측으로 채우지 않는다(hook #126 정직성).
"""
import datetime
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402
from openpyxl import Workbook, load_workbook  # noqa: E402
from openpyxl.styles import Font, PatternFill, Alignment  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE = ROOT / "nscm-be" / "src" / "main"
OUT = ROOT / "Doc" / "화면분석서"
PREV = OUT / "TOBE_UI_DB객체_전수취합_v2.2.xlsx"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── DB 사전 ────────────────────────────────────────────────────────
cur.execute("""SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS
                WHERE OWNER IN ('SCM_MGR','FP_MGR','SCMD_APP')
                  AND OBJECT_TYPE IN ('PACKAGE','PROCEDURE','FUNCTION','TABLE','VIEW')""")
owner_of, type_of = {}, {}
for o, n, t in cur.fetchall():
    n = n.strip().upper()
    if n not in type_of or t == "TABLE":
        owner_of[n], type_of[n] = o, t
PROGS = {n for n, t in type_of.items() if t in ("PACKAGE", "PROCEDURE", "FUNCTION")}
TABVIEW = {n for n, t in type_of.items() if t in ("TABLE", "VIEW")}
cur.execute("SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y'")
GTTS = {r[0].strip().upper() for r in cur.fetchall()}
print("DB: 프로그램 %d / TABLE·VIEW %d / GTT %d" % (len(PROGS), len(TABVIEW), len(GTTS)))

# ── 축A: 개발된 UI(배선 보유) → API_M ROOT ─────────────────────────
cur.execute("""SELECT DISTINCT B.MNU_ID, A.API_URL
                 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
                 JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID""")
ui_roots = {}
for mnu, url in cur.fetchall():
    s = (url or "").strip().upper()
    m = (mnu or "").strip().upper()
    if not s or not m:
        continue
    r = s.split("(")[0].split(".")[0]
    if r in PROGS:
        ui_roots.setdefault(m, set()).add(r)
UI_LIST = sorted(ui_roots)
print("축A: 개발 UI %d개 / ROOT %d개" % (len(UI_LIST), len({r for v in ui_roots.values() for r in v})))

# ── 축B/C: BE 소스 스캔 ────────────────────────────────────────────
be_files = [q for q in BE.rglob("*") if q.suffix.lower() in (".xml", ".java") and q.is_file()]
ident = re.compile(r"\b([A-Z][A-Z0-9_]{3,})\b")
be_progs, be_tabs = {}, {}
for q in be_files:
    try:
        txt = q.read_text(encoding="utf-8", errors="replace").upper()
    except Exception:  # noqa: BLE001
        continue
    rel = q.name
    for m in ident.finditer(txt):
        nm = m.group(1)
        if nm in PROGS:
            be_progs.setdefault(nm, set()).add(rel)
        elif nm in TABVIEW:
            be_tabs.setdefault(nm, set()).add(rel)
FW_PAT = re.compile(r"^(PKG_NSCM_UI_|UP_FX_|PR_GET_MENU|PR_SCM_ADM_|PKG_SCM0000$|FN_GET_VOC_)")
fw_progs = {n for n in PROGS if FW_PAT.search(n)}
print("축B: BE호출 SP %d + 프레임워크 %d / 축C: BE직접 TABLE %d"
      % (len(be_progs), len(fw_progs), len(be_tabs)))

# ── 의존 그래프 ────────────────────────────────────────────────────
cur.execute("""SELECT NAME, REFERENCED_NAME, REFERENCED_TYPE FROM ALL_DEPENDENCIES
                WHERE OWNER IN ('SCM_MGR','FP_MGR') AND REFERENCED_OWNER IN ('SCM_MGR','FP_MGR')""")
dep = {}
for n, rn, rt in cur.fetchall():
    dep.setdefault(n.strip().upper(), set()).add((rn.strip().upper(), rt))


def closure(seeds):
    seen, tabs, stack = set(), {}, list(seeds)
    while stack:
        o = stack.pop()
        if o in seen:
            continue
        seen.add(o)
        for rn, rt in dep.get(o, ()):
            if rt in ("TABLE", "VIEW"):
                tabs.setdefault(rn, set()).add(o)
            elif rt in ("PACKAGE", "PROCEDURE", "FUNCTION", "PACKAGE BODY") and rn not in seen:
                stack.append(rn)
    return tabs


# UI별 폐포 (사용UI 목록 산출)
tab_uis, tab_via = {}, {}
for ui in UI_LIST:
    for t, via in closure(ui_roots[ui]).items():
        tab_uis.setdefault(t, set()).add(ui)
        tab_via.setdefault(t, set()).update(via)
axis = {t: {"A"} for t in tab_uis}
# 축B
for t, via in closure(set(be_progs) | fw_progs).items():
    axis.setdefault(t, set()).add("B")
    tab_via.setdefault(t, set()).update(via)
# 축C
for t, files in be_tabs.items():
    axis.setdefault(t, set()).add("C")
    tab_via.setdefault(t, set()).update(files)

# ── v2.2 승계 (ASIS존재 / 이관SOURCE) ──────────────────────────────
prev_meta = {}
prev_objs = set()
try:
    wb = load_workbook(PREV, read_only=True, data_only=True)
    rows3 = list(wb["3_TABLE_이관SOURCE"].iter_rows(values_only=True))
    h3 = [str(c) for c in rows3[0]]
    for r in rows3[1:]:
        if not r or not r[1]:
            continue
        nm = str(r[1]).strip().upper()
        prev_meta[nm] = {"ASIS": str(r[4]) if len(r) > 4 and r[4] else "",
                         "분류": str(r[5]) if len(r) > 5 and r[5] else "",
                         "SRC": str(r[6]) if len(r) > 6 and r[6] else ""}
        prev_objs.add(nm)
    for r in list(wb["1_UI별_DB객체"].iter_rows(values_only=True))[1:]:
        if r and len(r) > 6 and r[6]:
            prev_objs.add(str(r[6]).strip().upper())
    wb.close()
    print("v2.2 승계: TABLE 메타 %d건" % len(prev_meta))
except Exception as e:  # noqa: BLE001
    print("v2.2 로드 실패(승계 없이 진행):", str(e)[:90])

BAK = re.compile(r"(_BAK|_BK\d|_BACKUP|_\d{8}$|BAK_)", re.I)
AXIS_NM = {"A": "A:개발UI", "B": "B:공통SP", "C": "C:BE직접"}

rows = []
for t in sorted(axis):
    if t not in TABVIEW:
        continue
    pm = prev_meta.get(t, {})
    uis = sorted(tab_uis.get(t, ()))
    rows.append([
        owner_of.get(t, ""), t, type_of.get(t, ""), "Y" if t in GTTS else "",
        "Y",                                            # TOBE존재 (DB 실측)
        pm.get("ASIS") or ("미확인" if t not in prev_objs else ""),
        "백업/스냅샷" if BAK.search(t) else (pm.get("분류") or "업무"),
        pm.get("SRC") or ("신규포착(v2.3)" if t not in prev_objs else ""),
        len(uis), ";".join(uis),
        ";".join(AXIS_NM[a] for a in sorted(axis[t])),
        ";".join(sorted(list(tab_via.get(t, ())))[:8]),
        "신규" if t not in prev_objs else "",
    ])
print("\n대상 TABLE/VIEW %d개 (신규 %d)" % (len(rows), sum(1 for r in rows if r[12] == "신규")))

# ── xlsx ───────────────────────────────────────────────────────────
HDR = Font(bold=True, color="FFFFFF")
FILL = PatternFill("solid", fgColor="4472C4")
wb2 = Workbook()

ws0 = wb2.active
ws0.title = "0_방법론"
for line in [
    ["TOBE_UI_DB객체_전수취합 v2.3", ""],
    ["생성", datetime.datetime.now().strftime("%Y-%m-%d %H:%M")],
    ["범위", "공통 + 현재 개발된 UI 한정 (사용자 지시 2026-08-10)"],
    ["", ""],
    ["취합식", "closure(축A) ∪ closure(축B) ∪ 축C"],
    ["축A 개발UI", "SCM_ADM_MNU_BTN_MPG_M 배선 보유 UI %d개 → SCM_ADM_API_M ROOT → ALL_DEPENDENCIES 재귀 폐포" % len(UI_LIST)],
    ["축B 공통SP", "BE MyBatis XML/Java 가 호출하는 SP %d개 + 프레임워크 명명 계열 %d개 → 폐포" % (len(be_progs), len(fw_progs))],
    ["축C BE직접", "BE 소스가 SQL 로 직접 읽는 TABLE/VIEW %d개 (참조 SP 없음)" % len(be_tabs)],
    ["", ""],
    ["v2.2 누락 근본원인", "취합식이 closure(API_M ∩ 취합UI 43개) 단일 기점이라 3층에서 구멍"],
    ["  L1", "UI 가 취합 대상에서 빠짐 — 배선 52 중 9개 제외(COM0007/0010/0011, DMF0035, DMF0043_01, DMF0068, DMF0074_40, SCP0013, SYS0017)"],
    ["  L2", "SP 는 있으나 API_M 미등재 — DB 프로그램 1,125 중 1,042개. 예: SCM_ADM_USER_BMK_M(즐겨찾기 UP_FX_*FAVORITE)"],
    ["  L3", "참조 SP 자체 없음(BE 범용 코드 직접 접근). 예: SCM_ADM_CMBO_SQL_M(콤보 SQL 156본), SCM_COM_SYS_LOG/SQL_LOG"],
    ["", ""],
    ["한계(명시)", "ASIS존재 = AS-IS(MSSQL) 미접속. v2.2 판정 승계, 신규분은 '미확인' — 추측으로 채우지 않음"],
    ["", "축B 프레임워크 계열은 명명 패턴 기반(PKG_NSCM_UI_/UP_FX_/PR_GET_MENU/PR_SCM_ADM_/PKG_SCM0000/FN_GET_VOC_)"],
    ["", "다른 모듈 전용 테이블은 기점 도달 불가로 자동 제외 (전체 %d → 대상 %d)" % (len(TABVIEW), len(rows))],
]:
    ws0.append(line)
ws0.column_dimensions["A"].width = 22
ws0.column_dimensions["B"].width = 150

ws1 = wb2.create_sheet("1_TABLE_전수")
cols1 = ["OWNER", "TABLE/VIEW명", "구분", "GTT", "TOBE존재", "ASIS존재", "분류",
         "이관SOURCE", "사용UI수", "사용UI목록", "포착축", "근거(경유 객체·파일)", "v2.2대비"]
ws1.append(cols1)
for r in rows:
    ws1.append(r)
for c in ws1[1]:
    c.font, c.fill, c.alignment = HDR, FILL, Alignment(horizontal="center")
ws1.freeze_panes = "A2"
for i, w in enumerate([10, 40, 8, 6, 10, 10, 14, 20, 9, 46, 22, 52, 10], 1):
    ws1.column_dimensions[chr(64 + i) if i <= 26 else "A"].width = w

ws2 = wb2.create_sheet("2_UI별_TABLE")
ws2.append(["MENU_ID", "TABLE/VIEW명", "구분", "GTT", "경유 ROOT"])
for ui in UI_LIST:
    for t, via in sorted(closure(ui_roots[ui]).items()):
        if t in TABVIEW:
            ws2.append([ui, t, type_of.get(t, ""), "Y" if t in GTTS else "",
                        ";".join(sorted(list(via))[:4])])
for c in ws2[1]:
    c.font, c.fill = HDR, FILL
ws2.freeze_panes = "A2"

ws3 = wb2.create_sheet("3_공통_객체")
ws3.append(["TABLE/VIEW명", "포착축", "근거", "비고"])
for r in rows:
    if "A:개발UI" not in r[10]:
        ws3.append([r[1], r[10], r[11], "화면 배선 밖 — 공통/프레임워크"])
for c in ws3[1]:
    c.font, c.fill = HDR, FILL
ws3.column_dimensions["A"].width = 40
ws3.column_dimensions["C"].width = 60

ws4 = wb2.create_sheet("4_개발UI목록")
ws4.append(["MENU_ID", "ROOT 프로그램 수", "ROOT 목록"])
for ui in UI_LIST:
    ws4.append([ui, len(ui_roots[ui]), ";".join(sorted(ui_roots[ui]))])
for c in ws4[1]:
    c.font, c.fill = HDR, FILL
ws4.column_dimensions["C"].width = 90

dst = OUT / "TOBE_UI_DB객체_전수취합_v2.3.xlsx"
wb2.save(dst)
print("[산출] %s" % dst)
print("  시트: 0_방법론 / 1_TABLE_전수(%d) / 2_UI별_TABLE / 3_공통_객체(%d) / 4_개발UI목록(%d)"
      % (len(rows), sum(1 for r in rows if "A:개발UI" not in r[10]), len(UI_LIST)))
con.close()
