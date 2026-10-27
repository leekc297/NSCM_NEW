/*=============================================================================================================
 * 02_EXPORT_CLOUD_SOURCE — 클라우드 PKG_DMF0020 SPEC/BODY 원문을 파일로 내보내기 (조회 전용 · 데이터 변경 없음)
 *   사유: 10_APPLY 가 클라우드 원문에서 앵커를 찾지 못해 중단(원문 무변경). 클라우드 BODY 는 2026-10-15 11:58 판으로
 *         사내 원문과 다르다 → 클라우드 원문 기준으로 패치를 다시 만든다.
 *   실행: SQL Developer · SCM_MGR 접속 · 전체 선택 → F5 (스크립트 실행)
 *   결과: D:\Downloads\Source\PKG_DMF0020_CLOUD_SRC.txt  (약 1MB · 기존 폴더 D:\Downloads\Source 사용 — SQL Developer 는 폴더를 새로 만들지 못한다: SP2-0556)
 *         다른 폴더에 저장하려면 아래 SPOOL 경로를 이미 있는 폴더로 바꿔 주세요.
 *         → 이 파일을 C:\Projects\NSCM\_artifacts\_cloud_to_corp\DMF0020_SAVECLOB_20261021\ 에 복사해 주세요.
 *   형식: 한 줄 = 원문 한 줄. 탭·줄바꿈은 {TAB}·{LF}·{CR} 로 바꿔 적어 공백이 손실되지 않게 했다(파일 끝 '|#' 표지).
 *         마지막 줄 'END|줄수' 가 있으면 완전한 파일.
 *=============================================================================================================*/
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 32767
SET LONG 2000000
SET TRIMSPOOL ON
SET TRIMOUT ON
SET DEFINE OFF
SPOOL D:\Downloads\Source\PKG_DMF0020_CLOUD_SRC.txt
SELECT 'META|' || SYS_CONTEXT('USERENV','DB_NAME') || '|' || USER || '|' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT 'OBJ|' || OBJECT_TYPE || '|' || STATUS || '|' || TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') || '|' ||
       (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME = O.OBJECT_NAME AND S.TYPE = O.OBJECT_TYPE)
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME = 'PKG_DMF0020' ORDER BY OBJECT_TYPE;
SELECT CASE TYPE WHEN 'PACKAGE' THEN 'S' ELSE 'B' END || '|' || LPAD(LINE, 6, '0') || '|' ||
       REPLACE(REPLACE(REPLACE(TEXT, CHR(13), '{CR}'), CHR(10), '{LF}'), CHR(9), '{TAB}') || '|#'
  FROM USER_SOURCE
 WHERE NAME = 'PKG_DMF0020' AND TYPE IN ('PACKAGE', 'PACKAGE BODY')
 ORDER BY TYPE, LINE;
SELECT 'END|' || COUNT(*) FROM USER_SOURCE WHERE NAME = 'PKG_DMF0020' AND TYPE IN ('PACKAGE', 'PACKAGE BODY');
SPOOL OFF
SET HEADING ON
SET FEEDBACK ON
SET PAGESIZE 50
PROMPT 완료 — D:\Downloads\Source\PKG_DMF0020_CLOUD_SRC.txt (마지막 줄 END|줄수 확인)
