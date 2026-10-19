--------------------------------------------------------------------------------
-- DMF0082 SCM_FCST 편집 게이트 — 사내/클라우드 차이 진단 (읽기 전용)
--
-- 증상 : 룩업을 WED 10:00~19:00 로 동일 설정하고 40 division SCP Planner(dodae)로
--        로그인했을 때, 사내는 SCM_FCST 편집 가능 / 클라우드는 편집 불가.
--
-- 사용 : 클라우드에 SCM_MGR 로 접속해 그대로 실행하고, 각 섹션 결과를 회신.
--        사내 실측값을 [사내] 로 병기했으니 다른 항목만 보면 된다.
--
-- ⚠ 실행 시각이 중요하다. 룩업 창(WED 10:00~19:00) 안에 있어야 의미가 있으므로
--   한국시간 수요일 10~19시 사이에 실행할 것. 실행 시각도 함께 회신.
--------------------------------------------------------------------------------
SET LINESIZE 220
SET PAGESIZE 200
COLUMN 항목    FORMAT A38
COLUMN 값      FORMAT A62
COLUMN 사내값  FORMAT A34

PROMPT ================================================================
PROMPT [A] DB 서버 시각·시간대   ★ 1순위 의심 축
PROMPT ================================================================
SELECT '접속 DB'                              AS 항목, SYS_CONTEXT('USERENV','DB_NAME')                             AS 값, 'ZIOUI1'              AS 사내값 FROM DUAL
UNION ALL SELECT '서버 호스트',                     SYS_CONTEXT('USERENV','SERVER_HOST'),                                  'itx'                  FROM DUAL
UNION ALL SELECT 'SYSDATE',                        TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),                              '2026-09-09 14:14:20'  FROM DUAL
UNION ALL SELECT '★ 요일 TO_CHAR(SYSDATE,''DY'')',  TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH'),                     'WED'                  FROM DUAL
UNION ALL SELECT '★ 시각 TO_CHAR(SYSDATE,''HH24MI'')', TO_CHAR(SYSDATE,'HH24MI'),                                          '1414'                 FROM DUAL
UNION ALL SELECT '★ DBTIMEZONE',                   DBTIMEZONE,                                                            '+09:00'               FROM DUAL
UNION ALL SELECT 'SESSIONTIMEZONE',                SESSIONTIMEZONE,                                                       '+09:00'               FROM DUAL
UNION ALL SELECT 'SYSTIMESTAMP',                   TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS TZH:TZM'),                 '… +09:00'             FROM DUAL
UNION ALL SELECT 'UTC 대비 서버 오프셋(시간)',        TO_CHAR(ROUND((CAST(SYSTIMESTAMP AS DATE) - SYS_EXTRACT_UTC(SYSTIMESTAMP)) * 24, 2)), '9'   FROM DUAL;

PROMPT
PROMPT >> 판정: DBTIMEZONE/SYSDATE 가 +09:00(KST)이 아니면 여기가 원인이다.
PROMPT    편집 시간창은 룩업의 '1000'~'1900' 문자열을 TO_CHAR(SYSDATE,'HH24MI') 와
PROMPT    문자열 비교한다. 서버가 UTC 면 한국 14:14 가 '0514' 로 나와 '1000' <= '0514' 가
PROMPT    거짓이 되어 창 밖으로 떨어진다(= 편집 불가).

PROMPT
PROMPT ================================================================
PROMPT [B] GET_ADMIN_GROUP_MEASURE 룩업 (DMF0082 / division 40)
PROMPT ================================================================
COLUMN GRP FORMAT A16
COLUMN MEASURE FORMAT A14
COLUMN DAYS FORMAT A12
SELECT SEGMENT1 AS GRP, SEGMENT3 AS DIV, SEGMENT4 AS MEASURE
     , ATTRIBUTE1 AS DAYS, ATTRIBUTE2 AS FROM_T, ATTRIBUTE3 AS TO_T
     , ATTRIBUTE4 AS LIMIT_M, VALID_YN
     , LENGTH(SEGMENT1) AS L_GRP, LENGTH(ATTRIBUTE1) AS L_DAYS   -- 앞뒤 공백 검출용
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
   AND SEGMENT2 = 'DMF0082' AND SEGMENT3 = '40'
 ORDER BY SEGMENT4, SEGMENT1;

PROMPT
PROMPT >> [사내] SCM_FCST 행 3건 = ADMIN / SCM PI Admin / SCP Planner
PROMPT    전부 DAYS='WED'(L_DAYS=3) FROM='1000' TO='1900' LIMIT='MKT_FCST' VALID='Y'
PROMPT    L_GRP('SCP Planner')=11 — 길이가 다르면 공백 혼입이다.

PROMPT
PROMPT ================================================================
PROMPT [C] 사용자 그룹 매핑 (dodae)
PROMPT ================================================================
SELECT USER_ID, USER_GR_ID, USE_YN, LENGTH(USER_GR_ID) AS L_GR
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'dodae' ORDER BY USER_GR_ID;

PROMPT
PROMPT >> [사내] 1행 — USER_GR_ID='SCP Planner' (L_GR=11) / USE_YN='Y'

