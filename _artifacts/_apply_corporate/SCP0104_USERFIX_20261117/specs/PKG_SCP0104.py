# -*- coding: utf-8 -*-
# SCP0104 사용자의견 DB 보완 (2026-11-17) — PKG_SCP0104 PACKAGE BODY 수정 구간
# 기준본 = apply_patch.py 가 실행 시 ALL_SOURCE 에서 새로 조회한 원문(#152)
TYPE = 'PACKAGE BODY'
def M(t):
    return '/* 2026.11.17 SCP0104 보완: ' + t + ' */'

HUNKS = [
    # ① ORA-01840 — 변경 행이 없어 GT_SCP_CAPA_LINE_ASSIGN_KEYS 가 비면 V_VERSION 이 NULL → TO_DATE('01','YYYYMMDD') 오류.
    #    AS-IS(MSSQL)는 NULL 을 그대로 넘기고 오류 없이 다음 문장(LOSS_PLAN 정리 DELETE)을 실행한다.
    #    P_SCP0106_CHK_LOSS_ASGN_ASM(1796) · P_SCP0106_CHK_LOSS_ASGN_ELTR(3119) 2곳
    ("    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');\n"
     "    V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');",
     "    " + M("변경 행이 없으면 V_VERSION 이 NULL, AS-IS 처럼 NULL 로 두고 계속(ORA-01840 방지)") + "\n"
     "    IF V_VERSION IS NOT NULL THEN\n"
     "        V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');\n"
     "        V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');\n"
     "    END IF;",
     2),
    # ② Dummy 코드 이름 비교 — AS-IS MERGE ON NAME 은 Latin1_General_CI_AS(대소문자 무시). TO-BE 도 대소문자 무시로
    ("                               AND A.NAME    = V_NAME);",
     "                               AND UPPER(A.NAME) = UPPER(V_NAME));   " + M("AS-IS CI 정렬 등가"),
     1),
    ("             WHERE NAME = V_NAME;",
     "             WHERE UPPER(NAME) = UPPER(V_NAME);   " + M("AS-IS CI 정렬 등가"),
     1),
    # ③ ELTR 조회조건 Material — AS-IS SCP0104_GET_CAPA_LINE_ASSIGN_ELTR:720·802 = A.ITEM_ID IN (...). TO-BE 는 NICK_NAME(전부 '-')으로 비교해 0행
    #    대소문자 무시는 11-13 조회조건 규칙 유지(본문·보관 테이블 2곳)
    ("                OR  UPPER(A.NICK_NAME) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */",
     "                OR  UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */ " + M("AS-IS ITEM_ID 비교"),
     2),
    # ④ SOP 조회 정렬 — AS-IS ORDER BY 끝의 OPERATION_ID, ELTR_LN_TP_CD 누락(SOP_ASSEMBLY · SOP_ELTR 2곳)
    ("         ORDER BY A.DIVISION_ID\n"
     "                , IA.SITE_ID\n"
     "                , IB.COMPANY_ID\n"
     "                , IC.PLANT_ID\n"
     "                , ID.FACTORY_ID\n"
     "                , IE.LINE_ID;",
     "         ORDER BY A.DIVISION_ID\n"
     "                , IA.SITE_ID\n"
     "                , IB.COMPANY_ID\n"
     "                , IC.PLANT_ID\n"
     "                , ID.FACTORY_ID\n"
     "                , IE.LINE_ID\n"
     "                , A.OPERATION_ID      " + M("AS-IS ORDER BY 등가") + "\n"
     "                , A.ELTR_LN_TP_CD;",
     2),
]
TESTS = []   # 시험은 verify_after.py(저장 실패 재현 4건 · Material · 정렬 · Dummy 대소문자)
