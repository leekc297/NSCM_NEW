-- =====================================================================
-- 00A_GTT_REBUILD_DMF0003.sql — 클라우드 GTT 재생성 (구판 정밀도 교정, 2026-07-22)
--
-- ▶ 배경: 00_GTT_DDL 은 기존재 시 -955 skip → 클라우드에 구판(수량/금액 NUMBER(20,10))
--    GTT 가 이미 있으면 교정본(NUMBER(30,10))이 반영되지 않음 (DMF0082 ORA-01438 사고 동형 예방).
-- ▶ 실행 순서: 1) 본 파일 → 2) 00_GTT_DDL_DMF0003.sql 재실행 → 3) INVALID 재컴파일 확인
-- ▶ ⚠ ORA-14452(사용 중) 시: BE(WAS) 재기동 직후 재실행.
-- ▶ ⚠ GT_PRDM*/공유 GTT 는 타 화면과 공유 — DROP 시 의존 PKG 잠시 INVALID → 재생성+재컴파일로 복원.
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
  drop_gtt('GT_ANLO_TEMP_AN_LOGIC');
  drop_gtt('GT_ANLO_TEMP_DATA');
  drop_gtt('GT_ANLO_TEMP_DM_MST_VERSION');
  drop_gtt('GT_ANLO_TEMP_SCM_MST_SITE');
  drop_gtt('GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V');
  drop_gtt('GT_ANLO_TMP_DM_PLN_MKT_FCST_C');
  drop_gtt('GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C');
  drop_gtt('GT_ANLO_TMP_PROJECT_CODE');
  drop_gtt('GT_CREF_TEMP_DATA');
  drop_gtt('GT_DMF0_DM_MST_ITEM_SINGLE_V');
  drop_gtt('GT_DMF0_MAIN');
  drop_gtt('GT_DMF3_ITEM_SINGLE_V');
  drop_gtt('GT_DMF3_RESULTS');
  drop_gtt('GT_DMF3_SEND_TARGET_DATA');
  drop_gtt('GT_DMF3_SITE_CUSTOMER_MAP');
  drop_gtt('GT_DMF3_TMP_MKT_FCST');
  drop_gtt('GT_DMF3_T_ERR');
  drop_gtt('GT_DMF3_T_ERR2');
  drop_gtt('GT_DMF3_T_PRICE');
  drop_gtt('GT_FSPS_SALES_PLAN_TEMP_LOC');
  drop_gtt('GT_FSPS_T_MKT_FCST');
  drop_gtt('GT_FSPS_T_PRICE');
  drop_gtt('GT_GGET_CAL_MONTH_END');
  drop_gtt('GT_GGET_CAL_WEEK_END');
  drop_gtt('GT_GGET_EDI_END_CUST');
  drop_gtt('GT_GGET_EDI_SENDER');
  drop_gtt('GT_GGET_INTRANSIT_DATA');
  drop_gtt('GT_GGET_ITEM_SINGLE_A');
  drop_gtt('GT_GGET_ITEM_SINGLE_B');
  drop_gtt('GT_GGET_ITEM_SINGLE_ORI');
  drop_gtt('GT_GGET_ITEM_SINGLE_V');
  drop_gtt('GT_GGET_LAST_DATA_SETUP');
  drop_gtt('GT_GGET_MF');
  drop_gtt('GT_GGET_MKT_FCST_DATA');
  drop_gtt('GT_GGET_MKT_FCST_DST');
  drop_gtt('GT_GGET_MKT_FCST_RESULT');
  drop_gtt('GT_GGET_OWNER_TOKEN');
  drop_gtt('GT_GGET_RPA_END_CUST');
  drop_gtt('GT_GGET_SALES_PRICE');
  drop_gtt('GT_GGET_SELECT_MEASURE');
  drop_gtt('GT_GGET_SHIPMENT_PLAN');
  drop_gtt('GT_GGET_SITE_ITEM');
  drop_gtt('GT_GGET_SITE_ITEM_ALL');
  drop_gtt('GT_GGET_SPLIT_BIZ_TYPE');
  drop_gtt('GT_GGET_SPLIT_CUSTOMER');
  drop_gtt('GT_GGET_SPLIT_ITEM_ID');
  drop_gtt('GT_GGET_SPLIT_ITEM_TYPE');
  drop_gtt('GT_GGET_SPLIT_OWNER');
  drop_gtt('GT_GGET_SPLIT_PLANT_SITE_ID');
  drop_gtt('GT_GGET_SPLIT_PROJECT_CODE');
  drop_gtt('GT_GGET_SPLIT_SCM_SITE_ID');
  drop_gtt('GT_GGET_SPLIT_SENDER_CODE');
  drop_gtt('GT_GGET_SPLIT_TEAM_ID');
  drop_gtt('GT_GGET_T_BNP');
  drop_gtt('GT_GGET_T_SSP_SYNC');
  drop_gtt('GT_GGET_VMI_DIO');
  drop_gtt('GT_GGET_VMI_INV');
  drop_gtt('GT_GGET_VMI_INV_RESULT');
  drop_gtt('GT_MFCP_TEMP_DM_SSP');
  drop_gtt('GT_SAVEPK_RESULTS');
  drop_gtt('GT_SAVEPK_VALID_RESULTS');
  drop_gtt('GT_T_MAIL_ADDR');
END;
/

-- 재생성 후 검증: INVALID 0 + 수량/금액 컬럼 data_precision=30
-- SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID';
-- SELECT table_name, column_name, data_precision FROM all_tab_columns
--  WHERE owner='SCM_MGR' AND table_name LIKE 'GT_%' AND data_precision=20 AND data_scale=10
--    AND column_name IN ('QTY','V_QTY','PRICE','CELL_QUANTITY','MIN_CAPACITY');  -- 0행 정상
