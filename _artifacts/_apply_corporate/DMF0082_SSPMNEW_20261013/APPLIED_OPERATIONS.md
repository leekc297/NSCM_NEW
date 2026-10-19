# DMF0082_SSPMNEW — 사내 ZIOUI1 적용 기록 (2026-10-13)

마커 `[E20261013-DMF0082SSPMNEW]` · 대상 `SCM_MGR.PKG_DMF0082` PACKAGE BODY (`P_DMF0082_SAVE_MAIN_DATA` 검증 #5 뒤 5-1 신설)

## 기준 원문
- 조회 DB ZIOUI1 · 최종 빌드 조회 2026-10-13 00:18 · 기준 BODY = 10-12 18:23:13 본(MANDCOL 적용본)과 동일 내용
- 백업 `00_BACKUP_PKG_DMF0082_BODY.sql` · 적용본 `01_PKG_DMF0082_BODY.sql` (원문 대비 추가 46줄, 삭제·변경 0줄)
- AS-IS 대조: LGCE_SCMDEV `DMF0082_SAVE_MAIN_DATA`(수정 2026-06-12 17:31, DB 직접 조회 10-13) — Site/Item 검증 L871~891 · L1433~1458 모두 3키(Division·Site·Model). 4키 검증은 AS-IS 에 없음 = 신규 행 한정 의도적 강화

## 실행한 작업
| 시각 | 작업 | 결과 |
|---|---|---|
| 00:14 | 1차 build · apply (Project 등호 비교판) | VALID · 오류 0 · 검증 6케이스 + 실호출 PASS |
| 00:17 | 백업본으로 원복 (DB == 1차 적용본 확인 후) | DB == 백업본 · 마커 0 |
| 00:18 | 2차 build · apply (Project 빈값 표기 '-'·'/' 동일 처리 추가) | FRESH-GATE PASS · DB==적용본 · VALID · USER_ERRORS 0 · SCM_MGR INVALID 7 → 7 |
| 00:20~00:22 | 클라우드 패키지 리허설 (99 → 00 → 10 → 00 → 90) | 왕복 PASS · 최종 상태 = 적용 (LAST_DDL 00:22:20 · 마커 1) |

권한·시노님·메타·데이터 변경 없음.

## 검증 (`test_sspmnew.py`)
T1 — DB 적용 원문에서 검증 문장을 추출해 세션 GTT 가상 입력행으로 실행 (ROLLBACK):

| 케이스 | 결과 |
|---|---|
| 신규 + 4키 유효(실값 Project) | 통과 |
| 신규 + 다른 Project | 차단 |
| 신규 + Project 빈값(마스터는 실값뿐) | 차단 |
| 신규 + 마스터 '-' · 입력 '-' | 통과 |
| 신규 + 마스터 '-' · 입력 '/' | 통과 |
| 신규 + 4키 있으나 VALID_YN='N' | 차단 |
| 신규 + 마스터에 없음 | 차단 |
| 수정 + 다른 Project | 통과 (신규 행만 대상) |
| 삭제 + 다른 Project | 통과 (신규 행만 대상) |

T2 — 저장 SP 실호출(신규 행 · 없는 Project): `RESULT_CODE=F` · 5-1 메시지 · 원장 0 → 0.

## 미실행
- 정상 신규 행의 실제 저장(성공 경로)은 호출하지 않았다 — 원장에 시험 행이 남기 때문. 통과 판정은 T1(문장 단위)로만 확인.
- 81 계열 실데이터 케이스는 별도로 돌리지 않았다 (문장은 Division 무관 동일).
- 화면(브라우저) 확인 미실행. 클라우드 미적용 — 패키지 `_deploy_packages/DMF0082_SSPMNEW_CLOUD_20261013/`.
