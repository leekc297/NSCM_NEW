# -*- coding: utf-8 -*-
# SCP0127 Precede/Safety Stock Day — Model/Nickname(P_ITEM_ID) : LIKE %값% 는 이미 AS-IS 와 같음 → 형태 유지, A.ITEM_ID 컬럼 쪽 UPPER 추가 1곳 (plan.csv no 43)
#   입력은 이미 UPPER(SA.COLUMN_VALUE). 수정 = P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY 의 A.ITEM_ID LIKE 1곳.
#   유지: 같은 EXISTS 안의 닉네임 식(UPPER(SB.NICK_NAME) LIKE …) — 이미 양쪽 UPPER. '--' 주석 줄(옛 IA.TST 조인). P_SCP0127_SAVE_*(저장)·GET_SEARCH_INFO(품목 비교 없음).
# LOWER: SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY.ITEM_ID 소문자 0건 / 전체 2,105건 (2026-11-13 10:32:29)
HUNKS = [
    ("WHERE A.ITEM_ID LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'",
     "WHERE UPPER(A.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=['PRE_KEY_VALUES'], base={'P_PERIOD_FROM': '20000101', 'P_PERIOD_TO': '99991231'}, values=[
    ('same:empty', None),
    ('same:ALLtext', 'ALL'),
    ('eq:code:upper', 'AAEF1090I-A1-700'),
    ('eq:code:lower', 'aaef1090i-a1-700'),
    ('eq:part:upper', 'AAEF1090'),
    ('eq:part:lower', 'aaef1090'),
    ('eq:nick:upper', 'E90B-700'),
    ('eq:nick:lower', 'e90b-700'),
    ('eq:multi:upper', 'AAEF1090I-A1-700, AAEH1072I-A1-400'),
    ('eq:multi:lower', 'aaef1090i-a1-700, aaeh1072i-a1-400'),
])]
