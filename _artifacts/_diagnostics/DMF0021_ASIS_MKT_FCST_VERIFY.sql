--------------------------------------------------------------------------------
-- DMF0021 AS-IS 검증 쿼리 — 특정 키의 MKT FCST[R+P] 미출력 사유 추적
--------------------------------------------------------------------------------
-- 실행 대상 : **클라우드 AS-IS DB (MS-SQL)** — TO-BE(Oracle) 아님
-- 목적      : AS-IS 1,820 vs TO-BE 1,887 (+67) 중 아래 1건이 AS-IS 에만 없는 사유 규명
--
--   Div 40 / Sales Site BYD Electronics_CN_SZX / Model MCSS56831-A1 (Nick X3832)
--   Incoterms DAP / FCST Type Mass / Currency USD / Cell Prod Site 남경A(=NJ01-A)
--   Measure  MKT FCST[R+P]  ← TO-BE 에만 존재
--   값       2027-01 = 1,069,000 / 2027-02 = 748,000  (그 외 기간 0)
--
-- ⭐ 왜 이 추적인가 (AS-IS SP 원문 실측 — DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx)
--   MKT_FCST_RP 는 원천에서 바로 읽는 메저가 아니라 **두 조각의 합성**이다 (L1071~1137):
--     · 과거구간 : #RAW_DATA 의 MEASURE='RTF_SYS_RP'  (YYYYMMDD <  경계)
--     · 미래구간 : #RAW_DATA 의 MEASURE='MKT_FCST'    (YYYYMMDD >= 경계, <= @p_to)
--   경계 = CASE WHEN VERSION_NO='CURRENT' THEN @p_now_yyyymmdd
--               ELSE CONVERT(CHAR(8), DATEADD(DD,-7, dbo.FN_NEXT_DAY(CUTOFF_YYYYMMDD,'MON')),112) END
--   문제 행은 값이 **2027-01·02(미래)에만** 있으므로 → **미래구간 = MKT_FCST 조각**이다.
--   ⇒ 따라서 "AS-IS 에 MKT_FCST 원천행이 있는가 / 있는데 어느 필터에서 걸리는가" 를 순서대로 본다.
--
-- 사용법 : ▼ 조회조건 변수를 화면과 동일하게 맞춘 뒤 §0 부터 순서대로 실행.
--          각 절 끝의 "판정" 주석대로 0건이 나오는 지점이 곧 원인이다.
--------------------------------------------------------------------------------

SET NOCOUNT ON;

------------------------------ 조회조건 (화면과 동일하게) ------------------------------
DECLARE @p_division_id   NVARCHAR(30)  = N'40';
DECLARE @p_from_yyyymmdd NVARCHAR(8)   = N'20260817';
DECLARE @p_to_yyyymmdd   NVARCHAR(8)   = N'20270228';
DECLARE @p_created_by    NVARCHAR(300) = N'jaeuk.shin';   -- 조회 계정
-- @p_now_yyyymmdd 는 화면이 계산해 넘긴다. 화면과 다르면 미래/과거 경계가 어긋나 결과가 달라진다.
DECLARE @p_now_yyyymmdd  NVARCHAR(8)   = N'20260901';

------------------------------ 추적 대상 키 ------------------------------
DECLARE @k_item      NVARCHAR(100) = N'MCSS56831-A1';
DECLARE @k_site      NVARCHAR(100) = N'BYD Electronics_CN_SZX';
DECLARE @k_incoterms NVARCHAR(30)  = N'DAP';
DECLARE @k_fcsttype  NVARCHAR(60)  = N'Mass';
DECLARE @k_currency  NVARCHAR(10)  = N'USD';


PRINT '===== §0 파라미터 확인 =====';
SELECT @p_division_id AS DIVISION, @p_from_yyyymmdd AS FROM_YMD,
       @p_now_yyyymmdd AS NOW_YMD, @p_to_yyyymmdd AS TO_YMD, @p_created_by AS CREATED_BY;
-- 판정: @p_now_yyyymmdd 가 화면 값과 같아야 한다. 다르면 아래 결과 전체가 무의미.


