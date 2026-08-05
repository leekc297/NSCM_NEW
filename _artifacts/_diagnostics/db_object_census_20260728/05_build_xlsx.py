#!/usr/bin/env python3
"""
05_build_xlsx.py — 최종 산출: Doc/화면분석서/TOBE_UI_DB객체_전수취합_v1.0.xlsx
시트: 0_요약_대사한계 / 1_UI별_DB객체 / 2_구분별_취합 / 3_TABLE_이관SOURCE / 4_UI_API_배선
"""
import csv, pathlib, re
from collections import defaultdict
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

HERE = pathlib.Path(__file__).resolve().parent
OUT = pathlib.Path(r"C:\Projects\NSCM\Doc\화면분석서\TOBE_UI_DB객체_전수취합_v1.1.xlsx")

def load(name):
    with (HERE / f"{name}.csv").open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))

# ---------- 카탈로그 ----------
objects = defaultdict(list)
for r in load("all_objects"):
    objects[(r["OWNER"], r["OBJECT_NAME"])].append((r["OBJECT_TYPE"], r["STATUS"]))
gtt = {(r["OWNER"], r["TABLE_NAME"]) for r in load("all_tables") if r["TEMPORARY"] == "Y"}
tobe_tables = {(r["OWNER"], r["TABLE_NAME"]) for r in load("all_tables")}

def ptype(k):
    ts = {t for t, _ in objects.get(k, [])}
    for pick in ("PACKAGE", "PACKAGE BODY", "TABLE", "VIEW", "MATERIALIZED VIEW", "PROCEDURE",
                 "FUNCTION", "SEQUENCE", "TYPE", "SYNONYM", "TRIGGER", "INDEX"):
        if pick in ts:
            return "PACKAGE" if pick == "PACKAGE BODY" else pick
    return sorted(ts)[0] if ts else "(미존재)"

def pstatus(k):
    ss = [s for _, s in objects.get(k, [])]
    return "INVALID" if "INVALID" in ss else ("VALID" if ss else "")

# ---------- ASIS 존재 — 1순위 실측(asis_tables.csv, sqlcmd 2026-07-28) / 2순위 Phase2 스냅샷 ----------
asis_tables, asis_snapshot = set(), set()
live_f = HERE / "asis_tables.csv"
if live_f.exists():
    for line in live_f.read_text(encoding="utf-8", errors="ignore").splitlines():
        parts = line.split(",")
        if len(parts) >= 2 and parts[1].strip():
            asis_tables.add(parts[1].strip().upper())
try:
    wb0 = openpyxl.load_workbook(r"C:\Projects\NSCM\_analysis\_phase2\02_DB_Inventory.xlsx", read_only=True)
    ws0 = wb0["Tables"]
    for row in ws0.iter_rows(min_row=3, values_only=True):
        if row and row[1]:
            asis_snapshot.add(str(row[1]).strip().upper())
    wb0.close()
except Exception as e:
    print("ASIS snapshot FAIL:", e)
ASIS_SRC = f"실측(sqlcmd LGCE_SCMDEV, {len(asis_tables)}건)" if asis_tables else f"Phase2 스냅샷({len(asis_snapshot)}건)"
if not asis_tables:
    asis_tables = asis_snapshot

# ---------- UI 축 ----------
ui_axis = {r["UI"]: r for r in load("ui_axis")}
mnu = {r["MNU_ID"]: r for r in load("mnu_m")}

def ui_kind(u):
    if u in ui_axis:
        return ui_axis[u]["KIND"]
    return "축외(메타전용)"

def ui_domain(u):
    if u == "COMMON":
        return "공통"
    a = ui_axis.get(u)
    return a["FE_PATHS"].split("/")[0] if a and a["FE_PATHS"] else "-"

def ui_name(u):
    return (mnu.get(u) or {}).get("MNU_DESC", "")

