# -*- coding: utf-8 -*-
# SCP0104 Line Assign — Material(Electrode 모드, P_ITEM_ID) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER 2곳 (plan.csv no 39)
#   수정 = P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR 의 A.NICK_NAME IN (SELECT COLUMN_VALUE …) 2곳
#   (현재분 SCP_MST_CAPA_ELTR_LINE_ASSIGN / 마감분 SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF). 비교 컬럼 NICK_NAME 은 그대로 둔다(UPPER 만).
#   유지: P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY 의 같은 인자 비교 — 이미 양쪽 UPPER + LIKE(2026.10.07 AJS), 그 위 '--' 주석 줄(옛 NICK_NAME IN)은 주석이라 제외.
#         같은 프로시저의 다른 인자(DIVISION/SITE/PLANT/…/ELECTRODE_TYPE IN (SELECT COLUMN_VALUE …))는 TEXT 조회조건이 아니라 범위 밖. SAVE·CHK·CALC 프로시저는 대상 아님.
# LOWER: SCP_MST_CAPA_ELTR_LINE_ASSIGN.NICK_NAME 소문자 0건 / 전체 22,359건 (2026-11-13 10:32:28) — 값은 전부 '-' 1종
# LOWER: SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF.NICK_NAME 소문자 0건 / 전체 601,284건 (2026-11-13 10:32:28) — 값은 전부 '-' 1종
RX = [(r"(?<![\w.(])(A\.NICK_NAME) IN \(SELECT COLUMN_VALUE\s*$", r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 2)]
P = 'PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR'
B = {'P_VERSION_SEQ': '1', 'P_DIVISION_ID': '82', 'P_SITE_ID': 'ALL', 'P_PLANT_ID': 'ALL', 'P_FACTORY_ID': 'ALL', 'P_LINE_ID': 'ALL',
     'P_OPERATION_ID': 'ALL', 'P_ELECTRODE_TYPE': 'ALL', 'P_VALID_FLAG': 'ALL', 'P_PROGRAM_ID': 'SCP0104', 'P_SHEET_NAME': 'ELTR',
     'P_USER_ID': 'minyonglee1', 'P_DEBUG_MODE': 'N'}
# ※ 두 테이블의 NICK_NAME 이 전부 '-' 라 영문 값으로 1행 이상 나오는 대소문자 쌍을 만들 수 없다(eq:code 는 전후 모두 0행). '-' 입력(same:dash)으로 일치 경로만 확인한다.
TESTS = [
    dict(proc=P, vary='P_ITEM_ID', key=[], base=dict(B, P_VERSION='202610'), values=[   # 현재분(PROG_STAT 0)
        ('same:empty', None),
        ('same:ALL', 'ALL'),
        ('same:dash', '-'),
        ('same:dash-multi', '-, JF1'),
        ('eq:code:upper', 'JF1'),
        ('eq:code:lower', 'jf1'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], base=dict(B, P_VERSION='202609'), values=[   # 마감분(PROG_STAT 2)
        ('same:cut-empty', None),
        ('same:cut-ALL', 'ALL'),
        ('same:cut-dash', '-'),
        ('same:cut-dash-multi', '-, JF1'),
        ('eq:cutcode:upper', 'JF1'),
        ('eq:cutcode:lower', 'jf1'),
    ]),
]
