# DMF0082 Monthly 입력 경계월 사업부별 분리 + 81 계열 당월 입력 (E20261124-DMF0082DIVCUTOFF-CURMON)

- 대상: SCM_MGR.PKG_DMF0082 PACKAGE BODY, P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE 구간 1곳
- 기준본: 사내 ZIOUI1, LAST_DDL 2026-11-24 13:36:33, 조회 2026-11-24 13:40
- 실행 계정: SCM_MGR, 전체 F5, 반복 실행 가능

## 변경 내용

| 사업부 | 경계월(M3_CUTOFF_DATE) | Monthly 입력 시작 |
|---|---|---|
| 40, 82 | 오늘 월 + 3개월 (종전) | 당월 + 4개월 |
| 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC | 지난달 | 당월 |

- 사용자 지시 2026-11-24 13:35: 81, 81 JV 당월도 수정 가능하도록 변경
- DMF0082_UC_CUTOFF_CLOUD_20261124_1037, DMF0082_DIV_CUTOFF_TEMP_CLOUD_20261124_1144 패키지는 이 패키지로 대체함. 먼저 실행할 필요 없음
- 1144 패키지를 이 패키지 뒤에 실행하면 -20011 로 중단되고 원문은 바뀌지 않음

## 실행 순서

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/05_BACKUP_CLOUD.sql | 클라우드 원문을 표 ZB_DMF0082_DIVCUTC_20261124_SRC 에 보관. 표가 있으면 건너뜀 |
| 2 | A_DB/20_PKG_BODY_PKG_DMF0082_DIV_CUTOFF_CURMON.sql | 구간 치환 후 컴파일. 컴파일 오류면 원문 자동 복원 |
| 3 | A_DB/90_VERIFY.sql | 읽기 전용 확인. 기대값 = PACKAGE BODY VALID, 오류 0, 표식 줄 2건 |
| 문제 시 | A_DB/99_ROLLBACK.sql | 1번 백업 원문으로 복원 |

## 클라우드 원문별 동작 (사내 DRY 리허설 2026-11-24 13:40)

| 클라우드 원문 | 결과 |
|---|---|
| A: M+3 한 줄 (11-23 판) | 치환 적용 |
| B: POJ 판 (81_UC 경계 미전달) | 치환 적용 |
| C: 81_UC 지난달 (1037 패키지 적용본) | 치환 적용 |
| D: 81 계열 지난달 (사내 11:36 표준판) | 치환 적용 |
| E: 81 계열 당월 임시판 (1144 패키지 적용본, 사내 11:40 판) | 치환 적용 |
| 이미 반영됨 | SKIP, 원문 무변경 |
| 그 외 | -20011 오류로 중단, 원문 무변경. 구간 원문 전달 필요 |

## 화면

- FE 변경 없음. 화면은 Monthly 조회에서 경계월 이하 월의 MKT_FCST, SCM_FCST, VMI_In_Req 칸을 잠금(ForecastPriceGridUtils.ts isM4Locked)
- Weekly, Daily 조회에는 경계월 규칙이 걸리지 않음
