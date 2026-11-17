# -*- coding: utf-8 -*-
# SCP0128 Precede/Safety Stock Qty — Model/Nickname(P_ITEM_ID) : LIKE %값% 는 이미 AS-IS 와 같음 → 형태 유지, A.ITEM_ID 컬럼 쪽 UPPER 추가 1곳 (plan.csv no 44)
#   입력은 이미 UPPER(SA.COLUMN_VALUE). 수정 = P_SCP0128_GET_SAFETY_STOCK 의 A.ITEM_ID LIKE 1곳.
#   유지: 같은 EXISTS 안의 닉네임 식(이미 양쪽 UPPER). '--' 주석 줄(옛 IA.TST 조인). P_SCP0128_SAVE_*(저장)·GET_SEARCH_INFO(품목 비교 없음).
# LOWER: SCP_OPMZ_SAFETY_STOCK.ITEM_ID 소문자 0건 / 전체 251건 (2026-11-13 10:32:29)
HUNKS = [
    ("WHERE A.ITEM_ID LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'",
     "WHERE UPPER(A.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=['PRE_KEY_VALUES'], base={'P_PERIOD_FROM': '20000101', 'P_PERIOD_TO': '99991231'}, values=[
    ('same:empty', None),
    ('same:ALLtext', 'ALL'),
    ('eq:code:upper', 'AAEF1090I-A1-700'),
    ('eq:code:lower', 'aaef1090i-a1-700'),
    ('eq:part:upper', 'AAEF1090'),
    ('eq:part:lower', 'aaef1090'),
    ('eq:nick:upper', 'L10D-003'),
    ('eq:nick:lower', 'l10d-003'),
    ('eq:multi:upper', 'AAEF1090I-A1-700, ACLT1010U-A1-003'),
    ('eq:multi:lower', 'aaef1090i-a1-700, aclt1010u-a1-003'),
])]
