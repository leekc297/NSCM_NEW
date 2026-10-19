# GAP 262 — DMF0042 빈 키 보정 구간의 사업부(40) 한정 조건 — 확인 결과 (2026-10-15 20:4x)

- 판정: **이미 반영됨 — 추가 DB 변경 없음.** GAP 257(=F-13 빈값 검사 정정)과 같은 패치에서 40 조건을 함께 복원함 (`[E20261015-GAP257]`).
- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · PKG_DMF0042 BODY LAST_DDL 2026-10-15 19:09:20 VALID (재조회본 기준)
- TO-BE `P_DMF0042_SAVE_DM_PLN_BP_FCST` L4816 `IF V_CNT_1 > 0 AND V_DIVISION_ID = '40' THEN` … L4854 `GOTO END_PKUPDATE` … L5894 `<<END_PKUPDATE>>`
- AS-IS `DMF0042_SAVE_DM_PLN_BP_FCST`(LGCE_SCMDEV, modify 2026-02-06) L762~813 `IF EXISTS(...) AND @v_DIVISION_ID = '40'` … `GOTO END_PKUPDATE` … L1373 `END_PKUPDATE:` → 1:1 일치
- 경위: GAP257 이전 원문은 `IS NULL` 검사(항상 거짓)라 블록이 동작하지 않아 40 조건 누락이 잠복(GAP "현재 대상 0건(잔류)"). F-13 정정과 40 조건을 한 패치로 넣어 "F-13 만 고쳐 40 외 저장이 건너뛰어지는" 상태는 생기지 않음.

## 실증 (현재 원문 재실행 — `DMF0042_GAP257_20261015/e2e.py`, 시험키 ZZGAP257*, 종료 시 삭제 11행·잔존 0)
| 키 | 조건 | 결과 |
|---|---|---|
| K1 | 40 · 빈 키 '-' 매칭 | FCST_TYPE/INCOTERMS → MPS/FCA 채움 · 202611 행 미생성 (AS-IS 와 같이 GOTO 로 종료) |
| K2 | 40 · 빈 키 '/' 매칭 | 동일 |
| K3 | **81 · 빈 키 '-' 매칭** | 기존 빈값 행 미변경 · **202611 Business_Plan QTY 5 + LOC/SalesAmt 3종 생성 = 이후 저장 단계 정상 수행 (건너뜀 없음)** |
- 결과커서 3/3 `('0','SUCCESS')` · 출력 `e2e_rerun_20261015.out.txt`

## 클라우드
- 별도 패키지 불필요 — `_deploy_packages/DMF0042_GAP257_BLANKFILL_CLOUD_20261015/` 의 10_APPLY 에 40 조건 포함(c_i_asc). **클라우드 미적용** 상태이며 GAP257 패키지 적용 시 GAP262 도 함께 해소.
