-- ============================================================================
-- DMF0082 / Division 81 — "정적 컬럼 동일한데 메저가 복수 행" 원인 확정 + 영향 산출
--
--   ⭐ 원인 : DM_MST_CUSTOMER_FCST.MEASURE 에 **같은 개념의 표기 변형**이 누적되어
--             PKG_DMF0082 의 CUST_FCST 하위 확장 블록([E20260825-CUSTSUB])이
--             변형마다 1행씩 승격 -> 전부 같은 SORT_ORDER_NO(+0.10) -> 같은 자리에 N행.
--
--   사내(ZIOUI1) 2026-09-21 실측
--     Customer FCST   2,810행(81) / 109행(40)  2022-11-08~  ys_cho·hwayoung.lim
--     Customer Fcst     257행(81)              2026-09-03~  minyonglee1   (대소문자 변형)
--     Cutomer FCST      191행(81)              2024-01-02~  jtomczak      (오타: Cutomer)
--     -> 셋 다 SCM_MST_SHEET_MEASURE 미등재 = 라벨 없음(유령 measure)
--     -> 40 은 변형 1종뿐이라 충돌 없음 (= "40은 해결됐다" 와 일치)
--     -> 영향 사용자 11명 (titleset 에 CUST_FCST 를 선택한 전원)
--
--   성격 : READ-ONLY. ⭐ 사용자 ID 불필요 — SP 호출 없이 전 사용자를 한 번에 판정한다.
--          (PKG 의 measure 적재 3블록을 SQL 로 재현)
--   검증 : 사내에서 실행해 11건 충돌 재현 확인 후 배포.
-- ============================================================================
SET LINESIZE 300
SET PAGESIZE 200
SET SQLBLANKLINES ON

PROMPT ============================================================
PROMPT [1] CUST_FCST measure 표기 변형 전수 (원인 그 자체)
PROMPT     EXPECT : 변형 1종. 2종 이상이면 그 수만큼 화면 행이 겹친다.
PROMPT ============================================================
SELECT C.MEASURE
     , C.DIVISION_ID
     , C.VALID_YN
     , COUNT(*)                                          AS LEDGER_ROWS
     , MIN(TO_CHAR(C.CREATION_DATE,'YYYY-MM-DD'))        AS FIRST_CREATED
     , MAX(C.CREATED_BY)                                 AS CREATED_BY
     , MAX(C.UPLOAD_UOM)                                 AS UOM
     , MAX(C.UPLOAD_BUCKET_TYPE)                         AS BUCKET_TP
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE M
                          WHERE M.PROGRAM_ID = 'DMF0082' AND M.COLUMN_NAME = C.MEASURE)
            THEN 'Y' ELSE '*** 미등재(라벨없음) ***' END  AS IN_SHEET_MEASURE
  FROM DM_MST_CUSTOMER_FCST C
 WHERE C.MEASURE_GROUP = 'CUST_FCST'
   AND NVL(C.MEASURE,'-') <> '-'
 GROUP BY C.MEASURE, C.DIVISION_ID, C.VALID_YN
 ORDER BY C.DIVISION_ID, C.MEASURE, C.VALID_YN;

PROMPT ============================================================
PROMPT [2] 표기 정규화 시 몇 개로 합쳐지는가 (대소문자/공백 무시)
PROMPT     한 정규형에 원표기가 2개 이상이면 = 변형 누적. 오타는 정규화로도 안 합쳐진다.
PROMPT ============================================================
SELECT UPPER(REPLACE(MEASURE,' ','')) AS NORM
     , COUNT(DISTINCT MEASURE)        AS VARIANT_CNT
     , LISTAGG(DISTINCT MEASURE, ' | ') WITHIN GROUP (ORDER BY MEASURE) AS VARIANTS
  FROM DM_MST_CUSTOMER_FCST
 WHERE MEASURE_GROUP = 'CUST_FCST' AND VALID_YN = 'Y' AND NVL(MEASURE,'-') <> '-'
 GROUP BY UPPER(REPLACE(MEASURE,' ',''))
 ORDER BY 2 DESC, 1;

