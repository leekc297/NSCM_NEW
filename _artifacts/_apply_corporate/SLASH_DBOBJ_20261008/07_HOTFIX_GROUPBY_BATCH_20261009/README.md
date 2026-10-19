# [E20261009-GRPBYFIX] GROUP BY 식 불일치 회귀 — 96 객체 전수 점검 · 9 객체 일괄 핫픽스 (클라우드 DEV/QA 적용 패키지)

> 상위: `_artifacts/_apply_corporate/SLASH_DBOBJ_20261008/` (10-08 NULL 센티널 '-'→'/' DB 객체 변경 96 객체). DMF0020 단건 핫픽스 = `06_HOTFIX_GROUPBY_20261009/`.
> 본 폴더 = 나머지 95 객체 전수 점검 결과 발견된 **같은 회귀 8 객체 + PKG_DMF0044**.

## 1. 점검 방법 (두 축, 모두 변경 전 원문 `00_BACKUP_corp` 대비)
| 축 | 도구 | 결과 |
|---|---|---|
| A. 구조 스캐너 | `06_…/_work/groupby_scan.py` — SELECT/ORDER BY/HAVING 항목 중 GROUP BY 식으로 설명되지 않는 컬럼 참조 추출, 변경 전 원문에 없던 것만 | 15 객체 후보 (6 객체는 오탐으로 아래 B 에서 제외) |
| B. **DB 파서 게이트(정답지)** | `06_…/_work/parse_check.py` / `_parse_sweep.py` — GROUP BY 가 있는 모든 문장을 PL/SQL 변수→바인드 치환 후 **SELECT 부분을 `cursor.parse`** (DBMS_SQL.PARSE 는 INSERT…SELECT 에서 ORA-00979 를 놓침, 클라이언트 parse 는 보고) | 현재 사내 원문 **ORA-00979 17 문장 / 9 객체** · 수정본 **0** |

- 도구가 검증 못 한 문장(바인드 치환 한계 ORA-00923/00904/00971) 17건 = P_SYS0012_REJECT 1 · PKG_DMF0004 3 · PKG_DMF0082 1 · PKG_SCP0009 9 · PKG_SYS0012 1 · PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE 2 → 스캐너 A 기준 신규 불일치 0 (10-08 수정이 GROUP BY 문장에 닿지 않음).
- VIEW 7 = DB 가 CREATE 시 검사 → 전부 VALID·수정분 전부 존재(전체 원문 확인) → 무관.

## 2. 사내 ZIOUI1 적용 (2026-10-09) — 객체별 FRESH-GATE(LAST_DDL 동일) → CREATE OR REPLACE → VALID/오류/재파싱/새 INVALID
| 객체 | 979 문장 | 교정 줄(마커) | 사내 적용 | 비고 |
|---|---:|---:|---|---|
| PROCEDURE DMF0020_GET_SCM_MST_FUTURE_PRICE | 2 | 3 | 14:42:53 VALID | PLANT_SITE_ID CASE 식 + CURRENCY |
| PACKAGE BODY PKG_DMF0021 | 1 | 1 | 14:42:54 VALID | CELL_PROD_SITE_ID CASE 식 |
| PACKAGE BODY PKG_DMF0044 | 4 | 17 | 14:42:56 VALID → **15:00:45 타 작업자 덮어쓰기로 소실** | §4 |
| PACKAGE BODY PKG_DMF0045 | 1 | 1 | 14:43:03 VALID | |
| PACKAGE BODY PKG_SCP0013 | 1 | 1 | 14:43:05 VALID | |
| PACKAGE BODY PKG_SSP0045 | 1 | 1 | 14:43:08 VALID | |
| PROCEDURE PR_DM_DNM_EDI_CALLOFF_MKT_FCST | 4 | 4 | 14:43:08 VALID | |
| PROCEDURE PR_SSP_ANL_SHIPMENT_PLAN_FG | 2 | 2 | 15:13:36 VALID | |
| PROCEDURE PR_DM_PLN_SALES_PLAN_RESULT_MOVE | 1 | 1 | 15:14:29 VALID | 타 세션(SID 498) library cache pin 으로 대기 → 사용자가 세션 종료 후 적용 |
- 적용 후 재파싱: 9 객체 모두 ORA-00979 0 · 오류 0 · 새 INVALID 0 (기준선 5 제외). 로그 `06_…/_work/APPLY_LOG_corp_hotfix.json`.
- 교정 원칙: **GROUP BY 식 := SELECT 식(텍스트 동일)**. 10-08 이 SELECT 줄은 `NVL(NULLIF(RTRIM(x),''),'/')`, 같은 문장 GROUP BY 줄은 `NVL(x,'/')`(리터럴만) 또는 미변경 `NVL(x,'-')` 로 서로 다른 규칙을 적용한 것이 원인.

