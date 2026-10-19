-- [E20261008-SLASHOBJ] 01b_CLOUD_BACKUP_EXPORT_JSONL — 백업 테이블 최신 회차를 JSON Lines 파일로 내보내기(선택) · 생성 2026-10-08 18:40 · 대상 96객체(사내 현재 원문 스냅샷 2026-10-08T17:26) · SCM_MGR 접속 후 파일 전체 실행(F5)
--   · 한 줄 = 원문 한 줄 {"t":객체유형,"n":객체명,"l":줄,"p":조각(보통 1),"s":텍스트,"run":회차}. 결과가 수십만 줄이므로 SQLcl / SQL*Plus 권장.
--   · SQL Developer 는 [도구 > 환경설정 > 데이터베이스 > 워크시트 > 스크립트에서 출력할 최대 행수] 를 1,000,000 으로 올린 뒤 실행. 파일은 실행 디렉터리의 00_CLOUD_BACKUP_CLOUD.jsonl 로 생성(환경명으로 바꿔 보관).
--   · 이 파일은 cloud_tool.py rollback --from x.jsonl 로도 복원 가능. SQL 만 쓸 때의 원복은 99_*.sql(백업 테이블) 사용.

SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON TRIMOUT ON FEEDBACK OFF HEADING OFF VERIFY OFF
SET LONG 2000000 LONGCHUNKSIZE 2000000
SET DEFINE OFF
SPOOL 00_CLOUD_BACKUP_CLOUD.jsonl
SELECT JSON_OBJECT('t' VALUE obj_type, 'n' VALUE obj_name, 'l' VALUE line, 'p' VALUE piece, 's' VALUE RTRIM(text, CHR(10) || CHR(13)), 'run' VALUE bak_run RETURNING CLOB)
  FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008
 WHERE bak_run = (SELECT MAX(bak_run) FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008)
   AND line > 0
 ORDER BY obj_type, obj_name, line, piece;
SPOOL OFF
