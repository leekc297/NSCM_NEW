# DMF0082 81_UC Monthly 입력 경계월 변경 클라우드 이관 패키지 (임시 작업)

- 생성: 2026-11-24 10:37, _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/build_cloud_pkg_uc_cutoff.py
- 원천: 사내 ZIOUI1 PKG_DMF0082 PACKAGE BODY, LAST_DDL 2026-11-24 10:25:27, 조회 2026-11-24 10:37
- 표식: E20261124-DMF0082UCCUTOFF, 복원 주석 E20261124-DMF0082UCCUTOFF-RESTORE

## 변경 내용

P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE 구간 1곳만 바꿈. 그 외 PKG 원문, 메타는 변경 없음.

| 사업부 | 변경 전 | 변경 후 |
|---|---|---|
| 81_UC | 오늘 월 + 3개월 (2026-11 기준 20270201) | 지난달 1일 (2026-11 기준 20261001) |
| 그 외 | 오늘 월 + 3개월 | 변경 없음 |

화면은 Monthly 조회일 때만 이 값으로 MKT_FCST, SCM_FCST, VMI_In_Req 월 칸을 잠금. 81_UC 는 Monthly 에서 당월부터 3개 메저 입력 가능함. Weekly, Daily 는 영향 없음. 화면 소스 변경 없음.

## 클라우드 원문 대응

| 클라우드 구간 원문 | 처리 |
|---|---|
| A: M+3 한 줄 (11-23 판) | 구간 치환 후 컴파일 |
| B: POJ 판 (81_UC NULL, 2026-11-24 10:14 사내 변경) | 구간 치환 후 컴파일 |
| 이미 변경됨 | SKIP |
| 그 외 | 중단, 원문 변경 없음. 구간 원문을 전달 바람 |

컴파일 오류가 나면 원문으로 자동 복원함.

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. A_DB/05_BACKUP_CLOUD.sql: 현재 PACKAGE BODY 원문을 ZB_DMF0082_UCCUT_20261124_SRC 표로 보관
2. A_DB/20_PKG_BODY_PKG_DMF0082_UC_CUTOFF.sql: Output 창에서 APPLY, SKIP, 중단 줄 확인
3. A_DB/90_VERIFY.sql: PACKAGE BODY VALID, 오류 0건, 표식 줄 확인
4. A_DB/99_ROLLBACK.sql: 문제가 있을 때만 실행. 05 백업본으로 복원

## 사내 리허설 (2026-11-24, DB 변경 없음)

20_PKG 블록을 DRY 로 실행함. 원문 읽기만 입력값으로 바꿈.
- A 판: 기준 A(M+3), 패치 적용 가능
- B 판: 기준 B(POJ), 패치 적용 가능
- 현재 사내본: SKIP
- B 판에 같은 치환을 하면 결과가 현재 사내 원문과 일치함

## 복원 (임시 작업 종료 때)

PKG 안 E20261124-DMF0082UCCUTOFF-RESTORE 주석의 ① 또는 ② 방법을 따름. 클라우드는 99_ROLLBACK.sql 로 이관 전 원문 복원 가능함.
