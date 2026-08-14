--------------------------------------------------------------------------------------------------
-- [E20260814-CURMEASURE] No.41 후속 — 81 계열 SCM_FCST 편집권한 등재 (사용자 결정 2026-08-14)
-- [E20260814-ENDCUST]    No.64      — End Customer 셀 콤보 division 상별화 (사용자 결정 2026-08-14)
--------------------------------------------------------------------------------------------------

/* (D) 81 계열 SCM_FCST grant — 40 그룹셋(ADMIN / SCM PI Admin / SCP Planner) 준용.
       ⚠ 40 의 SCM_FCST 행이 갖는 ATTRIBUTE1~3(요일·시간창)·ATTRIBUTE4(LIMIT_MEASURE='MKT_FCST')는
         **복제하지 않는다**. 그 두 값은 소형(40)의 "월요일 Timeline 단축" 운영규칙 전용이고,
         복제하면 SAVE SP §1 [E20250912-001720] 검증이 걸려 **해당 요일에 81 의 MKT_FCST 가 잠긴다**.
         81 에는 그 운영규칙의 AS-IS 근거가 없으므로 상시 허용(요일 제한 없음)으로 등재한다.
       ⚠ 82 는 대상 아님 — DM_UI_EDITABLE_MEASURE 에 82 SCM_FCST 가 없다(AS-IS·TO-BE 공통).
       편집대상 등재(DM_UI_EDITABLE_MEASURE / DMF0082 × 81 계열 × SCM_FCST)는 이미 존재(AJS 2026-07-14). */
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
  , DISPLAY_SEQ, VALID_YN, DESCRIPTION
  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT 'GET_ADMIN_GROUP_MEASURE', G.GRP, 'DMF0082', D.DIV, 'SCM_FCST', '-'
     , 5, 'Y', '[E20260814-CURMEASURE] No.41 — 81 계열 SCM_FCST 편집권한(사용자 결정). 40 의 요일창·LIMIT_MEASURE 는 미복제'
     , 'admin', SYSDATE, 'admin', SYSDATE
FROM (SELECT '81' DIV FROM DUAL UNION ALL SELECT '81_HD' FROM DUAL
      UNION ALL SELECT '81_HG' FROM DUAL UNION ALL SELECT '81_HM' FROM DUAL
      UNION ALL SELECT '81_ST' FROM DUAL UNION ALL SELECT '81_UC' FROM DUAL) D
CROSS JOIN (SELECT 'ADMIN' GRP FROM DUAL UNION ALL SELECT 'SCM PI Admin' FROM DUAL
            UNION ALL SELECT 'SCP Planner' FROM DUAL) G
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
    WHERE  X.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND X.SEGMENT1=G.GRP
    AND    X.SEGMENT2='DMF0082' AND X.SEGMENT3=D.DIV AND X.SEGMENT4='SCM_FCST' );

/* (E) End Customer 셀 콤보 — division 상별 등재본 신규.
       AS-IS/TO-BE 실측: 메타 `FcstNPrice.END_CUSTOMER` 가 `EndCustomerByDivision40` 을 물고 있고
       그 SQL 은 `A.DIVISION_ID='40'` · `SEGMENT1='40'` 로 **40 하드코딩** →
       81 로 조회해도 40 목록(AJ상사 등)이 그대로 노출 = 요구 No.64 의 직접 원인.
       요구 원문 : "END_CUSTOMER 룩업코드 기준으로 Div별 리스트를 구성할 수 있도록 수정 필요".
       사내 실측 END_CUSTOMER 룩업 = 1,730행 (40:951 / 81:219 / 81_HG:222 / 82:319 / 81_ST:9 / 81_HM:6 / 81_HD:2 / 81_UC:1).

       ① 룩업 축   : 요구 원문 그대로 SEGMENT1(=division) 상별.
       ② SITE_ITEM 축 : AS-IS EndCustomerByDivision40 의 owner→부서 조인 원문 유지(division 전달 시에만).
       @divisionId 미전달 = 메타 표시 경로 → 전 division 합집합(CODE→NAME 매핑 보존, 편집 후보 ⊊ 표시 후보 규약). */
MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M T
USING (SELECT 'EndCustomerByDivisionDMF0082' AS SQL_ID FROM DUAL) S
ON (T.SQL_ID = S.SQL_ID)
WHEN NOT MATCHED THEN INSERT
  ( SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN
  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
VALUES
  ( 'EndCustomerByDivisionDMF0082', 'DM'
  /* SQL_NM = VARCHAR2(100) — 한글 장문 금지(2026-08-14 ORA-12899 실패 이력) */
  , 'DMF0082 End Customer by division (END_CUSTOMER lookup)'
  ,
'SELECT DISTINCT CODE, NAME FROM (
  /* [E20260814-ENDCUST] No.64 — ① END_CUSTOMER 룩업 축 (division 상별) */
  SELECT L.SEGMENT2 AS CODE, L.SEGMENT3 AS NAME
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = ''END_CUSTOMER''
  AND    L.VALID_YN = ''Y''
  AND    L.SEGMENT2 <> ''-''
  AND    ( NVL(TRIM(@divisionId), ''-'') = ''-'' OR L.SEGMENT1 = TRIM(@divisionId) )
  UNION ALL
  /* ② SITE_ITEM owner→부서 축 (AS-IS EndCustomerByDivision40 원문) — division 전달 시에만 */
  SELECT A.PROJECT_CODE AS CODE, NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
  FROM   SCM_MGR.SCM_MST_SITE_ITEM A
  JOIN   SCM_MGR.SCM_MST_SSO_USER_INFO B ON B.USER_ID = TRIM(REGEXP_SUBSTR(A.OWNER, ''[^,]+'', 1, 1))
  JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON C.DEPT_ID = B.DEPT_ID
  LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
         ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2
        AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''
  WHERE  A.VALID_YN = ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') <> ''-''
  AND    A.DIVISION_ID = TRIM(@divisionId)
) ORDER BY NAME'
  , 'Y', 'admin', SYSDATE, 'admin', SYSDATE );

/* (F) 메타 재배선 — 메인 그리드 표시용 셀 콤보를 40 고정본에서 division 상별본으로 교체.
       (@divisionId 미전달 = 전 division 합집합이라 81/82 행의 CODE→NAME 매핑이 처음으로 성립한다.
        편집 진입 시 division 한정 목록으로의 스왑은 FE GRID_EDIT_COMBO 가 담당.) */
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    CELL_COMBO_DATA_TYPE = 'EndCustomerByDivisionDMF0082'
     , LAST_UPDATED_BY = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID = 'DMF0082'
AND    SHEET_NAME = 'FcstNPrice'
AND    COLUMN_NAME = 'END_CUSTOMER'
AND    CELL_COMBO_DATA_TYPE = 'EndCustomerByDivision40';

COMMIT;
