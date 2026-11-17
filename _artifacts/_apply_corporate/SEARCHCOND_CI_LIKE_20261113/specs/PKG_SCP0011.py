# -*- coding: utf-8 -*-
# SCP0011 Production Plan (Model) — Material(no 10) / Model·Nickname(no 11) : 비교 형태 유지, 컬럼 쪽 UPPER 추가 (8곳)
#   no 10 Material  P_ITEM_ID  → A.ITEM_ID IN (… V_ITEM_TAB) : P_SCP0011_GET_PROD_PLAN_MODEL 3곳(SCP_ANL_PRODUCTION_PLAN / HIST_SCP_ANL_PRODUCTION_PLAN / SCM_DNM_PRODUCT_RESULT_V)
#                                                              + P_SCP0011_GET_PROD_MODEL_TITLE 3곳(같은 인자·같은 식 — 제목용. 지침 2-3 에 따라 함께 포함. plan.csv 비고의 '판단 필요' 항목)
#   no 11 Nickname  P_NICK_NAME → SCM_MST_ITEM_SN A.NICK_NAME LIKE '%'||토큰||'%' : GET_PROD_PLAN_MODEL 1곳 + GET_PROD_MODEL_TITLE 1곳. LIKE 는 이미 %값%.
#   입력 토큰은 이미 UPPER(P_SPLIT_LIST(…, 'Y', …)) → 입력 쪽 변경 없음. 'ALL'·빈값 판정 그대로.
# 유지: P_SCP0011_GET_PROD_PLAN_LINE 의 SB.ITEM_ID IN (… V_ITEM_TAB) 2곳(행 더블클릭 ITEM_ID = 드릴다운) / 같은 꼴의 Site·Electrode Type 조건(콤보) /
#       INSTR(UPPER(V_NK_ITEM(I)), V_NK_TOKEN)·INSTR(V_NK_MODEL, V_NK_TOKEN)(이미 양쪽 UPPER) / GT_0011_NICKITEM 조인(값 비교 아님) / '--' 주석 줄
# LOWER: SCP_ANL_PRODUCTION_PLAN.ITEM_ID 소문자 0건 / 전체 159,731,587건 (2026-11-13 10:38:14)
# LOWER: HIST_SCP_ANL_PRODUCTION_PLAN.ITEM_ID 소문자 0건 / 전체 69,752,072건 (2026-11-13 10:40:05)
# LOWER: SCM_DNM_PRODUCT_RESULT_V.ITEM_ID 소문자 0건 / 전체 1,586,201건 (2026-11-13 10:40:37)
# LOWER: SCM_MST_ITEM_SN.NICK_NAME 소문자 0건 / 전체 796,166건 (2026-11-13 10:40:44)
# 대상 줄에 따옴표가 있어 표시 주석이 자동으로 붙지 않으므로 치환식에 줄 끝 표시를 포함(8줄 모두 이 식으로 줄이 끝난다)
RX = [
    (r"(?<![\w.(])(A\.ITEM_ID)        IN \(SELECT COLUMN_VALUE FROM TABLE\(V_ITEM_TAB\)\)\)$",
     r"UPPER(\1) IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* 2026.11.13 조회조건 대소문자 무시 */", 6),
    (r"(?<![\w.(])(A\.NICK_NAME) LIKE '%' \|\| TRIM\(B\.COLUMN_VALUE\) \|\| '%'$",
     r"UPPER(\1) LIKE '%' || TRIM(B.COLUMN_VALUE) || '%'   /* 2026.11.13 조회조건 대소문자 무시 */", 2),
]
P1 = 'PKG_SCP0011.P_SCP0011_GET_PROD_PLAN_MODEL'
P2 = 'PKG_SCP0011.P_SCP0011_GET_PROD_MODEL_TITLE'
C = {'P_DIVISION_ID': '81', 'P_OPERATION_GROUP': 'P', 'P_SCM_SITE_ID': 'ALL', 'P_MODEL_ID': 'ALL', 'P_PLAN_TYPE': 'MA', 'P_SEQ': '1',
     'P_PROGRAM_ID': 'SCP0011', 'P_SHEET_NAME': 'MODEL', 'P_USER_ID': 'minyonglee1', 'P_ELECTRODE_TYPE': 'ALL', 'P_BUCKET': 'WEEKLY', 'P_CHK_ALL': 'N', 'P_DEBUG_MODE': 'F'}
# 이력 테이블 분기(계획 시작일 < 지난주 기준일) — 데이터가 있는 분기. P_TO_PERIOD 는 TITLE 에 없는 인자(없는 인자는 시험기가 넘기지 않음)
HIST = dict(C, P_FROM_YYYYMMDD='20260928', P_TO_YYYYMMDD='20261025', P_PLAN_START_YYYYMMDD='20260928', P_TO_PERIOD='20261025')
# 현재 계획 테이블 분기(계획 시작일 >= 지난주 기준일 20261102) — 2026-11-13 현재 SCP_ANL_PRODUCTION_PLAN 에 계획 시작일 2026-11-02 이후 행이 0건이라 결과 0행(실행 오류 여부만 확인)
LIVE = dict(C, P_FROM_YYYYMMDD='20261012', P_TO_YYYYMMDD='20261206', P_PLAN_START_YYYYMMDD='20261109', P_TO_PERIOD='20261206')
V_ITEM = [
    ('same:empty', None), ('same:ALL', 'ALL'),
    ('eq:code:upper', 'AMDMLEB56-A1'), ('eq:code:lower', 'amdmleb56-a1'),
    ('eq:multi:upper', 'AMDMLEB56-A1, AMFMCHEVC-A1'), ('eq:multi:lower', 'amdmleb56-a1, amfmchevc-a1'),
]
V_ITEM_LIVE = [('same:empty-live', None), ('eq:code-live:upper', 'AMDMLEB56-A1'), ('eq:code-live:lower', 'amdmleb56-a1')]
# 닉네임에만 있는 문자열(MBAG-EB56 — 품목코드·Model 에는 없음)이라 SCM_MST_ITEM_SN.NICK_NAME LIKE 구간까지 내려간다
V_NICK = [
    ('same:empty', None), ('same:ALL', 'ALL'),
    ('eq:nick:upper', 'MBAG-EB56'), ('eq:nick:lower', 'mbag-eb56'),
    ('eq:multi:upper', 'MBAG-EB56, AMFMCHEVC'), ('eq:multi:lower', 'mbag-eb56, amfmchevc'),
]
TESTS = [
    dict(proc=P1, vary='P_ITEM_ID', key=[], base=dict(HIST, P_NICK_NAME=None), values=V_ITEM),
    dict(proc=P1, vary='P_ITEM_ID', key=[], base=dict(LIVE, P_NICK_NAME=None), values=V_ITEM_LIVE),
    dict(proc=P1, vary='P_NICK_NAME', key=[], base=dict(HIST, P_ITEM_ID='ALL'), values=V_NICK),
    dict(proc=P2, vary='P_ITEM_ID', key=[], base=dict(HIST, P_NICK_NAME=None), values=V_ITEM),
    dict(proc=P2, vary='P_ITEM_ID', key=[], base=dict(LIVE, P_NICK_NAME=None), values=V_ITEM_LIVE),
    dict(proc=P2, vary='P_NICK_NAME', key=[], base=dict(HIST, P_ITEM_ID='ALL'), values=V_NICK),
]