PRINT '===== §1 titleset — MKT_FCST 가 조회 대상에 들어가는가 =====';
-- MKT_FCST_RP 를 고르면 SP 가 MKT_FCST 와 RTF_SYS_RP 를 SYSTEM_ADD='Y' 로 자동 추가한다(L741~759).
-- 즉 사용자가 MKT_FCST 를 직접 고르지 않아도 미래구간 재료로 쓰인다.
SELECT COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
 WHERE PROGRAM_ID = 'DMF0021'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
   AND USER_ID = @p_created_by
 ORDER BY SORT_ORDER_NO;
-- 판정: MKT_FCST_RP 가 있으면 MKT_FCST 는 자동 확보된다(직접 선택 불필요).


PRINT '===== §2 메저 마스터 — MKT_FCST 가 이 division 에서 유효한가 =====';
-- SP 는 VALID_YN='Y' + DIVISION_ID 목록 매칭 행만 쓴다(L619~689).
SELECT COLUMN_NAME, DIVISION_ID, VALID_YN, DEFAULT_FLAG, SORT_ORDER_NO
  FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
 WHERE PROGRAM_ID = 'DMF0021'
   AND COLUMN_NAME IN ('MKT_FCST', 'MKT_FCST_RP', 'RTF_SYS_RP')
 ORDER BY SORT_ORDER_NO;
-- 판정: MKT_FCST 가 VALID_YN='Y' 이고 DIVISION_ID 에 40 이 포함돼야 한다.


PRINT '===== §3 ⭐ 원천 데이터 — DM_PLN_SALES_PLAN 에 MKT_FCST 가 있는가 (필터 전) =====';
-- 미래구간 원천 arm = FROM DM_PLN_SALES_PLAN (L919~991), PLAN_RESULT='P'
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.CURRENCY, A.FCST_TYPE, A.INCOTERMS,
       A.SCM_SITE_ID, A.PROJECT_CODE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.DOM_EXP
  FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
 WHERE A.DIVISION_ID = @p_division_id
   AND A.ITEM_ID     = @k_item
   AND A.SCM_SITE_ID = @k_site
   AND A.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
   AND A.MEASURE IN ('MKT_FCST', 'MKT_FCST_RP', 'RTF_SYS_RP')
 ORDER BY A.MEASURE, A.YYYYMMDD;
-- 판정: 여기서 MKT_FCST 가 **0건** 이면 → 원천 데이터 부재. AS-IS 가 안 만드는 게 정상이고,
--       TO-BE 쪽에 그 데이터가 어디서 왔는지를 되짚어야 한다(원천 적재 경로 차이).
--       행이 있으면 §4~§6 의 필터 중 하나가 걸러낸 것이다.


PRINT '===== §3-1 기간 경계 판정 (미래구간에 들어오는가) =====';
SELECT A.MEASURE, A.YYYYMMDD, A.QTY,
       CASE WHEN A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
            THEN 'IN  (미래구간 — MKT_FCST_RP 재료)'
            WHEN A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD < @p_now_yyyymmdd
            THEN 'PAST(과거구간 — RTF_SYS_RP 재료)'
            ELSE 'OUT (조회기간 밖)' END AS 구간판정
  FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
 WHERE A.DIVISION_ID = @p_division_id
   AND A.ITEM_ID     = @k_item
   AND A.SCM_SITE_ID = @k_site
   AND A.MEASURE     = 'MKT_FCST'
 ORDER BY A.YYYYMMDD;
-- 판정: 2027-01·02 행이 'IN' 이어야 MKT_FCST_RP 미래구간이 만들어진다.


PRINT '===== §4 SITE 마스터 조인 (INNER JOIN — 불일치 시 전멸) =====';
-- L953~959 : JOIN SCM_MST_SITE ON DIVISION_ID, SCM_SITE_ID AND VALID_YN='Y'
SELECT C.DIVISION_ID, C.SCM_SITE_ID, C.VALID_YN, C.END_CUSTOMER
  FROM SCM_MST_SITE C WITH(NOLOCK)
 WHERE C.DIVISION_ID = @p_division_id
   AND C.SCM_SITE_ID = @k_site;
-- 판정: 행이 없거나 VALID_YN <> 'Y' 이면 **이 사이트의 모든 메저가 통째로 탈락**한다.
--       (그런데 같은 키의 RTF[R+P] 는 AS-IS 에 있으므로, 이 절은 통과일 가능성이 높다)


