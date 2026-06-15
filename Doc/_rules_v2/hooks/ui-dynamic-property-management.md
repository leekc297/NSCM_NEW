# Hook — UI 생성의 동적 속성관리 (Menu Button / Column / Measure)

> ⭐ **사용자 명시 요구 (2026-06-12)**:
> 화면의 **Button / Column / Measure 의 모든 속성** 은 admin UI (Menu Button + UI Category Setup) 에서 관리하는 데이터를 기준으로 **동적 fetch + 즉시 반영** 의무.
> 신규 UI 작성 시 admin UI 에 데이터 부재 → **신규 등록 의무**. 등록 후 admin UI 에서 데이터 조작 → **자동 반영**.

작성: 2026-06-12 (사용자 명명 "UI 생성의 동적 속성관리")
상위 룰: `anti-simplification.md`
관련 룰: `_tobe/04_store.md` / `_tobe/07_datagrid.md` / `_tobe/08_column_meta.md` / `_tobe/09_subtitle_hotkey.md` / `_tobe/12_metadata_sql.md`

---

## §0. 진입 — 3 구성요소

| # | 구성요소 | 관리 admin UI | 관리 테이블 | child hook |
|---|---|---|---|---|
| 1 | **Menu Button** (Visible/Enable/권한) | **SYS0009 Menu Button** (`menu-button-management`) | `SCM_ADM_MNU_BTN_MPG_M` + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | `menu-button-dynamic-fetch.md` ⭐ 신규 |
| 2 | **Column** (Visible/Enable/Width/Lookup/CellType/Label/Scale/Align 등) | **SYS0004 UI Category Setup** (`ui-category`) | `SCM_MST_SHEET_COLUMNS` | `ui-category-setup-column-meta.md` |
| 3 | **Measure** (Lookup 코드/Label/SortOrder/Valid) | **SYS0004 UI Category Setup** (Measure 탭) | `SCM_MST_SHEET_MEASURE` | `ui-category-setup-column-meta.md §8` ⭐ 추가 |

⚠ **3 종 모두 의무** — 하나라도 하드코딩 시 admin 변경 전파 불가 → 운영 결정 무효화 → 신뢰성 손상.

---

## §1. 트리거 (작업 키워드 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01) | PRE-WRITE 1단계 (3 구성요소 확인) + 신규 등록 + POST-WRITE 검증 |
| Button 추가/수정 (`customButtons`/`hotkeyConfig`) | PRE-WRITE + POST-WRITE |
| Grid Column 수정 (T04) | PRE-WRITE + POST-WRITE |
| Measure 추가 (Sales Price 등 PIVOT 화면) | PRE-WRITE + POST-WRITE |
| Sheet 추가 | PRE-WRITE |

---

## §2. 신규 화면 작성 시 의무 4 단계

### Step 1 — admin UI 데이터 존재 점검 (PRE-WRITE)

```sql
-- 1) Menu Button (해당 화면 ID 의 button 정의 존재?)
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '{NEW_MENU_ID}';

-- 2) Column (해당 화면 ID + 각 SHEET 의 column 메타 존재?)
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, VISIBLE_FLAG, COLUMN_WIDTH
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '{NEW_MENU_ID}';

-- 3) Measure (PIVOT/measure 사용 화면 만 — 해당 화면 ID + SHEET 의 measure 존재?)
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VALID_YN
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = '{NEW_MENU_ID}';
```

### Step 2 — 부재 시 admin UI 에 신규 등록 의무

⚠ **Step 1 결과 0 건 → 신규 등록 의무**. admin UI 에서 등록하거나, deploy SQL (BLOCK 3/4/6) 에 INSERT 포함.

**신규 등록 표준 SQL 패턴** (메타 SQL 7-BLOCK 의 일부):

