# 공통소스 다운로드 적용 보고 — 2026-09-16

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push`) |
| 직전 기준선 | `2a96a90c` (2026-09-15 09:20) |
| **신규 기준선** | **`cb0ee783` (2026-09-16 09:19 "주석")** |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 + `configs/types/procedures.d.ts` (부수 1줄) |
| 변경 파일 | 101 (M 97 / A 4) |
| 정적검증 | **미수행** (사용자 상시 지시 2026-09-02 — 요청 시 `fe-check.ps1`) |

## 1. 분류 요약

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 (로컬=직전기준선) | 87 | 공통본 그대로 덮어쓰기 |
| 이미 동일 (로컬=공통 신본) | 2 | 변경 없음 |
| 3-way 병합 (로컬 편집본) | 8 | 자동 7 + 수동해소 1 |
| 신규 파일 | 4 | 추가 |

## 2. 이미 동일 (공통이 내 소스를 역수입한 결과)

- `features/demand/src/pages/forecast-price/forecast-price.constants.ts`
- `features/demand/src/pages/sales-reports/utils/sales-reports.merge.ts`

## 3. 3-way 병합 8건 — base = '로컬이 실제 출발한 공통 판본'

| 파일 | base | 결과 |
|---|---|---|
| `features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx` | `bf0e27f0` (09-15 11:28 fix :엑셀 업로드 메세지 변경) | 자동 병합 (충돌 0) |
| `features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx` | `c2210452` (09-15 15:49 fix: 49, 55, 56, 76 번 추가 개선사항 작업) | 자동 병합 (충돌 0) |
| `features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx` | `c2210452` (09-15 15:49 fix: 49, 55, 56, 76 번 추가 개선사항 작업) | 자동 병합 (충돌 0) |
| `features/demand/src/pages/sales-reports/SalesReports.tsx` | `c2210452` (09-15 15:49 fix: 49, 55, 56, 76 번 추가 개선사항 작업) | 자동 병합 (충돌 0) |
| `features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx` | `03e57138` (08-31 09:29 동기화) | **충돌 2 → COMMON 채택** |
| `packages/foundation/src/utils/gridAction.ts` | `06eeb630` (09-14 15:02 fix: excel form 양식 as-is와 동일하게 수정) | 자동 병합 (충돌 0) |
| `packages/shared/src/components/organisms/data-grid/DataGrid.tsx` | `b4f66354` (09-10 18:13 fix: 194번 필터 이슈 수정, 상한값 증가 및 clear시 발생하는 레이아웃 에러 수정) | 자동 병합 (충돌 0) |
| `packages/shared/src/components/organisms/data-grid/dataGridUtils.ts` | `58e9775d` (09-14 14:28 feat(data-grid): FPTextModal 셀에도 FPModal과 동일한 오픈 아이콘 표시) | 자동 병합 (충돌 0) |

### 3.1 수동 해소 1건 — `PriceBatchInputModal.tsx`

- **LOCAL**: 조회 후 client-side 재필터(`siteFilter`/`projectTokens`/`itemId`) 유지 + `'ALL'` sentinel 제거 보정(2026-08-24 내 수정).
- **COMMON**: client-side 재필터 **전면 제거** — "재확인 필터가 콤마·다중 조건을 온전히 반영 못 해 결과를 잘못 좁힌다"
  (`2645e03e` 09-04 / `4dd8f82e` 09-07).
- **판정 = COMMON 채택.** SP 로 `scmSiteId`/`projectCode`(`'^'` 다중) / `itemId` 를 이미 넘기고 있어 서버 필터가 정본이고,
  공통 해법이 내 ALL-sentinel 수정을 포함하는 상위 해법이며 시점도 더 최신(09-04/09-07 > 08-24).
- 해소 후 `siteFilter` 잔존 참조 0건 확인.

## 4. 신규 파일 4 (SCP0021 Project Route 일괄저장 모달)

- `features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.module.scss`
- `features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx`
- `features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts`
- `features/supply/src/pages/project-route/utils/projectRoute.plantSaveRequest.ts`

`ProjectRoute.tsx` 가 `./components/modals/ProjectRouteListSaveModal` · `./utils/projectRoute.plantSaveRequest` 를 import — 참조 해소 확인 완료.

## 5. 부수 반영 — `configs/types/procedures.d.ts`

공통 변경 1줄(`COM0012.project.request.projectCode?: string`) 을 로컬 d.ts 의 동일 블록에 삽입.
(4폴더 밖이지만 위 Project 모달 변경분의 타입 계약이라 동반 반영.)

## 6. 병합 무결성 점검

| 점검 | 결과 |
|---|---|
| 충돌 마커 잔존 | 0 |
| 병합 유래 선언 중복(merged > max(local, common)) | 0 |
| import 경로 해소(신규 4파일) | OK |
| 개행 정규화 후 대조 (CRLF/LF 혼재 대응) | 적용 |

## 7. 원복 자료

- `local_before/` — 대상 97 파일의 **적용 직전 로컬 원본** (신규 4는 원본 없음 → 삭제로 원복)
- `local_worktree.patch` — nscm-fe 워크트리 전체 diff (HEAD 기준)
- `local_git_head.txt` / `local_git_status.txt`

원복: `local_before/` 를 `nscm-fe/` 위에 덮어쓰기 + 신규 4파일 삭제 + d.ts 삽입 1줄 제거.
