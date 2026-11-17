# -*- coding: utf-8 -*-
# SCP0039 Master Validation — Model/Nickname(P_ITEM_ID) 11개 시트 : LIKE %값% 는 AS-IS·TO-BE 같음 → 컬럼 쪽 UPPER 만 추가 (plan.csv no 18~28)
#   입력 토큰은 이미 UPPER(TRIM(...)) (IA.TST, 2026.10.07) → 그대로.
#   수정 22곳 = 11개 조회 프로시저 × 컬럼 2개 (A.<코드 컬럼> LIKE IA.TST / A.<닉네임 컬럼> LIKE IA.TST)
#     PLAN_GROUP: A.SALES_ITEM_ID · A.MODEL_NICK_NAME (GT_0039_MKT_FCST_PLAN_GROUP)
#     YIELD · BOM · PROJECT_ROUTE · OS_CAPACITY · TACT_TIME_OSP · PR_ELEC · LINE_ASSIGN · TACT_TIME · BOD: A.MODEL_ID · A.NICK_NAME (GT_0039_TGT_DATA_PLAN_GROUP)
#     INTRANSIT_INV: A.ITEM_ID · A.NICK_NAME (GT_0039_INT_TGT_PLAN_GROUP)
#   유지: P_SCP0039_GET_VALIDATION_STOCK_OSP — P_ITEM_ID 인자는 있으나 본문에서 비교에 쓰지 않음(로그 문자열 조립뿐),
#         Plan Group 조건(P_PLAN_GROUP_ID — 계획 대상 밖), 그 밖의 LIKE 'CA%' 등 고정 문자 비교, 주석 줄(2026.10.07 이전 원문).
# LOWER: 비교 대상이 세션 임시 테이블(GTT)이라 원장 직접 집계 불가 → 수정 전 시험의 빈값 조회 결과에서 코드·닉네임 컬럼의 소문자 포함 값을 집계(아래 TESTS 위 주석).
RX = [
    (r"\b(A\.(?:SALES_ITEM_ID|MODEL_NICK_NAME|MODEL_ID|ITEM_ID|NICK_NAME))(\s+)LIKE IA\.TST", r"UPPER(\1)\2LIKE IA.TST", 22),
]
#   실측(2026-11-13 10:31~10:41, P_ITEM_ID 빈값 조회 결과의 코드·닉네임 출력 컬럼): 소문자 포함 값 0건
#     Division 81: PLAN_GROUP 79행 · YIELD 0 · BOM 24 · PROJECT_ROUTE 29 · OS_CAPACITY 4 · TACT_TIME_OSP 0 · PR_ELEC 5 · LINE_ASSIGN 65 · TACT_TIME 87 · BOD 29 · INTRANSIT_INV 0
#     Division 40: PLAN_GROUP 11 · YIELD 4 · BOM 17 · PROJECT_ROUTE 9 · OS_CAPACITY 4 · TACT_TIME_OSP 0 · PR_ELEC 12 · LINE_ASSIGN 74 · TACT_TIME 61 · BOD 11 · INTRANSIT_INV 0
#     Division 82: OS_CAPACITY 4 외 전부 0
#   TACT_TIME_OSP · INTRANSIT_INV 는 81·82·40·81_UC·81_HG·81_ST·81_HD·81_HM·EE·EE_UC 전부 빈값 조회 0행(검증 오류 데이터 없음)
#     → 1행 이상 나오는 시험을 만들 수 없음. 오류 없이 실행되는지만 확인(행 수 0).
PX = 'PKG_SCP0039.P_SCP0039_GET_VALIDATION_'


def T(name, div, code, nick, multi=None):
    v = [('same:empty', None),
         ('eq:code:upper', code.upper()), ('eq:code:lower', code.lower()),
         ('eq:nick:upper', nick.upper()), ('eq:nick:lower', nick.lower())]
    if multi:
        v += [('eq:multi:upper', multi.upper()), ('eq:multi:lower', multi.lower())]
    return dict(proc=PX + name, vary='P_ITEM_ID', key=[], base={'P_DIVISION_ID': div}, values=v)


TESTS = [
    T('PLAN_GROUP', '81', 'AMVWGMC25-A1-0D0', 'VWG-MC25', 'AMVWGMC25, FCA-GSW'),
    T('YIELD', '40', 'MAP2563H4A10', 'BRZ V7'),
    T('BOM', '81', 'AMTYTTNGA-A1-070', 'H5.5C', 'AMTYTTNGA, H5.5C'),
    T('PROJECT_ROUTE', '81', 'AMFMCC727-E1', 'VWG-MEB'),
    T('OS_CAPACITY', '81', 'MCP376880A10', 'AMERICA OTHERS'),
    T('TACT_TIME_OSP', '81', 'MCP376880A10', 'AMERICA OTHERS'),      # 데이터 없음 — 0행
    T('PR_ELEC', '81', 'APCAN3580A', 'U56A'),
    T('LINE_ASSIGN', '81', 'ACEN4065I-A1-601', 'N2.2-6'),
    T('TACT_TIME', '81', 'ACEN4069I-A1-400', 'E71A'),
    T('BOD', '81', 'AMFMCC727-E1', 'TYT E-TNGA'),
    T('INTRANSIT_INV', '81', 'AMFMCC727-E1', 'TYT E-TNGA'),          # 데이터 없음 — 0행
]
