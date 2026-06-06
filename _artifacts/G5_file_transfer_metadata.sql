-- ============================================================================
-- G5 File Transfer 메타 SQL (Phase 7 A1, 2026-06-04)
--
-- 적용 대상:
--   1. SCM_SYS_FILE 테이블 (DDL)
--   2. SCM_ADM_API_M 메타 등록 (file-upload / file-download / file-delete 3 endpoint)
--   3. SCM_ADM_PROC_M 메타 등록 (없음 — file transfer 는 SP 호출 X)
--
-- 멱등 INSERT 패턴 (NOT EXISTS) — 재실행 안전.
-- ============================================================================

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │ BLOCK 1: SCM_SYS_FILE 테이블 DDL                                            │
-- └────────────────────────────────────────────────────────────────────────────┘

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USER_TABLES WHERE TABLE_NAME = 'SCM_SYS_FILE';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE SCM_SYS_FILE (
                FILE_ID            VARCHAR2(32)   NOT NULL,
                MNU_ID             VARCHAR2(20)   NOT NULL,
                SHT_NM             VARCHAR2(50)   NOT NULL,
                FILE_NM            VARCHAR2(255)  NOT NULL,
                FILE_PATH          VARCHAR2(1000) NOT NULL,
                FILE_SIZE          NUMBER         NOT NULL,
                MIME_TYPE          VARCHAR2(100),
                UPLOADED_BY        VARCHAR2(50)   NOT NULL,
                UPLOADED_AT        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
                DELETED_YN         CHAR(1)        DEFAULT ''N'' NOT NULL,
                LAST_UPDATED_BY    VARCHAR2(50),
                LAST_UPDATE_DATE   TIMESTAMP,
                CONSTRAINT PK_SCM_SYS_FILE PRIMARY KEY (FILE_ID)
            )';
        EXECUTE IMMEDIATE 'CREATE INDEX IDX_SCM_SYS_FILE_MNU ON SCM_SYS_FILE (MNU_ID, SHT_NM, DELETED_YN)';
        EXECUTE IMMEDIATE 'CREATE INDEX IDX_SCM_SYS_FILE_UPLD ON SCM_SYS_FILE (UPLOADED_BY, UPLOADED_AT)';

        COMMENT ON TABLE SCM_SYS_FILE IS 'G5 File Transfer 메타 (filesystem 저장 + DB 메타)';
        COMMENT ON COLUMN SCM_SYS_FILE.FILE_ID IS 'UUID (hex 32자)';
        COMMENT ON COLUMN SCM_SYS_FILE.FILE_PATH IS '실제 저장 경로 (filesystem 절대 경로)';
        COMMENT ON COLUMN SCM_SYS_FILE.DELETED_YN IS 'soft delete flag';

        DBMS_OUTPUT.PUT_LINE('[OK] SCM_SYS_FILE 테이블 생성 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[SKIP] SCM_SYS_FILE 테이블 이미 존재');
    END IF;
END;
/

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │ BLOCK 2: SCM_ADM_API_M 메타 등록 (3 endpoint × ALL 메뉴 — Global API)        │
-- │                                                                              │
-- │ ⚠️ 현재 file transfer 는 mnuId/shtNm 별로 호출 — Global API 등록 패턴 적용. │
-- │ 또는 화면별 별도 등록 필요 시 화면 ID 변경.                                  │
-- └────────────────────────────────────────────────────────────────────────────┘

INSERT INTO SCM_ADM_API_M (
    MNU_ID, SHT_NM, MNU_BTN_CD, API_TP_CD, API_URL, API_MSG_ID, API_DESC,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'ALL', 'common', 'FILE_UPLOAD', 'POST',
       '/{mnuId}/{shtNm}/file-upload',
       'MSG_API_ALL_COMMON_FILE_UPLOAD',
       'G5 File Upload — 일반 파일 업로드 (multipart/form-data)',
       'SYSTEM', SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP
  FROM DUAL
 WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_API_M
     WHERE MNU_ID = 'ALL' AND SHT_NM = 'common' AND MNU_BTN_CD = 'FILE_UPLOAD'
 );

INSERT INTO SCM_ADM_API_M (
    MNU_ID, SHT_NM, MNU_BTN_CD, API_TP_CD, API_URL, API_MSG_ID, API_DESC,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'ALL', 'common', 'FILE_DOWNLOAD', 'GET',
       '/{mnuId}/{shtNm}/file-download/{fileId}',
       'MSG_API_ALL_COMMON_FILE_DOWNLOAD',
       'G5 File Download — 파일 다운로드 (binary stream)',
       'SYSTEM', SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP
  FROM DUAL
 WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_API_M
     WHERE MNU_ID = 'ALL' AND SHT_NM = 'common' AND MNU_BTN_CD = 'FILE_DOWNLOAD'
 );

INSERT INTO SCM_ADM_API_M (
    MNU_ID, SHT_NM, MNU_BTN_CD, API_TP_CD, API_URL, API_MSG_ID, API_DESC,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'ALL', 'common', 'FILE_DELETE', 'DELETE',
       '/{mnuId}/{shtNm}/file-delete/{fileId}',
       'MSG_API_ALL_COMMON_FILE_DELETE',
       'G5 File Delete — 파일 삭제 (soft delete)',
       'SYSTEM', SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP
  FROM DUAL
 WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_API_M
     WHERE MNU_ID = 'ALL' AND SHT_NM = 'common' AND MNU_BTN_CD = 'FILE_DELETE'
 );

COMMIT;

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │ BLOCK 3: Verify                                                              │
-- └────────────────────────────────────────────────────────────────────────────┘

PROMPT === Verify SCM_SYS_FILE 테이블 ===
SELECT COUNT(*) AS TABLE_EXISTS FROM USER_TABLES WHERE TABLE_NAME = 'SCM_SYS_FILE';

PROMPT === Verify SCM_ADM_API_M G5 메타 ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_TP_CD, API_URL
  FROM SCM_ADM_API_M
 WHERE MNU_BTN_CD IN ('FILE_UPLOAD', 'FILE_DOWNLOAD', 'FILE_DELETE')
 ORDER BY MNU_BTN_CD;

-- 예상 결과: 3 row (FILE_UPLOAD / FILE_DOWNLOAD / FILE_DELETE)

-- ============================================================================
-- 적용 절차:
--   1. sqlplus / DBeaver 로 본 SQL 실행
--   2. BE 재시작 후 endpoint 호출 검증
--   3. FE 의 useFileUpload / useFileDownload hook 호출 → 정상 동작 확인
--   4. application.yml 의 file.storage.path 설정 검증 (미설정 시 ${user.home}/.nscm/files default)
-- ============================================================================
