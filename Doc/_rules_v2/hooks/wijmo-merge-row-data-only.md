# Hook — Wijmo 병합(MergeManager): 병합 경계는 **행 데이터만** 본다

> ⛔ `MergeManager.getMergedRange()` 에 **선택/포커스/편집 상태를 섞지 말 것.**
> 섞으면 "그리드에 포커스만 가면 병합이 깨진다" 가 된다.
> 2026-08-11 공용 그리드에서 한 번 잡았고, 2026-08-21 DMF0049 초본에서 다른 형태로 재발했다.
> **초본 생성 시점에 이 룰을 적용**한다 (사후 제거는 되돌릴 diff 가 커진다).

작성: 2026-08-21 (사용자 명시)
트리거: T04(Grid/DataGrid/머지·편집 제어) · T01(신규 화면) · T01M(화면 수정) — 그리드 병합을 다루는 모든 작업
관련 hook: `screen-grid-edit-merge-and-meta-mandatory`(#89), `datagrid-shared-component-mandatory`,
`grid-cell-interaction-patterns-mandatory`

---

## §1. 규칙

`getMergedRange()` 의 입력은 **행 데이터뿐**이다. 셀 값, `CRUD_TYPE`, `INSERT_GROUP_ID` 같은
**행 자체의 속성만** 쓴다.

**금지 — 선택/포커스/편집 상태를 병합 판정에 섞는 것:**

| # | 금지 형태 |
|---|---|
| 1 | `selectionChanged` → 선택 행(또는 그 세트)을 병합에서 분리 → `invalidate()` |
| 2 | `prepareCellForEdit` / `beginningEdit` → 편집 행을 병합에서 제외 |
| 3 | MergeManager 인스턴스에 "지금 선택된 행/세트" 같은 **가변 상태 필드**를 두는 것 |

허용되는 상태 의존은 **하나뿐** — `cellEditEnded` 후 `invalidate()`.
이건 상태가 아니라 **값이 바뀌어서 병합키가 바뀐 것**을 반영하는 것이다.

## §2. 이유 (3가지 모두 실제 증상)

1. wijmo 는 **이미 선택된 셀을 다시 클릭해도** 선택 이벤트를 낸다(더블클릭의 두 번째 클릭 포함).
   선택으로 병합을 바꾸면 사용자에겐 **"포커스만 갔는데 병합이 깨진다"** 로 보인다.
2. 편집 불가 셀은 `beginningEdit` 이 cancel 되고 `cellEditEnded` 가 **오지 않는다.**
   편집 상태로 병합을 바꿔 두면 그 행이 **갈라진 채 고착**된다(드릴다운 더블클릭이 늘 이 경로).
3. 되돌리려면 `invalidate()` 가 필요한데, `invalidate` 는 10ms 뒤 `refresh` 를 예약하고
   `FlexGrid.refresh` 는 `finishEditing()` 을 부른다 → **편집기·콤보 드롭다운이 닫힌다.**

## §3. 자주 나오는 잘못된 전제

> "클릭한 행만 편집하려면 그 행을 병합에서 떼어내야 한다" — **틀렸다.**

wijmo 의 편집 범위(`_rng`)는 `beginningEdit` **보다 먼저** 병합 블록 전체로 계산된다.
갈라 보여줘도 저장은 어차피 블록 전체에 된다. 즉 **병합을 유지한 채로도 "같은 group 만 수정" 은
그대로 성립**하고, 병합을 건드릴 이유가 없다.

## §4. 요구사항 문구 해석 주의 ⭐

> "수정할 line 클릭 시 **병합이 풀리고** 편집 가능"

이런 문장은 기능 요구가 아니라 **결함 신고**일 수 있다. 기능으로 구현하기 전에 확인할 것.

실제 사례 — DMF0049 `REQ:CHAT-20260820-18` 이 이 케이스였다. 요구로 읽고 세트 분리 기능을
구현했다가, 사용자가 "포커스만 가면 병합이 깨진다"고 신고했다.
(hook #139 원장 축과 연결 — 요구 문구를 그대로 구현으로 옮기기 전에 증상인지 요구인지 가른다.)

---

## §5. 수정 방향 — 이미 상태 의존으로 나왔을 때

**대체 구현을 찾지 말고 제거한다.** 분리 로직을 빼면 병합은 조회 직후 상태(값 기준 광역 병합)로
돌아가고, 그게 정상 동작이다. 새로 짤 것이 없다.

### 5.1 MergeManager — 상태 필드·세터·판정 제거

```ts
// 제거 전
export class XxxMergeManager extends MergeManager {
  private activeSetKey: string | null = null;               // (a) 상태 필드
  setActiveSetKey(key: string | null): boolean { ... }       // (b) 외부 세터
  ...
      const inActive = (i: number): boolean =>
        this.activeSetKey !== null && setKeyOf(rowItem(i)) === this.activeSetKey;
      const curActive = inActive(r);
      const sameRow = (a: number, b: number): boolean =>
        inActive(a) === curActive && canMergeRows(rowItem(a), rowItem(b), leftBindings);  // (c)

// 제거 후 — (a)(b) 통째로 삭제, (c) 는 행 데이터 판정만 남긴다
      const sameRow = (a: number, b: number): boolean =>
        canMergeRows(rowItem(a), rowItem(b), leftBindings);
```

### 5.2 Grid — 배선 제거

- `selectionChanged` 핸들러 등록 + cleanup 의 `removeHandler` **한 쌍**
- 행 교체(재조회·Insert) 시 상태를 되돌리던 `useEffect` — 상태가 없으니 되돌릴 것도 없다
- 쓰이지 않게 된 import 정리

### 5.3 세트키 헬퍼 정리

병합 소비처가 사라지면 `setKeyOf` 류 헬퍼도 같이 삭제한다.
⚠ 저장측(payload 세트 그룹핑)에 **같은 이름의 별도 함수**가 있을 수 있다. 그건 무관하니 남긴다.

### 5.4 검증

- `tsc --noEmit` / `eslint` 통과
- `git diff --ignore-cr-at-eol` 로 **로직 diff 가 0** 인지 확인한다.
  상태 의존은 대개 커밋 안 된 작업분이라, 제대로 걷어내면 커밋 baseline 과 로직이 정확히 일치한다.
  주석만 남으면 정상. 로직 diff 가 남으면 덜 걷어냈거나 다른 것까지 건드린 것이다.
- 화면 확인 3가지
  1. 병합된 좌측 셀을 **여러 번 클릭** → 병합이 유지된다
  2. 병합 셀 **더블클릭** → 편집기가 뜨고 10ms 뒤 닫히지 않는다(콤보면 드롭다운이 열린 채 유지)
  3. **재조회·필터 적용 후** → 병합이 그대로다

## §6. 선택 행을 정말 강조해야 한다면

병합 구조가 아니라 **표시 계층**에서 한다. `formatItem` 으로 선택 행/세트에 배경·테두리 클래스를
토글하면 병합 블록은 그대로 두고 시각만 바뀌므로 §2 의 3가지 사고가 없다.
**병합을 쪼개는 건 "강조" 수단이 아니다.**

## §7. 리뷰 체크 (초본 검수 시)

- MergeManager 서브클래스에 `private` **가변** 필드가 있으면 의심한다
  (생성자로 받은 `private readonly fixedBindings` 만 정상).
- merge/grid 파일에서 다음이 잡히면 재검토:

```bash
# ⚠ 넓은 grep(setActive*)은 오탐이 많다 — 실측 2026-08-21: setActiveTab/setActiveGrid(탭 전환)이
#   20건 넘게 걸린다. 병합 상태 의존만 노리도록 좁힌다.
rg -n "activeSetKey|setActiveSetKey|_editingRow|prepareCellForEdit" \
   -g "*merge*.ts" -g "*Grid.tsx" nscm-fe/features nscm-fe/packages

# selectionChanged 는 정당한 용도(탭 활성 그리드 라우팅 등)도 있으므로, merge 파일과
# 같은 폴더에서 mergeManager 를 건드리는지 함께 본다.
rg -n "selectionChanged" -g "*Grid.tsx" nscm-fe/features | rg -i "merge"
```

---

## §8. 근거 (2026-08-21 실측)

| 항목 | 실측 |
|---|---|
| 공용 정본 | `nscm-fe/packages/foundation/src/utils/mergeManager.ts:65~80` — `bindInvalidateEvents()` 에 §1·§2·§3 이 주석으로 성문화되어 있고, 허용된 `cellEditEnded → invalidate` 만 등록(L75) |
| `_editingRow` 잔존 | **0건** (공용에서 제거 완료) |
| `CustomMergeManager` 가변 필드 | **없음** (readonly 만) |
| 화면 정본 (clean) | `nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.merge.ts:37` — `private readonly fixedBindings` 만 보유 |
| ⚠ 미정리 | `nscm-fe/features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts` — §9 참조 |

> ⚠ 원문이 인용한 커밋 `0a76c94` 는 **이 저장소에 존재하지 않는다**(`git log --all` 및 메시지 검색 모두 무매치).
> 근거는 커밋 해시가 아니라 **위 파일·라인 실측**으로 삼는다.

## §9. 사고 이력 / 현재 상태

| 시점 | 화면 | 상태 의존 형태 | 증상 | 현재 |
|---|---|---|---|---|
| 2026-08-11 | 공용 `CustomMergeManager` | `prepareCellForEdit` → `_editingRow` | 포커스만 옮겨도 병합 풀림 / 편집 취소 셀은 갈라진 채 고착 | ✅ 제거 완료 |
| 2026-08-21 | DMF0049 `EtcSalesReportsMergeManager` | `selectionChanged` → `activeSetKey` | 그리드에 포커스 가면 병합 깨짐 | ⛔ **작업 트리에 잔존** |

### DMF0049 잔존 실측 (2026-08-21 — 되돌림 **미완료**)

```
etc-sales-reports/utils/etc-sales-reports.merge.ts:62   private activeSetKey: string | null = null;
                                              :75   setActiveSetKey(key: string | null): boolean {
                                              :105  this.activeSetKey !== null && setKeyOf(...) === this.activeSetKey
etc-sales-reports/components/EtcSalesReportsGrid.tsx:458 selectionChangedHandler
                                                    :463 mergeManager.setActiveSetKey(setKeyOf(item))
                                                    :465 g.selectionChanged.addHandler(...)
                                                    :471 removeHandler (cleanup)
                                                    :492 mm.setActiveSetKey(null) (행 교체 시 reset)
etc-sales-reports/__asis-mapping__.md:96,125  REQ:CHAT-20260820-18 = '구현' 으로 기입됨
```

**후속 조치(미이행)**: §5 절차대로 위 5곳 + 헬퍼를 제거하고, `__asis-mapping__.md` 의
`REQ:CHAT-20260820-18` 행을 **"결함 신고 → 원복"** 으로 정정해야 한다(§4). 제거 후 §5.4 검증
(`git diff --ignore-cr-at-eol` 로직 diff 0)까지 통과해야 완료다.