```sql
-- BLOCK 3: SCM_ADM_MNU_BTN_MPG_M (Menu Button)
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT '{NEW_MENU_ID}', '{SHT_NM}', 'SEARCH', '{NEW_MENU_ID}_{SHT_NM}_SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{NEW_MENU_ID}' AND SHT_NM='{SHT_NM}' AND MNU_BTN_CD='SEARCH');
-- 동일 패턴으로 INSERT/DELETE/SAVE/EXCEL/UPLOAD/MANUAL 등 추가

-- BLOCK 6 (a): SCM_MST_SHEET_COLUMNS (Column 메타)
INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, ...)
SELECT * FROM (SELECT '{NEW_MENU_ID}' PROGRAM_ID, '{SHT_NM}' SHEET_NAME, 'DIVISION_ID' COLUMN_NAME, 'Division' COLUMN_LABEL_NAME, ... FROM DUAL UNION ALL ...) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=NEW.PROGRAM_ID AND SHEET_NAME=NEW.SHEET_NAME AND COLUMN_NAME=NEW.COLUMN_NAME);

-- BLOCK 6 (b): SCM_MST_SHEET_MEASURE (Measure 메타 — PIVOT/measure 사용 화면)
INSERT INTO SCM_MST_SHEET_MEASURE (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VALID_YN, CREATED_BY, CREATION_DATE)
SELECT * FROM (SELECT '{NEW_MENU_ID}', 'Sales Price', 'LOC', 'Local', 1, 'Y', 'admin', SYSDATE FROM DUAL UNION ALL ...) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=NEW.PROGRAM_ID AND SHEET_NAME=NEW.SHEET_NAME AND COLUMN_NAME=NEW.COLUMN_NAME);
```

### Step 3 — FE 동적 fetch 구현 (3 구성요소 통합)

| 구성요소 | Store state | fetch action | 호출 시점 |
|---|---|---|---|
| **Menu Button** | (BE auto: `useTabBtnPermissions` hook 또는 API `/admin/menu/{MENU_ID}/buttons`) | `useTabBtnPermissions(MENU_ID, SHT_NM)` | mount + division/tab 변경 |
| **Column** | `staticColumns: { [SHEET]: RawFlexGridColumnConfig[] }` | `fetchStaticColumns()` | mount + Search + division 변경 |
| **Measure** | `staticMeasures: { [SHEET]: MeasureMeta[] }` (PIVOT 화면) | `fetchStaticMeasures()` | mount + Search + division 변경 |

### Step 4 — admin UI 변경 → 화면 즉시 반영 의무

- 화면 진입 시 항상 fetch (mount + Search)
- Cache invalidation 시점: 사용자가 admin UI 에서 SAVE → BE 가 `/api/cache/refresh` 트리거 → FE store 자동 invalidate
- (BE 가 cache 미지원 시) 사용자가 화면 재진입 시 mount fetch 로 반영

---

## §3. 구성요소 1 — Menu Button (Visible/Enable)

⭐ 상세는 child hook **`menu-button-dynamic-fetch.md`** 참조.

### 3.1 핵심 (요약)

화면의 모든 버튼 (Search/Insert/Delete/Save/Excel/Upload/Manual + customButtons) 은 `SCM_ADM_MNU_BTN_MPG_M` (정의) + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (권한) 데이터 기준:

| 의미 | 결정 기준 |
|---|---|
| **Visible** (사용자에게 표시) | `MNU_BTN_MPG_M.USE_YN = 'Y'` (admin 이 정의 자체 토글) |
| **Enable** (클릭 가능) | 로그인 사용자 그룹의 `USER_GR_MNU_BTN_MPG_M` row 존재 + `USE_YN = 'Y'` (권한) |

### 3.2 FE 구현 패턴 ⭐ 2026-06-15 — **BE+FE 구현 완료**

