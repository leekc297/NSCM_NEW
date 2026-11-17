# -*- coding: utf-8 -*-
# SSP0019 Shipment Change History — SO No : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER(2곳).
RX = [(r"(?<![\w.(])((?:\w+\.)?ERP_SO_NO) IN \(SELECT COLUMN_VALUE", r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 2)]
P = 'PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY'
B = {'P_DIVISION_ID': 'ALL', 'P_FROM_SITE': 'ALL', 'P_TO_SITE': 'ALL', 'P_INCOTERMS': 'ALL', 'P_FROM_YYYYMMDD': '20260801', 'P_TO_YYYYMMDD': '20261231', 'P_LANGUAGE': 'EN'}
TESTS = [dict(proc=P, vary='P_SONO', key=[], base=B, values=[
    ('same:empty', None),
    ('eq:one:a', '4570302671'),
    ('eq:one:b', ' 4570302671 '),
    ('same:two', '4570302671,1100030111'),
    ('same:part', '45703026'),
])]
