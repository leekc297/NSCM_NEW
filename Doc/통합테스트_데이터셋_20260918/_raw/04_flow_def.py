# -*- coding: utf-8 -*-
"""
Phase 1 — PROCESS FLOW 정의 (단일 원천).
모든 산출물(MD/XLSX/HTML)이 이 정의에서 생성된다.

배치 SP·인자는 ALL_SCHEDULER_JOBS.JOB_ACTION 실측 인용 (01_meta.json).
"""

# (단계ID, DIV, 순서, 구분, 화면, 권한그룹, 입력MEASURE, 편집요일, 원장, 배치JOB, 수동실행SP, 검증, 결함No)
STEPS = [
    # ── 40 ─────────────────────────────────────────────────────────────
    ("S40-01", "40", 1, "입력", "DMF0082", "DM Planner", "LOC(단가)", "-",
     "DM_PLN_CFM_SELLING_PRICE", "", "",
     "단가 입력 후 DMF0082 재조회. ⚠ 첫 진입 직후 즉시 조회 금지 — authGroup CMBO 도착 전이면 userGroup=userId 로 나가 measureAuth 미표시 응답이 남는다(ForecastPrice.tsx:287~295 재조회)", "1ST-45(LOC 미입력 저장차단)"),
    ("S40-02", "40", 2, "입력", "DMF0082", "DM Planner", "MKT_FCST", "-",
     "DM_PLN_MKT_FCST", "", "",
     "DMF0082 그리드 반영", "1ST-33~49"),
    ("S40-03", "40", 3, "입력", "DMF0082", "SCP Planner", "SCM_FCST", "MON",
     "DM_PLN_MKT_FCST", "", "",
     "SCP Planner 계정으로만 편집 가능 확인", "1ST-36/41"),
    ("S40-04", "40", 4, "배치", "-", "-", "-", "-",
     "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_40",
     "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40','MKT FCST Weekly Cutoff','MF_W','Weekly Rolling','system')",
     "MF_W 신규 버전 생성 확인", ""),
    ("S40-05", "40", 5, "배치", "-", "-", "-", "-",
     "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_SCM_FCST",
     "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40','SCM FCST Weekly Cutoff','SF_W','Weekly Rolling','system')",
     "SF_W 신규 버전 생성 확인", ""),
    ("S40-06", "40", 6, "입력", "DMF0021", "DM Planner", "SalesAmt_LOC", "-",
     "DM_PLN_SALES_PLAN", "", "", "SALES PLAN 저장", "1ST-58~62"),
    ("S40-07", "40", 7, "입력", "DMF0021", "SCP Planner", "RTF_SYS_RP", "-",
     "DM_PLN_SALES_PLAN", "", "", "권한별 편집 메저 분리 확인", "1ST-58~62"),
    ("S40-08", "40", 8, "배치", "-", "-", "-", "-",
     "DM_PLN_SALES_PLAN_C", "JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40",
     "PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE(P_DIVISION_ID=>'40',P_CUTOFF_YYYYMMDD=>NULL,P_CREATION_TYPE=>NULL)",
     "SALES PLAN Cutoff 버전 생성", ""),
    ("S40-09", "40", 9, "입력", "DMF0044", "DM Planner", "관리대상(Report)", "-",
     "-", "", "", "추가 관리대상 반영", "CHAT-20260820-2~13"),
    ("S40-10", "40", 10, "입력", "DMF0049", "DM ADMIN/ADMIN", "관리대상(Etc Report)", "-",
     "-", "", "",
     "⚠ etc-sales-reports.editLock G0: DM Planner 는 82 만 편집 허용 → 40 은 상위권한 필요",
     "CHAT-20260820-14~19"),
    ("S40-11", "40", 11, "입력", "DMF0042", "DM Planner", "BIZ PLAN 관리대상", "-",
     "DM_PLN_BIZPLAN", "", "", "BIZ PLAN 저장", "⚠ 원장 0건(공백)"),
    ("S40-12", "40", 12, "검증", "DMF0035", "-", "MKT FCST / SALES PLAN / BIZ PLAN", "-",
     "-", "", "",
     "3 TYPE 각각에서 S40-02·06·11 입력값 집계 확인", "UM-01~12"),

    # ── 81 ─────────────────────────────────────────────────────────────
    ("S81-01", "81", 1, "선행/배치", "-", "-", "CUST_FCST_EDI", "-",
     "DM_PLN_MKT_FCST", "JOB_PR_DM_DNM_EDI_CALLOFF",
     "PR_DM_PLN_CUST_FCST_RECORD('81','EDI')",
     "EDI 유입분은 MEASURE=CUST_FCST_EDI 로 적재 (원장 DM_MST_CUSTOMER_FCST 경유)", "⚠ 절차 신규정의"),
    ("S81-02", "81", 2, "선행/입력", "DMF0014", "DM Planner", "CUST_FCST", "-",
     "DM_PLN_MKT_FCST", "", "",
     "수기/Excel 유입분은 MEASURE=CUST_FCST — EDI분(CUST_FCST_EDI)과 구분 확인", "2ND-90~92"),
    ("S81-03", "81", 3, "입력", "DMF0082", "DM Planner", "LOC(단가)", "-",
     "SCM_MST_FUTURE_PRICE", "", "",
     "⚠ 81 은 DM_PLN_CFM_SELLING_PRICE 0건 — FUTURE_PRICE 축. ⚠ 첫 진입 직후 즉시 조회 금지(authGroup CMBO race)", "1ST-63~67"),
    ("S81-04", "81", 4, "입력", "DMF0082", "DM Planner", "MKT_FCST", "-",
     "DM_PLN_MKT_FCST", "", "", "DMF0082 그리드 반영", "1ST-63~67"),
    ("S81-05", "81", 5, "입력", "DMF0082", "DM Planner (W/S)", "MKT_FCST", "-",
     "DM_PLN_MKT_FCST", "", "", "W/S 권한 편집 범위 확인. ⚠ 사전확인 필수 — CMBO MktFcstWsPlannerYn 이 0행이면 wsPlannerYn=false 로 조용히 degrade 되어 AS_In_Req·W/S FCST Type·AS FROM SITE 검증이 오류 없이 전부 꺼진다. 계정은 ADMIN 미겸직(jaehyeok/miyeong.lee)만 사용", "1ST-63(W/S 권한)"),
    ("S81-06", "81", 6, "입력", "DMF0082", "SCP Planner", "SCM_FCST", "TUE",
     "DM_PLN_MKT_FCST", "", "",
     "⚠ 81 SCM_FCST 원장 0건 — 신규 입력 시나리오", "1ST-41"),
    ("S81-07", "81", 7, "배치", "-", "-", "-", "-",
     "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_2",
     "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('81','MKT FCST Weekly Cutoff','MF_W','Weekly Rolling','system')",
     "MF_W 신규 버전 생성 확인", ""),
    ("S81-08", "81", 8, "입력", "DMF0021", "DM Planner", "SalesAmt_LOC", "-",
     "DM_PLN_SALES_PLAN", "", "", "SALES PLAN 저장", "1ST-58~62"),
    ("S81-09", "81", 9, "입력", "DMF0021", "SCP Planner", "RTF_SYS_RP", "WED",
     "DM_PLN_SALES_PLAN", "", "", "수요일만 편집 가능 확인", "1ST-58~62"),
    ("S81-10", "81", 10, "배치", "-", "-", "-", "-",
     "DM_PLN_SALES_PLAN_C", "JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81",
     "PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE('81','')",
     "SALES PLAN Cutoff 버전 생성", ""),
    ("S81-11", "81", 11, "검증", "DMF0035", "-", "MKT FCST / SALES PLAN", "-",
     "-", "", "", "2 TYPE 에서 입력값 집계 확인", "UM-01~12"),

    # ── 82 ─────────────────────────────────────────────────────────────
    ("S82-01", "82", 1, "입력", "DMF0020", "DM Planner", "LOC/USD/KRW 단가(52주)", "-",
     "SCM_MST_FUTURE_PRICE", "", "",
     "52주 구간 단가 입력. DMF0020 편집가능 division 은 82 뿐(lookup DM_EDITABLE_DIVISION_ALLOW)", "1ST-23~30"),
    ("S82-02", "82", 2, "입력", "DMF0003", "DM Planner", "MKT_FCST", "-",
     "DM_PLN_MKT_FCST", "", "",
     "⚠ DMF0082 는 82 조회전용(V82-00) — DMF0003 사용", "1ST-50~57"),
    ("S82-03", "82", 3, "입력", "DMF0003", "DM Planner (W/S)", "MKT_FCST", "-",
     "DM_PLN_MKT_FCST", "", "", "W/S 권한 + AS From Site. ⚠ CMBO MktFcstWsPlannerYn / FcstTypeWs 사전확인 필수 — 미등록 시 무증상 degrade", "1ST-57"),
    ("S82-04", "82", 4, "배치", "-", "-", "-", "-",
     "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_82",
     "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('82','MKT FCST Weekly Cutoff','MF_W','Weekly Rolling','system')",
     "MF_W 신규 버전 생성 확인", ""),
    ("S82-05", "82", 5, "입력", "DMF0021", "DM Planner", "SalesAmt_LOC", "-",
     "DM_PLN_SALES_PLAN", "", "",
     "⚠ 82 는 SCP Planner 메저 메타 없음", "1ST-58~62"),
    ("S82-06", "82", 6, "배치", "-", "-", "-", "-",
     "DM_PLN_SALES_PLAN_C", "JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_82",
     "PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE('82','')",
     "SALES PLAN Cutoff 버전 생성", ""),
    ("S82-07", "82", 7, "검증", "DMF0035", "-", "MKT FCST / SALES PLAN", "-",
     "-", "", "", "2 TYPE 에서 입력값 집계 확인", "UM-01~12"),
]

