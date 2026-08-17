#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 대사표 잔여 18행 확정 — 축별 실측 근거 기입.

사용자 확정 (2026-08-15)
  · SSP Sync      → 구현 대상 제외
  · 공용 모달      → 이번 대사 대상 제외 (ColumnLayoutModal / FPModal / VersionCutOff)

나머지는 **실측 원천**으로 판정한다 (추정 금지 — hook #126 정직성).
  · division 스코프 정적컬럼 → DB `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 실측
  · 저장 SP 파라미터          → DB `ALL_ARGUMENTS` 실측
  · SP 내부 자동행 생성       → DB `ALL_SOURCE` 라인 실측
  · FE 게이팅                 → FE 파일:라인 실측
  · 원천 md 표 헤더 행        → 요구사항 아님(해당없음)
"""
import io, sys, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
MAP = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst\__asis-mapping__.md")

X_SSP = "범위 제외 — SSP Sync 는 구현 대상에서 제외(사용자 확정 2026-08-15). 표시/색상 축(E08·CI-01)은 이미 구현되어 별도 유지"
X_MOD = "범위 제외 — 공용 모달은 이번 대사 대상에서 제외(사용자 확정 2026-08-15). 공용 정본 = master `columnLayoutModal`/`measureSelectModal`(hook #132)"
X_VCO = ("범위 제외 — Version Cut-Off 는 11화면 공용 모달이고, AS-IS `DMF0003_MktFcst.cs` L5593·L5605~5606 이 "
         "전 줄 주석(LEGACY/DISABLED). 공용 모달 제외(사용자 확정 2026-08-15)")

FIX = {
    # ── 사용자 확정 제외 ─────────────────────────────────────────────
    "CH-104":                  ("제외 — SSP Sync",       X_SSP, "제외"),
    "MODAL:ColumnLayoutModal": ("제외 — 공용 모달",       X_MOD, "제외"),
    "MODAL:FPModal":           ("제외 — 공용 모달",       X_MOD, "제외"),
    "CA-115":                  ("제외 — 공용 모달",       X_VCO, "제외"),
    "CH-106":                  ("제외 — 공용 모달",       X_VCO, "제외"),

    # ── 원천 md 표 헤더 행 (요구사항 아님) ───────────────────────────
    "CC-101": ("해당없음 — 표 헤더",
               "원천 `DMF0003_MktFcst_상세분석서_v2.0.md` L69 = 표 헤더 행(`컨트롤|담긴 LAYER|자식 상태|LAYER 은폐 방식|실효 표시|근거`). "
               "`--init` 자동채번 산물이며 요구사항 행이 아님", "해당없음"),
    "CG-114": ("해당없음 — 표 헤더",
               "원천 `상세분석서_v2.0.md` L228 = §7.3 표 헤더 행(`상위(선택)|조건|하위(종속)|유형|SP`). 요구사항 행이 아님", "해당없음"),

    # ── AS-IS 비활성 ────────────────────────────────────────────────
    "CG-121": ("해당없음 — AS-IS 비활성",
               "원천 `상세분석서_v2.0.md` L236 `CUST_FCST_ORG | (비활성, E20241126 합의) | Customer Fcst[Org.] | 비활성 | L954~980`. "
               "AS-IS 합의로 비활성 확정 — 이식 대상 아님", "해당없음"),

    # ── 실측 구현 ───────────────────────────────────────────────────
    "C-05":   ("components/MktFcstForm.tsx:223~229 (`BizTypeField` comboId=`BizTypebyDivision`, `sc.bizTypes` 다중선택)",
               "", "구현"),
    "CG-101": ("DB `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=DMF0003·SHEET_NAME='Mkt Fcst') — `END_CUSTOMER40`/`SCM_SITE_ID40`/`ITEM_ID40` "
               "3행 모두 DIVISION_ID='40' VISIBLE_FLAG='Y' 실측(2026-08-15)",
               "", "구현"),
    "CG-106": ("components/MktFcstForm.tsx:231~236 (Sender Code — 81 계열 전용 enable, AS-IS `clbEDISender` Division==81 파리티) "
               "+ DB SHEET_COLUMNS `SENDER_NAME` DIVISION_ID='40,81,81_UC…'(82 제외)",
               "", "구현"),
    "CG-110": ("DB `SCM_MST_SHEET_COLUMNS` — `CELL_PER_CAR`/`CELL_PER_MODULE`/`MODULE_PER_CAR` 3행 모두 "
               "DIVISION_ID='81,81_UC,81_HM,81_ST,81_HD,81_HG' 실측(40·82 미노출)",
               "", "구현"),
    "CE-108": ("DB `SCM_MST_SHEET_COLUMNS` — `CELL_PER_CAR`/`CELL_PER_MODULE`/`MODULE_PER_CAR` DIVISION_ID=81 계열 전용 실측 "
               "(CG-110 과 동일 실체 — §5.1 정적컬럼 축)",
               "", "구현"),
    "CE-109": ("DB `SCM_MST_SHEET_COLUMNS` — `PROJECT_CODE`/`PROJECT_NAME` DIVISION_ID='82,81,81_UC…'(40 미포함) "
               "+ components/MktFcstForm.tsx:149 (Project = 40 비활성, division 변경 시 clear)",
               "", "구현"),
    "CG-113": ("utils/mkt-fcst.editLock.ts:186~ (Division 40 — 8주차 `O_RC2.BASIS_YYYYMM` 이전 월 추가 잠금, AS-IS L974~981) "
               "+ :58 div40MonthCutoff",
               "", "구현"),
    "CG-118": ("DB `PKG_DMF0003`(PACKAGE BODY) L8835~8875 — 'LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집' 자동행 생성 "
               "+ L11365/L11414 `V_DIVISION_ID='82' AND V_MEASURE='BNPIn'` 판가 존재 검사 실측",
               "", "구현"),
    "CG-119": ("components/MktFcstGrid.tsx:1321~1323 (Sales site=비축향(AS) → W/S Planner 행 Measure `AS_In_Req` 셋팅·후보 1종) "
               "+ DB SHEET_COLUMNS `AS_YN` 전 division",
               "", "구현"),
    "CI-10":  ("DB `PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST` **P_AUTHORITY 16번째 인자** 실측(ALL_ARGUMENTS POSITION=16) "
               "+ MktFcst.tsx:596~605 (authority 산출) + utils/mkt-fcst.save.ts:51~52,159 (payload 단일값)",
               "", "구현"),
}

lines = MAP.read_text(encoding="utf-8").split("\n")
done = []
for i, l in enumerate(lines):
    if not l.startswith("| "):
        continue
    c = l.split("|")
    if len(c) < 6:
        continue
    rid = c[1].strip()
    if rid not in FIX or rid in done:
        continue
    loc, why, st = FIX[rid]
    c[3], c[4], c[5] = f" {loc} ", f" {why} ", f" {st} "
    lines[i] = "|".join(c)
    done.append(rid)

MAP.write_text("\n".join(lines), encoding="utf-8")
print(f"[대사표] {len(done)}/{len(FIX)}행 확정")
for r in done:
    print(f"   {r:<26}→ {FIX[r][2]}")
miss = [k for k in FIX if k not in done]
if miss:
    print(f"⛔ 미반영: {miss}")
