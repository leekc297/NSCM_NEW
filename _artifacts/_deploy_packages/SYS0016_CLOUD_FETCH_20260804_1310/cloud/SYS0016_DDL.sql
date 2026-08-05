-- SYS0016 DDL (클라우드 추출 2026-08-04 13:37) — 적용 순서 정렬본
-- 시드 유닛 1개
-- 폐포 레벨 1: 신규 6 (누적 유일 6)
-- 폐포 레벨 2: 신규 1 (누적 유일 7)
-- 폐포 레벨 3: 신규 0 (누적 유일 7)
-- ===== TABLE : SCM_ADM_NOTICE_CONTENT_MASTER =====

  CREATE TABLE "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"
   (	"NOTICE_ID" NUMBER(19,0) NOT NULL ENABLE,
	"LANGUAGE_CODE" VARCHAR2(4 CHAR) NOT NULL ENABLE,
	"NOTICE_TITLE" VARCHAR2(300 CHAR),
	"NOTICE_CONTENT" VARCHAR2(1000 CHAR),
	"CREATED_BY" VARCHAR2(150 CHAR),
	"CREATION_DATE" DATE NOT NULL ENABLE,
	"LAST_UPDATED_BY" VARCHAR2(150 CHAR),
	"LAST_UPDATE_DATE" DATE NOT NULL ENABLE,
	"NOTICE_IMAGE" VARCHAR2(50 CHAR),
	"NOTICE_IMAGE_ID" VARCHAR2(20 CHAR)
   )
/
-- (종속 INDEX 없음)

   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."NOTICE_ID" IS '공지ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."LANGUAGE_CODE" IS '언어구분코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."NOTICE_TITLE" IS '공지제목명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."NOTICE_CONTENT" IS '공지내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."CREATED_BY" IS '데이터입력사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."CREATION_DATE" IS '데이터입력일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."LAST_UPDATED_BY" IS '데이터수정사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"."LAST_UPDATE_DATE" IS '데이터수정일시'
   COMMENT ON TABLE "SCM_MGR"."SCM_ADM_NOTICE_CONTENT_MASTER"  IS '공지확정내용기본'
/
-- (종속 TRIGGER 없음)
-- ===== TABLE : SCM_ADM_NOTICE_MASTER =====

  CREATE TABLE "SCM_MGR"."SCM_ADM_NOTICE_MASTER"
   (	"NOTICE_ID" NUMBER(19,0) NOT NULL ENABLE,
	"SUB_MODULE_CODE" VARCHAR2(30 CHAR) NOT NULL ENABLE,
	"MODULE_CODE" VARCHAR2(30 CHAR) NOT NULL ENABLE,
	"NOTICE_TITLE" VARCHAR2(300 CHAR),
	"CYCLE_CLASS_CODE" VARCHAR2(5 CHAR),
	"DETAIL_CLASS_CODE" VARCHAR2(10 CHAR),
	"SEND_TIME_TEXT" VARCHAR2(40 CHAR),
	"VALID_YN" VARCHAR2(1 CHAR),
	"SQL_LONG_TEXT" VARCHAR2(1000 CHAR),
	"CREATED_BY" VARCHAR2(150 CHAR),
	"CREATION_DATE" DATE NOT NULL ENABLE,
	"LAST_UPDATED_BY" VARCHAR2(150 CHAR),
	"LAST_UPDATE_DATE" DATE NOT NULL ENABLE,
	"START_DATE" DATE,
	"END_DATE" DATE,
	"POPUP_YN" VARCHAR2(1)
   )
/
-- (종속 INDEX 없음)

   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."NOTICE_ID" IS '공지ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."SUB_MODULE_CODE" IS '보조서비스모듈코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."MODULE_CODE" IS '서비스모듈코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."NOTICE_TITLE" IS '공지제목명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."CYCLE_CLASS_CODE" IS '주기구분코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."DETAIL_CLASS_CODE" IS '주기단위코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."SEND_TIME_TEXT" IS '발신시간내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."VALID_YN" IS '유효여부'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."SQL_LONG_TEXT" IS 'SQL상세내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."CREATED_BY" IS '데이터입력사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."CREATION_DATE" IS '데이터입력일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."LAST_UPDATED_BY" IS '데이터수정사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_NOTICE_MASTER"."LAST_UPDATE_DATE" IS '데이터수정일시'
   COMMENT ON TABLE "SCM_MGR"."SCM_ADM_NOTICE_MASTER"  IS '공지기본'
