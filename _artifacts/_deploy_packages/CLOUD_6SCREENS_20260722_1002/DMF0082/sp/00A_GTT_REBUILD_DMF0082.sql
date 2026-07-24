-- =====================================================================
-- 00A_GTT_REBUILD_DMF0082.sql — 클라우드 GTT 재생성 (구판 정밀도 교정, 2026-07-22)
--
-- ▶ 원인: 클라우드 조회 시 ORA-01438 (value ... greater than precision (20,10))
--    = 클라우드에 '예전 정의' GTT(QTY 등 NUMBER(20,10))가 이미 존재
--    → 00_GTT_DDL 은 기존재 시 -955 skip 이라 교정본(NUMBER(30,10))으로 갱신되지 않음.
--    사내는 2026-07 정밀도 확폭 교정 완료 (GT_DMF0082_TEMP_FCST_N_PRICE.QTY 외).
--
-- ▶ 실행 순서 (반드시):
--    1) 본 파일 실행  → 대상 GTT 전체 DROP (미존재 -942 skip)
--    2) 00_GTT_DDL_DMF0082.sql 재실행 → 신 정의로 재생성
--    3) INVALID 재컴파일 확인 (하단 참조)
--
-- ▶ ⚠ ORA-14452 (사용 중) 발생 시: GTT 를 물고 있는 세션 존재 —
--    BE(WAS) 재기동 직후(또는 유휴 시간)에 재실행하세요.
-- ▶ ⚠ GT_PRDM* 는 타 화면(DMF0003 등)과 공유 — DROP 시 의존 PKG 가 잠시 INVALID 되나
--    재생성 + 재컴파일(또는 다음 호출 시 자동 컴파일)로 복원됩니다.
-- =====================================================================
SET SERVEROUTPUT ON
DECLARE
  PROCEDURE drop_gtt(p_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE "SCM_MGR"."' || p_name || '"';
    DBMS_OUTPUT.PUT_LINE('DROPPED : ' || p_name);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -942 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP(미존재): ' || p_name);
      ELSIF SQLCODE = -14452 THEN
        RAISE_APPLICATION_ERROR(-20001,
          p_name || ' 사용 중(ORA-14452) — BE 재기동 후 본 파일부터 재실행');
      ELSE
        RAISE;
      END IF;
  END;
BEGIN
  drop_gtt('GT_DMF0082_CAL_MONTH_END_DATE');
  drop_gtt('GT_DMF0082_CAL_WEEK_END_DATE');
  drop_gtt('GT_DMF0082_FCST_PRICE_BUCKET');
  drop_gtt('GT_DMF0082_FCST_PRICE_DAILY');
  drop_gtt('GT_DMF0082_FCST_PRICE_EXCEL');
  drop_gtt('GT_DMF0082_FCST_PRICE_UNPIVOT');
  drop_gtt('GT_DMF0082_FCST_PRICE_WEEKLY');
  drop_gtt('GT_DMF0082_MF_SP');
  drop_gtt('GT_DMF0082_MST_ITEM_SINGLE_A_V');
  drop_gtt('GT_DMF0082_MST_ITEM_SINGLE_B_V');
  drop_gtt('GT_DMF0082_MST_ITEM_SINGLE_ORI_V');
  drop_gtt('GT_DMF0082_MST_ITEM_SINGLE_V');
  drop_gtt('GT_DMF0082_PJT');
  drop_gtt('GT_DMF0082_SP_FILTER');
  drop_gtt('GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE');
  drop_gtt('GT_DMF0082_TEMP_FCST_N_PRICE');
  drop_gtt('GT_DMF0082_TEMP_INTO_GROUP_MEASURE');
  drop_gtt('GT_DMF0082_TEMP_SELECT_MEASURE');
  drop_gtt('GT_DMF0082_TEMP_SITE_ITEM');
  drop_gtt('GT_DMF0082_TEMP_SITE_ITEM_ALL');
  drop_gtt('GT_DMF0082_T_LAST_DATA_SETUP_FCST');
  drop_gtt('GT_DMF0082_T_LAST_DATA_SETUP_FCST_C');
  drop_gtt('GT_DMF0082_T_LAST_DATA_SETUP_PRICE');
  drop_gtt('GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C');
  drop_gtt('GT_DMF0082_T_VERSION');
  drop_gtt('GT_DMF0082_T_WS_FCST');
  drop_gtt('GT_PRDM1_MSHYCHU1');
  drop_gtt('GT_PRDM1_MSHYCHU2');
  drop_gtt('GT_PRDM1_TEMP_DAYINFO');
  drop_gtt('GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE');
  drop_gtt('GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST');
  drop_gtt('GT_PRDM1_TEMP_EXCH');
  drop_gtt('GT_PRDM1_T_FCST');
  drop_gtt('GT_PRDM1_T_MAIN');
  drop_gtt('GT_PRDM1_T_PRICE');
  drop_gtt('GT_PRDM_SEND_TARGET_DATA');
  drop_gtt('GT_PRDM_T_MAIN');
END;
/

-- ─────────────────────────────────────────────────────────────
-- 3) 재생성(00_GTT_DDL_DMF0082.sql 재실행) 후 INVALID 재컴파일:
-- SELECT object_type, object_name FROM all_objects
--  WHERE owner='SCM_MGR' AND status='INVALID';
-- 발견 시: ALTER PACKAGE SCM_MGR.PKG_DMF0082 COMPILE BODY;  (그 외 INVALID 도 동일 패턴)
--
-- 4) 검증 — 교정 반영 확인 (QTY 가 30,10 이어야 정상):
-- SELECT column_name, data_precision, data_scale FROM all_tab_columns
--  WHERE owner='SCM_MGR' AND table_name='GT_DMF0082_TEMP_FCST_N_PRICE'
--    AND column_name IN ('QTY','MIN_CAPACITY','FORECAST_INFO_CELL_PACK_COUNT','CELL_PER_CAR');
-- ─────────────────────────────────────────────────────────────
