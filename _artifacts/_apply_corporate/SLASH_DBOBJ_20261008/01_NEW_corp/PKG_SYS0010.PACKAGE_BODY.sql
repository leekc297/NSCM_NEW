PACKAGE BODY PKG_SYS0010 
AS

	PROCEDURE P_SYS0010_GET_LOOKUP_MASTER (
      P_LOOKUP_TYPE   IN  VARCHAR2
    , P_LOOKUP_GROUP  IN  VARCHAR2
    , P_VALID_YN      IN  VARCHAR2
    , O_RC1           OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
	)
/*
 * Program ID   : P_SYS0010_GET_LOOKUP_MASTER
 * Description  : Lookup Master 조회(AS-IS : SCM0003_GET_LOOKUP_MASTER)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.04.13   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

IS
		--V_ERR_MSG 	VARCHAR2(4000);

	BEGIN
    OPEN O_RC1 FOR
        SELECT
              LOOKUP_TYPE AS LOOKUP_TYPE_KEY
            , LOOKUP_TYPE
            , DESCRIPTION
            , LOOKUP_GROUP
            , VALID_YN
            , SEGMENT1
            , SEGMENT2
            , SEGMENT3
            , SEGMENT4
            , SEGMENT5
            , ATTRIBUTE1
            , ATTRIBUTE2
            , ATTRIBUTE3
            , ATTRIBUTE4
            , ATTRIBUTE5
            , ATTRIBUTE6
            , ATTRIBUTE7
            , ATTRIBUTE8
            , ATTRIBUTE9
            , ATTRIBUTE10
            , ATTRIBUTE11
            , ATTRIBUTE12
            , ATTRIBUTE13
            , ATTRIBUTE14
            , ATTRIBUTE15
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
--        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER
        FROM SCM_ADM_LOOKUP_MASTER                                                                          -- 2026.09.17 AJS
        WHERE (TRIM(P_LOOKUP_TYPE)  IS NULL OR UPPER(LOOKUP_TYPE)  LIKE '%' || UPPER(TRIM(P_LOOKUP_TYPE)) || '%')
--          AND (TRIM(P_LOOKUP_GROUP) IS NULL OR LOOKUP_GROUP = TRIM(P_LOOKUP_GROUP))
--          AND (TRIM(P_VALID_YN)     IS NULL OR VALID_YN     = TRIM(P_VALID_YN))
          AND (TRIM(P_LOOKUP_GROUP) IS NULL OR LOOKUP_GROUP = UPPER(TRIM(P_LOOKUP_GROUP)))                  -- 2026.09.17 AJS
          AND (TRIM(P_VALID_YN)     IS NULL OR VALID_YN     = UPPER(TRIM(P_VALID_YN)))                      -- 2026.09.17 AJS
--        ORDER BY LOOKUP_TYPE;
        -- 2026.09.17 AJS AS-IS 정렬 기준 (START)
        ORDER BY UPPER(REPLACE(REPLACE(LOOKUP_TYPE, '-', ''), '_', '/' || CHR(127)))
               , LENGTH(LOOKUP_TYPE)
               , LOOKUP_TYPE;
        -- 2026.09.17 AJS AS-IS 정렬 기준 (END)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT
        FROM DUAL;

		EXCEPTION
		    WHEN OTHERS THEN
		        ROLLBACK;
		        RAISE_APPLICATION_ERROR(-20001,
		        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
		        ' / SQLERRM=' || SQLERRM ||
		        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
		        ' / PARAMS=' || '-' );

	END P_SYS0010_GET_LOOKUP_MASTER;

  PROCEDURE P_SYS0010_GET_LOOKUP_MASTER_DETAIL (
      P_LOOKUP_TYPE   IN  VARCHAR2
    , O_RC1           OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
/*
 * Program ID   : P_SYS0010_GET_LOOKUP_MASTER_DETAIL
 * Description  : Lookup Value 조회(AS-IS : SCM0003_GET_LOOKUP_MASTER_DETAIL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021/05/26   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 공유잠금 해제 옵션 추가
 * 2026.04.21   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

IS
    --V_ERR_MSG   VARCHAR2(4000);

  BEGIN
    OPEN O_RC1 FOR
        SELECT
              LOOKUP_TYPE
            , DESCRIPTION
            , DISPLAY_SEQ
            , VALID_YN
            , SEGMENT1
            , SEGMENT2
            , SEGMENT3
            , SEGMENT4
            , SEGMENT5
            , ATTRIBUTE1
            , ATTRIBUTE2
            , ATTRIBUTE3
            , ATTRIBUTE4
            , ATTRIBUTE5
            , ATTRIBUTE6
            , ATTRIBUTE7
            , ATTRIBUTE8
            , ATTRIBUTE9
            , ATTRIBUTE10
            , ATTRIBUTE11
            , ATTRIBUTE12
            , ATTRIBUTE13
            , ATTRIBUTE14
            , ATTRIBUTE15
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
--        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL                                                                   -- 2026.09.17 AJS
        WHERE (TRIM(P_LOOKUP_TYPE)  IS NULL OR LOOKUP_TYPE = TRIM(P_LOOKUP_TYPE) )
--        ORDER BY DISPLAY_SEQ;
        -- 2026.09.17 AJS AS-IS 정렬 기준(표시순서 빈 값 먼저) (START)
        ORDER BY DISPLAY_SEQ NULLS FIRST
               , SEGMENT1
               , SEGMENT2
               , SEGMENT3
               , SEGMENT4
               , SEGMENT5;
        -- 2026.09.17 AJS AS-IS 정렬 기준(표시순서 빈 값 먼저) (END)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT
        FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-' );

  END P_SYS0010_GET_LOOKUP_MASTER_DETAIL;

  PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER (
      P_DATA         IN CLOB
    , P_USER_ID      IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  )
/*
 * Program ID   : P_SYS0010_SAVE_LOOKUP_MASTER
 * Description  : Lookup Type 등록, 수정(AS-IS : SCM0003_SAVE_LOOKUP_MASTER)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017/12/07   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/01/29	hwyoon			[PS02199094B] GSCM(DM/SCP) SM운영/유지보수 LTRIM, RTRIM 적용
 * 2026.04.21   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 * 2026.06.23	byunmj0223		MultiRow 등록, 수정을 위하여 LOOP문 적용
 */
  IS
      V_ACTIVE_FLAG      VARCHAR2(1);
      V_LOOKUP_TYPE_KEY  VARCHAR2(200);
      V_LOOKUP_TYPE      VARCHAR2(200);
      V_DESCRIPTION      VARCHAR2(1000);
      V_LOOKUP_GROUP     VARCHAR2(200);
      V_VALID_YN         VARCHAR2(2);
      V_SEGMENT1         VARCHAR2(100);
      V_SEGMENT2         VARCHAR2(100);
      V_SEGMENT3         VARCHAR2(100);
      V_SEGMENT4         VARCHAR2(100);
      V_SEGMENT5         VARCHAR2(100);