/
-- (종속 TRIGGER 없음)
-- ===== TABLE : SCM_ADM_USER_M =====

  CREATE TABLE "SCM_MGR"."SCM_ADM_USER_M"
   (	"USER_ID" VARCHAR2(50 CHAR) NOT NULL ENABLE,
	"USER_NM" VARCHAR2(150 CHAR) NOT NULL ENABLE,
	"USER_ENG_NM" VARCHAR2(150 CHAR),
	"USER_EML" VARCHAR2(150 CHAR),
	"DEPT_ID" VARCHAR2(50 CHAR),
	"USER_PHN" VARCHAR2(50 CHAR),
	"USER_HPHN" VARCHAR2(50 CHAR),
	"LANG_CD" VARCHAR2(10 CHAR),
	"ACNT_LOK_YN" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,
	"TMZ_CD" VARCHAR2(100) NOT NULL ENABLE,
	"LOGN_DTM" DATE,
	"USE_YN" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
	"CREATED_BY" VARCHAR2(30 CHAR) NOT NULL ENABLE,
	"CREATION_DATE" DATE NOT NULL ENABLE,
	"LAST_UPDATED_BY" VARCHAR2(30 CHAR) NOT NULL ENABLE,
	"LAST_UPDATE_DATE" DATE NOT NULL ENABLE,
	"N01_ATR_CTN" VARCHAR2(300 CHAR),
	"N02_ATR_CTN" VARCHAR2(300 CHAR),
	"N03_ATR_CTN" VARCHAR2(300 CHAR),
	"N04_ATR_CTN" VARCHAR2(300 CHAR),
	"N05_ATR_CTN" VARCHAR2(300 CHAR),
	"N06_ATR_CTN" VARCHAR2(300 CHAR),
	"N07_ATR_CTN" VARCHAR2(300 CHAR),
	"N08_ATR_CTN" VARCHAR2(300 CHAR),
	"N09_ATR_CTN" VARCHAR2(300 CHAR),
	"N10_ATR_CTN" VARCHAR2(300 CHAR),
	"XLS_PWD" RAW(256),
	"XLS_PWD_CHG_DATE" TIMESTAMP (6),
	"PERM_KEP_CNC_YN" VARCHAR2(1 CHAR) DEFAULT 'N' NOT NULL ENABLE
   )
  CREATE UNIQUE INDEX "SCM_MGR"."PK_SCM_ADM_USER_M" ON "SCM_MGR"."SCM_ADM_USER_M" ("USER_ID")

ALTER TABLE "SCM_MGR"."SCM_ADM_USER_M" ADD CONSTRAINT "PK_SCM_ADM_USER_M" PRIMARY KEY ("USER_ID")
  USING INDEX "SCM_MGR"."PK_SCM_ADM_USER_M"  ENABLE
/

  CREATE UNIQUE INDEX "SCM_MGR"."PK_SCM_ADM_USER_M" ON "SCM_MGR"."SCM_ADM_USER_M" ("USER_ID")

