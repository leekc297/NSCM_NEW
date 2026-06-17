# Wijmo FlexGrid 학습자료 (NSCM 프로젝트용)

> **목적**: Claude Code / 개발자가 Wijmo FlexGrid를 정확한 정신 모델(mental model)로 다루도록 하는 단일 진실원본.
> `doc/` 폴더에 두고 `CLAUDE.md`에서 참조한다.
> **기준 버전**: `@mescius/wijmo` **5.20261.50** (MESCIUS, 구 GrapeCity)
> **스코프**: NSCM TO-BE (React + TypeScript). 일반 그리드는 Wijmo FlexGrid, 피벗 그리드는 SpreadJS(`@mescius/spread-sheets`)로 분리되어 있음 — **둘은 완전히 다른 제품/API**다.

---

## 0. Claude Code가 가장 자주 틀리는 3가지 (먼저 읽을 것)

대부분의 잘못된 코드는 아래 세 가지 혼동에서 나온다. 코드 생성 전 반드시 체크.

1. **FlexGrid ≠ SpreadJS ≠ AG Grid ≠ MUI DataGrid.** 이름이 비슷하거나 같은 벤더(MESCIUS)라도 API는 전혀 다르다.
   - SpreadJS는 **시트 모델**: `workbook.getSheet().getCell(r,c).value()`.
   - FlexGrid는 **CollectionView 모델**: 데이터는 `itemsSource`(배열 또는 `CollectionView`), 셀 값은 객체의 속성.
   - AG Grid의 `columnDefs`/`rowData`/`gridApi`, MUI의 `valueGetter`/`renderCell` 같은 API는 **존재하지 않는다.**
2. **패키지 스코프는 `@mescius/*`다.** `@grapecity/wijmo`(구 스코프)나 스코프 없는 `wijmo`는 이 프로젝트에서 쓰지 않는다.
3. **데이터의 중심은 항상 `CollectionView`다.** 정렬/필터/그룹/페이징/편집/변경추적이 전부 여기서 일어난다. 그리드를 DOM처럼 직접 조작하려 들면 거의 항상 틀린다.

---

## 1. 아키텍처 정신 모델

```
데이터 배열  ──>  CollectionView  ──>  FlexGrid(뷰)  ──>  Column[] (열 정의)
 (raw data)      (정렬/필터/그룹/         (렌더링/편집)        (binding=속성명)
                  페이징/편집/변경추적)
```

- FlexGrid는 **순수 JS 컨트롤**이다. `@mescius/wijmo.react.grid`의 React 컴포넌트는 그 위의 얇은 래퍼(interop)일 뿐.
- `itemsSource`에 **배열**을 주면 FlexGrid가 내부적으로 자동으로 `CollectionView`로 감싼다. 이때 실제 뷰는 `grid.collectionView`로 접근.
- 정렬/필터/그룹/변경추적이 필요하면 **직접 `CollectionView`를 만들어** `itemsSource`로 넘기는 것이 정석.

---

## 2. 패키지 & 임포트 (정확한 이름)

```ts
// 코어 (CollectionView, formatNumber, Globalize 등)
import * as wjcCore from '@mescius/wijmo';
import { CollectionView } from '@mescius/wijmo';

// 그리드 코어 (코드로 컨트롤 직접 생성할 때)
import { FlexGrid, Column, DataMap, CellRange } from '@mescius/wijmo.grid';

// React 래퍼 컴포넌트 (JSX에서 쓸 때) ★ NSCM은 이쪽
import { FlexGrid, FlexGridColumn, FlexGridCellTemplate } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';
import { FlexGridSearch } from '@mescius/wijmo.react.grid.search';

// 셀 커스터마이징 헬퍼 (링크/버튼/이미지/스파크라인/별점)
import { CellMaker } from '@mescius/wijmo.grid.cellmaker';

// CSS (필수 — 없으면 그리드가 깨져 보인다)
import '@mescius/wijmo.styles/wijmo.css';
```

> **규칙**: "코드로 생성"하려면 코어 모듈(`@mescius/wijmo.grid`)의 클래스를, "JSX로 선언"하려면 React 모듈(`@mescius/wijmo.react.grid`)의 컴포넌트를 쓴다. 둘을 섞지 말 것.

---

## 3. CollectionView — 데이터의 심장

`CollectionView`는 원본 배열을 건드리지 않고 정렬/필터/그룹/페이징/편집/변경추적을 제공하는 래퍼다.

