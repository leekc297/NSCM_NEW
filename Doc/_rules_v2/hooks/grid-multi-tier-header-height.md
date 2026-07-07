# Hook — Grid 다단(2단/3단) 헤더 높이 정합

> ⚠ **동적 컬럼/다단 헤더 grid 작업 시 적용**
> 헤더 총높이 = **48px 고정**. 1단=48 / 2단=24×2 / 3단=16×3. 1단 높이(48)를 tier 수만큼 ×N 하면
> 헤더가 비대해짐(예 3단=144px). foundation `HEIGHT_BY_COLUMN_DEPTH` + DMF0007 패턴을 따른다.

작성: 2026-06-27 (사용자 명시 — DMF0020 3단 헤더 144px 비대화 사고 후 룰화)
상위 룰: `anti-simplification.md`
관련 룰: `ui-category-setup-column-meta.md` (#65) / `screen-runtime-pitfalls-mandatory.md` (#70 P6) / `screen-grid-edit-merge-and-meta-mandatory.md` (#89)
단일 출처(높이): `packages/foundation/src/utils/columnMapping.ts` `HEIGHT_BY_COLUMN_DEPTH`
reference 화면: **DMF0007** (customer-forecast-master — height 수동조작 0 표준)

---

## §0. 트리거 (작업 키워드 매칭 시 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 grid (T01) | PRE-WRITE + POST-WRITE |
| 화면 grid 수정 (T01M) | PRE-WRITE + POST-WRITE |
| 다단 헤더 / 동적 컬럼 / 월별·주별 group (T04) | PRE-WRITE + POST-WRITE |
| `columnHeaders` / `height` / `defaultSize` 키워드 등장 | POST-WRITE 검증 |

---

## §1. WHY — 헤더 높이 비대화 사고

DMF0020: 동적 컬럼이 3단(년월→주차→일)인데 1단 높이(48) 가 row 마다 적용돼 **3 × 48 = 144px** 로 헤더가 비대해짐.
근본 원인: 정적 컬럼이 1단(height 48)으로 매핑된 채 동적이 3단이고, 화면이 useEffect 로 height 를 강제 override 하나 공유 DataGrid wrapper 의 비동기 refresh 와 충돌해 정규화 실패.

---

## §2. 알고리즘 (foundation 단일 출처)

`packages/foundation/src/utils/columnMapping.ts`:
- `HEIGHT_BY_COLUMN_DEPTH` (L26-30): **ONE_DEPTH=48 / TWO_DEPTH=24 / THREE_DEPTH=16**.
- `getColumnDepth()` (L116-135): 컬럼 메타 `sClsLblNm`(소분류)·`lClsLblNm`(대분류)로 depth 판정 — 둘 다 없음=**1단** / `lClsLblNm` 없음(또는 sCls=lCls)=**2단** / 그 외=**3단**.
- `mapRawColumnsToWijmoColumns()` (L169~): depth 별로 **group + leaf 모든 tier 에 동일 height** 부여 → 1단 48 / 2단 24×2 / 3단 16×3 = **총합 항상 48px**.

> ⭐ **Wijmo 규칙**: 헤더 각 row 높이 = 그 row 에 속한 컬럼들의 `height` 중 **max**.
> → 한 컬럼이라도 height 48 이면 그 row 전체가 48 로 비대. 모든 tier 의 모든 컬럼이 동일 per-tier 높이(48/maxDepth)를 가져야 함.

per-tier height = **48 / maxDepth** (1단 48 / 2단 24 / 3단 16).

---

## §3. 의무 패턴

### (P-A) Matched depth — 권장 (DMF0007 표준, height 수동조작 0)
동적 depth ≤ 정적 depth 일 때:
- 동적 컬럼에 **`height` 미지정** (height-less). `CustomerFcstMasterDateColumns.ts` 참조 — upper group + lower leaf 에 height 없음.
- grid 컴포넌트에서 **useEffect/columnHeaders/invalidate 로 height 조작 금지**. `CustomerFcstMasterFcstGrid.tsx` 처럼 `<DataGrid staticColumns dynamicColumns>` 만 전달.
- 정적 컬럼 depth 는 메타 `SMALL_CLASS_LABEL_NAME`(→`sClsLblNm`) / `LARGE_CLASS_LABEL_NAME`(→`lClsLblNm`)로 표현 → wrapper `mapRawColumnsToWijmoColumns` 가 depth 별 height 자동 부여 → row 높이 결정. 동적(height-less)은 row 를 끌어올리지 않음.

### (P-B) Mismatched depth — 정적 1단 + 동적 3단 (DMF0020)
depth 불일치가 불가피할 때(정적은 single-header, 동적은 3단). **height 전담 단일 useEffect 1개**로 처리 — 실제 header row 수 기반(구조적):

```ts
// merge/LOC 효과 "이후"에 정의 (핸들러/mergeManager 세팅 후 높이 정규화 → merge 무간섭)
useEffect(() => {
  const g = gridRef.current; if (!g) return;
  const id = requestAnimationFrame(() => {      // ⭐ wrapper 비동기 구조 refresh 이후
    const hdr = g.columnHeaders?.rows;
    if (!hdr || hdr.length === 0) return;
    const per = Math.max(1, Math.round(48 / hdr.length)); // ⭐ 실제 rowCount: 1단48/2단24/3단16
    hdr.defaultSize = per;
    for (let i = 0; i < hdr.length; i++) hdr[i].height = per;
    for (let i = 0; i < g.columns.length; i++)  // 정적 col wrapper-부여 48 잔여 제거 (Wijmo row=max(height))
      (g.columns[i] as unknown as { height: number }).height = per;
    g.invalidate();
  });
  return () => cancelAnimationFrame(id);
}, [rows, dynBindings, dataMaps, visibleColumns, gridRef]);
```

원칙 5:
1. **단일 출처** — height 조작은 이 효과 **한 곳만**. 동적 컬럼 정의/다른 useEffect 에서 height 미조작 (DMF0007 동적=height 미지정 정합).
2. **실제 `columnHeaders.rows.length`** 로 나눔 ("HEADER ROW 수에 따라 조정"). `dynBindings` 파생 maxDepth 추정 금지.
3. 정적(얕은) 컬럼은 mergeManager `ColumnHeader` verticalSpan(`CellRange(0,c, rows-1,c)`)으로 row 전체 병합 → per=16 × N row 를 1 cell 로 시각 통합.
4. **rAF 지연** — wrapper 비동기 rebuild 이후 적용 (pre-binding 동기 useEffect 단독 금지: rebuild 에 덮임).
5. **merge/LOC 효과와 분리·이후 정의** — 높이 효과가 mergeManager/formatItem 핸들러를 건드리지 않게 별도 효과로 두고 그 뒤에 배치.

> ⚠️ 회귀 사례(2026-06-27): height 강제를 **3곳(동기 dataMaps / rAF / merge 효과 시작부)에 중복** → 값/타이밍 경쟁 + merge·LOC 효과 간섭 → 높이 무효 + merge/LOC 해제. **단일화**로 해소.
> 가능하면 P-A(정적·동적 depth 정합 — 메타 sCls/lCls)로 설계해 height 수동조작 자체를 없애는 게 최선. P-B 는 차선.

> ⭐ **검증 보강 (2026-06-27 DMF0020 최종 적용 — 사용자 '정상 동작' 확인)**:
> - **실동작 레버 = `columnHeaders.rows[i].height` + `rows.defaultSize`** (Row 객체에만 `height` 존재).
>   Wijmo 타입상 **`Column` 에는 `height` 속성이 없음** (`Column extends RowCol`, `Row` 만 `height`). 따라서
>   `g.columns[i].height = per` 는 **TS no-op + 런타임 무효** — §3 P-B 코드의 해당 줄은 cargo 이므로 **제거**하고
>   `columnHeaders.rows` 만 조작할 것. 정적 잔여 48 은 컬럼 height 가 아니라 **rows[i].height 강제로 정규화**됨.
> - rAF 1회보다 **`g.updatedLayout` 핸들러로 재적용 + guard(`defaultSize===per && rows[0].height===per` 면 skip)** 가 wrapper rebuild 에 더 견고 (DMF0020 최종 채택).
> - 공유 `DataGrid` 의 `headerRowHeight` prop 단독(=`rows.defaultSize` 만 설정)은 **정적 컬럼 잔여로 무효** — 각 `rows[i].height` 까지 설정해야 함.

---

## §4. PRE-WRITE 자기 점검

- [ ] 동적 depth vs 정적 depth 비교 → maxDepth 산정.
- [ ] **matched** 면: 동적 컬럼 height **미지정** + grid 에 height 조작 0 (P-A).
- [ ] **mismatched** 면: maxDepth 정규화 5단계(P-B) 모두 적용 — 정적 leaf 도 48/maxDepth.
- [ ] per row height = **48 / 실제 rowCount**(`columnHeaders.rows.length`) — 1단48/2단24/3단16, 임의 px 금지.
- [ ] Wijmo "row 높이 = max(컬럼 height)" 규칙 인지 — 잔여 48 컬럼 0 확인.
- [ ] (P-B) height 조작 = **단일 effect 한 곳만** (동적 컬럼 정의/타 effect height 미조작). rAF 지연 + merge 효과 이후 정의.

---

## §5. POST-WRITE 자동 검증 (grep)

```bash
# (1) 동적/정적 컬럼에 height 48 직접 부여 0 (다단인데 48 = 비대 위험)
grep -nE "height:\s*48" features/**/components/*Grid.tsx
# (2) per-tier height 가 48/maxDepth 상수(16/24)인지 (다단 화면)
grep -nE "height:\s*(16|24)" features/**/components/*Grid.tsx
# (3) (P-B) defaultSize + rAF invalidate 존재
grep -nE "columnHeaders\.rows\.defaultSize|requestAnimationFrame" features/**/components/*Grid.tsx
# (4) (P-A 화면) grid 에 height/columnHeaders 조작 0 (DMF0007 류)
grep -nE "columnHeaders|\.height\s*=" features/**/components/*Grid.tsx   # 없으면 P-A 정합
```

---

## §6. 안티패턴 (사고 사례)

| # | 안티패턴 | 결과 |
|---|---|---|
| 6.1 | tier 마다 1단 높이(48) 부여 | 헤더 = 48×N 비대 (DMF0020 144px) |
| 6.2 | 일부 tier 만 height 지정 | row 별 높이 불균형 |
| 6.3 | pre-binding useEffect 단독으로 height 강제 | wrapper 비동기 refresh 에 덮여 무효 |
| 6.4 | 정적 1단(48) 잔여 미정규화 (동적만 16) | 정적이 속한 모든 row max=48 → 비대 |
| 6.5 | Wijmo "row=max(height)" 규칙 무시 | 한 컬럼 48 이 row 전체 비대 유발 |
| 6.6 | **height 강제를 여러 effect/컬럼정의에 중복** | 값/타이밍 경쟁 → 높이 무효 + merge/LOC 효과 간섭·해제 (2026-06-27 DMF0020 회귀) → **단일 효과로 통합** |
| 6.7 | height 효과가 merge/LOC 효과와 섞임 | mergeManager/핸들러 간섭 → 분리·이후 정의 필수 |
| 6.6 | matched depth 인데 동적 컬럼에 height 강제 | DMF0007 표준 위반 + 불필요 조작 |

---

## §7. 적용 이력

| 화면 | 패턴 | 적용일 | 비고 |
|---|---|---|---|
| DMF0007 (customer-forecast-master) | P-A | (기존) | matched 2단 — height 수동조작 0 표준 reference |
| DMF0020 (sales-future-price) | P-B | 2026-06-27 | 정적 1단 + 동적 3단. **단일 height 효과**(rAF, 실제 rowCount=3 → per 16) + 정적 verticalSpan. 3중 height 경쟁 제거 회귀 fix 동반. |
| DMF0020 PriceBatchInput (**모달**) | P-B + 모달 보강 | 2026-07-01 | ⭐ **CustomDialog 안 그리드** 특화. dialog open 애니메이션으로 컨테이너가 0→full 리사이즈되고 wijmo가 그때(수 프레임 뒤) 3단 헤더를 확정 build → 이후 정적이라 `updatedLayout` 미발생 → 큰 높이 잔존. 해결: **(1) 높이 정규화 핸들러를 `open` 세션당 1회만 등록(churn 0 — dataMaps/dynBindings 변경으로 재등록 금지, ref로 최신값 참조) (2) `ResizeObserver` `deps=[open]`로 재부착**(닫힌 채 mount 시 `gridWrapRef=null`→미부착 버그) **(3) 재진입 초기화** = `searched` flag로 빈 그리드→단일 헤더 리셋. |
| DMF0020 PriceBatchInput (**재진입 재발**) | P-B v2 (상시 감시) | 2026-07-02 | ⭐⭐ 저장→Close→재Open 시 비대화 **재발** — 잔여 경로 2: ① close/reopen 과정의 **그리드 인스턴스 교체** 시 정규화 핸들러가 죽은 인스턴스에 잔존 ② "예상 tier 수(dynBindings)"로만 per 산출 → 실제 헤더 행수와 어긋나는 순간 48×N. **해결(불변식 방식)**: open 동안 rAF 상시 루프가 (a) `gridRef.current` 교체 감지 → 살아있는 인스턴스에 `updatedLayout` 핸들러 이관 (b) **존재 행 높이 = `48/실제 행수`, defaultSize = `48/예상 tier`** 각각 강제 ⇒ 어떤 조합에서도 "보이는 헤더 총합 = 48px" 불변식. 목표 상태면 early-exit(프레임당 속성 비교 수준). 모달 내 그리드는 이 v2 를 표준으로 사용. |

---

## Cross-ref
- foundation `columnMapping.ts` — `HEIGHT_BY_COLUMN_DEPTH` / `getColumnDepth` / `mapRawColumnsToWijmoColumns` (높이 단일 출처)
- `ui-category-setup-column-meta.md` (#65) — 정적 컬럼 메타 depth(`SMALL/LARGE_CLASS_LABEL_NAME`)
- `screen-runtime-pitfalls-mandatory.md` (#70 P6) — 다단 헤더 row 높이
- `screen-grid-edit-merge-and-meta-mandatory.md` (#89) — mergeManager(verticalSpan) props
- reference: DMF0007 `CustomerFcstMasterFcstGrid.tsx` / `CustomerFcstMasterDateColumns.ts`
