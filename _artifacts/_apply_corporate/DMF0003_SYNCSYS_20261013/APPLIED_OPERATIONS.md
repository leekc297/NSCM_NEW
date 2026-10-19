# DMF0003 저장 연계 Sales Plan 동기화 — 생성자·수정자 'SYSTEM' `[E20261013-DMF0003SYNCSYS]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 대상: `PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` 가 `DM_PLN_SALES_PLAN` 에 기록하는 생성자·수정자 (사용자 확정 범위 — 그 외 무변경)

## 요청 (2026-10-13)
| 메저 | 생성자 | 생성 시각 | 수정자 | 수정 시각 |
|---|---|---|---|---|
| 수량: MKT_FCST, CUST_FCST, TMM_FCST, RTF, RTF_SYS_RP | 원장 행의 생성자 그대로 | 원장의 생성 시각 | 'SYSTEM' | 저장 시각 |
| 금액: SalesAmt_KRW, SalesAmt_LOC, SalesAmt_USD | 'SYSTEM' | 저장 시각 | 'SYSTEM' | 저장 시각 |
| 금액: MKT_AMT_KRW, MKT_AMT_LOC | 'SYSTEM' | 저장 시각 | 'SYSTEM' | 저장 시각 |

추가 지시: "수량은 수정자만 'SYSTEM', 금액은 생성자·수정자에 'SYSTEM' — 정확히 일치하는지 확인 후 진행" · "데이터를 일괄 수정할 필요는 없습니다".

## 변경 내용 (최종 INSERT 의 SELECT 목록 2줄)
- 종전(줄 주석으로 보존)
  `, NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)` / `, V_CREATED_BY, SYSDATE AS LAST_UPDATE_DATE`
- 보완
  `, CASE WHEN MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST','RTF','RTF_SYS_RP') THEN CREATED_BY ELSE 'SYSTEM' END, NVL(CREATION_DATE, SYSDATE)` / `, 'SYSTEM', SYSDATE AS LAST_UPDATE_DATE`
- 메저 종류로 직접 구분한 이유: 초안(`NVL(CREATED_BY, 'SYSTEM')`)은 원장 생성자가 빈 수량 행에도 'SYSTEM' 을 넣는다
  (원장 `CREATED_BY` 는 NULL 허용, 현재 사내 82 원장에는 0건). 요청 기준과 예외 없이 맞추려고 바꿨다.
- 수량·금액 값, 삭제 범위, 메저 목록, 호출부 무변경. 호출처 = `P_DMF0003_SAVE_MKT_FCST` 한 곳(82).
- AS-IS `DMF0003_MKT_FCST_SALES_PLAN_SYNC` L335~336 은 저장한 사용자로 기록 → 의도적 변경.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | BODY 최신 원문 조회·백업 (LAST_DDL 10-12 21:52:19) | `00_BACKUP_PKG_DMF0003_BODY.sql` | 15:36 | 14,833줄 |
| 2 | 종전 프로시저 1회 실행 (전후 비교용 스냅샷 목적) | `test_run.py old` | 15:33 | ⚠ 아래 "데이터에 남은 영향" |
| 3 | 바뀐 식 검증 (테이블 미변경) | `test_expr.py` | 15:36 | 20케이스 PASS |
| 4 | PKG_DMF0003 BODY 적용 (+7줄) | `01_PKG_DMF0003_BODY.sql` (`build_apply.py apply`) | 15:37:05 | VALID · 오류 0 · DB==적용본 · INVALID 181→181 |
| 5 | 클라우드 패키지 리허설 (원복 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0003_SYNCSYS_CLOUD_20261013/` | 15:38 | 최종 적용 상태 · 마커 1 |

권한·시노님·메타 변경 없음. SPEC 무변경.

## 데이터에 남은 영향 (#2)
- 사용자 지시("데이터 일괄 수정 불필요")가 오기 전에, 전후 비교를 위해 **종전** 프로시저를 82 · 실행 사용자 `minyonglee1` 로 1회 실행했다.
- 프로시저가 내부에서 COMMIT 하므로(L13472~13474) 되돌려지지 않았다.
- 결과: 사내 82 Sales Plan(당주 이후) 39,758행이 같은 값으로 다시 기록됨. 수정자는 종전과 같은 `minyonglee1`, 수정 시각이 10-06 18:29 → 10-13 15:33 으로 바뀜.
  금액 메저 8종 중 금액 5종(26,004행)은 생성 시각도 15:33 으로 바뀜. 수량·금액 값은 원장에서 다시 만든 값이다(행 수 39,758 → 39,758).
- 보완 프로시저('new')는 실행하지 않았다. 사내 데이터의 수정자는 지금도 `minyonglee1` 이다.

## 검증
- 바뀐 식: 메저 10종 × 입력 생성자 있음/없음 = 20케이스. 수량 메저는 생성자·생성 시각 유지(빈 값도 그대로), 금액 메저는 생성자 'SYSTEM'·생성 시각 실행 시각, 수정자 전부 'SYSTEM'.
- 적용본 == DB 원문, 컴파일 VALID, 오류 0.

## 미실행
- 보완 프로시저의 실제 실행(DMF0003 에서 82 저장 → Sales Plan 기록 확인). 데이터 전 행이 다시 기록되므로 실행하지 않았다.
- 클라우드 적용.

## 알아둘 점
- 기존 데이터는 고치지 않는다. 적용 뒤 82 를 DMF0003 에서 처음 저장할 때 82 당주 이후 전 행이 새 규칙으로 기록된다(이 프로시저가 원래 전 행을 다시 쓰기 때문).
- 수정자 값으로 "사람이 고친 행"을 판정하는 로직(`LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')`)이 이 프로시저와 야간 Sales Plan 배치에 있다.
  판매계획 조정 제외(SALES_PLAN_ADJUST_YN='N') 품목의 금액 메저를 다시 계산할지 정하는 데 쓰인다.
  종전에는 동기화가 전 행에 사용자 이름을 남겨 82 의 조정 제외 품목이 전부 "사람이 고친 것"으로 보였고, 변경 뒤에는 실제로 Sales Plan 을 직접 고친 행만 해당한다.
  사내 82 조정 제외 품목 399건 중 당주 이후 Sales Plan 행이 있는 것은 0건(10-13 조회).

## 원복
`00_BACKUP_PKG_DMF0003_BODY.sql` 실행, 또는 패키지의 `99_ROLLBACK_SYNCSYS_PATCH.sql`.
