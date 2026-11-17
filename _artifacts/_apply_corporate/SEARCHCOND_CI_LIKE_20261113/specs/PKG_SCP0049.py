# -*- coding: utf-8 -*-
# SCP0049 Version Name 팝업(P_GET_NEW_VERSION_INFO) — Version Name : LIKE %값% 는 AS-IS 와 이미 같음 → 컬럼·입력 양쪽 UPPER 만 추가 1곳 (plan.csv no 30)
#   유지: P_SAVE_NEW_VERSION 의 P_VERSION_NAME(INSERT 값 — 저장, 대상 아님). 패키지 안에서 VERSION_NAME 을 조건으로 비교하는 곳은 이 1곳뿐
#         (work\PKG_SCP0049.cur.sql 전체 검색: 6줄 = 인자 선언 2 · SELECT 목록 1 · 이 조건 1 · INSERT 2).
# LOWER: SCM_MASTER_VERSION_INFO_H_SN.VERSION_NAME 소문자 포함 6건 / 전체 6,541건 (2026-11-13 10:30:03) — 예: 20260311_D_Temp001_81, 20260423_D_Temp001_81_uc
HUNKS = [
    ("               AND (TRIM(P_VERSION_NAME) IS NULL OR A.VERSION_NAME LIKE '%' || P_VERSION_NAME || '%')",
     "               AND (TRIM(P_VERSION_NAME) IS NULL OR UPPER(A.VERSION_NAME) LIKE '%' || UPPER(P_VERSION_NAME) || '%')   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SCP0049.P_GET_NEW_VERSION_INFO'
B = {'P_FROM_DATE': '20251201', 'P_TO_DATE': '20261231'}
TESTS = [dict(proc=P, vary='P_VERSION_NAME', key=[], cursor='O_RC', base=B, values=[
    ('same:empty', None),
    ('eq:code:upper', '81-20261102-PR-01'),
    ('eq:code:lower', '81-20261102-pr-01'),
    ('eq:part:upper', '_D_2311_82'),
    ('eq:part:lower', '_d_2311_82'),
    ('eq:mixed:upper', 'TEMP001'),     # 저장값이 'Temp001'(대소문자 섞임) — 수정 전에는 'Temp001' 입력만 일치
    ('eq:mixed:lower', 'temp001'),
    ('eq:mixed:asis', 'Temp001'),
])]
