# DMF0082_DBFIX_CLOUD_20260831 — 파일 목록

| # | 파일 | 대상 REQ | 내용 |
|---|---|---|---|
| 0 | `00_CLOUD_PRECHECK.sql` | 전체 | read-only 선판정: [A]객체상태 [B]가드·마커 세대(0=구본) [C]-8 실오류 로그 확보 [D]외부 의존 실존 [E]메뉴 행 [F]GTT/SEQ 존재 [G]base REPOINT 세대 |
| 1 | `A_DB/01_PKG_DMF0020_BODY.sql` | -8 | CONVERSION ORA-12841 허용 가드 포함 BODY (사내 라이브 무수정 덤프, 409KB) |
| 2 | `A_DB/02_PKG_DMF0082_BODY.sql` | -12/-13 | SAVE V#10(52주 Unit Price)·V#11(RMA 음수)·V#12(비RMA 음수 차단) 포함 최신 BODY (799KB) |
| 3 | `A_DB/03_PR_SCM_MST_EXCHANGE_RATE.sql` | -9 | base proc — 08-24 REPOINT(PKG 멤버 호출) 본문 |
| 4 | `A_DB/04_PR_SCM_MST_EXCHANGE_RATE_UI.sql` | -9 | OUT-커서 래퍼 (클라우드 최초 이관) |
| 5 | `A_DB/05_BPSIF_WIRING.sql` | -9 | GRANT(SCMP_APP)/시노님/API_M/PROC_M(DELETE 후 INSERT)/BTN/그룹권한 — 멱등 |
| 6 | `A_DB/06_LOOKUP_VALIDATION_PRICE.sql` | -12 | 룩업 MKT_FCST_VALIDATION_PRICE 11행 (INSERT NOT EXISTS + VALID_YN UPDATE 보정) |
| 7 | `A_DB/90_VERIFY.sql` | 전체 | V1 VALID / V2 가드·마커 / V3 룩업 / V4 배선 6축 / V5 PROC_M↔ARGS / V6 GTT 모의행 양성 / V11 메뉴 행 |
| - | `_survey/delta_PKG_*.diff` | - | 직전 클라우드 패키지 대비 라이브 delta 실측 (DMF0082 46줄 / DMF0020·DMF0000 종결자 차이뿐) |
