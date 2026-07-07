# Hook #102 — 커스텀 우클릭(Context) 메뉴 표준 (dismiss 레이스 차단)

> 신설: 2026-07-03 (DMF0003 우클릭 PR 메뉴 "무반응" 사고 — 사용자 보고 후 원인 확정)
> 트리거: T01 / T01M / T04 — 그리드(또는 임의 영역)에 **커스텀 우클릭 메뉴**(DOM div) 를 구현/수정할 때
> 짝: #67 popup-modal-and-routing (팝업 라우팅) / #66 grid-cell-interaction-patterns

## §0. 사고 (원인 확정)

증상: "우클릭 시 아무 반응 없음". 실제로는 **메뉴가 떠도 어떤 항목을 눌러도 조용히 닫히기만** 했다.

원인: 메뉴 닫기(dismiss)를 `document.addEventListener('mousedown', dismiss, { once: true })` 로 걸면,
**메뉴 항목 클릭의 mousedown 단계에서 dismiss 가 먼저 실행되어 메뉴가 DOM 에서 제거**된다.
click 이벤트는 mousedown+mouseup 완성 후 발화하므로 — target 이 이미 detach 된 항목의 click 은 발화하지 않는다.
→ 메뉴 표시는 정상, 액션은 0% 동작. 컴파일/린트/타입 전부 통과하는 **런타임 전용 결함**.

## §1. 표준 구현 3종 세트 (의무)

| # | 규칙 | 구현 |
|---|---|---|
| 1 | **항목 실행 = `mousedown`** (click 금지) | `li.addEventListener('mousedown', e => { if (e.button !== 0) return; e.preventDefault(); e.stopPropagation(); handleAction(...) })` — 제거 레이스 원천 차단 (좌클릭만) |
| 2 | **dismiss = persistent + contains 가드** | `document` 의 `mousedown`+`contextmenu` persistent 리스너 — `if (menuEl.contains(e.target)) return;` 후 제거. `{once:true}` 금지. removeContextMenu() 안에서 리스너 해제 |
| 3 | **capture 플래그 add/remove 일치** | 그리드 내부 전파 차단 대비 `addEventListener('contextmenu', h, { capture: true })` 사용 시 **cleanup 도 `{ capture: true }` 로 해제** — 플래그 불일치 = 미해제 → 리마운트마다 리스너 누적 |

## §2. 부속 표준

- 메뉴 표시 조건은 `grid.hitTest(ev)` 로 판정 (`cellType === CellType.Cell` 등) — 조건 미충족 시 `preventDefault()` 하지 않아 브라우저 기본 메뉴 유지 (AS-IS 도 검증은 항목 클릭 시점).
- 메뉴 DOM 은 `document.body` append + `position:fixed` + `z-index` — 그리드 내부 append 금지 (스크롤/오버플로 클리핑).
- 재우클릭 시 기존 메뉴 먼저 제거(removeContextMenu) 후 새로 표시.
- i18n: 메뉴 표시명 하드코딩 금지 — LBL 채번(#98 §7) + `t(lblKey, fallback)`.

## §3. PRE-WRITE 점검

1. 항목 실행이 mousedown 인가? (click 이면 레이스 검토 증빙)
2. dismiss 에 contains 가드가 있는가? once:true 가 아닌가?
3. add/remove 의 capture 플래그가 일치하는가?
4. cleanup(useEffect return)에서 메뉴 DOM + 리스너 모두 해제하는가?

## §4. POST-WRITE grep

```
grep "once: *true" — 컨텍스트 메뉴 dismiss 에서 0건
grep "addEventListener('click'" — 메뉴 항목(li)에서 0건 (mousedown 사용)
```

레퍼런스 구현: `nscm-fe/features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx` contextMenuHandler (2026-07-03 fix).
메모리: `feedback_custom_context_menu_dismiss_race.md`
