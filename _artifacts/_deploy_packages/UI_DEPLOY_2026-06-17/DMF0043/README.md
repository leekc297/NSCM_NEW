# DMF0043 (Contribute Main) — 클라우드 이관

## 변경 항목 (2026-06-17)

| # | 항목 | 영향 파일 |
|---|---|---|
| 1 | Menu Button 동적화 (`useTabBtnPermissions`) | `ContributeMain.tsx` |
| 2 | "기여율 버전관리" customButton **항상 노출** (admin 메타 의존 X) | `ContributeMain.tsx` |
| 3 | `staticColumns` + `fetchStaticColumns` (BASE 6 컬럼 동적 fetch) | `useContributeMainStore.ts` + `ContributeMainGrid.tsx` |
| 4 | `visibleBaseColumns` filter (admin VISIBLE_FLAG 반영) | `ContributeMainGrid.tsx` |
| 5 | Viewport sticky cell merge (DMF0004 `CustomMergeManager` 패턴) | `ContributeMainGrid.tsx` |
| 6 | mount + Search 시 `fetchStaticColumns` 호출 | `ContributeMain.tsx` |
| 7 | SHEET_COLUMNS BASE 6 컬럼 + VERSION_MGMT 메타 등록 | `03_META/060` |

---

## 적용 순서

### Step 1 — SQL 적용

```
1) 03_META/060_DMF0043_dynamic_property_management.sql
   (VERSION_MGMT button + BASE 6 SHEET_COLUMNS INSERT)
```

POST-CHECK:
- BTN_MPG 의 VERSION_MGMT 1 row
- USER_GR 의 VERSION_MGMT 권한 (sister 그룹 자동 복사)
- SHEET_COLUMNS 의 BASE 6 row (`DEPARTMENT_NAME` / `DEPT_NAME` / `END_CUST_REPORT` / `SOLDTO_CUST_REPORT` / `PRODUCT_GROUP` / `DM_BIZ_TYPE`)

### Step 2 — FE 파일 배포

`01_FE/contribute-main/` 의 모든 파일을 클라우드 FE 의 `nscm-fe/features/master/src/pages/contribute-main/` 에 덮어쓰기.

```
ContributeMain.tsx
ContributeMain.module.scss
contribute-main.constants.ts
types.ts
index.ts
useContributeMainStore.ts
components/ContributeMainGrid.tsx        (viewport sticky 적용)
components/ContributeRatePopup.tsx
components/SearchBar.tsx
components/VersionPopup.tsx
components/VersionPopup.module.scss
utils/validators.ts
```

### Step 3 — BE 재기동

```
./gradlew bootRun
```

### Step 4 — 검증

- 브라우저 새로고침 → DMF0043 진입 + 버전 선택 + 조회
- 확인:
  - ✅ BASE 6 컬럼 표시 (부문/팀/고객군/판매처/제품군/형태)
  - ✅ 동적 Y#/M# 컬럼 표시 (PIVOT)
  - ✅ "기여율 버전관리" 버튼 항상 노출
  - ✅ admin VISIBLE_FLAG='N' 토글 시 해당 column 숨김
  - ✅ admin COLUMN_WIDTH 변경 시 즉시 반영
  - ✅ **viewport sticky cell merge** — 머지 cell 의 첫 row 가 viewport 위로 사라지면 새 viewport 첫 row 에 content 자동 표시

## viewport sticky 작동 원리

```typescript
// HeaderMergeManager 의 Cell case:
const rng = new CellRange(r, c);
const minRow = panel.viewRange.row;     // 현재 viewport 시작 row
const maxRow = panel.viewRange.row2;    // 현재 viewport 끝 row
while (rng.row > minRow && _canMerge(...)) rng.row--;   // viewport 안에서만 확장
while (rng.row2 < maxRow && _canMerge(...)) rng.row2++;

// scrollPositionChanged → g.invalidate() (머지 재계산 trigger)
```

→ 같은 값 row 들이 viewport 안에서만 그룹화 → cell content 가 현재 보이는 첫 row 에 자동 위치.

## PIVOT NVL (이미 사내 적용 완료 — 회귀 확인)

2026-06-17 사내 SP `DMF0043_GET_CONTRIBUTE_MAIN_DATA` 의 동적 SELECT NVL 적용 완료. 회귀 확인 (선택):
```
python _artifacts/_diagnostics/test_dmf0043_first_row_null.py
```
→ NULL count = 0 기대.
