# UI 백업 — DMF0082 / DMF0014 / DMF0074 (2026-08-23)

> 목적: **소스 전체를 최신본으로 교체한 뒤**, 이 3개 화면의 수정분만 다시 얹기 위한 백업.
> 기준 커밋 = `7653e1b` (`C_PATCH/00_base_commit.txt`). 백업 시점 = 워킹트리 현재 상태(미커밋 변경 포함).

## 담긴 것

| 폴더 | 내용 | 파일 |
|---|---|---:|
| `A_SCREENS/forecast-price/` | **DMF0082** Fcst & Price — 화면 폴더 **전체** | 31 |
| `A_SCREENS/customer-fcst-upload/` | **DMF0014** Customer Fcst Upload — 폴더 전체 | 13 |
| `A_SCREENS/metal-link-price/` | **DMF0074** Metal Link Price — 폴더 전체 | 13 |
| `B_SHARED/` | 위 3화면이 의존하는 **공용 변경 파일** (원본 상대경로 그대로) | 21 |
| `C_PATCH/` | `git diff HEAD` 패치 2본 + 신규(untracked) 파일 목록 + 기준 커밋 | 4 |
| `_MANIFEST.md` | 전 파일 md5 체크섬 | — |

폴더 전체를 담은 이유: 부분 이관 시 `pages/<화면>/index.ts` 누락으로 클라우드 `resolveView()` 가
"Page Not Found" 를 내는 사고 계보가 있다 — **화면 단위 이관은 항상 폴더 전체**.

## B_SHARED 상세 (⚠ 전 화면 공용 — 최신본에 덮어쓰기 전 반드시 대조)

| 파일 | 이 3화면과의 관계 |
|---|---|
| `features/master/src/components/searchFields/SearchFields.tsx` | 조회조건 카탈로그. **2026-08-23 복구 작업분 포함** — `cascade`/`debugLabel`/`disabled` prop 신설, `VersionField.versionNo` 추가 (type-check 실패 정정, 작업 중단 시점 상태) |
| `features/master/src/components/searchFields/SearchFields.debug.ts` | **신규 파일**. 화면들이 import 하는데 리포지토리에 없어 TS2307 발생 → 계약만 되살린 no-op 구현 |
| `features/master/src/components/searchFields/{SearchFields.utils.ts, .module.scss, index.ts}` | 카탈로그 동반 파일 (미변경분 포함 — 폴더 정합용) |
| `features/master/src/components/columnLayoutModal/*` | Column Setting 모달 재수출 스텁 (DMF0082 가 shared 정본을 직행 import 하도록 전환) |
| `packages/foundation/src/constants/column-config.ts` | 셀 컨트롤 `FPTextModal` 신설 (DMF0082 `ITEM_ID`) |
| `packages/foundation/src/utils/mergeManager.ts` | 빈 셀 병합 opt-in 지점 (DMF0082 Sender Name) |
| `packages/shared/src/components/organisms/data-grid/{DataGrid,dataGridUtils}.ts(x)` | `FPTextModal` 셀 처리(타이핑 허용 + 돋보기 아이콘) |
| `packages/shared/src/components/organisms/{index.ts, olap-pivot-grid/*}` | 배럴 export + 동반 파일 (배럴만 이관 시 resolve 실패) |
| `packages/shared/src/components/templates/modals/column-layout-modal/*` | Column 모달 **정본** (+ zeroWidth 회귀 테스트 신규) |
| `packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx` | 조회조건 콤보 |
| `packages/shared/src/stores/useDirtyRegistry.ts` | 재조회 confirm 메시지 `MSG00703` → `MSG01016` |
| `configs/types/procedures.d.ts` | 3화면 프로시저 타입 (타 화면 선언 포함) |

## 최신본 교체 후 재적용 절차

1. **최신본 받기** — 이때 아래 폴더는 최신본에 없을 수 있고, 있으면 type-check 를 깨뜨리므로 정리 대상:
   `features/demand/src/pages/BACKUP_20260818/`, `BACKUP_20260823/` (실측 TS2307 9건 원인)
2. **화면 3개 = 폴더 통째로 복사** (부분 파일 복사 금지)
   ```
   A_SCREENS/forecast-price/        → nscm-fe/features/demand/src/pages/forecast-price/
   A_SCREENS/customer-fcst-upload/  → nscm-fe/features/demand/src/pages/customer-fcst-upload/
   A_SCREENS/metal-link-price/      → nscm-fe/features/demand/src/pages/metal-link-price/
   ```
   ⚠ `forecast-price/utils/forecast-price.excelForm.test.ts` 는 **삭제된 파일**이다(백업에도 없음).
   최신본에 남아 있으면 지운다.
3. **공용 파일은 덮어쓰기 금지 — 3-way 대조** (`B_SHARED` = 우리 변경분, 최신본 = 남의 변경분 포함)
   ```
   diff -u <최신본 파일> B_SHARED/<같은 경로>
   ```
   충돌 시 `C_PATCH/02_shared.patch` 의 해당 hunk 만 골라 적용한다.
4. **패치 방식 대안** — 최신본이 `7653e1b` 계보를 그대로 이어받았다면:
   ```
   git apply --3way C_PATCH/01_screens.patch
   git apply --3way C_PATCH/02_shared.patch
   ```
   신규 파일 2개(`C_PATCH/03_untracked_new_files.txt`)는 패치에 없으니 `B_SHARED` 에서 직접 복사.
5. **검증**
   ```
   pnpm type-check          # 기대: 3화면·공용 관련 에러 0
   ```
   ⚠ 백업 시점의 알려진 미해결 = `SearchFields` prop 복구 작업이 **진행 중 중단** 상태다.
   `cascade`/`debugLabel`/`disabled`/`versionNo` 구현은 들어갔으나 **type-check 재실행 전**이다
   (@master/@report/@demand 잔여 에러 가능). 재적용 후 이어서 확인할 것.

## 관련 이관 패키지 (DB 축 포함 최신본)

| 화면 | 패키지 | 상태 |
|---|---|---|
| DMF0082 | `_deploy_packages/DMF0082_CLOUD_20260823/` | 취합 완료 / 클라우드 미적용 |
| DMF0074 | `_deploy_packages/DMF0074_CLOUD_20260820/` | 취합 완료 / 클라우드 미적용 |
| DMF0014 | `_deploy_packages/DMF0014_CLOUD_20260818/` | 취합 완료 / 클라우드 미적용 |

⚠ `DMF0074_CLOUD_20260820/B_FE/metal-link-price/` 는 워킹트리보다 **신본**이다
(`TEMPLATE_EMPTY: 'MSG01015'` vs 워킹트리 `'MSG00656'` 등 9파일 상이 — 2026-08-23 11:01 워킹트리 되돌림 사고).
재적용 시 **패키지본을 우선**하고 백업본과 대조할 것.
