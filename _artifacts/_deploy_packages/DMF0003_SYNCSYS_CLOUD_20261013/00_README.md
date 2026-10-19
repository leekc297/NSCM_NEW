# DMF0003 저장 연계 Sales Plan 동기화 — 생성자·수정자를 'SYSTEM' 으로 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0003SYNCSYS]` — PKG_DMF0003 BODY `P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` 의 최종 기록 2줄 교체. 다른 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 (2026-10-13) | 이 프로시저가 `DM_PLN_SALES_PLAN` 에 기록하는 생성자·수정자를 저장한 사용자 대신 'SYSTEM' 으로 |
| 종전 | 수정자 = DMF0003 에서 저장한 사용자(전 메저) · 금액 메저 생성자 = 저장한 사용자 |
| 배경 | 82 는 한 품목만 저장해도 82 전체 Sales Plan(당주 이후)이 다시 기록된다 → 손대지 않은 품목까지 그 사용자가 수정한 것으로 남음 (QA 10-13 13:42 k0101 — 12,249행) |
| AS-IS | `DMF0003_MKT_FCST_SALES_PLAN_SYNC` L335~336 도 저장한 사용자로 기록 → 의도적 변경 |
| 달라지지 않는 것 | 수량·금액 값 · 삭제 범위 · 메저 목록 · 수정 시각(저장 시각) · 수량 메저의 생성자·생성 시각(원장 값) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 15:37 → 리허설 재적용 15:38) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0003_SYNCSYS_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 적용 뒤 기록 규칙
| 메저 | 생성자 | 생성 시각 | 수정자 | 수정 시각 |
|---|---|---|---|---|
| 수량: MKT_FCST, CUST_FCST, TMM_FCST, RTF, RTF_SYS_RP | 원장 행의 생성자 그대로 | 원장의 생성 시각 | SYSTEM | 저장 시각 |
| 금액: SalesAmt_KRW, SalesAmt_LOC, SalesAmt_USD | SYSTEM | 저장 시각 | SYSTEM | 저장 시각 |
| 금액: MKT_AMT_KRW, MKT_AMT_LOC | SYSTEM | 저장 시각 | SYSTEM | 저장 시각 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 2종 `N=1 PASS` · L2 마커 0 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_SYNCSYS_PATCH.sql](A_DB/10_APPLY_SYNCSYS_PATCH.sql) | `APPLIED — PKG_DMF0003 BODY VALID · 마커 1곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS · V2 VALID/오류 0 · V3 바뀐 구간 9줄 · V4 10 메저 전부 PASS |

롤백: [A_DB/99_ROLLBACK_SYNCSYS_PATCH.sql](A_DB/99_ROLLBACK_SYNCSYS_PATCH.sql) — 되돌리면 다시 저장한 사용자 이름으로 기록된다. 이미 기록된 데이터는 바뀌지 않는다.

## 주의
- **기존 데이터는 고치지 않는다.** 어떤 파일도 `DM_PLN_SALES_PLAN` 을 쓰지 않고, 동기화 프로시저도 실행하지 않는다.
  적용 뒤 DMF0003 에서 82 를 처음 저장할 때 82 당주 이후 전 행이 새 규칙으로 기록된다(이 프로시저가 원래 전 행을 다시 쓴다).
  실제 기록은 그 저장 뒤 00 의 L3 로 확인한다 — 수정자 SYSTEM, 금액 메저 생성자 SYSTEM.
- **패치형이다.** 클라우드 원문을 읽어 그 2줄만 바꾼다. 앵커가 맞지 않거나 동기화 프로시저 밖에 있으면 원문을 건드리지 않고 중단한다 → 00 의 L1 결과를 회신.
- 수정자 값으로 "사람이 고친 행"을 가리는 로직이 이 프로시저와 야간 Sales Plan 배치에 있다(판매계획 조정 제외 품목의 금액 재계산 여부).
  종전에는 82 의 전 행에 사용자 이름이 남아 조정 제외 품목이 모두 "사람이 고친 것"으로 보였고, 적용 뒤에는 Sales Plan 을 직접 고친 행만 해당한다.
- 10 은 패키지 BODY 재생성이라 DMF0003 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 한가할 때 실행.
- 같은 BODY 를 고치는 다른 패키지가 있으면 구간이 다르므로 순서 무관(앵커 기준 패치).

## 리허설 (사내 ZIOUI1 2026-10-13 15:38, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 2종 PASS · L2 0) → 90(V1 미적용 · V4 10 PASS) → 10(`APPLIED … 마커 1곳`) → 10(`SKIP` 멱등) → 90(V1 PASS · V4 10 PASS) → 00(L1 0건 = 적용됨 · L2 1).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0003 BODY 최종 기록 2줄 교체 | A_DB/10_APPLY_SYNCSYS_PATCH.sql |
| 권한·시노님·메타 변경 | 없음 |
| 데이터 변경 | 패키지에 없음 (사내에서 검증용으로 종전 프로시저를 1회 실행한 것은 이관 대상 아님 — APPLIED_OPERATIONS 참조) |
