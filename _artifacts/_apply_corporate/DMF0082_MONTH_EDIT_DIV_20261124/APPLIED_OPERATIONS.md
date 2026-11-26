# DMF0082 Monthly 입력 경계월 사업부별 분리 (E20261124-DMF0082DIVCUTOFF, -TEMP, -CURMON)

- 대상 DB: 사내 ZIOUI1 (59.19.252.148:2521)
- 대상 객체: SCM_MGR.PKG_DMF0082 PACKAGE BODY, P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE
- 요청(2026-11-24): 40 = 당월 + 3개월까지 잠금, 81과 81 JV = 당월부터 입력. 이어서 임시 조치로 81과 81 JV = 익월부터 입력(UI 버그 수정 뒤 당월부터로 정정 예정)
- 근거: AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음(DMF0003_MktFcst.cs:2957~2971). M+3 규칙은 AS-IS DMF0082 의 40 사업부에만 있음
- 81 JV 코드: SCM_MST_DIVISION 실측 81_HD, 81_HG, 81_HM, 81_ST, 81_UC. 81 포함 6개를 LIKE '81%' 로 묶음
- 82 는 요청에 없어 종전(+3개월) 유지

## 착수 시 원문

| 조회 시각 | LAST_DDL | 내용 |
|---|---|---|
| 2026-11-24 11:34:01 | 2026-11-24 10:25:27 | 81_UC 만 경계 지난달(E20261124-DMF0082UCCUTOFF), 그 외 오늘 월 + 3개월 |

## 적용

| 단계 | 스크립트 | LAST_DDL | 변경 | 컴파일 |
|---|---|---|---|---|
| 1 표준 | apply_month_edit_div.py | 11:36:44 | CASE WHEN p_division_id = '81_UC' → LIKE '81%', 주석 교체 | 91.9초, VALID, 오류 0 |
| 2 임시 | apply_temp_next_month.py | 11:40:00 | 81 계열 THEN 경계 지난달 → 당월, 복원 주석 3줄 | 162.0초, VALID, 오류 0 |
| 3 당월 | apply_restore_current_month.py | 13:36:33 | 사용자 지시 13:35 81, 81 JV 당월 수정 허용. 81 계열 THEN 경계 당월 → 지난달, 임시 주석 4줄 → 종전 기록 주석 2줄. 백업 04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql, 적용본 05_PKG_DMF0082_BODY_DIV_CUTOFF_CURMON.sql | 160.2초, VALID, 오류 0 |

1, 2, 3단계는 적용 직전 FRESH-GATE 통과. DMF0082 INVALID 객체 0건.

## 검증 (temp_verify.log, DB SYSDATE 2026-11-24 11:42:58)

P_DMF0082_GET_MAIN_DATA 호출(조회 2026-11-01 ~ 2027-12-31, 품목 ZZ_NO_ITEM_DIVCUTOFF), O_RC2 14행의 M3_CUTOFF_DATE 값

| 사업부 | 값 | 화면 잠금 | 입력 시작 |
|---|---|---|---|
| 40 | 20270201 | 2027-02 까지 | 2027-03 |
| 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC | 20261101 | 2026-11 까지 | 2026-12 |
| 82 | 20270201 | 2027-02 까지 | 2027-03 |

1단계(표준) 직후 검증(verify.log 11:38:40): 81 계열 6개 = 20261001(2026-11 부터 입력), 40, 82 = 20270201.

## 3단계 검증 (curmon_verify.log, DB SYSDATE 2026-11-24 13:39:22)

| 사업부 | 값 | 화면 잠금 | 입력 시작 |
|---|---|---|---|
| 40 | 20270201 | 2027-02 까지 | 2027-03 |
| 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC | 20261001 | 2026-10 까지 | 2026-11 |
| 82 | 20270201 | 2027-02 까지 | 2027-03 |

## 범위 밖으로 둔 것

- P_DMF0082_GET_MAIN_DATA_CURRENT 의 두 번째 결과셋(MONTH_NAME, 오늘 + 3개월)은 화면이 쓰지 않아 변경 안 함
- Excel Upload 의 M0~M16 식은 열과 월을 맞추는 식이라 변경 안 함
- 저장 프로시저(P_DMF0082_SAVE_MAIN_DATA)에는 월 제한식이 없음

## 복원

- 표준(81 계열 당월부터)으로 되돌림: PKG 안 [E20261124-DMF0082DIVCUTOFF-TEMP] 주석대로 THEN 줄 교체. 표준판 = 01_PKG_DMF0082_BODY_DIV_CUTOFF.sql, 백업 = 02_BACKUP_PKG_DMF0082_BODY_STANDARD.ASIS.sql
- 착수 전(81_UC 만 당월부터)으로 되돌림: 00_BACKUP_PKG_DMF0082_BODY.ASIS.sql
- 복원할 때도 그 시점 DB 원문을 다시 조회해 다른 변경이 없을 때만 백업본으로 교체함

## 클라우드 이관 패키지

- 전달본(3단계): _artifacts/_deploy_packages/DMF0082_DIV_CUTOFF_CURMON_CLOUD_20261124_1340 (build_cloud_pkg_div_cutoff_curmon.py, 리허설 curmon_rehearse.log). 클라우드 원문 A~E 5가지 DRY 적용 가능, 이미 반영된 원문 SKIP 확인. 1144 패키지는 대체됨
- 2단계 전달본: _artifacts/_deploy_packages/DMF0082_DIV_CUTOFF_TEMP_CLOUD_20261124_1144 (build_cloud_pkg_div_cutoff_temp.py, 리허설 temp_rehearse.log)
- 클라우드 원문 A(M+3), B(POJ), C(81_UC 지난달), D(81 계열 지난달) 4가지 DRY 적용 가능, 이미 반영된 원문은 SKIP 확인
- 표준판 기준 1139 패키지와 경우 이름 길이 결함(ORA-06502)이 있던 1143 패키지는 전달 전 삭제함
