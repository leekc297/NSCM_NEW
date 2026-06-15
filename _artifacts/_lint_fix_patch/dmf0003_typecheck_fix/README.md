# DMF0003 (MKT FCST) — type-check 17 패턴 정밀 보완

작성: 2026-06-09 (local PC) → cloud 적용 대상
적용 룰: `Doc/_rules_v2/hooks/type-check-error-patterns.md` 17 패턴

## 변경 인벤토리 (10 file)

| File | 적용 패턴 | 변경 |
|---|---|---|
| `MktForecastMaster.tsx` | §2 패턴 6 | 9 위치 `as ComboItem[]` / `as MktFcstRow[]` direct cast → `as unknown as ...` |
| `components/MktForecastCarSubGrid.tsx` | §2 패턴 6 | line 55 `as CarRow[]` → `as unknown as CarRow[]` |
| `components/MktForecastPsiSubGrid.tsx` | §2 패턴 6 | line 59 `as PsiRow[]` → `as unknown as PsiRow[]` |
| `components/modals/MasterChgModal.tsx` | §3 패턴 12 | `onClose=` / `title=` → `customHeaderTitle=` / `type='modal'` / `position='basic'` (handleClose 이미 있음) |
| `components/modals/MeasureSelectModal.tsx` | §3 패턴 11 | `size={900}` → `size={800}` (900 은 DialogNavigationSize union 비포함) |
| `components/modals/PrHistoryModal.tsx` | §3 패턴 11, 12 | `onClose/title/width/height` 전체 → `handleClose/customHeaderTitle/size={800}/customContentArea` 신 prop |
| `components/modals/PrModal.tsx` | §3 패턴 11, 12 | `onClose/title/width=1100/height/buttons` → `handleClose/handleSubmit/customHeaderTitle/size={1000}/customContentArea` |
| `components/modals/SspSyncCompareModal.tsx` | §3 패턴 12 | `onClose/title/width=1200/height/buttons` → `handleClose/customHeaderTitle/size={1200}/customContentArea` |
| `components/modals/SspSyncModal.tsx` | §3 패턴 11, 12 | `onClose/title/width=1100/height/buttons` → `handleClose/customHeaderTitle/size={1000}/customContentArea` |
| `utils/longToPivot.ts` | §2 패턴 7 | line 97/98 `as Record<string, unknown>)` → `as unknown as Record<string, unknown>)` (replace_all 2회) |

## 패턴 적용 0 건 (false positive 또는 이미 정상)

| 패턴 | 결과 |
|---|---|
| §1 패턴 1 (`tabId` 누락) | ✓ 모든 호출 (`useTabProcQuery` 3 + `useProcMutation` 0) 의 `tabId` 이미 있음 |
| §1 패턴 2 (Modal `callFromCell`) | ✓ ProjectByDivisionModal / ItemByDivisionModal 모두 `callFromCell={true}` 명시 |
| §1 패턴 4 (`setSelectedValue` 4 인자) | ✓ 4 인자 시그니처 (project, projectName, projectStatus, bizTypeName) 사용 |
| §2 패턴 8 (`<DataGrid<XxxType>>` generic) | ✓ DataGrid 사용 0 (모두 FlexGrid 직접 사용 + generic 명시 X) |
| §2 패턴 9/10 (`[key:string]:WijmoPrimitive`) | ⚠ CarRow / PsiRow 에 `[key: string]: string \| number` 있음. WijmoRowItem 와 정확 일치 X 지만 DataGrid<T> 사용 안 함 → 차단 X. 향후 cleanup 권장 |
| §3 패턴 13 (DatePickerCalendar) | ✓ 카탈로그 SearchFields 사용 (직접 호출 X) |
| §3 패턴 14 (`RESPONSE_SET.CUD`) | ✓ 사용 0 |
| §4 패턴 15-17 (eslint) | ⚠ no-base-to-string 잠재 (longToPivot 의 `String(row.QTY ?? 0)` 등) — 사용자 lint-staged 결과에 따라 추가 fix 가능 |

## 적용 방법

### Option A — Patch 적용

```bash
# Git Bash (cloud PC)
cd /c/Projects/NSCM/nscm-fe
git apply --check <USB>/dmf0003_typecheck_fix.patch
git apply <USB>/dmf0003_typecheck_fix.patch
```

### Option B — File 단위 복사

```powershell
# PowerShell (cloud PC)
$src = "<USB>\dmf0003_typecheck_fix\full_files"
$dst = "C:\Projects\NSCM\nscm-fe"
Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
```

### 검증 + Push

```powershell
cd C:\Projects\NSCM\nscm-fe\features\demand
pnpm type-check  # 0 errors 기대

cd C:\Projects\NSCM\nscm-fe
git add -A
git commit -m "fix(DMF0003): MKT FCST type-check 17 패턴 보완 (10 file)"
git push -u origin fix/lint-cleanup-20260608
```

## 룰 적용 효과

이번 보완은 `type-check-error-patterns.md` 17 패턴 룰의 첫 번째 cycle 적용. 작업 시간:
- DMF0003 fix 약 15 분 (master 60+ errors 16 시간 대비)
- cloud type-check 호출 0 (룰 §6 grep 으로 PRE-WRITE 자동 검출)

룰 자가 진화 (`type-check-error-patterns.md §9`) 효과 검증 — 새 패턴 발견 시 §1~§5 에 추가.