--      V_ATTRIBUTE1       VARCHAR2(100);
      V_ATTRIBUTE1       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE2       VARCHAR2(100);
      V_ATTRIBUTE2       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE3       VARCHAR2(100);
      V_ATTRIBUTE3       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE4       VARCHAR2(100);
      V_ATTRIBUTE4       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE5       VARCHAR2(100);
      V_ATTRIBUTE5       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE6       VARCHAR2(100);
      V_ATTRIBUTE6       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE7       VARCHAR2(100);
      V_ATTRIBUTE7       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE8       VARCHAR2(100);
      V_ATTRIBUTE8       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE9       VARCHAR2(100);
      V_ATTRIBUTE9       VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE10      VARCHAR2(100);
      V_ATTRIBUTE10      VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE11      VARCHAR2(100);
      V_ATTRIBUTE11      VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE12      VARCHAR2(100);
      V_ATTRIBUTE12      VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE13      VARCHAR2(100);
      V_ATTRIBUTE13      VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE14      VARCHAR2(100);
      V_ATTRIBUTE14      VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE15      VARCHAR2(100);
      V_ATTRIBUTE15      VARCHAR2(150);   -- 2026.09.17 AJS
      --V_CREATED_BY       VARCHAR2(300);
      --V_CREATION_DATE    DATE;
      --V_LAST_UPDATED_BY  VARCHAR2(300);
      --V_CREATION_DATE_STR VARCHAR2(30);

      V_PROGRAM_NAME     VARCHAR2(150) := 'SCM0003_SAVE_LOOKUP_MASTER';
      V_LOG_TYPE         VARCHAR2(30);
      N_LOG_COUNT        NUMBER := 0;
      V_LOG_MESSAGE      VARCHAR2(1000);
      V_LOG_DESC         VARCHAR2(500);
      D_EVENT_DATE       DATE;


      V_RESULT_CURSOR    SYS_REFCURSOR;
      V_CODE           VARCHAR2(10);
      V_MSG            VARCHAR2(4000);
      V_EVENT          VARCHAR2(100);



  BEGIN
      -- 2026.09.17 AJS 저장 시작 지점 · 이력 1회 기록 (START)
      SAVEPOINT SP_SYS0010_SAVE_M;

      P_SYS0010_SAVE_LOOKUP_MASTER_HIST(P_DATA, P_USER_ID, V_RESULT_CURSOR);

      FETCH V_RESULT_CURSOR INTO V_CODE, V_MSG, V_EVENT;
      CLOSE V_RESULT_CURSOR;
      -- 2026.09.17 AJS 저장 시작 지점 · 이력 1회 기록 (END)

      -- JSON -> 변수 매핑
	  FOR JT IN (
	      SELECT
	            JT.CRUD_TYPE AS V_ACTIVE_FLAG
	          , JT.LOOKUP_TYPE_KEY AS V_LOOKUP_TYPE_KEY
	          , JT.LOOKUP_TYPE AS V_LOOKUP_TYPE
	          , JT.DESCRIPTION AS V_DESCRIPTION
	          , JT.LOOKUP_GROUP AS V_LOOKUP_GROUP
	          , JT.VALID_YN AS V_VALID_YN
	          , NVL(TRIM(JT.SEGMENT1), '/') AS V_SEGMENT1
	          , NVL(TRIM(JT.SEGMENT2), '/') AS V_SEGMENT2
	          , NVL(TRIM(JT.SEGMENT3), '/') AS V_SEGMENT3
	          , NVL(TRIM(JT.SEGMENT4), '/') AS V_SEGMENT4
	          , NVL(TRIM(JT.SEGMENT5), '/') AS V_SEGMENT5
	          , JT.ATTRIBUTE1 AS V_ATTRIBUTE1
	          , JT.ATTRIBUTE2 AS V_ATTRIBUTE2
	          , JT.ATTRIBUTE3 AS V_ATTRIBUTE3
	          , JT.ATTRIBUTE4 AS V_ATTRIBUTE4
	          , JT.ATTRIBUTE5 AS V_ATTRIBUTE5
	          , JT.ATTRIBUTE6 AS V_ATTRIBUTE6
	          , JT.ATTRIBUTE7 AS V_ATTRIBUTE7
	          , JT.ATTRIBUTE8 AS V_ATTRIBUTE8
	          , JT.ATTRIBUTE9 AS V_ATTRIBUTE9
	          , JT.ATTRIBUTE10 AS V_ATTRIBUTE10
	          , JT.ATTRIBUTE11 AS V_ATTRIBUTE11
	          , JT.ATTRIBUTE12 AS V_ATTRIBUTE12
	          , JT.ATTRIBUTE13 AS V_ATTRIBUTE13
	          , JT.ATTRIBUTE14 AS V_ATTRIBUTE14
	          , JT.ATTRIBUTE15 AS V_ATTRIBUTE15	          
	      FROM JSON_TABLE(
	          P_DATA
	        , '$[*]'
	          -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (START)
--	          COLUMNS (
--	                CRUD_TYPE          VARCHAR2(1)    PATH '$.CRUD_TYPE'
--	              , LOOKUP_TYPE_KEY    VARCHAR2(200)  PATH '$.LOOKUP_TYPE_KEY'
--	              , LOOKUP_TYPE        VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
--	              , DESCRIPTION        VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY NULL ON ERROR
--	              , LOOKUP_GROUP       VARCHAR2(200)  PATH '$.LOOKUP_GROUP'
--	              , VALID_YN           VARCHAR2(2)    PATH '$.VALID_YN'
--	              , SEGMENT1           VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY NULL ON ERROR
--	              , SEGMENT2           VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY NULL ON ERROR
--	              , SEGMENT3           VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY NULL ON ERROR
--	              , SEGMENT4           VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY NULL ON ERROR
--	              , SEGMENT5           VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE1         VARCHAR2(100)  PATH '$.ATTRIBUTE1' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE2         VARCHAR2(100)  PATH '$.ATTRIBUTE2' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE3         VARCHAR2(100)  PATH '$.ATTRIBUTE3' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE4         VARCHAR2(100)  PATH '$.ATTRIBUTE4' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE5         VARCHAR2(100)  PATH '$.ATTRIBUTE5' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE6         VARCHAR2(100)  PATH '$.ATTRIBUTE6' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE7         VARCHAR2(100)  PATH '$.ATTRIBUTE7' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE8         VARCHAR2(100)  PATH '$.ATTRIBUTE8' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE9         VARCHAR2(100)  PATH '$.ATTRIBUTE9' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE10        VARCHAR2(100)  PATH '$.ATTRIBUTE10' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE11        VARCHAR2(100)  PATH '$.ATTRIBUTE11' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE12        VARCHAR2(100)  PATH '$.ATTRIBUTE12' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE13        VARCHAR2(100)  PATH '$.ATTRIBUTE13' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE14        VARCHAR2(100)  PATH '$.ATTRIBUTE14' NULL ON EMPTY NULL ON ERROR
--	              , ATTRIBUTE15        VARCHAR2(100)  PATH '$.ATTRIBUTE15' NULL ON EMPTY NULL ON ERROR
--	              --, CREATED_BY         VARCHAR2(300)  PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
--	              --, CREATION_DATE_STR  VARCHAR2(30)   PATH '$.CREATION_DATE' NULL ON EMPTY NULL ON ERROR
--	              --, LAST_UPDATED_BY    VARCHAR2(300)  PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
--	          )
	          COLUMNS (
	                CRUD_TYPE          VARCHAR2(1)    PATH '$.CRUD_TYPE'
	              , LOOKUP_TYPE_KEY    VARCHAR2(200)  PATH '$.LOOKUP_TYPE_KEY'
	              , LOOKUP_TYPE        VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
	              , DESCRIPTION        VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY ERROR ON ERROR
	              , LOOKUP_GROUP       VARCHAR2(200)  PATH '$.LOOKUP_GROUP'
	              , VALID_YN           VARCHAR2(2)    PATH '$.VALID_YN'
	              , SEGMENT1           VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY ERROR ON ERROR
	              , SEGMENT2           VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY ERROR ON ERROR
	              , SEGMENT3           VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY ERROR ON ERROR
	              , SEGMENT4           VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY ERROR ON ERROR
	              , SEGMENT5           VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE1         VARCHAR2(150)  PATH '$.ATTRIBUTE1' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE2         VARCHAR2(150)  PATH '$.ATTRIBUTE2' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE3         VARCHAR2(150)  PATH '$.ATTRIBUTE3' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE4         VARCHAR2(150)  PATH '$.ATTRIBUTE4' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE5         VARCHAR2(150)  PATH '$.ATTRIBUTE5' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE6         VARCHAR2(150)  PATH '$.ATTRIBUTE6' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE7         VARCHAR2(150)  PATH '$.ATTRIBUTE7' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE8         VARCHAR2(150)  PATH '$.ATTRIBUTE8' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE9         VARCHAR2(150)  PATH '$.ATTRIBUTE9' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE10        VARCHAR2(150)  PATH '$.ATTRIBUTE10' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE11        VARCHAR2(150)  PATH '$.ATTRIBUTE11' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE12        VARCHAR2(150)  PATH '$.ATTRIBUTE12' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE13        VARCHAR2(150)  PATH '$.ATTRIBUTE13' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE14        VARCHAR2(150)  PATH '$.ATTRIBUTE14' NULL ON EMPTY ERROR ON ERROR
	              , ATTRIBUTE15        VARCHAR2(150)  PATH '$.ATTRIBUTE15' NULL ON EMPTY ERROR ON ERROR
	              --, CREATED_BY         VARCHAR2(300)  PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
	              --, CREATION_DATE_STR  VARCHAR2(30)   PATH '$.CREATION_DATE' NULL ON EMPTY NULL ON ERROR
	              --, LAST_UPDATED_BY    VARCHAR2(300)  PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
	          )
	          -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (END)
	      ) JT
	  ) LOOP

	  V_ACTIVE_FLAG := NVL(TRIM(JT.V_ACTIVE_FLAG), '');	  
      V_LOOKUP_TYPE_KEY := NVL(TRIM(JT.V_LOOKUP_TYPE_KEY), '');
      V_LOOKUP_TYPE     := NVL(TRIM(JT.V_LOOKUP_TYPE), '');
	  V_DESCRIPTION		:= NVL(TRIM(JT.V_DESCRIPTION), '');
	  V_LOOKUP_GROUP	:= NVL(TRIM(JT.V_LOOKUP_GROUP), '');
	  V_VALID_YN		:= NVL(TRIM(JT.V_VALID_YN), '');
      V_SEGMENT1        := NVL(TRIM(JT.V_SEGMENT1), '');
      V_SEGMENT2        := NVL(TRIM(JT.V_SEGMENT2), '');
      V_SEGMENT3        := NVL(TRIM(JT.V_SEGMENT3), '');
      V_SEGMENT4        := NVL(TRIM(JT.V_SEGMENT4), '');
      V_SEGMENT5        := NVL(TRIM(JT.V_SEGMENT5), '');
	  V_ATTRIBUTE1      := NVL(TRIM(JT.V_ATTRIBUTE1), ''); 
	  V_ATTRIBUTE2      := NVL(TRIM(JT.V_ATTRIBUTE2), '');
	  V_ATTRIBUTE3      := NVL(TRIM(JT.V_ATTRIBUTE3), '');
	  V_ATTRIBUTE4      := NVL(TRIM(JT.V_ATTRIBUTE4), '');
	  V_ATTRIBUTE5      := NVL(TRIM(JT.V_ATTRIBUTE5), '');
	  V_ATTRIBUTE6      := NVL(TRIM(JT.V_ATTRIBUTE6), '');
	  V_ATTRIBUTE7      := NVL(TRIM(JT.V_ATTRIBUTE7), '');
	  V_ATTRIBUTE8      := NVL(TRIM(JT.V_ATTRIBUTE8), '');
	  V_ATTRIBUTE9      := NVL(TRIM(JT.V_ATTRIBUTE9), '');
	  V_ATTRIBUTE10      := NVL(TRIM(JT.V_ATTRIBUTE10), '');
	  V_ATTRIBUTE11      := NVL(TRIM(JT.V_ATTRIBUTE11), '');
	  V_ATTRIBUTE12      := NVL(TRIM(JT.V_ATTRIBUTE12), '');
	  V_ATTRIBUTE13      := NVL(TRIM(JT.V_ATTRIBUTE13), '');
	  V_ATTRIBUTE14      := NVL(TRIM(JT.V_ATTRIBUTE14), '');
	  V_ATTRIBUTE15      := NVL(TRIM(JT.V_ATTRIBUTE15), '');

      /*
      IF V_CREATION_DATE_STR IS NOT NULL THEN
          V_CREATION_DATE := TO_DATE(V_CREATION_DATE_STR, 'YYYY-MM-DD HH24:MI:SS');
      ELSE
          V_CREATION_DATE := SYSDATE;
      END IF;
      */
      V_LOG_TYPE    := 'START';
      V_LOG_MESSAGE := '########## Start of procedure ##########';
      V_LOG_DESC    := '';
      D_EVENT_DATE  := SYSDATE;

      PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);

      -- 2026.09.17 AJS 행마다 전체 이력 재기록 제거 (START)
