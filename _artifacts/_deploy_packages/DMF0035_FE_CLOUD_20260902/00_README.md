# DMF0035 FE 클라우드 이관 패키지 — 2026-09-02 (수정분만)

> 대상 화면: **DMF0035 Demand Plan Waterfall** (MKT FCST / SALES PLAN / BIZ PLAN 통합)
> 성격: **FE 전용**. DB/메타 변경 **없음** — SQL·메타 INSERT 동봉분 0건.
> 범위: 사용자 지시 2026-09-02 "**수정분만 취합**" — 오늘 변경된 4파일만 담았다(폴더 전체 아님).

---

## 1. 동봉 파일 (5)

저장소 실경로 구조 그대로 보존 (룰 22 §1.8 — 축약·평탄화 ⛔).

| # | 경로 | 성격 |
|---:|---|---|
| 1 | `nscm-fe/features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx` | 런타임 |
| 2 | `nscm-fe/features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.constants.ts` | 런타임 |
| 3 | `nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx` | 런타임 |
| 4 | `nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` | 런타임 (**공용 컴포넌트**) |
| 5 | `nscm-fe/features/report/src/pages/demand-plan-waterfall/__asis-mapping__.md` | 문서 (대사표 — 런타임 무관) |

⚠️ **4번은 `packages/shared` 공용 파일**이다. `exportExcel` 호출 지점은 전 저장소에서 DMF0035
(`DemandPlanWaterfall.tsx:251`) **단독**임을 features+apps+shared 전수 grep 으로 확인했으므로
타 화면 회귀는 없다. 그래도 배포 시 shared 패키지가 함께 빌드되는지 확인할 것.

---

## 2. 수정 내용 (3건)

### (A) 종속메저가 Measure 모달 저장 후 사라짐 — `REQ:CHAT-20260902-W46`

**증상** (사용자 신고): MKT FCST TYPE · DIVISION 81 에서 최초 조회 시엔 종속메저가 나오지만,
MEASURE 모달에서 저장하면 GRID 에서 종속메저가 사라진다. **선택을 바꾸지 않고 OK 만 눌러도 재현.**

**원인**: FE 가 `vis.includes(String(r.MEASURE))` 로 행을 걸렀는데, 메인 SP 가 붙이는 종속메저는
모달 목록의 원천(`SCM_MST_SHEET_MEASURE` `VALID_YN='Y'`)에 **없거나 `VALID_YN='N'`** 이라 전량 탈락했다.

사내 실측 (div 81, `PR_GET_SHEET_MEASURE_LIST` 20건 vs SP 산출 종속 10건 — 교집합 0):

| SP 위치 | 조건 | 자동 추가되는 MEASURE |
|---|---|---|
| `PKG_DMF0035` L433~481 | `CUST_FCST` 보유 | `Immidiate` `Planning_Forecast` `Commercial_Agreement` `Firm_Temp` `Manumacturing_Material_Temp` `Material_Temp` `Backorder` `CUST_FCST_EDI` |
| `PKG_DMF0035` L489~522 | 〃 | `DM_MST_CUSTOMER_FCST.MEASURE` → `Customer FCST` / `Cutomer FCST` |

**AS-IS 근거**: `DMF0035_MktFcstWaterfall.cs:1809` 은 팝업 OK 시 `InitSpread()` 뿐이고 **행 필터가 없다.**
팝업은 `DM0002_TitleSetForm_Popup.cs:425 SaveTitleSet()` → `SCM0002_SET_TITLESET_POPUP` 으로 서버 저장하고,
다음 조회에서 SP 가 **선택+종속을 함께** 내려주는 계약이다.

**보완**:
1. 모달 OK = **titleset 'M' 서버 저장** (`saveTitleSet`) + 그리드 비움 + 메저 메타 재fetch → Search 로 재조회
   - 저장 엔드포인트 = 공용 `POST /admin/menu/{mnuId}/titleset` (**BE 고정 매핑**).
     `MenuServiceImpl.saveTitleSet` javadoc 대로 `SCM_ADM_MNU_BTN_MPG_M` 등록을 요구하지 않는다
     → **메타 배선 작업 불요**(화면별 `call-proc` 경로였다면 403).
2. `GUBUN_META.titleSetSheetNm` 신설 — SP 가 읽는 titleset 시트명은 **메타 시트명과 다른 세 번째 축**이다.

| GUBUN | PROGRAM_ID | titleset SHEET_NAME | 메타 SHEET_NAME |
|---|---|---|---|
| MKT | DMF0035 | `mktFcstWaterfall` (`PKG_DMF0035` L112) | `Mkt Fcst Waterfall` (L113) |
| SALES | DMF0022 | `salesPlanWaterfall` (`PKG_DMF0022` L628) | `Sales Plan Waterfall` (L629) |
| BIZ | DMF0051 | `Biz Plan Waterfall` (`PKG_DMF0051` L532) | 동일 |