# ---------- 병합: (UI, OWNER, NAME) -> routes/depth ----------
# 변형 PROGRAM_ID 병합 (FE 실증: metal-link-price DIV40 formId / contribute-view PROGRAM_ID)
ALIAS = {"DMF0074_40": "DMF0074", "DMF0043_01": "DMF0043"}
AXIS = set(ui_axis) | set(ALIAS)          # 시트1~3 은 구현 UI 축 한정 (축외 메타는 시트4+시트0)
cell = defaultdict(lambda: {"routes": set(), "depth": None, "via": ""})
dropped_uis = defaultdict(int)

def add(u, o, n, route, depth=None, via=""):
    if not u or u == "?" or not n:
        return
    u = ALIAS.get(u, u)
    if u not in AXIS:
        dropped_uis[u] += 1
        return
    c = cell[(u, o, n)]
    c["routes"].add(route)
    if depth is not None and (c["depth"] is None or depth < c["depth"]):
        c["depth"] = depth
        c["via"] = via

for r in load("closure"):
    base = r["ROUTE"]
    if "추정" in base:
        continue  # v2.1 정책(2026-08-04): 명명 기반 추정 편입(NOTICE추정 등)은 실측 아님 — UI 귀속 불인정
    route = base if r["DEPTH"] == "0" else f"의존폐포({base})"
    add(r["UI"], r["OWNER"], r["OBJECT_NAME"], route, int(r["DEPTH"]), r["VIA"])
for r in load("dynamic_static"):
    for u in r["UIS"].split(";"):
        add(u, r["OBJECT_OWNER"], r["OBJECT_NAME"], "동적SQL(정적파싱)", via=f"{r['SRC_OWNER']}.{r['SRC_UNIT']}")
for r in load("dynamic_vsql"):
    if (r["OBJECT_OWNER"], r["OBJECT_NAME"]) not in objects:
        continue  # 옵티마이저 내부 가상객체(VW_DAG/VW_ORE/CMP3$ 등) 제외
    for u in r["UIS"].split(";"):
        add(u, r["OBJECT_OWNER"], r["OBJECT_NAME"], "동적SQL(V$실측)", via=r["SRC_UNIT"])
# v2.1 정책(2026-08-04): AWR/ASH 경로 UI 귀속 전면 불인정 — ASH PLSQL_ENTRY_OBJECT 는 SQL 이 호출한
# 공용 함수일 수 있어 발행자 증명이 아님 (실증: DMF0003×SCM_DNM_STOCK 오귀속, FN_GET_LOOKUP_VALUE 경유).
# dynamic_awr.csv 덤프는 참고용으로만 보존. 인정 경로 = 폐포/정적파싱/V$ PROGRAM_ID/콤보/등록쿼리/API_M.
# for r in load("dynamic_awr"):
#     if (r["OBJECT_OWNER"], r["OBJECT_NAME"]) not in objects:
#         continue
#     for u in r["UIS"].split(";"):
#         add(u, r["OBJECT_OWNER"], r["OBJECT_NAME"], "동적SQL(AWR)", via=r["SRC_UNIT"])
for r in load("sql_log_tables"):
    add("COMMON", r["OBJECT_OWNER"], r["OBJECT_NAME"], "동적SQL(BE로그)")
for r in load("combo_tables"):
    uis = [u for u in r["UIS"].split(";") if u and u != "(미사용)"]
    for u in (uis or ["COMMON"]):
        add(u, r["OBJECT_OWNER"], r["OBJECT_NAME"], "콤보SQL", via=r["SQL_ID"])
for r in load("dq_tables"):
    add("SYS0013", r["OBJECT_OWNER"], r["OBJECT_NAME"], "등록쿼리(SYS0013)", via=f"DQ_ID={r['DQ_ID']}")