--      P_SYS0010_SAVE_LOOKUP_MASTER_HIST(P_DATA, P_USER_ID, V_RESULT_CURSOR );
--
--      -- 결과 커서 읽기
--      FETCH V_RESULT_CURSOR INTO V_CODE, V_MSG, V_EVENT;
--      CLOSE V_RESULT_CURSOR;
--
--      DBMS_OUTPUT.PUT_LINE('CODE=' || V_CODE || ', MSG=' || V_MSG || ', EVENT=' || V_EVENT);
      -- 2026.09.17 AJS 행마다 전체 이력 재기록 제거 (END)

      PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);

      IF V_ACTIVE_FLAG = 'I' THEN
          INSERT INTO SCM_ADM_LOOKUP_MASTER (
                LOOKUP_TYPE
              , DESCRIPTION
              , LOOKUP_GROUP
              , VALID_YN
              , SEGMENT1
              , SEGMENT2
              , SEGMENT3
              , SEGMENT4
              , SEGMENT5
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE11
              , ATTRIBUTE12
              , ATTRIBUTE13
              , ATTRIBUTE14
              , ATTRIBUTE15
          ) VALUES (
                V_LOOKUP_TYPE
              , V_DESCRIPTION
              , V_LOOKUP_GROUP
              , V_VALID_YN
              , V_SEGMENT1
              , V_SEGMENT2
              , V_SEGMENT3
              , V_SEGMENT4
              , V_SEGMENT5
              , P_USER_ID
              , SYSDATE
              , P_USER_ID
              , SYSDATE
              , V_ATTRIBUTE1
              , V_ATTRIBUTE2
              , V_ATTRIBUTE3
              , V_ATTRIBUTE4
              , V_ATTRIBUTE5
              , V_ATTRIBUTE6
              , V_ATTRIBUTE7
              , V_ATTRIBUTE8
              , V_ATTRIBUTE9
              , V_ATTRIBUTE10
              , V_ATTRIBUTE11
              , V_ATTRIBUTE12
              , V_ATTRIBUTE13
              , V_ATTRIBUTE14
              , V_ATTRIBUTE15
          );
      
      ELSIF V_ACTIVE_FLAG = 'D' THEN
          /* 삭제 — 기존에는 'D' 가 아래 ELSE 의 UPDATE 로 흘러가 행이 지워지지 않았다.
             키는 UPDATE 와 동일하게 V_LOOKUP_TYPE_KEY(조회 SP 가 내려준 원본 이름)를 쓴다. */
          DELETE FROM SCM_ADM_LOOKUP_MASTER
          	WHERE LOOKUP_TYPE = V_LOOKUP_TYPE_KEY;

          DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
       		WHERE LOOKUP_TYPE = V_LOOKUP_TYPE_KEY;
          
          N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;
          
      ELSE
          UPDATE SCM_ADM_LOOKUP_MASTER
             SET LOOKUP_TYPE      = V_LOOKUP_TYPE
               , DESCRIPTION      = V_DESCRIPTION
               , LOOKUP_GROUP     = V_LOOKUP_GROUP
               , VALID_YN         = V_VALID_YN
               , SEGMENT1         = V_SEGMENT1
               , SEGMENT2         = V_SEGMENT2
               , SEGMENT3         = V_SEGMENT3
               , SEGMENT4         = V_SEGMENT4
               , SEGMENT5         = V_SEGMENT5
               , LAST_UPDATED_BY  = P_USER_ID
               , LAST_UPDATE_DATE = SYSDATE
               , ATTRIBUTE1       = V_ATTRIBUTE1
               , ATTRIBUTE2       = V_ATTRIBUTE2
               , ATTRIBUTE3       = V_ATTRIBUTE3
               , ATTRIBUTE4       = V_ATTRIBUTE4
               , ATTRIBUTE5       = V_ATTRIBUTE5
               , ATTRIBUTE6       = V_ATTRIBUTE6
               , ATTRIBUTE7       = V_ATTRIBUTE7
               , ATTRIBUTE8       = V_ATTRIBUTE8
               , ATTRIBUTE9       = V_ATTRIBUTE9
               , ATTRIBUTE10      = V_ATTRIBUTE10
               , ATTRIBUTE11      = V_ATTRIBUTE11
               , ATTRIBUTE12      = V_ATTRIBUTE12
               , ATTRIBUTE13      = V_ATTRIBUTE13
               , ATTRIBUTE14      = V_ATTRIBUTE14
               , ATTRIBUTE15      = V_ATTRIBUTE15
           WHERE LOOKUP_TYPE = V_LOOKUP_TYPE_KEY;

           N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;

          IF V_LOOKUP_TYPE_KEY <> V_LOOKUP_TYPE THEN
              UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                 SET LOOKUP_TYPE = V_LOOKUP_TYPE
               WHERE LOOKUP_TYPE = V_LOOKUP_TYPE_KEY;
          END IF;
      END IF;
  	END LOOP;    

  	COMMIT;

  	V_LOG_TYPE    := 'END';
  	V_LOG_MESSAGE := '########## END of procedure ##########';
  	V_LOG_DESC    := '';
  	D_EVENT_DATE  := SYSDATE;

  	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

  EXCEPTION
      WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SQLERRM;
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        -- 2026.09.17 AJS 오류 시 저장분 되돌리기 (START)
        BEGIN
            ROLLBACK TO SAVEPOINT SP_SYS0010_SAVE_M;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        -- 2026.09.17 AJS 오류 시 저장분 되돌리기 (END)

        PR_SCM_SYS_LOG_BATCH(
            V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE
        );

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_LOG_DESC ||
        ' / SQLERRM=' || V_LOG_MESSAGE ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

  END P_SYS0010_SAVE_LOOKUP_MASTER;

  PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_HIST (
      P_DATA         IN CLOB
    , P_USER_ID      IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  )
/*
 * Program ID   : P_SYS0010_SAVE_LOOKUP_MASTER_HIST
 * Description  : Lookup Type History(AS-IS : PR_SCM_ADM_LOOKUP_MASTER_HIST)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017.12.15   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.04.21   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 * 2026.06.23	byunmj0223		MultiRow 등록, 수정을 위하여 LOOP문 적용
 */
  IS
--      V_LOOKUP_TYPE        NVARCHAR2(200);
      V_LOOKUP_TYPE        VARCHAR2(200);   -- 2026.09.17 AJS
--      V_DESCRIPTION        NVARCHAR2(1000);
      V_DESCRIPTION        VARCHAR2(1000);   -- 2026.09.17 AJS
--      V_LOOKUP_GROUP       NVARCHAR2(200);
      V_LOOKUP_GROUP       VARCHAR2(200);   -- 2026.09.17 AJS
--      V_VALID_YN           NVARCHAR2(2);
      V_VALID_YN           VARCHAR2(2);   -- 2026.09.17 AJS
--      V_SEGMENT1           NVARCHAR2(100);
      V_SEGMENT1           VARCHAR2(100);   -- 2026.09.17 AJS
--      V_SEGMENT2           NVARCHAR2(100);
      V_SEGMENT2           VARCHAR2(100);   -- 2026.09.17 AJS
--      V_SEGMENT3           NVARCHAR2(100);
      V_SEGMENT3           VARCHAR2(100);   -- 2026.09.17 AJS
--      V_SEGMENT4           NVARCHAR2(100);
      V_SEGMENT4           VARCHAR2(100);   -- 2026.09.17 AJS
--      V_SEGMENT5           NVARCHAR2(100);
      V_SEGMENT5           VARCHAR2(100);   -- 2026.09.17 AJS
--      V_ATTRIBUTE1         NVARCHAR2(100);
      V_ATTRIBUTE1         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE2         NVARCHAR2(100);
      V_ATTRIBUTE2         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE3         NVARCHAR2(100);
      V_ATTRIBUTE3         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE4         NVARCHAR2(100);
      V_ATTRIBUTE4         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE5         NVARCHAR2(100);
      V_ATTRIBUTE5         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE6         NVARCHAR2(100);
      V_ATTRIBUTE6         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE7         NVARCHAR2(100);
      V_ATTRIBUTE7         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE8         NVARCHAR2(100);
      V_ATTRIBUTE8         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE9         NVARCHAR2(100);
      V_ATTRIBUTE9         VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE10        NVARCHAR2(100);
      V_ATTRIBUTE10        VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE11        NVARCHAR2(100);
      V_ATTRIBUTE11        VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE12        NVARCHAR2(100);
      V_ATTRIBUTE12        VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE13        NVARCHAR2(100);
      V_ATTRIBUTE13        VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE14        NVARCHAR2(100);
      V_ATTRIBUTE14        VARCHAR2(150);   -- 2026.09.17 AJS
--      V_ATTRIBUTE15        NVARCHAR2(100);
      V_ATTRIBUTE15        VARCHAR2(150);   -- 2026.09.17 AJS
      --V_CREATED_BY         NVARCHAR2(300);
      --V_CREATION_DATE      DATE;
      --V_LAST_UPDATED_BY    NVARCHAR2(300);
      --V_CREATION_DATE_STR  VARCHAR2(30);

      N_HISTORY_SEQ        NUMBER;