⚠️ BIZ 는 `SHEETS` enum(`bizPlanWaterfall`)과 **다르다** — enum 으로 대체 ⛔.
⚠️ `menuId` 는 GUBUN 별 **종속 PROGRAM_ID**(DMF0035/DMF0022/DMF0051). BE 가 path `mnuId` 를 그대로
`P_PROGRAM_ID` 로 넘기므로 `MENU_ID` 고정 전달 시 SALES/BIZ 가 저장은 되고 조회에 안 잡힌다.

### (B) 종속메저는 메저필터 적용 대상에서 제외 — `[E20260902-MEASFILTEREXEMPT]`

사용자 확정 2026-09-02. (A) 에서 클라이언트 행 필터를 **전면 제거**했더니 건수 표시가 선택에
반응하지 않아 `REQ:CHAT-20260831-W44`(메저 5개 선택했는데 건수 그대로)가 후퇴한다.
전면 적용하면 (A) 의 증상이 재발한다. ⇒ **면제 규칙**으로 확정:

- 모달 목록(`staticMeasures` = `SHEET_MEASURE VALID_YN='Y'`)에 **있는** 메저 → 선택 여부대로 필터
- 모달 목록에 **없는** 메저(= SP 가 붙인 종속/파생) → **필터 면제, 항상 표시**

판정 원천이 모달에 넘기는 바로 그 목록이라 모달과 축이 어긋날 수 없다.
`staticMeasures` 가 비면(fetch 실패) 전 메저가 면제로 떨어져 필터가 no-op — 메타 실패로 행이
사라지는 쪽보다 안전한 degrade(의도된 동작).

### (C) OLAP Excel Download 가 동적 컬럼만 받음 — `REQ:CHAT-20260902-W47`

**원인**: `exportExcel` 이 `{ includeColumnHeaders: true }` 만 전달.
- PivotGrid 는 **행 축 필드(`engine.rowFields`)를 rowHeaders 패널**에 렌더한다
  (`wijmo.olap` d.ts `showRowFieldHeaders` = "top-left panel").
- `IFlexGridXlsxOptions.includeRowHeaders` 기본값은 **false** (`wijmo.grid.xlsx` d.ts).
- ⇒ xlsx 에 `columnFields` 로 만든 **동적(기간) 컬럼만** 남고 `VERSION_NO`/`MEASURE`/`ITEM_ID` 등
  고정 행축 컬럼이 전량 누락.

**보완**: `includeRowHeaders: true` + `includeColumns: () => true`
(후자는 사용자 지시 "OLAP COLUMN **전체** 보이도록" — 기본 동작이 `visible === false` 컬럼을 빼므로
숨김 상태 열까지 강제 포함).

---

### (D) 조회건수 표기를 **피벗 후 건수**로 — `REQ:CHAT-20260902-W49` · `[E20260902-PIVOTCOUNT]`

**증상** (사용자 신고 2026-09-02): SALES PLAN TYPE · DIVISION 81 · `SP_W_20260828_V001` 조회에서
**UI 표기 1,150건** vs **Excel Download 1,144행**. 6건 불일치.

**원인**: 표기 축과 그리드 축이 서로 다른 것을 세고 있었다.

| | 무엇을 세는가 |
|---|---|
| 구 UI 표기 (`dataCount`/`rowCount`) | `visibleData.length` = **SP `O_RC1` 원천 행수** |
| 실제 그리드·Excel | `PivotEngine` 이 **`rowFields` 조합으로 그룹핑**한 결과 행수 |

`DemandPlanWaterfallGrid` 는 `unpivotWideRows(data, keyBindings = rowFields …)` 로 long 변환 후
`PivotEngine` 에 넘긴다. 따라서 **행 축(`rowFields`)에 없는 컬럼으로만 갈리는 원천 행들은 한 행으로 병합**되고,
표기 건수가 그리드 행수보다 많아진다. (양측 엑셀 실측: AS-IS 1,144 = TO-BE 1,144 로 **데이터는 일치**,
메저별 231/257/220/218/218 전부 동일 → 원천 6행이 피벗에서 병합된 것)

**보완**: `OlapPivotGrid` 에 `onPivotRowCountChange` 신설 — 그리드의 `updatedLayout`(행·열 재생성 완료)
시점에 **`grid.rows.length`** 를 통지한다. 페이지가 그 값을 `pivotRowCount` 로 받아
**SubTitle `dataCount` 와 OlapGridMeta `rowCount` 두 곳이 함께** 사용 → 표기 = 그리드 = Excel 로 3축 일치.

### ⛔ 쓰면 안 되는 값 2가지 (2026-09-02 클라우드 실측으로 **반증됨**)

