# UIPKG_CONSOLIDATION_20260915 — STEP 2 결과 (사내 ZIOUI1 적용)

## 범위 변경 (사용자 2026-09-15)
- PKG_DMF0008 · PKG_DMF0048 포함 → **15 PKG · 43건** (대상 14 + DMF0000 재배선용 PKG_DMF0000)
- PKG_DMF0008 AJS 멤버: **전부 standalone 본문으로 교체** (코드 동일한 P_DMF0008_GET_SALES_SITE_PROJECT_MODEL 은 무변경)
- STEP 0 원장·STEP 1 백업 재생성: 객체 76 · SCMP_APP GRANT/SYNONYM 61 · META API_M 38 / PROC_M 206 / BTN_MPG 49

## 적용 결과 (18:57~19:00)
| PKG | 처리 | 결과 |
|---|---|---|
| PKG_DMF0000 | 멤버 코드 동일 → 무변경 (DMF0008 가 PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY 호출) | - |
| PKG_DMF0003 | 멤버 추가 1 · 내부 호출 재배선 1 | VALID |
| PKG_DMF0006 | 추가 1 · 재배선 1 | VALID |
| PKG_DMF0007 | 추가 1 · 재배선 1 | VALID |
| PKG_DMF0008 | standalone 본문 교체 6 · 동일 1 · SCMP_APP EXECUTE·시노님 신규 | VALID |
| PKG_DMF0014 | 추가 3 · 재배선 4 (TO_MKT_FCST 2본 → P_PR_DM_CUST_ITEM_MAPPING 내부화) | VALID |
| PKG_DMF0020 | 추가 1 · 재배선 2 | VALID |
| PKG_DMF0040 | 추가 1 | VALID |
| PKG_DMF0043 | 래퍼 1(기존 멤버 → `_CORE`) · 추가 2 · standalone 본문 교체 7 | VALID |
| PKG_DMF0048 | 멤버 코드 동일 → 무변경 | - |
| PKG_DMF0072 | 추가 5 | VALID |
| PKG_DMF0082 | 추가 3 · 재배선 1 | VALID |
| PKG_SYS0012 | **신규 생성** · 추가 3 · SCMP_APP EXECUTE·시노님 신규 | VALID |
| PKG_SYS0014 | 추가 4 | VALID |
| PKG_SYS0017 | (파일럿) 추가 1 · 재배선 1 | VALID |

- 선처리: INVALID standalone 3건(DMF0043_GET_CONTRIBUTION_SALES_LIST · DMF0072_GET_END_CUSTOMER_LIST · _SALES_SITE_LIST) 재컴파일 → VALID
- 외부 호출부 6 (전부 VALID): DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP / PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA / SCM_ADM_MAIL_SEND_BATCH·_DATA / DMF0043_GET_MAIN_SPREAD_TITLE(래퍼 → _CORE)

### ⚠ 발생·조치
PKG_DMF0043 적용 직후 standalone `DMF0043_GET_MAIN_SPREAD_TITLE`(래퍼)·`DMF0043_GET_CONTRIBUTE_MAIN_DATA` INVALID —
래퍼가 호출하던 기존 멤버(9인자)가 `_CORE` 로 개명되고 동일명 자리에 8인자 래퍼 멤버가 들어온 탓. 약 1분 뒤 래퍼 standalone 호출을 `PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE` 로 보정(12_CALLER) + 재컴파일 → VALID. 생성기(s2_build.py)에 반영.

## 검증
- `02_apply/VERIFY.md`: 43 멤버 전부 found · 시그니처(ALL_ARGUMENTS) 동일 · 코드(주석·공백 제외) 동일 — **불일치 0**
- INVALID 대조(17:53 덤프 vs 적용 후, PROCEDURE/PACKAGE/FUNCTION/SYNONYM): **신규 0** · 해소 4
- 실행 동등성(동일 인자, 결과 커서 행수·해시): DMF0043 SPREAD_TITLE 래퍼(118행) · DMF0072 DATA_TYPE(3) · TEAM(107) · DMF0043 VARSION(8) · YEAR_POPUP(9) — 전부 동일
- 부수 영향(보고): standalone 의 `$$PLSQL_UNIT` 이 PKG 안에서는 PKG 이름을 반환 → **SCM_SYS_LOG_BATCH.PROGRAM_NAME 표기만 PKG 이름으로 바뀜**(대상 23건). 프로그램명 문자열로 로그를 읽는 객체 0.
- META 는 아직 standalone → 화면 호출 경로 무변경 (STEP 3 적용 시 전환)

## 취합 누락 방지 (사용자 지시 — 권한·시노님 포함)
사내에 실행한 **모든 작업(19건)** 을 SQL 파일로 기록하고 `02_apply/APPLIED_OPERATIONS.md` 에 작업 ↔ 파일 1:1 대조표 작성.
콘솔 실행분 추가 기록: `PKG_DMF0008·PKG_SYS0012/20_GRANT_SCM_MGR.sql · 21_SYNONYM_SCMP_APP.sql` · `_COMMON/00_RECOMPILE_INVALID_STANDALONE.sql · 90_RECOMPILE_DEPENDENTS.sql`.
STEP 5 는 이 대조표 전 행 포함 여부를 게이트로 확인한다.

## 파일
`02_apply/<PKG>/10_SPEC.sql · 11_BODY.sql · _DIFF.md` · `02_apply/_CALLERS/12_CALLER_*.sql` · `APPLY_LOG.md` · `VERIFY.md` · `BUILD.json` · 도구 `tools/s2_build.py · s2_apply.py`
원복: `01_backup/objects/*.sql` (s2_apply.restore 동일 방식) · SCMP_APP 신규 2건 = REVOKE/DROP SYNONYM