--      V_PROGRAM_NAME       NVARCHAR2(150) := 'P_SYS0010_SAVE_LOOKUP_MASTER_HIST';
      V_PROGRAM_NAME       VARCHAR2(150) := 'P_SYS0010_SAVE_LOOKUP_MASTER_HIST';   -- 2026.09.17 AJS
--      V_LOG_TYPE           NVARCHAR2(30);
      V_LOG_TYPE           VARCHAR2(30);   -- 2026.09.17 AJS
      N_LOG_COUNT          NUMBER := 0;
--      V_LOG_MESSAGE        NVARCHAR2(1000);
      V_LOG_MESSAGE        VARCHAR2(1000);   -- 2026.09.17 AJS
--      V_LOG_DESC           NVARCHAR2(500);
      V_LOG_DESC           VARCHAR2(500);   -- 2026.09.17 AJS
      D_EVENT_DATE         DATE;
  BEGIN
      -- JSON payload parsing
	  FOR JT IN (
      	SELECT
            JT.LOOKUP_TYPE AS V_LOOKUP_TYPE
          , JT.DESCRIPTION AS V_DESCRIPTION
          , JT.LOOKUP_GROUP AS V_LOOKUP_GROUP
          , JT.VALID_YN AS V_VALID_YN
          , NVL(TRIM(JT.SEGMENT1), '/') AS V_SEGMENT1
          , NVL(TRIM(JT.SEGMENT2), '/') AS V_SEGMENT2
          , NVL(TRIM(JT.SEGMENT3), '/') AS V_SEGMENT3
          , NVL(TRIM(JT.SEGMENT4), '/') AS V_SEGMENT4
          , NVL(TRIM(JT.SEGMENT5), '/') AS V_SEGMENT5
          , JT.ATTRIBUTE1 AS V_ATTRIBUTE1
          , JT.ATTRIBUTE2 AS V_ATTRIBUTE2
          , JT.ATTRIBUTE3 AS V_ATTRIBUTE3
          , JT.ATTRIBUTE4 AS V_ATTRIBUTE4
          , JT.ATTRIBUTE5 AS V_ATTRIBUTE5
          , JT.ATTRIBUTE6 AS V_ATTRIBUTE6
          , JT.ATTRIBUTE7 AS V_ATTRIBUTE7
          , JT.ATTRIBUTE8 AS V_ATTRIBUTE8
          , JT.ATTRIBUTE9 AS V_ATTRIBUTE9
          , JT.ATTRIBUTE10 AS V_ATTRIBUTE10
          , JT.ATTRIBUTE11 AS V_ATTRIBUTE11
          , JT.ATTRIBUTE12 AS V_ATTRIBUTE12
          , JT.ATTRIBUTE13 AS V_ATTRIBUTE13
          , JT.ATTRIBUTE14 AS V_ATTRIBUTE14
          , JT.ATTRIBUTE15 AS V_ATTRIBUTE15          
      	FROM JSON_TABLE(
            P_DATA
          , '$[*]'
            -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (START)
--            COLUMNS (
--                LOOKUP_TYPE        VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
--              , DESCRIPTION        VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY NULL ON ERROR
--              , LOOKUP_GROUP       VARCHAR2(200)  PATH '$.LOOKUP_GROUP'
--              , VALID_YN           VARCHAR2(2)    PATH '$.VALID_YN'
--              , SEGMENT1           VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY NULL ON ERROR
--              , SEGMENT2           VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY NULL ON ERROR
--              , SEGMENT3           VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY NULL ON ERROR
--              , SEGMENT4           VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY NULL ON ERROR
--              , SEGMENT5           VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE1         VARCHAR2(100)  PATH '$.ATTRIBUTE1' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE2         VARCHAR2(100)  PATH '$.ATTRIBUTE2' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE3         VARCHAR2(100)  PATH '$.ATTRIBUTE3' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE4         VARCHAR2(100)  PATH '$.ATTRIBUTE4' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE5         VARCHAR2(100)  PATH '$.ATTRIBUTE5' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE6         VARCHAR2(100)  PATH '$.ATTRIBUTE6' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE7         VARCHAR2(100)  PATH '$.ATTRIBUTE7' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE8         VARCHAR2(100)  PATH '$.ATTRIBUTE8' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE9         VARCHAR2(100)  PATH '$.ATTRIBUTE9' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE10        VARCHAR2(100)  PATH '$.ATTRIBUTE10' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE11        VARCHAR2(100)  PATH '$.ATTRIBUTE11' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE12        VARCHAR2(100)  PATH '$.ATTRIBUTE12' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE13        VARCHAR2(100)  PATH '$.ATTRIBUTE13' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE14        VARCHAR2(100)  PATH '$.ATTRIBUTE14' NULL ON EMPTY NULL ON ERROR
--              , ATTRIBUTE15        VARCHAR2(100)  PATH '$.ATTRIBUTE15' NULL ON EMPTY NULL ON ERROR
--              --, CREATED_BY         VARCHAR2(300)  PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
--              --, CREATION_DATE_STR  VARCHAR2(30)   PATH '$.CREATION_DATE' NULL ON EMPTY NULL ON ERROR
--              --, LAST_UPDATED_BY    VARCHAR2(300)  PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
--            )
            COLUMNS (
                LOOKUP_TYPE        VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
              , DESCRIPTION        VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY ERROR ON ERROR
              , LOOKUP_GROUP       VARCHAR2(200)  PATH '$.LOOKUP_GROUP'
              , VALID_YN           VARCHAR2(2)    PATH '$.VALID_YN'
              , SEGMENT1           VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY ERROR ON ERROR
              , SEGMENT2           VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY ERROR ON ERROR
              , SEGMENT3           VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY ERROR ON ERROR
              , SEGMENT4           VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY ERROR ON ERROR
              , SEGMENT5           VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE1         VARCHAR2(150)  PATH '$.ATTRIBUTE1' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE2         VARCHAR2(150)  PATH '$.ATTRIBUTE2' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE3         VARCHAR2(150)  PATH '$.ATTRIBUTE3' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE4         VARCHAR2(150)  PATH '$.ATTRIBUTE4' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE5         VARCHAR2(150)  PATH '$.ATTRIBUTE5' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE6         VARCHAR2(150)  PATH '$.ATTRIBUTE6' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE7         VARCHAR2(150)  PATH '$.ATTRIBUTE7' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE8         VARCHAR2(150)  PATH '$.ATTRIBUTE8' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE9         VARCHAR2(150)  PATH '$.ATTRIBUTE9' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE10        VARCHAR2(150)  PATH '$.ATTRIBUTE10' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE11        VARCHAR2(150)  PATH '$.ATTRIBUTE11' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE12        VARCHAR2(150)  PATH '$.ATTRIBUTE12' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE13        VARCHAR2(150)  PATH '$.ATTRIBUTE13' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE14        VARCHAR2(150)  PATH '$.ATTRIBUTE14' NULL ON EMPTY ERROR ON ERROR
              , ATTRIBUTE15        VARCHAR2(150)  PATH '$.ATTRIBUTE15' NULL ON EMPTY ERROR ON ERROR
              --, CREATED_BY         VARCHAR2(300)  PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
              --, CREATION_DATE_STR  VARCHAR2(30)   PATH '$.CREATION_DATE' NULL ON EMPTY NULL ON ERROR
              --, LAST_UPDATED_BY    VARCHAR2(300)  PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
            )
            -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (END)
      	) JT
      ) LOOP

      V_LOOKUP_TYPE := NVL(TRIM(JT.V_LOOKUP_TYPE), '');
      V_DESCRIPTION := NVL(TRIM(JT.V_DESCRIPTION), '');
      V_LOOKUP_GROUP := NVL(TRIM(JT.V_LOOKUP_GROUP), '');
      V_VALID_YN 	:= NVL(TRIM(JT.V_VALID_YN), '');      
      V_SEGMENT1    := NVL(TRIM(JT.V_SEGMENT1), '');
      V_SEGMENT2    := NVL(TRIM(JT.V_SEGMENT2), '');
      V_SEGMENT3    := NVL(TRIM(JT.V_SEGMENT3), '');
      V_SEGMENT4    := NVL(TRIM(JT.V_SEGMENT4), '');
      V_SEGMENT5    := NVL(TRIM(JT.V_SEGMENT5), '');
      V_ATTRIBUTE1  := NVL(TRIM(JT.V_ATTRIBUTE1), '');
      V_ATTRIBUTE2  := NVL(TRIM(JT.V_ATTRIBUTE2), '');
      V_ATTRIBUTE3  := NVL(TRIM(JT.V_ATTRIBUTE3), '');
      V_ATTRIBUTE4  := NVL(TRIM(JT.V_ATTRIBUTE4), '');
      V_ATTRIBUTE5  := NVL(TRIM(JT.V_ATTRIBUTE5), '');
      V_ATTRIBUTE6  := NVL(TRIM(JT.V_ATTRIBUTE6), '');
      V_ATTRIBUTE7  := NVL(TRIM(JT.V_ATTRIBUTE7), '');
      V_ATTRIBUTE8  := NVL(TRIM(JT.V_ATTRIBUTE8), '');
      V_ATTRIBUTE9  := NVL(TRIM(JT.V_ATTRIBUTE9), '');
      V_ATTRIBUTE10  := NVL(TRIM(JT.V_ATTRIBUTE10), '');
      V_ATTRIBUTE11  := NVL(TRIM(JT.V_ATTRIBUTE11), '');
      V_ATTRIBUTE12  := NVL(TRIM(JT.V_ATTRIBUTE12), '');
      V_ATTRIBUTE13  := NVL(TRIM(JT.V_ATTRIBUTE13), '');
      V_ATTRIBUTE14  := NVL(TRIM(JT.V_ATTRIBUTE14), '');
      V_ATTRIBUTE15  := NVL(TRIM(JT.V_ATTRIBUTE15), '');

      /*
      IF V_CREATION_DATE_STR IS NOT NULL THEN
          V_CREATION_DATE := TO_DATE(V_CREATION_DATE_STR, 'YYYY-MM-DD HH24:MI:SS');
      ELSE
          V_CREATION_DATE := SYSDATE;
      END IF;
      */
      V_LOG_TYPE    := 'START';
      V_LOG_MESSAGE := '########## Start of procedure ##########';
      V_LOG_DESC    := '';
      D_EVENT_DATE  := SYSDATE;

      PR_SCM_SYS_LOG_BATCH(
          V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE
      );

      N_HISTORY_SEQ := SEQ1_SCM_ADM_LOOKUP_MASTER_H.NEXTVAL;

      INSERT INTO SCM_ADM_LOOKUP_MASTER_H (
            HISTORY_SEQ
          , LOOKUP_TYPE
          , DESCRIPTION
          , LOOKUP_GROUP
          , VALID_YN
          , SEGMENT1
          , SEGMENT2
          , SEGMENT3
          , SEGMENT4
          , SEGMENT5
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE4
          , ATTRIBUTE5
          , ATTRIBUTE6
          , ATTRIBUTE7
          , ATTRIBUTE8
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE11
          , ATTRIBUTE12
          , ATTRIBUTE13
          , ATTRIBUTE14
          , ATTRIBUTE15
          , HISTORY_CREATION_DATE
      ) VALUES (
            N_HISTORY_SEQ
          , V_LOOKUP_TYPE
          , V_DESCRIPTION
          , V_LOOKUP_GROUP
          , V_VALID_YN
          , V_SEGMENT1
          , V_SEGMENT2
          , V_SEGMENT3
          , V_SEGMENT4
          , V_SEGMENT5
          , P_USER_ID
          , SYSDATE
          , P_USER_ID
          , SYSDATE
          , V_ATTRIBUTE1
          , V_ATTRIBUTE2
          , V_ATTRIBUTE3
          , V_ATTRIBUTE4
          , V_ATTRIBUTE5
          , V_ATTRIBUTE6
          , V_ATTRIBUTE7
          , V_ATTRIBUTE8
          , V_ATTRIBUTE9
          , V_ATTRIBUTE10
          , V_ATTRIBUTE11
          , V_ATTRIBUTE12
          , V_ATTRIBUTE13
          , V_ATTRIBUTE14
          , V_ATTRIBUTE15
          , D_EVENT_DATE
      );

      END LOOP;