COLS = ["단계ID", "DIV", "순서", "구분", "화면", "권한그룹", "입력MEASURE", "편집요일",
        "대상원장", "배치JOB", "수동실행SP", "검증포인트", "대응결함No"]

# DMF0035 3 TYPE ↔ 조회 SP (procedures.d.ts JSDoc 실측)
WATERFALL = [
    ("MKT FCST", "PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL", "DM_PLN_CFM_MKT_DEMAND_PLAN_C"),
    ("SALES PLAN", "PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", "DM_PLN_SALES_PLAN_C"),
    ("BIZ PLAN", "PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", "DM_PLN_BP_FCST_C"),
]

# ── 화면 ID ↔ 화면명 ────────────────────────────────────────────────────────
# 권위 원천: SCM_ADM_MNU_M.MNU_MSG_ID → SCM_ADM_MSG_M.MSG_NM(KO), 미등록 시 MNU_DESC.
# 실측·생성 = _raw/09_program_names.py  (임의 명명 금지)
import json as _json
import pathlib as _pathlib

PROGRAM_NAMES = _json.loads(
    (_pathlib.Path(__file__).resolve().parent / "09_program_names.json")
    .read_text(encoding="utf-8"))["names"]


def scr_name(scr):
    """'DMF0003' -> 'MKT FCST'. 화면 없음('-')은 그대로 '-'."""
    return "-" if scr == "-" else PROGRAM_NAMES.get(scr, "")


def scr_label(scr):
    """'DMF0003' -> 'DMF0003(MKT FCST)' — 도식 라벨용."""
    nm = PROGRAM_NAMES.get(scr)
    return "{}({})".format(scr, nm) if nm else scr


# '화면' 바로 뒤에 '화면명' 을 끼운 확장 뷰 (MD / XLSX / HTML 공용)
COLS_X = COLS[:5] + ["화면명"] + COLS[5:]


def steps_x():
    for s in STEPS:
        yield list(s[:5]) + [scr_name(s[4])] + list(s[5:])


# DMF0035 3 TYPE 의 메타 소속 PROGRAM_ID (SALES/BIZ 는 종속 PROGRAM 으로 스위칭된다)
WATERFALL_PROGRAM = {"MKT FCST": "DMF0035", "SALES PLAN": "DMF0022", "BIZ PLAN": "DMF0051"}


def scr_label_plain(scr):
    """'DMF0003' -> 'DMF0003 · MKT FCST' — mindmap 용.
    mindmap 은 () 를 노드 shape 문법으로 해석하므로 괄호 표기를 쓸 수 없다."""
    nm = PROGRAM_NAMES.get(scr)
    return "{} · {}".format(scr, nm) if nm else scr