/

   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_ID" IS '사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_NM" IS '사용자명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_ENG_NM" IS '사용자영어명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_EML" IS '사용자이메일'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."DEPT_ID" IS '부서식별ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_PHN" IS '사용자전화번호'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USER_HPHN" IS '사용자휴대전화번호'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."LANG_CD" IS '언어코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."ACNT_LOK_YN" IS '계정잠금여부'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."TMZ_CD" IS '시간대코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."LOGN_DTM" IS '로그인일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."USE_YN" IS '사용여부'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."CREATED_BY" IS '데이터입력사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."CREATION_DATE" IS '데이터입력일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."LAST_UPDATED_BY" IS '데이터수정사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."LAST_UPDATE_DATE" IS '데이터수정일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N01_ATR_CTN" IS '1번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N02_ATR_CTN" IS '2번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N03_ATR_CTN" IS '3번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N04_ATR_CTN" IS '4번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N05_ATR_CTN" IS '5번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N06_ATR_CTN" IS '6번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N07_ATR_CTN" IS '7번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N08_ATR_CTN" IS '8번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N09_ATR_CTN" IS '9번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."N10_ATR_CTN" IS '10번속성내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."XLS_PWD" IS '엑셀비번(엑셀시뮬레이터)'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."XLS_PWD_CHG_DATE" IS '엑셀비번변경일자(엑셀시뮬레이터)'
   COMMENT ON COLUMN "SCM_MGR"."SCM_ADM_USER_M"."PERM_KEP_CNC_YN" IS '영구보관동의여부'
   COMMENT ON TABLE "SCM_MGR"."SCM_ADM_USER_M"  IS 'UI 공통 사용자'
/
-- (종속 TRIGGER 없음)
-- ===== TABLE : SCM_COM_ATCH_FILE_M =====

  CREATE TABLE "SCM_MGR"."SCM_COM_ATCH_FILE_M"
   (	"ATCH_FILE_ID" VARCHAR2(50) DEFAULT SYS_GUID() NOT NULL ENABLE,
	"ATCH_FILE_SAVE_NM" VARCHAR2(500) NOT NULL ENABLE,
	"ATCH_FILE_TP_CD" VARCHAR2(20),
	"ATCH_FILE_KDN_CD" VARCHAR2(10),
	"ATCH_FILE_EFNM_NM" VARCHAR2(100) NOT NULL ENABLE,
	"ATCH_FILE_SIZE" NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE,
	"ATCH_FILE_CTN" BLOB,
	"CREATED_BY" VARCHAR2(30) NOT NULL ENABLE,
	"CREATION_DATE" DATE DEFAULT SYSDATE NOT NULL ENABLE,
	"LAST_UPDATED_BY" VARCHAR2(30) NOT NULL ENABLE,
	"LAST_UPDATE_DATE" DATE DEFAULT SYSDATE NOT NULL ENABLE,
	 CONSTRAINT "SCM_COM_ATCH_FILE_M_PK" PRIMARY KEY ("ATCH_FILE_ID")
  USING INDEX  ENABLE
   )
/

  CREATE UNIQUE INDEX "SCM_MGR"."SCM_COM_ATCH_FILE_M_PK" ON "SCM_MGR"."SCM_COM_ATCH_FILE_M" ("ATCH_FILE_ID")

  CREATE UNIQUE INDEX "SCM_MGR"."SYS_IL0000111684C00007$$" ON "SCM_MGR"."SCM_COM_ATCH_FILE_M"

/

   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_ID" IS '첨부파일ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_SAVE_NM" IS '첨부파일저장명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_TP_CD" IS '첨부파일유형코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_KDN_CD" IS '첨부파일종류코드'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_EFNM_NM" IS '첨부파일확장자명'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_SIZE" IS '첨부파일크기'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."ATCH_FILE_CTN" IS '첨부파일내용'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."CREATED_BY" IS '데이터입력사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."CREATION_DATE" IS '데이터입력일시'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."LAST_UPDATED_BY" IS '데이터수정사용자ID'
   COMMENT ON COLUMN "SCM_MGR"."SCM_COM_ATCH_FILE_M"."LAST_UPDATE_DATE" IS '데이터수정일시'
   COMMENT ON TABLE "SCM_MGR"."SCM_COM_ATCH_FILE_M"  IS '첨부파일정보 마스터'
