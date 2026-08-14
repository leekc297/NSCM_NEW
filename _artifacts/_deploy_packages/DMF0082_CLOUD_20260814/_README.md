# DMF0082 (Fcst&Price MGMT) — 클라우드 이관 패키지 (2026-08-14)

> **기준선**: 클라우드 = `DMF0082_CLOUD_20260812` 적용 상태.
> 본 패키지 = 그 이후 **사내 변경분**(08-13 Excel Form/Upload 적재 + 08-14 통합테스트 1st 6건 보완).
> **QA·DEV 2개 DB 각각** 적용. 전 스크립트 멱등(MERGE/CREATE OR REPLACE) — 재적용 무해.
>
> ⚠ 기준선 미적용 DB 에는 **`DMF0082_CLOUD_20260812` 를 먼저** 적용할 것
> (`00_PRECHECK_CLOUD.sql` [A] 가 판정한다).

---

## 담는 작업 (08-12 이후 누적)

### 08-13 — Excel Form / Upload
| 마커 | 내용 |
|---|---|
| `E20260813-EXCELFORM` | **Excel Form 조회 SP 신설**(`P_DMF0082_GET_EXCEL_FORM_DATA`) — MAIN GET 내부호출로 `TEMP_FCST_N_PRICE` 재사용(필터 무복제) |
| `E20260813-UPLOADSAVE` | Excel Upload **원장 적재 경로**(`p_mode > 0` 분기) + `'^'` 파싱부 skip 플래그(1회용 소비 — 세션 누수 방지) |

### 08-14 — 통합테스트 1st 재점검 6건 (No.41/42/45/49/64/65)
| No | 조치 | 담긴 파일 |
|---|---|---|
| **41** | ① CURRENT SP `O_RC4` 컬럼 규격을 일반 GET 과 정합(`MEASURE/EDIT_AUTH_YN/TODAY_LIMIT_YN/TODAY_DAY_LIST`) — 종전 2컬럼이라 FE 가 못 읽어 **전 measure 잠김** ② `GET_ADMIN_GROUP_MEASURE` 에 81 계열·82 grant 보강(MKT_FCST·LOC×5그룹, SCP Planner 요일제한, 81 SCM_FCST) ③ 40 SCM_FCST 요일창 `MON 1900~2000` → **`WED 0000~1700`**(AS-IS 2026-07-08 최신본 동기화) | `03_BODY` · `04_LOOKUP` |
| **42** | 40 Div FCST Type = `SALES_TYPE_CODE` 중 W/S 전용(`ATTRIBUTE2='Y'`) 2종만 제외 = **12종(ETC 포함)**. 종전의 `SEGMENT1<>'ETC'` 는 **다른 콤보 코드**(`FCST_TYPE_NOT_ETC`)의 조건 오이식이었다. + FE 가 호출만 하고 **DB 미등재**였던 `FcstTypeEditDMF0082` 신규 등재 | `05_CMBO` |
| **45** | 요구 데이터셋 재현 결과 52주 판가 게이트가 **정상 차단**(위반 62주) — 변경 없음 | — |
| **49** | `E20260814-FCSTNAME` — 판가 미입력 팝업 **오탐** 정정. 제외목록(`MKT_FCST_VALIDATION_PRICE`)이 **코드**만 담는데 FCST_TYPE 이 **명칭**으로 들어온 행이 `NOT IN` 을 통과했다(원장 실재: div40 `Mass` 585행). 판정을 **코드+명칭 양쪽**으로 확장 | `03_BODY` |
| **64** | End Customer 셀 콤보가 `EndCustomerByDivision40`(SQL 안에 `'40'` 하드코딩)을 전 division 에 물고 있어 81 조회 시 40 목록(AJ상사) 노출 → **`EndCustomerByDivisionDMF0082`**(END_CUSTOMER 룩업 division 상별) 신규 등재 + 메타 재배선 | `05_CMBO` · `06_SHEET_META` |
| **65** | 81 컬럼 전수 대조(AS-IS `DMF0003 'Mkt Fcst'` ↔ TO-BE) 결과 **컬럼 메타는 완비**. 실제 결함 = `PROJECT_CODE` 가 `FPModal` 인데 **셀 검색모달 미배선** → 81 신규행에서 Project 입력 수단이 없었음 → FE 모달 배선 | `B_FE` · `C_FE_SHARED` |

