-- ============================================================================
-- DMF0014 클라우드 저장/업로드 -9994 진단 + 권한 조치
--   실행: 클라우드 DB 에 SCM_MGR(또는 DBA) 로 접속.  -9994 = BE 가 SP 실행 중 SQL/PLS 오류를 감싼 코드.
--   저장/업로드 BE 진입점은 PKG_DMF0014 단 하나 → SCMD_APP 의 PKG_DMF0014 GRANT/SYNONYM 이 1순위 원인.
-- ============================================================================

-- ── STEP 1. 진단 (아래 6개 SELECT 결과를 '기대값'과 대조) ────────────────────
-- 1-1) 패키지 존재/유효 — 둘 다 VALID 여야 함. INVALID/미존재면 02_BODY(+01_SPEC) 먼저 배포.
SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST')
 ORDER BY object_name, object_type;
-- 기대: PKG_DMF0014 PACKAGE=VALID / PACKAGE BODY=VALID / PR_DM_PLN...=PROCEDURE VALID

-- 1-2) ⭐ SCMD_APP 실행권한 — 행이 없으면 이것이 -9994 원인(1순위).
SELECT table_name, privilege
  FROM dba_tab_privs
 WHERE grantee='SCMD_APP' AND owner='SCM_MGR'
   AND table_name IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST');
-- 기대: PKG_DMF0014=EXECUTE (PR_DM_PLN 은 내부호출이라 없어도 무방하나 함께 부여 권장)

-- 1-3) ⭐ SCMD_APP 시노님 — 미접두 참조 resolution. 없으면 PLS-00201 → -9994.
SELECT synonym_name, table_owner, table_name
  FROM dba_synonyms
 WHERE owner='SCMD_APP' AND synonym_name IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST');
-- 기대: PKG_DMF0014 → SCM_MGR.PKG_DMF0014

-- 1-4) API_M — 저장/업로드 SP URL 등록 + 사용중.
SELECT api_id, api_tp_cd, api_url, use_yn
  FROM scm_adm_api_m
 WHERE api_url IN ('PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',
                   'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD');
-- 기대: DMF0014_main_SAVE / DMF0014_main_UPLOAD, USE_YN=Y  (없으면 API_M INSERT 필요)

-- 1-5) 버튼→API 매핑.
SELECT mnu_id, sht_nm, mnu_btn_cd, api_id, use_yn
  FROM scm_adm_mnu_btn_mpg_m
 WHERE mnu_id='DMF0014' AND mnu_btn_cd IN ('SAVE','UPLOAD');
-- 기대: FCST Upload/SAVE→DMF0014_main_SAVE, FCST Upload/UPLOAD→DMF0014_main_UPLOAD, USE_YN=Y

-- 1-6) PROC_M — 저장 SP 파라미터 메타(18) + 17번째 = createdByList(FE 정렬 일치).
SELECT sort_ord, col_nm, col_tp_cd
  FROM scm_adm_proc_m
 WHERE proc_nm='PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
 ORDER BY sort_ord;
-- 기대: 18행, SORT 17 COL_NM='createdByList'  (다르면 04_PROC_M_createdByList.sql 적용)


-- ── STEP 2. 조치 (1-2/1-3 이 비었으면 실행 — 멱등) ───────────────────────────
GRANT EXECUTE ON SCM_MGR.PKG_DMF0014                    TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.PR_DM_PLN_CUST_FCST_TO_MKT_FCST TO SCMD_APP;

CREATE OR REPLACE SYNONYM SCMD_APP.PKG_DMF0014                     FOR SCM_MGR.PKG_DMF0014;
CREATE OR REPLACE SYNONYM SCMD_APP.PR_DM_PLN_CUST_FCST_TO_MKT_FCST FOR SCM_MGR.PR_DM_PLN_CUST_FCST_TO_MKT_FCST;

-- (필요 시) 패키지 재컴파일 후 유효성 재확인
ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE;
ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY;
SELECT object_name, object_type, status FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PKG_DMF0014';