--      COMMIT;
      /* 확정은 호출한 저장 프로시저에서 */   -- 2026.09.17 AJS


      N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;

      V_LOG_TYPE    := 'END';
      V_LOG_MESSAGE := '########## END of procedure ##########';
      V_LOG_DESC    := '';
      D_EVENT_DATE  := SYSDATE;

      PR_SCM_SYS_LOG_BATCH(
          V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE
      );

      OPEN O_RESULT_CURSOR FOR
           SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

  EXCEPTION
      WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SQLERRM;
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(
            V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE
        );

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_LOG_DESC ||
        ' / SQLERRM=' || V_LOG_MESSAGE ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

  END P_SYS0010_SAVE_LOOKUP_MASTER_HIST;

  PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL (
        P_DATA           IN CLOB
      , P_USER_ID        IN VARCHAR2
      , O_RESULT_CURSOR  OUT SYS_REFCURSOR
  )
/*
 * Program ID   : P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL
 * Description  : Lookup Values 등록,수정(AS-IS : SCM0003_SAVE_LOOKUP_MASTER_DETAIL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/01/29	hwyoon			[PS02199094B] GSCM(DM/SCP) SM운영/유지보수 LTRIM, RTRIM 적용
 * 2026.04.21   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

  IS
        V_CRUD_TYPE      VARCHAR2(1);
        V_LOOKUP_TYPE      VARCHAR2(200);
        V_DESCRIPTION      VARCHAR2(1000);
        V_DISPLAY_SEQ      NUMBER;
        V_VALID_YN         VARCHAR2(2);
        V_SEGMENT1         VARCHAR2(100);
        V_SEGMENT2         VARCHAR2(100);
        V_SEGMENT3         VARCHAR2(100);
        V_SEGMENT4         VARCHAR2(100);
        V_SEGMENT5         VARCHAR2(100);
        V_SEGMENT1_KEY     VARCHAR2(100);
        V_SEGMENT2_KEY     VARCHAR2(100);
        V_SEGMENT3_KEY     VARCHAR2(100);
        V_SEGMENT4_KEY     VARCHAR2(100);
        V_SEGMENT5_KEY     VARCHAR2(100);
--        V_ATTRIBUTE1       VARCHAR2(100);
        V_ATTRIBUTE1       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE2       VARCHAR2(100);
        V_ATTRIBUTE2       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE3       VARCHAR2(100);
        V_ATTRIBUTE3       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE4       VARCHAR2(100);
        V_ATTRIBUTE4       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE5       VARCHAR2(100);
        V_ATTRIBUTE5       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE6       VARCHAR2(100);
        V_ATTRIBUTE6       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE7       VARCHAR2(100);
        V_ATTRIBUTE7       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE8       VARCHAR2(100);
        V_ATTRIBUTE8       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE9       VARCHAR2(100);
        V_ATTRIBUTE9       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE10      VARCHAR2(100);
        V_ATTRIBUTE10      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE11      VARCHAR2(100);
        V_ATTRIBUTE11      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE12      VARCHAR2(100);
        V_ATTRIBUTE12      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE13      VARCHAR2(100);
        V_ATTRIBUTE13      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE14      VARCHAR2(100);
        V_ATTRIBUTE14      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE15      VARCHAR2(100);
        V_ATTRIBUTE15      VARCHAR2(150);   -- 2026.09.17 AJS

        V_PROGRAM_NAME     VARCHAR2(150) := 'P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL';
        V_LOG_TYPE         VARCHAR2(30);
        N_LOG_COUNT        NUMBER := 0;
        V_LOG_MESSAGE      VARCHAR2(1000);
        V_LOG_DESC         VARCHAR2(500);
        D_EVENT_DATE       DATE;

        V_HIST_CURSOR      SYS_REFCURSOR;
        V_CODE             VARCHAR2(10);
        V_MSG              VARCHAR2(4000);
        V_EVENT            VARCHAR2(100);
  BEGIN
      -- 2026.09.17 AJS 저장 시작 지점 · 이력 1회 기록 (START)
      SAVEPOINT SP_SYS0010_SAVE_D;

      P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST(
            P_DATA
          , P_USER_ID
          , V_HIST_CURSOR
      );

      FETCH V_HIST_CURSOR INTO V_CODE, V_MSG, V_EVENT;
      CLOSE V_HIST_CURSOR;
      -- 2026.09.17 AJS 저장 시작 지점 · 이력 1회 기록 (END)

	 FOR JT IN ( 	
        SELECT
              JT.CRUD_TYPE AS V_CRUD_TYPE
            , JT.LOOKUP_TYPE AS V_LOOKUP_TYPE
            , JT.DESCRIPTION AS V_DESCRIPTION
            , JT.DISPLAY_SEQ AS V_DISPLAY_SEQ
            , JT.VALID_YN AS V_VALID_YN
            , NVL(TRIM(JT.SEGMENT1), '/') AS V_SEGMENT1
            , NVL(TRIM(JT.SEGMENT2), '/') AS V_SEGMENT2
            , NVL(TRIM(JT.SEGMENT3), '/') AS V_SEGMENT3
            , NVL(TRIM(JT.SEGMENT4), '/') AS V_SEGMENT4
            , NVL(TRIM(JT.SEGMENT5), '/') AS V_SEGMENT5
            , TRIM(JT.SEGMENT1_KEY) AS V_SEGMENT1_KEY
            , TRIM(JT.SEGMENT2_KEY) AS V_SEGMENT2_KEY
            , TRIM(JT.SEGMENT3_KEY) AS V_SEGMENT3_KEY
            , TRIM(JT.SEGMENT4_KEY) AS V_SEGMENT4_KEY
            , TRIM(JT.SEGMENT5_KEY) AS V_SEGMENT5_KEY
            , JT.ATTRIBUTE1 AS V_ATTRIBUTE1
            , JT.ATTRIBUTE2 AS V_ATTRIBUTE2
            , JT.ATTRIBUTE3 AS V_ATTRIBUTE3
            , JT.ATTRIBUTE4 AS V_ATTRIBUTE4
            , JT.ATTRIBUTE5 AS V_ATTRIBUTE5
            , JT.ATTRIBUTE6 AS V_ATTRIBUTE6
            , JT.ATTRIBUTE7 AS V_ATTRIBUTE7
            , JT.ATTRIBUTE8 AS V_ATTRIBUTE8
            , JT.ATTRIBUTE9 AS V_ATTRIBUTE9
            , JT.ATTRIBUTE10 AS V_ATTRIBUTE10
            , JT.ATTRIBUTE11 AS V_ATTRIBUTE11
            , JT.ATTRIBUTE12 AS V_ATTRIBUTE12
            , JT.ATTRIBUTE13 AS V_ATTRIBUTE13
            , JT.ATTRIBUTE14 AS V_ATTRIBUTE14
            , JT.ATTRIBUTE15 AS V_ATTRIBUTE15        
        FROM JSON_TABLE(
              P_DATA
            , '$[*]'
              -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (START)
--              COLUMNS (
--                  CRUD_TYPE      VARCHAR2(1)    PATH '$.CRUD_TYPE'
--                , LOOKUP_TYPE    VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
--                , DESCRIPTION    VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY NULL ON ERROR
--                , DISPLAY_SEQ    NUMBER         PATH '$.DISPLAY_SEQ' NULL ON EMPTY NULL ON ERROR
--                , VALID_YN       VARCHAR2(2)    PATH '$.VALID_YN'
--                , SEGMENT1       VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT2       VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT3       VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT4       VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT5       VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT1_KEY   VARCHAR2(100)  PATH '$.SEGMENT1_KEY' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT2_KEY   VARCHAR2(100)  PATH '$.SEGMENT2_KEY' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT3_KEY   VARCHAR2(100)  PATH '$.SEGMENT3_KEY' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT4_KEY   VARCHAR2(100)  PATH '$.SEGMENT4_KEY' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT5_KEY   VARCHAR2(100)  PATH '$.SEGMENT5_KEY' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE1     VARCHAR2(100)  PATH '$.ATTRIBUTE1' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE2     VARCHAR2(100)  PATH '$.ATTRIBUTE2' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE3     VARCHAR2(100)  PATH '$.ATTRIBUTE3' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE4     VARCHAR2(100)  PATH '$.ATTRIBUTE4' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE5     VARCHAR2(100)  PATH '$.ATTRIBUTE5' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE6     VARCHAR2(100)  PATH '$.ATTRIBUTE6' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE7     VARCHAR2(100)  PATH '$.ATTRIBUTE7' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE8     VARCHAR2(100)  PATH '$.ATTRIBUTE8' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE9     VARCHAR2(100)  PATH '$.ATTRIBUTE9' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE10    VARCHAR2(100)  PATH '$.ATTRIBUTE10' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE11    VARCHAR2(100)  PATH '$.ATTRIBUTE11' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE12    VARCHAR2(100)  PATH '$.ATTRIBUTE12' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE13    VARCHAR2(100)  PATH '$.ATTRIBUTE13' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE14    VARCHAR2(100)  PATH '$.ATTRIBUTE14' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE15    VARCHAR2(100)  PATH '$.ATTRIBUTE15' NULL ON EMPTY NULL ON ERROR
--              )
              COLUMNS (
                  CRUD_TYPE      VARCHAR2(1)    PATH '$.CRUD_TYPE'
                , LOOKUP_TYPE    VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
                , DESCRIPTION    VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY ERROR ON ERROR
                , DISPLAY_SEQ    NUMBER         PATH '$.DISPLAY_SEQ' NULL ON EMPTY ERROR ON ERROR
                , VALID_YN       VARCHAR2(2)    PATH '$.VALID_YN'
                , SEGMENT1       VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT2       VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT3       VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT4       VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT5       VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT1_KEY   VARCHAR2(100)  PATH '$.SEGMENT1_KEY' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT2_KEY   VARCHAR2(100)  PATH '$.SEGMENT2_KEY' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT3_KEY   VARCHAR2(100)  PATH '$.SEGMENT3_KEY' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT4_KEY   VARCHAR2(100)  PATH '$.SEGMENT4_KEY' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT5_KEY   VARCHAR2(100)  PATH '$.SEGMENT5_KEY' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE1     VARCHAR2(150)  PATH '$.ATTRIBUTE1' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE2     VARCHAR2(150)  PATH '$.ATTRIBUTE2' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE3     VARCHAR2(150)  PATH '$.ATTRIBUTE3' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE4     VARCHAR2(150)  PATH '$.ATTRIBUTE4' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE5     VARCHAR2(150)  PATH '$.ATTRIBUTE5' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE6     VARCHAR2(150)  PATH '$.ATTRIBUTE6' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE7     VARCHAR2(150)  PATH '$.ATTRIBUTE7' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE8     VARCHAR2(150)  PATH '$.ATTRIBUTE8' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE9     VARCHAR2(150)  PATH '$.ATTRIBUTE9' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE10    VARCHAR2(150)  PATH '$.ATTRIBUTE10' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE11    VARCHAR2(150)  PATH '$.ATTRIBUTE11' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE12    VARCHAR2(150)  PATH '$.ATTRIBUTE12' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE13    VARCHAR2(150)  PATH '$.ATTRIBUTE13' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE14    VARCHAR2(150)  PATH '$.ATTRIBUTE14' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE15    VARCHAR2(150)  PATH '$.ATTRIBUTE15' NULL ON EMPTY ERROR ON ERROR
              )
              -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (END)
        ) JT
      ) LOOP
		
		V_CRUD_TYPE := NVL(TRIM(JT.V_CRUD_TYPE), ''); 	
        V_LOOKUP_TYPE  := NVL(TRIM(JT.V_LOOKUP_TYPE), '');
		V_DESCRIPTION  := NVL(TRIM(JT.V_DESCRIPTION), '');
		V_DISPLAY_SEQ  := JT.V_DISPLAY_SEQ;
		V_VALID_YN	   := NVL(TRIM(JT.V_VALID_YN), '');	
        V_SEGMENT1     := NVL(TRIM(JT.V_SEGMENT1), '');
        V_SEGMENT2     := NVL(TRIM(JT.V_SEGMENT2), '');
        V_SEGMENT3     := NVL(TRIM(JT.V_SEGMENT3), '');
        V_SEGMENT4     := NVL(TRIM(JT.V_SEGMENT4), '');
        V_SEGMENT5     := NVL(TRIM(JT.V_SEGMENT5), '');
		V_ATTRIBUTE1   := NVL(TRIM(JT.V_ATTRIBUTE1), '');
		V_ATTRIBUTE2   := NVL(TRIM(JT.V_ATTRIBUTE2), '');
		V_ATTRIBUTE3   := NVL(TRIM(JT.V_ATTRIBUTE3), '');
		V_ATTRIBUTE4   := NVL(TRIM(JT.V_ATTRIBUTE4), '');
		V_ATTRIBUTE5   := NVL(TRIM(JT.V_ATTRIBUTE5), '');
		V_ATTRIBUTE6   := NVL(TRIM(JT.V_ATTRIBUTE6), '');
		V_ATTRIBUTE7   := NVL(TRIM(JT.V_ATTRIBUTE7), '');
		V_ATTRIBUTE8   := NVL(TRIM(JT.V_ATTRIBUTE8), '');
		V_ATTRIBUTE9   := NVL(TRIM(JT.V_ATTRIBUTE9), '');
		V_ATTRIBUTE10   := NVL(TRIM(JT.V_ATTRIBUTE10), '');
		V_ATTRIBUTE11   := NVL(TRIM(JT.V_ATTRIBUTE11), '');
		V_ATTRIBUTE12   := NVL(TRIM(JT.V_ATTRIBUTE12), '');
		V_ATTRIBUTE13   := NVL(TRIM(JT.V_ATTRIBUTE13), '');
		V_ATTRIBUTE14   := NVL(TRIM(JT.V_ATTRIBUTE14), '');
		V_ATTRIBUTE15   := NVL(TRIM(JT.V_ATTRIBUTE15), '');
		V_SEGMENT1_KEY := JT.V_SEGMENT1_KEY;
        V_SEGMENT2_KEY := JT.V_SEGMENT2_KEY;
        V_SEGMENT3_KEY := JT.V_SEGMENT3_KEY;
        V_SEGMENT4_KEY := JT.V_SEGMENT4_KEY;
        V_SEGMENT5_KEY := JT.V_SEGMENT5_KEY;

        /*V_SEGMENT1_KEY := NVL(TRIM(V_SEGMENT1_KEY), '');
        V_SEGMENT2_KEY := NVL(TRIM(V_SEGMENT2_KEY), '');
        V_SEGMENT3_KEY := NVL(TRIM(V_SEGMENT3_KEY), '');
        V_SEGMENT4_KEY := NVL(TRIM(V_SEGMENT4_KEY), '');
        V_SEGMENT5_KEY := NVL(TRIM(V_SEGMENT5_KEY), '');*/

        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_LOG_DESC    := '';
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(
              V_PROGRAM_NAME
            , V_LOG_TYPE
            , N_LOG_COUNT
            , V_LOG_MESSAGE
            , V_LOG_DESC
            , D_EVENT_DATE
        );

        -- 2026.09.17 AJS 행마다 전체 이력 재기록 제거 (START)
