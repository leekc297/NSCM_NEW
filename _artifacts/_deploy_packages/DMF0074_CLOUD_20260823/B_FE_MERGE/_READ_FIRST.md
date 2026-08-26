# ⛔ 병합 대상 4본 — 덮어쓰지 말 것

최신 공통소스(`common` = `eunjoo-hwang/nscm-fe`, HEAD `badd49a0`) 기준으로 재판정한 결과,
이 5본은 **공통 쪽에만 있는 코드가 있어** 우리 것으로 덮으면 그 부분이 사라진다.
각 파일 옆의 `*.COMMON.txt` 가 **공통 최신 원본**이다 — 그걸 기준으로 우리 변경만 얹으면 된다.

| 파일 | 공통에만 있는 것 (덮으면 사라짐) | 우리가 넣어야 하는 것 |
|---|---|---|
| `packages/shared/.../customDropdown/components/CustomListboxRow.tsx` | 39줄 | 10줄 |
| `packages/shared/.../organisms/data-grid/dataGridUtils.ts` | `CELL_CONTROL_TYPE.MODAL` 셀 컨트롤 처리 2곳 | 10줄 |
| `packages/shared/.../column-layout-modal/ColumnLayoutModal.tsx` | `HIDDEN_FROM_LIST` 필터 3곳 | 22줄 (zero-width 접목) |
| `packages/shared/src/stores/useDirtyRegistry.ts` | `MSG00703` close 문구 1줄 | 1줄 |

⚠ DMF0074 는 `procedures.d.ts` 변경이 없다(diff 내 `DMF0074` 0건) — 이관 대상 아님.

## 판정 근거

`B_FE` 에 남은 7본은 둘 중 하나다.
- **화면 폴더**(`forecast-price/**`) = 우리가 주인 → 그대로 덮는다
- **공용인데 우리 것이 공통의 상위 집합**(공통에만 있는 줄 0) → 덮어도 유실 없음
  (`string.ts` +17 / `organisms/index.ts` +4 / `columnLayoutModal.utils.ts` +29 / `olap-pivot-grid` 신규 2본)

나머지 **60본은 공통 최신과 바이트 동일**이라 이관 자체가 불필요해 제외했다.