**BE Endpoint (기존)**: `GET /admin/menu/{mnuId}/auth` → `MenuAuthDto { mnuBtnAuth: List<String>, unitAuth: List<UnitDto> }`
- 위치: `nscm-be/.../admin/menu/MenuController.java:63`
- service: `AuthServiceImpl.retrieveMenuBtnAuth(userId, mnuId)` — SCM_ADM_USER_GR_MNU_BTN_MPG_M 조회

**FE Hook (2026-06-15 신규 작성)**: `nscm-fe/packages/shared/src/hooks/useTabBtnPermissions.ts`
- export: `@shared/hooks` 의 `useTabBtnPermissions`
- 시그니처: `useTabBtnPermissions({ menuId }) → { buttons, hasButton, isLoading, refetch }`
- react-query 캐싱 (queryKey `['menu-auth', menuId]`, staleTime 60s)

**사용 패턴**:

```tsx
import { useTabBtnPermissions } from '@shared/hooks';

const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

const hotkeyConfig: HotkeyConfig = {
  search: hasButton('SEARCH') ? handleSearch : false,
  insert: hasButton('INSERT') ? handleInsert : false,
  save:   hasButton('SAVE')   ? handleSave   : false,
  delete: hasButton('DELETE') ? handleDelete : false,
  /* admin 정의 자체 없음 — Hidden allowlist */
  manual: false,
  upload: false,
};

const customButtons = hasButton('EXECUTE')
  ? [{ label: 'Execute', action: handleExecute }]
  : [];
```

⚠ **hardcoded `hotkeyConfig: { search: handleSearch }`** 작성 시 → admin USE_YN='N' 비활성화 무시 → 운영 결정 무효화 (SCM0008 사고 family, 메모리 `feedback_common_button_visibility_default.md`).

⚠ **`shtNm` 파라미터 없음** — BE 가 menu 전체의 권한 list 반환 (sheet 무관). sheet 별 권한 분리 필요 시 BE 보강 별도 task.

### 3.3 ⭐ 2026-06-15 사고 사례 (재발 방지)

**상황**: SYS0013 작업 시 master hook 의 `useTabBtnPermissions` 미구현으로 잘못 판단 → DynamicQuery.tsx 에 import → vite "does not provide an export named 'useTabBtnPermissions'" 사고.

**root cause**: BE endpoint 인벤토리 사전 점검 미수행. 사용자 지적으로 BE 의 `/admin/menu/{mnuId}/auth` (`MenuController.java:63`) 이미 존재 발견.

**재발 방지 의무** (anti-simplification + fe-import-check 보강):
- 신규 hook 작성 검토 시 **BE Controller endpoint 인벤토리 grep 의무**:
  ```bash
  grep -rn "@(Get|Post|Put|Delete)Mapping" nscm-be/src/main/java/com/lgcns/nscm/admin/menu/
  grep -rn "@(Get|Post|Put|Delete)Mapping" nscm-be/src/main/java/com/lgcns/nscm/general/
  ```
- 동적 fetch 패턴 (메뉴/권한/Column/Measure) 작업 시 `/admin/menu/{mnuId}/*` endpoint 인벤토리 의무
- 추측 ("BE 에 없을 것") 금지 — 직접 확인 후 결정

### 3.3 신규 등록 의무 SQL (반드시 deploy SQL 에 포함)

```sql
-- 새 화면의 sheet 마다 표준 button 6종 + 사용자 그룹 권한
MERGE INTO SCM_ADM_MNU_BTN_MPG_M t
USING (SELECT '{NEW_MENU_ID}' MNU_ID, '{SHT_NM}' SHT_NM, '{BTN_CD}' MNU_BTN_CD FROM DUAL) s
   ON (t.MNU_ID=s.MNU_ID AND t.SHT_NM=s.SHT_NM AND t.MNU_BTN_CD=s.MNU_BTN_CD)
 WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                       VALUES (s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, '{API_ID}', 'Y', 'admin', SYSDATE, 'admin', SYSDATE);
-- {BTN_CD} 반복: SEARCH/INSERT/DELETE/SAVE/EXCEL/UPLOAD/MANUAL

-- USER_GR_MNU_BTN_MPG_M (자매 화면 그룹 동적 복사)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, '{NEW_MENU_ID}' MNU_ID, '{SHT_NM}', '{BTN_CD}', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 WHERE u.MNU_ID = '{SISTER_MENU_ID}' AND u.SHT_NM = 'main' AND u.MNU_BTN_CD = 'SEARCH'
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
                    WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = '{NEW_MENU_ID}'
                      AND e.SHT_NM = '{SHT_NM}' AND e.MNU_BTN_CD = '{BTN_CD}');
```