# ---------- 미존재 사용분 편입 (사용자 지시 2026-07-28: 클라우드에서 가져와 사내 등록 예정) ----------
for r in load("ui_api"):
    if r["RESOLVE"] != "MISSING":
        continue
    u = ALIAS.get(r["UI"], r["UI"])
    if u not in AXIS:
        continue
    add(u, "SCM_MGR", r["API_URL"].strip().upper(),
        "API_M(미존재—등록불요 확정 20260729·배선정리 대상)", via=r["API_ID"])
add("COMMON", "SCM_MGR", "SCM_SYS_FILE",
    "BE직접SQL(미존재—제외 확정 20260729)", via="general/File.xml")
# EXCEL 스테일 2건 — PKG 멤버 실존 → 클라우드 아님, EXCEL_COLUMNS 메타 갱신 대상
add("DMF0082", "SCM_MGR", "DMF0082_EXCEL_UPLOAD",
    "EXCEL메타(스테일→PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD 갱신)", via="EXCEL_COLUMNS.STORAGE_SQL_ID")
add("DMF0003", "SCM_MGR", "DMF0003_CAR_FCST_EXCEL_UPLOAD",
    "EXCEL메타(스테일→PKG_DMF0003.P_DMF0003_CAR_FCST_EXCEL_UPLOAD 갱신)", via="EXCEL_COLUMNS.STORAGE_SQL_ID")

# INDEX 는 테이블 부속(V$/AWR plan 에만 등장) — 소속 테이블로 승격하지 않고 별도 구분 유지
# ---------- 시트1 데이터 ----------
s1 = []
for (u, o, n), c in sorted(cell.items()):
    k = (o, n)
    s1.append([ui_domain(u), ui_kind(u), u, ui_name(u),
               (ui_axis.get(u) or {}).get("FE_PATHS", ""),
               o, n, ptype(k), "Y" if k in gtt else "", pstatus(k),
               ";".join(sorted(c["routes"])), c["depth"] if c["depth"] is not None else "",
               c["via"]])

# ---------- 시트2 데이터 ----------
agg = defaultdict(lambda: {"uis": set(), "routes": set()})
for (u, o, n), c in cell.items():
    a = agg[(o, n)]
    a["uis"].add(u)
    a["routes"] |= c["routes"]
s2 = []
for (o, n), a in sorted(agg.items(), key=lambda x: (ptype(x[0]), x[0])):
    k = (o, n)
    s2.append([ptype(k), o, n, pstatus(k), "Y" if k in gtt else "",
               len(a["uis"]), ";".join(sorted(a["uis"])), ";".join(sorted(a["routes"]))])

# ---------- 시트3 데이터 (TABLE + GTT) ----------
META_RE = re.compile(r"^(SCM_ADM_|SCM_COM_|SCM_SYS_|SCM_MST_SHEET_|SCM_MST_TITLESET_)")
# AS-IS 멀티DB 실측 (2026-07-29 sys.synonyms 대조): LGCE_SCMDEV 에는 없으나 타 DB 에 동명 존재
ASIS_OTHER_DB = {
    "SCM_ITEM_M": "LGCE_FPDEV_TR", "SCM_PLANT_M": "LGCE_FPDEV_TR", "SCM_COMPANY_M": "LGCE_FPDEV_TR",
    "SCM_BOM_M": "LGCE_FPDEV_TR", "SCM_STOCK_H": "LGCE_FPDEV_TR", "SCM_AGING_STOCK_H": "LGCE_FPDEV_TR",
    "FP_FORMATION_SHORTER_LT_M": "LGCE_FPDEV_TR", "TH_ENG_NET_DEMAND": "ENG_SCP(DB)",
    "XIF_ERP_EDI_CALL_OFF_HEAD_R": "LGCE_INFDEV", "XIF_ERP_SALES_RESULT_R": "LGCE_INFDEV",
    "XIF_GSC_MOVE_EXCHANGE_RATE": "LGCE_INFDEV",
}
s3 = []
for (o, n), a in sorted(agg.items()):
    k = (o, n)
    if ptype(k) != "TABLE":
        continue
    is_gtt = k in gtt
    asis = "Y" if n.upper() in asis_tables else "N"
    if is_gtt:
        cls, src, why = "GTT", "TOBE DEV 구성(DDL만)", "GTT — 데이터 이관 불필요"
    elif n in ASIS_OTHER_DB:
        cls, src, why = ("업무(타DB)", f"ASIS QA 이관(원천 {ASIS_OTHER_DB[n]})",
                         f"ASIS 동명 테이블이 별도 DB {ASIS_OTHER_DB[n]} 에 존재 (sys.synonyms 실측 2026-07-29)")
    elif o == "INF_MGR":
        cls, src, why = "IF", "판정보류(IF 절차 별도)", "인터페이스 스키마"
    elif META_RE.match(n):
        cls, src, why = "META", "TOBE DEV 구성", "메타/설정/로그 계열 접두"
    elif asis == "Y":
        cls, src, why = "업무", "ASIS QA 이관", f"ASIS 동명 테이블 존재({ASIS_SRC})"
    else:
        cls, src, why = "업무", "판정보류(ASIS 없음)", f"ASIS({ASIS_SRC})에 동명 없음 — 신규/개명 확인 필요"
    s3.append([o, n, "Y" if is_gtt else "", "Y", asis, cls, src,
               len(a["uis"]), ";".join(sorted(a["uis"])), why])

