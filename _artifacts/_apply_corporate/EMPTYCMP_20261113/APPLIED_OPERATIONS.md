# 빈 문자열 비교 구문 보완 — 사내 적용 기록 (2026-11-13)

- 대상 DB: 사내 Oracle ZIOUI1 · 스키마 SCM_MGR · 요청: 사용자 "(a) 14줄 보완해줘"(2026-11-13)
- 근거: `Doc/_rules_consolidation/2026-11-13_EMPTY_STRING_COMPARE_조사.md` §4 · §8-4 (Oracle 은 `''` 가 NULL → `X <> ''` · `NVL(X,'') = ''` 가 항상 거짓)
- 기준 원문: 2026-11-13 18:36:40 `ALL_SOURCE` 재조회본(`backup/<객체>.ASIS.sql`) · 적용 직전 FRESH-GATE(지금 원문 == 착수 원문) 통과
- 바뀐 줄 끝 표시: `-- [E20261113-EMPTYCMP] 빈 문자열 비교 보완(Oracle 은 '' 가 NULL)`

## 적용 내용 (6개 객체 · 14줄)

| 객체 | 줄 | 수정 전 | 수정 후 | 수정 전 LAST_DDL | 최종 LAST_DDL |
|---|---|---|---|---|---|
| PKG_DMF0035 (BODY) | 3226 · 3229 | `AND NVL(C.ATTRIBUTE8, '''') <> '''' '` | `AND C.ATTRIBUTE8 IS NOT NULL '` | 2026-11-09 18:34:19 | 2026-11-13 18:41:53 |
| PKG_DMF0045 (BODY) | 1295 | `AND A.STORAGE_ID     <> ''` | 줄 주석 처리(1294줄 `IS NOT NULL` 유지) | 2026-10-30 17:32:13 | 2026-11-13 18:42:28 |
| PKG_DMF0003 (BODY) | 15009 | `IF S_FUTURE_VALID IS NOT NULL AND S_FUTURE_VALID <> '' THEN` | `IF S_FUTURE_VALID IS NOT NULL THEN` | 2026-11-10 13:10:31 | 2026-11-13 18:41:54 |
| PKG_DMF0003_01 (BODY) | 16525 | 같음 | 같음 | 2026-11-12 10:36:52 | 2026-11-13 18:41:56 |
| PR_SCM_DNM_DELIVERY_TRACKING | 54 | `… .ATTRIBUTE1) <> ''` | `… .ATTRIBUTE1) IS NOT NULL` | 2026-11-03 16:12:20 | 2026-11-13 18:41:57 |
| DMF0072_GET_ITEM_POPUP_LIST | 102 · 103 · 104 · 151 · 152 · 198 · 199 · 200 | `CASE WHEN NVL(P_MDM_ACTIVE_SW, '') = '' THEN ''` | `CASE WHEN P_MDM_ACTIVE_SW IS NULL THEN '@#@#@#'` | 2026-11-02 19:12:07 | 2026-11-13 18:41:57 |

## 실행 순서와 결과

| 시각 | 실행 | 결과 |
|---|---|---|
| 18:36:40 | `emptycmp.py prep` | 6개 원문 백업 · 치환 검사 14줄 일치 |
| 18:37:24 | `run_tests.py before` | 조회 11건 실행(오류 0) — `logs/tests.before.log` |
| 18:39:16~28 | `emptycmp.py apply` | 6개 APPLY · STATUS VALID · 적용본==DB True · 의존 INVALID 0 |
| 18:39:38 | `run_tests.py after` · `compare` | 아래 표 |
| 18:41:43~57 | 클라우드 패치 리허설(99 되돌리기 → 99 재실행 SKIP → 10 적용 → 10 재실행 SKIP) | 되돌린 뒤 == 수정 전 원문 6개 True · 재적용 6개 APPLY |
| 18:42:28 | PKG_DMF0045 적용본 재실행 | 리허설 패치가 줄바꿈을 CRLF → LF 로 바꿔(2,436곳) 적용본과 바이트가 달라짐 → 원래 줄바꿈의 적용본으로 다시 맞춤 |
| 18:42:29 | `emptycmp.py verify` | 6개 OK(VALID · 오류 0 · 적용본==DB · 의존 INVALID 0 · 표시 줄 14) |
| 18:43:05 | `run_tests.py after`(2회차) · `compare` | 1회차와 같음 |