PROMPT
PROMPT ================================================================
PROMPT [D] 편집창 통과 여부 시뮬레이션 (SP 의 INTO 적재 조건 그대로)
PROMPT ================================================================
COLUMN 판정 FORMAT A46
SELECT B.USER_GROUP, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME
     , CASE WHEN (REPLACE(B.DAYS,' ','') IS NULL OR B.DAYS = TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH'))
            THEN 'OK' ELSE 'FAIL(요일)' END AS 요일
     , CASE WHEN (REPLACE(B.FROM_TIME,' ','') IS NULL OR B.FROM_TIME <= TO_CHAR(SYSDATE,'HH24MI'))
             AND (REPLACE(B.TO_TIME,' ','')   IS NULL OR B.TO_TIME   >= TO_CHAR(SYSDATE,'HH24MI'))
            THEN 'OK' ELSE 'FAIL(시간창)' END AS 시간
     , CASE WHEN (REPLACE(B.DAYS,' ','') IS NULL OR B.DAYS = TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH'))
             AND (REPLACE(B.FROM_TIME,' ','') IS NULL OR B.FROM_TIME <= TO_CHAR(SYSDATE,'HH24MI'))
             AND (REPLACE(B.TO_TIME,' ','')   IS NULL OR B.TO_TIME   >= TO_CHAR(SYSDATE,'HH24MI'))
            THEN '통과 → EDIT_AUTH_YN=Y' ELSE '탈락 → 편집 불가' END AS 판정
  FROM (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT4 AS MEASURE
             , REGEXP_SUBSTR(A.ATTRIBUTE1,'[^,]+',1,1) AS DAYS
             , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
         WHERE A.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND A.VALID_YN='Y'
           AND A.SEGMENT2='DMF0082' AND A.SEGMENT3='40'
           AND (A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                WHERE G.USER_ID='dodae' AND G.USE_YN='Y'))) B
 ORDER BY B.MEASURE;

PROMPT
PROMPT >> [사내] SCM_FCST 1행이 요일 OK / 시간 OK / '통과 → EDIT_AUTH_YN=Y'
PROMPT    여기서 FAIL(시간창) 이 나오면 [A] 의 서버 시각이 원인으로 확정된다.

PROMPT
PROMPT ================================================================
PROMPT [E] PKG_DMF0082 세대 확인
PROMPT ================================================================
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;

SELECT '본문 라인수' AS 항목, TO_CHAR(COUNT(*)) AS 값, '15266' AS 사내값
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
UNION ALL SELECT 'AUTHUNION(보유그룹 합집합)',        TO_CHAR(COUNT(*)), '9'
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'AUTHUNION')>0
UNION ALL SELECT 'E20260819-LIMITMEAS',              TO_CHAR(COUNT(*)), '5'
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260819-LIMITMEAS')>0
UNION ALL SELECT 'E20260826-AUTHVIEW(T 잠금)',        TO_CHAR(COUNT(*)), '3'
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260826-AUTHVIEW')>0
UNION ALL SELECT 'E20260825-SCPPLOC',                TO_CHAR(COUNT(*)), '1'
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260825-SCPPLOC')>0
UNION ALL SELECT 'E20260907-LIMITMEAS-DIV(사내전용)',  TO_CHAR(COUNT(*)), '2'
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260907-LIMITMEAS-DIV')>0;

PROMPT
PROMPT >> 편집게이트 로직(AUTHUNION / LIMITMEAS / AUTHVIEW / SCPPLOC)은 09-07 클라우드본에도
PROMPT    이미 있다. 이 값들이 사내와 같으면 코드 세대는 원인이 아니다.

PROMPT
PROMPT ================================================================
PROMPT [F] 메저 마스터 — SCM_FCST 가 40 에 노출되는지
PROMPT ================================================================
COLUMN DIVISION_ID FORMAT A46
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VALID_YN, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='DMF0082' AND COLUMN_NAME IN ('SCM_FCST','MKT_FCST')
 ORDER BY COLUMN_NAME;

PROMPT
PROMPT >> [사내] SCM_FCST : DIVISION_ID='40,81,81_UC,81_HM,81_ST,81_HD,81_HG' / VALID_YN='Y' / SORT=45
PROMPT           MKT_FCST : DIVISION_ID='40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82' / VALID_YN='Y' / SORT=20
PROMPT    SCM_FCST 의 DIVISION_ID 에 '40' 이 없으면 메저 자체가 40 에서 안 뜬다.

PROMPT
PROMPT ================================================================
PROMPT [G] DM_UI_EDITABLE_MEASURE (편집후보 룩업)
PROMPT ================================================================
SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE2, VALID_YN
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE'
   AND (SEGMENT2='40' OR SEGMENT1='40' OR SEGMENT3='40')
 ORDER BY 1,2,3,4;

PROMPT
PROMPT >> [사내] 4행 — SEGMENT2='40' 기준
PROMPT      LOC(A1=Y,A2=Y) / MKT_FCST(A1=Y,A2=Y) / SCM_FCST(A1=N,A2=Y) / VMI_In_Req(A1=Y,A2=Y)
PROMPT    ⚠ SCM_FCST 의 ATTRIBUTE1 이 'N' 인 것은 사내도 동일하다(그럼에도 사내는 편집 가능).
PROMPT      이 행이 클라우드에 아예 없거나 VALID_YN='N' 이면 그때는 원인이 된다.

PROMPT
PROMPT ================================================================
PROMPT 회신 요청 : [A]~[G] 전체 출력 + 실행한 한국시간
PROMPT ================================================================