# ---------- 시트4: UI-API 배선 ----------
s4 = [[r["UI"], r["API_ID"], r["API_TP_CD"], r["API_URL"], r["RESOLVE"], r["ROOT"]]
      for r in load("ui_api")]

# ---------- 시트0: 요약/대사/한계 ----------
recon1 = (HERE / "recon_step1.txt").read_text(encoding="utf-8").splitlines()
dynrep = (HERE / "dynamic_report.txt").read_text(encoding="utf-8").splitlines()
n_ui = len({u for (u, _, _) in cell})
chk1 = len(s1)
chk2 = sum(x[5] for x in s2)
s0 = [
    ["TO-BE 개발 UI 기준 DB 객체 전수 취합 v1.1 (2026-07-28 — ASIS 실측 반영 + 미존재 사용분 편입/클라우드 등록 목록)"],
    ["원천: 사내 Oracle OCGSCMD_P01 read-only 실측 (메타/카탈로그/V$/AWR/SQL_LOG) + nscm-fe/nscm-be 소스 + ASIS MSSQL(LGCE_SCMDEV) 실측"],
    [""],
    ["[기계 대사]"],
    [f"시트1 행수 {chk1} == 시트2 사용UI수 합계 {chk2} : {'PASS' if chk1 == chk2 else 'FAIL'}"],
    [f"UI 축 수(객체 보유): {n_ui} / 객체 unique: {len(agg)} / TABLE(시트3): {len(s3)}"],
    [""],
    ["[Step1 대사 — FE ↔ MNU_M]"],
] + [[x] for x in recon1] + [
    [""],
    ["[동적 SQL 4-경로 리포트]"],
] + [[x] for x in dynrep] + [
    [""],
    ["[한계 (은폐 없음)]"],
    [f"1. 시트3 ASIS존재 = {ASIS_SRC} 실측 기준 (2026-07-28 재연결 완료 — 구 스냅샷 1,193 → 실측 반영). 테이블명에 콤마 포함 시 파싱 한계."],
    ["2. PKG_SYS0013 은 사용자 등록 쿼리 실행기 — 실행 객체는 SCM_ADM_DQ_LIST 등록분(전수 파싱 완료, 27건)에 의존. 향후 등록되는 쿼리는 본 취합에 없음."],
    ["3. AWR plan 객체 중 ASH 로 PL/SQL 유닛 귀속이 불가한 SQL 객체행 4,338건 제외(배치/타시스템/애드혹 포함 — UI 귀속 불가). V$/정적파싱이 주경로."],
    ["4. SCM_COM_SQL_LOG 파싱은 1,000자 절단 텍스트 기준 — 초장문 SQL 후반 테이블 누락 가능(COMMON 검증 경로로만 사용)."],
    ["5. SYS/PUBLIC 소유 내장 객체(DUAL/DBMS_* 등)는 이관 무관으로 제외."],
    ["6. 콤보 6건(YesOrNo 등)은 DUAL 정적 리스트 — 객체 없음 정상. FE 미검출 콤보 65건 중 SHEET_COLUMNS 메타로 47건 추가 매핑, 잔여는 미구현 화면 몫."],
    [""],
    ["[주요 발견 (조치 후보)]"],
    ["F1. SCP0013(FE 구현)이 SCM_ADM_MNU_M 에 없음 — 메뉴 미등록."],
    ["F2. COM0012(ProjectModal)가 MNU_M 에 없음 (COM0001~11 은 POPUP 으로 등록됨)."],
    ["F3. EXCEL_COLUMNS.DMF0082 STORAGE_SQL_ID='DMF0082_EXCEL_UPLOAD' — PKG 취합 시 DROP 된 standalone 지향(스테일). PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD 로 갱신 필요."],
    ["F4. PKG_SYS0014 스펙만 존재(INVALID, body 없음) — API SYS0014_GET_DIVISION_DATA 배선 위험."],
    ["F5. [해소 2026-07-29] SYS0011 배선 API 3건 — PKG_SYS0011.P_SYS0011_SAVE_MY_AUTH_DATA(PROC_SAVE) 로 사내 재배선 완료 (SYS0011_REWIRE_20260729 패키지). 클라우드는 02_CHECK 점검 SQL 로 확인 후 동일 적용 판단."],
    ["F6. general/File.xml 의 SCM_SYS_FILE 테이블이 사내 DB 미존재 (G5 파일기능 미이관)."],
    ["F7. 축외(메타전용) 키는 시트1~3 제외, 시트4 배선에 유지: " + ", ".join(f"{k}({v}행)" for k, v in sorted(dropped_uis.items()))],
    ["F8. SCP0013_GET_PRODUCTION_PLAN_LINEBY = INVALID — 참조 GTT 'GT_SCP0_DynamicPivot_SCP0013_P/_t/_k' 가 DB 미존재(동적 TRUNCATE 대상). GT_SCP0013 은 존재 — SP 미완성 이관 상태."],
    ["F9. 변형 PROGRAM_ID 병합: DMF0074_40→DMF0074(metal-link DIV40 formId), DMF0043_01→DMF0043(contribute-view 실제 PROGRAM_ID — MNU_M leaf 등록)."],
    ["F10. SYS0016(notice-setup): FE 는 표준 훅 사용이나 사내 API_M/BTN_MPG 배선 0건 — DB 실존 NOTICE SP(SCM0010_GET/SAVE_NOTICE_* 등)를 명명 기반 추정으로 편입(연결경로 'NOTICE추정(API_M미배선)'). 이관 시 SYS0016 API_M/BTN 등록 필요. 이미지 업로드는 SCM_SYS_FILE 미존재(F6)와 동일 계열."],
    ["F11. EXCEL_COLUMNS.DMF0003(Car Fcst) STORAGE_SQL_ID='DMF0003_CAR_FCST_EXCEL_UPLOAD' — standalone 미존재이나 PKG_DMF0003.P_DMF0003_CAR_FCST_EXCEL_UPLOAD 실존 → 메타 갱신 대상(F3 동일 패턴)."],
    [""],
    ["[클라우드→사내 등록 — 2026-07-29 최종 확정 (PRECHECK 실측 + 사용자 결정)]"],
    ["C4. PKG_SYS0014 SPEC+BODY — 클라우드 VALID 존재, 추출 완료 → _deploy_packages/CLOUD_DDL_FETCH_20260729/C4_PKG_SYS0014.sql 사내 등록 대상 (유일)"],
    ["제외 C1~C3. P_SCM0008_ADD/REQUEST/DELETE_MY_AUTH — 클라우드에도 실체 없음(dangling SYNONYM 만) + 사용자 확정 불필요. SYS0011 버튼 3종은 2026-07-29 사내 재배선 완료(→PKG_SYS0011.P_SYS0011_SAVE_MY_AUTH_DATA)"],
    ["제외 C5. SCM_SYS_FILE — 클라우드에도 미존재 + 사용자 확정 제외 (필요 시 리포 baseline _artifacts/G5_file_transfer_metadata.sql)"],
    ["※ 클라우드 불필요(사내 조치): DMF0082/DMF0003 EXCEL_COLUMNS 메타 갱신 2건(F3/F11), SYS0016 API_M/BTN 배선 등록(F10)"],
    ["※ 축외 참고(FE 미배선 legacy — 등록 불요 판단): P_SCM0005_SAVE_USER_GROUP / P_SCM0008_GET_AUTH_GROUP_INFO / P_SCM0008_GET_DIVISION_LIST / P_SCM0008_GET_MY_AUTH_LIST / P_SCM0008_GET_CURRENT_USER / P_SCM0009_GET_APPROVAL_LIST / P_SCM0009_APPROVE_AUTH / P_SCM0009_REJECT_AUTH (SYS0011/0012 PKG 로 대체 구현됨)"],
]

