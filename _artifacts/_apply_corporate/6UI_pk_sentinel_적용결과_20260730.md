# 6화면 PK 센티널 `'-'` 확대 적용 — **완료** (사내 DB, 2026-07-30)

> 대상 화면: DMF0020 / DMF0003 / DMF0021 / DMF0042 / DMF0044 / DMF0049
> 확정 범위(**A안**, 사용자 지시): **Main Grid 의 Main Table** × **PK×VARCHAR2×NOT NULL ∩ 안전코어** × **명백한 저장 경로만**
> 근거 룰: hook #119 · 선례 `DMF0082_pk_sentinel_적용결과_20260730.md`

---

## 1. 적용 결과 — 8 오브젝트 / **136 건** (전부 VALID · USER_ERRORS 0)

| # | 오브젝트 | Main Table | 프로시저(문장) | 치환 | 배포 |
|---:|---|---|---|---:|---|
| 1 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | `SCM_MST_FUTURE_PRICE` | (단독) L840 INSERT | **11** | 21:54 |
| 2 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | `SCM_MST_FUTURE_PRICE` | (단독) L629 INSERT | **11** | 22:08 |
| 3 | `PKG_DMF0020` | `SCM_MST_FUTURE_PRICE` | `EXCEL_UPLOAD` L2057 MERGE(11) + `PRICE_CONVERSION` L4424 MERGE(11) | **22** | 22:08 |
| 4 | `PKG_DMF0003` | `DM_PLN_MKT_FCST` | `SAVE_MKT_FCST` INSERT 5문장 (10+9+10+9+9) | **47** | 21:56 |
| 5 | `PKG_DMF0021` | `DM_PLN_SALES_PLAN` | `SAVE_DM_PLN_SALES_PLAN_ALL` L3225 INSERT | **11** | 21:58 |
| 6 | `PKG_DMF0042` | `DM_PLN_BP_FCST` | `SAVE_DM_PLN_BP_FCST` INSERT 2문장(12+9) + **MERGE-SET 2**(L4384 `FCST_TYPE` / L4386 `INCOTERMS`) | **23** | 22:05 |
| 7 | `PKG_DMF0044` | `DM_PLN_SALES_PLAN_REPORT_C` | `SAVE_SALES_PLAN_REPORT_C` L3997 MERGE | **5** | 22:07 |
| 8 | `PKG_DMF0049` | `DM_PLN_SALES_ETC_REPORT_C` | `SAVE_SALES_ETC_REPORT_C` INSERT 2문장(3+3) | **6** | 22:07 |
| | | | **합계** | **136** | |

### 화면별 적용 컬럼 (PK×VARCHAR2×NOT NULL ∩ 안전코어)
| 화면 | 적용 | 제외(PK지만 위험) |
|---|---|---|
| DMF0020 | 11 — DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS | (없음) |
| DMF0003 | 10 — 위 11 중 CURRENCY 제외(PK 아님) | (없음) |
| DMF0021 | 11 — + CELL_PROD_SITE_ID / **CURRENCY 제외(PK 아님)** | (없음) |
| DMF0042 | 12 — + END_CUSTOMER, CELL_PROD_SITE, YYYYMM | **BIZ_TYPE, DEPT_ID, ITEM_USE** |
| DMF0044 | 11 | **VERSION_NO, COMPANY_ID, COMPO_40, DEPARTMENT_ID, DEPT_ID** |
| DMF0049 | 3 — DIVISION_ID, MEASURE, YYYYMMDD | **VERSION_NO** |

---

## 2. 제외 내역 (사용자 지시 "문제 소지 무조건 제외 / 확실한 것만")

| 분류 | 대상 | 제외 사유 |
|---|---|---|
| **버전축** | `VERSION_NO` / `CUTOFF_TYPE` / `CUTOFF_YYYYMMDD` | `'-'` 채우면 서로 다른 버전이 한 키로 뭉개짐 |
| **조직·회사 코드** | `DEPT_ID` `DEPARTMENT_ID` `COMPANY_ID` `COMPO_40` | 식별자 — 오류 은폐 |
| **분류 코드** | `BIZ_TYPE` `ITEM_USE` | 동일 |
| **공용 테이블** | `SCM_MST_TITLESET_USER`(전 화면 공용) · `PKG_DMF0000` 환율 · `SCM0002_SET_TITLESET_POPUP` | 6화면 밖 파급 |
| **Main Table 아닌 부수 테이블 전부** | 이력(`_H`) · `DM_MOBILE_REPORT_*` · `DM_ANL_MKT_PSI*` · `DM_PLN_PR_DETAIL` · `DM_BP_EXCHANGE_RATE*` · `DM_MST_EXCHANGE_RATE*` 등 | Main Table 아님 |
| **위험 프로시저** | ⛔`P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE`(L14130) — PK 값 **의도적 변경** 로직 / `P_DMF0044_SAVE_..._REPORT_C_CF`(34문장) / `P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY`(11) / `P_DMF0044_MOBILE_REPORT_CREATE` · `SALES_REPORT_DEPT_CREATE` · `SAVE_DM_EXCHANGE_RATE_REPORT` / `P_DMF0042_SAVE_..._PRICE_CONV`(2) · `SAVE_..._REPLACE_BY_CUTOFF`(1) / `P_DMF0003_SAVE_PRPOPUP` | 버전복사·Cutoff·리포트생성·PK변경 — A안 범위 밖 |
| **조회(SELECT) 리터럴 NULL** | **5건 전부 제외** — `NULL AS REQUEST_NO`(DMF0003 L2643, 코드성) / `NULL AS CUTOFF_YYYYMMDD`(DMF0021 L479·516·536, 버전축) / `NULL AS YYYYMMDD`(DMF0044 L1787, 버전팝업=Main Grid 아님) | 확실한 것만 원칙 |

