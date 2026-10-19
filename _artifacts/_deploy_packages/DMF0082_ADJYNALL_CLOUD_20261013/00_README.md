# DMF0082 저장 — 조정 제외(SALES_PLAN_ADJUST_YN='N') 품목도 단가 검증 적용 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0082ADJYNALL]` — PKG_DMF0082 BODY `P_DMF0082_SAVE_MAIN_DATA` 단가 검증(#10)의 제외조건 8줄 주석 처리. 다른 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 (2026-10-13) | `SALES_PLAN_ADJUST_YN = 'N'` 품목을 단가 검증에서 빼는 제외조건을 주석 처리 — 플래그가 N 이어도 단가 검증이 적용되도록 |
| 종전 | 단가 검증(#10 Sales Price 해당 주차 확인)은 Site-Item 마스터에 `SALES_PLAN_ADJUST_YN='N'` 으로 등록된 품목을 검사에서 뺐다 → 그 품목은 판가 없이 수량 저장 |
| 실제 사례 | 클라우드 QA 10-12: 40 · AJ상사_AB_TES · MCCM356015A2 · Aima (플래그 N) — 오창A(HQ06-A) 판가 없이 MKT_FCST 가 15:50 · 18:00 두 번 저장됨 |
| 보완 | 제외조건 8줄을 줄 주석으로 막는다(삭제하지 않음). 조정 제외 품목도 그 주·같은 키의 판가가 없으면 `Unit Price Not Found !` 로 저장 차단 |
| AS-IS | AS-IS `DMF0082_SAVE_MAIN_DATA`(LGCE_SCMDEV 06-12 본 L1185~1191)도 같은 예외를 둔다 → 이번 변경은 AS-IS 대비 의도적 강화 |
| 달라지지 않는 것 | 플래그가 N 이 아닌 품목의 검증 결과 · 검증 제외 Fcst Type(무상 등 룩업) 규칙 · 검증 대상 메저 룩업 · 수량 0 행 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 09:59 → 리허설 재적용 10:05:12) · 문장 전후 비교 5케이스 통과 · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_ADJYNALL_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 `N=1 PASS` · L2 마커 0 · L3 대상 품목 목록 · L5 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_ADJYNALL_PATCH.sql](A_DB/10_APPLY_ADJYNALL_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS · V2 VALID/오류 0 · V3 주석 처리된 8줄 · V4 `PASS — 단가 검증으로 차단 · 원장 0 → 0` (또는 `N/A`) |

롤백: [A_DB/99_ROLLBACK_ADJYNALL_PATCH.sql](A_DB/99_ROLLBACK_ADJYNALL_PATCH.sql) — 되돌리면 조정 제외 품목은 다시 판가 없이 저장된다.

## 주의
- **기존 데이터는 그대로다.** 이미 판가 없이 저장된 수량은 남아 있고, 그 품목·그 주에 수량을 새로 넣거나 고칠 때부터 판가가 없으면 막힌다. 00 의 L4 가 그런 주의 수를 보여 준다.
- 90 의 V4 는 저장 SP 를 실제 호출한다(조정 제외 품목 · 8주 뒤 월요일 · 수량 1). 판가가 없어 검증에서 막히는 것이 기대값이며, 패치 미적용이면 호출하지 않는다. 호출 전 그 (키, 일자) 원장 0건을 확인하고 호출 뒤 다시 확인한다.
- V4 가 `N/A` 면 시험 품목들이 단가 검증보다 앞선 검증(Biz Type 등)에서 먼저 막힌 것 — 사내가 이 경우였다. V1~V3 로 판정하고, 화면에서 조정 제외 품목으로 직접 확인한다.
- 같은 BODY 를 고치는 `DMF0082_MANDCOL_CLOUD_20261012` · `DMF0082_SSPMNEW_CLOUD_20261013` 과는 서로 다른 구간이라 적용 순서 무관.
- 10 은 패키지 BODY 재생성이라 조회·저장 실행 중이면 대기 — 00 L5 확인 뒤 한가할 때 실행.

## 리허설 (사내 ZIOUI1 2026-10-13 10:05, `_rehearsal_out/`)
99(역치환 → 마커 0 · VALID) → 00(L1 PASS · L2 0) → 90(V1 미적용 · V4 `SKIP`) → 10(`APPLIED … 마커 1곳`) → 10(`SKIP` 멱등) → 90(V1 PASS · V3 8줄 주석 · V4 `N/A` — 사내 조정 제외 품목 5건이 모두 Biz Type 검증에서 먼저 차단) → 00(L2 1).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 제외조건 8줄 주석 처리 | A_DB/10_APPLY_ADJYNALL_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
