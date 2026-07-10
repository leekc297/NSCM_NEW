-- ============================================================================
-- DMF0014 저장 -9994 / "InvocationTargetException: null" 최종 DB 점검
--   확정: SP 직접호출 = SAVE OK (SP/데이터/파라미터/권한/PKG body 전부 정상).
--         => 원인은 BE 가 OUT 결과커서(o_result_cursor)를 처리하는 단계.
--   BE 는 PROC_M 의 DATA_TP_CD 로 파라미터 유형을 판단한다:
--         DATA_TP_CD='PROC_RESULT' (또는 'CURSOR') 이어야 REF CURSOR 로 등록.
--         이 값이 다르면(VARCHAR/공란 등) OUT 커서를 스칼라로 오등록 → BE 리플렉션 예외.
--   실행: 클라우드 DB, SCM_MGR 접속.
-- ============================================================================

-- ── STEP 1. 진단 — 18번째(OUT 커서) 행의 DATA_TP_CD 확인 ────────────────────
SELECT sort_ord, col_nm, data_tp_cd, col_tp_cd
  FROM scm_adm_proc_m
 WHERE proc_nm = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
 ORDER BY sort_ord;
-- 기대(사내 정상본): SORT 18 = o_result_cursor / DATA_TP_CD='PROC_RESULT' / COL_TP_CD='OUT'
-- SORT18 DATA_TP_CD 가 'PROC_RESULT' 가 아니면 → STEP 2 실행.


-- ── STEP 2. 조치 — OUT 커서 DATA_TP_CD 를 PROC_RESULT 로 교정 (멱등) ─────────
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET DATA_TP_CD = 'PROC_RESULT',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
   AND SORT_ORD = 18
   AND COL_TP_CD = 'OUT'
   AND NVL(DATA_TP_CD,'X') <> 'PROC_RESULT';
COMMIT;

-- (참고) 업로드 SP 도 동일 점검 — 필요 시 함께 교정
-- SELECT sort_ord, col_nm, data_tp_cd, col_tp_cd FROM scm_adm_proc_m
--  WHERE proc_nm='PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD' ORDER BY sort_ord;

-- ── STEP 3. 재검증 ──────────────────────────────────────────────────────────
SELECT sort_ord, col_nm, data_tp_cd, col_tp_cd
  FROM scm_adm_proc_m
 WHERE proc_nm = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
   AND sort_ord = 18;
-- 기대: DATA_TP_CD='PROC_RESULT'