## 3. 클라우드 적용 순서 (SCM_MGR 접속, 각 파일 전체 F5)
| 순서 | 파일 | 내용 / 기대 |
|---|---|---|
| 1 | `01_APPLY_ALL_GRPBYFIX.sql` | 8 객체 CREATE OR REPLACE(PKG_DMF0044 제외) → `APPLY | … VALID`, `APPLY ERR` 0행 |
| 1b | `01b_APPLY_PKG_DMF0044_GRPBYFIX.sql` | PKG_DMF0044 **14:42:56 사내 적용본**(10-08 수정분 + 핫픽스 17줄). ⚠ §4 참조 후 적용 여부 결정 |
| 2 | `02_VERIFY_GRPBYFIX.sql` | V1 VALID/ERR 0 · V2 마커 수 = 기대치(1b 미적용 시 PKG_DMF0044 만 MISMATCH 가 정상) · V3 마커 줄 원문 |
| 원복 | `99_ROLLBACK_to_1726_payload.sql` | 9 객체를 핫픽스 직전 클라우드 본(17:26 페이로드)으로 — ⚠ ORA-00979 재발 |

## 4. PKG_DMF0044 — 타 작업자 편집 중 (보류)
- 사내 LAST_DDL 15:00:45 → 15:15:55(INVALID) → 15:16:09 → 15:20:33 … 자기 사본(10-08 본 기준, ENERGE_KWH 포맷 변경·NO_DATA_FOUND 처리 추가)으로 반복 교체 → 제 14:42 핫픽스 17줄 소실, **ORA-00979 재발 4문장 + 타 작업자 자체 신규 1문장(L1482: SELECT 만 `UPPER(SINGLE.ITEM_CLASS_NAME) LIKE` 로 바꾸고 GROUP BY 는 미변경) = 5문장**(10-08 수정분 331/331 은 보존됨).
- 재교정본(15:20:33 본 위에 GROUP BY 18줄 교정 — 우리 회귀 17 + 타 작업자 신규 1, 파싱 979 5→0) = `06_…/_work/pending_PKG_DMF0044_refix.sql` — **적용하지 않음**(FRESH-GATE 가 두 번 연속 불일치 = 편집 진행 중). 편집이 끝나면 `python _refix_dmf0044.py`(최신 원문 재추출+재교정+게이트) → `python _apply_dmf0044_refix.py`(FRESH-GATE 적용) 순으로 적용하고 01b 를 재생성한다.
- 클라우드 1b 는 그 전 상태(14:42 본). 타 작업자 변경까지 올려야 하면 재교정·재생성 후 사용.

## 5. 그 외 발견 (본 패키지 범위 밖, 결정 필요)
- **PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING**: 10-08 20:05:41 타 작업자 덮어쓰기로 **우리 10-08 수정 25줄 전부 소실**(현재 '/' 0줄). GROUP BY 회귀는 없음(원래대로 돌아갔으므로). 10-08 변경을 다시 넣으려면 그 버전 위에 재계획·재적용 필요 — 미수행.
- 상위 패키지 `03_CLOUD_APPLY_ONEFILE.sql`·`04_CLOUD_VERIFY.sql` 은 아직 17:26 본 기준(구본). 객체별 사본(`05_CLOUD_PAYLOAD_corp`·`03_CLOUD_APPLY_sqlplus`·`01_NEW_corp`)은 핫픽스 본으로 교체됨. ONEFILE 재생성은 PKG_DMF0044 확정 뒤.

## 6. 재발 방지(룰 반영)
- 식 치환은 **문장 단위**: SELECT 를 바꾸면 GROUP BY/ORDER BY/HAVING 의 동일 식도 함께. 변경 목록(xlsx 시트 2)이 줄 단위라 GROUP BY 줄이 빠진 것이 1차 원인, 같은 문장에 서로 다른 치환 규칙(전체 NVL 형 vs 리터럴만)이 적용된 것이 2차 원인.
- **컴파일 VALID ≠ 검증**: PL/SQL 컴파일은 ORA-00979 를 잡지 않음 → 적용 전 `parse_check.py`(SELECT 부분 cursor.parse) 게이트 + 적용 후 실제 실행.
- 메모리: `feedback_sentinel_replace_statement_unit_groupby.md`.