/
-- (종속 TRIGGER 없음)
-- ===== TABLE : SCM_SYS_LOG_BATCH =====

  CREATE TABLE "SCM_MGR"."SCM_SYS_LOG_BATCH"
   (	"PROGRAM_NAME" VARCHAR2(150 CHAR),
	"LOG_TYPE" VARCHAR2(30 CHAR),
	"LOG_COUNT" NUMBER(10,0),
	"LOG_MESSAGE" VARCHAR2(1000 CHAR),
	"DESCRIPTION" VARCHAR2(1000 CHAR),
	"IN_PARA_DATA" VARCHAR2(2000 CHAR),
	"SQL_ERR_CODE" VARCHAR2(100 CHAR),
	"SQL_ERR_MSG" VARCHAR2(2000 CHAR),
	"SQL_BACKTRACE" VARCHAR2(4000 CHAR),
	"EVENT_DATE" DATE,
	"CREATION_DATE" DATE,
	"CREATED_BY" VARCHAR2(150 CHAR),
	"LAST_UPDATE_DATE" DATE,
	"LAST_UPDATED_BY" VARCHAR2(150 CHAR),
	"ATTRIBUTE1" VARCHAR2(150 CHAR),
	"ATTRIBUTE2" VARCHAR2(150 CHAR),
	"ATTRIBUTE3" VARCHAR2(150 CHAR),
	"ATTRIBUTE4" VARCHAR2(150 CHAR),
	"ATTRIBUTE5" VARCHAR2(150 CHAR),
	"ATTRIBUTE6" VARCHAR2(150 CHAR),
	"ATTRIBUTE7" VARCHAR2(150 CHAR),
	"ATTRIBUTE8" VARCHAR2(150 CHAR),
	"ATTRIBUTE9" VARCHAR2(150 CHAR),
	"ATTRIBUTE10" VARCHAR2(150 CHAR)
   )
/
-- (종속 INDEX 없음)
-- (종속 COMMENT 없음)
-- (종속 TRIGGER 없음)
-- ===== PACKAGE_SPEC : PKG_SYS0016 =====

  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_SYS0016"
