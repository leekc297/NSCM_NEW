# -*- coding: utf-8 -*-
# SCP0037 Operation LT — Material(P_ITEM_ID) : 비교 형태 유지, 컬럼 쪽 UPPER 만 추가 2곳 (plan.csv no 17). 입력 토큰은 이미 UPPER.
#   ① 품목코드 경로 A.ITEM_ID IN (...) = AS-IS 완전 일치 → UPPER(A.ITEM_ID)
#   ② 닉네임 경로 IA.NICK_NAME LIKE 토큰||'%' = AS-IS 앞부분 일치 → 형태(값%) 유지, UPPER(IA.NICK_NAME) (지침 6번)
#   유지: Division / Plant Site / LT Operation / Valid 조건(TEXT 직접 입력 아님 — 계획 대상 밖), O_RC2(조건 없는 전체 조회),
#         P_SCP0037_SAVE_OPERATION_LT(저장). 패키지 안 조회 프로시저는 P_SCP0037_GET_OPERATION_LT 1개.
# LOWER: SCP_MST_OPERATION_LT.ITEM_ID 소문자 0건 / 전체 3,016건 (2026-11-13 10:30:03)
# LOWER: SCM_MST_ITEM_SN.NICK_NAME 소문자 0건 / 전체 796,166건, 그중 Operation LT 품목 행 0건 / 5,426건 (2026-11-13 10:30:03~08)
HUNKS = [
    ("            OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)",
     "            OR  UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */"),
    ("                         WHERE IA.NICK_NAME LIKE UPPER(XC.COLUMN_VALUE) || '%'))",
     "                         WHERE UPPER(IA.NICK_NAME) LIKE UPPER(XC.COLUMN_VALUE) || '%'))   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0037.P_SCP0037_GET_OPERATION_LT'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=[], base={}, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'MPCDELALP42I'),
    ('eq:code:lower', 'mpcdelalp42i'),
    ('eq:nick:upper', 'ROUNDROCK'),
    ('eq:nick:lower', 'roundrock'),
    ('eq:multi:upper', 'MPCDELALP42I,SALADO'),
    ('eq:multi:lower', 'mpcdelalp42i,salado'),
])]
