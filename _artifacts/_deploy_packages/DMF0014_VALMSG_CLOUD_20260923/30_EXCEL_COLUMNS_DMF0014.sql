-- SCM_ADM_EXCEL_COLUMNS DMF0014 — 클라우드 목표상태 (멱등 · 비파괴 · 사전값 WHERE 없음)
-- ⭐ 2026-09-23 3차 정정: HEADER_CONTENT = 식별 13토큰 + **업로드 파일의 기간 헤더(날짜) 그대로** = 17토큰
--   증상: 같은 파일이 사내에선 'Please Input QTY' 2행 정상, 클라우드에선 9행 전부 'Invalid Measure Upload Bucket'.
--   원인(07-08 클라우드 진단 선례와 동일 서명): 클라우드 BE 는 HEADER_CONTENT **파이프 수만큼만** 컬럼을 매핑하고 **전 토큰**을 엑셀 헤더와 대조한다.
--     - 13토큰 → 기간 컬럼 4개가 절단되어 헤더행 ATTRIBUTE14~17 이 빈값 → 버킷 산출 원천 소실 → 전 행 Bucket 오류
--     - W27~W31 토큰 → 파일에 없는 헤더라 'Invalid Column Header Title'
--   ⇒ 파일 헤더와 1:1 인 토큰만 성립한다. 아래 4개 날짜 = 사내 스테이징 실측(2026-09-23 12:40 minyonglee1 배치 V_TITLE 행 ATTRIBUTE14~17).
--   ⚠ 파일 종속: 기간 헤더가 다른 파일(다른 주차·26주 양식)을 올리면 그 파일의 날짜로 이 값을 다시 맞춰야 한다.
--   ⛔ 사내(현행 BE)에는 적용 금지 — 현행 BE 는 '파일에 실재하는 토큰'을 식별 컬럼으로 넣은 뒤 기간 컬럼을 또 붙여 날짜 토큰이 **2중 매핑**된다(사내 실측 2026-09-23: 메시지 2배 중복). 사내 값 = 원본 18토큰 유지.
--      근본 해결 = 클라우드 FE(Excel Form 날짜 헤더)·BE(동적 매핑) 를 사내 세대(08-14 이후)로 재이관 — DB 만으로는 파일마다 동기가 필요.
MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (SELECT 'DMF0014' PROGRAM_ID, 'FCST Upload' SHEET_NAME, 'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD' STORAGE_SQL_ID,
              'Division*|Sales Site*|Plant Site*|Customer Project*|Customer Model*|Incoterms*|FCST Type*|Customs Handbook*|Measure Group*|Measure*|Upload UOM*|Project|Model|20260921|20260928|20261005|20261012' HEADER_CONTENT,
              70 OPTION_ATTRIBUTE_COLUMN_NUMBER, 'Y' VALID_YN FROM DUAL) S
ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME)
WHEN MATCHED THEN UPDATE SET T.STORAGE_SQL_ID = S.STORAGE_SQL_ID, T.HEADER_CONTENT = S.HEADER_CONTENT,
     T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER, T.VALID_YN = S.VALID_YN,
     T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
     VALUES (S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT, S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;

-- 확인 (기대: 파이프 16개 = 17토큰)
SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT,
       LENGTH(HEADER_CONTENT) - LENGTH(REPLACE(HEADER_CONTENT, '|', '')) AS PIPE_CNT
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0014' AND SHEET_NAME = 'FCST Upload';
