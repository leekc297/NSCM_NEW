--------------------------------------------------------------------------------
-- DMF0082 : SCM_FCST 메저를 81 계열 DIVISION 에서 사용 가능하도록 개방
--            [2/2] DM_UI_EDITABLE_MEASURE 룩업 행 추가 (셀 편집 게이트)
-- 마커     : E20260902-81SCMFCST
-- 대상     : SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
-- 지시     : "81 DIVISION 전체에 SCM_FCST 행 추가. 다른 조건은 40 을 복사해서 동일하게"
--            (사용자 2026-09-02) → SEGMENT2(DIVISION)만 바꾸고 **나머지 전 컬럼은 40 행 그대로 복제**.
--------------------------------------------------------------------------------
-- 왜 이 축이 별도로 필요한가 (2026-09-02 기계 스윕으로 발견 — 손나열이었으면 놓쳤을 축)
--   DMF0082 를 참조하는 LOOKUP_TYPE 전수 = DM_UI_EDITABLE_MEASURE / GET_ADMIN_GROUP_MEASURE
--   / MENU_AUTH_BY_DIVISION 3종. 메저 개방에는 앞의 2종이 모두 필요하다.
--     · GET_ADMIN_GROUP_MEASURE  = "어느 권한그룹이 언제(요일·시간창) 편집 가능한가"  → 01_ 파일
--     · DM_UI_EDITABLE_MEASURE   = "그 메저 셀이 애초에 편집 대상인가(EDIT_YN)"        → 본 파일
--   둘 중 하나라도 없으면 화면에서 편집이 열리지 않는다.
--
-- 컬럼 의미 (PKG_DMF0082 실측 — 추정 아님)
--   SEGMENT1   = PROGRAM_ID ('DMF0082')            L9000 · L14850 · L5413
--   SEGMENT2   = DIVISION_ID                        L8997
--   SEGMENT3   = MEASURE (코드)                     L8998
--   SEGMENT4   = MEASURE 표시명                     L14687 "Measure = DM_UI_EDITABLE_MEASURE SEGMENT4(표시명)"
--   SEGMENT5   = '-' (센티널)
--   ATTRIBUTE1 = INSERT_YN — 행 신규입력/엑셀양식 후보 메저 여부   L14853 · L5415 주석 "INSERT_YN"
--   ATTRIBUTE2 = EDIT_YN   — 셀 편집 가능 여부 ⭐ 본 개방의 핵심   L9001 주석 "EDIT_YN 여부"
--   ATTRIBUTE3 = VMI_COND  — VMI 사이트 조건('ALL' | 'Y')          L14843 · L5419
--
-- 복제 원본 (div40 실측 2026-09-02)
--   DMF0082 | 40 | SCM_FCST | SEGMENT4='SCM_FCST' | A1='N' | A2='Y' | A3='ALL'
--                | DISPLAY_SEQ=402 | VALID_YN='Y' | DESCRIPTION='SCM_FCST'
--   → A1='N' : SCM_FCST 는 40 에서도 Insert 후보가 아니다(엑셀양식·행 신규입력 후보에서 제외).
--   → A2='Y' : 셀 편집 개방 — 본 요구의 실체.
--   → A3='ALL': VMI 사이트 조건 없음.
--
-- ⚠ 40 복사이므로 그대로 따라오는 것 2가지 (지시대로 유지 — 임의 개선하지 않음)
--   ① SEGMENT4='SCM_FCST' : 40 행은 표시명 자리에 코드가 들어가 있다. 81 의 다른 메저들은
--      정상 라벨('MKT FCST[R+P]','Unit Price(LOC)')을 쓰므로 관례상 'SCM FCST[R+P]' 가 맞지만,
--      "40 을 복사" 지시에 따라 40 값을 그대로 쓴다.
--      소비처 L14842(엑셀양식 MEASURE_NAME)는 현재 SEGMENT3='LOC' 한정(L14854)이라 미소비.
--   ② DISPLAY_SEQ=402 : 81 계열에서 LOC 가 이미 402 라 번호가 겹친다. SP 로직은 DISPLAY_SEQ 를
--      소비하지 않으며(L14844 는 ROW_NUMBER() ORDER BY SEGMENT3) 관리화면 정렬용이라 무해하다.
--      (40 에서도 LOC=402 / SCM_FCST=402 로 이미 겹쳐 있는 상태 = 40 원본과 동일한 형태)
--
-- 구현 방식 : 리터럴 하드코딩이 아니라 **40 행 자체를 SELECT 해서 SEGMENT2 만 치환**한다.
--             ATTRIBUTE1~15 를 포함한 전 컬럼이 자동으로 40 과 일치하며, 40 이 바뀌면
--             재실행만으로 81 이 따라간다. (메타값 권위소스 파생 원칙)
--             ⚠ 40 행이 없으면 USING 이 0행 → 아무것도 적재되지 않는다(잘못된 값 삽입 대신 무동작).
--                검증 ①이 0행이면 40 원본 부재를 의심할 것.
--
-- 선행 조건
--   · SCM_MST_SHEET_MEASURE 의 SCM_FCST DIVISION_ID 에 81 계열 포함
--     (사내 2026-09-02 17:46 적용 완료 — minyonglee1 / 클라우드는 00_ 파일 필요)
--   · 01_GET_ADMIN_GROUP_MEASURE_SCM_FCST_81.sql 적용
--
-- SP 변경 : 불필요
--   PKG_DMF0082 의 SCM_FCST LIVE 리터럴 35건을 전수 확인한 결과 전부 메저코드 기반이며
--   division 분기가 없다(L3000·L3021·L3341·L7968·L9077·L12297·L12856·L12912·L13075·L13212·
--   L14110·L14175·L14364·L14513 …). 메저 강제포함(L1136~1146)·FCST_GAP 파생(L7686~7697) 도
--   SCM_MST_SHEET_MEASURE 구동이라 division 필터가 없다. ⇒ 메타만으로 개방된다.
--
-- 생성 행수 : 6 division x 1 메저 = 6 행
-- 멱등성    : PK(LOOKUP_TYPE, SEGMENT1~SEGMENT5) 기준 MERGE — 재실행 안전
-- 사전 실측 : 동일 키 기존재 0행
--------------------------------------------------------------------------------

