# -*- coding: utf-8 -*-
# SCP0130 Scheduled Receipt Information — Item(P_ITEM_ID, Virtual Bom 탭) : AS-IS·TO-BE 모두 LIKE %값% 조인 AND IN 완전 일치(실효 완전 일치) → 형태 유지,
#   A.ITEM_ID 컬럼 쪽 UPPER 추가 2곳 (plan.csv no 46). 입력은 이미 UPPER(COLUMN_VALUE).
#   수정 = P_SCP0130_GET_VIRTUAL_BOM 의 A.ITEM_ID LIKE IA.TST 1곳 + A.ITEM_ID IN (…) 1곳.
#   유지: A.ITEM_ID_CHILD 비교(GET_VIRTUAL_BOM · GET_SCHEDULED_RECIEPT_INFORMATION) — 다른 인자(P_ITEM_ID_CHILD)·plan.csv 담당 조건 아님.
#         P_SCP0130_SAVE_* / SVAE_VIRTUAL_BOM(저장)·GET_SEARCH_INFO.
# LOWER: SCP_OPMZ_VIRTUAL_BOM.ITEM_ID 소문자 0건 / 전체 13건 (2026-11-13 10:32:29)
HUNKS = [
    ("OR A.ITEM_ID LIKE IA.TST)",
     "OR UPPER(A.ITEM_ID) LIKE IA.TST)   /* 2026.11.13 조회조건 대소문자 무시 */"),
    ("OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)",
     "OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=['PRE_KEY_VALUES'], base={'P_FROM_DATE': '20000101'}, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'AAEN4101I-A1-170'),
    ('eq:code:lower', 'aaen4101i-a1-170'),
    ('eq:multi:upper', 'AAEN4101I-A1-170, EAE0630N1-02'),
    ('eq:multi:lower', 'aaen4101i-a1-170, eae0630n1-02'),
    ('same:part', 'AAEN4101I'),
])]
