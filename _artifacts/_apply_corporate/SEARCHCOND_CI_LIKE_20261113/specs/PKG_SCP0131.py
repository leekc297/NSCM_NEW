# -*- coding: utf-8 -*-
# SCP0131 Sales Site Priority — Model/Nickname(P_ITEM_ID) : LIKE %값% 는 이미 AS-IS 와 같음 → 형태 유지, A.ITEM_ID 컬럼 쪽 UPPER 추가 1곳 (plan.csv no 47)
#   입력은 이미 UPPER(COLUMN_VALUE)(인라인뷰 IA.TST). 수정 = P_SCP0131_GET_SALES_SITE_PRIORITY 의 A.ITEM_ID LIKE IA.TST 1곳.
#   유지: P_SCP0131_SAVE_SALES_SITE_PRIORITY(저장·검증)의 ITEM_ID 비교.
# LOWER: SCP_OPMZ_SALES_SITE_PRIORITY.ITEM_ID 소문자 0건 / 전체 212건 (2026-11-13 10:32:29)
HUNKS = [
    ("OR  A.ITEM_ID LIKE IA.TST)",
     "OR  UPPER(A.ITEM_ID) LIKE IA.TST)   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=['PRE_KEY_VALUES'], base={'P_PERIOD_FROM': '20000101', 'P_PERIOD_TO': '99991231'}, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'ACEH1081I-B1-100'),
    ('eq:code:lower', 'aceh1081i-b1-100'),
    ('eq:part:upper', 'ACEH1081'),
    ('eq:part:lower', 'aceh1081'),
    ('eq:multi:upper', 'ACEH1081I-B1-100, ACEH1062I-A1-010'),
    ('eq:multi:lower', 'aceh1081i-b1-100, aceh1062i-a1-010'),
])]
