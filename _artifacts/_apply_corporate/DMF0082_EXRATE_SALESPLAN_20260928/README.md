# [E20260928-EXRSP] DMF0082 환율 팝업 저장 → Sales Plan 재계산 호출 활성화

## 요구
`PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` 에서 SALES_PLAN 갱신 SP 호출이 주석(`/* TO-DO 4/1 전환 예정 … */`)
→ AS-IS 확인 후 TO-BE 전환본으로 호출.

## AS-IS 근거 (MSSQL LESDFPSTO1C01 / LGCE_SCMDEV / SCP_MGR_DEV, 2026-09-28 15:57 직접 조회)
- DMF0082 → `POPUP.DMF0000_ExchangeRatePopup` (DMF0082_FcstNPrice_Mgmt.cs:3142) → 저장 `DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA` (팝업 .cs:440)
- `DMF0000_SAVE_EXCHANGE_POPUP_DATA` L375 `EXEC DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION @v_DIVISION_ID`
  → L378 `EXEC PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW @v_DIVISION_ID, 'EXCHANGE_RATE_UI'` (활성)

## TO-BE 전환 여부
- 전환본 = **standalone `SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW`** (VALID, LAST_DDL 2026-09-23 10:17, SCMP_APP 시노님 有)
- PKG 합류본 없음 — 호출처가 배치·타 SP 9곳(PR_SCM_MST_EXCHANGE_RATE, PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING, PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE,
  PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE, PR_DM_LONGPLAN_40_* 3종 …)이라 standalone 유지 규약 대상. (`PKG_DMF0020.P_PR_…_SINGLE` 은 별개 SP)
- 전환 완전성: 영속 테이블 DML 구성 AS-IS 와 일치
  (DM_PLN_SALES_PLAN DELETE×3·INSERT / DM_PLN_SALES_ETC_PLAN DELETE×2·INSERT×3 / DM_PLN_CFM_MKT_DEMAND_PLAN MERGE / DM_PLN_SALES_PLAN_RESULT DELETE·INSERT)
- `'EXCHANGE_RATE_UI'` = 분기 아님, CREATED_BY/LAST_UPDATED_BY 감사값 (AS-IS 동일)
- 내부 COMMIT 없음(호출자 책임, 주석으로 명시) → 호출자 COMMIT 에서 환율·Sales Price·Sales Plan 원자 반영

## 사전 드라이런 (커밋 없음 — 실행 후 ROLLBACK)
`PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW('40','EXCHANGE_RATE_UI')` → CALL_OK · **176.3초** ·
DM_PLN_SALES_PLAN(LAST_UPDATED_BY='EXCHANGE_RATE_UI') 0 → 67,246(트랜잭션 내) → ROLLBACK 후 0.
SCM_SYS_LOG_BATCH START 16:14:59 / END 16:17:55 (ERROR 없음).
FE 타임아웃 `VITE_API_TIMEOUT` = 300,000ms(.env) / 1,800,000ms(.env.local) — 범위 내.

## 작업 ↔ 파일 대조표 (사내 ZIOUI1)
| # | 실행 작업 | 시각 | 파일 | 결과 |
|---|---|---|---|---|
| 0 | 적용 직전 원문 보관 | 16:21 | `00_before_PKG_DMF0000_BODY.sql` | 원복용 (LAST_DDL 2026-09-02 11:47:13) |
| 1 | PKG_DMF0000 BODY 주석 해제 (FRESH-GATE 통과) | 16:23:38 | `01_PKG_DMF0000_BODY.sql` | VALID, USER_ERRORS 0 |
| 2 | PKG_DMF0020 재컴파일 (적용 전 BODY INVALID) | 16:23:40 | `02_recompile.sql` | spec/body VALID |
| 3 | DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 재컴파일 (#2 로 INVALID 전이) | 16:25 | `02_recompile.sql` | VALID |

## ⚠️ 잔여 위험 (미조치 — 결정 필요)
- **PR 예외 삼킴 → 허위 성공 가능**: TO-BE PR 은 `EXCEPTION WHEN OTHERS THEN ROLLBACK; 로그` 후 **RAISE 없음**.
  PR 실패 시 환율 MERGE·Sales Price 까지 롤백되지만 호출자는 계속 진행해 `CODE='0' SUCCESS` 를 반환한다.
  AS-IS 는 중첩 트랜잭션 CATCH 의 `ROLLBACK TRANSACTION <name>` 이 오류로 호출자에 전파되어 실패가 드러났다.
  PR 공용(배치 9곳)이라 RAISE 추가는 영향 검토 후 결정.
- 클라우드 DB 미적용.
