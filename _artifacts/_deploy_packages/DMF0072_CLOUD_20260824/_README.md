# DMF0072 (NN Master Mapping) 클라우드 이관 — **FE 축만** (2026-08-24)

> 화면 = `features/master/src/pages/nn-master-mapping` (AS-IS DMF0072 NN Master Mapping).
> 본 폴더는 요청대로 **FE 폴더를 저장소 경로 구조 그대로** 재구성한 것이다(DMF0082 와 동일 방식).
> ⚠ **DB 축(PKG/메타/배선)은 포함하지 않았다** — 별도 요청 시 `make_cloud_package_full.py --menu DMF0072` 로 뜬다.

## 1. 구성 — **최신 공통소스 기준 재판정 (2026-08-24)**

`B_FE/` 아래 경로 = 그대로 배포 경로. 최신 공통소스(`common` HEAD `badd49a0`)와 63본을 전수 대조했다.

| 판정 | 본수 | 처리 |
|---|---:|---|
| 공통 최신과 **바이트 동일** | **53** | 이관 불필요 — 제외 |
| 우리 것이 공통의 상위집합 / 공통에 없는 신규 | **6** | `B_FE/` — 그대로 덮는다 |
| 공통에만 있는 코드 보유 | **4** | `B_FE_MERGE/` — ⛔ 병합 |

⭐ **화면 폴더 11본 중 이관 대상은 1본뿐**이다(`NnMasterMappingForm.module.scss`, 공통에 없는 신규 56줄).
나머지 10본은 이미 공통에 반영돼 있다.

⚠ **`NnMasterMapping.tsx` 는 공통이 더 최신이었다.** 저장 확인 문구가 공통은 표준
`CRUD_MSG.SAVE_CONFIRM`(행 수를 묻지 않음 — 2026-08-23 사용자 요구)인데 사내 사본은 구
`MSG00617 '{0} 행을 저장하시겠습니까?'` 였다. **사내 트리를 공통본으로 맞췄고**(백업
`_artifacts/_backup/COMMON_SEARCHFIELDS_20260824/NnMasterMapping.tsx.OURS_BAK`), 이관 대상에서 뺐다.

## 2. FE 이관 경로 상세 (폴더·파일 단위)

### ① 화면 폴더 — **폴더 통째** (`index.ts` 가 viewRegistry 등록 키)

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/features/master/src/pages/nn-master-mapping/components` | **`nscm-fe/features/master/src/pages/nn-master-mapping/components`** | 1 | `NnMasterMappingForm.module.scss` |

### ② 공용 — 화면이 실제로 닿는 **변경분 폐포**(기계 산출). 미변경 공용은 클라우드 것을 그대로 둔다

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/packages/foundation/src/utils` | **`nscm-fe/packages/foundation/src/utils`** | 1 | `string.ts` |
| `B_FE/packages/shared/src/components/organisms` | **`nscm-fe/packages/shared/src/components/organisms`** | 1 | `index.ts` |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid` | **`nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid`** | 2 | `OlapPivotGrid.tsx`, `olapUtils.ts` |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal` | **`nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal`** | 1 | `columnLayoutModal.utils.ts` |


## 3. ⭐ `features/master/src/components/` 는 **의도적으로 제외**했다 (33본)

폐포에는 잡히지만 넣지 않았다. 최신 공통소스(`common` = `eunjoo-hwang/nscm-fe`, HEAD `badd49a0`)를
직접 받아 대조한 결과 **공통 쪽이 우리 것의 상위 집합**이기 때문이다.

- 공통에는 `CascadeFields` / `useCascadeFields` 가 있고 우리 사본에는 **없다**
- `cascade` prop(EndCustomer / SalesSite / PlantSite)은 **양쪽 동일**(2026-08-22 같은 계보)
- 실차이는 `SearchFields.tsx` 15줄 — division 자동보정 1건이며 공통이 **2026-08-23 사용자 요청으로 제거**한 것

2026-08-23 에 이걸 우리 구본으로 덮었다가 `sales-site-project-model` 과 `mkt-fcst` 가
`TS2305 has no exported member 'CascadeFields'` 로 두 번 깨졌다. **클라우드 것을 그대로 둘 것.**