---

## §4. 구성요소 2 — Column (Visible/Enable/Width/Lookup/CellType/Label/Scale/Align)

⭐ 상세는 child hook **`ui-category-setup-column-meta.md`** 참조 (5단계 의무 패턴 + DMF0004/0005 표준).

### 4.1 admin UI 가 관리하는 모든 column 속성 (전부 동적 fetch)

| 속성 | 메타 컬럼 | FE 영향 |
|---|---|---|
| Visible | `VISIBLE_FLAG` | 컬럼 노출/숨김 |
| Display | `DISPLAY_FLAG` | column-mapping 필터 |
| Fixed | `FIXED_FLAG` | 좌측 frozen |
| Label | `COLUMN_LABEL_NAME` | 헤더 i18n |
| Width | `COLUMN_WIDTH` | 너비 |
| Scale | `DATA_SCALE_NUMBER` | 소수점 |
| CellType | `CELL_CONTROL_OBJECT_TYPE_CODE` | modal/combo/text/checkbox/image/popup |
| InputType (Enable) | `INPUT_TP_CD` | S(static)/O(opt)/M(mandatory)/IO/IM (edit type) |
| Align | `HORIZONTAL_ALIGN_CODE` | L/R/C |
| Uppercase | `UPPERCASE_APPLY_FLAG` | 자동 변환 |
| Selectable | `USER_SELECTABLE_FLAG` | column setting popup 노출 |
| Lookup (combo) | `ATTRIBUTE1~10` (`_modalKey` 등) | combo / popup 키 |

→ **모두 admin 변경 시 즉시 반영** — `staticColumns[SHEET]` state + `fetchStaticColumns()` action.

---

## §5. 구성요소 3 — Measure (Lookup 코드/Label/SortOrder/Valid)

PIVOT 화면 (Sales Price / Contribute Ratio / Demand Plan 등) 의 measure (LOC, RTF_SYS_RP 등) 도 admin 관리.

### 5.1 admin UI 가 관리하는 모든 measure 속성

| 속성 | 메타 컬럼 | FE 영향 |
|---|---|---|
| Code | `COLUMN_NAME` | measure 코드 (LOC, USD, RTF_SYS_RP, ...) |
| Label | `COLUMN_LABEL_NAME` | 화면 표시 라벨 |
| Sort Order | `SORT_ORDER_NO` | 정렬 순서 |
| Valid | `VALID_YN` | 사용 가능 여부 |

### 5.2 FE 동적 fetch 패턴

```ts
// Store
interface State {
  staticMeasures: { [key in SHEETS]: MeasureMeta[] };
  /* ... */
}

interface Action {
  fetchStaticMeasures: () => Promise<void>;
}

fetchStaticMeasures: async () => {
  const [main, popup] = await Promise.all([
    apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, { sheetNm: SHEETS.MAIN }),
    apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, { sheetNm: SHEETS.POPUP }),
  ]);
  set(state => {
    state.staticMeasures = {
      [SHEETS.MAIN]:  main.data.result,
      [SHEETS.POPUP]: popup.data.result,
    };
  });
},
```

### 5.3 신규 등록 의무 SQL

