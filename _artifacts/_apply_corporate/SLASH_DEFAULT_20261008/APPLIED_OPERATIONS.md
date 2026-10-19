# [E20261008-SLASHDEF] NULL 센티널 DEFAULT '-' → '/' (ON NULL 일괄) — 사내 적용 기록 · 클라우드 DEV/QA 적용 패키지

> 기준 파일: `_artifacts/_diagnostics/SLASH_SENTINEL_DMLRISK_20261007/슬래시전환_DEFAULT_DB객체_정리_20261007_v4.xlsx` 시트 `1_DEFAULT`
> 대상 = **시트 적용 `'/'` 전부 = 2,005컬럼 / 283테이블** (사용자 최종 정정 10-08: 현재 '-' 조건 무시) = 현재 `'-'` 1,916 + 현재 DEFAULT 없음 89. 전부 `DEFAULT ON NULL '/'` (ON NULL 일괄 — 없던 39컬럼도 추가).
> 데이터 변경 없음(컬럼 DEFAULT 메타만). 시트 2·4(DB 객체 변경)는 본 패키지 범위 밖(다음 단계).

## 1. 건수 — 시트 적용 '/' 2,005 = 전부 적용

| 시트 `1_DEFAULT` 적용 `'/'` 2,005 | 현재 DEFAULT | 건수 | 처리 |
|---|---|---|---|
| 현재 `'-'` → `'/'` | `'-'` | **1,916** | **본 패키지 적용** (1차 목록 1,789 · 정제전 탈락 추가 115 · 신규 테이블 12) |
| 현재 DEFAULT 없음 → 신설 | (없음) | 89 | **추가 적용(사용자 최종 정정)** — 신규 테이블 83 + 1차 목록 6, 21테이블(END_CUSTOMER·NERP_*·SCM_ADM_API_M·SCM_ADM_MSG_M·SPMS_* 등), 전부 NOT NULL, VARCHAR2 72·NVARCHAR2 12·CHAR 5 → `DEFAULT ON NULL '/'` 신설 |

나머지 17행(적용 = 'Y' 유지 7 · 'N' 유지 5 · 'ALL'·SYS_GUID()·'NORMAL'·1 유지 각 1 · 미적용 1)은 시트 자체가 변경 대상이 아님.

## 2. 사내 적용 (ZIOUI1 SCM_MGR, 2026-10-08)

| 단계 | 내용 | 결과 |
|---|---|---|
| FRESH-GATE | 1,916컬럼 사전 재조회(`s1`) → 현재 `'-'` 1,916 / VARCHAR2 / NOT NULL / GTT 0 / ON NULL 플래그 xlsx 와 일치(YES 1,877 · 없음 39) | `00_BEFORE_dictionary_snapshot.{json,csv}` · 사전 INVALID 48 (`00_BEFORE_invalid_objects.json`) |
| 1차 적용 | 테이블 단위 `ALTER TABLE … MODIFY (col DEFAULT [ON NULL] '/')` 262문장, 컬럼별 기존 ON NULL 플래그 유지 | ok 262 / err 0 (85초) · `'/'` 1,916 |
| 재컴파일 | DDL 로 새로 INVALID 된 95객체 `ALTER … COMPILE` 2회 | 새 INVALID 0 · 총 INVALID 48(= 사전과 동일) |
| 정정 1 | "ON NULL 아니면 대상 아님" 지시 → 39컬럼 `DEFAULT '-'` 원복 | ok 25테이블 |
| 정정 2 | "ON NULL 은 일괄 적용, 없으면 추가" 지시 → 39컬럼 `DEFAULT ON NULL '/'` 적용 | ok 25테이블 · INVALID 48 유지 |
| 정정 3 | "현재 '-' 조건 무시, 적용 '/' 2,005 전부" 지시 → DEFAULT 없던 89컬럼(21테이블) `DEFAULT ON NULL '/'` 신설(`s6`, FRESH-GATE: 89 전부 DEFAULT 없음·NOT NULL·GTT 0) | ok 21/21 · 새 INVALID 4 재컴파일 |
| 최종 검증 | **2,005 전부 `DATA_DEFAULT = '/'`, `DEFAULT_ON_NULL = YES`** | `04_CORP_APPLY_RESULT.json` · `05_FINAL_SCOPE.json` · `00_BEFORE_dictionary_snapshot_extra89.csv` |
| 스크립트 검증 | `01_APPLY_CLOUD` 사내 재실행 → SUMMARY total=1916 altered=0 already=1916 other=0 missing=0 error=0(멱등) · `02_VERIFY` → slash=1916 (on_null=1916) dash=0 · `03_RECOMPILE` → 사전 INVALID 48 중 43 정상 컴파일(단순 stale), 5 는 원래 컴파일 오류(PKG_SCP0134·PKG_SDM2010/2020/2030·PKG_SPMS_SEND_MAIL, 본 작업 무관) | `s5` 출력 |

ON NULL 없던 39컬럼(25테이블): DM_PLN_SALES_PLAN(_C/_H/_RESULT…)·DM_PLN_MKT_FCST_RESULT(_C)·DM_PLN_NET_DEMAND·DM_PLN_DEMANDID_PEGGING·SCM_ADM_MNU_M·SCM_ADM_USER_*_H·SPMS_PROJECT_* 등 — 목록 `05_FINAL_SCOPE.json` `on_null_added`.

