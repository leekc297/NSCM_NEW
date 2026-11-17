# -*- coding: utf-8 -*-
# SSP0045 Shipment Request SEMI — BOD 선택 팝업 Model/Nickname (plan.csv no 68) : AS-IS 단건 '=' → 형태 유지, 컬럼·입력 양쪽 UPPER(1곳).
#   대상 = P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE 의 A.ITEM_ID = P_ITEM_ID (SCP_MST_BOD_ITEM A) 1곳.
#   유지: P_SSP0045_GET_SHIPMENT_REQUEST 의 P_ITEM_ID(주 화면 Model/Nickname — plan.csv 의 이 패키지 대상은 no 68 뿐, 해당 프로시저는 이미 UPPER 후보 목록 방식),
#         P_SSP0045_SAVE_SHIPMENT_REQUEST 의 P_ITEM_ID(저장) 는 대상 아님.
# LOWER: SCP_MST_BOD_ITEM.ITEM_ID 소문자 0건 / 전체 334,787건 (2026-11-13 10:30 조회)
HUNKS = [
    ("               AND A.ITEM_ID           = P_ITEM_ID",
     "               AND UPPER(A.ITEM_ID)    = UPPER(P_ITEM_ID)   /* 2026.11.13 조회조건 대소문자 무시 */"),
]
P = 'PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE'
B = {'P_DIVISION_ID': '40', 'P_OPERATION_GROUP': 'A', 'P_FROM_YYYYMMDD': '20261113', 'P_PROGRAM_ID': 'SSP0045'}
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=[], base=B, values=[
    ('same:empty', None),
    ('same:code', 'MCCM125010A1'),
    ('eq:code:upper', 'MCCM125010A1'),
    ('eq:code:lower', 'mccm125010a1'),
    ('eq:code2:upper', 'MCCM348514A4-D01'),
    ('eq:code2:lower', 'mccm348514a4-d01'),
])]
