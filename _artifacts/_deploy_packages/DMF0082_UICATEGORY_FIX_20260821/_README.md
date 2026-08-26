# DMF0082 UI CATEGORY SETUP 보완 (2026-08-21)

> 상태: **미적용** — 생성만 완료. 사내 DB 반영은 사용자 승인 후.
> 근거 원천: UI 메타 지식사전 v1.0 (`Doc/_rules_v2/_dictionary/`) + division별 AS-IS 기준 규칙(hook #142 §3.5)

## 적용 순서

| # | 파일 | 기대 |
|---|---|---|
| 0 | `A_DB/00_BACKUP.sql` | 4행 백업 |
| 1 | `A_DB/01_FIX_PROJECT_CODE_MODALKEY.sql` | 1행 UPDATE |
| 2 | `A_DB/02_FIX_DIVISION_SCOPE_82.sql` | 3행 UPDATE |
| 3 | `A_DB/90_VERIFY.sql` | 4행 EXPECTED=ACTUAL · PK DUP 0 |
| — | `A_DB/99_ROLLBACK.sql` | 원복 (필요 시) |

두 UPDATE 모두 **현재값 일치 조건**을 걸어 재실행해도 안전하다(멱등).

## 포함하지 않은 항목 (판정: 정정 대상 아님)

| 항목 | 사유 |
|---|---|
| `AS_FROM_SITE` 콤보 배선 | TO-BE 가 **AS-IS DMF0082 와 동일**(양쪽 컨트롤·콤보 공란). 회귀가 아니다. 단일 행이라 82만 바꿀 수 없어 40까지 영향. FE 는 이미 화면 레벨에서 `AS_FROM_SITE` 콤보를 소비(`ForecastPrice.tsx:225`) |
| `FORECAST_INFO_PRODUCT_GROUP` | DMF0082 에 **행 자체가 없다**. 신규 행 생성은 `ui-category-setup-no-arbitrary-data` 금지 대상 — 필요 여부는 운영 판단 |
| D12 5건(`APPLICATION`/`CUST_GROUP_DTL`/`MEASURE_GROUP`/`ROUTE` 등) | 콤보 ID 는 있으나 컨트롤이 `FPComboBox` 가 아니라 소비되지 않음. **AS-IS 동일 모양** — AS-IS `SpreadInfo.cs:1442` 도 `FPComboBox` 일 때만 콤보를 붙인다. 고치면 AS-IS 대비 기능 추가 |
| 콤보 ID 재매핑 4건(`CurrencyList`/`CustGroup`/`EndCustomerByDivisionDMF0082`/`FcstTypeByUserGroupDMF0082`) | TO-BE 가 등록된 ID 로 의도 재매핑한 것 — 정상 |
| MEASURE `SCM_FCST.SMALL_CLASS_LABEL_NAME` | AS-IS `'SCM_FCST'` → TO-BE `'SCM FCST[R+P]'`. AS-IS `COLUMN_LABEL_NAME` 이 이미 `'SCM FCST[R+P]'` 라 일관성 개선. 원복 불필요 |

## ⚠ 적용 시점 주의

2026-08-21 저녁 사내 Oracle 에 **대량 적재가 진행**됐다(15:31~20:26, `SCM_ADM_LOOKUP_MASTER_DETAIL`
0행 구간 포함). 같은 창에서 `SCM_MST_SHEET_COLUMNS` 건수가 15,704 → 15,702 로 또 변했다.
적재가 다시 돌면 이 UPDATE 가 **조용히 덮일 수 있다.** 적용 후 `90_VERIFY.sql` 재실행으로 잔존을 확인할 것.
