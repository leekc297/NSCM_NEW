# -*- coding: utf-8 -*-
# SCP0101 Inventory Trend — Material : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼 쪽 UPPER 추가(7곳). 입력 토큰은 이미 UPPER.
RX = [(r"(?<![\w.(])((?:\w+\.)?ITEM_ID) IN \(SELECT UPPER\(COLUMN_VALUE\)", r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 7)]
P = 'PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREND'
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=[], base={'P_YYYYMM': '202609', 'P_DIVISION_ID': '82', 'P_PLANT_ID': 'ALL'}, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'EH048126P2S1'),
    ('eq:code:lower', 'eh048126p2s1'),
    ('eq:multi:upper', 'EH048126P2S1, EH155063P3S2'),
    ('eq:multi:lower', 'eh048126p2s1, eh155063p3s2'),
    ('eq:part:upper', 'EH048126'),
    ('eq:part:lower', 'eh048126'),
])]