> **DB 변경 없음** 항목: No.45(재현 검증만), No.65(FE 전용).

---

## A_DB — 적용 순서 (sqlplus, `SET DEFINE OFF`)

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 0 | `00_PRECHECK_CLOUD.sql` | ⭐ **READ-ONLY 선판정** — 기준선 적용 여부/CTRL 화이트리스트/INPUT_TP_CD 분포/채번 충돌/신규 콤보·SP 존재 | 조회만 |
| 1 | `01_GTT_DDL.sql` | BODY 참조 GTT 자급 DDL | 기존재 skip 멱등 |
| 2 | `02_PKG_DMF0082_SPEC.sql` | SPEC 현행 스냅샷 (Excel Form SP 선언 포함) | CREATE OR REPLACE |
| 3 | `03_PKG_DMF0082_BODY.sql` | **BODY 현행 스냅샷 — 08-13·08-14 누적 최종형** | CREATE OR REPLACE |
| 4 | `04_LOOKUP_GET_ADMIN_GROUP_MEASURE.sql` | measure 편집권한 **116행 전수** (기준선 28행 → +88) | MERGE (PK = LOOKUP_TYPE+SEGMENT1~5) |
| 5 | `05_CMBO_SYNC.sql` | DMF0082 소비 콤보 중 기준선 이후 변경 **4종** | MERGE (본문 CLOB 청크) |
| 6 | `06_SHEET_META_SYNC.sql` | UI Category — COLUMNS 86행 + MEASURE 22행 | MERGE (**DELETE 없음**) |
| 7 | `07_PROCM_API_SYNC.sql` | Excel Form PROC 18행 + API 17행 | MERGE |
| 8 | `08_MSG_SYNC.sql` | `MSG00703`/`MSG00705` 3언어 6행 | MERGE |
| 9 | `09_BTN_WIRING_SYNC.sql` | ⭐ **버튼 배선 18행 + 버튼 권한 100행** — `FORM_DATA`(Excel Form, 08-13 신설) 포함 | MERGE |
| 10 | `10_EXCEL_META_SYNC.sql` | Excel 메타 — `EXCEL_UPLOAD` 13행 + `EXCEL_COLUMNS` 1행 | MERGE |
| 11 | `90_VERIFY.sql` | ⭐ **적용 후 값 단언 11섹션** (기대값 스크립트 내장) | 조회만 |

> ⛔ **2026-08-14 2차 정정** — 최초본에 `09`·`10` 이 **누락**돼 클라우드 40 division 에서
> **Excel Form 버튼이 보이지 않는** 사고가 났다. FE 게이트는 `isExcelDiv(40) && hasButton('FORM_DATA')` 인데,
> 그 버튼의 배선(`SCM_ADM_MNU_BTN_MPG_M`)·권한(`SCM_ADM_USER_GR_MNU_BTN_MPG_M`) 행이 **08-13 22:00 신설분**이라
> 클라우드에 없었다. 누락 경위 = 델타 서베이를 테이블별로 손으로 나열하다 컬럼명 오류로 BTN 축이 조용히 스킵됨.
> ⇒ 이후 축 도출은 **기계적 전수 스윕**(`_artifacts/_diagnostics/_dmf0082_missing_axis_sweep.py`)으로만 한다.

### 시트 메타를 MERGE 로 하는 근거 (hook #98 §9 예외 판정)
§9 는 클라우드 이관 시 **SHEET_NAME 단위 DELETE 후 전량 재적재**를 요구한다. 그 목적은
"사내에서 삭제된 행이 클라우드에 남는 소실/잔존"을 막는 것이다. 본 패키지는 그 조건에 해당하지 않는다:

