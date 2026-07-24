-- =====================================================================
-- 00A_GTT_REBUILD_DMF0042.sql — 클라우드 GTT 재생성 (구판 정밀도 교정, 2026-07-22)
--
-- ▶ 배경: 00_GTT_DDL 은 기존재 시 -955 skip → 클라우드에 구판(수량/금액 NUMBER(20,10))
--    GTT 가 이미 있으면 교정본(NUMBER(30,10))이 반영되지 않음 (DMF0082 ORA-01438 사고 동형 예방).
-- ▶ 실행 순서: 1) 본 파일 → 2) 00_GTT_DDL_DMF0042.sql 재실행 → 3) INVALID 재컴파일 확인
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
  drop_gtt('GT_DMF0042_DLT_ITEM_ID');
  drop_gtt('GT_DMF0042_DM_MST_ITEM_SINGLE_A_V');
  drop_gtt('GT_DMF0042_DM_MST_ITEM_SINGLE_B_V');
  drop_gtt('GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V');
  drop_gtt('GT_DMF0042_DM_MST_ITEM_SINGLE_V');
  drop_gtt('GT_DMF0042_RAW_DATA');
  drop_gtt('GT_DMF0042_RAW_DATA_SUM');
  drop_gtt('GT_DMF0042_SCM_MST_SITE_ITEM');
  drop_gtt('GT_DMF0042_SCM_MST_SSO_USER_INFO');
  drop_gtt('GT_DMF0042_SELECT_MEASURE');
  drop_gtt('GT_SDBE_RESULTS');
  drop_gtt('GT_SDPB2_BP_FCST_4');
  drop_gtt('GT_SDPB2_DM_PLN_BP_FCST_X_4');
  drop_gtt('GT_SDPBP_FUTURE_PRICE_TEMP0_4');
  drop_gtt('GT_SDPBP_FUTURE_PRICE_TEMP1_2');
  drop_gtt('GT_SDPBP_FUTURE_PRICE_TEMP2_4');
  drop_gtt('GT_SDPBP_FUTURE_PRICE_TEMP3_2');
  drop_gtt('GT_SDPB_BP_FCST');
  drop_gtt('GT_SDPB_DM_MST_ITEM_SINGLE_A_V');
  drop_gtt('GT_SDPB_DM_MST_ITEM_SINGLE_B_V');
  drop_gtt('GT_SDPB_DM_MST_ITEM_SINGLE_ORI');
  drop_gtt('GT_SDPB_DM_MST_ITEM_SINGLE_V');
  drop_gtt('GT_SDPB_FUTURE_PRICE_TEMP_QTY');
END;
/

-- 재생성 후 검증: INVALID 0 + 수량/금액 컬럼 data_precision=30
-- SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID';
-- SELECT table_name, column_name, data_precision FROM all_tab_columns
--  WHERE owner='SCM_MGR' AND table_name LIKE 'GT_%' AND data_precision=20 AND data_scale=10
--    AND column_name IN ('QTY','V_QTY','PRICE','CELL_QUANTITY','MIN_CAPACITY');  -- 0행 정상
