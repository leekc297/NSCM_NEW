# __grid-combos__.md — MktFcst(DMF0003) 그리드 콤보 전수 정리

> 기준 시점: 2026-08-12 (worktree 현재 상태) · 대상: `components/MktFcstGrid.tsx`, `mkt-fcst.constants.ts`
> 목적: 그리드 셀 콤보(dropdown)의 데이터 소스 / 편집 진입 스왑 / 편집 종료 원복 / 연쇄 클리어를 한 문서에서 추적한다.
> 관련: [__asis-mapping__.md](__asis-mapping__.md) (E04-3 spdMain_ComboSelChange, CD-02/CD-10/CE-02/CE-04/CG-05/CG-06)

---

## 0. 한눈에 보기 — 살아있는 콤보 전수

| # | comboId | 호출 계층 | 파라미터 | 용도 | 정의 위치 |
|---|---|---|---|---|---|
| 1 | admin `cellCboDataTp` 전부 (`MyDivision`, `EndCustomer`, `ScmSitebyEndCustomer40`, `Incoterms`, `FcstType`, `CustomsHandbook`, `Measure` …) | 조회 표시 | `mnuId` | 코드→명칭 표시 dataMap | [MktFcstGrid.tsx:261~285](components/MktFcstGrid.tsx#L261-L285) |
| 2 | `MktFcstEditMeasure` | 편집 후보 | `divisionId` | MEASURE 편집 드롭다운 | [constants.ts:352~356](mkt-fcst.constants.ts#L352-L356) |
| 3 | `IncotermsEdit` | 편집 후보 | 없음 | INCOTERMS 편집 드롭다운 | 동일 |
| 4 | `FcstTypeEditMode` | 편집 후보 | 없음 (`wsOnly`) | W/S Planner 전용 FCST_TYPE | 동일 |
| 5 | `FcstTypeWs` | 판정 보조 | 없음 | W/S 계열 FCST Type CODE Set | [MktFcstGrid.tsx:343~365](components/MktFcstGrid.tsx#L343-L365) |
| 6 | `AS_FROM_SITE` | 판정 보조 | `param1`(division) | AS(비축)향 사이트 **NAME** Set | 동일 |
| 7 | `AsIncotermsEdit` | 판정 보조 + 스왑 | `divisionId` | AS향 행 INCOTERMS 스왑 | 동일 |
| 8 | `PlantSiteByItem` | 행 단위 즉석 | `divisionId`, `projectCode`, `itemId` | PLANT_SITE_ID 행별 후보 | [MktFcstGrid.tsx:387~406](components/MktFcstGrid.tsx#L387-L406) |

1번만 컬럼 메타 기반(가변)이고, 2~8번은 코드에 고정되어 있습니다.

---

## 1. 데이터 소스 4계층

### 1-1. 조회 표시용 `dataMaps` — [MktFcstGrid.tsx:261~299](components/MktFcstGrid.tsx#L261-L299)

```ts
comboColumns = visibleColumns.filter(c => c._ctrlType === 'FPComboBox' && !!c._comboKey)
useTabComboQueries({ filters: comboColumns.map(c => ({ comboId: c._comboKey, mnuId: `'DMF0003'` })) })
dataMaps[c.binding] = rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null
```

| 항목 | 내용 |
|---|---|
| 대상 결정 | 하드코딩 아님. admin `SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`(`_comboKey`) 보유 컬럼 전부 |
| fallback | admin 미등록 시 [MAIN_COLUMNS](mkt-fcst.constants.ts#L96-L206) 정의 사용 |
| quoting | `mnuId` 를 `'DMF0003'` 형태로 **따옴표 포함** 전달. BE `makeComboQuery` 가 값을 raw 치환하므로 필수 |
| rebuild 조건 | `comboSig` = `comboId#rowCount` 조합이 바뀔 때만 |
| 0행 처리 | `dataMap = null` → 코드 원문 표시 |
| ref 미러 | `comboRowsRef`(원본 rows) / `dataMapsRef`(원복용) |

`mnuId` quoting 은 회귀 방어입니다. 2026-07-20 에 이걸 빼고 호출해서 `Measure` 콤보 SQL(`WHERE A.PROGRAM_ID = @mnuId`)이 `''` 로 치환 → 23행이 0행 → 그리드가 measure 코드를 그대로 표시한 사고가 있었습니다. `@mnuId` 를 안 쓰는 콤보는 잉여 파라미터를 무시하므로 전 컬럼 일괄 전달이 안전합니다.

### 1-2. 편집 후보용 `editDataMaps` — [MktFcstGrid.tsx:301~334](components/MktFcstGrid.tsx#L301-L334)

`GRID_EDIT_COMBO` 3종을 화면 진입 시 1회 조회합니다.

| binding | comboId | 파라미터 | 게이트 | 성격 |
|---|---|---|---|---|
| `MEASURE` | `MktFcstEditMeasure` | `divisionId: "'82'"` | — | VALID + TMM 제외 (82 기준 7종) |
| `INCOTERMS` | `IncotermsEdit` | 없음 | — | `VALID_YN='Y'` + `ATTRIBUTE2='Y'` |
| `FCST_TYPE` | `FcstTypeEditMode` | 없음 | `wsOnly` | W/S Planner 전용 EDIT_MODE 6종 |

- `editComboRowsRef` 에 **원본 rows** 도 별도 보관합니다. MEASURE·FCST_TYPE 분기 필터가 rows 를 다시 걸러 `new DataMap()` 을 만들기 때문입니다.
- `divisionParam: true` 는 `'값'` quoting 규약을 따릅니다(1-1 과 동일 이유).
- 조회 표시 dataMap 과 **분리**된 이유: AS-IS 가 조회 목록(전체)과 편집 목록(유효분)을 이원화해 두었기 때문입니다. 그래서 편집이 끝나면 반드시 원복해야 합니다(3장 참조).

### 1-3. W/S·AS 판정 보조 3종 — [MktFcstGrid.tsx:343~379](components/MktFcstGrid.tsx#L343-L379)

콤보로 조회하지만 **드롭다운에 직접 쓰지 않고 판정 자료로만** 씁니다.

| comboId | 파라미터 | 산출물 | 키 | 소비 지점 |
|---|---|---|---|---|
| `FcstTypeWs` | 없음 | `wsFcstTypeSetRef` | `CODE` | `isAsFromSiteEditable`, CE-04 클리어 |
| `AS_FROM_SITE` | `param1: "'82'"` | `asSiteNamesRef` | **`NAME`** | AS향 행 판정 (INCOTERMS 스왑 / MEASURE 분기 / CE-02 / CE-04) |
| `AsIncotermsEdit` | `divisionId: "'82'"` | `asIncotermsMapRef` | `CODE`→`NAME` DataMap | INCOTERMS 스왑 (CD-02) |

`AS_FROM_SITE` 만 `CODE` 가 아니라 **`NAME`** 을 키로 씁니다. AS-IS `dtAsSalesSite.Select("Name = …")` 를 1:1 이식한 결과이고, 행의 `SCM_SITE_ID` 값과 직접 비교합니다. 1-1/1-2 와 규약이 다르므로 수정 시 주의가 필요합니다.

`isAsFromSiteEditable(row, isInsert)` 판정 순서 — 하나라도 실패하면 `false`:

| 순서 | 조건 | 근거 |
|---|---|---|
| 1 | Insert 행 | #128~130 |
| 2 | `FCST_TYPE` ∈ `wsFcstTypeSetRef` | #128~130 |
| 3 | `SCM_SITE_ID` 입력됨 | 통합테스트 1st No.56-① |
| 4 | 해당 사이트가 AS향 **아님** | CE-02 |

2026-08-14 요구로 **W/S Planner 권한 축을 제거**했습니다(원래 순서 2). AS-IS 는 W/S 단독 조건이었지만 컬럼 자체는 `GET_SPREAD_TITLE p_type='LOAD'` 가 DM Planner·DM ADMIN 에게도 자동 추가하기 때문에, 권한 축을 두면 "컬럼은 보이는데 항상 잠긴" 상태가 됩니다. 이제 권한과 무관하게 행 조건만으로 판정합니다.

저장 검증 `MSG00476`([MktFcst.tsx](MktFcst.tsx)) 의 W/S 축도 같은 날 함께 제거했습니다. 두 게이트는 축이 일치해야 합니다 — 입력만 열고 필수 검사를 W/S 로 남기면 비 W/S 사용자가 빈값으로 저장하고, 반대면 채울 수 없는 값을 요구하게 됩니다. 남은 조건은 `81*`/`82` + 고객향 + `FCST_TYPE` ∈ W/S 4종 + 빈값입니다.

### 1-4. 행 단위 즉석 조회 `PlantSiteByItem` — [MktFcstGrid.tsx:387~406](components/MktFcstGrid.tsx#L387-L406)

`PLANT_SITE_ID` 만 이 방식입니다. react-query 를 거치지 않고 `apiClient.getCombo` 를 직접 호출합니다.

| 항목 | 내용 |
|---|---|
| division 게이트 | `division.startsWith('81')` 아니면 **아무 동작 없음** (AS-IS .cs L4152·4161) |
| 파라미터 | `divisionId`, `projectCode`, `itemId` — 전부 `q()` 로 `'값'` quoting |
| 캐시 | `WeakMap<row object, rows>` — 행 객체가 키. 행이 재생성되면(재조회) 캐시 전체 무효 |
| 트리거 | `PROJECT_CODE` / `ITEM_ID` 값이 **실제로 변한** 경우만 ([:1151~1153](components/MktFcstGrid.tsx#L1151-L1153)) |
| 실패 처리 | 캐시 미갱신 → 표준 콤보 유지 (무증상 폴백 금지 규약에 따른 의도된 동작) |
| 소비 | `beginningEdit` 의 `PLANT_SITE_ID` 분기 |

### 1-5. (참고) 공용 DataGrid 자동 배선 — 사실상 5번째 경로

[MktFcstGrid.tsx:529~543](components/MktFcstGrid.tsx#L529-L543) 에서 공용 `DataGrid` 에 `cellCtrlObjTpCd`(=`_ctrlType`) / `cellCboDataTp`(=`_comboKey`) / `inputTpCd` 를 넘깁니다. wrapper 는 이 메타로 **자체적으로** 콤보를 조회해 `col.dataMap` 을 붙입니다.

- queryKey 가 1-1 과 같아 react-query 캐시로 네트워크 중복은 없습니다.
- 다만 wrapper 의 `columnGroups` 재적용이 `col.dataMap` 을 **덮어씁니다**. 그래서 [:1431~1436](components/MktFcstGrid.tsx#L1431-L1436) `updatedLayout` 핸들러가 매 레이아웃마다 dataMap 을 재부착합니다.
- 붙여넣기 후에도 같은 재부착을 합니다 ([:1348~1359](components/MktFcstGrid.tsx#L1348-L1359) — `SCM_SITE_ID`/`SCM_SITE_ID40` 붙여넣기 시).

---

## 2. 컬럼별 배선

| binding | 조회 dataMap (comboId) | 편집 시 스왑 대상 | cascade 필터 | 변경 시 clear | 편집 종료 원복 |
|---|---|---|---|---|---|
| `DIVISION_ID` | `MyDivision` | 없음 (조회 dataMap) | 없음 | — | 해당 없음 |
| `END_CUSTOMER` | `EndCustomer` | cascade 필터 결과 | `DIVISION_ID` | → `SCM_SITE_ID` | O |
| `SCM_SITE_ID` | `ScmSitebyEndCustomer40`(fallback) | cascade 필터 결과 | `DIVISION_ID`, `END_CUSTOMER` | → `MEASURE`/`AS_FROM_SITE` (CE-04) | O |
| `END_CUSTOMER40` | admin 등록값 | cascade 필터 결과 | `DIVISION_ID` | → `SCM_SITE_ID40` | O |
| `SCM_SITE_ID40` | admin 등록값 | cascade 필터 결과 | `DIVISION_ID`, `END_CUSTOMER40`→`END_CUSTOMER` | — | O |
| `MEASURE` | `Measure` | `MktFcstEditMeasure` + W/S 3분기 | 없음 | → Model 5컬럼 (CG-06) | O |
| `INCOTERMS` | `Incoterms` | AS향 행 → `AsIncotermsEdit`, 그 외 → `IncotermsEdit` | 없음 | — | O |
| `FCST_TYPE` | `FcstType` | 82 → WS/WSF 제거, W/S → `FcstTypeEditMode` | 없음 | → `AS_FROM_SITE` (CE-04) | O |
| `DOM_EXP` | `CustomsHandbook` | 없음 (조회 dataMap) | 없음 | — | 해당 없음 |
| `PLANT_SITE_ID` | admin 등록값 | `PlantSiteByItem` 행별 캐시 | 없음 | — | **X (갭 G-1)** |
| `AS_FROM_SITE` | admin 등록값 | 스왑 없음. 편집 가능 여부만 판정 | 없음 | — | 해당 없음 |
| `PROJECT_CODE` / `ITEM_ID` | 콤보 아님 (`FPModal`) | 팝업 | — | → `PLANT_SITE_ID` 후보 재조회 | 해당 없음 |
| `ITEM_NAME` / `NICK_NAME` / `ITEM_TYPE` | 콤보 아님 (`FPText`/`S`) | 편집 불가 | — | MEASURE 변경 시 clear 대상 | 해당 없음 |

cascade 규칙 원문 — [constants.ts:330~350](mkt-fcst.constants.ts#L330-L350):

| binding | 행 키 → 콤보 키 |
|---|---|
| `END_CUSTOMER` | `DIVISION_ID` → `DIVISION_ID` |
| `SCM_SITE_ID` | `DIVISION_ID` → `DIVISION_ID`, `END_CUSTOMER` → `END_CUSTOMER` |
| `END_CUSTOMER40` | `DIVISION_ID` → `DIVISION_ID` |
| `SCM_SITE_ID40` | `DIVISION_ID` → `DIVISION_ID`, `END_CUSTOMER40` → `END_CUSTOMER` |

판정식은 **관대 통과**입니다:

```ts
return !rv || rv === 'ALL' || !cv || rv === cv;   // rv=행 값, cv=콤보 값
```

행 값이 공란/`ALL` 이면 전체 통과이고, **콤보 값이 공란이어도 통과**합니다. 후자가 갭 G-3 입니다. 필터 후에는 `DIVISION_ID|CODE` 복합 키로 dedup 해 division 컨텍스트를 유지합니다.

---

## 3. 편집 진입 시 스왑 결정 — [MktFcstGrid.tsx:819~967](components/MktFcstGrid.tsx#L819-L967)

**단일 통과 체인입니다. 먼저 걸린 분기에서 `return` 하므로 뒤 분기는 실행되지 않습니다.**

전제 게이트 ([:837~845](components/MktFcstGrid.tsx#L837-L845)) — 하나라도 걸리면 편집 자체가 취소됩니다:

- Insert 행(`CRUD_TYPE === 'I'`) 아님 → `e.cancel`
- `_ctrlType === 'FPModal'` → `e.cancel` (팝업은 더블클릭 전용)
- `_inputEditType === 'S'` → `e.cancel`

| # | 조건 | 동작 | 근거 |
|---|---|---|---|
| 0 | `binding === 'AS_FROM_SITE'` | 스왑 없음. `isAsFromSiteEditable` false 면 `e.cancel`. **게이트보다 먼저** 판정 | #128~130, CE-02, No.56-① |
| — | 전제 게이트 (위 3항목) | `e.cancel` + return | — |
| — | `editingCellRef` 기록 (`binding`, `oldVal`) | 4장 변경 감지의 원천 | — |
| 1 | `INCOTERMS` + 행 사이트가 AS향 + `asIncotermsMapRef` 존재 | `col.dataMap = asIncotermsMapRef` | CD-02 |
| 2 | `PLANT_SITE_ID` + WeakMap 캐시 히트 | `col.dataMap = new DataMap(캐시 rows)` | CD-10 |
| 3 | `FCST_TYPE` + `division === '82'` | (W/S면 편집콤보, 아니면 조회콤보) rows 에서 `WS`,`WSF` 제거 후 스왑 | 통합테스트 1st No.54 |
| 4 | `GRID_EDIT_COMBO[binding]` 존재 + `wsOnly` 게이트 통과 + dataMap 존재 | `MEASURE` 는 아래 3분기 선적용, 그 외 `editDataMapsRef[binding]` | E20260402-001736 |
| 5 | `_ctrlType === 'FPComboBox'` + `GRID_CASCADE_FILTERS[binding]` | 조회 rows 를 행 값으로 필터 + dedup 후 스왑 | hook #59 §5-G |
| — | 동적 컬럼 `/^[MWD]_/` | `e.cancel = !evalDynCell(...).editable` | 보강스펙 §1 |

**MEASURE 편집 후보 3분기** ([:914~929](components/MktFcstGrid.tsx#L914-L929)):

| 분기 | 조건 | 후보 |
|---|---|---|
| 1-a | 행 `SCM_SITE_ID` 확정 + AS(비축)향 | `AS_In_Req` **단독** |
| 1-b | 행 `SCM_SITE_ID` 확정 + 고객향 | `MKT_FCST_RP` **단독** |
| 1-c | 사이트 미정 + 비W/S Planner + division 81*/82 | 전체에서 `AS_In_Req` **제거** |

세 분기 모두 후보가 0건이면 스왑을 생략합니다(표준 편집 콤보 유지 = 회귀 0). `FCST_TYPE` 82 분기, `INCOTERMS` AS 분기도 같은 0건 방어를 갖습니다.

주의: 1-a/1-b 는 **후보를 1종으로 고정**하는 강한 필터입니다. 2026-08-10 에 한 번 걷어냈다고 기록된 필터가 2026-08-12 CD-02/CE-02 작업으로 되살아난 지점이므로, 업무 요구가 어느 쪽인지 확인이 필요합니다.

---

## 4. 편집 종료 시 원복 + 연쇄 — [MktFcstGrid.tsx:1045~1156](components/MktFcstGrid.tsx#L1045-L1156)

### 4-1. dataMap 원복 — [:1051~1058](components/MktFcstGrid.tsx#L1051-L1058)

```ts
if (GRID_CASCADE_FILTERS[binding] && dataMapsRef.current[binding]) col.dataMap = dataMapsRef.current[binding];
if (GRID_EDIT_COMBO[binding]    && dataMapsRef.current[binding]) col.dataMap = dataMapsRef.current[binding];
```

| 원복됨 | 원복 안 됨 |
|---|---|
| `MEASURE`, `INCOTERMS`(AS 스왑 포함), `FCST_TYPE`(82 스왑 포함), `END_CUSTOMER`, `SCM_SITE_ID`, `END_CUSTOMER40`, `SCM_SITE_ID40` | **`PLANT_SITE_ID`** — 두 테이블 어디에도 키가 없음 (갭 G-1) |

편집 취소(ESC)도 `cellEditEnded` 를 타므로 함께 커버됩니다.

### 4-2. 값 변경 연쇄 — 전부 같은 `INSERT_GROUP_ID` 형제 행 일괄

`changed` 판정은 `editingCellRef.oldVal` 과 새 값의 문자열 비교입니다. **실제로 변한 경우만** 동작하므로 무변경 편집 진입/취소로는 클리어가 발생하지 않습니다.

| 순서 | 트리거 | 결과 | 근거 |
|---|---|---|---|
| 1 | 정적 컬럼 아무거나 | 같은 그룹 형제 행에 같은 값 복사 | Phase 2b |
| 2 | `GRID_CASCADE_CLEAR[binding]` | 하위 컬럼 clear (`END_CUSTOMER`→`SCM_SITE_ID`, `END_CUSTOMER40`→`SCM_SITE_ID40`) | hook #59 §5-G |
| 3 | `MEASURE` (값 ∉ `MEASURE_MODEL_KEEP`) | `ITEM_ID`,`ITEM_ID40`,`ITEM_NAME`,`ITEM_TYPE`,`NICK_NAME` clear | CG-06 |
| 4 | `SCM_SITE_ID` (AS향 전환) | `MEASURE` clear | CE-04 (.cs L3478) |
| 5 | `SCM_SITE_ID`/`FCST_TYPE` (AS향 or 비W/S FCST Type, 81*/82) | `AS_FROM_SITE` clear | CE-04 (.cs L3506·3587·3597) |
| 6 | 정적 컬럼 아무거나 | 동적 수량(`dynBindings`) **전부 null** | CG-05 (.cs L5319~5379) |
| 7 | `PROJECT_CODE`/`ITEM_ID` | `applyPlantSites` 재조회 | CD-10 |
| — | 마무리 | `editingCellRef = null`, `invalidate(true)` | — |

`MEASURE_MODEL_KEEP = ['AS_In_Req', 'BNPIn']` 입니다 — 이 두 measure 는 model 을 유지합니다.

---

## 5. 구조 규약 (수정 전 반드시 확인)

| 규약 | 내용 | 위반 시 증상 |
|---|---|---|
| 콤보 편집은 **Insert 행 전용** | `beginningEdit` 의 `!isInsert → e.cancel`. 조회된 행의 정적 콤보 셀은 편집 불가 | — |
| `col.dataMap` 은 **컬럼 단위** | Wijmo 는 행별 dataMap 을 지원하지 않음. 행 컨텍스트 스왑은 그 컬럼 전체에 적용됨 | 드롭다운 열린 동안 **조회 행 표시명까지** 편집 후보 기준으로 렌더 (갭 G-2) |
| 원복은 **편집 종료 후** | `cellEditEnded` 는 편집이 끝나야 실행 | 드롭다운 열린 동안의 표시 붕괴는 원복으로 못 막음 → `formatItem` 단계 보정 필요 |
| 콤보 파라미터는 FE 에서 quoting | BE `makeComboQuery` 가 값을 raw 치환. 세션 `sesUserId`/`sesLangCd` 만 BE 가 따옴표 포함 주입 | 숫자 비교 ORA-01722 또는 `''` 치환 0행 |
| `dataMap` 0행이면 `null` | 스왑도 0건이면 생략 | 코드 원문 표시 |

---

## 6. 알려진 갭

| ID | 갭 | 위치 | 증상 | 원인 |
|---|---|---|---|---|
| G-1 | `PLANT_SITE_ID` dataMap 원복 누락 | [:1051~1058](components/MktFcstGrid.tsx#L1051-L1058) | 한 행에서 편집한 뒤 다른 행의 Plant Site 코드가 명칭으로 변환되지 않음 | `GRID_CASCADE_FILTERS`/`GRID_EDIT_COMBO` 둘 다에 키 없음 |
| G-2 | 편집 중 조회 행 Measure 명칭 사라짐 | `formatItem` 정적 분기 | Insert 행 Measure 드롭다운을 여는 동안 기존 조회 행 Measure 가 빈칸/코드로 보임 | 컬럼 단위 `col.dataMap` + 구 계보의 `formatItem` 표시명 재기입 블록 미이관 (2026-08-10 사용자 요구) |
| G-3 | `SCM_SITE_ID` cascade 과잉 통과 | [:937~943](components/MktFcstGrid.tsx#L937-L943) | `END_CUSTOMER` 가 공란인 사이트(`EG01-82-AS` 등)가 고객 선택 후에도 후보에 남음 | 관대 통과 `!cv` — 구 계보의 `strict: true` 미이관 |
| G-4 | `comboSig` 에 division 없음 | [:274~276](components/MktFcstGrid.tsx#L274-L276) | division 전환 후 콤보 행 수가 같으면 이전 division dataMap 유지 | 구 계보의 `division\|` prefix 미이관 |
| G-5 | 권한 반영 편집 콤보 없음 | `GRID_EDIT_COMBO` | 권한 밖 팀/고객/사이트가 후보에 노출 가능 | `sesUserId` 파라미터 콤보 5종이 dead 파일에만 존재 (7장) |
| G-6 | `TEAM_ID` → `DEPT_ID` 2단 cascade 없음 | `GRID_CASCADE_FILTERS` | `END_CUSTOMER` 후보가 팀으로 좁혀지지 않음 | 동일 |

---

## 7. live(`constants.ts`) vs dead(`utils/mkt-fcst.gridCombos.ts`) 대비

`utils/mkt-fcst.gridCombos.ts`(390줄)는 **현재 어디서도 쓰이지 않습니다.** `utils/comboDebug.ts:9` 만 import 하고, `comboDebug.ts` 는 아무도 import 하지 않습니다(합계 484줄 dead).

| 항목 | live `constants.ts` | dead `gridCombos.ts` | 판정 |
|---|---|---|---|
| `GRID_CASCADE_CLEAR` | 동일 | 동일 | 차이 없음 |
| `END_CUSTOMER` cascade | `DIVISION_ID` 1단 | `DIVISION_ID` + `TEAM_ID`→`DEPT_ID` | 갭 G-6 |
| `SCM_SITE_ID` cascade | 관대 통과 | `END_CUSTOMER` 규칙에 `strict: true` | 갭 G-3 |
| 편집 콤보 | 3종 (권한 무관) | 5종 (`sesUserIdParam`) — `TeambyDivisionAuth`, `EndCustomerByDivisionDeptAuth`, `EndCustomerByDivision40`, `SiteByEndCustomerAuth`, `FCST_TYPE`(`editModeYn='Y'`) | 갭 G-5 |
| `ROW_PARAM_EDIT_COMBO` (`AS_INCOTERMS`, 행 Div `MktFcstEditMeasure`) | 하드코딩 분기로 대체 | 테이블로 존재 | 기능상 커버됨 |
| 헬퍼 (`buildEditComboFilter`, `filterMeasureEditRows`, `rowSalesSite` …) | 없음 (인라인) | 있음 | 참고용 |

---

## 8. fallback `MAIN_COLUMNS` 주의사항 — [constants.ts:96~206](mkt-fcst.constants.ts#L96-L206)

admin `SCM_MST_SHEET_COLUMNS` 미등록 시에만 쓰이는 fallback 12종입니다. 정본은 admin 동적 fetch(`fetchStaticColumns`)입니다.

| 주의 | 내용 |
|---|---|
| `MEASURE` 가 `FPText` + `'S'` + `_comboKey` 없음 | fallback 상태에서는 **Measure 편집 자체가 불가**하고 조회 dataMap 도 없습니다. 3장의 MEASURE 편집 경로는 admin 이 MEASURE 를 콤보(`inputTpCd != 'S'`)로 등록한 것을 전제로 합니다 |
| `SCM_SITE_ID` 의 `_comboKey` = `ScmSitebyEndCustomer40` | 40 전용 이름이 81/82 컬럼에 붙어 있습니다. admin 등록값이 정본이라 실사용에서는 드러나지 않지만 fallback 진입 시 후보가 어긋날 수 있습니다 |
| `END_CUSTOMER40`/`SCM_SITE_ID40`/`PLANT_SITE_ID`/`AS_FROM_SITE` 미정의 | fallback 에는 없습니다. 전부 admin 메타에만 존재합니다 |

`_inputEditType` 범례: `S`=읽기전용 / `M`=필수 / `O`=선택 / `IM`=신규 필수 / `IO`=신규 선택
