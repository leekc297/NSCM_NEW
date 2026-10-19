--------------------------------------------------------------------------------
-- DMF0082 : SCM_FCST 메저를 81 계열 DIVISION 에서 사용 가능하도록 개방
--            [1/2] GET_ADMIN_GROUP_MEASURE 룩업 행 추가
-- 마커     : E20260902-81SCMFCST
-- 대상     : SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
--------------------------------------------------------------------------------
-- ⚠ 본 SQL 만으로는 화면에 SCM_FCST 가 나타나지 않는다. [2/2] 가 반드시 필요하다.
--    SCM_MST_SHEET_MEASURE / PROGRAM_ID='DMF0082' / SHEET_NAME='FcstNPrice'
--    / COLUMN_NAME='SCM_FCST' 의 DIVISION_ID 가 현재 '40' 뿐이라(2026-09-02 실측)
--    81 계열에서는 메저 목록에 뜨지도 않는다. 본 룩업은 "뜬 뒤의 편집권한" 축이다.
--
-- 전제 (사용자 확정 2026-09-02)
--   · AS-IS 에 없는 TO-BE 신규 기능 → AS-IS 파리티 요건 없음.
--     (실측: AS-IS SCM_ADM_LOOKUP_MASTER_DETAIL 의 GET_ADMIN_GROUP_MEASURE 98행 중
--      SEGMENT2='DMF0082' 는 SEGMENT3='40' 만 존재. 81 계열 0행)
--   · 권한그룹 = 40 패턴 준용 3그룹
--   · 요일/시간창 = 81 SCP Planner MKT_FCST 창과 동일
--
-- 룩업 컬럼 의미 (PKG_DMF0082 L3492~3517 · L3629~3640 실측)
--   SEGMENT1 = 권한그룹 / SEGMENT2 = PROGRAM_ID / SEGMENT3 = DIVISION_ID
--   SEGMENT4 = MEASURE  / SEGMENT5 = '-' (센티널)
--   ATTRIBUTE1 = 요일 토큰(콤마 다중, 'MON'/'TUE'…). 빈값 = 요일 제한 없음
--   ATTRIBUTE2 = FROM_TIME('HH24MI') / ATTRIBUTE3 = TO_TIME. 빈값 = 시간 제한 없음
--   ATTRIBUTE4 = 잠금 토큰 — ⚠ **의미가 둘 공존**한다 (L3644~3650 주석 + 실측)
--     (a) 메저명 해석 : L3629~3640. 활성 행의 A4 토큰과 이름이 같은 메저를 강제 'N'.
--                       실데이터 = DMF0082/SCM_FCST/A4='MKT_FCST' 3행(div40)
--     (b) 그룹명 해석 : L3651~3672. A4 가 같은 (S2,S3,S4) 의 SEGMENT1(그룹)과 매칭될 때만 발동.
--                       그 그룹의 시간창이 열려 있는 동안 내 메저를 'N'.
--                       실데이터 = DMF0082/MKT_FCST/A4='SCP Planner' 18행(81 계열)
--                                  DMF0003/MKT_FCST/A4='SCP Planner' 18행
--                                  DMF0021/RTF_SYS_RP/A4='RTF[R+P]' 18행
--     두 분기는 공존한다 — 토큰이 그룹명과 매칭되면 (b), 아니면 (b) 는 영향 0이고 (a) 만 작동.
--
-- ⭐ ATTRIBUTE4 를 NULL 로 두는 이유 (중요 — 40 값 복제 금지)
--   div40 의 SCM_FCST 3행이 가진 A4='MKT_FCST' 는 위 (a) 해석으로 작동한다:
--       UPDATE … SET EDIT_AUTH_YN='N' WHERE EXISTS(… A.MEASURE = B.LIMIT_MEASURE)
--   → "SCM_FCST 행이 창 안에 있는 동안 MKT_FCST 편집을 강제로 잠근다".
--   81 에 그대로 복제하면 화요일 창 시간대에 기존 81 MKT_FCST 편집이 잠기는 회귀가 난다.
--   81 계열 SCM_FCST 는 잠금 요건이 없으므로 NULL 로 둔다.
--
-- 회귀 영향 분석 (PKG_DMF0082 편집게이트 전 분기 실측 — 신규 행이 건드리는 곳 0)
--   L3605~3611 AS_In_Req 분기      : MEASURE='AS_In_Req'  한정 → 무관
--   L3613~3627 VMI_In_Req 분기     : MEASURE='VMI_In_Req' 한정 → 무관
--   L3629~3640 (a) 메저명 잠금     : 신규 행 A4=NULL → B.LIMIT_MEASURE IS NULL → 미발동
--   L3651~3672 (b) 그룹명 잠금     : L2.SEGMENT4 = B.MEASURE(=MKT_FCST) 로 조회하므로
--                                    SEGMENT4='SCM_FCST' 인 신규 행은 매칭 대상이 아님 → 미발동
--   L3576~3603 LOC 강제개방 분기   : MEASURE='LOC' 한정 → 무관
--
-- 참고 (신규 아님) : L3551~3555 는 SEGMENT3 필터 없이 GROUP BY SEGMENT4, ATTRIBUTE1 이라
--   SCM_FCST 가 A1='MON'(40) + A1='TUE'(81) 두 행으로 O_RC4 에 실린다.
--   MKT_FCST 가 이미 NULL/TUE 2행으로 동일하게 동작 중이므로 새로운 형태는 아니다.
--
-- ⭐ 시간창은 division 마다 다르다 (2026-09-02 실측 — 81 SCP Planner MKT_FCST 원본)
--     81=0411~1100 / 81_UC=1001~1145 / 81_ST=0406~1135
--     81_HD=1006~1150 / 81_HM=0401~1130 / 81_HG=1010~1140
--   "81 SCP 창과 동일" 을 division 별 창 준용으로 해석해 각 창을 그대로 미러링한다.
--   ▶ 6개 division 전부 81 기준(0411~1100)으로 통일하려면 아래 D 인라인뷰의
--     FROM_TIME/TO_TIME 을 모두 '0411'/'1100' 으로 바꾸면 된다 (그 외 수정 불필요).
--
-- 생성 행수 : 3 그룹 x 6 division = 18 행
-- 멱등성    : PK(LOOKUP_TYPE, SEGMENT1~SEGMENT5) 기준 MERGE — 재실행 안전
--             (PK 실측: PK_SCM_ADM_LOOKUP_MASTER_DETAI = 위 6컬럼)
-- 사전 실측 : 동일 키 기존재 0행 (SEGMENT2='DMF0082' AND SEGMENT4='SCM_FCST' AND SEGMENT3 LIKE '81%')
--------------------------------------------------------------------------------

