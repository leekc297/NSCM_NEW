# DMF0049 세트 보충 2차 — 클라우드 ORA-00001(RTF 저장) 정정 (DB 단, 클라우드 이관)

> 마커 `[E20260930-DMF0049SETFULL2]` — `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` · 전제 = [`DMF0049_SETFULL_CLOUD_20260930`](../DMF0049_SETFULL_CLOUD_20260930/00_README.md)(1차) 적용 상태

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0049` BODY, 1차 보충 INSERT 블록(62줄)을 2차 블록(55줄)으로 **교체**. (a) RTF 0행 삭제 비활성 2줄은 그대로. FE·BE·메타 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 20:00:38) — [`_apply_corporate/DMF0049_SETFULL_20260930/apply_setfull2.py`](../../_apply_corporate/DMF0049_SETFULL_20260930/apply_setfull2.py) |
| 클라우드 | **미적용** · ⚠ QA · DEV 2곳 모두 (1차 적용된 DB 에 덧적용) |
| BE 재기동 | 불요 |

## 1. 클라우드 실사고 (2026-09-30 19:41, minyonglee1)

Insert 후 RTF 만 입력하고 저장 → `ORA-00001 PK_DM_PLN_SALES_ETC_REPORT_C (VERSION_NO, DIVISION_ID, DATA_SEQ, MEASURE, YYYYMMDD)` @ BODY 1197행 = "INSERT 대상(DATA_SEQ 미존재)" 원장 INSERT. 페이로드 = I × 2개월(202609·202610) × 3행, RTF 11/22. 달력 매핑·이력 시퀀스·원장 잔여 행은 모두 정상(95~97 진단).

**원인**: 1차 보충 INSERT 는 GTT 식별 **33컬럼이 전부 같은** 행끼리만 같은 세트로 봤다. 화면 세트 행들 사이에 DATA_SEQ 채번 키(DENSE_RANK 19컬럼)가 **아닌** 컬럼(부서명 `T_DEPARTMENT_NAME`·`DEPARTMENT_EDIT_FLAG`·`FCST_TYPE`·`CELL_MODEL*`·`PROJECT_CODE`·`SCM_SITE_ID`)이 서로 다르면 그룹이 갈라져, 같은 (채번 DATA_SEQ, MEASURE, 월)에 보충 행이 두 벌 생겨 PK 충돌. 사내 1차 검증 페이로드는 행 간 값이 모두 같아 통과했었다.
**사내 재현**: 1차 상태에서 부서명/편집플래그를 첫 행에만 채우거나 FCST_TYPE 을 행마다 달리 보내면 **동일 ORA-00001** 발생 → 2차 적용 후 동일 페이로드 성공.

## 2. 정정 (2차 블록)

- 세트 판정 키 = `VERSION_NO · DIVISION_ID · DATA_SEQ` + **INSERT 경로 DATA_SEQ 채번 키 19컬럼**(DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER) + `YYYYMMDD`.
- 비-키 컬럼(ACTIVE_FLAG, RESULT_MONTH, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME, PROJECT_CODE, SCM_SITE_ID, CELL_MODEL_INFO, CELL_MODEL, FCST_TYPE, CREATED_BY)은 그룹 **MAX 대표값**.
- `NOT EXISTS` 도 같은 키 + MEASURE (NULL-safe DECODE, 'D' 제외). 원장 보존 가드(수정 경로 실제 값 보존) 유지.

**사내 E2E** (2차 적용 후 · ZZ_TEST 세트 즉시 삭제): X1 부서명/편집플래그 행별 상이 → 3행+LOC 성공 / X2 FCST_TYPE 행별 상이 → 성공 / X3 동일 페이로드 → 성공 / X4 M RTF 1행만 → 3행 보충·기존 값 보존 / X5 I LOC 1행만 → 3행 보충. 1차 상태에서는 X1·X2 가 ORA-00001.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — `[H]` **`적용`**(= 1차 적용본) → 2·3·4 / `SKIP` / `⚠` → §4
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0049_SETFULL2`
3. [A_DB/11_PKG_DMF0049_BODY.sql](A_DB/11_PKG_DMF0049_BODY.sql) — BODY 전체본
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID / V2 2차 블록 1·1차 블록 0·비활성 2줄·활성 RTF 삭제 0 / V3 GRANT
5. 화면: 19:41 실패 케이스(Insert → RTF 만 2개월 입력 → 저장) 재시도 → 성공·3행+단가(LOC) 행 확인

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 지문이 다르면 수동 반영

[A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql): 1차 블록(`/*[E20260930-DMF0049SETFULL] 메저 세트 보충 …` 부터 `--Start [C20210125-000207] 40사업부 Unit Price Measure 추가` 직전까지)을 통째로 이 블록으로 바꾸고 재컴파일 → `90_VERIFY` V2.

## 5. 별건 관찰 (FE)

클라우드 화면이 같은 세트의 행마다 부서명·편집플래그 등 비-키 값을 다르게 보내는 것으로 보인다(사내 FE 코드는 세트 첫 행 identity 를 전 행에 공유). 저장 결과에는 영향이 없도록 SP 가 흡수했지만, 클라우드 FE 세대가 사내와 다른지 확인 가치가 있다 — [A_DB/98_DIAG_PAYLOAD_TOKENS.sql](../DMF0049_SETFULL_CLOUD_20260930/A_DB/98_DIAG_PAYLOAD_TOKENS.sql) 로 실패 호출의 행별 토큰을 볼 수 있다.