MERGE INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (
    SELECT SRC.LOOKUP_TYPE
         , SRC.SEGMENT1
         , D.DIV            AS SEGMENT2      -- ⭐ DIVISION 만 치환
         , SRC.SEGMENT3
         , SRC.SEGMENT4
         , SRC.SEGMENT5
         , SRC.DISPLAY_SEQ
         , SRC.VALID_YN
         , SRC.ATTRIBUTE1,  SRC.ATTRIBUTE2,  SRC.ATTRIBUTE3,  SRC.ATTRIBUTE4,  SRC.ATTRIBUTE5
         , SRC.ATTRIBUTE6,  SRC.ATTRIBUTE7,  SRC.ATTRIBUTE8,  SRC.ATTRIBUTE9,  SRC.ATTRIBUTE10
         , SRC.ATTRIBUTE11, SRC.ATTRIBUTE12, SRC.ATTRIBUTE13, SRC.ATTRIBUTE14, SRC.ATTRIBUTE15
      FROM ( SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
              WHERE LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
                AND SEGMENT1    = 'DMF0082'
                AND SEGMENT2    = '40'          -- 복제 원본 = div40 행
                AND SEGMENT3    = 'SCM_FCST' ) SRC
     CROSS JOIN
           ( SELECT '81'    AS DIV FROM DUAL
             UNION ALL SELECT '81_UC' FROM DUAL
             UNION ALL SELECT '81_ST' FROM DUAL
             UNION ALL SELECT '81_HD' FROM DUAL
             UNION ALL SELECT '81_HM' FROM DUAL
             UNION ALL SELECT '81_HG' FROM DUAL ) D
) S
ON ( T.LOOKUP_TYPE = S.LOOKUP_TYPE
 AND T.SEGMENT1    = S.SEGMENT1
 AND T.SEGMENT2    = S.SEGMENT2
 AND T.SEGMENT3    = S.SEGMENT3
 AND T.SEGMENT4    = S.SEGMENT4
 AND T.SEGMENT5    = S.SEGMENT5 )
WHEN MATCHED THEN UPDATE
   SET T.DISPLAY_SEQ      = S.DISPLAY_SEQ
     , T.VALID_YN         = S.VALID_YN
     , T.ATTRIBUTE1       = S.ATTRIBUTE1
     , T.ATTRIBUTE2       = S.ATTRIBUTE2
     , T.ATTRIBUTE3       = S.ATTRIBUTE3
     , T.ATTRIBUTE4       = S.ATTRIBUTE4
     , T.ATTRIBUTE5       = S.ATTRIBUTE5
     , T.DESCRIPTION      = 'E20260902-81SCMFCST SCM_FCST 81 편집 개방 (div40 행 전 컬럼 복제)'
     , T.LAST_UPDATED_BY  = 'admin'
     , T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
   ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
   , DISPLAY_SEQ, VALID_YN, DESCRIPTION
   , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
   , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
   , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
   , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15 )
   VALUES
   ( S.LOOKUP_TYPE, S.SEGMENT1, S.SEGMENT2, S.SEGMENT3, S.SEGMENT4, S.SEGMENT5
   , S.DISPLAY_SEQ, S.VALID_YN
   , 'E20260902-81SCMFCST SCM_FCST 81 편집 개방 (div40 행 전 컬럼 복제)'
   , 'admin', SYSDATE, 'admin', SYSDATE
   , S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5
   , S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8, S.ATTRIBUTE9, S.ATTRIBUTE10
   , S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15 );