--        P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST(
--              P_DATA
--            , P_USER_ID
--            , V_HIST_CURSOR
--        );
--
--        FETCH V_HIST_CURSOR INTO V_CODE, V_MSG, V_EVENT;
--        CLOSE V_HIST_CURSOR;
        -- 2026.09.17 AJS 행마다 전체 이력 재기록 제거 (END)

        IF V_CRUD_TYPE = 'I' THEN
            INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
                  LOOKUP_TYPE
                , DESCRIPTION
                , DISPLAY_SEQ
                , VALID_YN
                , SEGMENT1
                , SEGMENT2
                , SEGMENT3
                , SEGMENT4
                , SEGMENT5
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                , ATTRIBUTE1
                , ATTRIBUTE2
                , ATTRIBUTE3
                , ATTRIBUTE4
                , ATTRIBUTE5
                , ATTRIBUTE6
                , ATTRIBUTE7
                , ATTRIBUTE8
                , ATTRIBUTE9
                , ATTRIBUTE10
                , ATTRIBUTE11
                , ATTRIBUTE12
                , ATTRIBUTE13
                , ATTRIBUTE14
                , ATTRIBUTE15
            ) VALUES (
                  V_LOOKUP_TYPE
                , V_DESCRIPTION
                , V_DISPLAY_SEQ
                , V_VALID_YN
                , V_SEGMENT1
                , V_SEGMENT2
                , V_SEGMENT3
                , V_SEGMENT4
                , V_SEGMENT5
                , P_USER_ID
                , SYSDATE
                , P_USER_ID
                , SYSDATE
                , V_ATTRIBUTE1
                , V_ATTRIBUTE2
                , V_ATTRIBUTE3
                , V_ATTRIBUTE4
                , V_ATTRIBUTE5
                , V_ATTRIBUTE6
                , V_ATTRIBUTE7
                , V_ATTRIBUTE8
                , V_ATTRIBUTE9
                , V_ATTRIBUTE10
                , V_ATTRIBUTE11
                , V_ATTRIBUTE12
                , V_ATTRIBUTE13
                , V_ATTRIBUTE14
                , V_ATTRIBUTE15
            );

            N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;
        ELSIF V_CRUD_TYPE = 'D' THEN
            /* 삭제 — 기존에는 'D' 가 아래 UPDATE 로 흘러가 행이 지워지지 않고 갱신만 됐다.
               AS-IS 는 SCM0003_DELETE_LOOKUP_MASTER_DETAIL 로 분리돼 있고 동일하게
               SEGMENT1_KEY~5_KEY 를 WHERE 에 쓴다. */
            DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = V_LOOKUP_TYPE
               AND SEGMENT1    = NVL(V_SEGMENT1_KEY, V_SEGMENT1)
               AND SEGMENT2    = NVL(V_SEGMENT2_KEY, V_SEGMENT2)
               AND SEGMENT3    = NVL(V_SEGMENT3_KEY, V_SEGMENT3)
               AND SEGMENT4    = NVL(V_SEGMENT4_KEY, V_SEGMENT4)
               AND SEGMENT5    = NVL(V_SEGMENT5_KEY, V_SEGMENT5)
               ;

            N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;
        ELSE
            UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
               SET DESCRIPTION      = V_DESCRIPTION
                 , DISPLAY_SEQ      = V_DISPLAY_SEQ
                 , VALID_YN         = V_VALID_YN
                 , SEGMENT1         = V_SEGMENT1
                 , SEGMENT2         = V_SEGMENT2
                 , SEGMENT3         = V_SEGMENT3
                 , SEGMENT4         = V_SEGMENT4
                 , SEGMENT5         = V_SEGMENT5
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
                 , ATTRIBUTE1       = V_ATTRIBUTE1
                 , ATTRIBUTE2       = V_ATTRIBUTE2
                 , ATTRIBUTE3       = V_ATTRIBUTE3
                 , ATTRIBUTE4       = V_ATTRIBUTE4
                 , ATTRIBUTE5       = V_ATTRIBUTE5
                 , ATTRIBUTE6       = V_ATTRIBUTE6
                 , ATTRIBUTE7       = V_ATTRIBUTE7
                 , ATTRIBUTE8       = V_ATTRIBUTE8
                 , ATTRIBUTE9       = V_ATTRIBUTE9
                 , ATTRIBUTE10      = V_ATTRIBUTE10
                 , ATTRIBUTE11      = V_ATTRIBUTE11
                 , ATTRIBUTE12      = V_ATTRIBUTE12
                 , ATTRIBUTE13      = V_ATTRIBUTE13
                 , ATTRIBUTE14      = V_ATTRIBUTE14
                 , ATTRIBUTE15      = V_ATTRIBUTE15
             WHERE LOOKUP_TYPE = V_LOOKUP_TYPE
               AND SEGMENT1    = NVL(V_SEGMENT1_KEY, V_SEGMENT1)
               AND SEGMENT2    = NVL(V_SEGMENT2_KEY, V_SEGMENT2)
               AND SEGMENT3    = NVL(V_SEGMENT3_KEY, V_SEGMENT3)
               AND SEGMENT4    = NVL(V_SEGMENT4_KEY, V_SEGMENT4)
               AND SEGMENT5    = NVL(V_SEGMENT5_KEY, V_SEGMENT5)
               ;

            N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;
        END IF;
	  END LOOP;	
    COMMIT;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(
          V_PROGRAM_NAME
        , V_LOG_TYPE
        , N_LOG_COUNT
        , V_LOG_MESSAGE
        , V_LOG_DESC
        , D_EVENT_DATE
    );

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT
          FROM DUAL;

  EXCEPTION
      WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SQLERRM;
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        -- 2026.09.17 AJS 오류 시 저장분 되돌리기 (START)
        BEGIN
            ROLLBACK TO SAVEPOINT SP_SYS0010_SAVE_D;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        -- 2026.09.17 AJS 오류 시 저장분 되돌리기 (END)

        PR_SCM_SYS_LOG_BATCH(
              V_PROGRAM_NAME
            , V_LOG_TYPE
            , N_LOG_COUNT
            , V_LOG_MESSAGE
            , V_LOG_DESC
            , D_EVENT_DATE
        );

        RAISE_APPLICATION_ERROR(
            -20001
          , '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_LOG_DESC
            || ' / SQLERRM=' || V_LOG_MESSAGE
            || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
            || ' / PARAMS=' || '-'
        );
  END P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL;


  PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST (
        P_DATA           IN CLOB
      , P_USER_ID        IN VARCHAR2
      , O_RESULT_CURSOR  OUT SYS_REFCURSOR
  )
