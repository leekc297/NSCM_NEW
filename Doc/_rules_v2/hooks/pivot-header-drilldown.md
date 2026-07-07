# Hook #103 — PIVOT 그리드 헤더 드릴다운 표준 (합계 헤더 클릭 → 하위 버킷 펼침/접힘)

> 신설: 2026-07-03 (DMF0003 SUM 헤더 드릴다운 구현 — AS-IS spdMain_CellDoubleClick e.ColumnHeader L3416~3455 1:1)
> 트리거: T01 / T01M / T04 — 기간 PIVOT(D_/W_/M_ 등 버킷 동적 컬럼) 그리드에 헤더 드릴다운을 구현할 때
> 짝: #93 grid-multi-tier-header-height / #92 column-division-id-visibility / feedback_grid_combo_datamap_wiped_by_wrapper

## §0. AS-IS 동작 (정본)

- **M_(월 합계) 헤더 더블클릭** → 해당 월 구간(다음 M_ 전까지)의 **W_ 컬럼 visible 토글** + 보이는 D_ 는 **접기만**
- **W_(주) 헤더 더블클릭** → 해당 주 구간(다음 W_/M_ 전까지)의 **D_ 컬럼 visible 토글**
- AS-IS(FarPoint)는 전 버킷 컬럼이 스프레드에 **항상 존재**하고 `SetSpreadColumn` 이 Visible 만 제어 — 드릴은 그 위의 개별 flip

## §1. TO-BE 구현 표준 (Wijmo + 공용 DataGrid wrapper)

| # | 규칙 | 이유 |
|---|---|---|
| 1 | **전 버킷 컬럼(D/W/M) 상시 렌더** — 버킷별 컬럼 필터링(allowedKinds 분기) 금지 | 드릴 대상이 존재해야 펼침 가능. SPREAD_TITLE 류 SP 는 원래 전체 버킷을 반환(실측 후 채택) |
| 2 | **표시 규칙 rank 분리**: `DYN_RANK = {M:0, W:1, D:2}` — 활성 버킷 kind=표시 / 상위(rank<bucket)=합계 → Sum 체크 토글 / 하위(rank>bucket)=기본 숨김 | "합계 = kind≠활성 전부" 는 하위 버킷까지 Sum 에 묶이는 오류 |
| 3 | **드릴 오버라이드**: `drillVisRef: Map<binding, boolean>` — 헤더 더블클릭 시 구간 walk(dynBindings interleave 순서) 하며 flip 값 기록 | 개별 컬럼 flip = AS-IS 1:1 (그룹 단위 상태 아님) |
| 4 | **통합 적용 함수 1곳**: `applyDynVisibility()` = base(규칙 2) 에 오버라이드 우선 적용 — `updatedLayout` 핸들러로 **매 레이아웃 재적용** (wrapper columnGroups 재적용이 visible 을 덮는 것 방어 — dataMap 재부착과 동일 가드 패턴) + ref 로 노출해 드릴 핸들러가 즉시 호출 | imperative flip (컬럼그룹 rebuild 금지 — 스크롤/폭/데이터맵 보존) |
| 5 | **드릴 리셋**: bucket/Sum/조회(동적 메타) 변경 시 `drillVisRef.clear()` | AS-IS SetSpreadColumn 재실행과 등가 |
| 6 | **헤더 판정**: `hitTest(ev).cellType === CellType.ColumnHeader` → `g.columns[ht.col].binding` 의 kind 로 분기 — 그룹(월/주차) 헤더 클릭도 leaf 컬럼으로 해석되므로 별도 처리 불요 | |

## §2. 구간 walk 의사코드 (AS-IS 1:1)

```ts
const idx = dynBindings.indexOf(clicked);
for (let i = idx + 1; i < dynBindings.length; i++) {
  const t = dynBindings[i], tk = dynKindOf(t);
  if (clickedKind === 'M') {
    if (tk === 'M') break;
    if (tk === 'W') flip(t);            // 토글
    else if (tk === 'D') flip(t, hideOnly); // 보이는 경우만 접기
  } else { // 'W'
    if (tk === 'W' || tk === 'M') break;
    if (tk === 'D') flip(t);
  }
}
applyDynVisibilityRef.current?.();
```

## §3. 전제·주의

- dynBindings 는 **M→W→D interleave (AS-IS 스프레드 순서)** 이어야 walk 가 성립 — SP SORT(_01/_21/_31) 기준 정렬 유지.
- 전 버킷 상시 렌더로 **recalc/merge/필터 보행 범위가 넓어짐** — 해당 유틸이 kind 분기를 이미 갖는지 확인(AS-IS 도 전 컬럼 존재였으므로 동작 등가가 정상). 하위 버킷 셀 편집 가능 여부는 기존 editLock/evalDynCell 규칙을 그대로 따른다.
- 3년 조회 시 D_ 컬럼 ~1,000개 렌더(숨김) — Daily 버킷과 동일 수준(기존 허용 범위).

## §4. PRE-WRITE / POST-WRITE

- PRE: ①메인 SP 가 전 버킷 데이터 키를 반환하는지 실측했는가 ②표시 규칙이 rank 분리인가 ③적용 함수가 updatedLayout 재적용인가 ④리셋 3트리거(bucket/sum/조회) 있는가
- POST: 드릴 → Sum 체크 토글 → 드릴 초기화 확인 / 버킷 전환 → 초기화 확인 / 재조회 → 초기화 확인

레퍼런스 구현: `nscm-fe/features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx` (allowedKinds/DYN_RANK/drillVisRef/applyDynVisibility/dblclickHandler 헤더 분기).

## §5. ⭐ 동적 PIVOT 컬럼 Excel export `visible: true` 필수 (2026-07-06 DMF0043 사고)

동적 기간/PIVOT 컬럼(`buildDynamicColumns`)에 **`visible: true` 를 명시하지 않으면 Excel 다운로드 시 hidden 처리**된다.

**원인**: 공통 `GridAction.excelDownload`(`@foundation/utils/gridAction.ts`)가 export 컬럼을 `new Column({ visible: columnGroup.visible })` 로 재생성 → columnGroup config 의 `visible` 이 **undefined** 면 Wijmo 가 hidden. 정적 컬럼은 SHEET_COLUMNS meta 에서 `visible:true` 라 표시되지만, 동적 컬럼은 미명시 시 화면엔 보이나(Wijmo 기본 true) **export 에서만 숨김**.

**의무**: 동적 컬럼 config 의 **group + leaf 둘 다 `visible: true`** 명시.
```tsx
return {
  header: leaf.periodLabel, align: 'center', height: 24,
  visible: true,                                            // ⭐ group
  columns: [{ binding: leaf.binding, ..., visible: true }], // ⭐ leaf
};
```
- 정상 선례: DMF0048 `SalesMonitoringGrid.tsx`(동적 컬럼 `visible: true` 명시). 사고: DMF0043 `ContributeMainGrid.tsx`(미명시 → 동적 기간컬럼 Excel 숨김).
- 검증: Excel 다운로드 후 정적(B~) 다음 **동적 컬럼이 hidden 아닌지** 육안. 다단 헤더 유지는 gridAction `headerDepth>1` 경로가 처리.
- 메모리 `feedback_grid_dynamic_column_visible_excel.md`.
