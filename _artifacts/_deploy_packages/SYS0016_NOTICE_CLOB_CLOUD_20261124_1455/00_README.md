# SYS0016 Notice Setup 공지 본문 CLOB 전환

- 대상: SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER.NOTICE_CONTENT, SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_H.NOTICE_CONTENT, SCM_MGR.PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST, SCM_MGR.PKG_SYS0016 재컴파일
- 기준본: 사내 ZIOUI1, 조회 2026-11-24 14:49 (PKG_SYS0016 LAST_DDL 13:56:50, HIST 프로시저 LAST_DDL 2026-11-23 17:36:12)
- 실행 계정: SCM_MGR 또는 SCM_MGR 객체 DDL 권한 계정, 전체 F5, 반복 실행 가능

## 변경 내용

| 객체 | 변경 전 | 변경 후 |
|---|---|---|
| SCM_ADM_NOTICE_CONTENT_MASTER.NOTICE_CONTENT | VARCHAR2(4000 CHAR) | CLOB |
| SCM_ADM_NOTICE_CONTENT_MASTER_H.NOTICE_CONTENT | VARCHAR2(4000 CHAR) | CLOB |
| PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST 본문 받는 칸 P_CONTENT | VARCHAR2 | CLOB |
| PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST 로그 JSON | 본문 전체 | 본문 길이(P_CONTENT_LEN) |
| PKG_SYS0016 | 변경 없음 | 재컴파일 |

- 컬럼은 임시 컬럼 추가, 값 복사, 대조, 기존 컬럼 삭제, 이름 변경 순서로 바꿈. 대조가 1건이라도 다르면 오류로 멈추고 기존 컬럼을 지우지 않음
- NOTICE_CONTENT 컬럼 위치가 표 맨 뒤로 바뀜. 컬럼 이름으로 읽는 SQL 은 영향 없음
- HIST 프로시저는 클라우드 원문에서 앵커 2개('P_CONTENT         VARCHAR2', 'P_CONTENT' VALUE P_CONTENT)만 바꿈. 앵커가 없으면 -20003 오류로 멈추고 원문을 바꾸지 않음
- 실행 전 표 2개를 _BAK20261124 이름으로 복사해 둠

## 실행 순서

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/00_PRECHECK_CLOUD.sql | 읽기 전용. 컬럼 형식, 행 수, HIST 앵커, 객체 상태 출력 |
| 2 | A_DB/10_APPLY_NOTICE_CONTENT_CLOB.sql | 백업 표 생성, CLOB 전환, HIST 수정, PKG_SYS0016 재컴파일 |
| 3 | A_DB/90_VERIFY_NOTICE_CONTENT_CLOB.sql | 읽기 전용. 기대값 = PASS 13건, VERIFY OK. 2번 직후에 실행함. 그 사이 화면에서 공지를 저장하면 백업 대조 항목이 FAIL 로 나옴 |
| 문제 시 | A_DB/99_ROLLBACK_NOTICE_CONTENT_CLOB.sql | VARCHAR2(4000 CHAR) 로 원복. 본문 4000 byte 넘는 행이 있으면 -20091 로 멈춤 |

## 사내 리허설 (2026-11-24)

| 단계 | 결과 |
|---|---|
| 10 적용 14:51 | 백업 2개 생성, 표 2개 CLOB, HIST 수정, PKG_SYS0016 VALID |
| 90 확인 14:52 | PASS 13건 |
| 저장 확인 14:52 | 116,607 byte 신규 저장, 150,807 byte 수정 저장, 이력 기록, 삭제 일치. 끝에 ROLLBACK 해 행 수 45, 54 그대로 |
| 99 원복 14:54 | HIST DDL = 수정 전 원문, 표 2개 VARCHAR2(4000 CHAR), 행 수·글자 수 그대로 |
| 99 재실행 | SKIP 3건 |
| 10 재적용 | 표 2개, HIST DDL = 첫 적용본 |
| 10 재실행 | SKIP 3건 |
| 90 확인 14:54 | PASS 13건 |

- 사내 DB 는 compatible 23.6.0 임. 클라우드 19c 에서 실행한 기록은 없음(미확인)
- 스크립트는 19c 에 있는 구문(EXECUTE IMMEDIATE CLOB, DBMS_LOB.COMPARE, ALL_TAB_COLUMNS)만 씀

## 화면

- FE·BE 변경 없이 동작함. 서버가 CLOB 값을 글자로 바꿔 넘김
- 첨부파일 기능의 서버 경로는 없음. 가이드 Doc/verify/SYS0016/FE_GUIDE_20261124_1455.md
