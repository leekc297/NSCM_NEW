--------------------------------------------------------------------------------
-- 00_PRECHECK — 적용 전 클라우드 현재 상태 확인 (읽기 전용)
-- 실행 : SCM_MGR 접속 후 그대로 실행. 결과를 보고 10_PATCH 실행 여부를 판단한다.
--------------------------------------------------------------------------------
SET LINESIZE 200
SET PAGESIZE 100
COLUMN 항목 FORMAT A46
COLUMN 값   FORMAT A70

PROMPT === [1] 대상 객체 상태 ===
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

PROMPT === [2] 패치 적용 가능 여부 ===
SELECT '본문 총 라인수' AS 항목,
       TO_CHAR(COUNT(*)) AS 값
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
UNION ALL
SELECT '구 문구 LIVE 라인 (기대 1 = 적용가능)',
       TO_CHAR(COUNT(*))
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND INSTR(TEXT, q'[V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK]') > 0
   AND LTRIM(TEXT) NOT LIKE '--%'
UNION ALL
SELECT '신 문구 라인 (기대 0 = 미적용 상태)',
       TO_CHAR(COUNT(*))
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND INSTR(TEXT, 'MDM에서 Biz Type을 입력하시기') > 0
UNION ALL
SELECT '판정',
       CASE WHEN (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
                   AND INSTR(TEXT,'MDM에서 Biz Type을 입력하시기') > 0) > 0
                 THEN 'SKIP — 이미 적용됨'
            WHEN (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
                   AND INSTR(TEXT, q'[V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK]') > 0
                   AND LTRIM(TEXT) NOT LIKE '--%') = 1
                 THEN 'GO — 10_PATCH 실행 가능'
            ELSE 'STOP — 대상 라인 수 이상. 담당자 확인 필요'
       END
  FROM DUAL;

PROMPT === [3] 대상 라인 원문 (치환 전) ===
SELECT LINE, TEXT FROM USER_SOURCE
 WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND INSTR(TEXT, 'BIZ_TYPE 이 없어서') > 0
 ORDER BY LINE;