MERGE INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (
    SELECT 'GET_ADMIN_GROUP_MEASURE' AS LOOKUP_TYPE
         , G.GRP                     AS SEGMENT1
         , 'DMF0082'                 AS SEGMENT2
         , D.DIV                     AS SEGMENT3
         , 'SCM_FCST'                AS SEGMENT4
         , '-'                       AS SEGMENT5
         , D.SEQ                     AS DISPLAY_SEQ
         , 'TUE'                     AS ATTRIBUTE1     -- 요일
         , D.FROM_TIME                AS ATTRIBUTE2     -- 시작 HH24MI
         , D.TO_TIME                  AS ATTRIBUTE3     -- 종료 HH24MI
      FROM ( SELECT '81'    AS DIV, 110 AS SEQ, '0411' AS FROM_TIME, '1100' AS TO_TIME FROM DUAL
             UNION ALL SELECT '81_UC', 120, '1001', '1145' FROM DUAL
             UNION ALL SELECT '81_ST', 130, '0406', '1135' FROM DUAL
             UNION ALL SELECT '81_HD', 140, '1006', '1150' FROM DUAL
             UNION ALL SELECT '81_HM', 150, '0401', '1130' FROM DUAL
             UNION ALL SELECT '81_HG', 160, '1010', '1140' FROM DUAL ) D
     CROSS JOIN
           ( SELECT 'ADMIN'        AS GRP FROM DUAL
             UNION ALL SELECT 'SCM PI Admin'       FROM DUAL
             UNION ALL SELECT 'SCP Planner'        FROM DUAL ) G
) S
ON ( T.LOOKUP_TYPE = S.LOOKUP_TYPE
 AND T.SEGMENT1    = S.SEGMENT1
 AND T.SEGMENT2    = S.SEGMENT2
 AND T.SEGMENT3    = S.SEGMENT3
 AND T.SEGMENT4    = S.SEGMENT4
 AND T.SEGMENT5    = S.SEGMENT5 )