### 대상 없음으로 확인된 것 (작업 불필요)
- `PKG_DMF0003` `SAVE_MKT_FCST` **UPDATE 2문장**(L11332/L11353) — `SET A.QTY = 0` 뿐, **PK 대입 없음**
- `PKG_DMF0049` **UPDATE**(L1000) — 동일
- `PKG_DMF0044` L4117 MERGE-UPDATE — `FORECAST_INFO_*` 만 SET, **PK 아님**
- `PKG_DMF0044` `CELL_PROD_SITE` — 이미 `'-'` 리터럴(L4105, 원문 주석 `NOT NULL, PK`)
- 조회 전용 5 오브젝트(`DMF0002_GET_TITLESET_POPUP`·`DMF0020_GET_SCM_MST_FUTURE_PRICE`·`DMF0020_GET_SPREAD_TITLE_DATE`·`DMF0073_GET_VERSION_SALESPRICE`·`PR_GET_DAY_RANGE`) — 영속 DML 0

---

## 3. 전수 census 근거 (누락 0 검증)

- 배선 원장 = `SCM_ADM_MNU_BTN_MPG_M` × `SCM_ADM_API_M` **API 81행 → 고유 오브젝트 15개**
- 검사 라인 = **39,764행 전 라인** (표본 아님)
- 컬럼↔값 **개수 불일치 0건** (전 문장 위치 1:1 대조)
- Main Table DML 은 **프로시저 필터 없이** 전수 열거 후 A안 화이트리스트로 선별

### ⭐ 작업 중 잡은 파서 결함 4건 (모두 배포 전 교정 — 누락/과잉 방지)
| # | 결함 | 영향 | 교정 |
|---:|---|---|---|
| 1 | **로컬 프로시저 소속 오탐** — `LOG_END` 를 프로시저 경계로 오인 | **DMF0049 2문장이 "범위 밖"으로 잘못 분류** (누락 위험) | `ALL_ARGUMENTS` 기준 공개 프로시저만 경계 인정 → 복구 |
| 2 | **UPDATE SET 절 미검사** | `MERGE ... WHEN MATCHED UPDATE SET <PK>` 누락 | 전수 스윕 추가 → **DMF0042 2건**(ORA-01407 위험) 발견·적용 |
| 3 | **PK 여부 미검사** | **DMF0021 에서 비PK `V_CURRENCY` 과잉 치환** 시도 | Main Table PK 교집합 검사 추가 → 배포 전 차단 |
| 4 | **SET 처리 블록이 `continue` 뒤** → 도달 불가 | DMF0042 MERGE-SET 2건 미적용 | 값목록 파싱보다 앞으로 이동 |
| 5 | **닫는 괄호를 값에 포함** | DMF0044 `CELL_PROD_SITE`(이미 `'-'`)를 다중라인 오탐 | 짝 안 맞는 뒤쪽 `)`/`;` 제거 |

---

## 4. 검증 (오브젝트별 공통)

1. 규칙별 **기대건수 assert** 일치 / **라인수 불변** / 잔존 경고 0
2. **diff 육안 확인** — 주석·리터럴·숫자(`A.QTY`, `B.PRICE`, `TO_NUMBER(B.LOC)`) 미변경 확인
3. BE(8080) 정지 상태 → `DDL_LOCK_TIMEOUT=120` 배포 → **8/8 VALID · USER_ERRORS 0**
4. **INVALID 738건은 본 작업과 무관** 확정 — 내 배포 오브젝트에 의존하는 INVALID **0건**, 737건이 기존 컴파일 결함(`ORA-00904 "V"."ACTIVE_FLAG"` 등), 배포 전후 **738 불변**
5. 저장 SP 는 **직접 실행 안 함** (hook #104 — 부수효과·연쇄 SP) → 화면 E2E 위임

---

## 5. 원복

```
-- BE 정지 후 (오브젝트별 개별 원복 가능)
@BACKUP_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL_pre_nvl_20260730.sql
@BACKUP_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0020_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0003_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0021_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0042_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0044_pre_nvl_20260730.sql
@BACKUP_PKG_DMF0049_pre_nvl_20260730.sql
```

## 6. 잔여

- **BE 재기동** — 요청 시 (현재 정지)
- 화면 E2E: 6화면 저장 경로 실측
- **클라우드 미적용** — 이관 패키지 취합 시 8 오브젝트 동봉 (룰 22 / hook #14)
- 미적용 범위(§2 위험 프로시저)는 필요 시 별건 검토
- ⚠️ 별건 기존 결함(미수정): `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT` 전 division `ORA-00904 "SORT_KEY"` — `V_ORDERBY` 가 `SORT_KEY` 참조하나 템플릿 SELECT 미투영
