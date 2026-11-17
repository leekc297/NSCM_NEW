# -*- coding: utf-8 -*-
# SCP0097 SCP BOM(Elec) — Parent Item / Child Item : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼 쪽 UPPER 추가 (plan.csv no 34, 35)
#   입력 토큰은 이미 UPPER(TOKEN). 수정 = P_SCP0097_GET_SCP_BOM_ELEC 의 PARENT_ITEM_ID IN ( 3곳 + CHILD_ITEM_ID IN ( 3곳
#   (별칭 조회용 인라인뷰 2개 + 본 조회). 주석 처리된 옛 조회(-- 줄)는 건드리지 않는다.
#   유지: P_SCP0097_SAVE_SCP_BOM_ELEC(저장) · P_SPL_ARR(내부 분해).
# LOWER: SCP_MST_BOM_ELEC.PARENT_ITEM_ID 소문자 0건 / 전체 29,985건 (2026-11-13 10:32:28)
# LOWER: SCP_MST_BOM_ELEC.CHILD_ITEM_ID 소문자 0건 / 전체 29,985건 (2026-11-13 10:32:28)
RX = [(r"(?<![\w.(])((?:XA|A)\.(?:PARENT|CHILD)_ITEM_ID) IN \(", r"UPPER(\1) IN (", 6)]
P = 'PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC'
B = {'P_DIVISION_ID': '40', 'P_DEBUG_MODE': 'N'}
TESTS = [
    dict(proc=P, vary='P_PARENT_ID', key=[], base=B, values=[
        ('same:empty', None),
        ('eq:code:upper', 'ACACA3223A'),
        ('eq:code:lower', 'acaca3223a'),
        ('eq:multi:upper', 'ACACA3223A, EAE0074N5-01'),
        ('eq:multi:lower', 'acaca3223a, eae0074n5-01'),
        ('same:part', 'ACACA322'),
    ]),
    dict(proc=P, vary='P_CHILD_ID', key=[], base=B, values=[
        ('same:empty', None),
        ('eq:code:upper', 'APCAN1921A'),
        ('eq:code:lower', 'apcan1921a'),
        ('eq:multi:upper', 'APCAN1921A, APCCA2488A'),
        ('eq:multi:lower', 'apcan1921a, apcca2488a'),
        ('same:part', 'APCAN192'),
    ]),
]