WHEN MATCHED THEN UPDATE
   SET T.DISPLAY_SEQ      = S.DISPLAY_SEQ
     , T.VALID_YN         = 'Y'
     , T.ATTRIBUTE1       = S.ATTRIBUTE1
     , T.ATTRIBUTE2       = S.ATTRIBUTE2
     , T.ATTRIBUTE3       = S.ATTRIBUTE3
     , T.ATTRIBUTE4       = NULL
     , T.DESCRIPTION      = 'E20260902-81SCMFCST SCM_FCST 81 개방 (그룹=40 패턴 3그룹, 시간창=81 SCP Planner 창 준용, LIMIT_MEASURE 미설정)'
     , T.LAST_UPDATED_BY  = 'admin'
     , T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
   ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
   , DISPLAY_SEQ, VALID_YN, DESCRIPTION
   , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
   , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4 )
   VALUES
   ( S.LOOKUP_TYPE, S.SEGMENT1, S.SEGMENT2, S.SEGMENT3, S.SEGMENT4, S.SEGMENT5
   , S.DISPLAY_SEQ, 'Y'
   , 'E20260902-81SCMFCST SCM_FCST 81 개방 (그룹=40 패턴 3그룹, 시간창=81 SCP Planner 창 준용, LIMIT_MEASURE 미설정)'
   , 'admin', SYSDATE, 'admin', SYSDATE
   , S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, NULL );

COMMIT;

--------------------------------------------------------------------------------
-- 검증 ①  적재 결과 = 18행, 전부 TUE/창 보유/ATTRIBUTE4 NULL 이어야 한다
--------------------------------------------------------------------------------
SELECT SEGMENT3 AS DIV, SEGMENT1 AS GRP, SEGMENT4 AS MEASURE
     , ATTRIBUTE1 AS 요일, ATTRIBUTE2 AS FROM_T, ATTRIBUTE3 AS TO_T
     , ATTRIBUTE4 AS LIMIT_MEAS, DISPLAY_SEQ, VALID_YN, CREATED_BY
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
   AND SEGMENT2    = 'DMF0082'
   AND SEGMENT4    = 'SCM_FCST'
   AND SEGMENT3 LIKE '81%'
 ORDER BY SEGMENT3, SEGMENT1;

--------------------------------------------------------------------------------
-- 검증 ②  DMF0082 매트릭스 — 81 계열 각 division 에 SCM_FCST 가 붙었는지
--------------------------------------------------------------------------------
SELECT SEGMENT1 AS GRP, SEGMENT3 AS DIV
     , LISTAGG(SEGMENT4, ', ') WITHIN GROUP (ORDER BY SEGMENT4) AS MEASURES
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
   AND SEGMENT2    = 'DMF0082'
   AND VALID_YN    = 'Y'
 GROUP BY SEGMENT1, SEGMENT3
 ORDER BY SEGMENT1, SEGMENT3;

--------------------------------------------------------------------------------
-- 검증 ③  회귀 가드 A — 신규 SCM_FCST 행에 잠금 토큰이 붙지 않았는가
--          ⚠ 반드시 SEGMENT4='SCM_FCST' 로 좁힐 것. 조건 없이 "81 계열 A4 IS NOT NULL"
--            로 보면 정상 행인 MKT_FCST/A4='SCP Planner' 18행이 오탐으로 잡힌다(2026-09-02 실측).
--          기대: 0행. 1행이라도 나오면 화요일 창에 81 MKT_FCST 가 잠긴다.
--------------------------------------------------------------------------------
SELECT SEGMENT1, SEGMENT3, SEGMENT4, ATTRIBUTE4
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
   AND SEGMENT2    = 'DMF0082'
   AND SEGMENT3 LIKE '81%'
   AND SEGMENT4    = 'SCM_FCST'
   AND ATTRIBUTE4 IS NOT NULL;

--------------------------------------------------------------------------------
-- 검증 ④  회귀 가드 B — 기존 그룹잠금(MKT_FCST / A4='SCP Planner') 행이 보존되었는가
--          기대: 적재 전과 동일한 18행 (DM ADMIN·DM Planner·DM Planner (W/S) x 6 division)
--------------------------------------------------------------------------------
SELECT COUNT(*) AS 그룹잠금행수
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
   AND SEGMENT2    = 'DMF0082'
   AND SEGMENT3 LIKE '81%'
   AND SEGMENT4    = 'MKT_FCST'
   AND ATTRIBUTE4  = 'SCP Planner';

--------------------------------------------------------------------------------
-- 검증 ⑤  [2/2] 미적용 확인 — 메저 마스터가 아직 81 을 포함하지 않으면 화면에 안 뜬다
--          기대(본 SQL 만 적용한 시점): DIVISION_ID = '40'
--------------------------------------------------------------------------------
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VALID_YN
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0082' AND COLUMN_NAME = 'SCM_FCST';

--------------------------------------------------------------------------------
-- 원복 (필요 시)
--------------------------------------------------------------------------------
-- DELETE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
--  WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
--    AND SEGMENT2    = 'DMF0082'
--    AND SEGMENT4    = 'SCM_FCST'
--    AND SEGMENT3 LIKE '81%'
--    AND DESCRIPTION LIKE 'E20260902-81SCMFCST%';
-- COMMIT;
