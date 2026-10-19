# UIPKG_CONSOLIDATION_20260915 — STEP 0 · STEP 1 결과

## STEP 0 — DB 새로고침 · 대상 재확정 (조회 전용, 2026-09-15 17:53)
- 09-14 조사 도구 재실행: `00_refresh/` (01_dump 에 스케줄러 3종 조회 추가 · 출력 경로만 변경) → `TOBE_UI별_PKG전환대상_20260915.md/.xlsx`
- 09-14 대비: 대상 43건 동일(추가·제외 0). 변화 =
  - **PKG_DMF0008 신규 생성(09-14 18:37~18:51, 마커 `2026.09.14 AJS`)** — 7 멤버 · 의도적 보완(SAVEPOINT/ROLLBACK TO · 커서 미오픈 방어 · 로그 프로그램명 · SALES_SITE `SEARCHTYPE` 컬럼) · META 는 standalone 유지 · SCMP_APP 권한·시노님 없음
  - **PKG_DMF0048 에 P_DMF0048_GET_SPREAD_TITLE 추가(09-14 18:54, AJS)**
  - DMF0008 standalone 4건 INVALID→VALID(09-14 18:27 재컴파일) · PR_DM_PLN_CFM_TO_MKT_FCST INVALID→VALID
- **사용자 결정: PKG_DMF0008 · PKG_DMF0048 제외 → 12 PKG · 34건 진행**
- 원장: `LEDGER.json` (tools/s0_ledger.py)

### 대상 12 PKG · 34건
| PKG | 건 | 비고 |
|---|---:|---|
| PKG_DMF0003 | 1 | SCM_ADM_MAIL_SEND — 외부 호출부 SCM_ADM_MAIL_SEND_BATCH·_DATA |
| PKG_DMF0006 | 1 | 외부 호출부 PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA |
| PKG_DMF0007 | 1 | |
| PKG_DMF0014 | 3 | TO_MKT_FCST 2본이 PR_DM_CUST_ITEM_MAPPING 호출(PKG 내부화) |
| PKG_DMF0020 | 1 | 외부 호출부 DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP |
| PKG_DMF0040 | 1 | |
| PKG_DMF0043 | 10 | 동일명 기존 멤버 7 + 래퍼 1 + 신규 2 · INVALID 1(CONTRIBUTION_SALES_LIST) |
| PKG_DMF0072 | 5 | INVALID 2(END_CUSTOMER_LIST·SALES_SITE_LIST, ALL_ERRORS 0) |
| PKG_DMF0082 | 3 | PR_SCM_MST_EXCHANGE_RATE_UI → PR_SCM_MST_EXCHANGE_RATE (PKG 내부화) |
| PKG_SYS0012 | 3 | **PKG 신규 생성** + SCMP_APP GRANT·시노님 |
| PKG_SYS0014 | 4 | |
| PKG_SYS0017 | 1 | |

### 설계 확정 사항
- **동일명 멤버 7건(PKG_DMF0043)**: 본문 차이 91~870 토큰 + **시그니처도 다름**(멤버에만 O_RESULT_CURSOR 등). 7 멤버 참조처 = PKG 자신뿐(API_M 0) → META 실사용 = standalone → **standalone 본문·시그니처로 교체**(PROC_M 과 일치)
- **래퍼 DMF0043_GET_MAIN_SPREAD_TITLE**: standalone(8인자)이 `PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE`(9인자)를 호출 후 자체 커서 반환 → 기존 멤버를 `P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE` 로 이름 변경, 공개 멤버 = 래퍼 로직(내부 호출만 _CORE 로)
- AUTHID·PRAGMA 없음 34/34 · 스케줄러 JOB 직접 참조 0/34 · EXCEL/CMBO 참조 0/34
- 대상 PKG 중 최근 타 작업자 마커: PKG_DMF0003/0007/0020/0072(AJS 08~09월) · PKG_SYS0017(`2026.09.14 AJS`) — STEP 2 는 적용 직전 FRESH-GATE 로 변경 감지

## STEP 1 — BACKUP (DB 무변경, `01_backup/`)
- 객체 원문 61 (PKG SPEC/BODY 22 · standalone 34 · 외부 호출부 5) — SOURCE-FRESH 스탬프 · sha1 `MANIFEST.md`
- 부재 기록: PKG_SYS0012 SPEC/BODY (신규 대상)
- SCMP_APP: GRANT 50 · SYNONYM 50 → `scmp_app/GRANT_SYNONYM_RESTORE.sql`
- META: API_M 25 · PROC_M 128 · BTN_MPG 36 → `meta/*.csv` + `meta/META_RESTORE.sql`(멱등 MERGE)
