# DMF0082 81_UC Monthly 입력 경계월 변경 (E20261124-DMF0082UCCUTOFF)

- 대상 DB: 사내 ZIOUI1 (59.19.252.148:2521)
- 대상 객체: SCM_MGR.PKG_DMF0082 PACKAGE BODY, P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE
- 요청: 81_UC 는 Monthly 조회에서 당월부터 MKT_FCST 입력. 경계월을 지난달로 전달. 임시 작업이라 복원 방법을 주석으로 남김
- 작업 구분: 임시 작업. 복원 대상임

## 착수 시 원문

| 조회 시각 | LAST_DDL | 내용 |
|---|---|---|
| 2026-11-24 10:17:19 | 2026-11-24 10:14:35 | POJ 변경이 먼저 들어와 있음. 81_UC = CAST(NULL AS VARCHAR2(8)) (경계 미전달), 그 외 = 오늘 월 + 3개월 |

POJ 의 CASE 구조와 주석은 유지하고 81_UC THEN 값만 바꿈. 원문 백업은 00_BACKUP_PKG_DMF0082_BODY.ASIS.sql (POJ 판).

## 적용

| 단계 | 스크립트 | 적용 시각(LAST_DDL) | 변경 |
|---|---|---|---|
| 1 | apply_uc_cutoff.py | 10:17:58 | 81_UC THEN CAST(NULL ...) → THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD') |
| 2 | apply_uc_cutoff_note.py | 10:25:27 | 복원 주석 5줄 추가 (표식 E20261124-DMF0082UCCUTOFF-RESTORE). 실행 식 변경 없음 |

1, 2단계는 FRESH-GATE 통과 후 적용함. DB 반영은 끝났으나 클라이언트 응답이 제한 시간(1단계 400초, 2단계 120초) 안에 오지 않음. 반영 여부는 ALL_OBJECTS, ALL_SOURCE 재조회로 확인함.

## 검증 (verify.log, 10:28)

- PACKAGE BODY VALID, ALL_ERRORS 0건, DMF0082 INVALID 객체 0건
- DB 원문 = 03_PKG_DMF0082_BODY_UC_CUTOFF_FINAL.sql 일치
- P_DMF0082_GET_MAIN_DATA 호출 결과 O_RC2 첫 행 M3_CUTOFF_DATE

| 사업부 | 값 | 화면 기준월 |
|---|---|---|
| 81_UC | 20261001 | 202610 (2026-11 부터 입력) |
| 81 | 20270201 | 202702 (변경 없음) |
| 40 | 20270201 | 202702 (변경 없음) |

## 적용 범위

- SP 에는 조회 Bucket 입력값이 없음. 화면이 Monthly 조회일 때만 이 경계월로 월 칸을 잠그므로(ForecastPriceGridUtils.ts isM4Locked) Weekly, Daily 는 영향 없음
- 경계월은 MKT_FCST, SCM_FCST, VMI_In_Req 3개 메저에 같이 걸림. 81_UC 는 3개 메저가 당월부터 입력됨
- 당월 이전 월은 화면의 별도 규칙으로 잠긴 채 유지됨
- Excel Upload(P_DMF0082_EXCEL_UPLOAD, P_DMF0082_GET_EXCEL_UPLOAD_DATA)의 M+3, M+4 식은 변경 안 함

## 복원

PKG 안 표식 E20261124-DMF0082UCCUTOFF-RESTORE 주석을 따름.
- POJ 판으로 복원: 00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
- 1단계본(복원 주석 없음): 02_BACKUP_PKG_DMF0082_BODY_STEP1.ASIS.sql
- 복원할 때도 그 시점 DB 원문을 다시 조회해 다른 변경이 없을 때만 백업본으로 교체함

## 클라우드 이관 패키지

- 전달본: _artifacts/_deploy_packages/DMF0082_UC_CUTOFF_CLOUD_20261124_1037 (build_cloud_pkg_uc_cutoff.py, 리허설 rehearse.log)
- cloud_pkg.py 생성본 DMF0082_CLOUD_DB_MOD_20261124_1029 는 사용 안 함. PACKAGE BODY 기준 문구를 1단계 적용본으로 잡아 클라우드에서 중단(-20011)되고, 요청 밖 PACKAGE SPEC 패치와 META 동기화가 섞여 있음
