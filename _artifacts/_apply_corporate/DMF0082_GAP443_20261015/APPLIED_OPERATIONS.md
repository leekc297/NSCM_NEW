# DMF0082_GAP443_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_SAVE_MAIN_DATA` 파싱 직후 (마커 `[GAP443 2026-10-15]`, 블록 1개 삽입)
- 방식: **DB 만 변경 (FE 무변경)** — 사용자 상시 지시(DB 객체 우선, FE 는 가이드만). 앞서 넣었던 FE `allocateLoc` 수정은 원복함.
- AS-IS 근거: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0082_FcstNPrice_Mgmt/DMF0082_FcstNPrice_Mgmt.cs` L7183~7199 — Monthly 월 칸 편집 시 `Today.AddDays(Monday - DayOfWeek)` 이전 D_ 일자 `continue`(값·저장 모두 안 함)
- 변경: 화면·팝업 저장(`v_skip_parse = 'N'`)의 `GT_PRDM1_T_MAIN` 에서 `MEASURE='LOC' AND ACTION<>'D' AND YYYYMMDD < 이번 주 월요일` 행 DELETE
  - 이번 주 월요일 = `TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')` (같은 SP `v_plan_start_yyyymmdd` 와 동일 식)
  - KRW/USD·MKT_AMT 는 이후 LOC 에서 확장되므로 함께 빠짐
  - 제외: 행 삭제(ACTION='D') · Excel Upload 경로(`SKIP_PARSE='Y'`) — 종전 동작 유지
  - Save Price 팝업은 FE 가 이미 이번 주 월요일 이전 시작을 막음(AS-IS L1195 MSG00409) → 영향 없음
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 13:30:12 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 검증 (2026-10-15 목, 이번 주 월요일 = 20261012, 저장 SP 실호출, minyonglee1)
- 키: 40 / Electrolux / Electrolux / Kwonnie_CN_DGG / MCCH125020A1 / E / MPS / DAP / '-' / NJ01-A — 10월 판가·수요 행 없음 확인
- 입력: 월 칸 편집이 보내는 형태 그대로 `M` LOC 1.234 (USD) × 20261001·20261005·20261012·20261019·20261026

| | DM_PLN_CFM_SELLING_PRICE 10월 생성 일자 (LOC·KRW·USD 동일) |
|---|---|
| 수정 전 | 20261001, 20261005, 20261012, 20261019, 20261026 (지난 일자 2건 포함) |
| 수정 후 | **20261012, 20261019, 20261026** |
| 지난 일자만 전송 | SUCCESS · 생성 0행 |

- 정리: 테스트 생성 판가 행 삭제(수정 전 15 · 수정 후 9) → minyonglee1 테스트 잔여 0 (SELLING_PRICE · CFM_MKT_DEMAND_PLAN · DM_PLN_MKT_FCST)
- 참고(AS-IS 와 차이): 일요일 저장 시 AS-IS FE 식은 다음 날 월요일, 본 SP 식은 그 주 월요일을 기준으로 삼는다. 화면 표시는 저장 후 재조회 시 원값으로 돌아온다.

## 이관 패키지
- `_artifacts/_deploy_packages/DMF0082_GAP443_LOCPAST_CLOUD_20261015/` — 사내 리허설(13:58) 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (원문 전체 일치) · 최종 VALID
