# DMF0043_01 (Contribute View) — 클라우드 이관

## 변경 항목 (2026-06-17)

| # | 항목 | 영향 파일 |
|---|---|---|
| 1 | Menu Button 동적화 (`useTabBtnPermissions`) | `ContributeView.tsx` |
| 2 | "⊞ 컬럼 표시 설정" customButton **항상 노출** | `ContributeView.tsx` |
| 3 | Version popup 트리거 button → DMF0005 패턴 (Button + FunctionSearchIcon) | `ContributeViewForm.tsx` |
| 4 | `fallbackColumns` 전달 (titleData 별도 fetch + `visible` flag 매칭) | `ContributeView.tsx` |
| 5 | 동적 컬럼 제외 (`.slice(0, BASE_COLUMN_COUNT)`) | `ContributeView.tsx` |
| 6 | `visibleBaseColumns` store + popup OK 시 저장 + grid filter | `useContributeViewStore.ts` + `ContributeView.tsx` + `ContributeViewGrid.tsx` |
| 7 | Popup 재진입 시 이전 이동 내역 복원 (`ColumnSettingFallback.visible`) | 공용 `ColumnSettingModal.tsx` |
| 8 | ColumnSettingModal 의 좌우 이동 button fix (`panel.rows[e.row]?.dataItem` 직접 추출) | 공용 `ColumnSettingModal.tsx` |
| 9 | 동적 column 상단 지역명 (LARGE_CLASS_LABEL_NAME) case-insensitive 매칭 | `ContributeViewGrid.tsx` |
| 10 | COLUMN_SET button 메타 등록 | `03_META/060` |

---

## 적용 순서

### Step 1 — SQL 적용

```
1) 03_META/060_DMF0043_01_dynamic_property_management.sql
   (COLUMN_SET button + USER_GR)
```

### Step 2 — FE 파일 배포

`01_FE/contribute-view/` 의 모든 파일을 클라우드 FE 의 `nscm-fe/features/master/src/pages/contribute-view/` 에 덮어쓰기.

```
ContributeView.tsx
ContributeView.module.scss
contribute-view.constants.ts
types.ts
index.ts
useContributeViewStore.ts
components/ContributeViewForm.tsx       (돋보기 popup 버튼)
components/ContributeViewGrid.tsx       (visibleBaseColumns + case-insensitive)
components/modals/ContributeVersionModal.tsx
components/modals/ColumnTitleSetModal.tsx
hooks/useContributeViewExpression.ts
hooks/useContributeViewValidation.ts
```

### Step 3 — 공용 컴포넌트 (ColumnSettingModal) 배포

`01_FE/_shared_components/columnSettingModal/` 의 파일을 클라우드 FE 의 `nscm-fe/features/master/src/components/columnSettingModal/` 에 덮어쓰기.

```
ColumnSettingModal.tsx                  (ColumnSettingFallback.visible 추가 + selectionChanged fix)
ColumnSettingModal.module.scss
```

⚠️ 공용 컴포넌트 — **DMF0020 등 다른 화면도 사용**. 호환성 검증 의무 (visible default = true 라 기존 호출은 영향 없음).

### Step 4 — BE 재기동

```
./gradlew bootRun
```

### Step 5 — 검증

- 브라우저 새로고침 → DMF0043_01 진입 + 버전 선택 + 조회
- 확인:
  - ✅ 동적 column 상단 지역명 표시 (대만/중국 등 LARGE_CLASS_LABEL_NAME)
  - ✅ "⊞ 컬럼 표시 설정" button 항상 노출
  - ✅ Version popup 트리거 button → 돋보기 모양 (DMF0005 동일)
  - ✅ ⊞ 클릭 → ColumnSettingModal popup → 9 base columns 표시 (동적 컬럼 제외)
  - ✅ 좌측으로 이동 후 OK → grid 에서 해당 column 숨김
  - ✅ 다시 ⊞ 클릭 → 이전 이동 내역 복원 (좌측 grid 에 표시)
  - ✅ 우측 grid 의 column 선택 후 좌측 이동 button 정상 작동

## PIVOT NVL audit (선택)

`05_VERIFY/test_dmf0043_01_first_row_null.py` — DMF0043_GET_CONTRIBUTION_SALES_LIST 의 첫 row dynamic column NULL count 측정.

```
python test_dmf0043_01_first_row_null.py
```

→ NULL > 0 시 별도 SP NVL patch 필요 (현재 사내 환경 확인 필요).