### ① 화면 폴더 — **폴더 통째** (`index.ts` 가 viewRegistry 등록 키)

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/features/master/src/pages/nn-master-mapping` | **`nscm-fe/features/master/src/pages/nn-master-mapping`** | 7 | `NnMasterMapping.module.scss`, `NnMasterMapping.tsx`, `__asis-mapping__.md`, `index.ts`, `nn-master-mapping.constants.ts`, `nn-master-mapping.types.ts`, `useNnMasterMappingStore.ts` |
| `B_FE/features/master/src/pages/nn-master-mapping/components` | **`nscm-fe/features/master/src/pages/nn-master-mapping/components`** | 3 | `NnMasterMappingForm.module.scss`, `NnMasterMappingForm.tsx`, `NnMasterMappingGrid.tsx` |
| `B_FE/features/master/src/pages/nn-master-mapping/utils` | **`nscm-fe/features/master/src/pages/nn-master-mapping/utils`** | 1 | `nn-master-mapping.merge.ts` |

### ② 공용 — 화면이 실제로 닿는 **변경분 폐포**(기계 산출). 미변경 공용은 클라우드 것을 그대로 둔다

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/packages/foundation/src/apis` | **`nscm-fe/packages/foundation/src/apis`** | 1 | `axios.ts` |
| `B_FE/packages/foundation/src/constants` | **`nscm-fe/packages/foundation/src/constants`** | 4 | `button-type.ts`, `column-config.ts`, `index.ts`, `message-id.ts` |
| `B_FE/packages/foundation/src/lib` | **`nscm-fe/packages/foundation/src/lib`** | 1 | `query-client.ts` |
| `B_FE/packages/foundation/src/styles` | **`nscm-fe/packages/foundation/src/styles`** | 1 | `common-styles.module.scss` |
| `B_FE/packages/foundation/src/utils` | **`nscm-fe/packages/foundation/src/utils`** | 6 | `columnMapping.ts`, `editTracker.ts`, `gridAction.ts`, `gridUtils.ts`, `mergeManager.ts`, `string.ts` |
| `B_FE/packages/shared/src/components/molecules/columnSelectDualList` | **`nscm-fe/packages/shared/src/components/molecules/columnSelectDualList`** | 2 | `ColumnSelectDualList.module.scss`, `ColumnSelectDualList.tsx` |
| `B_FE/packages/shared/src/components/molecules/customDropdown` | **`nscm-fe/packages/shared/src/components/molecules/customDropdown`** | 2 | `CustomDropdown.tsx`, `CustomDropdownMui.module.scss` |
| `B_FE/packages/shared/src/components/molecules/customDropdown/components` | **`nscm-fe/packages/shared/src/components/molecules/customDropdown/components`** | 3 | `CustomListbox.module.scss`, `CustomListbox.tsx`, `CustomListboxRow.tsx` |
| `B_FE/packages/shared/src/components/molecules/dialog` | **`nscm-fe/packages/shared/src/components/molecules/dialog`** | 1 | `CustomDialog.tsx` |
| `B_FE/packages/shared/src/components/organisms` | **`nscm-fe/packages/shared/src/components/organisms`** | 1 | `index.ts` |
| `B_FE/packages/shared/src/components/organisms/alert` | **`nscm-fe/packages/shared/src/components/organisms/alert`** | 1 | `Alert.tsx` |
| `B_FE/packages/shared/src/components/organisms/data-grid` | **`nscm-fe/packages/shared/src/components/organisms/data-grid`** | 4 | `DataGrid.tsx`, `dataGridUtils.ts`, `gridContextMenu.ts`, `titleSetApi.ts` |
| `B_FE/packages/shared/src/components/organisms/main-title` | **`nscm-fe/packages/shared/src/components/organisms/main-title`** | 1 | `MainTitle.tsx` |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid` | **`nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid`** | 2 | `OlapPivotGrid.tsx`, `olapUtils.ts` |
| `B_FE/packages/shared/src/components/organisms/result-area` | **`nscm-fe/packages/shared/src/components/organisms/result-area`** | 3 | `ResultArea.module.scss`, `ResultArea.tsx`, `ResultArea.types.ts` |
| `B_FE/packages/shared/src/components/organisms/search-area` | **`nscm-fe/packages/shared/src/components/organisms/search-area`** | 1 | `SearchArea.tsx` |
| `B_FE/packages/shared/src/components/organisms/sub-title` | **`nscm-fe/packages/shared/src/components/organisms/sub-title`** | 1 | `SubTitle.tsx` |
| `B_FE/packages/shared/src/components/organisms/toast-message` | **`nscm-fe/packages/shared/src/components/organisms/toast-message`** | 1 | `ToastMessage.tsx` |
| `B_FE/packages/shared/src/components/templates` | **`nscm-fe/packages/shared/src/components/templates`** | 1 | `index.ts` |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal` | **`nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal`** | 3 | `ColumnLayoutModal.module.scss`, `ColumnLayoutModal.tsx`, `columnLayoutModal.utils.ts` |
| `B_FE/packages/shared/src/hooks` | **`nscm-fe/packages/shared/src/hooks`** | 6 | `index.ts`, `useClearAppData.ts`, `useCustomQueryClient.ts`, `useInsertedRows.ts`, `useSaveWithValidation.ts`, `useTabBtnPermissions.ts` |
| `B_FE/packages/shared/src/lib` | **`nscm-fe/packages/shared/src/lib`** | 2 | `lges.ts`, `mui.ts` |
| `B_FE/packages/shared/src/stores` | **`nscm-fe/packages/shared/src/stores`** | 4 | `index.ts`, `useDirtyRegistry.ts`, `useMessageStore.ts`, `useSessionStore.ts` |