PRINT '===== §5 제외 룩업 1 — FCST_TYPE / ITEM_ID 배제 목록 =====';
-- L971~985 : DM_SALES_PLAN_WATERFALL_SP_W_ADD 의 SEGMENT2(FCST_TYPE)·SEGMENT3(ITEM_ID) 는 제외된다
SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS EXCL_FCST_TYPE, SEGMENT3 AS EXCL_ITEM_ID, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
   AND VALID_YN = 'Y'
   AND SEGMENT1 = @p_division_id
   AND (SEGMENT2 = @k_fcsttype OR SEGMENT3 = @k_item);
-- 판정: 행이 나오면 그 사유로 제외된 것이다(FCST_TYPE 또는 ITEM_ID 배제).


PRINT '===== §6 제외 룩업 2 — CATCHUP 메저 배제 =====';
-- L987~991 : SALES_PLAN_CATCHUP 의 SEGMENT2 에 해당하는 MEASURE 는 제외된다
SELECT SEGMENT1, SEGMENT2 AS EXCL_MEASURE, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
 WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
   AND VALID_YN = 'Y';
-- 판정: 목록에 MKT_FCST 가 있으면 제외 대상이다.


PRINT '===== §7 QTY<>0 조건 =====';
-- L967 : (( MEASURE <> ''RTF_SYS_RP'' AND QTY <> 0 ) OR ( MEASURE = ''RTF_SYS_RP'' ))
--        → MKT_FCST 는 **QTY = 0 이면 적재되지 않는다**
SELECT A.YYYYMMDD, A.QTY,
       CASE WHEN A.QTY <> 0 THEN 'OK' ELSE '⛔ QTY=0 → 적재 제외' END AS 판정
  FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
 WHERE A.DIVISION_ID = @p_division_id
   AND A.ITEM_ID     = @k_item
   AND A.SCM_SITE_ID = @k_site
   AND A.MEASURE     = 'MKT_FCST'
   AND A.YYYYMMDD BETWEEN @p_now_yyyymmdd AND @p_to_yyyymmdd
 ORDER BY A.YYYYMMDD;


PRINT '===== §8 종합 — 전 필터를 그대로 적용한 최종 재현 =====';
-- AS-IS L919~991 의 미래구간 arm 을 이 키에 한정해 그대로 재현한다.
-- 결과가 0건이면 AS-IS 가 MKT_FCST_RP 를 못 만드는 것이 **정상 동작**이라는 뜻이다.
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.CURRENCY, A.FCST_TYPE,
       ISNULL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
  FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
  JOIN SCM_MST_SITE C WITH(NOLOCK)
    ON A.DIVISION_ID = C.DIVISION_ID
   AND A.SCM_SITE_ID = C.SCM_SITE_ID
   AND C.VALID_YN    = 'Y'
 WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
   AND A.DIVISION_ID = @p_division_id
   AND A.MEASURE     = 'MKT_FCST'
   AND A.ITEM_ID     = @k_item
   AND A.SCM_SITE_ID = @k_site
   AND A.QTY <> 0
   AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                             WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                               AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID )
   AND A.ITEM_ID NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                           WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                             AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID )
   AND A.MEASURE NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                           WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y' )
 ORDER BY A.YYYYMMDD;


PRINT '===== §9 참고 — 같은 키의 다른 메저는 왜 나오는가 (대조군) =====';
-- 같은 키에서 AS-IS 에 존재하는 메저: RTF[R+P](RTF_SYS_RP) / RTF_PR / Sales Amt.(KRW/LOC) / Unit Price(LOC)
-- 이들이 나오는데 MKT_FCST 만 없다면 원인은 사이트/기간이 아니라 **MKT_FCST 데이터 자체**다.
SELECT A.MEASURE, COUNT(*) AS CNT, MIN(A.YYYYMMDD) AS MIN_YMD, MAX(A.YYYYMMDD) AS MAX_YMD,
       SUM(CASE WHEN A.QTY <> 0 THEN 1 ELSE 0 END) AS QTY_NOT_ZERO
  FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
 WHERE A.DIVISION_ID = @p_division_id
   AND A.ITEM_ID     = @k_item
   AND A.SCM_SITE_ID = @k_site
   AND A.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
 GROUP BY A.MEASURE
 ORDER BY A.MEASURE;

PRINT '===== 끝 =====';
