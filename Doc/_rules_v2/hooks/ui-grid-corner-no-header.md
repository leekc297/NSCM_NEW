# Hook #108 — ui-grid-corner-no-header (그리드 No. 코너 헤더 머지+라벨 공통 표준) ⭐ 2026-07-08 신설

> **트리거**: T01(신규 화면) / T01M(화면 수정) / grid / 헤더 머지 / 다단 헤더 / MergeManager / "No." 컬럼
> **지위**: 사용자 지정 공통 적용 사항 (2026-07-08 — "No. 헤더(좌상단 코너) 가로/세로 머지+라벨은 공통 적용 사항으로 Rule 지정")
> **정본 구현**: `features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx` (DMF0020 환율 Modal)
> 선례: `ContributeViewGrid.tsx`(setCellData 'No') / `auth-request.grid-utils.ts`(attachRowNoHeader)

---

## §1. No. 코너(TopLeft) 가로/세로 머지 + 라벨 — 전 그리드 공통 의무

rowHeader(순번) 컬럼을 쓰는 **모든** 그리드는 좌상단 코너(TopLeft 패널)를 다음 표준으로 처리한다:

1. **머지**: TopLeft 패널 전체(rowHeader 컬럼 수 × 헤더 행 수)를 **단일 셀**로 가로/세로 머지.
   다단(2단/3단) 헤더든 rowHeader 가 2컬럼(순번+CRUD 상태)이든 항상 전체 1셀.
2. **라벨**: 머지된 셀에 **'No.'** 표기 + 중앙 정렬.
3. 구현 위치: 화면의 커스텀 MergeManager `getMergedRange` + `formatItem`.

```ts
// ── MergeManager (getMergedRange 최상단) ──
if (panel.cellType === CellType.TopLeft) {
  return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
}

// ── formatItem (재귀 방지 가드 필수 — setCellData 가 invalidate 를 유발) ──
if (e.panel.cellType === CellType.TopLeft) {
  if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
  e.cell.style.textAlign = 'center';
}
```

- 커스텀 MergeManager 가 **없는** 단순 그리드: formatItem 라벨(위 2번)만으로 충분(1단 헤더 × 1 rowHeader 컬럼이면 머지 불필요). 다단 헤더/2 rowHeader 컬럼이면 MergeManager 신설 포함 의무.
- `allowMerging=AllowMerging.All` prop 전달 의무 (wrapper 가 매 렌더 기본값으로 되돌리는 함정 — DMF0020 선례 주석 참조).

## §2. ⚠️ 커스텀 MergeManager 설치 = nested 그룹 네이티브 span 무효 (동반 함정)

`grid.mergeManager = new CustomXxx()` 를 설치하면 **wijmo 기본 MergeManager 가 담당하던
nested columnGroups(년→월, 년월→주차)의 1단 헤더 수평 span 도 함께 무효화**된다.
"nested 그룹이니 네이티브로 합쳐진다"는 가정 금지 (DMF0020 환율 Modal 사고 2026-07-08 — 년도 미머지).

✅ 커스텀 MergeManager 를 쓰는 그리드는 **동적 1단(년/년월) 수평 머지를 직접 구현**한다
(binding 규칙에서 그룹키 파생 — 정본: ExchangeRateModal `M_yyyymm`→년도 slice, PriceBatchInputModal `dynHdrKey`):

```ts
if (binding.startsWith('M_') && r === 0) {
  const yearOf = (b: string) => (b.startsWith('M_') ? b.slice(2, 6) : '');
  const y = yearOf(binding);
  let c1 = c, c2 = c;
  while (c1 > 0 && yearOf(panel.columns[c1 - 1]?.binding ?? '') === y) c1--;
  while (c2 < panel.columns.length - 1 && yearOf(panel.columns[c2 + 1]?.binding ?? '') === y) c2++;
  return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
}
```

## §3. 자기 점검 (POST-WRITE)

```
✅ TopLeft 전체 단일 머지 + 'No.' 라벨 + 중앙 정렬?
✅ setCellData 재귀 방지 가드(현재값 비교) 있는가?
✅ 커스텀 MergeManager 그리드에서 동적 1단 수평 머지를 수동 구현했는가? (네이티브 span 가정 0)
✅ allowMerging=All prop 전달 (wrapper 리셋 함정)?
✅ 기존 고정컬럼 세로 머지/데이터셀 머지 회귀 없음?
```

> Cross-ref: RULESET_MASTER §3.1 체크리스트 / hook #38(merge viewport sticky) / #93(헤더 높이 48px) / #95(backcolor) / 메모리 `feedback_wijmo_hierarchical_merge`