## 4. 덮기 전 필수

```
# 배포 루트(nscm-fe) 에서
node <이 폴더>/_precopy_export_guard.mjs <이 폴더>/B_FE
```

대상 파일이 내보내던 심볼 중 **사라지는 것**을 `LOST` 로 찍는다. 한 줄이라도 나오면 그 파일만 병합한다.

## 5. FE 검증

`type-check` **13/13 성공 · error 0** / `lint` **13/13 성공 · error 0**(warning 193, 기존분).
원문 = `_survey/fe_check_20260823.txt` · 도구 = `_artifacts/_tools/fe-check.ps1`(넥서스 미접속).
⚠ 사내 트리 기준이다. 적용 후 클라우드에서 `pnpm exec turbo run type-check --continue` 로 재확인할 것.

## 6. 범위 밖

- DB 축(PKG_DMF0072 / SHEET_COLUMNS / 배선·권한 / MSG·LBL) — 본 패키지 미포함
- `features/master/src/components/**` 33본 — §2 사유로 제외
- 미변경 공용 — 클라우드 것이 이미 동일

### 🔁 `B_FE_POOL/` — 클라우드가 뒤처졌을 때만 쓰는 예비분 (2026-08-24 신설)

**클라우드 트리는 사내와도, 공통소스와도 다르다.** 실사고 3연발이 그걸 증명했다.

| 방향 | 실사고 | 증상 |
|---|---|---|
| 클라우드가 **앞섬** | `CascadeFields` / `useCascadeFields` (클라우드에만) | 우리 것으로 덮어 **TS2305** ×2 |
| 클라우드가 **뒤처짐** | `CELL_CONTROL_TYPE.TEXT_MODAL` (공통엔 있는데 클라우드엔 없음) | **TS2339** |

그래서 "무엇을 올릴지"는 사내에서 다 정할 수 없다 — **클라우드에서 판정해야** 한 번에 끝난다.

- `B_FE/` … 반드시 덮는다 (우리가 앞서거나 클라우드에 없는 신규)
- `B_FE_POOL/` … 사내 = 공통소스가 **완전히 같은** 파일들. 클라우드가 최신이면 **아무것도 안 올린다**
- `B_FE_MERGE/` … ⛔ 덮기 금지, 병합

```
# 배포 루트(nscm-fe) 에서
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL           # 진단만 (SAME / STALE / MISSING)
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL --apply   # 다른 것만 실제 복사
```

`STALE`/`MISSING` 로 잡힌 것만 최신화되므로 클라우드 고유 작업을 덮지 않는다.
이번 `TEXT_MODAL`(TS2339) 도 `packages/foundation/src/constants/column-config.ts` 가
`STALE` 로 잡혀 한 번에 해소된다.

**권장 순서**: ① `_precopy_export_guard.mjs` → ② `B_FE/` 덮기 → ③ `_cloud_gap_check.mjs --apply`
→ ④ `B_FE_MERGE/` 병합 → ⑤ `pnpm exec turbo run type-check --continue`
