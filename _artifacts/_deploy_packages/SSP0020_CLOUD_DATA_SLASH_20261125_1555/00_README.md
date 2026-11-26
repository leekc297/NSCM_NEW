# SSP0020 위임 '/' 데이터 삭제 (클라우드)

대상 테이블: SCM_MGR.SSP_MST_DELEGATE
대상 행: DELEGATEE_ID, USER_ID, DIVISION_ID 중 하나가 '/' 인 행

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | 10_SELECT_SLASH.sql | 대상 행 조회, 건수 기록 |
| 2 | 20_BACKUP_DELETE_SLASH.sql | 백업 테이블 SSP_MST_DELEGATE_BAK20261125_SLASH 저장 뒤 같은 건수일 때만 삭제·COMMIT |
| 3 | 90_VERIFY.sql | 남은 '/' 0건, 백업 행, 오늘 유효 위임 2건 이상인 위임자 확인 |
| 되돌리기 | 99_ROLLBACK.sql | 백업 테이블 행 다시 넣음, 이미 있는 행은 건너뜀 |

- 실행: DBeaver 스크립트 전체 실행(Alt+X). 20 의 출력은 Output 창에서 확인함
- 20 은 다시 실행해도 됨. 대상 0건이면 변경 없음
- 백업 테이블 생성 권한(CREATE TABLE)이 없으면 20 이 오류로 멈추고 삭제하지 않음
- 사내 ZIOUI1: 2026-11-25 15:53 1건 삭제함(40, chahg, '/', 20261103~20271231). 백업 = 같은 이름 백업 테이블, Doc/verify/SSP0020/applied/SSP_MST_DELEGATE_slash_deleted_20261125_155330.csv
- 사내 리허설: 임시 복사 테이블로 10 → 20 → 90 → 20 재실행 → 99 → 99 재실행 오류 0
