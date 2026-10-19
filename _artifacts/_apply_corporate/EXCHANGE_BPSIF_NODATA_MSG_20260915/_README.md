# EXCHANGE_BPSIF_NODATA_MSG_20260915 — BPS I/F 반영 대상 0건 안내 (DB 전용, FE 무변경)

## 요구 (사용자 2026-09-15)
DMF0082 환율 모달 BPS I/F — 반영할 대상이 없으면 "반영할 환율 정보가 없습니다" 안내.

## 원인 (사내 ZIOUI1 실측)
- 원천 `XIF_GSC_MOVE_EXCHANGE_RATE_SN` 0행 → 공유 배치 `PR_SCM_MST_EXCHANGE_RATE` 는 루프 0회로 정상 종료(로그 11:42:52 START/END)
- 래퍼 `PR_SCM_MST_EXCHANGE_RATE_UI` 가 무조건 CODE='0' success → 화면 성공 토스트, 값·Last Update 불변

## 조치 [E20260915-BPSIFNODATA]
화면 전용 래퍼만 수정(공유 배치 본문 무수정 — 야간 배치 영향 없음):
배치 CUR_E 와 동일 조건으로 대상 건수 선계산 → 0건이면 배치 미호출, `CODE='1' / RESULT_MSG='반영할 환율 정보가 없습니다'`.
FE `ExchangeRateModal.handleBpsIf` 는 CODE≠'0' 이면 RESULT_MSG 를 Alert 표시(기존 로직). 결과 키가 소문자
`o_result_cursor`(PROC_M COL_NM)라 공용 axios 인터셉터(대문자 `O_RESULT_CURSOR` 검사)에 걸리지 않음.
호출처 = DMF0082 ExchangeRateModal 1곳(FE grep · PROC_M 실측).

## 적용 (사내 — 2026-09-15 11:53 완료)
| 파일 | 결과 |
|---|---|
| 00_BACKUP_ASIS/PR_SCM_MST_EXCHANGE_RATE_UI.ASIS.sql | 적용 직전 원문 (원복용) |
| 01_APPLY/PR_SCM_MST_EXCHANGE_RATE_UI.sql | 게이트 통과 후 배포 — VALID · ERRORS 0 · GRANT SCMP_APP EXECUTE 유지 |
| apply_wrapper.py | backup / apply / test |

실측(test): XIF 0행 → `('1', '반영할 환율 정보가 없습니다', None)`.

## 클라우드
01_APPLY 그대로 사용 가능(단독 PROCEDURE 전체본). 클라우드 원문이 백업본과 같은지 먼저 대조.