/*
 * Program ID   : P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST
 * Description  : Lookup Values History(AS-IS : PR_SCM_ADM_LOOKUP_MASTER_DETAIL_HIST)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017.12.15   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.04.21   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */
  IS
        V_LOOKUP_TYPE      VARCHAR2(200);
        V_DESCRIPTION      VARCHAR2(1000);
        V_DISPLAY_SEQ      NUMBER;
        V_VALID_YN         VARCHAR2(2);
        V_SEGMENT1         VARCHAR2(100);
        V_SEGMENT2         VARCHAR2(100);
        V_SEGMENT3         VARCHAR2(100);
        V_SEGMENT4         VARCHAR2(100);
        V_SEGMENT5         VARCHAR2(100);
--        V_ATTRIBUTE1       VARCHAR2(100);
        V_ATTRIBUTE1       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE2       VARCHAR2(100);
        V_ATTRIBUTE2       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE3       VARCHAR2(100);
        V_ATTRIBUTE3       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE4       VARCHAR2(100);
        V_ATTRIBUTE4       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE5       VARCHAR2(100);
        V_ATTRIBUTE5       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE6       VARCHAR2(100);
        V_ATTRIBUTE6       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE7       VARCHAR2(100);
        V_ATTRIBUTE7       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE8       VARCHAR2(100);
        V_ATTRIBUTE8       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE9       VARCHAR2(100);
        V_ATTRIBUTE9       VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE10      VARCHAR2(100);
        V_ATTRIBUTE10      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE11      VARCHAR2(100);
        V_ATTRIBUTE11      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE12      VARCHAR2(100);
        V_ATTRIBUTE12      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE13      VARCHAR2(100);
        V_ATTRIBUTE13      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE14      VARCHAR2(100);
        V_ATTRIBUTE14      VARCHAR2(150);   -- 2026.09.17 AJS