- 기준선(08-12) 이후 DMF0082 시트 메타 변경은 **UPDATE 2건뿐**(`AS_FROM_SITE` 08-12·`END_CUSTOMER` 08-14), **삭제 0건**
- 행 수도 기준선 패키지와 동일 — `FcstNPrice` COLUMNS **61** / MEASURE **22** (08-12 패키지 명시치와 일치)
- `Sales Price Save All` 은 **공유 시트**다(사내 DMF0082 소유 25행 / 전체 49행). DELETE 방식이면 타 PROGRAM_ID 행 전량을
  동봉해야 하는데, 삭제할 행이 없는 상황에서 그 위험만 떠안게 된다.

⇒ **MERGE(DELETE 절 없음)** 가 동일 결과 + 낮은 위험. 행 수 단언은 `90_VERIFY.sql` [7] 이 수행한다.

---

## B_FE / C_FE_SHARED — ⚠️ **폴더 단위 전체 교체** (부분 반입 금지)

> ⛔ **2026-08-14 정정** — 최초본은 "기준선 대비 변경분만" 담았다가 **`forecast-price/index.ts` 가 누락**됐다.
> 그 파일이 화면 등록의 **유일한 키**다: `apps/web/src/mdi/viewRegistry.tsx` 가
> `import.meta.glob('features/*/src/pages/*/index.ts')` 로 화면을 수집하므로, `index.ts` 없이 폴더를
> 교체하면 `resolveView()` → `undefined` → `ViewContainer.tsx:139` 이 **탭 안에 NotFoundPage** 를 그린다
> (= "Page Not Found. Unfortunately, the requested page could not be found.").
> 규약 = 메모리 `feedback_cloud_shell_generation_mismatch` §2026-08-11
> **"이관 단위는 import 가 통과하는 최상위 폴더다"**. 아래는 모두 **폴더 통째** 교체본이다.

### 반입 범위 규칙 (사용자 지시 2026-08-14)

> **"수정한 파일이 존재하는 폴더"는 그 폴더 전체**를 담는다. **수정 0건인 폴더는 담지 않는다.**
> (= 부분 파일 반입 금지 ↔ 무관 폴더 과대 반입도 금지)

| 경로 | 대상 | 파일 | 반입 단위 |
|---|---|---:|---|
| `B_FE/forecast-price/` | `features/demand/src/pages/forecast-price/` | **31** | **페이지 폴더 자체가 단위** → 미수정 파일 포함 **전체**. ⭐ `index.ts` 는 수정되지 않았지만 **반드시 포함**(viewRegistry 등록 키) |
| `C_FE_SHARED/master-components/` | `features/master/src/components/` | **51** | **하위 컴포넌트 폴더가 각각 단위** → 수정 있는 13폴더 + 수정된 `index.ts`(barrel) |

**master-components 반입 13폴더**: `columnLayoutModal` · `columnSettingModal` · `contributeVersionModal` ·
`customerModal` · `itemByDivisionModal` · `measureSelectModal`(신규) · `ownerByDivisionModal` · `ownerModal` ·
`projectByDivisionModal` · `projectModal` · `regionModal` · `searchFields` · `versionModal`(신규) + `index.ts`

**제외**: `contributeRateModal` · `storageLocationModal` · `teamModal` (수정 0건) /
`features/demand/src/components/` **폴더 통째 제외**(수정 0건 — 기준선 반입분이 그대로 유효)

> ⚠️ master 공용 13폴더 중 일부는 **DMF0082 전용 변경이 아니다**(다른 화면 작업분 포함). barrel `index.ts` 가
> 수정돼 있어 export 정합을 위해 함께 반입한다. 타 화면 미완 작업이 섞이면 곤란한 경우, 반입 전
> `git status -- nscm-fe/features/master/src/components` 로 내용을 확인하고 선별할 것.