```ts
const view = new CollectionView(rawArray, {
  // 정렬
  sortDescriptions: [new SortDescription('orderDate', false)], // false=내림차순
  // 그룹
  groupDescriptions: [new PropertyGroupDescription('plant')],
  // 필터 (술어 함수)
  filter: (item) => item.qty > 0,
  // 페이징
  pageSize: 50,
  // ★ 변경추적 (서버 저장용 — 4장 참조)
  trackChanges: true,
  // 신규행 추가 시 기본값
  newItemCreator: () => ({ plant: '', qty: 0 }),
});
```

### 핵심 멤버
| 멤버 | 의미 |
|---|---|
| `items` | 정렬·필터·그룹·페이징이 **적용된** 뷰 데이터 |
| `sourceCollection` | 원본 배열 |
| `currentItem` / `currentPosition` | 현재 행 (그리드 선택과 연동) |
| `moveCurrentTo(item)` / `moveCurrentToPosition(n)` | 현재 행 이동 |
| `refresh()` | 정렬/필터 재적용 (정렬·필터 조건 바꾼 뒤 호출) |
| `pageSize`, `pageIndex`, `moveToPage(n)` | 페이징 |
| `addNew()` / `commitNew()` / `cancelNew()` | 신규행 트랜잭션 |
| `editItem(item)` / `commitEdit()` / `cancelEdit()` | 편집 트랜잭션 |
| `remove(item)` / `removeAt(idx)` | 삭제 |
| `getError` | 셀 검증 콜백 (6장) |

> **함정**: 정렬/필터 조건을 바꾼 뒤에는 `view.refresh()`를 호출해야 반영된다. 또한 원본 배열을 `push`로 직접 수정하면 뷰는 모른다 — `view.addNew()`/`commitNew()` 또는 `view.sourceCollection.push(...)` 후 `view.refresh()`.

---

## 4. 편집 & 변경 추적 (저장 로직의 핵심)

NSCM처럼 그리드 편집 → 서버 저장(commit)이 필요한 화면에서 가장 중요한 부분.

```ts
const view = new CollectionView(rows, { trackChanges: true });
// 편집/추가/삭제가 일어나면 자동으로 채워진다:
view.itemsEdited   // 수정된 항목
view.itemsAdded    // 추가된 항목
view.itemsRemoved  // 삭제된 항목

// 서버 저장 후 초기화:
view.clearChanges();
```

> **반드시 알아야 할 동작 (공식 문서 명시)**:
> CollectionView는 **CollectionView의 메서드를 통한 변경만 추적**한다 (`editItem`/`commitEdit`, `addNew`/`commitNew`, `remove`). **원본 데이터 객체를 직접 수정한 변경은 추적되지 않는다.** FlexGrid에서 셀을 편집하면 내부적으로 이 메서드들을 거치므로 자동 추적되지만, 코드에서 `row.qty = 10`처럼 직접 바꾸면 추적 안 됨.

### 편집 제어 속성 (FlexGrid)
| 속성 | 의미 |
|---|---|
| `isReadOnly` | 그리드 전체 읽기전용 |
| `column.isReadOnly` | 특정 열만 읽기전용 |
| `allowAddNew` | 마지막에 신규행(`*`) 표시 |
| `allowDelete` | Delete 키로 행 삭제 허용 |
| `column.isRequired` | 빈 값 불가 (기본 true) |

### 편집 검증 이벤트
```ts
grid.cellEditEnding.addHandler((s, e) => {
  const newVal = s.activeEditor.value;
  if (e.col === s.columns.getColumn('qty').index && Number(newVal) < 0) {
    e.cancel = true; // 편집 취소 (값 롤백)
    // e.stayInEditMode = true; // 셀에 계속 머물게 하려면
  }
});
```
- `beginningEdit`: 편집 진입 차단 (`e.cancel = true`)
- `cellEditEnding`: 값 확정 직전 검증
- `cellEditEnded`: 확정 후 후처리(연쇄 계산 등)
- `rowEditEnded`: 행 단위 확정 후

---

## 5. Column 정의

`autoGenerateColumns`는 기본 `true`라서 데이터 속성으로 열을 자동 생성한다. **실무에서는 거의 항상 `false`로 두고 명시적으로 정의**한다(헤더/포맷/순서 제어 때문).

