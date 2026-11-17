# -*- coding: utf-8 -*-
# SCP0041 Stock OSP (Pack Hold Stock) — Inspection(P_INSPECTION_ID) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼 쪽 UPPER 만 추가 1곳 (plan.csv no 29). 입력은 이미 UPPER.
#   유지: 쉼표 분해(REGEXP_SUBSTR — 토큰 TRIM 없음)·'ALL'·빈값 처리 그대로. Division/Plant Site/Material/Status 조건(계획 대상 밖).
#         P_SCP0041_SAVE_PACKER_HOLD_STOCK 의 INSPECTION_ID = V_INSPECTION_ID (저장 — 대상 아님). 다른 조회 프로시저(P_SCP0041_GET_STOCK_OSP)에는 이 인자 없음.
# LOWER: SCM_DNM_STOCK_LOT_CONTROL.INSPECTION_ID 소문자 0건 / 전체 2,073건 (2026-11-13 10:30:03)
HUNKS = [
    ("                 OR A.INSPECTION_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_INSPECTION_ID), '[^,]+', 1, LEVEL)",
     "                 /* 2026.11.13 조회조건 대소문자 무시 */\n"
     "                 OR UPPER(A.INSPECTION_ID) IN (SELECT REGEXP_SUBSTR(UPPER(P_INSPECTION_ID), '[^,]+', 1, LEVEL)"),
]
P = 'PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK'
B = {'P_DIVISION_ID': '82', 'P_FROM_YYYYMMDD': '20230101', 'P_TO_YYYYMMDD': '20251231',
     'P_CUTOFF_FROM_YYYYMMDD': '20230101', 'P_CUTOFF_TO_YYYYMMDD': '20251231'}
TESTS = [dict(proc=P, vary='P_INSPECTION_ID', key=[], base=B, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'EC-2024-G0385'),
    ('eq:code:lower', 'ec-2024-g0385'),
    ('eq:multi:upper', 'EC-2024-G0385,EC-2023-G2031'),
    ('eq:multi:lower', 'ec-2024-g0385,ec-2023-g2031'),
    ('same:part', 'EC-2024'),          # 완전 일치 유지 확인(부분 입력은 0행이어야 함)
])]