```sql
INSERT INTO SCM_MST_SHEET_MEASURE (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VALID_YN, CREATED_BY, CREATION_DATE)
SELECT * FROM (
  SELECT '{NEW_MENU_ID}' PROGRAM_ID, 'Sales Price' SHEET_NAME, 'LOC'        COLUMN_NAME, 'Local'        COLUMN_LABEL_NAME, 1 SORT_ORDER_NO, 'Y' VALID_YN, 'admin' CREATED_BY, SYSDATE CREATION_DATE FROM DUAL UNION ALL
  SELECT '{NEW_MENU_ID}',            'Sales Price',            'USD',                    'USD',                            2,               'Y',          'admin',           SYSDATE                   FROM DUAL UNION ALL
  SELECT '{NEW_MENU_ID}',            'Sales Price',            'RTF_SYS_RP',             'RTF System RP',                  3,               'Y',          'admin',           SYSDATE                   FROM DUAL
) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=NEW.PROGRAM_ID AND SHEET_NAME=NEW.SHEET_NAME AND COLUMN_NAME=NEW.COLUMN_NAME);
```

---

## §6. PRE-WRITE 자기 점검 (모두 ✓ 필수)

### 6.1 admin UI 데이터 존재 점검

- [ ] `SCM_ADM_MNU_BTN_MPG_M` 의 `{NEW_MENU_ID}` × `{SHT_NM}` × button 정의 1건 이상 존재?
- [ ] `SCM_MST_SHEET_COLUMNS` 의 `{NEW_MENU_ID}` × `{SHT_NM}` × column 메타 1건 이상 존재?
- [ ] (PIVOT/measure 사용 화면) `SCM_MST_SHEET_MEASURE` 의 `{NEW_MENU_ID}` × `{SHT_NM}` measure 1건 이상 존재?

### 6.2 부재 시 deploy SQL 에 신규 등록 INSERT 포함

- [ ] BLOCK 3 (Menu Button) NOT EXISTS 멱등 INSERT 작성?
- [ ] BLOCK 6 (Column 메타) NOT EXISTS 멱등 INSERT 작성?
- [ ] BLOCK 6+ (Measure 메타, PIVOT 화면) NOT EXISTS 멱등 INSERT 작성?
- [ ] USER_GR_MNU_BTN_MPG_M (권한) 자매 그룹 동적 복사 INSERT 작성?

### 6.3 FE 동적 fetch 구현

- [ ] Store 에 `staticColumns` + `fetchStaticColumns` 정의?
- [ ] (PIVOT 화면) Store 에 `staticMeasures` + `fetchStaticMeasures` 정의?
- [ ] Component mount + Search 시 둘 다 호출?
- [ ] `hotkeyConfig` 가 `useTabBtnPermissions` 결과 사용 (하드코딩 X)?
- [ ] DataGrid 에 `staticColumns={...[SHEET]}` prop 전달?
- [ ] PIVOT/measure 사용 grid 에 `staticMeasures` 사용?

---

## §7. POST-WRITE 자동 검증 (grep)

```bash
# 1) DataGrid 에 staticColumns prop 누락 검출
grep -L "staticColumns" features/*/src/pages/{NEW_SCREEN}/components/*Grid.tsx

# 2) Store 에 fetchStaticColumns 미정의 검출
grep -L "fetchStaticColumns" features/*/src/pages/{NEW_SCREEN}/use*Store.ts

# 3) hotkeyConfig 하드코딩 (`useTabBtnPermissions` 미사용) 검출
grep -L "useTabBtnPermissions\|hasButton" features/*/src/pages/{NEW_SCREEN}/{Screen}.tsx

# 4) FlexGridColumn binding 직접 명세 검출 (예외: 동적 PIVOT 만 허용)
grep -rn "FlexGridColumn binding=" features/*/src/pages/{NEW_SCREEN}/ | grep -v "// 동적\|// dynamic\|// PIVOT"

# 5) deploy SQL 에 SCM_ADM_MNU_BTN_MPG_M / SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE INSERT 존재
grep -l "SCM_ADM_MNU_BTN_MPG_M\|SCM_MST_SHEET_COLUMNS\|SCM_MST_SHEET_MEASURE" \
     _artifacts/_deploy_packages/{NEW_MENU_ID}/03_META/*.sql
```

