# -*- coding: utf-8 -*-
# SCP0098 CAPA (Mobility IT) — Model/Nickname(P_ITEM_ID) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼 쪽 UPPER 추가 1곳 (plan.csv no 36)
#   입력 토큰은 이미 UPPER(COLUMN_VALUE). 수정 = P_GET_CAPA_MOBILITYIT 의 SA.ITEM_ID IN (…) 1곳(SCM_MST_ITEM_LINE_ASSIGN_SN, 인라인뷰 XA).
#   유지: P_GET_CAPA_MOBILITYIT_LINE 의 같은 식 — 화면에 등록되지 않은 프로시저라 건드리지 않는다(총괄 지시).
#         같은 식이 두 프로시저에 글자까지 같아, 뒤따르는 줄(MOBILITYIT 은 조인 뒤 바로 ';', _LINE 은 'AND XA.PRIORITY …')까지 묶어 1건만 치환한다.
#         T.ITEM_NAME IN (… P_NICK_NAME …) — 다른 인자(FE '' 고정)라 범위 밖. P_SAVE_* 는 저장.
# LOWER: SCM_MST_ITEM_LINE_ASSIGN_SN.ITEM_ID 소문자 0건 / 전체 569,394건 (2026-11-13 10:32:28)
HUNKS = [
    ("""                    AND ( TRIM(P_ITEM_ID) IS NULL OR SA.ITEM_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) ) )
               ) XA
         WHERE IA.DIVISION_ID  = XA.DIVISION_ID(+)
           AND IA.SITE_ID      = XA.SITE_ID(+)
           AND IA.PLANT_ID     = XA.PLANT_ID(+)
           AND IA.FACTORY_ID   = XA.FACTORY_ID(+)
           AND IA.LINE_ID      = XA.LINE_ID(+)
           AND IA.OPERATION_ID = XA.OPERATION_ID(+)
        ;""",
     """                    AND ( TRIM(P_ITEM_ID) IS NULL OR UPPER(SA.ITEM_ID) IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) ) )   /* 2026.11.13 조회조건 대소문자 무시 */
               ) XA
         WHERE IA.DIVISION_ID  = XA.DIVISION_ID(+)
           AND IA.SITE_ID      = XA.SITE_ID(+)
           AND IA.PLANT_ID     = XA.PLANT_ID(+)
           AND IA.FACTORY_ID   = XA.FACTORY_ID(+)
           AND IA.LINE_ID      = XA.LINE_ID(+)
           AND IA.OPERATION_ID = XA.OPERATION_ID(+)
        ;"""),
]
P = 'PKG_SCP0098.P_GET_CAPA_MOBILITYIT'
B = {'P_TODAY_YYYYMMDD': '20261113', 'P_FROM_YYYYMMDD': '20261101', 'P_TO_YYYYMMDD': '20261231', 'P_DIVISION_ID': '40',
     'P_PLANT_ID': 'ALL', 'P_BUCKET': 'M', 'P_USER_ID': 'minyonglee1', 'P_DEBUG_MODE': 'N'}
TESTS = [dict(proc=P, vary='P_ITEM_ID', key=[], cursor='O_RC', base=B, values=[
    ('same:empty', None),
    ('eq:code:upper', 'MAMM9314U0A1-016'),
    ('eq:code:lower', 'mamm9314u0a1-016'),
    ('eq:multi:upper', 'MAMM9314U0A1-016, MAMM9314U0A1-018'),
    ('eq:multi:lower', 'mamm9314u0a1-016, mamm9314u0a1-018'),
    ('same:part', 'MAMM9314U0A1'),
])]
