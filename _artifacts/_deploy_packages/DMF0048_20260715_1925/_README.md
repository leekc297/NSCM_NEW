# DMF0048 (Sales Monitoring) — 이관 패키지 (2026-07-15 19:25)

> **폴더**: `_artifacts/_deploy_packages/DMF0048_20260715_1925/`
> **화면**: DMF0048 / Sales Monitoring (판매 모니터링) — `features/demand/src/pages/sales-monitoring`
> **이관 성격**: FE 결함 수정 (그리드 **MEASURE 컬럼 코드→명칭 미표시** 해소)
> **변경 파일**: 2 (공유 플랫폼 1 + 화면 1). SQL/메타/BE 변경 없음.

---

## 1. 이관 목적 (한 줄)

DMF0048 그리드에서 **MEASURE 컬럼이 코드(예: `MKT_FCST`)로만 표시**되고 명칭(예: `MKT FCST[P+P]`)이 나오지 않던 문제를, **공유 DataGrid 의 자동 콤보 dataMap 경로에 `@mnuId` 파라미터 전달 기능을 신설**하여 해소.

## 2. 증상 & 근본 원인 (실측 추적)

**증상**: UI Category Setup 에서 MEASURE 컬럼을 `FPComboBox` + 콤보 `Measure` 로 설정했고 콤보 데이터도 정상인데, 화면에는 measure **코드만** 노출.

**원인 2가지 (둘 다 수정)**:

1. **화면이 콤보 메타를 유실** — `SalesMonitoringGrid` 가 PIVOT/머지/다단헤더 처리를 위해 컬럼 설정을 자체 재구성(`mergedColumns` → `mainStaticColumns`)하면서, admin 메타의 `cellCtrlObjTpCd`(=`FPComboBox`) / `cellCboDataTp`(=`Measure`) 두 필드를 **DataGrid 로 전달하지 않음** → 공유 DataGrid 의 자동 콤보 필터가 MEASURE 를 "콤보 컬럼"으로 인식하지 못함.

2. **공유 DataGrid 가 `@mnuId` 를 안 넘김** — 설령 콤보로 인식돼도, DataGrid 의 자동 콤보 조회(`useTabComboQueries` → `apiClient.getCombo`)는 **`comboId` 만 전송**. 그런데 `Measure` 콤보 SQL 은 `WHERE A.PROGRAM_ID = @mnuId` 로 **`@mnuId` 가 필수**. 값이 안 채워져 `PROGRAM_ID = (빈값)` → **0 건** → 빈 dataMap → 코드 노출.
   - axios 인터셉터는 `X-Request-ID` 만 부착, menuId 헤더 주입 없음(확인).

**BE 동작 근거 (`admin/combo` 리졸버)**:
- `LookupServiceImpl.retrieveCombo` → `makeComboQuery(SQL_DTL_CTN, params)` = **raw 치환**. 문자열 리터럴은 **호출측이 따옴표로 감싸야** 함 (BE 는 `sesUserId` 를 `"'"+값+"'"` 로 직접 wrap).
- `MenuServiceImpl.resolveComboBoxDataMaps` 도 `mnuId`/`divisionId` 를 `"'"+값+"'"` 로 wrap 하여 전달.
- → FE 도 동일 규약: `@mnuId` 에 **`'DMF0048'`(따옴표 포함)** 를 넘겨야 `PROGRAM_ID = 'DMF0048'` 이 되어 조회됨. raw `DMF0048` 은 `PROGRAM_ID = DMF0048` → **ORA-00904**.

## 3. 변경 파일 상세

### 3-1. `packages/shared/src/components/organisms/data-grid/DataGrid.tsx` ⭐ 공유 플랫폼

자동 콤보(`cellCtrlObjTpCd=COMBO`) 조회에 **바인드 파라미터를 함께 전달**하는 `comboParams` 프롭 신설.

- **Props 신설**:
  ```ts
  /** 자동 콤보의 SQL 바인드 파라미터(@mnuId / @divisionId 등) 해소용 공통 파라미터.
   *  ⚠ BE makeComboQuery 는 raw 치환 → 문자열 리터럴 값은 작은따옴표로 감싸 전달 (예: { mnuId: "'DMF0048'" }).
   *  미지정 시 기존 동작 — 회귀 0. 미사용 콤보는 여분 파라미터를 무시(무해). */
  comboParams?: Record<string, string>;
  ```
- **구조분해**: `comboParams = {},` 추가.
- **콤보 조회 로직 변경** (`comboIds: string[]` → `comboFilters: ComboParam[]`):
  ```ts
  // BEFORE: comboId 만
  const comboIds = staticColumns.filter(...).map(c => String(c.cellCboDataTp));
  const comboQueries = useTabComboQueries({ filters: comboIds });

  // AFTER: comboId + comboParams(@mnuId 등)
  const comboFilters = staticColumns
    .filter(c => c.display && c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO && c.cellCboDataTp)
    .map(c => ({ comboId: String(c.cellCboDataTp), ...comboParams }));
  const comboQueries = useTabComboQueries({ filters: comboFilters });
  const comboQueryMap = Object.fromEntries(comboFilters.map((f, i) => [f.comboId, comboQueries[i]]));
  ```
  → `dataMap` lookup(`comboQueryMap[column.cellCboDataTp]`)은 comboId 키 유지로 **무변경**.