## 3. 클라우드 DEV / QA 적용 절차

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | `02_VERIFY.sql` (적용 전) | V1: 2,005 의 현재 분포 — 기대 `dash=1916 other=89(DEFAULT NULL)` (일부 `missing` = 그 환경에 없는 테이블, 기록만) · V2: INVALID 목록(사전 기준선) |
| 2 | **`01_APPLY_CLOUD_idempotent.sql`** | SCM_MGR 접속, `SET SERVEROUTPUT ON` 후 실행. 실행 시점 사전으로 컬럼마다 판정: 현재 `'-'` 또는 DEFAULT 없음 → `DEFAULT ON NULL '/'` · 이미 `'/'` 인데 ON NULL 없음 → ON NULL 추가 · 테이블/컬럼 없음 → MISSING · 다른 DEFAULT → OTHER(변경 안 함) · 오류(GTT 사용 중 ORA-14450 등) → ERROR. 마지막 `SUMMARY` 줄 확인 |
| 3 | `03_RECOMPILE_INVALID.sql` | DDL 로 무효화된 의존 PKG/PROC/VIEW 재컴파일(SCM_MGR INVALID 전부 2회) |
| 4 | `02_VERIFY.sql` (적용 후) | V1 기대 `slash=2005 (on_null=2005) dash=0 other=0` · V2 INVALID 가 1 의 기준선과 같은지 |
| 3b | `06_CLOUD_INVALID_DIAG.sql` (조회 전용, 2026-10-09 추가) | 03 에서 `COMPILE FAIL … ORA-24344` 가 남을 때 원인 분류. D1 INVALID 총수/오류 보유 수 · D2 분류(A 참조객체 미생성 / B 컬럼 없음 / C 의존객체 INVALID 연쇄 / D 권한 / E 기타) · D3 객체별 첫 오류 원문 · D4 미생성 식별자 목록(DEV 어느 스키마에도 없음 / 스펙 미생성 BODY 만 / 존재→권한) · D5 DEFAULT 대상 테이블 ORA-00904 교차검사(0행 = 본 작업 무관). **판정: D5 0행 + D2 가 A/B/C/D 만이면 SKIP 하고 다음 단계 진행. E 또는 D5 행 있으면 D3 출력 공유 후 중단** |
| 원복 | `99_ROLLBACK_DEFAULT_to_dash.sql` | 사내 적용 전 상태로(1,877 `DEFAULT ON NULL '-'` + 39 `DEFAULT '-'` + 89 `DEFAULT NULL`=제거). 클라우드 원복 시 그 환경의 사전 기준으로 다시 생성 권장 |

`01_APPLY_CORP_executed.sql` 은 사내 최종 효과와 같은 283문장(참고용, 클라우드는 01_APPLY_CLOUD 사용).

## 4. 유의

- `DEFAULT ON NULL` 은 INSERT 시 NULL 을 DEFAULT 로 치환한다. 기존 행은 바뀌지 않는다(기존 `'-'` 값 그대로).
- 적용 중 ALTER TABLE 은 메타 변경이라 즉시 끝나지만, 해당 테이블을 참조하는 PL/SQL 이 INVALID 로 바뀌고 다음 호출 때 자동 재컴파일된다. 배치 시간대를 피해 3번 재컴파일까지 한 번에 돌리는 것을 권장(사내 95객체 재컴파일 수 초).
- 사내 재실행 검증(멱등): `01_APPLY_CLOUD` → `SUMMARY total=2005 altered=0 already=2005 other=0 missing=0 error=0` · `02_VERIFY` → `slash=2005 (on_null=2005) dash=0`.

## 5. 클라우드 DEV 1차 실행 (2026-10-09, 사용자 직접 실행)

- 03_RECOMPILE 출력: pass 1 compiled=128 / pass 2 compiled=0 / remaining INVALID=37 (COMPILE FAIL 34 = VIEW 28 · PROCEDURE DMF0043 2 · PACKAGE BODY PKG_SCM_CMBO·PKG_SCP0001·PKG_SCP0030·PKG_SSP0003). 이어진 두 번째 재컴파일 출력에서는 TYPE STP_USER_OBJ · FN_GET_* 공통 함수 다수 · SCM/SCP/SSP 프로시저 수백 건이 COMPILE FAIL (붙여넣기 5만자 절단으로 총수 미확인).
- 원리상 01 은 컬럼 DEFAULT 메타만 바꾸므로(컬럼·타입·객체 변경 없음) 의존 객체를 INVALID 로 만들 수는 있어도 **컴파일 오류를 새로 만들 수 없음** → 재컴파일 뒤 ORA-24344 로 남는 객체는 그 환경 고유 오류(참조 객체 미생성·구조 차이) 보유. 사용자 가설 = "DEV 에 로컬(사내) PKG·객체가 전부 생성되어 있지 않음".
- 사용자 결정: 미생성 원인이면 SKIP 후 계속 진행. 확인 수단 = `06_CLOUD_INVALID_DIAG.sql` (사내 ZIOUI1 조회 전용 검증 통과 — 사내 INVALID 5 = A 참조없음 3(PKG_SCP0134 스펙 없음·UTL_MAIL 2) + B 컬럼없음 2(PKG_SDM2010/2020/2030 BLD.BIZ_TYPE), D5 0행).
- 03_RECOMPILE 마지막 메시지의 사내 수치("48개") 문구를 환경 중립으로 수정(2026-10-09).