| 후보 | 왜 안 되는가 |
|---|---|
| `data.length` / `visibleData.length` (구 구현) | 피벗과 무관한 **원천 행수**. 실측: Rows 를 `DIVISION`·`MEASURE` 2개로 줄여 **그리드가 5행**이 됐는데도 표기는 **1,150 유지** |
| `engine.pivotView.items.length` (1차 수정안) | 엔진 출력 뷰 항목 수이지 **그리드 행수가 아니다**. 실측: 뷰 **1,150** vs 그리드·Excel **1,144**. Subtotal 을 `None` 으로 바꿔도 1,150 유지 → 총계행 때문도 아님 |

⇒ **`grid.rows.length`** 만이 화면에 그려지는 행이자 `FlexGridXlsxConverter` 가 내보내는 집합과 동일하다.

- 트리거는 반드시 **`updatedLayout`**. `engine.updatedView` 시점엔 그리드가 아직 행을 다시 만들기 전이라 직전 행수를 집는다.
- 핸들러는 ref 로 최신화해 engine 구독을 재등록하지 않는다(구독 누수·중복 방지).
- 조회 전·초기화 직후(그리드 미마운트)는 통지가 없으므로 `data.length === 0` 이면 0 으로 되돌린다.
- ⚠ `REQ:CHAT-20260831-W44`(메저 선택에 건수 반응) 는 유지된다 — 두 표기가 여전히 같은 하나의 원천을 본다.

---

## 3. 검증 (2026-09-02 실측)

⚠️ **(D) 는 정적검증 미수행** — 사용자 지시 2026-09-02 "별도 요청 있을 때까지 type-check / lint 수행하지 마세요".
아래 PASS 기록은 **(A)(B)(C) 까지 반영된 시점**의 것이며, (D) 반영분은 아직 검증되지 않았다. 배포 전 실행 필요.

| 축 | 결과 |
|---|---|
| type-check | **PASS 3/3** (`@foundation` / `@shared` / `@report`) — (A)(B)(C) 시점 |
| lint | `@report` **오류 0** · `@shared` 오류 0 (경고 27건 전부 기존분) — (A)(B)(C) 시점 |
| 영향 범위 | `exportExcel` 호출 지점 = `DemandPlanWaterfall.tsx:251` **단독** (전수 grep) |
| titleset 저장 E2E | 합성 사용자 비파괴 실측 — 저장 2행(`SHEET_NAME=mktFcstWaterfall`) → BASE `[CUST_FCST, MKT_FCST]` → 종속 DEP-A 8 + DEP-B 2 산출 확인 → 정리 후 **잔여 0행**(원장 무오염) |
| MSG | `MSG00618` 기존 코드 재사용 (KO/EN/CN 3개 locales 실재 확인) — **신규 채번 0** |

### ⛔ 미검증 (배포 전 확인 필요)

- **실화면 확인 미완료.** (A)(B)(C) 모두 사용자 실화면 검증 전이다.
- 특히 (C) 는 xlsx 산출물을 열어 고정 컬럼(Version/Measure/Item …)이 실제로 포함되는지 **육안 확인**이 필요하다.

---

## 4. 배포 절차

1. 위 4파일을 **저장소 동일 경로**에 덮어쓴다.
2. FE 빌드 — `packages/shared` 가 함께 빌드되는지 확인(3번 파일이 shared 소속).
3. 화면 진입 → MKT FCST TYPE · DIV 81 → Measure 모달에서 `CUST_FCST` 포함 선택 → **OK**(그리드 비워짐)
   → **Search** → 종속메저(`Immidiate`/`Backorder`/`Customer FCST` 등)가 선택 메저와 함께 나오는지 확인.
4. 동일 화면에서 Excel 다운로드 → 고정 컬럼 포함 여부 확인.

### ⚠️ 이관 단위 주의 (hook #148)

FE 신규 화면은 `pages/<화면>/index.ts` 가 `viewRegistry` glob 의 **유일한 등록 키**라 폴더 전체를
옮겨야 하지만, **DMF0035 는 클라우드에 이미 배포된 기존 화면**이므로 이번처럼 파일 단위 덮어쓰기가
성립한다. 만약 대상 환경에 DMF0035 폴더가 없다면 이 패키지로는 부족하다 —
`DMF0035_FE_CLOUD_20260831`(폴더 전체본)을 먼저 적용할 것.

---

## 5. DB / 메타

**없음.** 이번 보완은 FE 단독이다.
- titleset 저장은 기존 SP(`SCM0002_SET_TITLESET_POPUP`) + 기존 BE 고정 엔드포인트 재사용.
- `SCM_ADM_MNU_BTN_MPG_M` 배선 **불요**(§2-A 참조).
- 잔여(이번 범위 밖): BTN 권한 배선 `MEASURE_SELECT` 미등재 — 현재 무게이트 노출(사용자 지시 2026-08-31).
