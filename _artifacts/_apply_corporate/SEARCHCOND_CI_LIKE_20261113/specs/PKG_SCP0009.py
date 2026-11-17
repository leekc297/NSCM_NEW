# -*- coding: utf-8 -*-
# SCP0009 Shipment Plan FG — PJT (plan.csv no 9) : IN 유지, 컬럼·입력 토큰 양쪽 UPPER (4곳)
#   P_SCP0009_GET_SHIPMENT_PLAN_FG         2곳 : SCP_ANL_SHIPMENT_PLAN_FG IA / HIST_SCP_ANL_SHIPMENT_PLAN_FG IA
#   P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL 2곳 : 같은 인자(P_PROJECT_CODE)·같은 식(제목용 병렬 조회) → 지침 2-3 에 따라 함께 포함(plan.csv 에는 '참고'로만 적힌 범위 밖 프로시저)
# 유지: SCP_ANL_SHIPMENT_PLAN_FIX 구간(두 프로시저 각 1줄 — P_PROJECT_CODE 는 NULL/ALL 판정에만 쓰이고 비교 대상은 ITEM_ID = PJT 비교 아님) /
#       P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING·_PROBLEM(FN_SCM_SPLIT(ENG_DEMAND_ID,2,'::') = P_PROJECT_CODE — 행 키 전달 = 드릴다운) /
#       P_FIX_HIST*·저장 프로시저(PROJECT_CODE = B.P_PROJECT_CODE 등 저장 행 키) / '--' 주석 줄 / 'ALL'·빈값 판정
# LOWER: SCP_ANL_SHIPMENT_PLAN_FG.PROJECT_CODE 소문자 35,643,786건 / 전체 208,537,098건 (2026-11-13 10:33:43)
# LOWER: HIST_SCP_ANL_SHIPMENT_PLAN_FG.PROJECT_CODE 소문자 15,084,442건 / 전체 94,401,910건 (2026-11-13 10:34:53)
#   ※ 소문자 포함 코드(예: Division 40 의 'Anjin', 'phisemi')가 실제로 있으므로 수정 후에는 대문자·소문자 입력으로도 이 행들이 조회된다(수정 전에는 원문 표기와 똑같이 넣어야만 조회).
# 대상 줄에 따옴표가 있어 표시 주석이 자동으로 붙지 않으므로 치환식에 줄 끝 표시를 포함(4줄 모두 이 식으로 줄이 끝난다)
RX = [(r"(?<![\w.(])(IA\.PROJECT_CODE)   IN \(SELECT COLUMN_VALUE FROM TABLE\(STRING_SPLIT\(P_PROJECT_CODE, ','\)\)\)\)$",
       r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))   /* 2026.11.13 조회조건 대소문자 무시 */", 4)]
P1 = 'PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG'
P2 = 'PKG_SCP0009.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL'
C = {'P_DIVISION_ID': '40', 'P_BIZ_TYPE': 'A', 'P_PLAN_TYPE': 'MA', 'P_SEQ': '1', 'P_ITEM_ID': 'ALL', 'P_ELECTYPE': 'ALL', 'P_FROMSITE': 'ALL', 'P_TEAM_ID': 'ALL', 'P_TOSITE': 'ALL',
     'P_BUCKET': 'WEEKLY', 'P_CHK_ALL': 'N', 'P_PROGRAM_ID': 'SCP0009', 'P_SHEET_NAME': 'Shipment Plan FG', 'P_USER_ID': 'minyonglee1', 'P_DEBUG_MODE': 'F'}
# 현재 계획 테이블 분기(계획 시작일이 이번 주 기준일 이후) / 이력 테이블 분기(그 이전) — P_TO_PERIOD 는 TITLE_PARAL 에 없는 인자(없는 인자는 시험기가 넘기지 않음)
LIVE = dict(C, P_FROM_YYYYMMDD='20261109', P_TO_YYYYMMDD='20261206', P_PLAN_START_YYYYMMDD='20261109', P_TO_PERIOD='20261206')
HIST = dict(C, P_FROM_YYYYMMDD='20260928', P_TO_YYYYMMDD='20261025', P_PLAN_START_YYYYMMDD='20260928', P_TO_PERIOD='20261025')
# 같은 프로시저·같은 인자를 분기별로 두 번 시험하므로 라벨에 분기(live/hist)를 붙여 구분한다
V_LIVE = [
    ('same:empty-live', None), ('same:ALL-live', 'ALL'),
    ('same:orig-live', 'Anjin'),
    ('eq:code-live:orig', 'Anjin'), ('eq:code-live:upper', 'ANJIN'), ('eq:code-live:lower', 'anjin'),
    ('eq:multi-live:orig', 'Anjin, OP Mobility_01'), ('eq:multi-live:upper', 'ANJIN, OP MOBILITY_01'), ('eq:multi-live:lower', 'anjin, op mobility_01'),
]
V_HIST = [
    ('same:empty-hist', None), ('same:ALL-hist', 'ALL'),
    ('same:orig-hist', 'Greenway'),
    ('eq:code-hist:orig', 'Greenway'), ('eq:code-hist:upper', 'GREENWAY'), ('eq:code-hist:lower', 'greenway'),
    ('eq:multi-hist:orig', 'Greenway, phisemi, NT'), ('eq:multi-hist:upper', 'GREENWAY, PHISEMI, NT'), ('eq:multi-hist:lower', 'greenway, phisemi, nt'),
]
TESTS = [
    dict(proc=P1, vary='P_PROJECT_CODE', key=[], base=LIVE, values=V_LIVE),
    dict(proc=P1, vary='P_PROJECT_CODE', key=[], base=HIST, values=V_HIST),
    dict(proc=P2, vary='P_PROJECT_CODE', key=[], base=LIVE, values=V_LIVE),
    dict(proc=P2, vary='P_PROJECT_CODE', key=[], base=HIST, values=V_HIST),
]