/*
 * Program ID   : PKG_SYS0013
 * Description  : PKG_DMF0207
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.24   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
    PROCEDURE P_SYS0016_GET_NOTICE_CONTENT_MASTER
    (
        P_MODULE	       IN  VARCHAR2,
        P_SUB_MODULE	   IN  VARCHAR2,
        P_ACTIVE_YN	 	   IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0016_SAVE_NOTICE_CONTENT_MASTER
    (
        P_DATA           IN  CLOB,
        P_USER_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_SYS0016;
/
-- ===== PACKAGE_BODY : PKG_SYS0016 =====

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_SYS0016"
AS
    PROCEDURE P_SYS0016_GET_NOTICE_CONTENT_MASTER
    (
        P_MODULE         IN  VARCHAR2,
        P_SUB_MODULE     IN  VARCHAR2,
        P_ACTIVE_YN      IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        C_LANGUAGE_CODE CONSTANT VARCHAR2(4 CHAR) := 'EN';
        V_PROC_INPUT    VARCHAR2(4000 CHAR);
        V_BACKTRACE     VARCHAR2(4000 CHAR);
        V_SQL_CODE      VARCHAR2(100 CHAR);
        V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
        N_LOG_COUNT     PLS_INTEGER := 0;
    BEGIN
        OPEN O_RC1 FOR
            SELECT
                   TO_CHAR(A.NOTICE_ID)                 AS NOTICE_ID,
                   A.MODULE_CODE                        AS MODULE,
                   A.MODULE_CODE                        AS MODULE_NM,
                   A.SUB_MODULE_CODE                    AS SUB_MODULE,
                   A.SUB_MODULE_CODE                    AS SUB_MODULE_NM,
                   A.NOTICE_TITLE                       AS NOTICE,
                   A.VALID_YN                           AS ACTIVE,
                   TO_CHAR(A.START_DATE, 'YYYY-MM-DD')  AS START_DATE,
                   TO_CHAR(A.END_DATE, 'YYYY-MM-DD')    AS END_DATE,
                   CASE
                       WHEN A.START_DATE IS NULL AND A.END_DATE IS NULL THEN NULL
                       ELSE NVL(TO_CHAR(A.START_DATE, 'YYYY-MM-DD'), '-')
                            || ' ~ '
                            || NVL(TO_CHAR(A.END_DATE, 'YYYY-MM-DD'), '-')
                   END                                  AS PUBLICATION_PERIOD,
                   A.POPUP_YN                           AS POPUP_YN,
                   A.CYCLE_CLASS_CODE                   AS POPUP_MAIN_CD,
                   A.CYCLE_CLASS_CODE                   AS POPUP_MAIN_NM,
                   A.DETAIL_CLASS_CODE                  AS POPUP_SUB1_CD,
                   A.DETAIL_CLASS_CODE                  AS POPUP_SUB1_NM,
                   A.SEND_TIME_TEXT                     AS POPUP_SUB2_CD,
                   A.SEND_TIME_TEXT                     AS POPUP_SUB2_NM,
                   B.NOTICE_TITLE                       AS NOTICE_TITLE,
                   B.NOTICE_CONTENT                     AS NOTICE_CONTENT,
                   B.NOTICE_IMAGE                       AS NOTICE_IMAGE,
                   F.ATCH_FILE_SAVE_NM                  AS IMAGE_FILE_NM,
                   CAST(NULL AS VARCHAR2(1))            AS IMAGE_DATA,
                   C.USER_NM                            AS CREATED_BY,
                   A.CREATION_DATE						AS CREATION_DATE,
                   CAST(NULL AS VARCHAR2(1))            AS ACTION
              FROM SCM_ADM_NOTICE_MASTER A
              LEFT OUTER JOIN SCM_ADM_NOTICE_CONTENT_MASTER B
                ON B.NOTICE_ID = A.NOTICE_ID
               AND B.LANGUAGE_CODE = C_LANGUAGE_CODE
              LEFT OUTER JOIN SCM_COM_ATCH_FILE_M F
                ON F.ATCH_FILE_ID = B.NOTICE_IMAGE
              LEFT OUTER JOIN SCM_ADM_USER_M C
                ON C.USER_ID = A.CREATED_BY
             WHERE (NVL(P_MODULE, 'ALL') = 'ALL' OR A.MODULE_CODE = P_MODULE)
               AND (NVL(P_SUB_MODULE, 'ALL') = 'ALL' OR A.SUB_MODULE_CODE = P_SUB_MODULE)
               AND (NVL(P_ACTIVE_YN, 'ALL') = 'ALL' OR A.VALID_YN = P_ACTIVE_YN)
             ORDER BY A.MODULE_CODE, A.SUB_MODULE_CODE, A.CREATION_DATE DESC, A.NOTICE_ID DESC;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE,
                   'SUCCESS' AS MSG,
                   CAST(NULL AS VARCHAR2(1)) AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_PROC_INPUT := JSON_OBJECT(
                'P_MODULE' VALUE P_MODULE,
                'P_SUB_MODULE' VALUE P_SUB_MODULE,
                'P_ACTIVE_YN' VALUE P_ACTIVE_YN
            );
            V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                    $$PLSQL_UNIT,
                    'ERROR',
                    N_LOG_COUNT,
                    'EXCEPTION',
                    '',
                    SYSDATE,
                    V_PROC_INPUT,
                    V_SQL_CODE,
                    V_SQL_ERRMSG,
                    V_BACKTRACE
                );
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            RAISE_APPLICATION_ERROR(
                -20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE
                || ' / SQLERRM=' || V_SQL_ERRMSG
                || ' / BACKTRACE=' || V_BACKTRACE
                || ' / PARAMS=' || V_PROC_INPUT
            );
    END P_SYS0016_GET_NOTICE_CONTENT_MASTER;


    PROCEDURE P_SYS0016_SAVE_NOTICE_CONTENT_MASTER
    (
        P_DATA           IN  CLOB,
        P_USER_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        V_SQL_CODE       VARCHAR2(100 CHAR);
        V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
        V_BACKTRACE      VARCHAR2(4000 CHAR);
        V_AFFECTED       NUMBER := 0;
        V_USER           VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
        V_NOTICE_ID      SCM_ADM_NOTICE_MASTER.NOTICE_ID%TYPE;
        V_OLD_FILE_ID    SCM_ADM_NOTICE_CONTENT_MASTER.NOTICE_IMAGE%TYPE;
        V_LANGUAGE_CODE  SCM_ADM_NOTICE_CONTENT_MASTER.LANGUAGE_CODE%TYPE;
    BEGIN
        FOR REC IN (
            SELECT JT.*
              FROM JSON_TABLE(
                       P_DATA,
                       '$[*]'
                       COLUMNS (
                           CRUD_TYPE       VARCHAR2(10)  PATH '$.CRUD_TYPE',
                           NOTICE_ID       NUMBER        PATH '$.NOTICE_ID',
                           MODULE          VARCHAR2(100) PATH '$.MODULE',
                           SUB_MODULE      VARCHAR2(100) PATH '$.SUB_MODULE',
                           NOTICE          VARCHAR2(500) PATH '$.NOTICE',
                           ACTIVE          VARCHAR2(4)   PATH '$.ACTIVE',
                           START_DATE      VARCHAR2(10)  PATH '$.START_DATE',
                           END_DATE        VARCHAR2(10)  PATH '$.END_DATE',
                           POPUP_YN        VARCHAR2(4)   PATH '$.POPUP_YN',
                           LANGUAGE_CODE   VARCHAR2(4)   PATH '$.LANGUAGE_CODE',
                           NOTICE_TITLE    VARCHAR2(500) PATH '$.NOTICE_TITLE',
                           NOTICE_CONTENT  CLOB          PATH '$.NOTICE_CONTENT',
                           NOTICE_IMAGE    VARCHAR2(50)  PATH '$.NOTICE_IMAGE'
                       )
                   ) JT
        ) LOOP
            V_LANGUAGE_CODE := NVL(REC.LANGUAGE_CODE, 'EN');
            V_OLD_FILE_ID := NULL;

            IF REC.CRUD_TYPE = 'I' THEN
                SELECT NVL(MAX(NOTICE_ID), 0) + 1
				INTO V_NOTICE_ID
				FROM SCM_ADM_NOTICE_MASTER;

                INSERT INTO SCM_ADM_NOTICE_MASTER
                (
                    NOTICE_ID,
                    MODULE_CODE,
                    SUB_MODULE_CODE,
                    NOTICE_TITLE,
                    VALID_YN,
                    START_DATE,
                    END_DATE,
                    POPUP_YN,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE
                )
                VALUES
                (
                    V_NOTICE_ID,
                    REC.MODULE,
                    REC.SUB_MODULE,
                    REC.NOTICE,
                    NVL(REC.ACTIVE, 'N'),
                    CASE
                        WHEN REC.START_DATE IS NULL THEN NULL
                        ELSE TO_DATE(REC.START_DATE, 'YYYY-MM-DD')
                    END,
                    CASE
                        WHEN REC.END_DATE IS NULL THEN NULL
                        ELSE TO_DATE(REC.END_DATE, 'YYYY-MM-DD')
                    END,
                    NVL(REC.POPUP_YN, 'N'),
                    V_USER,
                    SYSDATE,
                    V_USER,
                    SYSDATE
                );

                INSERT INTO SCM_ADM_NOTICE_CONTENT_MASTER
                (
                    NOTICE_ID,
                    LANGUAGE_CODE,
                    NOTICE_TITLE,
                    NOTICE_CONTENT,
                    NOTICE_IMAGE,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE
                )
                VALUES
                (
                    V_NOTICE_ID,
                    V_LANGUAGE_CODE,
                    REC.NOTICE_TITLE,
                    REC.NOTICE_CONTENT,
                    REC.NOTICE_IMAGE,
                    V_USER,
                    SYSDATE,
                    V_USER,
                    SYSDATE
                );

                V_AFFECTED := V_AFFECTED + 1;

            ELSIF REC.CRUD_TYPE = 'M' THEN
                UPDATE SCM_ADM_NOTICE_MASTER
                   SET MODULE_CODE       = REC.MODULE,
                       SUB_MODULE_CODE   = REC.SUB_MODULE,
                       NOTICE_TITLE      = REC.NOTICE,
                       VALID_YN          = NVL(REC.ACTIVE, VALID_YN),
                       START_DATE        = CASE
                                               WHEN REC.START_DATE IS NULL THEN NULL
                                               ELSE TO_DATE(REC.START_DATE, 'YYYY-MM-DD')
                                           END,
                       END_DATE          = CASE
                                               WHEN REC.END_DATE IS NULL THEN NULL
                                               ELSE TO_DATE(REC.END_DATE, 'YYYY-MM-DD')
                                           END,
                       POPUP_YN          = NVL(REC.POPUP_YN, POPUP_YN),
                       LAST_UPDATED_BY   = V_USER,
                       LAST_UPDATE_DATE  = SYSDATE
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                IF SQL%ROWCOUNT > 0 THEN
                    V_AFFECTED := V_AFFECTED + 1;

                    BEGIN
                        SELECT NOTICE_IMAGE
                          INTO V_OLD_FILE_ID
                          FROM SCM_ADM_NOTICE_CONTENT_MASTER
                         WHERE NOTICE_ID = REC.NOTICE_ID
                           AND LANGUAGE_CODE = V_LANGUAGE_CODE
                         FOR UPDATE;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_OLD_FILE_ID := NULL;
                    END;

                    UPDATE SCM_ADM_NOTICE_CONTENT_MASTER
                       SET NOTICE_TITLE    = REC.NOTICE_TITLE,
                           NOTICE_CONTENT  = REC.NOTICE_CONTENT,
                           NOTICE_IMAGE    = REC.NOTICE_IMAGE,
                           LAST_UPDATED_BY = V_USER,
                           LAST_UPDATE_DATE = SYSDATE
                     WHERE NOTICE_ID = REC.NOTICE_ID
                       AND LANGUAGE_CODE = V_LANGUAGE_CODE;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCM_ADM_NOTICE_CONTENT_MASTER
                        (
                            NOTICE_ID,
                            LANGUAGE_CODE,
                            NOTICE_TITLE,
                            NOTICE_CONTENT,
                            NOTICE_IMAGE,
                            CREATED_BY,
                            CREATION_DATE,
                            LAST_UPDATED_BY,
                            LAST_UPDATE_DATE
                        )
                        VALUES
                        (
                            REC.NOTICE_ID,
                            V_LANGUAGE_CODE,
                            REC.NOTICE_TITLE,
                            REC.NOTICE_CONTENT,
                            REC.NOTICE_IMAGE,
                            V_USER,
                            SYSDATE,
                            V_USER,
                            SYSDATE
                        );
                    END IF;

                    IF V_OLD_FILE_ID IS NOT NULL
                       AND V_OLD_FILE_ID <> NVL(REC.NOTICE_IMAGE, '#') THEN
                        DELETE FROM SCM_COM_ATCH_FILE_M F
                         WHERE F.ATCH_FILE_ID = V_OLD_FILE_ID
                           AND F.ATCH_FILE_KDN_CD = 'NOTICE'
                           AND NOT EXISTS (
                               SELECT 1
                                 FROM SCM_ADM_NOTICE_CONTENT_MASTER C
                                WHERE C.NOTICE_IMAGE = V_OLD_FILE_ID
                           );
                    END IF;
                END IF;

            ELSIF REC.CRUD_TYPE = 'D' THEN
                DELETE FROM SCM_ADM_NOTICE_CONTENT_MASTER
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                DELETE FROM SCM_ADM_NOTICE_MASTER
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
            END IF;
        END LOOP;

        OPEN O_RC1 FOR
            SELECT V_AFFECTED AS AFFECTED
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE,
                   'SUCCESS' AS MSG,
                   CAST(NULL AS VARCHAR2(1)) AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            RAISE_APPLICATION_ERROR(
                -20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE
                || ' / SQLERRM=' || V_SQL_ERRMSG
                || ' / BACKTRACE=' || V_BACKTRACE
            );
    END P_SYS0016_SAVE_NOTICE_CONTENT_MASTER;
END PKG_SYS0016;
/
-- ===== PROCEDURE : PR_SCM_SYS_LOG_BATCH =====

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_SCM_SYS_LOG_BATCH"
(
    p_program_name   in varchar2,
    p_log_type       in varchar2,
    p_log_count      in number,
    p_log_message    in varchar2,
    p_description    in varchar2,
    p_event_date     in date     default sysdate,
    p_in_para_data   in varchar2 default null,
    p_sql_err_code   in varchar2 default null,
    p_sql_err_msg    in varchar2 default null,
    p_sql_backtrace  in varchar2 default null
)
IS
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.03.03       jcnam     [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    pragma autonomous_transaction;

    c_prog_name_len  constant pls_integer := 150;
    c_log_type_len   constant pls_integer := 30;
    c_log_msg_len    constant pls_integer := 1000;
    c_desc_len       constant pls_integer := 1000;
    c_in_para_len    constant pls_integer := 2000;
    c_err_code_len   constant pls_integer := 100;
    c_err_msg_len    constant pls_integer := 2000;
    c_backtrace_len  constant pls_integer := 4000;
    c_created_by_len constant pls_integer := 150;

    v_in_para_data varchar2(4000);
    v_sql_code     varchar2(100);
    v_sql_errmsg   varchar2(2000);
    v_backtrace    varchar2(4000);
    v_created_by   varchar2(150) := 'scm_batch';

begin

    -- 정상 흐름
    v_in_para_data := substr(p_in_para_data, 1, c_in_para_len);

    insert into scm_sys_log_batch
    (
        program_name,
        log_type,
        log_count,
        log_message,
        description,
        in_para_data,
        sql_err_code,
        sql_err_msg,
        sql_backtrace,
        event_date,
        creation_date,
        created_by,
        last_update_date,
        last_updated_by
    )
    values
    (
        substr(p_program_name, 1, c_prog_name_len),
        substr(p_log_type,     1, c_log_type_len),
        p_log_count,
        substr(p_log_message,  1, c_log_msg_len),
        substr(p_description,  1, c_desc_len),
        v_in_para_data,
        substr(p_sql_err_code, 1, c_err_code_len),
        substr(p_sql_err_msg,  1, c_err_msg_len),
        substr(p_sql_backtrace,1, c_backtrace_len),
        nvl(p_event_date, sysdate),
        sysdate,
        substr(v_created_by, 1, c_created_by_len),
        sysdate,
        substr(v_created_by, 1, c_created_by_len)
    );

    commit;

exception
    when others then
        rollback;

        -- 예외 시: 프로시저 입력값을 JSON으로 저장
        v_in_para_data :=
            json_object(
                'p_program_name'   value substr(p_program_name, 1, c_prog_name_len),
                'p_log_type'       value substr(p_log_type,     1, c_log_type_len),
                'p_log_count'      value p_log_count,
                'p_log_message'    value substr(p_log_message,  1, c_log_msg_len),
                'p_description'    value substr(p_description,  1, c_desc_len),
                'p_event_date'     value to_char(nvl(p_event_date, sysdate), 'yyyy-mm-dd hh24:mi:ss'),
                'p_in_para_data'   value substr(p_in_para_data, 1, c_in_para_len),
                'p_sql_err_code'   value substr(p_sql_err_code, 1, c_err_code_len),
                'p_sql_err_msg'    value substr(p_sql_err_msg,  1, c_err_msg_len),
                'p_sql_backtrace'  value substr(p_sql_backtrace,1, c_backtrace_len)
                returning varchar2(4000)
            );

        v_sql_code   := substr(to_char(sqlcode), 1, c_err_code_len);
        v_sql_errmsg := substr(sqlerrm,         1, c_err_msg_len);
        v_backtrace  := substr(dbms_utility.format_error_backtrace, 1, c_backtrace_len);

        insert into scm_sys_log_batch
        (
            program_name,
            log_type,
            log_count,
            log_message,
            description,
            in_para_data,
            sql_err_code,
            sql_err_msg,
            sql_backtrace,
            event_date,
            creation_date,
            created_by,
            last_update_date,
            last_updated_by
        )
        values
        (
            substr(p_program_name, 1, c_prog_name_len),
            'error',
            null,
            null,
            null,
            v_in_para_data,
            v_sql_code,
            v_sql_errmsg,
            v_backtrace,
            sysdate,
            sysdate,
            substr(v_created_by, 1, c_created_by_len),
            sysdate,
            substr(v_created_by, 1, c_created_by_len)
        );

        commit;

end pr_scm_sys_log_batch;
/
-- ===== 추출 끝 (총 8 객체 / 폐포 유일 7 / 깊이 3) =====

