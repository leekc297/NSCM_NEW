-- ============================================================================
-- DMF0082 CURRENCY 결손 — 클라우드 원인 진단
--
-- 사내 ZIOUI1 에서는 "RTF[R+P] / BALANCE 만 CURRENCY 누락" 패턴이 재현되지 않는다
-- (사내는 MKT_FCST·SCM_FCST·RTF_SYS_RP 가 늘 함께 비었다). 클라우드 데이터에서만
-- 나타나는 패턴이므로, 아래를 **클라우드에서 한 세션 안에** 순서대로 실행해 주십시오.
--
-- ⚠ DBeaver 에서 §1 과 §2 를 **같은 커넥션·같은 세션**으로 실행해야 한다.
--    GT_ 로 시작하는 표는 세션 임시표(GTT)라 세션이 끊기면 내용이 사라진다.
--    읽기 전용 조회이며 영구 데이터를 바꾸지 않는다.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- §1. 문제 화면과 동일한 조건으로 조회를 재현한다
--     아래 값은 첨부 화면 기준 예시다. 실제 재현 조건으로 바꿔서 실행할 것.
-- ----------------------------------------------------------------------------
DECLARE
    R1 SYS_REFCURSOR; R2 SYS_REFCURSOR; R3 SYS_REFCURSOR;
    R4 SYS_REFCURSOR; R5 SYS_REFCURSOR; RR SYS_REFCURSOR;
BEGIN
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id   => '40',
        p_team_id       => 'ALL',
        p_customer      => 'ALL',
        p_biz_type      => 'ALL',
        p_from_yyyymmdd => '20260101',      -- ← 화면 조회 From
        p_to_yyyymmdd   => '20271231',      -- ← 화면 조회 To
        p_scm_site_id   => 'ALL',
        p_item_id       => 'MCSS22561-C1',  -- ← 결손이 보이는 Model
        p_version_type  => 'Current',       -- ← 화면 Version
        p_qty_yn        => 'Y',
        p_created_by    => USER,
        p_user_group    => 'ADMIN',
        p_plant_site_id => 'ALL',
        p_project_code  => 'ALL',
        p_owner         => 'ALL',
        p_sender_code   => 'ALL',
        O_RC1 => R1, O_RC2 => R2, O_RC3 => R3, O_RC4 => R4, O_RC5 => R5,
        O_RESULT_CURSOR => RR);
END;
/

-- ----------------------------------------------------------------------------
-- §2-1. MEASURE 별 CURRENCY 결손 — 어떤 measure 가 비는지
-- ----------------------------------------------------------------------------
SELECT MEASURE,
       COUNT(*)                                              AS 행수,
       SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END)     AS 통화없음,
       MAX(CURRENCY)                                         AS 통화예시,
       MIN(YYYYMMDD)                                         AS 시작,
       MAX(YYYYMMDD)                                         AS 종료
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 GROUP BY MEASURE
 ORDER BY 3 DESC, 1;
-- 기대: 보완 적용 후라면 통화없음 = 0
-- RTF_SYS_RP / BALANCE 만 값이 크다면 → §2-2 로 키를 확인한다


-- ----------------------------------------------------------------------------
-- §2-2. 결손 행의 9키 전체 — 같은 키의 단가(LOC) 행과 어느 컬럼이 다른지
-- ----------------------------------------------------------------------------
SELECT '결손' AS 구분, MEASURE, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
       INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, COUNT(*) AS 행수, NULL AS 통화
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 WHERE CURRENCY IS NULL AND MEASURE NOT LIKE 'VMI%'
 GROUP BY MEASURE, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
          INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
UNION ALL
SELECT '단가LOC', MEASURE, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
       INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, COUNT(*), MAX(CURRENCY)
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 WHERE MEASURE = 'LOC'
 GROUP BY MEASURE, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
          INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
 ORDER BY 6, 4, 1, 2;
-- 두 블록을 나란히 놓고 **어느 컬럼이 다른지** 본다.
--   · CELL_PROD_SITE_ID 만 다르다      → 1차 보완(E20260918-CURRCELLPROD)이 처리
--   · INCOTERMS / PROJECT_CODE 도 다르다 → 2차 보완(E20260918-CURRSITEITEM)이 처리
--   · 단가LOC 블록이 아예 없다          → 단가 미등록 (보완 대상 아님 — 정상)


-- ----------------------------------------------------------------------------
-- §2-3. 같은 행이 통화 있는 행 / 없는 행으로 쪼개져 있는가
--       최종 그리드는 CURRENCY 를 표시 컬럼으로 GROUP BY 하므로,
--       한 키의 일부 기간만 통화가 채워지면 **그리드 행이 둘로 갈린다**.
-- ----------------------------------------------------------------------------
SELECT MEASURE, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
       CELL_PROD_SITE_ID,
       COUNT(DISTINCT NVL(CURRENCY, '(없음)')) AS 통화종류,
       LISTAGG(DISTINCT NVL(CURRENCY, '(없음)'), ' / ')
           WITHIN GROUP (ORDER BY NVL(CURRENCY, '(없음)')) AS 통화목록
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 GROUP BY MEASURE, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
          CELL_PROD_SITE_ID
HAVING COUNT(DISTINCT NVL(CURRENCY, '(없음)')) > 1
 ORDER BY 1, 3, 4;
-- 여기 행이 나오면 '(없음)' 과 실제 통화가 한 키에 섞여 있다는 뜻이다.
-- 화면에서는 같은 Model 이 통화 있는 줄 / 없는 줄로 두 번 보인다.


-- ----------------------------------------------------------------------------
-- §3. 보완이 채우지 않는 키 (설계상 제외 — 오배정 방지)
--     아래 축 안에서 통화가 2종 이상인 키는 폴백이 건드리지 않는다.
-- ----------------------------------------------------------------------------
SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
       COUNT(DISTINCT CURRENCY) AS 통화종류
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 WHERE MEASURE = 'LOC' AND CURRENCY IS NOT NULL
 GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
HAVING COUNT(DISTINCT CURRENCY) > 1
 ORDER BY 1, 2, 3;
-- 여기 나오는 키가 §2-1 의 결손과 겹치면, 통화를 자동으로 정할 수 없는 키다.
-- 어느 통화를 써야 하는지 업무 확인이 필요하다.