### 반입 후 필수 확인 (1분)
```bash
# ① 화면 등록 키 — 반드시 존재해야 한다 (없으면 Page Not Found 재발)
ls features/demand/src/pages/forecast-price/index.ts

# ② 로컬 사본 잔재 0 — 공용 승격분이 로컬 사본에 가려지지 않는지 (hook #132)
ls features/demand/src/pages/forecast-price/components/modals/MeasureSelectModal.tsx   # 없어야 정상

# ③ 빌드 — barrel export 불일치는 여기서 잡힌다
pnpm build   # 또는 클라우드 표준 빌드 명령
```

> `public/locales/{KO,EN,CN}.json` — 본 패키지는 **신규 i18n 코드 없음**(MSG00703/00705 는 기존 코드).
> 기준선 패키지의 locales 를 이미 반영했다면 추가 작업 없음.

---

## 본 패키지에 **넣지 않은** 것 (의도적 제외)

| 항목 | 사유 |
|---|---|
| 콤보 11종 (`SalesPlant`·`MktFcstEditMeasure`·`TeambyDivision2`·`CompanySalesSite`·`SalesCompany`·`PlantSiteByItem`·`SalesPlanItemId`·`DpjtClass`·`StackMethod`·`CellTypeByDivision`·`SpmsEndCustomer`) | 08-12 이후 변경됐지만 **DMF0082 가 소비하지 않는다**(소비 39종 ∩ 변경 15종 = 4종 실측). UP_FX 전수 변환 패키지 소관 |
| `SCM_MST_TITLESET_USER` (19행 변경) | **사용자 개인 컬럼셋**(개인화 데이터). 클라우드에서 사용자별로 자체 생성되며, 이관하면 타 환경 사용자 설정을 덮어쓴다. 기준선 패키지도 미포함 |
| `SalesPlan.tsx` / `BusinessPlan.tsx` 필터 룰 정정 | 08-14 공통 룰(hook #133 §5 UC-01 역전) 적용분이나 **DMF0021·DMF0042 소속**. 해당 화면 패키지에 포함할 것 |
| `ProjectByDivision` CMBO 등재 | FPModal 컬럼의 `CELL_COMBO_DATA_TYPE` 은 **소비되지 않는 사문 값**(공용 DataGrid 는 `FPComboBox` 일 때만 콤보 생성). 등재해도 화면 무변화라 근거 없는 메타를 만들지 않음 |

---

## 적용 후 기대치 (사내 실측 = 클라우드 기대치)

| 축 | 값 |
|---|---|
| PKG | SPEC/BODY **VALID**, 컴파일 오류 0, 마커 4종 존재 |
| measure 편집권한 | 116행 / 40 SCM_FCST = `WED 0000~1700` / 81·82 에 MKT_FCST·LOC grant 존재 |
| Current 버전 measure | 81+DM Planner(W/S) = `AS_In_Req`·`LOC`·`MKT_FCST` = Y (종전 전부 N) |
| FCST Type (40) | **12종**(AS,ASF,ETC,MPS,RMA,Recall,SDC,SDF,SMC,SMF,SPF,TST) — WS/WSF 없음 |
| FCST Type (81+W/S) | 4종(WS,WSF,AS,ASF) |
| End Customer | div40 **1,067종**(구 등재본과 동일 = 회귀 0) / 81 553 / 81_HG 227 / 82 1,534, 81·82 에 `AJ*` 0건 |
| UI Category | COLUMNS 86행(FcstNPrice 61 + Save All 25) / MEASURE 22행 |
| Project 셀 | 81 계열 신규행에서 **더블클릭 시 Project 검색 모달** 오픈 → 선택값이 셀에 반영 |

## 생성 근거

`_artifacts/_diagnostics/build_dmf0082_cloud_20260814.py` (사내 live 실측 — 문서·기억 기반 추정 없음)
+ `_dmf0082_pkg_finalize.py`(공용 FE·PRECHECK·VERIFY). 델타 서베이 = `_dmf0082_delta_survey.py`(2부).
사내 백업 = `_artifacts/_apply_corporate/BACKUP_DMF0082_test4142_20260814.json`.
