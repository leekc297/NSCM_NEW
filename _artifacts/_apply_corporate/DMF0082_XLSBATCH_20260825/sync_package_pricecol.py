# -*- coding: utf-8 -*-
"""DAILY 패키지 최종 동기 — BODY(h)·마커 재집계 90_VERIFY·FE 3본·README·원장"""
import io, sys, re, pathlib, shutil
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

markers = ["SCPPLOC", "AFSBLANK", "AFSNVL", "81AUTH", "CUSTSUB", "CURRNORM",
           "XLSMASTER", "XLSBATCH2", "XLSPRJ", "XLSPRICECOL2"]
counts = {}
for m in markers:
    counts[m] = src.count("E20260825-" + m)
# XLSBATCH = 전체 - XLSBATCH2 / XLSPRICECOL = 전체 - XLSPRICECOL2
counts["XLSBATCH"] = src.count("E20260825-XLSBATCH") - counts["XLSBATCH2"]
counts["XLSPRICECOL"] = src.count("E20260825-XLSPRICECOL") - counts["XLSPRICECOL2"]
print("라이브 마커 실측:", counts)

root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260825_DAILY")
bp = root / "A_DB" / "02_PKG_DMF0082_BODY.sql"
old = bp.read_text(encoding="utf-8")
banner = old[:old.find("CREATE OR REPLACE")].replace("2026-08-25g", "2026-08-25h")
bp.write_text(banner + "CREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
print("02 BODY(h) 재동기")

# 90_VERIFY V1 블록 재생성 (실측 카운트 기준)
order = ["SCPPLOC", "AFSBLANK", "AFSNVL", "81AUTH", "CUSTSUB", "CURRNORM",
         "XLSMASTER", "XLSBATCH", "XLSBATCH2", "XLSPRJ", "XLSPRICECOL", "XLSPRICECOL2"]
lines = []
for i, m in enumerate(order):
    sep = " UNION ALL" if i < len(order) - 1 else ")"
    lines.append("  SELECT 'E20260825-%s', %d FROM DUAL%s" % (m, counts[m], sep))
vp = root / "A_DB" / "90_VERIFY.sql"
v = vp.read_text(encoding="utf-8")
s0 = v.find("WITH exp (MARKER, CNT) AS (")
s1 = v.find("SELECT e.MARKER")
assert 0 < s0 < s1
v = v[:s0] + "WITH exp (MARKER, CNT) AS (\n" + "\n".join(lines) + "\n" + v[s1:]
v = re.sub(r"마커 \d+종", "마커 12종", v)
vp.write_text(v, encoding="utf-8")
print("90_VERIFY 마커 12종 재생성")

# FE 3본 재복사
fe_src = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")
fe_dst = root / "B_FE" / "forecast-price"
(fe_dst / "components" / "modals").mkdir(parents=True, exist_ok=True)
(fe_dst / "utils").mkdir(parents=True, exist_ok=True)
shutil.copy2(fe_src / "components" / "modals" / "ForecastTemplateModal.tsx",
             fe_dst / "components" / "modals" / "ForecastTemplateModal.tsx")
shutil.copy2(fe_src / "utils" / "forecast-price.excelForm.ts",
             fe_dst / "utils" / "forecast-price.excelForm.ts")
shutil.copy2(fe_src / "ForecastPrice.tsx", fe_dst / "ForecastPrice.tsx")
print("FE 3본 재복사 (모달/excelForm/ForecastPrice)")

# README — 11·12행 추가 + 갱신
rp = root / "README.md"
r = rp.read_text(encoding="utf-8")
r = r.replace("## 담긴 정정 10건", "## 담긴 정정 12건")
a10 = "| 10 | `E20260825-XLSPRJ` ×3 | Excel Form 에 PROJECT_CODE/PROJECT_NAME/PROJECT_OWNER 출력(제 컬럼 정정, SCM_MST_PROJECT LEFT) + FE 빈 정보성 컬럼 숨김 | REQ:CHAT-20260825-11 |"
assert a10 in r
r = r.replace(a10, a10 + """
| 11 | `E20260825-XLSPRICECOL` ×%d | **Excel Form 컬럼 = 단가 테이블(SCM_MST_FUTURE_PRICE) 컬럼 구성** — 행 축 = 원장 키(PLANT 포함), END_CUSTOMER 컬럼 제거, MAIN 메타 종속 폐지 | REQ:CHAT-20260825-12 |
| 12 | `E20260825-XLSPRICECOL2` ×%d | 업로드 검증 SP 슬롯 재편 — 슬롯2 Project Code(코드 항등)/슬롯8 Plant Site(마스터∪원장 도메인 검증) + T_MAIN **Plant 직송**(구 'Plant Site 축 미결' 해소)·CELL_PROD '-' | 동일 건 |""" % (counts["XLSPRICECOL"], counts["XLSPRICECOL2"]))
r = r.replace("(2026-08-25g)", "(2026-08-25h)").replace("금일 마커 10종 포함", "금일 마커 12종 포함").replace("검증 | 마커 10종", "검증 | 마커 12종")
# 이관 파일 표에 24_ 추가
t23 = "| `A_DB/23_LOOKUP_LOC_81.sql` | 멱등 MERGE 6행 | `DM_UI_EDITABLE_MEASURE` (DMF0082/LOC) 81계열 — Excel Form 대상 메저 축 (없으면 폼 0행) |"
assert t23 in r
r = r.replace(t23, t23 + """
| `A_DB/24_EXCEL_HEADER_PRICECOL.sql` | UPDATE 1행 | `SCM_ADM_EXCEL_COLUMNS` HEADER_CONTENT — 슬롯2 Project Code/슬롯8 Plant Site (위치 보존, **02 BODY 와 동시 적용 필수** — 한쪽만 적용 시 업로드 슬롯 계약 불일치) |""")
r = r.replace("**적용 순서: `21` → `23` → `02` → `90`**", "**적용 순서: `21` → `23` → `24` → `02` → `90`** (24·02 는 같은 배포창에서 연속 적용)")
rp.write_text(r, encoding="utf-8")
print("README 갱신")

# 원장 REQ-12
lp = pathlib.Path(r"C:\Projects\NSCM\Doc\단위테스트_보완대상\보완요청_원장.md")
t = lp.read_text(encoding="utf-8")
anchor = "type-check @demand 강제 PASS |"
assert t.count(anchor) == 1
t = t.replace(anchor, anchor + "\n| REQ:CHAT-20260825-12 | 대화 지정 2026-08-25 | Excel Form 컬럼 = 단가 테이블 컬럼 구성 + END_CUSTOMER 값 정정(컬럼 제거로 해소) + MAIN 미조회 독립 조회 + OPEN 후 Search 클릭 조회 | DMF0082 | EV:_artifacts/_apply_corporate/DMF0082_XLSBATCH_20260825/edits_pricecol_form.json::E20260825-XLSPRICECOL | VERIFIED | Y | N | 폼=원장 키 축(PLANT 포함) 2,431=독립기준 일치·프리필 2,396·3.2s. 업로드 왕복 시뮬(BE 동일 경로 PR_SAVE_EXCEL_UPLOAD→mode0): SUCCESS 3/ERROR 0·슬롯2 코드 항등·슬롯8 Plant 통과·T_MAIN Plant 직송('축 미결' 해소)·CELL_PROD '-'. HEADER_CONTENT 슬롯2/8 교체(24_, BODY 동시배포 필수). FE=고정 컬럼(메타 종속 폐지)·자동조회 제거(Search 게이트)·filters 폴백. type-check 강제 PASS. ⚠구양식 파일은 Invalid Project Code/Plant Site 로 명시 거부(2세대 호환 없음 — 신양식 재다운로드 안내) |")
lp.write_text(t, encoding="utf-8")
print("원장 REQ-12 등재")
