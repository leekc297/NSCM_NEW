# -*- coding: utf-8 -*-
# SCP0031 Global PSI — Model(nickName) : 앞부분 일치(값%) → 부분 일치(%값%) (plan.csv no 16). 컬럼·입력 UPPER 는 이미 적용(2026.10.20)이라 그대로.
#   수정 1곳 = GT_SCP0031_NICKITEM 적재문의 SCM_MST_ITEM_SN.NICK_NAME LIKE (P_SCP0031_GET_GLOBAL_PSI). 쉼표 분해·빈 토큰 제외는 그대로.
#   유지: no 15 Material(P_ITEM_ID) UPPER(B.ITEM_ID)/UPPER(B.CELL_ITEM_ID) IN (...) — 양쪽 UPPER 완료·AS-IS 완전 일치(변경 없음).
#         B.ITEM_ID / B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM GT_SCP0031_NICKITEM) — 위 결과 조인(값 비교 아님).
#   패키지 안에 P_NICK_NAME 을 받는 다른 프로시저 없음(PROCEDURE 1개 — work\PKG_SCP0031.cur.sql 전체 검색).
# LOWER: SCM_MST_ITEM_SN.NICK_NAME 소문자 0건 / 전체 796,166건 (2026-11-13 10:30:03)
HUNKS = [
    ("                          AND UPPER(NICK_NAME) LIKE UPPER(TRIM(SA.TOKEN))||'%');",
     "                          AND UPPER(NICK_NAME) LIKE '%'||UPPER(TRIM(SA.TOKEN))||'%');   /* 2026.11.13 조회조건 부분 일치 · 대소문자 무시 */"),
]
P = 'PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI'
B = {'P_FROM_YYYYMMDD': '20260831', 'P_TO_YYYYMMDD': '20261129', 'P_DIVISION_ID': '81_HG', 'P_PLAN_START_YYYYMMDD': '20260831',
     'P_PLAN_TYPE': 'PR', 'P_SEQ': '1', 'P_PROGRAM_ID': 'SCP0031', 'P_SHEET_NAME': 'Global PSI', 'P_USER_ID': 'minyonglee1',
     'P_BUCKET': 'WEEKLY', 'P_CHK_ALL': 'N', 'P_DEBUG_MODE': 'F'}
TESTS = [dict(proc=P, vary='P_NICK_NAME', key=[], base=B, values=[
    ('same:empty', None),
    ('eq:code:upper', 'E69B-400'),
    ('eq:code:lower', 'e69b-400'),
    ('eq:front:upper', 'E69B'),
    ('eq:front:lower', 'e69b'),
    ('eq:mid:upper', '69B-4'),        # 수정 전 0행(앞부분 일치) → 수정 후 부분 일치로 나와야 함
    ('eq:mid:lower', '69b-4'),
    ('eq:multi:upper', 'E69B, E81C-5'),
    ('eq:multi:lower', 'e69b, e81c-5'),
])]
