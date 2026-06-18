# DMF0072 (NN Master Mapping) — 클라우드 이관

## 변경 항목 (2026-06-17)

| # | 항목 | 영향 파일 |
|---|---|---|
| 1 | Menu Button 동적화 (`useTabBtnPermissions`) | `NnMasterMapping.tsx` |
| 2 | Monolithic 분리 — 577줄 → 본체 + `NnMasterMappingGrid` + `NnMasterMappingModals` | `NnMasterMapping.tsx` + 신규 2 컴포넌트 |
| 3 | `staticColumns` + `fetchStaticColumns` 동적 fetch | `useNnMasterMappingStore.ts` |
| 4 | `visibleColumns` MAIN_COLUMNS 항상 표시 + admin 메타 override (filter 제거 — column 안 보임 사고 fix) | `NnMasterMappingGrid.tsx` |
| 5 | Cell merge (HierarchicalMergeManager) + `AllowMerging.Cells` | `NnMasterMappingGrid.tsx` |
| 6 | `frozenColumns/frozenRows = 0` 명시 (cell 고정 해제) | `NnMasterMappingGrid.tsx` |
| 7 | SHEET_COLUMNS 23 컬럼 INSERT (snake_case binding) | `03_META/080` |

---

## 적용 순서

### Step 1 — SQL 적용

```
1) 03_META/080_DMF0072_dynamic_property_management.sql
   (Menu Button 4종 + USER_GR + SHEET_COLUMNS 23 컬럼 INSERT)
```

POST-CHECK 출력:
- BTN_MPG 4 row (SEARCH/INSERT/SAVE/DELETE)
- SHEET_COLUMNS 23 row

### Step 2 — FE 파일 배포

`01_FE/nn-master-mapping/` 의 모든 파일을 클라우드 FE 의 `nscm-fe/features/master/src/pages/nn-master-mapping/` 에 덮어쓰기.

```
NnMasterMapping.tsx                    (본체 — 378줄)
NnMasterMapping.module.scss
nn-master-mapping.constants.ts
useNnMasterMappingStore.ts
index.ts
components/NnMasterMappingGrid.tsx     [NEW] (분리)
components/NnMasterMappingModals.tsx   [NEW] (분리)
components/NnMasterMappingForm.tsx     (변경 없음 — 의존 import 확인용)
```

⚠️ `components/NnMasterMappingGrid.tsx` + `NnMasterMappingModals.tsx` 는 **신규 파일** — 클라우드에 없는 상태에서 신규 생성 필요.

### Step 3 — BE 재기동

```
./gradlew bootRun
```

### Step 4 — 검증

- 브라우저 새로고침 → DMF0072 진입
- 확인:
  - ✅ 23 column 정상 표시
  - ✅ Cell merge 시각 (같은 값 row 들 합쳐짐)
  - ✅ 가로/세로 scroll bar 정상
  - ✅ Header sticky (scroll 시 header 유지)
  - ✅ FPModal column 더블클릭 → popup (Customer/Project/Item)
  - ✅ 신규 행 (Insert) → CRUD_TYPE='I' 자동 마킹
  - ✅ 기존 행 수정 → CRUD_TYPE='M' 자동 마킹

## 변경 사고 학습

- DataGrid wrapper 사용 시 BE 메타 매칭 0건 환경에서 "조회 대기 중" hang → FlexGrid 직접 사용 유지
- `visibleColumns` filter 패턴 (`MAIN_COLUMNS.filter(c => staticColumns.some(s => s.colNm === c.key))`) 은 BE 메타 일부 매칭 시 컬럼 0개 사고 → `MAIN_COLUMNS.map + override` 패턴으로 변경
