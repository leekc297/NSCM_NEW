# CMBO / LOOKUP 3-테이블 클라우드 누락분 동기화 (2026-07-16 10:15)

> **폴더**: `_artifacts/_deploy_packages/CMBO_LOOKUP_SYNC_20260716_1015/`
> **배경**: DMF0048 클라우드 이관 후 UI CATEGORY SETUP 에 COMBO 설정된 3컬럼(FCST_TYPE / COMPANY_ID / MEASURE)의 **명칭 미표시**. FE 이관은 정상 — 원인은 클라우드 DB에 콤보 정의·LOOKUP 데이터 부재.
> **요청**: 현재 Oracle(SCM_MGR@OCGSCMD_P01) 데이터를 기준으로, **클라우드에 PK 기준 존재하지 않는 행만 INSERT** (존재 행 자동 제외).

---

## 1. 원인 사슬 (실측)

DMF0048 'Sales Monitoring' 시트의 콤보 3종은 아래 사슬로 명칭을 만든다. 클라우드에서 이 중 하나라도 끊기면 코드만 표시된다:

| 컬럼 | 콤보 SQL_ID | 콤보 데이터 원천 | 비고 |
|---|---|---|---|
| FCST_TYPE | `FcstType` | LOOKUP `SALES_TYPE_CODE` (14행) | param-less. **사내 2026-06-27 신설** |
| COMPANY_ID | `DM_COMPANY` | LOOKUP `DM_COMPANY` (18행) | param-less. **사내 2026-07-02 신설** |
| MEASURE | `Measure` | `SCM_MST_SHEET_MEASURE`(PROGRAM_ID=**@mnuId**) | **사내 2026-07-02 신설·07-13 갱신**. FE comboParams(@mnuId='DMF0048') 필요 — 이관 완료 |

⚠ 기존 DMF0048 이관 패키지(`DMF0048_20260715_1925`)는 **FE 2파일만 포함, SQL 0건** — 위 콤보 정의(CMBO_SQL_M)와 LOOKUP 데이터가 이관 대상에서 누락되어 있었음.

## 2. 파일 구성 (적용 순서대로)

| # | 파일 | 대상 테이블 | 후보 행수 | PK(NOT EXISTS 기준) |
|---|---|---|---:|---|
| 1 | `01_SCM_ADM_LOOKUP_MASTER_missing_insert.sql` | SCM_ADM_LOOKUP_MASTER | 604 | LOOKUP_TYPE |
| 2 | `02_..._DETAIL_missing_insert_part1~4.sql` | SCM_ADM_LOOKUP_MASTER_DETAIL | 78,222 (20k×3+18,222) | LOOKUP_TYPE+SEGMENT1~5 |
| 3 | `03_SCM_ADM_CMBO_SQL_M_missing_insert.sql` | SCM_ADM_CMBO_SQL_M | 119 | SQL_ID+MDU_DIVS_CD |

- **전 문장 = `INSERT … SELECT … FROM DUAL WHERE NOT EXISTS(PK)`** — 실측 PK 제약 기준. 클라우드에 이미 존재하는 행은 **자동 제외**(멱등, 재실행 안전).
- 원본 감사컬럼(CREATED_BY 등)·일시 **그대로 보존**. DATE/TIMESTAMP = 명시 마스크(hook #109 NLS).
- 적용 순서: MASTER → DETAIL → CMBO (참조 방향).

## 3. 적용 방법 (클라우드)

```
sqlplus SCM_MGR/<pw>@<cloud> @01_SCM_ADM_LOOKUP_MASTER_missing_insert.sql
sqlplus ... @02_..._part1.sql  (~part4 순차)
sqlplus ... @03_SCM_ADM_CMBO_SQL_M_missing_insert.sql
```
각 파일 말미 COMMIT 포함. DETAIL part 파일은 각 ~35MB — DBeaver 대신 sqlplus/SQLcl 권장.

⚠ **치환 변수 프롬프트**: 데이터에 `&` 포함 명칭(S&BD·LGE/KT&G·S&F·L&S 등 210문)이 있어, 각 파일 최상단에 `SET DEFINE OFF;` 를 포함했습니다(2026-07-16 patch). SQL Developer 에서는 **스크립트 실행(F5)** 으로 실행해야 SET 이 적용됩니다 — 문장 단위(Ctrl+Enter) 실행 시에는 먼저 `SET DEFINE OFF;` 를 별도 실행하세요.

## 4. 적용 후 확인 (클라우드)

```sql
-- 콤보 3종 존재 확인
SELECT SQL_ID, MDU_DIVS_CD, USE_YN FROM SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('FcstType','DM_COMPANY','Measure');
-- LOOKUP 데이터 확인
SELECT LOOKUP_TYPE, COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE IN ('SALES_TYPE_CODE','DM_COMPANY') GROUP BY LOOKUP_TYPE; -- 14 / 18 기대
-- Measure 콤보 원천 (FE @mnuId 로 조회)
SELECT COUNT(*) FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0048' AND VALID_YN='Y'; -- 19+17 기대
```
이후 DMF0048 화면 재조회 → FCST_TYPE/COMPANY_ID/MEASURE 명칭 표시 확인.

⚠ **Measure 콤보 원천 `SCM_MST_SHEET_MEASURE`(PROGRAM_ID='DMF0048')는 본 패키지 범위(3테이블) 밖** — 클라우드에서 위 확인 쿼리가 0이면 별도 요청 주세요(동일 방식으로 생성 가능).

## 5. 검증 (생성 시)

- 생성 문장 **전량(79,945-1,000=78,945문)을 원본 DB에 실제 실행** — 원본은 전 행이 존재하므로 전 문장 0 insert(NOT EXISTS 성립)여야 정상 = 문법·이스케이프 100% 검증 후 ROLLBACK. 결과는 아래 검증 로그 참조.
- 데이터 추출·PK 는 `all_constraints` 실측 (추측 0).
