# -*- coding: utf-8 -*-
# SCP0055 Shipment(Allo) Report — Model/Nickname(P_ITEM_ID) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼 쪽 UPPER 추가 4곳 (plan.csv no 33)
#   입력 토큰은 이미 UPPER(COLUMN_VALUE). 수정 = P_SCP0055_GET_SHIPMENT_ALLO_PLAN 안 A.ITEM_ID IN (...) 4곳
#   (SCP_ANL_SHIPMENT_PLAN_FG / SCP_ANL_SHIPMENT_PLAN_SEMI / SCM_DNM_EXFACTORY_RESULT 2곳).
#   유지: 같은 프로시저의 A.NICK_NAME IN (… V_NICKNAME …) 2곳 — 다른 인자(P_NICKNAME, 팝업 선택 시만 채워짐·plan.csv 참고 지점)라 범위 밖.
#         P_SCP0055_GET_SHIPMENT_ALLO_NOTE / SAVE 에는 P_ITEM_ID 조회조건 비교 없음.
# LOWER: SCP_ANL_SHIPMENT_PLAN_FG.ITEM_ID 소문자 0건 / 전체 208,537,098건 (2026-11-13 10:32:12)
# LOWER: SCP_ANL_SHIPMENT_PLAN_SEMI.ITEM_ID 소문자 0건 / 전체 43,354,206건 (2026-11-13 10:32:27)
# LOWER: SCM_DNM_EXFACTORY_RESULT.ITEM_ID 소문자 0건 / 전체 912,895건 (2026-11-13 10:32:28)
RX = [(r"(?<![\w.(])(A\.ITEM_ID) IN \(SELECT UPPER\(COLUMN_VALUE\)", r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 4)]
P = 'PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_PLAN'
# 기준 A: 계획 시작 20261019(81/A, MA seq 1) — FG 계획(O_RC1) + 실적(O_RC3). 기준 B: 계획 시작 20261109 — SEMI 계획(O_RC1)
BA = {'P_FROM_YYYYMMDD': '20260921', 'P_TO_YYYYMMDD': '20261231', 'P_DIVISION_ID': '81', 'P_BIZ_TYPE': 'A',
      'P_PLAN_START_YYYYMMDD': '20261019', 'P_FCST_YN': 'N', 'P_CELL_TYPE_GR': 'ALL', 'P_FROMSITE': 'ALL', 'P_TEAM_ID': 'ALL'}
BB = dict(BA, P_FROM_YYYYMMDD='20261012', P_TO_YYYYMMDD='20270331', P_PLAN_START_YYYYMMDD='20261109')
TESTS = [
    dict(proc=P, vary='P_ITEM_ID', key=[], cursor='O_RC1', base=BA, values=[
        ('same:empty', None),
        ('same:ALL', 'ALL'),
        ('eq:code:upper', 'ACHP2005I-A1-101'),
        ('eq:code:lower', 'achp2005i-a1-101'),
        ('eq:multi:upper', 'ACHP2005I-A1-101, ACEH1161I-A1-700'),
        ('eq:multi:lower', 'achp2005i-a1-101, aceh1161i-a1-700'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], cursor='O_RC3', base=BA, values=[
        ('same:rc3-empty', None),
        ('same:rc3-ALL', 'ALL'),
        ('eq:rc3code:upper', 'ACHP2005I-A1-101'),
        ('eq:rc3code:lower', 'achp2005i-a1-101'),
        ('eq:rc3multi:upper', 'ACHP2005I-A1-101, ACEH1161I-A1-700'),
        ('eq:rc3multi:lower', 'achp2005i-a1-101, aceh1161i-a1-700'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], cursor='O_RC1', base=BB, values=[
        ('same:semi-empty', None),
        ('eq:semicode:upper', 'ACEF1090I-A1-000'),
        ('eq:semicode:lower', 'acef1090i-a1-000'),
        ('eq:semimulti:upper', 'ACEF1090I-A1-000, ACEN4128I-A1-000'),
        ('eq:semimulti:lower', 'acef1090i-a1-000, acen4128i-a1-000'),
    ]),
]