--        V_ATTRIBUTE15      VARCHAR2(100);
        V_ATTRIBUTE15      VARCHAR2(150);   -- 2026.09.17 AJS

        N_HISTORY_SEQ      NUMBER;

        V_PROGRAM_NAME     VARCHAR2(150) := 'P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST';
        V_LOG_TYPE         VARCHAR2(30);
        N_LOG_COUNT        NUMBER := 0;
        V_LOG_MESSAGE      VARCHAR2(1000);
        V_LOG_DESC         VARCHAR2(500);
        D_EVENT_DATE       DATE;
  BEGIN
	FOR JT IN (  
        SELECT
              JT.LOOKUP_TYPE AS V_LOOKUP_TYPE
            , JT.DESCRIPTION AS V_DESCRIPTION
            , JT.DISPLAY_SEQ AS V_DISPLAY_SEQ
            , JT.VALID_YN AS V_VALID_YN
            , NVL(TRIM(JT.SEGMENT1), '/') AS V_SEGMENT1
            , NVL(TRIM(JT.SEGMENT2), '/') AS V_SEGMENT2
            , NVL(TRIM(JT.SEGMENT3), '/') AS V_SEGMENT3
            , NVL(TRIM(JT.SEGMENT4), '/') AS V_SEGMENT4
            , NVL(TRIM(JT.SEGMENT5), '/') AS V_SEGMENT5
            , JT.ATTRIBUTE1 AS V_ATTRIBUTE1
            , JT.ATTRIBUTE2 AS V_ATTRIBUTE2
            , JT.ATTRIBUTE3 AS V_ATTRIBUTE3
            , JT.ATTRIBUTE4 AS V_ATTRIBUTE4
            , JT.ATTRIBUTE5 AS V_ATTRIBUTE5
            , JT.ATTRIBUTE6 AS V_ATTRIBUTE6
            , JT.ATTRIBUTE7 AS V_ATTRIBUTE7
            , JT.ATTRIBUTE8 AS V_ATTRIBUTE8
            , JT.ATTRIBUTE9 AS V_ATTRIBUTE9
            , JT.ATTRIBUTE10 AS V_ATTRIBUTE10
            , JT.ATTRIBUTE11 AS V_ATTRIBUTE11
            , JT.ATTRIBUTE12 AS V_ATTRIBUTE12
            , JT.ATTRIBUTE13 AS V_ATTRIBUTE13
            , JT.ATTRIBUTE14 AS V_ATTRIBUTE14
            , JT.ATTRIBUTE15 AS V_ATTRIBUTE15                    
        FROM JSON_TABLE(
              P_DATA
            , '$[*]'
              -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (START)
--              COLUMNS (
--                  LOOKUP_TYPE    VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
--                , DESCRIPTION    VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY NULL ON ERROR
--                , DISPLAY_SEQ    NUMBER         PATH '$.DISPLAY_SEQ' NULL ON EMPTY NULL ON ERROR
--                , VALID_YN       VARCHAR2(2)    PATH '$.VALID_YN'
--                , SEGMENT1       VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT2       VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT3       VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT4       VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY NULL ON ERROR
--                , SEGMENT5       VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE1     VARCHAR2(100)  PATH '$.ATTRIBUTE1' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE2     VARCHAR2(100)  PATH '$.ATTRIBUTE2' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE3     VARCHAR2(100)  PATH '$.ATTRIBUTE3' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE4     VARCHAR2(100)  PATH '$.ATTRIBUTE4' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE5     VARCHAR2(100)  PATH '$.ATTRIBUTE5' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE6     VARCHAR2(100)  PATH '$.ATTRIBUTE6' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE7     VARCHAR2(100)  PATH '$.ATTRIBUTE7' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE8     VARCHAR2(100)  PATH '$.ATTRIBUTE8' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE9     VARCHAR2(100)  PATH '$.ATTRIBUTE9' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE10    VARCHAR2(100)  PATH '$.ATTRIBUTE10' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE11    VARCHAR2(100)  PATH '$.ATTRIBUTE11' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE12    VARCHAR2(100)  PATH '$.ATTRIBUTE12' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE13    VARCHAR2(100)  PATH '$.ATTRIBUTE13' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE14    VARCHAR2(100)  PATH '$.ATTRIBUTE14' NULL ON EMPTY NULL ON ERROR
--                , ATTRIBUTE15    VARCHAR2(100)  PATH '$.ATTRIBUTE15' NULL ON EMPTY NULL ON ERROR
--              )
              COLUMNS (
                  LOOKUP_TYPE    VARCHAR2(200)  PATH '$.LOOKUP_TYPE'
                , DESCRIPTION    VARCHAR2(1000) PATH '$.DESCRIPTION' NULL ON EMPTY ERROR ON ERROR
                , DISPLAY_SEQ    NUMBER         PATH '$.DISPLAY_SEQ' NULL ON EMPTY ERROR ON ERROR
                , VALID_YN       VARCHAR2(2)    PATH '$.VALID_YN'
                , SEGMENT1       VARCHAR2(100)  PATH '$.SEGMENT1' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT2       VARCHAR2(100)  PATH '$.SEGMENT2' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT3       VARCHAR2(100)  PATH '$.SEGMENT3' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT4       VARCHAR2(100)  PATH '$.SEGMENT4' NULL ON EMPTY ERROR ON ERROR
                , SEGMENT5       VARCHAR2(100)  PATH '$.SEGMENT5' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE1     VARCHAR2(150)  PATH '$.ATTRIBUTE1' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE2     VARCHAR2(150)  PATH '$.ATTRIBUTE2' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE3     VARCHAR2(150)  PATH '$.ATTRIBUTE3' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE4     VARCHAR2(150)  PATH '$.ATTRIBUTE4' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE5     VARCHAR2(150)  PATH '$.ATTRIBUTE5' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE6     VARCHAR2(150)  PATH '$.ATTRIBUTE6' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE7     VARCHAR2(150)  PATH '$.ATTRIBUTE7' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE8     VARCHAR2(150)  PATH '$.ATTRIBUTE8' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE9     VARCHAR2(150)  PATH '$.ATTRIBUTE9' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE10    VARCHAR2(150)  PATH '$.ATTRIBUTE10' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE11    VARCHAR2(150)  PATH '$.ATTRIBUTE11' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE12    VARCHAR2(150)  PATH '$.ATTRIBUTE12' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE13    VARCHAR2(150)  PATH '$.ATTRIBUTE13' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE14    VARCHAR2(150)  PATH '$.ATTRIBUTE14' NULL ON EMPTY ERROR ON ERROR
                , ATTRIBUTE15    VARCHAR2(150)  PATH '$.ATTRIBUTE15' NULL ON EMPTY ERROR ON ERROR
              )
              -- 2026.09.17 AJS 입력 칸 길이·오류 처리 (END)
        ) JT
     ) LOOP

        V_LOOKUP_TYPE := NVL(TRIM(JT.V_LOOKUP_TYPE), '');
        V_DESCRIPTION := NVL(TRIM(JT.V_DESCRIPTION), '');
        V_DISPLAY_SEQ := JT.V_DISPLAY_SEQ;
        V_VALID_YN	  := NVL(TRIM(JT.V_VALID_YN), '');
        V_SEGMENT1    := NVL(TRIM(JT.V_SEGMENT1), '');
        V_SEGMENT2    := NVL(TRIM(JT.V_SEGMENT2), '');
        V_SEGMENT3    := NVL(TRIM(JT.V_SEGMENT3), '');
        V_SEGMENT4    := NVL(TRIM(JT.V_SEGMENT4), '');
        V_SEGMENT5    := NVL(TRIM(JT.V_SEGMENT5), '');
        V_ATTRIBUTE1    := NVL(TRIM(JT.V_ATTRIBUTE1), '');
        V_ATTRIBUTE2    := NVL(TRIM(JT.V_ATTRIBUTE2), '');
        V_ATTRIBUTE3    := NVL(TRIM(JT.V_ATTRIBUTE3), '');
        V_ATTRIBUTE4    := NVL(TRIM(JT.V_ATTRIBUTE4), '');
        V_ATTRIBUTE5    := NVL(TRIM(JT.V_ATTRIBUTE5), '');
        V_ATTRIBUTE6    := NVL(TRIM(JT.V_ATTRIBUTE6), '');
        V_ATTRIBUTE7    := NVL(TRIM(JT.V_ATTRIBUTE7), '');
        V_ATTRIBUTE8    := NVL(TRIM(JT.V_ATTRIBUTE8), '');
        V_ATTRIBUTE9    := NVL(TRIM(JT.V_ATTRIBUTE9), '');
        V_ATTRIBUTE10    := NVL(TRIM(JT.V_ATTRIBUTE10), '');
        V_ATTRIBUTE11    := NVL(TRIM(JT.V_ATTRIBUTE11), '');
        V_ATTRIBUTE12    := NVL(TRIM(JT.V_ATTRIBUTE12), '');
        V_ATTRIBUTE13    := NVL(TRIM(JT.V_ATTRIBUTE13), '');
        V_ATTRIBUTE14    := NVL(TRIM(JT.V_ATTRIBUTE14), '');
        V_ATTRIBUTE15    := NVL(TRIM(JT.V_ATTRIBUTE15), '');

        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_LOG_DESC    := '';
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(
              V_PROGRAM_NAME
            , V_LOG_TYPE
            , N_LOG_COUNT
            , V_LOG_MESSAGE
            , V_LOG_DESC
            , D_EVENT_DATE
        );

        N_HISTORY_SEQ := SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H.NEXTVAL;

        INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H (
              HISTORY_SEQ
            , LOOKUP_TYPE
            , DESCRIPTION
            , DISPLAY_SEQ
            , VALID_YN
            , SEGMENT1
            , SEGMENT2
            , SEGMENT3
            , SEGMENT4
            , SEGMENT5
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
            , ATTRIBUTE1
            , ATTRIBUTE2
            , ATTRIBUTE3
            , ATTRIBUTE4
            , ATTRIBUTE5
            , ATTRIBUTE6
            , ATTRIBUTE7
            , ATTRIBUTE8
            , ATTRIBUTE9
            , ATTRIBUTE10
            , ATTRIBUTE11
            , ATTRIBUTE12
            , ATTRIBUTE13
            , ATTRIBUTE14
            , ATTRIBUTE15
            , HISTORY_CREATION_DATE
        ) VALUES (
              N_HISTORY_SEQ
            , V_LOOKUP_TYPE
            , V_DESCRIPTION
            , V_DISPLAY_SEQ
            , V_VALID_YN
            , V_SEGMENT1
            , V_SEGMENT2
            , V_SEGMENT3
            , V_SEGMENT4
            , V_SEGMENT5
            , P_USER_ID
            , SYSDATE
            , P_USER_ID
            , SYSDATE
            , V_ATTRIBUTE1
            , V_ATTRIBUTE2
            , V_ATTRIBUTE3
            , V_ATTRIBUTE4
            , V_ATTRIBUTE5
            , V_ATTRIBUTE6
            , V_ATTRIBUTE7
            , V_ATTRIBUTE8
            , V_ATTRIBUTE9
            , V_ATTRIBUTE10
            , V_ATTRIBUTE11
            , V_ATTRIBUTE12
            , V_ATTRIBUTE13
            , V_ATTRIBUTE14
            , V_ATTRIBUTE15
            , D_EVENT_DATE
        );

        N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;
		
     END LOOP;   
--     COMMIT;
     /* 확정은 호출한 저장 프로시저에서 */   -- 2026.09.17 AJS

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(
          V_PROGRAM_NAME
        , V_LOG_TYPE
        , N_LOG_COUNT
        , V_LOG_MESSAGE
        , V_LOG_DESC
        , D_EVENT_DATE
    );

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT
          FROM DUAL;

  EXCEPTION
      WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SQLERRM;
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(
              V_PROGRAM_NAME
            , V_LOG_TYPE
            , N_LOG_COUNT
            , V_LOG_MESSAGE
            , V_LOG_DESC
            , D_EVENT_DATE
        );

        RAISE_APPLICATION_ERROR(
            -20001
          , '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_LOG_DESC
            || ' / SQLERRM=' || V_LOG_MESSAGE
            || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
            || ' / PARAMS=' || '-'
        );
  END P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST;
END PKG_SYS0010;