> ⚠ **공유 컴포넌트**이므로 **회귀 0** 보장: `comboParams` 미지정 화면은 기존과 완전히 동일하게 동작(comboId 만 전송). 지정 화면만 파라미터 콤보가 활성화됨.

### 3-2. `features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx`

(a) **admin 콤보 메타 2필드를 DataGrid 까지 승계**:
- import 에 `MENU_ID` 추가.
- `MergedColumnMeta` 인터페이스에 `cellCtrlObjTpCd?: CELL_CONTROL_TYPE` / `cellCboDataTp?: string` 필드 추가.
- `mergedColumns` — admin 분기: `col.cellCtrlObjTpCd ?? fb._ctrlType`, `col.cellCboDataTp ?? fb._comboKey` 승계 / fallback 분기: `c._ctrlType`, `c._comboKey` 승계.
- `mainStaticColumns` (DataGrid 전달용): 두 필드 포함.

(b) **`@mnuId` 파라미터 공급 (따옴표 포함)**:
  ```ts
  // 안정 참조 module const — 문자열 리터럴은 quote 필수 (BE resolveComboBoxDataMaps 와 동일 규약)
  const COMBO_PARAMS = { mnuId: `'${MENU_ID}'` };   // = { mnuId: "'DMF0048'" }
  ...
  <DataGrid ... comboParams={COMBO_PARAMS} ... />
  ```

## 4. 데이터 흐름 (수정 후)

```
UI Category Setup: MEASURE = FPComboBox + 콤보 'Measure'
  → /admin/menu/DMF0048/column 응답: cellCtrlObjTpCd='FPComboBox', cellCboDataTp='Measure'
  → SalesMonitoringGrid: 두 필드 승계 → mainStaticColumns
  → DataGrid: 콤보 컬럼 인식 + comboParams({ mnuId:"'DMF0048'" }) 병합
  → getCombo({ comboId:'Measure', mnuId:"'DMF0048'" })
  → admin/combo: WHERE PROGRAM_ID = 'DMF0048' AND VALID_YN='Y' → 코드/명칭 rows
  → dataMap 부착 → MEASURE 셀 코드→명칭 자동 표시 ✅
```

## 5. 검증

| 항목 | 결과 |
|---|---|
| type-check (features/demand) | ✅ 0 error |
| type-check (packages/shared) | ✅ 0 error |
| eslint | ⏳ **로컬 차단(클라우드 전용)** — 클라우드 lint 결과 회신 후 추가 fix |
| 화면 E2E | ⏳ 사용자 브라우저 검증 필요 (Vite HMR) |

## 6. 배포 순서 & 주의

1. **공유 `DataGrid.tsx` 먼저(또는 동시)** 반영 — `SalesMonitoringGrid` 가 `comboParams` 프롭에 의존.
2. 이후 `SalesMonitoringGrid.tsx` 반영.
3. **클라우드 lint** 통과 확인 (로컬 미실행).
4. ⚠ `DataGrid` 는 전 화면 공용 — comboParams 미지정 화면 무영향이나, **회귀 스모크**로 대표 그리드 몇 개 조회 확인 권장.

## 7. 참고 — measure 실데이터 (SCM_MST_SHEET_MEASURE, PROGRAM_ID='DMF0048')

- `Sales Monitoring` 시트: 22행 (VALID 19), 명칭(`COLUMN_LABEL_NAME`) 빈칸 0.
- `Sales Plan Waterfall` 시트: 17행 (VALID 17).
- ⚠ `Measure` 콤보는 `PROGRAM_ID=@mnuId AND VALID_YN='Y'` 만 필터(**SHEET_NAME/DIVISION_ID 미필터**) → 두 시트 measure 가 함께 반환됨(코드→명칭 표시 목적엔 무해).
- ⚠ `VALID_YN='N'` 3개(`RTF_RP_CAR` / `RTF_RP_CELL` / `RTF_PR`)는 콤보에서 제외 → 해당 코드가 그리드에 뜨면 명칭 없이 코드로 남음(데이터 정비 별건).

## 8. 재사용성 (부수 효과)

`comboParams` 는 공유 자산이므로, **다른 화면의 `@mnuId`/`@divisionId` 파라미터 콤보**도 동일하게 `comboParams={{ mnuId: "'MNUID'", divisionId: "'40'" }}` 로 자동화 가능(문자열 값 quote 규약 준수).

## 9. 변경 파일 목록 (이관 대상)

```
fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx        (공유 플랫폼 — comboParams 신설)
fe/features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx  (메타 승계 + comboParams 전달)
```
> `fe/` = `nscm-fe/` 루트. 위 경로 그대로 배치.