## 전/후 시험 (조회 프로시저 · 끝에 ROLLBACK)

| 시험 | 수정 전 | 수정 후 | 판정 |
|---|---:|---:|---|
| DMF0072 81 · P_MDM_ACTIVE_SW=NULL | 41,423행 | 49,518행 | 조건 해제 확인(+8,095) |
| DMF0072 81 · 'Y' | 41,423행 | 41,423행 | 같음 |
| DMF0072 81_UC · NULL / 'Y' | 363 / 363 | 845 / 363 | 조건 해제 확인(+482) |
| DMF0072 82 · NULL / 'Y' | 44,223 / 44,223 | 44,572 / 44,223 | 조건 해제 확인(+349) |
| DMF0072 40 · NULL / 'Y' | 15,375 / 15,375 | 15,417 / 15,375 | 조건 해제 확인(+42) |
| DMF0035 81 MONTHLY(CURRENT) | 655행 | 655행 · 전 컬럼 같음 | 회귀 없음. 결과 커서에 KWH 컬럼 없음 → 화면 값 변화 **미확인** |
| DMF0045 Cell Biz / Pack Biz 81 | 10 / 81행 | 10 / 81행 · 전 컬럼 같음 | 회귀 없음. 효과 **미확인**(아래) |

- DMF0035 식 단위 확인(18:40:46): `SCM_MST_SITE_ITEM` 81% 56,894행에 수정 전 식 → 값 있는 행 0 / 수정 후 식 → KWH_MODULE 32,330 · KWH_PACK 33,943. 호출 뒤 `GT_DM35_T_COLUMN_SETUP` 의 두 식이 `C.ATTRIBUTE8 IS NOT NULL` 로 바뀐 것 확인.
- DMF0045: 호출 뒤 `GT_DMF0045_STOCK` 0행 · `GT_DMF0045_BOH` 0행. 사내 `SSP_DNM_STOCK_C` 81 재고의 최근 CUTOFF_DATE 가 2026-09-18 이라 대상 재고가 없다 → 바뀐 가지가 결과에 주는 차이를 사내 데이터로는 재지 못했다.
- PR_SCM_DNM_DELIVERY_TRACKING: 실행하지 않음(배치 · 데이터 변경). 조건만 SELECT 로 확인 — 날짜·FLAG 조건 제외 시 수정 전 술어 0행 / 수정 후 술어 10,389행. 날짜·FLAG 포함 시 0행(현재 대상 없음).
- PKG_DMF0003 · PKG_DMF0003_01 `…SAVE_MKT_FCST_PK_DATA_UPDATE`: 실행하지 않음(저장 프로시저 · 호출 경로 미확인). 컴파일 VALID 만 확인 — 동작 **미검증**.

## 클라우드 이관

- `_artifacts/_deploy_packages/EMPTYCMP_CLOUD_20261113/` — `10_APPLY_PATCH.sql` → `90_VERIFY.sql` · 되돌리기 `99_ROLLBACK_PATCH.sql` · `README.md`
- 수정 구간만 치환(객체 6개 · 구간 8개). 사내 DRY 재실행 6개 SKIP(18:43:12).
- 리허설은 사내 접속 계정이 system 이라 `USER_*` 를 `ALL_* + OWNER='SCM_MGR'` 로 바꿔 실행했다(`rehearse.py`). 패키지 파일은 `USER_*` 그대로다.
- 패치는 원문 줄바꿈을 LF 로 정규화한다. 클라우드 `PKG_DMF0045` 에 CRLF 가 있으면 적용 뒤 LF 로 바뀐다(내용 같음).

## 되돌리기

- 사내: `python rehearse.py ..\..\_deploy_packages\EMPTYCMP_CLOUD_20261113\99_ROLLBACK_PATCH.sql` 또는 `backup/<객체>.ASIS.sql` 실행(실행 전 원문 재조회 필요).
