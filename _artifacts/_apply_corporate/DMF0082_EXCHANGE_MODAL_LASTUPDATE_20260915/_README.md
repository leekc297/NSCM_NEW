# DMF0082_EXCHANGE_MODAL_LASTUPDATE_20260915 — 환율 모달 Last Update Date / Last Update By 컬럼

## 요구 (사용자 2026-09-15)
DMF0082 환율(Exchange Rate) 모달 그리드에 Last Update Date, Last Update By 컬럼 추가.
대표값 = 행(Division/Currency/Unit)의 조회기간 월 중 **가장 최근 수정일과 그 수정자** (사용자 확인).

## 메타/DB 단독 불가 사유
모달 그리드는 SHEET_COLUMNS 메타가 아니라 FE 상수(Div/Currency/Unit) + 월 동적 컬럼으로 구성되고,
SP 월별 행을 FE 가 피벗하므로 행 대표값 선택이 FE 에 필요. SP 는 두 컬럼을 반환하지 않았음.

## DB (사내 ZIOUI1 — 2026-09-15 11:28 적용 완료)
| # | 파일 | 결과 |
|---|---|---|
| 0 | 00_BACKUP_ASIS/PKG_DMF0082_BODY.ASIS.sql | 적용 직전 BODY 전체 (원복용) |
| 1 | 01_APPLY/PKG_DMF0082_BODY.sql | `P_DMF0082_POPUP_GET_FUTUREPRICE_INFO` O_RC1 에 `LAST_UPDATE_DATE`(TO_CHAR 'YYYY-MM-DD HH24:MI:SS')·`LAST_UPDATED_BY` 추가 [E20260915-EXLASTUPD] — 차이 5줄. PACKAGE/BODY VALID · ERRORS 0 · 배포본==01_APPLY |
| — | apply_sp.py | backup / apply / test |

실측(test): 컬럼 9개(+2), 2026 조회 3,684행, 예) 40/KRW/AUD 2026-01-29 11:12:21 hongjae.kim.

클라우드: 01_APPLY 는 사내 BODY 전체본 — 클라우드 BODY 가 다르면 통째 덮어쓰기 금지, 해당 SELECT 5줄만 동일 치환(apply_sp.py OLD/NEW).

## FE (동반 이관 대상)
- nscm-fe/features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx
- nscm-fe/features/demand/src/pages/forecast-price/forecast-price.constants.ts (`EXCHANGE_RATE_AUDIT_COLUMNS`)
- nscm-fe/configs/types/procedures.d.ts (DMF0082 futurePriceInfo o_rc1 +2필드 — 블록 단위 반영)
- nscm-fe/features/demand/src/pages/forecast-price/__asis-mapping__.md

## 원복
DB = 00_BACKUP_ASIS 실행 / FE = 위 파일의 [E20260915-EXLASTUPD] 변경분 제거.

## 미수행
type-check / lint 미실행 (사용자 지시 — 요청 시만).
