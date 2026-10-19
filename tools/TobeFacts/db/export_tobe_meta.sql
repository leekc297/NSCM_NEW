-- To-Be(Oracle, SCM_MGR) 메타 내보내기 — LGES 클라우드에서 실행해 CSV 를 C:\Projects\NSCM\Doc\tobefacts\db\ 에 둔다.
-- 소스에는 (MENU, sheet, button) 3-키까지만 있고 어느 SP/컬럼/콤보가 붙는지는 이 메타에만 있으므로, GAP 판정(gap.js) 의 근거가 된다.
-- 실행: SQL*Plus / SQLcl  →  @export_tobe_meta.sql   (DBeaver 는 각 SELECT 를 CSV 로 내보내고 파일명을 아래와 같이 저장)
-- 파일명(헤더 소문자 유지):
--   proc_meta.csv      menu_id,sheet,btn,api_id,proc
--   proc_params.csv    proc,col_nm,data_tp_cd,col_tp_cd,sort_ord
--   sheet_columns.csv  program_id,sheet_name,column_name,column_label_name,sort_order_no,visible_flag,default_flag,user_selectable_flag,valid_yn,division_id,input_tp_cd,cell_control_object_type_code,column_width,fixed_flag
--   sheet_measures.csv (SCM_MST_SHEET_MEASURE 전 컬럼)
--   combo_sql.csv      sql_id,sql_dtl_ctn
--   menu.csv           (SCM_ADM_MENU_M 전 컬럼)
--   msg_master.csv     (SCM_ADM_MSG_M 전 컬럼 — 생성기가 라벨 코드 자동 조회에 사용)
--   btn_auth.csv       (SCM_ADM_USER_GR_MNU_BTN_MPG_M 전 컬럼)
SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON FEEDBACK OFF HEADING OFF ECHO OFF VERIFY OFF TERMOUT OFF
SET MARKUP CSV ON QUOTE ON DELIMITER ','
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

SPOOL proc_meta.csv
SELECT 'menu_id','sheet','btn','api_id','proc' FROM DUAL;
SELECT DISTINCT M.MNU_ID, NVL(BMP.SHT_NM,'_DEFAULT_'), NVL(BMP.MNU_BTN_CD,'SEARCH'), BMP.API_ID, API.API_URL
  FROM SCM_MGR.SCM_ADM_MENU_M M
  LEFT JOIN SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BMP ON BMP.MNU_ID = M.MNU_ID
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BMP.API_ID
 WHERE M.USE_YN = 'Y'
 ORDER BY 1,2,3;
SPOOL OFF

SPOOL proc_params.csv
SELECT 'proc','col_nm','data_tp_cd','col_tp_cd','sort_ord' FROM DUAL;
SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M ORDER BY 1,4,5;
SPOOL OFF

SPOOL sheet_columns.csv
SELECT 'program_id','sheet_name','column_name','column_label_name','sort_order_no','visible_flag','default_flag','user_selectable_flag','valid_yn','division_id','input_tp_cd','cell_control_object_type_code','column_width','fixed_flag' FROM DUAL;
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, FIXED_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS ORDER BY 1,2,5;
SPOOL OFF

SPOOL sheet_measures.csv
SELECT * FROM SCM_MGR.SCM_MST_SHEET_MEASURE ORDER BY 1,2;
SPOOL OFF

SPOOL combo_sql.csv
SELECT 'sql_id','sql_dtl_ctn' FROM DUAL;
SELECT SQL_ID, DBMS_LOB.SUBSTR(SQL_DTL_CTN, 4000, 1) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M ORDER BY 1;
SPOOL OFF

SPOOL menu.csv
SELECT * FROM SCM_MGR.SCM_ADM_MENU_M ORDER BY MNU_ID;
SPOOL OFF

SPOOL msg_master.csv
SELECT * FROM SCM_MGR.SCM_ADM_MSG_M ORDER BY 1;   -- 라벨/메시지 마스터(LBL/MSG 코드 ↔ 문구) — 테이블명이 다르면 SYS0007 메시지관리 화면이 읽는 테이블로
SPOOL OFF

SPOOL btn_auth.csv
SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M ORDER BY 1,2,3;
SPOOL OFF
SET MARKUP CSV OFF
-- 주의: SET MARKUP CSV 는 SELECT * 에 헤더를 자동으로 붙이지 않으므로(HEADING OFF) 전 컬럼 파일은 DBeaver 내보내기(헤더 포함) 를 권장.
