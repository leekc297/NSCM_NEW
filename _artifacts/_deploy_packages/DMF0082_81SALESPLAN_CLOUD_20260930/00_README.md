# DMF0082 81 저장 후속처리 보완 (클라우드 이관)

> 마커 `[E20260930-DMF0082-81SP]` — DMF0082 [Save] (`P_DMF0082_SAVE_MAIN_DATA`) · Division 81 계열

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** 2객체: 공용 SP `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE` + `PKG_DMF0082` BODY(누적본). SPEC·PROC_M·FE·BE·메타 변경 없음 |
| 전제 | `PKG_DMF0082` BODY = [`DMF0082_CLOUDPERF_CLOUD_20260930`](../DMF0082_CLOUDPERF_CLOUD_20260930/00_README.md) 적용본 (지문 `16177/830657`). PRECHECK [H] 로 판정 |
| 사내 적용 | **완료 · VALID · 오류 0 · 참조 객체 INVALID 0** (ZIOUI1, 2026-09-30 12:07:37) — [`_apply_corporate/DMF0082_81SALESPLAN_20260930`](../../_apply_corporate/DMF0082_81SALESPLAN_20260930/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** · ⚠ **QA · DEV 2곳 모두** |
| BE 재기동 | 불요 |

## 1. 무엇이 문제였나

DMF0082 저장 후속처리는 `IF v_is_81 = 'N'` 게이트로 **40 만** 수행하고 81 은 통째로 건너뛰었다.
40 이 타는 전파 SP(`P_PR_DM_PLN_CFM_TO_MKT_FCST`)는 내부가 `division = '40'` 고정이고, Sales Plan 동기화 SP 도 데이터 생성부가 40 분기뿐이라 **81 을 게이트에만 추가하면 0건(무동작)** 이다.
그 결과 81 은 DMF0082 에서 SCM_FCST 를 저장해도 `DM_PLN_SALES_PLAN` 에 반영되지 않았고(사내 81 SCM_FCST 0건), BALANCE 재계산·RMA RTF 생성도 빠져 있었다.

## 2. 무엇이 바뀌나 (기준: AS-IS DMF0003 81 저장 후속 + SCM_FCST 는 AS-IS 40 Sales Plan 동기화 — 사용자 확정)

| # | 후속처리 | 근거 | 구현 |
|---|---|---|---|
| ① | RMA(반품예정) → RTF_SYS_RP = MKT_FCST | AS-IS `DMF0003_SAVE_MKT_FCST` L2499~2591 (사업부 무조건) | SAVE ■9 81 분기 — TO-BE `PKG_DMF0003` L12055~12114 1:1 |
| ② | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(division,'CALL')` — 저장 키 RTF·BALANCE·VMI 재계산 | AS-IS DMF0003 L2595~2634 | 대상 GTT `GT_PRDM_SEND_TARGET_DATA` 적재 후 호출 |
| ③ | Sales Plan 실시간 동기화 — 40 과 동일 전체(MKT_FCST·SCM_FCST·RTF_SYS_RP 수량 + SalesAmt·MKT_AMT) | AS-IS 40 `..._MKT_FCST_SAVE` / 사용자 확정 | 공용 SP 에 **81 분기 추가** (40 분기·공통부 무수정). 원천 = 배치 `..._LOCAL_KRW` 비-40 분기와 동일 |

- 두 객체 모두 **삽입만** — 기존 줄 1바이트 불변 (빌더 assert). 40 경로는 코드상 영향 없음.
- 81 분기 원천: MKT_FCST·SCM_FCST = `DM_PLN_MKT_FCST` · RTF_SYS_RP = `DM_PLN_CFM_MKT_DEMAND_PLAN`(셀생산지 실값) · 판가 = `SCM_MST_FUTURE_PRICE`(셀생산지 없음 → T2 셀생산지별 복제로 배치의 셀생산지 무시 조인과 등가).

**사내 E2E 검증** (81 / A19VO6001 / Volvo AS_WA_SE_GOT / AMVCC519H-A1R000 / E / AS / FCA / WA00-P)
- SCM_FCST 1셀 저장 → `DM_PLN_SALES_PLAN` SCM_FCST **생성 PASS** (3회 · 서로 다른 주 2개)
- RTF 주(11/05) 저장 시 RTF_SYS_RP·SalesAmt_KRW/LOC/USD 가 재생성되고 **값이 배치 생성값과 동일**(33,179,958 / 23,699.97)
- 같은 키 다른 Sales Plan 메저 54행 값 변화 0 · 정리('D' 저장 + 테스트 행 삭제) 후 원장·Sales Plan 전과 차이 0
- 저장 소요: 첫 호출 68초(콜드 파싱) → 이후 **7.5초**, 'D' 저장 2.7초

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` 2행 모두 **`적용`** 이면 진행 (SKIP=이미 적용 / ⚠ 중단=결과 회신). `[D]` 6행 VALID
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 원문 2객체 → `BAK_SRC_DMF0082_81SP` (비파괴 · 멱등)
3. [A_DB/11_SALES_PLAN_SYNC_SP.sql](A_DB/11_SALES_PLAN_SYNC_SP.sql) — 공용 SP 전체본 (`SHOW ERRORS` 0)
4. [A_DB/12_PKG_DMF0082_BODY.sql](A_DB/12_PKG_DMF0082_BODY.sql) — PKG BODY 전체본 (**3 다음** — 3 을 호출)
5. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID 2 / V2 지문 2행 SKIP / V3 참조 객체 INVALID 0
6. 화면: 81 에서 SCM_FCST 입력·저장 → Sales Plan(DMF0021 등)에서 해당 주 SCM_FCST 확인

롤백 (평소 실행 안 함): [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 유의

- **BALANCE 재계산이 새로 돈다.** 81 저장 시 저장 키의 BALANCE·RTF 가 재계산된다(AS-IS DMF0003 동작). 사내 첫 E2E 에서 해당 키 원장 576값이 갱신됐다 — 그동안 81 은 DMF0082 저장 후 재계산이 누락돼 이전 배치 시점 값이 남아 있었던 것. 재계산은 2회차부터 변화 0(안정).
- **삭제·0 입력의 Sales Plan 잔존** — 동기화는 QTY≠0 인 행만 다시 쓰므로, 81 에서 값을 지우거나 0 으로 바꾼 SCM_FCST 는 Sales Plan 에 이전 값이 남는다. **40 동기화도 QTY≠0 행만 다시 쓰는 같은 구조(기존 동작)**다 — 별도 보완 필요 시 결정 필요.
- **RMA 의 SCM_FCST** — 40 은 RMA 에서 MKT_FCST·SCM_FCST 를 모두 RTF_SYS_RP 로 만들지만, 81 은 AS-IS DMF0003 정본대로 MKT_FCST 만 쓴다.
- 별건 (이번 범위 밖): TO-BE **DMF0003** 도 81 BALANCE 호출이 "POC 임시 막음" 주석 상태이고, 넘기는 GTT 명이 `GT_DMF3_SEND_TARGET_DATA` 라 호출을 풀어도 피호출측(`GT_PRDM_SEND_TARGET_DATA`)이 비는 결함이 있다.
