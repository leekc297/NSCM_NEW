# Cloud PC `fix/lint-cleanup-20260608` Branch — features/master type-check + eslint Fix

> ⚠️ **2026-06-09 v2 갱신**: cloud type-check PASS 후 commit 시 husky pre-commit 의 eslint --fix 가 17 errors 차단 발견 →
> `ColumnSettingModal.tsx` + `SearchFields.tsx` 의 `@typescript-eslint/no-base-to-string` / `restrict-template-expressions` / `no-use-before-define` 추가 fix 반영. 본 README 와 patch / full_files 모두 갱신.

---


작성: 2026-06-09 (local PC) → cloud PC 에 적용

## Root Cause 3 축

| # | 분류 | 원인 | 영향 파일 수 |
|---:|---|---|---:|
| 1 | `tabId` required | `useTabProcQuery` / `useProcMutation` signature 변경 — `tabId: string` 필수. 호출처 전부 누락 | 13+ |
| 2 | `procedures.d.ts` DMF0008 schema 누락 | `main` / `division` sheet entry 없음. `repair/salesSite/sspm` 의 `sesUserId/menuId` strict required | 1 (procedures.d.ts) |
| 3 | `components/index.ts` export 누락 | cloud 의 `features/master/src/components/index.ts` 가 13 `*Field` + `ColumnSettingModal` re-export 안 함 | 1 (index.ts) |
| 4 (부수) | `DialogNavigationSize` literal | `size={1100}` 거부 → `size='large'` 사용 | 2 |
| 5 (부수) | `DatePickerCalendar.onChange` 시그니처 변경 | `[Dayjs, Dayjs]` → `DateRangePickerValueType` (가변 length) | 2 |
| 6 (부수) | `FlexGrid<T>` generic JSX 거부 | `<FlexGrid<SummaryRow>` → `<FlexGrid` (wijmo.react.grid generic 제거) | 1 |
| 7 (부수) | `ProjectByDivisionModal.setSelectedValue` 시그니처 | cloud 의 2 인자 → 4 인자 (optional) | 1 |
| 8 (부수) | `ItemByDivisionModal.headerTitle` prop 누락 | optional prop 추가 | 1 |
| 9 (부수) | `CustomDialog` width/height/title/onClose deprecated | `customHeaderTitle` / `customContentArea` / `handleClose` / `size` 사용 | 2 |
| 10 (부수) | `as Record<string, unknown>` direct cast | `as unknown as Record<string, unknown>` 우회 | 2 |
| 11 (부수) | `useTabProcQuery` 결과 `as XxxType[]` direct cast | `as unknown as XxxType[]` 우회 | 12+ |

## 적용 방법

### Option A — Git Apply Patch (권장 — 빠름)

cloud PC 의 `nscm-fe` 폴더에서:

```bash
# 1) 백업
git stash push -m "before-master-fix-patch"

# 2) patch 적용
git apply --check cloud_master_typecheck_fix.patch  # dry-run
git apply cloud_master_typecheck_fix.patch          # 실제 적용

# 3) type-check 재시도
pnpm type-check  # 또는 turbo run type-check --filter=@master
```

### Option B — File 단위 복사 (patch 충돌 시)

`full_files/` 폴더의 25 파일을 cloud PC `nscm-fe/` 의 동일 경로에 그대로 덮어쓰기:

```bash
# Windows PowerShell (cloud PC)
$src = "<USB 경로>\cloud_master_typecheck_fix\full_files"
$dst = "C:\Projects\NSCM\nscm-fe"  # cloud PC 의 nscm-fe 경로

# (a) 파일 인벤토리 dry-run
Get-ChildItem -Path $src -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($src.Length + 1)
    $target = Join-Path $dst $rel
    Write-Host "$rel  →  $target"
}

# (b) 실제 복사 (-Force = overwrite)
Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
```

⚠️ `components/columnSettingModal/ColumnSettingModal.tsx` 와 `searchFields/SearchFields.tsx` 폴더는 cloud 에 **없을 가능성**. 폴더 통째 복사 필수.

### Option C — 수동 Edit

cloud type-check 가 가리킨 60+ 오류 각각을 다음 패턴으로 직접 수정:

1. `useTabProcQuery({menuId, sheetName, filters, enabled})` → `useTabProcQuery({menuId, sheetName, tabId: MENU_ID, filters, enabled})`
2. `useProcMutation({menuId, sheetName})` → `useProcMutation({menuId, sheetName, tabId: MENU_ID})`
3. `(data?.o_rc1 ?? []) as XxxRow[]` → `(data?.o_rc1 ?? []) as unknown as XxxRow[]`
4. `procedures.d.ts` 의 DMF0008 entry 에 `main` / `division` sheet + 모든 sheet 의 `sesUserId?: string; menuId?: string;` optional 변경

## 적용 후 검증

```bash
pnpm type-check  # ELIFECYCLE 없이 완료되면 push 가능

git push -u origin fix/lint-cleanup-20260608
```

## ⚠️ 주의

- 이 patch 는 cloud PC 의 commit `911ad4b` (또는 그 이후) 에 대한 fix. 다른 branch / commit 에서는 hunk 충돌 가능
- patch 의 line offset 이 cloud 와 다르면 `git apply --reject cloud_master_typecheck_fix.patch` 후 `.rej` 파일 수동 merge
- erp-edi-master 의 추가 file 들 (`ErpEdiMasterSummaryGrid` / `ErpEdiMasterRepairGrid` / `empty-rows` 등) 은 cloud 에만 있는 file — 이 patch 에서 직접 fix 불가. cloud 에서 같은 패턴 (tabId 추가 / `as unknown as` cast / SHEETS enum 확장) 적용 필요

## 파일 인벤토리

- `cloud_master_typecheck_fix.patch` — git diff patch (33KB / 723 lines / 18 modified files)
- `full_files/` — local PC 의 최신 25 파일 (modal/page/component/types 포함)
- `README.md` — 본 문서