### 코드 방식
```ts
const grid = new FlexGrid('#host', {
  autoGenerateColumns: false,
  itemsSource: view,
  columns: [
    { binding: 'plant',     header: '공장',   dataType: 'String',  width: 120, isReadOnly: true },
    { binding: 'qty',       header: '수량',   dataType: 'Number',  format: 'n0', align: 'right' },
    { binding: 'orderDate', header: '주문일', dataType: 'Date',    format: 'yyyy-MM-dd', width: '*' },
    { binding: 'active',    header: '사용',   dataType: 'Boolean', width: 70 },
  ],
});
```

### React(JSX) 방식 ★ NSCM
```tsx
<FlexGrid itemsSource={view} autoGenerateColumns={false}>
  <FlexGridColumn binding="plant"     header="공장"   width={120} isReadOnly={true} />
  <FlexGridColumn binding="qty"       header="수량"   format="n0" align="right" />
  <FlexGridColumn binding="orderDate" header="주문일" format="yyyy-MM-dd" width="*" />
  <FlexGridColumn binding="active"    header="사용"   dataType="Boolean" width={70} />
</FlexGrid>
```

### 자주 쓰는 Column 속성
| 속성 | 설명 |
|---|---|
| `binding` | 데이터 객체의 속성명 (필수) |
| `header` | 헤더 텍스트 |
| `dataType` | `'String'`/`'Number'`/`'Boolean'`/`'Date'` |
| `format` | 표시 포맷. 숫자 `n0`/`n2`/`c`/`p`, 날짜 `yyyy-MM-dd`. (Globalize 규칙) |
| `width` | 숫자(px), 문자 `'*'`/`'2*'`(스타 사이징), `'150'` |
| `minWidth`/`maxWidth` | 너비 제약 |
| `isReadOnly` | 열 읽기전용 |
| `isRequired` | 빈 값 허용 여부 |
| `align` | `'left'`/`'center'`/`'right'` |
| `allowSorting` / `allowResizing` / `allowMerging` | 열 단위 동작 |
| `cssClass` / `cssClassAll` | 셀 / (셀+헤더) CSS 클래스 |
| `dataMap` | 코드→표시값 매핑 드롭다운 (7장) |
| `aggregate` | 그룹/합계 행 집계 (`'Sum'`/`'Avg'`/`'Cnt'` 등) |
| `wordWrap` / `multiLine` | 줄바꿈 / 멀티라인 편집 |
| `visible` | 표시 여부 |
| `cellTemplate` | 셀 커스텀 렌더 (6장) |

> **함정**: `format`에서 날짜는 **대문자 `MM`(월)**, 소문자 `mm`(분)이다. `yyyy-mm-dd`로 쓰면 월이 분으로 나온다.

---

## 6. 셀 커스터마이징 — 4가지 방식 (혼동 주의)

목적에 따라 방식이 다르다. Claude Code가 여기서 자주 임의의 DOM 조작을 시도하는데 **금지**.

### (1) `format` / `dataType` — 단순 표시 포맷
숫자/날짜/통화 포맷만 필요하면 이걸로 끝. 위 5장 참조.

### (2) `CellMaker` + `column.cellTemplate` — 선언적 위젯 (권장)
링크, 버튼, 이미지, 별점, 스파크라인 등 정형 위젯.
```ts
import { CellMaker } from '@mescius/wijmo.grid.cellmaker';

// 버튼 셀
col.cellTemplate = CellMaker.makeButton({
  text: '상세',
  click: (e, ctx) => openDetail(ctx.item), // ctx.item = 행 데이터
});

// 링크 셀
col.cellTemplate = CellMaker.makeLink({ text: '${item.name}', href: '${item.url}' });
```

### (3) `itemFormatter` — 명령형, 가장 빠름, 전 셀 호출
대량 데이터에서 성능이 중요하거나 조건부 스타일링 시.
```ts
grid.itemFormatter = (panel, r, c, cell) => {
  if (panel.cellType === wjcGrid.CellType.Cell) {
    const col = panel.columns[c];
    if (col.binding === 'qty') {
      const v = panel.getCellData(r, c, false);
      cell.style.color = v < 0 ? 'red' : '';
    }
  }
};
// 조건 바뀌면 grid.invalidate() 또는 grid.refreshCells(false)
```
> **주의**: `itemFormatter`는 **모든 셀에 대해 매우 자주 호출**된다. 무거운 연산 금지. `cell.innerHTML`을 통째로 갈아끼우기보다 `cell.textContent`/스타일만 손대는 게 안전.

