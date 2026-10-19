# DMF0014 Excel Upload — Customer Project/Model AS-IS 동일화 + [Project]/[Model] DMF0005 마스터 검증 (클라우드 이관)

> 마커 `[E20260930-DMF0014ASISPM]` · `[E20260930-DMF0014PMSI]` · `[E20260930-DMF0014MDLIND]` — DMF0014 Customer FCST Upload · [Upload] 검증 (`P_DMF0014_CUST_FCST_EXCEL_UPLOAD`, Division ≠ 40)

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0014` BODY 1본. FE·BE·PROC_M·메타 변경 없음 |
| 전제 | 클라우드 BODY = [`DMF0014_PRJMDL_CUSTFCST_CLOUD_20260929`](../DMF0014_PRJMDL_CUSTFCST_CLOUD_20260929/00_README.md) 의 10 적용본 (지문 `11471/746462`) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 13:38 ASISPM → 13:47 PMSI → 13:51 MDLIND) — [`_apply_corporate/DMF0014_ASIS_PRJMDL_20260930`](../../_apply_corporate/DMF0014_ASIS_PRJMDL_20260930/) |
| 클라우드 | **미적용** · ⚠ **QA · DEV 2곳 모두** |
| BE 재기동 | 불요 |

## 1. 지적 사항 (2026-09-30)

1. "Customer Project 검증은 AS-IS 에서 주석이었는데 풀렸다" — 09-23 분리 신설로 활성화돼 있었음.
2. "Model 은 Validation 이 안 나온다" — `Invalid Customer Model` 이 Customer Project 통과 행에만 걸려 있었음.
3. "[Project]=AAA, [Model]=BBB 가 통과 — DMF0005(Sales Site Project Model) 마스터 체크 누락" → DMF0005 마스터 = `SCM_MST_SITE_ITEM`.
4. "[Model] 에도 BBB 가 들어갔는데 Project 만 나온다" — `Invalid Model` 이 Project 통과 행에만 걸려 있었음.

## 2. 최종 검증 규칙 (Division ≠ 40)

| 검증 | 대상 열 | 판정 | 근거 |
|---|---|---|---|
| ~~Invalid Customer Project~~ | — | **비활성** | AS-IS L399~427 주석 파리티 |
| Invalid Customer Model | Customer Model* | 고객모델 마스터 (Site, Customer Project, Customer Model) **또는** SITE_ITEM (Site, [Project], [Model]) — 둘 다 없을 때만 오류 | AS-IS L429~470 동일 (Customer Project 통과 가드 제거 · SITE_ITEM 경로 복원) |
| Invalid Project | Project | (Division, Sales Site) SITE_ITEM 에 [Project] 없음 · 빈칸 포함 | DMF0005 마스터 (사용자 결정) |
| Invalid Model | Model | [Project] 정상 → (Site, [Project], [Model]) 조합 없음 / [Project] 오류 → (Site, [Model]) 자체 없음 · 빈칸 포함 | DMF0005 마스터 (사용자 결정) — Project 오류 행도 판정, 정상 Model 은 오탐 없음 |
| Invalid Model (품목분류) | Model | 대상 품목이 `SCM_MST_ITEM_SN` 에 없음 | 09-15 유지 (저장 후 반영 오류 방지) |

한 행의 사유는 ` / ` 로 모두 누적된다. 비활성은 줄 단위 `--` (내부 `/* */` 와 중첩 금지 — PLS-00103).

**사내 E2E** (실제 BE `/excel-upload`, 27케이스) — **PASS 27 / FAIL 0** [`_gate_reports/DMF0014_excel_upload_cases_20260930_1352.md`](../../_gate_reports/DMF0014_excel_upload_cases_20260930_1352.md)

| 케이스 | 입력 | 결과 |
|---|---|---|
| 26 | [Project]=AAA · [Model]=BBB | `Invalid Project [Project: AAA] / Invalid Model [Model: BBB]` |
| 17 | [Project]=ZZ_PRJCODE · [Model] 정상 | `Invalid Project [Project: ZZ_PRJCODE]` (Model 오탐 없음) |
| 22 | [Project]/[Model] 빈칸 | `Invalid Project [Project: (empty)] / Invalid Model [Model: (empty)]` |
| 23 | [Model]=ZZ_ITEM ([Project] 정상) | `Invalid Model [Model: ZZ_ITEM]` |
| 07 · 08 | Customer Project 또는 Customer Model 미등재 ([Project]/[Model] 정상) | 통과 (AS-IS SITE_ITEM 경로) |
| 24 · 25 | Customer 쪽 + [Project]/[Model] 둘 다 불일치 | `Invalid Customer Model [...]` + `Invalid Project/Model [...]` |

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` JUDGE `적용` 이면 진행 / `SKIP` 이면 종료 / `⚠ 중단` 이면 결과 회신
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0014_ASISPM`
3. [A_DB/10_PKG_DMF0014_BODY.sql](A_DB/10_PKG_DMF0014_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID·오류 0 / V2 지문 `11483/748077`·마커 ASISPM 4·MDLIND 1
5. 화면: [`Doc/단위테스트/DMF0014_ExcelUpload_ValidationCases_20260930.xlsx`](../../../Doc/단위테스트/DMF0014_ExcelUpload_ValidationCases_20260930.xlsx) 의 26·17·22 시트로 업로드 확인

롤백 (평소 실행 안 함): [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 유의

- `_SM` 프로시저(미배선)·Division 40 분기 무변경.
- 적용 이력: 13:38 ASISPM 에서 [Project]/[Model] 단독 검증을 한때 비활성했다가(AS-IS 완전 동일 선택) 13:47 PMSI 로 재활성 — 이 패키지는 최종 상태(13:51) 1본이다.
