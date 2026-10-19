-- ============================================================================
-- [DMF0082 XLSFORM-ASIS 2026-09-21] 90 — VERIFY (적용 후 검증 · READ-ONLY)
--
--   판정 = 카운트가 아니라 **값 단언** (hook deploy-package-completeness §1.0-C).
--   아래 G1~G8 은 전부 사내오라클에서 PASS 로 실측된 것과 동일 쿼리다.
--   하나라도 FAIL 이면 README §7 "롤백" 절차로 되돌린다.
-- ============================================================================
SET LINESIZE 300
SET PAGESIZE 200

PROMPT ============================================================
PROMPT [G1] PKG_DMF0082 컴파일 상태      EXPECT: PACKAGE/PACKAGE BODY 둘 다 VALID
PROMPT ============================================================
SELECT OBJECT_TYPE, STATUS,
       CASE WHEN STATUS = 'VALID' THEN 'PASS' ELSE '*** FAIL ***' END AS VERDICT
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

PROMPT ------------------------------------------------------------
PROMPT [G2] 컴파일 에러                   EXPECT: 0행
PROMPT ------------------------------------------------------------
SELECT LINE, POSITION, TEXT FROM USER_ERRORS
 WHERE NAME = 'PKG_DMF0082' ORDER BY SEQUENCE;

PROMPT ------------------------------------------------------------
PROMPT [G3] HEADER_CONTENT = AS-IS DMF0020 과 완전 일치   EXPECT: ASIS_MATCH=1, TOKEN_CNT=19
PROMPT      (DMF0020 메타가 클라우드에 없으면 ASIS_MATCH 는 NULL — 그때는 G4 로 판정)
PROMPT ------------------------------------------------------------
SELECT (SELECT REGEXP_COUNT(HEADER_CONTENT,'\|') + 1
          FROM SCM_ADM_EXCEL_COLUMNS
         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice')            AS TOKEN_CNT
     , (SELECT CASE WHEN A.HEADER_CONTENT = B.HEADER_CONTENT THEN 1 ELSE 0 END
          FROM (SELECT HEADER_CONTENT FROM SCM_ADM_EXCEL_COLUMNS
                 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice') A
             , (SELECT HEADER_CONTENT FROM SCM_ADM_EXCEL_COLUMNS
                 WHERE PROGRAM_ID='DMF0020' AND SHEET_NAME='Sales Price') B) AS ASIS_MATCH
  FROM DUAL;

PROMPT ------------------------------------------------------------
PROMPT [G4] HEADER_CONTENT 값 단언        EXPECT: VERDICT=PASS
PROMPT ------------------------------------------------------------
SELECT CASE WHEN HEADER_CONTENT =
            'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
            THEN 'PASS' ELSE '*** FAIL ***' END AS VERDICT
     , HEADER_CONTENT
  FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice';

PROMPT ------------------------------------------------------------
PROMPT [G5] 양식 컬럼 메타 19행 + 라벨 순서 = HEADER 토큰 1:1   EXPECT: ROWS=19, VERDICT=PASS
PROMPT ------------------------------------------------------------
SELECT COUNT(*) AS ROWS_CNT
     , CASE WHEN COUNT(*) = 19 THEN 'PASS' ELSE '*** FAIL ***' END AS ROW_VERDICT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='Sales Price Template' AND VALID_YN='Y';

SELECT CASE WHEN LAB = HC THEN 'PASS' ELSE '*** FAIL ***' END AS VERDICT, LAB
  FROM (SELECT (SELECT LISTAGG(COLUMN_LABEL_NAME,'|') WITHIN GROUP (ORDER BY TO_NUMBER(SORT_ORDER_NO))
                  FROM SCM_MST_SHEET_COLUMNS
                 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='Sales Price Template' AND VALID_YN='Y') AS LAB
             , (SELECT HEADER_CONTENT FROM SCM_ADM_EXCEL_COLUMNS
                 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice') AS HC
          FROM DUAL);

PROMPT ------------------------------------------------------------
PROMPT [G6] 구 축 잔존 검사               EXPECT: 0행
PROMPT      (Sales Site / Incoterms / FCST Type / Customs Handbook / Plant Site / Measure)
PROMPT ------------------------------------------------------------
SELECT '구 토큰 잔존: ' || HEADER_CONTENT AS LEFTOVER
  FROM SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
   AND (  INSTR(HEADER_CONTENT,'Sales Site')       > 0
       OR INSTR(HEADER_CONTENT,'Incoterms')        > 0
       OR INSTR(HEADER_CONTENT,'FCST Type')        > 0
       OR INSTR(HEADER_CONTENT,'Customs Handbook') > 0
       OR INSTR(HEADER_CONTENT,'Plant Site')       > 0
       OR INSTR(HEADER_CONTENT,'Measure')          > 0 );

PROMPT ------------------------------------------------------------
PROMPT [G7] 이식 마커 존재                EXPECT: XLSFORMASIS>=2, ASIS_M_BLANK=2, SLOT_DOC=1
PROMPT      (M0~M12 빈칸 2곳 = FORM_DATA 의 '' AS M0 / 주석)
PROMPT ------------------------------------------------------------
SELECT SUM(CASE WHEN INSTR(TEXT,'E20260921-XLSFORMASIS') > 0 THEN 1 ELSE 0 END) AS XLSFORMASIS
     , SUM(CASE WHEN INSTR(TEXT,'''' || '''' || ' AS M0') > 0 THEN 1 ELSE 0 END) AS ASIS_M_BLANK
     , SUM(CASE WHEN INSTR(TEXT,'ATTRIBUTE1 Div / 2 Team') > 0 THEN 1 ELSE 0 END) AS SLOT_DOC
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY';

PROMPT ------------------------------------------------------------
PROMPT [G8] NLS 암묵 형변환 교정 확인     EXPECT: EXPLICIT=3, IMPLICIT=1(주석 1줄만)
PROMPT      IMPLICIT 가 2 이상이면 실행 코드에 암묵 변환이 남은 것 -> ORA-01861 재발 위험
PROMPT ------------------------------------------------------------
SELECT SUM(CASE WHEN INSTR(TEXT,'FN_NEXT_DAY(TO_DATE(T_VER.YYYYMMDD') > 0 THEN 1 ELSE 0 END) AS EXPLICIT
     , SUM(CASE WHEN INSTR(TEXT,'FN_NEXT_DAY(T_VER.YYYYMMDD')         > 0 THEN 1 ELSE 0 END) AS IMPLICIT
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY';

PROMPT ============================================================
PROMPT [G9] 런타임 스모크 — 81 양식 조회 (선택 · 세션 NLS 기본값 그대로 둘 것)
PROMPT      EXPECT : 오류 없이 반환 / M0~M12 전부 NULL 또는 빈문자
PROMPT      ⚠ NLS_DATE_FORMAT 을 바꾸지 말 것 — 교정이 통했는지 보는 게 목적이다.
PROMPT ============================================================
-- VAR RC1 REFCURSOR
-- VAR RC2 REFCURSOR
-- EXEC PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA('81','ALL','ALL','ALL','20260101','20261231','ALL','','ALL','Y','<USER_ID>','','ALL','ALL','ALL','ALL',:RC1,:RC2);
-- PRINT RC1
-- PRINT RC2