### (4) `FlexGridCellTemplate` (React) — JSX 커스텀 셀 ★ NSCM에서 React 컴포넌트를 셀에 넣을 때
```tsx
<FlexGrid itemsSource={view}>
  <FlexGridColumn binding="status" header="상태">
    {/* cellType: 'Cell' | 'CellEdit' | 'ColumnHeader' | 'Group' ... */}
    <FlexGridCellTemplate cellType="Cell" template={(ctx) => (
      <StatusBadge value={ctx.item.status} />
    )} />
  </FlexGridColumn>
</FlexGrid>
```
- `ctx.item` = 행 데이터, `ctx.value` = 셀 값, `ctx.row`/`ctx.col` = 인덱스.
- React 컨텍스트(Context) 접근에 제약이 있으니, 셀 컴포넌트는 props로 데이터를 받게 설계.

**선택 가이드**: 단순 포맷 → (1) / 정형 위젯 → (2) / 성능·조건부 스타일 → (3) / 진짜 React 컴포넌트 필요 → (4).

### 검증 메시지 표시 (CollectionView.getError)
```ts
view.getError = (item, prop) => {
  if (prop === 'qty' && item.qty < 0) return '수량은 0 이상';
  return null;
};
grid.showErrors = true; // 셀에 에러 표시
```

---

## 7. DataMap — 코드/명칭 드롭다운 (SCM 마스터에서 필수)

저장은 코드값, 표시는 명칭인 전형적 패턴.
```ts
import { DataMap } from '@mescius/wijmo.grid';

// [{ id, name }, ...] 형태 lookup → 코드(id) 저장, 명칭(name) 표시 + 편집 시 드롭다운
const plantMap = new DataMap(plantList, 'id', 'name');

// 열에 연결
{ binding: 'plantId', header: '공장', dataMap: plantMap }
```
```tsx
// React
<FlexGridColumn binding="plantId" header="공장" dataMap={plantMap} />
```
- 편집 시 자동으로 콤보 에디터가 뜬다. `dataMap.getDisplayValue(key)` / `getKeyValue(display)`로 양방향 변환 가능.
- 동적 lookup(서버 비동기)일 경우 데이터 로드 완료 후 `dataMap`을 세팅하고 `grid.invalidate()`.

---

## 8. 자주 쓰는 기능 스니펫

```ts
// 고정 행/열 (틀고정)
grid.frozenColumns = 2;
grid.frozenRows = 1;

// 셀 병합 (같은 값 인접 셀 병합)
grid.allowMerging = 'Cells'; // 'None'|'Cells'|'ColumnHeaders'|'RowHeaders'|'AllHeaders'|'All'
col.allowMerging = true;

// 선택 모드
grid.selectionMode = 'Row'; // 'None'|'Cell'|'CellRange'|'Row'|'RowRange'|'ListBox'

// 그룹 합계/패널은 wijmo.grid.grouppanel + GroupDescription 사용

// Enter/Tab 키 동작
grid.keyActionEnter = 'MoveDown';   // KeyAction
grid.keyActionTab   = 'MoveAcross';

// 셀 값 직접 읽기/쓰기 (가능하면 데이터 객체를 직접 다루는 것이 우선)
const v = grid.getCellData(r, c, false); // false=원시값, true=포맷된 문자열
grid.setCellData(r, c, 100);

// 엑셀 내보내기 (별도 모듈)
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
FlexGridXlsxConverter.saveAsync(grid, { includeColumnHeaders: true }, 'export.xlsx');
```

### 클립보드 (Excel 라운드트립)
`grid.autoClipboard = true`(기본)면 Ctrl+C/Ctrl+V가 Excel 호환으로 동작. 붙여넣기 검증은 `pastingCell` 이벤트에서.

---

## 9. React 통합 — 가장 중요한 함정

NSCM이 React라서 여기서 버그가 가장 많이 난다.

### (1) ★★★ CollectionView를 렌더마다 새로 만들지 말 것
```tsx
// ❌ 틀림: 매 렌더마다 새 CollectionView → 정렬/선택/trackChanges/스크롤 위치 전부 초기화
function Grid({ rows }) {
  const view = new CollectionView(rows, { trackChanges: true }); // 매번 재생성!
  return <FlexGrid itemsSource={view} />;
}

// ✅ 맞음: 안정적 참조 유지
function Grid({ rows }) {
  const view = useMemo(() => new CollectionView(rows, { trackChanges: true }), []);
  // rows가 비동기로 나중에 도착하면 view.sourceCollection 갱신:
  useEffect(() => {
    view.sourceCollection = rows;   // 또는 deferUpdate로 묶어 처리
  }, [rows]);
  return <FlexGrid itemsSource={view} />;
}
```
> `itemsSource`에 매 렌더 새 배열/뷰가 들어가면 그리드가 통째로 재구성되어 trackChanges가 리셋된다. **참조 안정성**이 핵심.

