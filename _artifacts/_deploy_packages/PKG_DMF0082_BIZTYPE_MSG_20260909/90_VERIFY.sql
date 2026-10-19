--------------------------------------------------------------------------------
-- 90_VERIFY — 적용 후 검증 (읽기 전용). 4 항목 전부 PASS 여야 완료.
--------------------------------------------------------------------------------
SET LINESIZE 220
SET PAGESIZE 100
COLUMN 게이트 FORMAT A40
COLUMN 결과   FORMAT A8
COLUMN 실측   FORMAT A80

PROMPT === 적용 후 변경 지점 원문 ===
SELECT LINE, TEXT FROM USER_SOURCE
 WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND (INSTR(TEXT,'E20260608-000294') > 0 OR INSTR(TEXT,'BIZ_TYPE 이 없어서') > 0
        OR INSTR(TEXT,'MDM에서 Biz Type') > 0 OR INSTR(TEXT,'SCM_FP에 CSR') > 0)
 ORDER BY LINE;

PROMPT === 게이트 ===
WITH G AS (
  SELECT
    (SELECT COUNT(*) FROM USER_OBJECTS
      WHERE OBJECT_NAME='PKG_DMF0082' AND STATUS='VALID')                              AS g1_valid,
    (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
      AND INSTR(TEXT,'MDM에서 Biz Type을 입력하시기') > 0
      AND LTRIM(TEXT) NOT LIKE '--%')                                                  AS g2_new_live,
    (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
      AND INSTR(TEXT, q'[V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK]') > 0
      AND LTRIM(TEXT) NOT LIKE '--%')                                                  AS g3_old_live,
    (SELECT COUNT(*) FROM USER_ERRORS
      WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY')                                AS g4_err
  FROM DUAL
)
SELECT 'G1 PACKAGE+BODY 둘 다 VALID'   AS 게이트, CASE WHEN g1_valid=2 THEN 'PASS' ELSE 'FAIL' END AS 결과, '실측 '||g1_valid||' / 기대 2' AS 실측 FROM G
UNION ALL SELECT 'G2 신 문구 LIVE 1건',   CASE WHEN g2_new_live=1 THEN 'PASS' ELSE 'FAIL' END, '실측 '||g2_new_live||' / 기대 1' FROM G
UNION ALL SELECT 'G3 구 문구 LIVE 0건',   CASE WHEN g3_old_live=0 THEN 'PASS' ELSE 'FAIL' END, '실측 '||g3_old_live||' / 기대 0' FROM G
UNION ALL SELECT 'G4 컴파일 오류 0건',     CASE WHEN g4_err=0 THEN 'PASS' ELSE 'FAIL' END, '실측 '||g4_err||' / 기대 0' FROM G;

PROMPT === 의존 객체 INVALID 연쇄 (기대 0건) ===
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS
  FROM USER_OBJECTS O
  JOIN USER_DEPENDENCIES D ON D.NAME = O.OBJECT_NAME AND D.TYPE = O.OBJECT_TYPE
 WHERE D.REFERENCED_NAME = 'PKG_DMF0082' AND O.STATUS <> 'VALID';
