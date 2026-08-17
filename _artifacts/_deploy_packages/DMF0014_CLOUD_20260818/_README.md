# DMF0014 (Customer FCST Upload) 클라우드 이관 패키지 — 2026-08-18 취합

> **상태: 취합 완료 / 클라우드 미적용.** 적용은 별도 지시 후 수행.
> 계기 = 2026-08-18 사용자 보고 2건(재업로드 Dup / 회색 컬럼 저장)과 그 조사에서 드러난
> `ORA-00001` 계보를 사내에서 정정한 분량을 클라우드로 옮기기 위한 패키지.

## 1. 왜 이 범위인가 — 축은 기계 스윕으로 도출

`_artifacts/_diagnostics/_ui_deploy_axis_sweep.py DMF0014` (hook `deploy-axis-sweep-mandatory`)
- `SCM_ADM_%` / `SCM_MST_%` / `DM_ADM_%` **156 테이블 전수** 스캔 → `DMF0014` 보유 12 테이블 도출
- 쿼리 실패 = 즉시 중단(SKIP 금지). 결과 원본 = `_survey/axis_sweep_result.json`

## 2. 담긴 것

### A_DB (7 파일) — 적용 순서 = 파일명 순
| 파일 | 내용 | 규모 |
|---|---|---|
| `00_GTT_DDL.sql` | GTT **35개** 자급 DDL(`GT_DPCF%`/`GT_DCIM%`). 기존재 시 `SKIP(exists)` — 멱등 | 35 객체 |
| `01_PKG_DMF0014_SPEC.sql` | `ALL_SOURCE` 원문 | 106행 |
| `02_PKG_DMF0014_BODY.sql` | 원문 — **`[E20260818-BATCHKEEP]`**(재업로드 배치 정정) + **`[E20260818-GRAYWEEK]`**(회색 주차 반려) 반영 | 7,313행 |
| `03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql` | 후속 프로시저 — **정정 5건** 반영(아래 §3) | 2,038행 |
| `04_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql` | div 40 전용 후속 프로시저 (미변경분 — 동일 계보라 세트로 동봉) | 1,512행 |
| `10_META_DMF0014_ALL_AXES.sql` | 메타 **8축 / 171행** | 171행 |
| `90_VERIFY.sql` | 객체 VALID · 축별 기대 행수 · 정정 마커 · **Customer Master 실재** 확인 | — |

**메타 8축 (사내 실측 행수 = 이관 기대값)**

| 테이블 | 행 | 적재 방식 |
|---|---:|---|
| `SCM_ADM_MNU_M` | 1 | MERGE (PK `MNU_ID`) |
| `SCM_ADM_API_M` | 13 | MERGE (PK `API_ID`) |
| `SCM_ADM_PROC_M` | 64 | MERGE (PK `PROC_NM,COL_NM,COL_TP_CD`) |
| `SCM_ADM_MNU_BTN_MPG_M` | 12 | MERGE (PK `MNU_ID,SHT_NM,MNU_BTN_CD`) |
| `SCM_ADM_USER_GR_MNU_MPG_M` | 6 | MERGE |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 60 | MERGE |
| `SCM_ADM_EXCEL_COLUMNS` | 1 | 범위삭제+재적재 (PK 없음) |
| `SCM_MST_SHEET_COLUMNS` | 15 | 범위삭제+재적재 (PK 없음) |

- 범위삭제 2축의 삭제 범위 = `PROGRAM_ID LIKE 'DMF0014%'` = **삽입 범위와 동일**(소실 0).
- 감사컬럼에 `claude` 계열 ID 가 있으면 `'admin'` 으로 정규화(hook).

### B_FE (16 파일)
- `customer-fcst-upload/` **폴더 전체 13파일**(`index.ts` 포함 — viewRegistry 등록 키).
  ⚠ "변경분만" 담으면 탭 안에서 *Page Not Found* 가 난다(hook `deploy-fe-partial-folder-notfound`).
- `locales/KO·EN·CN.json` — 이 화면이 쓰는 MSG 14종·LBL 13종의 런타임 원천.
  MSG 14종은 사내 `SCM_ADM_MSG_M` 에 **전량 등록** 확인(스윕 C축).

### C_BE — 없음
이 화면은 generic call-proc + 공용 `FileController` `excel-upload` 체인만 사용.

## 3. 03_ 에 담긴 정정 5건 (2026-08-18 사내 적용분)