COMMIT;

--------------------------------------------------------------------------------
-- 검증 ①  적재 결과 = 6행. 0행이면 복제 원본(div40 SCM_FCST) 부재를 의심할 것
--------------------------------------------------------------------------------
SELECT SEGMENT2 AS DIV, SEGMENT3 AS MEASURE, SEGMENT4 AS 표시명
     , ATTRIBUTE1 AS INSERT_YN, ATTRIBUTE2 AS EDIT_YN, ATTRIBUTE3 AS VMI_COND
     , DISPLAY_SEQ, VALID_YN, CREATED_BY
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
   AND SEGMENT1    = 'DMF0082'
   AND SEGMENT3    = 'SCM_FCST'
   AND SEGMENT2 LIKE '81%'
 ORDER BY SEGMENT2;

--------------------------------------------------------------------------------
-- 검증 ②  ⭐ 40 과 완전 동일한지 컬럼 단위 대조 (DIVISION·감사컬럼·DESCRIPTION 제외)
--          기대: 0행 (차이 없음)
--------------------------------------------------------------------------------
SELECT '81 계열이 40 과 다름' AS 판정, X.*
  FROM ( SELECT SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN
              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
           FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082'
            AND SEGMENT3='SCM_FCST' AND SEGMENT2 LIKE '81%' ) X
 WHERE (X.SEGMENT4, X.SEGMENT5, X.DISPLAY_SEQ, X.VALID_YN
      , NVL(X.ATTRIBUTE1,'~'), NVL(X.ATTRIBUTE2,'~'), NVL(X.ATTRIBUTE3,'~')
      , NVL(X.ATTRIBUTE4,'~'), NVL(X.ATTRIBUTE5,'~'))
       NOT IN ( SELECT SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN
                     , NVL(ATTRIBUTE1,'~'), NVL(ATTRIBUTE2,'~'), NVL(ATTRIBUTE3,'~')
                     , NVL(ATTRIBUTE4,'~'), NVL(ATTRIBUTE5,'~')
                  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082'
                   AND SEGMENT2='40' AND SEGMENT3='SCM_FCST' );

--------------------------------------------------------------------------------
-- 검증 ③  ⭐ 3축 커버리지 매트릭스 — 81 계열 6 division 이 3축 모두 충족하는가
--          기대: 메저마스터=Y / 권한룩업=3 / 편집룩업=1  (6행 전부)
--------------------------------------------------------------------------------
WITH DIVS AS (SELECT COLUMN_VALUE DIV
                FROM TABLE(SYS.ODCIVARCHAR2LIST('81','81_UC','81_ST','81_HD','81_HM','81_HG')))
SELECT D.DIV
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_MEASURE S
                          WHERE S.PROGRAM_ID='DMF0082' AND S.COLUMN_NAME='SCM_FCST'
                            AND S.VALID_YN='Y'
                            AND ','||S.DIVISION_ID||',' LIKE '%,'||D.DIV||',%')
            THEN 'Y' ELSE 'N(누락)' END                                    AS 메저마스터
     , (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND L.SEGMENT2='DMF0082'
           AND L.SEGMENT3=D.DIV AND L.SEGMENT4='SCM_FCST' AND L.VALID_YN='Y') AS 권한룩업
     , (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND L.SEGMENT1='DMF0082'
           AND L.SEGMENT2=D.DIV AND L.SEGMENT3='SCM_FCST' AND L.VALID_YN='Y') AS 편집룩업
  FROM DIVS D ORDER BY D.DIV;

--------------------------------------------------------------------------------
-- 검증 ④  회귀 가드 — 기존 81 편집룩업 행이 보존되었는가
--          기대: 적재 전 16행(81 계열) + 신규 6행 = 22행
--------------------------------------------------------------------------------
SELECT SEGMENT2 AS DIV, SEGMENT3 AS MEASURE, ATTRIBUTE1 AS INS, ATTRIBUTE2 AS EDT, ATTRIBUTE3 AS VMI
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
   AND SEGMENT1    = 'DMF0082'
   AND SEGMENT2 LIKE '81%'
 ORDER BY SEGMENT2, SEGMENT3;

--------------------------------------------------------------------------------
-- 원복 (필요 시)
--------------------------------------------------------------------------------
-- DELETE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
--  WHERE LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
--    AND SEGMENT1    = 'DMF0082'
--    AND SEGMENT3    = 'SCM_FCST'
--    AND SEGMENT2 LIKE '81%'
--    AND DESCRIPTION LIKE 'E20260902-81SCMFCST%';
-- COMMIT;
