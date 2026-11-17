# -*- coding: utf-8 -*-
# SCP0129 Demand Exception — Model/Nickname : 컬럼 쪽 UPPER 추가(대소문자 무시). LIKE 는 이미 %값% (입력 토큰은 F_SPLIT_CLOB_LIST 가 UPPER).
HUNKS = [
    ("WHERE A.ITEM_ID LIKE '%' || XA.COLUMN_VALUE || '%'",
     "WHERE UPPER(A.ITEM_ID) LIKE '%' || XA.COLUMN_VALUE || '%'   /* 2026.11.13 조회조건 대소문자 무시 : 컬럼도 대문자로 비교 */"),
    ("AND XB.NICK_NAME LIKE '%' || XA.COLUMN_VALUE || '%')))",
     "AND UPPER(XB.NICK_NAME) LIKE '%' || XA.COLUMN_VALUE || '%')))   /* 2026.11.13 조회조건 대소문자 무시 : 컬럼도 대문자로 비교 */"),
]
P = 'PKG_SCP0129.P_SCP0129_GET_DEMAND_EXCEPTION'
KEY = ['PRE_KEY_VALUES']
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=KEY, base={'P_PERIOD_FROM': '20000101', 'P_PERIOD_TO': '99991231'}, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'ACEF1090I-A1-500'),
    ('eq:code:lower', 'acef1090i-a1-500'),
    ('eq:part:upper', 'ACEF1090'),
    ('eq:part:lower', 'acef1090'),
    ('eq:nick:upper', 'E90B-500'),
    ('eq:nick:lower', 'e90b-500'),
    ('eq:multi:upper', 'EAE1558F1, P37B'),
    ('eq:multi:lower', 'eae1558f1, p37b'),
])]
