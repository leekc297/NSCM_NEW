# lint-fix patch — 클라우드 PC 적용 가이드

## 적용 우선순위

### Phase 1 — type-check 차단 errors fix (push 통과 위해)

이 patch 의 핵심 fix 파일 (clouds PC 의 push 차단 해결):

| 파일 | 변경 의도 | 효과 |
|---|---|---|
| `features/demand/src/pages/mkt_forecast/components/MktForecastMasterForm.tsx` | import path 변경 (`features/master/src/components` → `features/master/src/components/searchFields/SearchFields`) | BizTypeField 등 11 export 사고 해소 (12 errors) |
| `features/demand/src/pages/mkt_forecast/components/MktForecastSubTabs.tsx` | TabWrapper API (`activeKey`/`onChange` → `activeTabIndex`/`setActiveTabIndex`), TabItem (`title` → `label`) | 3 errors 해소 |
| `features/demand/src/pages/mkt_forecast/components/modals/MasterChgModal.tsx` | CustomDialog API (`width`/`height`/`buttons` 제거 → `size`/`handleSubmit`/`handleClose`/`customContentArea`) | 1 error 해소 |
| `features/admin/src/pages/dynamic-query/dynamic-query.types.ts` | 모든 row type 에 `extends WijmoRowItem` 추가 | 5+ errors 해소 (ColumnMetaRow/HistoryRow/QueryRow/ParameterMetaRow/ResultRow) |
| `features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx` | `RawFlexGridColumnConfig` camelCase prop (`colNm`/`colLblNm`/`colWth`/`fixed`/`visible`/`display`) | 1 error 해소 |
| `features/admin/src/pages/dynamic-query/DynamicQuery.tsx` | `as unknown as XxxRow[]` double cast | 4 errors 해소 |
| `features/admin/src/pages/group-user/components/GroupUserInfoGrid.tsx` | `UserInfoRow = WijmoRowItem & {...}` type 정의 + storeChange `?? ''` 보정 | 5 errors 해소 |

### Phase 2 — eslint 사고 fix (이미 적용)

cat #1 (RESPONSE_SET enum → const object 6 파일) / cat A (func-style arrow 7 파일) / cat B (no-base-to-string) / cat C (no-use-before-define) / cat D (no-unsafe-* 잔존) / cat E~F.

### 클라우드 PC 만의 사고 (별도)

이 PC 에 없는 파일 (사용자가 이미 삭제 안내):
- `features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx` (30 errors — 삭제됨)
- `features/master/src/pages/shared-modal/ItemByDivisionModal.tsx` (28 errors — 삭제됨)

추가로 클라우드 PC 의 `SubTitle.tsx` 가 이 PC 의 `SubTitle.tsx` (searchAction prop 있음) 보다 옛 버전 가능성 — GroupManagement.tsx 의 `searchAction` 사고 해소 위해 같이 복사 필요.

## 적용 방법

### 옵션 1 (권장) — `git apply`

```bash
# 클라우드 PC 의 NSCM 루트에서:
git apply --check _artifacts/_lint_fix_patch/lint_fix_all.patch    # conflict 확인
git apply _artifacts/_lint_fix_patch/lint_fix_all.patch
git status   # 변경 확인
```

### 옵션 2 — 파일별 직접 복사

이 PC 의 각 파일 (위 7 + 기타) 을 클라우드 PC 의 같은 path 에 복사.

핵심 7 파일 위치:
```
이 PC C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt_forecast\components\MktForecastMasterForm.tsx
이 PC C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt_forecast\components\MktForecastSubTabs.tsx
이 PC C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt_forecast\components\modals\MasterChgModal.tsx
이 PC C:\Projects\NSCM\nscm-fe\features\admin\src\pages\dynamic-query\dynamic-query.types.ts
이 PC C:\Projects\NSCM\nscm-fe\features\admin\src\pages\dynamic-query\components\DynamicQueryResultGrid.tsx
이 PC C:\Projects\NSCM\nscm-fe\features\admin\src\pages\dynamic-query\DynamicQuery.tsx
이 PC C:\Projects\NSCM\nscm-fe\features\admin\src\pages\group-user\components\GroupUserInfoGrid.tsx
```

→ 클라우드 PC 의 같은 path 에 덮어쓰기.

### 추가 — SubTitle.tsx (searchAction prop) 도 복사 필요

```
이 PC C:\Projects\NSCM\nscm-fe\packages\shared\src\components\organisms\sub-title\SubTitle.tsx
```

→ 클라우드 PC 의 같은 path 에 덮어쓰기 (GroupManagement.tsx 의 `searchAction` prop 사고 해결).

## push 재시도

```bash
# 클라우드 PC:
git add -A
git commit -m "fix: type-check + lint errors"   # 또는 amend
git push -u origin fix/lint-cleanup-20260608
```

## 잔존 사고 대응

push 시 새로운 type-check error 발생하면 알려주세요 (이 PC fix 가 모두 해결하지 못한 경우 — 클라우드 코드만의 사고). 추가 fix 진행 가능.

## 파일 인벤토리 (전체 변경)

총 41 파일 변경 (patch 2660 lines). 위 README 의 핵심 7 파일 + 기타 lint fix.