---

## §8. anti-pattern 사고 사례

### 8.1 신규 화면 작성 시 BLOCK 3 (MNU_BTN_MPG_M) 미등록
- 결과: BE callProc 에서 "권한없음" 또는 button visible 0건 → 화면 빈 SubTitle
- fix: deploy SQL 에 NOT EXISTS 멱등 INSERT 추가, 자매 USER_GR 그룹 동적 복사
- 참조: SCM0008/SCM0009 사고 (메모리 `feedback_button_code_consistency_search_vs_retrieve.md`)

### 8.2 hotkeyConfig 하드코딩 (admin USE_YN 무시)
- 결과: admin 이 button 을 USE_YN='N' 으로 비활성화해도 화면에서 클릭 가능
- fix: `useTabBtnPermissions` 사용 + `hasButton(...)` 조건부 callback

### 8.3 SHEET_COLUMNS 미등록 + 하드코딩 column 사용
- 결과: admin VISIBLE/WIDTH 변경 영영 미반영
- fix: 메모리 `feedback_grid_no_hardcoded_static_columns.md` + child hook `ui-category-setup-column-meta.md`

### 8.4 Measure 하드코딩 (PIVOT 화면)
- 결과: admin 이 measure 추가 (예: ASP) 해도 PIVOT 컬럼 안 나타남
- fix: `SCM_MST_SHEET_MEASURE` 동적 fetch + `staticMeasures[SHEET]` state

### 8.5 admin UI 변경 후 캐시 invalidate 누락
- 결과: 다른 사용자가 화면 진입 해도 변경 사항 즉시 반영 안 됨 (mount fetch 가 BE cache 결과)
- fix: BE `/admin/menu/{MENU_ID}/column` SAVE 시 cache invalidate 트리거

---

## §9. Cross-ref

### Child hook
- `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md` ⭐ 신규 — Button visible/enable
- `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md` — Column 5단계 의무 + Measure §8 추가

### 룰 v2
- 04_store §9/§10 — `createPersistedStoreWithTab` + `fetchStaticColumns` guard
- 07_datagrid §11 — DataGrid `staticColumns` 출처 표준
- 08_column_meta — `_inputEditType`/`_ctrlType`/`_modalKey`
- 09_subtitle_hotkey §2.2.1 — 공통 버튼 기본 표시 정책
- 12_metadata_sql §13/§14 — MNU_BTN_CD 표준 + SHEET_COLUMNS 등록 + Measure 등록

### 메모리
- `feedback_admin_meta_dynamic_fetch.md` — UI Category Setup column 동적 fetch 의무
- `feedback_grid_no_hardcoded_static_columns.md` — staticColumns 하드코딩 금지
- `feedback_fetchstaticcolumns_no_initialized_guard.md` — initialized guard 오용 방지
- `feedback_sheet_columns_binding_must_match_sp.md` — COLUMN_NAME = SP alias case-sensitive
- `feedback_common_button_visibility_default.md` — hotkeyConfig 기본 표시 정책
- `feedback_button_code_consistency_search_vs_retrieve.md` — MNU_BTN_CD 표준 (SEARCH)

### 사용자 명명
- "**UI 생성의 동적 속성관리**" — Menu Button / Column / Measure 3 구성요소 통합 (2026-06-12 사용자 명시)

---

## §10. 위반 시 대응

- PRE-SUBMIT 시 §6 체크리스트 + §7 grep 모두 통과 의무
- 1건이라도 위반 = PR 머지 차단
- 사고 사례 §8 중 어느 것이라도 재현 가능 → 즉시 fix
- anti-simplification 위반 (속도/편의 목적 하드코딩) = 도구 사용 중단