# ---------- xlsx ----------
wb = openpyxl.Workbook()
H = Font(bold=True, color="FFFFFF")
FILL = PatternFill("solid", fgColor="4472C4")

def sheet(ws, header, rows, widths):
    ws.append(header)
    for c in ws[1]:
        c.font = H; c.fill = FILL; c.alignment = Alignment(vertical="center")
    for row in rows:
        ws.append(row)
    ws.freeze_panes = "A2"
    ws.auto_filter.ref = f"A1:{get_column_letter(len(header))}{ws.max_row}"
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[get_column_letter(i)].width = w

ws0 = wb.active; ws0.title = "0_요약_대사한계"
for row in s0:
    ws0.append(row)
ws0.column_dimensions["A"].width = 160
sheet(wb.create_sheet("1_UI별_DB객체"),
      ["도메인", "UI구분", "MENU_ID", "화면명", "FE폴더", "OWNER", "객체명", "객체구분", "GTT",
       "STATUS", "연결경로", "의존깊이", "VIA(근거)"],
      s1, [10, 12, 11, 26, 30, 10, 40, 12, 5, 9, 34, 8, 40])
sheet(wb.create_sheet("2_구분별_취합"),
      ["객체구분", "OWNER", "객체명", "STATUS", "GTT", "사용UI수", "사용UI목록", "연결경로합집합"],
      s2, [12, 10, 42, 9, 5, 9, 50, 40])
sheet(wb.create_sheet("3_TABLE_이관SOURCE"),
      ["OWNER", "TABLE명", "GTT", "TOBE존재", "ASIS존재(실측)", "분류", "이관SOURCE",
       "사용UI수", "사용UI목록", "근거"],
      s3, [10, 42, 5, 9, 14, 8, 22, 9, 44, 40])
sheet(wb.create_sheet("4_UI_API_배선"),
      ["UI", "API_ID", "API_TP_CD", "API_URL", "RESOLVE", "ROOT객체"],
      s4, [11, 32, 12, 46, 10, 40])
OUT.parent.mkdir(parents=True, exist_ok=True)
wb.save(OUT)
print(f"saved: {OUT}")
print(f"검증: 시트1 {chk1} == 시트2 합계 {chk2} -> {'PASS' if chk1 == chk2 else 'FAIL'}")
print(f"객체 unique {len(agg)} / TABLE {len(s3)} / UI축 {n_ui}")
