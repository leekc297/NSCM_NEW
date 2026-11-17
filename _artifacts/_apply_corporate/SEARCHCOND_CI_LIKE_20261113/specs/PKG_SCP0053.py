# -*- coding: utf-8 -*-
# SCP0053 SCP BOM (Cell~Pack) — Parent Item / Child Item : AS-IS 단일 값 완전 일치(=, IN 3값) → LIKE 미적용, 컬럼 쪽 UPPER 만 추가 (plan.csv no 31, 32)
#   입력은 선언부에서 V_PARENT_ID := UPPER(P_PARENT_ID), V_CHILD_ID := UPPER(P_CHILD_ID) 로 이미 UPPER → 그대로.
#   수정 16곳(전부 P_SCP0053_GET_SCP_BOM):
#     RX1 12곳 = [A|E].PARENT_ITEM_ID = V_PARENT_ID / [A|E].CHILD_ITEM_ID = V_CHILD_ID
#               (ALTER 분기 4 · ALL·모델 미입력 4 · ALL·모델 입력 4; A=SCM_MST_BOM_SN, E=SCM_MST_ALTER_BOM)
#     RX2  2곳 = B.PARENT_ITEM_ID / B.CHILD_ITEM_ID IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)  (ALTER 분기, B=SCM_MST_ALTER_BOM_MODEL)
#     RX3  2곳 = (SCM_MST_ITEM_SN) ITEM_ID IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)  (ALL 분기 2개 — plan.csv 가 추가 확인한 지점)
#   RX2·RX3 는 Model/Parent/Child 3개 인자가 한 식에 묶여 있어 컬럼 UPPER 가 Model 인자에도 함께 걸린다(인자 쪽은 모두 UPPER 대입).
#   유지: Model/Nickname 경로(V_MODEL_TAB 조립 = 이미 양쪽 UPPER · A.MODEL_ID IN (V_MODEL_TAB) — 계획 대상 밖), Plant Site 조건,
#         조인식(A.PARENT_ITEM_ID = B.PARENT_ITEM_ID 등), 주석 줄, P_SCP0053_SAVE_SCP_BOM·P_SCM_MST_ALTER_BOM_H(저장·이력).
# LOWER: SCM_MST_BOM_SN.PARENT_ITEM_ID 0건 / 4,744,712건 · CHILD_ITEM_ID 0건 / 4,744,712건 (2026-11-13 10:30:06~08)
# LOWER: SCM_MST_ALTER_BOM.PARENT_ITEM_ID 0건 / 7,647건 · CHILD_ITEM_ID 0건 / 7,647건 (2026-11-13 10:30:08)
# LOWER: SCM_MST_ALTER_BOM_MODEL.PARENT_ITEM_ID 0건 / 19,656건 · CHILD_ITEM_ID 0건 / 19,656건 (2026-11-13 10:30:08)
# LOWER: SCM_MST_ITEM_SN.ITEM_ID 0건 / 796,166건 (2026-11-13 10:30:03)
# 주의: SCM_MST_BOM_SN(474만 행) 의 PARENT/CHILD_ITEM_ID 에 UPPER 를 씌우면 그 컬럼 인덱스 접근이 막힐 수 있다(미측정) — 수정 전후 시간 대조 필요(--after).
RX = [
    (r"\b([AE]\.(PARENT|CHILD)_ITEM_ID)(\s*)= V_\2_ID\)", r"UPPER(\1)\3= V_\2_ID)", 12),
    (r"\b(B\.(?:PARENT|CHILD)_ITEM_ID)(\s+)IN \(V_MODEL_ID, V_PARENT_ID, V_CHILD_ID\)", r"UPPER(\1)\2IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)", 2),
    (r"WHERE ITEM_ID(\s+)IN \(V_MODEL_ID, V_PARENT_ID, V_CHILD_ID\)", r"WHERE UPPER(ITEM_ID)\1IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)", 2),
]
P = 'PKG_SCP0053.P_SCP0053_GET_SCP_BOM'
ALT = {'P_DIVISION_ID': '81_ST', 'P_ALTER_BOM': 'ALTER', 'P_DEBUG_MODE': 'F'}
ALL = {'P_DIVISION_ID': '81_ST', 'P_ALTER_BOM': 'ALL', 'P_DEBUG_MODE': 'F'}
ALLM = dict(ALL, P_MODEL_ID='EP096636PFBA-DD0')
TESTS = [
    dict(proc=P, vary='P_PARENT_ID', key=[], cursor='O_RC', base=ALT, values=[
        ('same:alt-empty', None), ('eq:alt:upper', 'EP096636PFBA-DD0'), ('eq:alt:lower', 'ep096636pfba-dd0')]),
    dict(proc=P, vary='P_PARENT_ID', key=[], cursor='O_RC', base=ALL, values=[
        ('eq:all:upper', 'EP096636PFBA-DD0'), ('eq:all:lower', 'ep096636pfba-dd0')]),
    dict(proc=P, vary='P_PARENT_ID', key=[], cursor='O_RC', base=ALLM, values=[
        ('same:allm-empty', None), ('eq:allm:upper', 'EP096636PFBA-DD0'), ('eq:allm:lower', 'ep096636pfba-dd0')]),
    dict(proc=P, vary='P_CHILD_ID', key=[], cursor='O_RC', base=ALT, values=[
        ('eq:alt:upper', 'AMDES0059A'), ('eq:alt:lower', 'amdes0059a')]),
    dict(proc=P, vary='P_CHILD_ID', key=[], cursor='O_RC', base=ALL, values=[
        ('eq:all:upper', 'AMDES0059A'), ('eq:all:lower', 'amdes0059a')]),
    dict(proc=P, vary='P_CHILD_ID', key=[], cursor='O_RC', base=ALLM, values=[
        ('eq:allm:upper', 'AMDES0059A'), ('eq:allm:lower', 'amdes0059a')]),
]

# 총괄 추가(2026-11-13): 큰 Division(81) 시간 대조용 — SCM_MST_BOM_SN 474만 행 구간
BIG = {'P_DIVISION_ID': '81', 'P_ALTER_BOM': 'ALL', 'P_DEBUG_MODE': 'F'}
TESTS += [
    dict(proc=P, vary='P_PARENT_ID', key=[], cursor='O_RC', base=BIG, values=[('eq:bigP:upper', 'AAEF1001I-A1-000'), ('eq:bigP:lower', 'aaef1001i-a1-000')]),
    dict(proc=P, vary='P_CHILD_ID', key=[], cursor='O_RC', base=BIG, values=[('eq:bigC:upper', 'ASCSC0738A'), ('eq:bigC:lower', 'ascsc0738a')]),
]