| 마커 | 내용 |
|---|---|
| `[E20260818-MKTDEL]` | 선삭제 범위를 INSERT 대상 키 집합과 일치시킴 |
| `[E20260818-RAISE]` | `WHEN OTHERS THEN ROLLBACK` 이 예외를 삼켜 **호출자 INSERT까지 되돌리고 정상 종료**하던 것을 `RAISE` 로 전파 |
| `[E20260818-MKTMERGE]` | `DM_PLN_MKT_FCST` 적재를 INSERT → **MERGE**(PK 10키) 전환 — 재저장이 덮어쓰기 |
| `[E20260818-MKTDISTINCT]` | `SELECT DISTINCT` 안의 `SYSTIMESTAMP` 때문에 무력화된 중복 제거를 정상화 |
| `[E20260818-MKTPKGUARD]` | ⭐ **근본** — 중복 행이 갈라지는 컬럼이 **`CREATION_DATE` 하나뿐**임을 계측으로 확정하고, PK 10키 파티션 후 **최신 1건만 채택**. 이전 업로드분 PSI 행과 이번 분이 같은 MKT 키로 겹쳐 `ORA-00001` 이 나던 것이 해소됨 |

검증 실측: 사용자 실제 파일(71행)로 **업로드+저장 6회 연속 전부 성공**, 원장 멱등(재저장해도 행수 불변).

## 4. 이관 제외 — 판단 근거

| 대상 | 제외 사유 |
|---|---|
| `SCM_ADM_EXCEL_UPLOAD` (132행) | 업로드 **스테이징 데이터** — 운영/테스트 이력 |
| `SCM_ADM_USER_MNU_SRCH_COND_M` (4행) | 사용자 **개인 조회조건** — 이관 시 타 환경 사용자 설정 덮어씀 |
| `SCM_ADM_PROGRAM` (1행) | AS-IS WinForms DLL 카탈로그 — TO-BE 무관 |
| `SCM_ADM_MSG_M` (18행) | 메시지 원장 — 화면 전용이 아니라 공용. MSG 14종 전량 사내 등록 확인만 하고 별도 이관 축으로 다룬다 |
| standalone 프로시저 2종 | `DMF0014_CUST_FCST_EXCEL_UPLOAD`, `DMF0014_SAVE_CUST_FCST_UPLOAD_DATA` — 사내에서도 **INVALID**(7~8월부터), 정본은 `PKG_DMF0014` |
| `DM_MST_CUSTOMER_FCST` | 마스터 **데이터** — 이관 대상 아님. 단 §5 주의 참조 |

## 5. ⚠ 적용 전 확인 (4건)

1. **Customer Master 실재** — 사내에서 이 표가 **0행**이 되어 업로드가 전건
   `Invalid Measure Upload Bucket.` 로 탈락한 사고가 있었다(2026-08-18, `_C` 최신 주차
   스냅샷 3,171행으로 복구). 클라우드도 `90_VERIFY.sql` ④로 먼저 확인할 것.
2. **`PR_DM_PLN_CUST_FCST_TO_MKT_FCST` 의존 객체** — `FN_NEXT_DAY`, `PR_SCM_SYS_LOG_BATCH`,
   `DM_MST_ITEM_SINGLE_V` 등 공용 객체는 미동봉. 부재 시 컴파일 INVALID.
3. **배포 후 반드시 재컴파일·상태 확인** — 이 프로시저를 바꾸면 `PKG_DMF0014` 가 INVALID 가 된다.
   `ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY;` 후 `90_VERIFY.sql` ①로 확인할 것.
   (2026-08-18 사내에서 이 확인을 건너뛰어 화면이 두 차례 중단된 사고가 있었다.)
4. **Period 열 입력 형식** — 주차 값은 텍스트로 입력해야 한다(숫자 셀은 `6.0` 으로 변환되어
   검증에서 탈락). DMF0074 와 동일 계보의 사용성 함정.

## 6. 적용 순서

```
A_DB/00_GTT_DDL.sql                              → GTT 35 (멱등)
A_DB/01_PKG_DMF0014_SPEC.sql
A_DB/02_PKG_DMF0014_BODY.sql
A_DB/03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql
A_DB/04_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql
   → ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY;   (의존 재컴파일)
A_DB/10_META_DMF0014_ALL_AXES.sql (COMMIT 포함)
A_DB/90_VERIFY.sql                               → 기대값 대조
B_FE                                             → 폴더 통째 배치 + locales 3본
```

원복: `_artifacts/_apply_corporate/BACKUP_PKG_DMF0014_BODY_pre_uploadfix_20260818.sql` ·
`BACKUP_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_pre_mktfix_20260818.sql` (정정 전 원본).

## 7. 근거 산출물

| 경로 | 내용 |
|---|---|
| `_survey/axis_sweep_result.json` | 축 스윕 원시 결과 (A/B/C 3계열) |
| `_survey/collect_report.json` | 취합 실적 (축별 행수 · GTT 목록 · FE 파일 목록) |
| `_artifacts/_diagnostics/_ui_deploy_axis_sweep.py` | 축 도출 도구 (화면 파라미터화) |
| `_artifacts/_diagnostics/_dmf0014_collect_package.py` | 취합 생성기 (재실행 멱등) |
| `_artifacts/_apply_corporate/DM_MST_CUSTOMER_FCST_RESTORE_20260818.sql` | 마스터 복구 SQL(§5-1 대비) |
