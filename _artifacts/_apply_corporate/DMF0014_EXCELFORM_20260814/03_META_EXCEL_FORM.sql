--------------------------------------------------------------------------------------------------
-- [E20260814-EXCELFORM] DMF0014 Excel Form 메타 배선 (hook #135 §5 — 5축 중 2·3·4·5)
--------------------------------------------------------------------------------------------------
-- 사용자 요구(2026-08-14): "EXCEL UPLOAD 기능이 있는 경우 DMF0082 의 EXCEL FORM/EXCEL UPLOAD 양식을
--   기본 RULE 로 … 이 RULE 을 기반으로 DMF0014 에 EXCEL FORM, EXCEL UPLOAD 기능 구현"
--   · Excel Upload 2단 = DMF0014 는 **이미 적용됨**(2026-07-10, onSave → UPLOAD_SAVE) → 신설 없음
--   · 신설 대상 = **Excel Form** 1종
--
-- ⚠ 배선(MNU_BTN_MPG_M)과 권한(USER_GR_MNU_BTN_MPG_M)은 **둘 다** 있어야 버튼이 뜬다.
--   FE 게이트 = `hasButton('FORM_DATA')` — 2026-08-14 DMF0082 이관에서 이 2축을 빠뜨려
--   40 division 에서 Excel Form 버튼이 아예 안 보인 실사고가 있었다.
--
-- 1축(SCM_ADM_EXCEL_COLUMNS)은 기존재 — 변경하지 않는다:
--   PROGRAM_ID='DMF0014' / SHEET_NAME='FCST Upload'
--   STORAGE_SQL_ID='PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'
--   HEADER_CONTENT = 13 토큰(**'*' 포함** — SHEET_COLUMNS 라벨과 문자 동일) + W27~W31
--   ⭐ W27~W31 = **고정 주차 문자열 유지**(사용자 A안 확정 2026-08-14 — 기존 업로드 파일 호환)
--------------------------------------------------------------------------------------------------
SET DEFINE OFF

/* ── ④ API_M ── */
MERGE INTO SCM_MGR.SCM_ADM_API_M T
USING (SELECT 'DMF0014_GET_EXCEL_FORM' AS API_ID FROM DUAL) S
ON (T.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT
  (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
  ('DMF0014_GET_EXCEL_FORM', 'PROC_SELECT', '-', 'DMF0014 Excel Form 조회',
   'PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA', 'Y',
   'admin', SYSDATE, 'admin', SYSDATE);

/* ── ② 버튼 배선 ── */
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T
USING (SELECT 'DMF0014' AS MNU_ID, 'FCST Upload' AS SHT_NM, 'FORM_DATA' AS MNU_BTN_CD FROM DUAL) S
ON (T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET T.API_ID = 'DMF0014_GET_EXCEL_FORM', T.USE_YN = 'Y',
                             T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
  ('DMF0014', 'FCST Upload', 'FORM_DATA', 'DMF0014_GET_EXCEL_FORM', 'Y',
   'admin', SYSDATE, 'admin', SYSDATE);

/* ── ③ 버튼 권한 — 같은 화면 UPLOAD 버튼 보유 그룹을 그대로 미러링(임의 그룹 생성 금지) ── */
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT U.USER_GR_ID, 'DMF0014', 'FCST Upload', 'FORM_DATA', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM   SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M U
WHERE  U.MNU_ID = 'DMF0014' AND U.MNU_BTN_CD = 'UPLOAD' AND U.USE_YN = 'Y'
AND    NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID = U.USER_GR_ID AND X.MNU_ID = 'DMF0014'
                    AND   X.SHT_NM = 'FCST Upload' AND X.MNU_BTN_CD = 'FORM_DATA');

/* ── ⑤ PROC_M — SP positional 17 (IN 15 + O_RC1 + O_RESULT_CURSOR)
      COL_NM = FE payload 키(camelCase) 1:1 / OUT 커서 = FE RESPONSE_SET 키 ── */
DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA'
;

INSERT INTO SCM_MGR.SCM_ADM_PROC_M
  (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA', C.COL_NM, C.DATA_TP_CD, C.COL_TP_CD, C.SORT_ORD,
       'admin', SYSDATE, 'admin', SYSDATE
FROM (
  SELECT 'divisionId'      COL_NM, 'VARCHAR'     DATA_TP_CD, 'IN'  COL_TP_CD,  1 SORT_ORD FROM DUAL
  UNION ALL SELECT 'deptId',          'VARCHAR',     'IN',   2 FROM DUAL
  UNION ALL SELECT 'endCustomer',     'VARCHAR',     'IN',   3 FROM DUAL
  UNION ALL SELECT 'scmSiteId',       'VARCHAR',     'IN',   4 FROM DUAL
  UNION ALL SELECT 'plantSiteId',     'VARCHAR',     'IN',   5 FROM DUAL
  UNION ALL SELECT 'projectCode',     'VARCHAR',     'IN',   6 FROM DUAL
  UNION ALL SELECT 'itemId',          'VARCHAR',     'IN',   7 FROM DUAL
  UNION ALL SELECT 'startYyyymmdd',   'VARCHAR',     'IN',   8 FROM DUAL
  UNION ALL SELECT 'endYyyymmdd',     'VARCHAR',     'IN',   9 FROM DUAL
  UNION ALL SELECT 'bucketType',      'VARCHAR',     'IN',  10 FROM DUAL
  UNION ALL SELECT 'domExp',          'VARCHAR',     'IN',  11 FROM DUAL
  -- ⚠ 12~15 는 **메인 GET 과 동일한 FE 키**를 써야 한다(store.filters 무가공 전달이 §3-1 계약).
  --   실측 store payload = createdBy / userinfo / sesUserId / mnuId — 다른 이름을 쓰면 NULL 바인딩.
  UNION ALL SELECT 'createdBy',       'VARCHAR',     'IN',  12 FROM DUAL
  UNION ALL SELECT 'userinfo',        'VARCHAR',     'IN',  13 FROM DUAL
  UNION ALL SELECT 'sesUserId',       'VARCHAR',     'IN',  14 FROM DUAL
  UNION ALL SELECT 'mnuId',           'VARCHAR',     'IN',  15 FROM DUAL
  UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 16 FROM DUAL
  UNION ALL SELECT 'o_result_cursor', 'PROC_RESULT', 'OUT', 17 FROM DUAL
) C;

COMMIT;
