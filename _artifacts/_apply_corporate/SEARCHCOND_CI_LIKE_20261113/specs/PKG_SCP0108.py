# -*- coding: utf-8 -*-
# SCP0108 LOB Report — Basic Nickname(P_NICK_NAME) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER 4곳 (plan.csv no 40, 41)
#   수정 = P_SCP0108_GET_CAPA_LOB_CURRENT 2곳(SCP_MST_CAPA_LINE_ASSIGN A.NICK_NAME / SCP_MST_CAPA_LOSS_PLAN_MDL A.MDL_NM)
#        + P_SCP0108_GET_CAPA_LOB 2곳(SCP_RPT_CAPA_LOB A.MDL_NM / SCP_MST_CAPA_LINE_ASSIGN_CUTF A.NICK_NAME).
#   유지: IF TRIM(V_NICK_NAME) IS NOT NULL (값 유무 분기 — 비교 아님). 다른 인자(DIVISION/SITE/…)의 IN (SELECT COLUMN_VALUE …)는 TEXT 조회조건이 아니라 범위 밖.
#         P_SCP0108_SET_CODE · P_SCP0108_GET_SPREAD_TITLE 에는 닉네임 비교 없음.
#   표시 주석: 수정 줄에 따옴표(',')가 있어 자동 표시가 붙지 않으므로 치환식 끝에 직접 붙인다(정적 SQL · 줄 끝).
# LOWER: SCP_MST_CAPA_LINE_ASSIGN.NICK_NAME 소문자 0건 / 전체 52,925건 (2026-11-13 10:32:28)
# LOWER: SCP_MST_CAPA_LOSS_PLAN_MDL.MDL_NM 소문자 0건 / 전체 508,798건 (2026-11-13 10:32:29)
# LOWER: SCP_RPT_CAPA_LOB.MDL_NM 소문자 0건 / 전체 617,763건 (2026-11-13 10:32:29)
# LOWER: SCP_MST_CAPA_LINE_ASSIGN_CUTF.NICK_NAME 소문자 0건 / 전체 1,601,718건 (2026-11-13 10:32:29)
RX = [(r"(?<![\w.(])(A\.(?:NICK_NAME|MDL_NM))(\s+)IN \(SELECT COLUMN_VALUE FROM TABLE\(STRING_SPLIT\(V_NICK_NAME, ','\)\)(.*?)\s*$",
       r"UPPER(\1)\2IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))\3   /* 2026.11.13 조회조건 대소문자 무시 */", 4)]
B = {'P_VERSION_SEQ': '1', 'P_DIVISION_ID': '82', 'P_SITE_ID': 'ALL', 'P_PLANT_ID': 'ALL', 'P_FACTORY_ID': 'ALL', 'P_LINE_ID': 'ALL',
     'P_OPERATION_ID': 'ALL', 'P_ELECTRODE_TYPE': 'ALL', 'P_BOTTLENECK_FLAG': 'ALL', 'P_PROGRAM_ID': 'SCP0108',
     'P_USER_ID': 'minyonglee1', 'P_DEBUG_MODE': 'N'}
V = [
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'JF1'),
    ('eq:code:lower', 'jf1'),
    ('eq:multi:upper', 'JF1,JP5'),
    ('eq:multi:lower', 'jf1,jp5'),
    ('same:part', 'JF'),
]
TESTS = [
    dict(proc='PKG_SCP0108.P_SCP0108_GET_CAPA_LOB_CURRENT', vary='P_NICK_NAME', key=[], base=dict(B, P_VERSION='202610', P_SHEET_NAME='CURRENT'), values=V),
    dict(proc='PKG_SCP0108.P_SCP0108_GET_CAPA_LOB', vary='P_NICK_NAME', key=[], base=dict(B, P_VERSION='202609', P_SHEET_NAME='CUTOFF'), values=V),
]