PROMPT ============================================================
PROMPT [3] ⭐⭐ 영향 사용자 — 화면에서 실제로 겹쳐 보이는 사람
PROMPT     PKG 의 measure 적재 3블록을 SQL 로 재현해 SORT_ORDER_NO 충돌을 찾는다.
PROMPT     (SP 호출 불필요 / 사용자 ID 불필요 / titleset 을 만들지 않는다)
PROMPT     EXPECT : 0행. 나오는 사용자 수 = 증상을 겪는 사람 수.
PROMPT ============================================================
WITH B1 AS (   /* 1단: 사용자 titleset 'M' x SHEET_MEASURE(VALID) */
  SELECT U.USER_ID, U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'B1_USER' AS SRC
    FROM SCM_MST_TITLESET_USER U
    JOIN SCM_MST_SHEET_MEASURE M
      ON  M.PROGRAM_ID  = U.PROGRAM_ID
      AND M.SHEET_NAME  = U.SHEET_NAME
      AND M.COLUMN_NAME = U.COLUMN_NAME
      AND M.VALID_YN    = 'Y'
   WHERE U.PROGRAM_ID = 'DMF0082'
     AND U.SHEET_NAME = 'FcstNPrice'
     AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
), SUBM AS (   /* 2단 후보: EDI 고정 8종 + DM_MST_CUSTOMER_FCST 데이터 기반 */
  SELECT MEASURE, MIN(SORT_NO) AS SORT_NO FROM (
     SELECT 'CUST_FCST_EDI' AS MEASURE, 0.11 AS SORT_NO FROM DUAL UNION ALL
     SELECT 'Backorder',0.12 FROM DUAL UNION ALL
     SELECT 'Commercial_Agreement',0.13 FROM DUAL UNION ALL
     SELECT 'Firm_Temp',0.14 FROM DUAL UNION ALL
     SELECT 'Immidiate',0.15 FROM DUAL UNION ALL
     SELECT 'Manumacturing_Material_Temp',0.16 FROM DUAL UNION ALL
     SELECT 'Material_Temp',0.17 FROM DUAL UNION ALL
     SELECT 'Planning_Forecast',0.18 FROM DUAL UNION ALL
     SELECT C.MEASURE, 0.10 FROM DM_MST_CUSTOMER_FCST C
      WHERE C.MEASURE_GROUP = 'CUST_FCST' AND NVL(C.MEASURE,'-') <> '-' AND C.VALID_YN = 'Y')
  GROUP BY MEASURE
), B2 AS (
  SELECT A.USER_ID, S.MEASURE, A.SORT_ORDER_NO + S.SORT_NO AS SORT_ORDER_NO, 'B2_CUSTSUB' AS SRC
    FROM (SELECT USER_ID, SORT_ORDER_NO FROM SCM_MST_TITLESET_USER
           WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
             AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND COLUMN_NAME = 'CUST_FCST') A
   CROSS JOIN SUBM S
   WHERE NOT EXISTS (SELECT 1 FROM B1 X WHERE X.USER_ID = A.USER_ID AND X.MEASURE = S.MEASURE)
), B3 AS (   /* 3단: 계산용 강제 포함 8종 (USER_ID='DM_ADMIN' 표식 — 최종 삭제 대상) */
  SELECT U.USER_ID, M.COLUMN_NAME AS MEASURE, M.SORT_ORDER_NO, 'B3_FORCED' AS SRC
    FROM (SELECT DISTINCT USER_ID FROM SCM_MST_TITLESET_USER
           WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
             AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M') U
   CROSS JOIN SCM_MST_SHEET_MEASURE M
   WHERE M.PROGRAM_ID = 'DMF0082' AND M.SHEET_NAME = 'FcstNPrice'
     AND M.COLUMN_NAME IN ('LOC','KRW','FCST_GAP','RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW','SCM_FCST','MKT_FCST')
     AND NOT EXISTS (SELECT 1 FROM B1 X WHERE X.USER_ID = U.USER_ID AND X.MEASURE = M.COLUMN_NAME)
     AND NOT EXISTS (SELECT 1 FROM B2 Y WHERE Y.USER_ID = U.USER_ID AND Y.MEASURE = M.COLUMN_NAME)
), ALLM AS (SELECT * FROM B1 UNION ALL SELECT * FROM B2 UNION ALL SELECT * FROM B3)
SELECT USER_ID
     , TO_CHAR(SORT_ORDER_NO) AS SORT_NO
     , COUNT(*)               AS OVERLAP_ROWS
     , LISTAGG(MEASURE || '[' || SRC || ']', ' | ') WITHIN GROUP (ORDER BY MEASURE) AS COLLIDING_MEASURES
  FROM ALLM
 GROUP BY USER_ID, SORT_ORDER_NO
HAVING COUNT(*) > 1
 ORDER BY 3 DESC, 1;

PROMPT ============================================================
PROMPT [4] 라벨 미등록 measure — 화면에 코드 그대로 노출되는 행
PROMPT     2단 블록이 승격시키는 이름 중 SHEET_MEASURE 에 없는 것 전부.
PROMPT     (EDI 고정 8종도 미등재면 라벨 없이 뜬다)
PROMPT ============================================================
SELECT S.MEASURE
     , CASE WHEN S.MEASURE IN ('CUST_FCST_EDI','Backorder','Commercial_Agreement','Firm_Temp'
                              ,'Immidiate','Manumacturing_Material_Temp','Material_Temp','Planning_Forecast')
            THEN 'PKG 고정 8종' ELSE 'DM_MST_CUSTOMER_FCST 데이터' END AS ORIGIN
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE M
                          WHERE M.PROGRAM_ID='DMF0082' AND M.SHEET_NAME='FcstNPrice'
                            AND M.COLUMN_NAME = S.MEASURE)
            THEN 'Y' ELSE '*** 미등재 ***' END AS IN_SHEET_MEASURE
  FROM (SELECT DISTINCT MEASURE FROM (
          SELECT 'CUST_FCST_EDI' AS MEASURE FROM DUAL UNION ALL
          SELECT 'Backorder' FROM DUAL UNION ALL SELECT 'Commercial_Agreement' FROM DUAL UNION ALL
          SELECT 'Firm_Temp' FROM DUAL UNION ALL SELECT 'Immidiate' FROM DUAL UNION ALL
          SELECT 'Manumacturing_Material_Temp' FROM DUAL UNION ALL SELECT 'Material_Temp' FROM DUAL UNION ALL
          SELECT 'Planning_Forecast' FROM DUAL UNION ALL
          SELECT C.MEASURE FROM DM_MST_CUSTOMER_FCST C
           WHERE C.MEASURE_GROUP='CUST_FCST' AND NVL(C.MEASURE,'-')<>'-' AND C.VALID_YN='Y')) S
 ORDER BY 3, 2, 1;

PROMPT
PROMPT ============================================================
PROMPT §판정
PROMPT   [1]/[2] 에 변형 2종 이상  -> 원인 확정. 보완은 §보완안 참조.
PROMPT   [3] 에 사용자가 나옴      -> 그 사용자들이 지금 화면에서 겹쳐 보고 있다.
PROMPT   [4] 의 미등재 목록        -> 라벨 없이 뜨는 행. SHEET_MEASURE 등재 필요 여부 판단.
PROMPT ============================================================