### (2) 컨트롤 인스턴스 접근은 `initialized`
```tsx
const gridRef = useRef<FlexGrid>();
<FlexGrid
  itemsSource={view}
  initialized={(g: FlexGrid) => { gridRef.current = g; }}
/>
// 이후 gridRef.current?.itemFormatter = ... / .scrollIntoView(...) 등
```

### (3) props는 camelCase
`itemsSource`, `isReadOnly`, `allowAddNew`, `autoGenerateColumns`, `frozenColumns` — 전부 카멜케이스. kebab-case는 Vue 문법이므로 React에서 쓰면 안 됨.

---

## 10. 안티패턴 → 올바른 패턴 (Claude Code 교정용)

| ❌ Claude Code가 흔히 하는 것 | ✅ 올바른 Wijmo FlexGrid |
|---|---|
| `gridApi`, `columnDefs`, `rowData` 사용 | AG Grid 문법. FlexGrid엔 없음. `columns` + `itemsSource` |
| `renderCell`, `valueGetter`, `valueFormatter` | MUI 문법. `cellTemplate`/`itemFormatter`/`column.format` |
| `sheet.getCell(r,c).value()` | SpreadJS 문법. FlexGrid는 `getCellData(r,c)` 또는 데이터 객체 직접 |
| `@grapecity/wijmo` / `wijmo` 임포트 | `@mescius/wijmo*` |
| 렌더마다 `new CollectionView(...)` | `useMemo`/`useRef`로 1회 생성 |
| 원본 배열 `push`/직접 수정 후 저장 | `view.addNew/commitNew`, `editItem/commitEdit` (trackChanges 위해) |
| `cell.innerHTML`로 직접 DOM 조립 | `CellMaker` 또는 `FlexGridCellTemplate` |
| 정렬/필터 변경 후 화면 안 바뀜 | `view.refresh()` 호출 |
| `yyyy-mm-dd` 포맷 | `yyyy-MM-dd` (월은 대문자) |
| 자동 열 생성 그대로 둠 | `autoGenerateColumns={false}` + 명시적 `columns` |
| 코드값을 그대로 표시 | `DataMap`으로 코드↔명칭 매핑 |

---

## 11. CLAUDE.md에 붙여넣을 규칙 블록

```md
## Wijmo FlexGrid 규칙 (doc/wijmo-flexgrid-guide.md 참조)
- 패키지는 반드시 `@mescius/wijmo*`. `@grapecity`/`wijmo`/AG Grid/MUI/SpreadJS API 사용 금지.
- 데이터는 `CollectionView`(itemsSource)로 다룬다. 정렬/필터/그룹/페이징/변경추적은 CollectionView 책임.
- 편집 결과 저장은 trackChanges + itemsEdited/Added/Removed 사용. 원본 객체 직접 수정 금지.
- 셀 커스텀: 포맷=column.format / 위젯=CellMaker / 성능·스타일=itemFormatter / React컴포넌트=FlexGridCellTemplate. DOM 직접 조립 금지.
- React: CollectionView는 useMemo/useRef로 1회 생성(렌더마다 재생성 금지), 인스턴스는 initialized로 획득, props는 camelCase.
- 열은 autoGenerateColumns=false + 명시적 columns. 코드/명칭은 DataMap.
- 구현 전 이 가이드의 "안티패턴 → 올바른 패턴" 표를 확인할 것.
```

---

## 12. 공식 레퍼런스

- FlexGrid API: `https://developer.mescius.com/wijmo/api/classes/Wijmo_Grid.Flexgrid.html`
- CollectionView API: `https://developer.mescius.com/wijmo/api/classes/Wijmo.Collectionview.html`
- React 시작 가이드: `https://developer.mescius.com/wijmo/docs/GettingStarted/React-Components`
- 편집/변경추적 문서: `https://developer.mescius.com/wijmo/docs/Topics/Wijmo/Collections/Editing-Views`
- 데모(React): `https://developer.mescius.com/wijmo/demos/Grid/Overview/react`
