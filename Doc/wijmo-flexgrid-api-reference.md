# Wijmo FlexGrid 완전 API 레퍼런스 (NSCM)

> **용도**: Claude Code / 개발자가 속성·메서드·이벤트·Enum을 즉시 grep해서 쓰는 레퍼런스.
> 개념·안티패턴은 `doc/wijmo-flexgrid-guide.md`, 정확한 시그니처는 본 파일.
> **기준 버전**: `@mescius/wijmo` **5.20261.50** (MESCIUS, 구 GrapeCity)
> **출처**: developer.mescius.com API/Docs + mescius.co.kr/docs. 패키지 스코프는 항상 `@mescius/*`.
> **표기**: `(d=값)`=기본값, `[Enum]`=문자열 리터럴 허용(React JSX에서 문자열로 전달 가능), `(ro)`=읽기전용.

---

## 1. 패키지 맵 (무엇을 어디서 import 하나)

| 기능 | 패키지 | 주요 export |
|---|---|---|
| 코어/데이터 | `@mescius/wijmo` | `CollectionView`, `SortDescription`, `PropertyGroupDescription`, `DataType`, `Globalize`, `format`, `toggleClass` |
| 그리드 코어(코드 생성) | `@mescius/wijmo.grid` | `FlexGrid`, `Column`, `DataMap`, `CellRange`, `CellType`, `SelectionMode`, `Row`, `GroupRow` |
| 그리드 React 래퍼 | `@mescius/wijmo.react.grid` | `FlexGrid`, `FlexGridColumn`, `FlexGridCellTemplate` |
| 컬럼 필터 | `@mescius/wijmo.grid.filter` / `@mescius/wijmo.react.grid.filter` | `FlexGridFilter` |
| 검색 | `@mescius/wijmo.grid.search` / `@mescius/wijmo.react.grid.search` | `FlexGridSearch` |
| 그룹 패널 | `@mescius/wijmo.grid.grouppanel` / `@mescius/wijmo.react.grid.grouppanel` | `GroupPanel` |
| 셀 위젯 | `@mescius/wijmo.grid.cellmaker` | `CellMaker`, `SparklineMarkers` |
| 마스터-디테일 | `@mescius/wijmo.grid.detail` / `...react.grid.detail` | `FlexGridDetailProvider`, `FlexGridDetail` |
| 멀티로우(다단 헤더) | `@mescius/wijmo.grid.multirow` / `...react.grid.multirow` | `MultiRow` |
| 엑셀 입출력 | `@mescius/wijmo.grid.xlsx` | `FlexGridXlsxConverter` |
| PDF 출력 | `@mescius/wijmo.grid.pdf` | `FlexGridPdfConverter` |
| 입력 컨트롤(에디터) | `@mescius/wijmo.input` / `@mescius/wijmo.react.input` | `ComboBox`, `InputDate`, `InputNumber`, `AutoComplete`, `MultiSelect`, `Menu` |
| CSS(필수) | `@mescius/wijmo.styles/wijmo.css` | — |
| 한국어 culture(옵션) | `@mescius/wijmo/cultures/wijmo.culture.ko` | — |

> 코드로 컨트롤을 만들면 코어 모듈(`@mescius/wijmo.grid`), JSX로 선언하면 React 모듈(`@mescius/wijmo.react.grid`). 섞지 말 것.

---

## 2. FlexGrid — 속성 (옵션)

생성자 옵션이자 인스턴스 속성. React에서는 동일 이름을 camelCase prop으로 전달.

| 속성 | 타입 / 값 | 의미 |
|---|---|---|
| `itemsSource` | `any[]` \| `CollectionView` | 데이터 소스. 배열을 주면 내부에서 CV로 래핑 |
| `collectionView` | `CollectionView` (ro) | 실제 사용 중인 CV |
| `autoGenerateColumns` | `boolean` (d=true) | 데이터 속성으로 열 자동 생성 |
| `columns` | `Column[]` / `ColumnCollection` | 열 정의 |
| `rows` | `RowCollection` (ro) | 행 컬렉션 (`rows[i].dataItem`로 데이터 접근) |
| `isReadOnly` | `boolean` (d=false) | 전체 읽기전용 |
| `allowAddNew` | `boolean` (d=false) | 신규행(`*`) 표시 |
| `allowDelete` | `boolean` (d=false) | Delete 키로 행 삭제 |
| `allowSorting` | `[AllowSorting]` `None`/`SingleColumn`/`MultiColumn` (d=SingleColumn) | 정렬(헤더 클릭). boolean도 허용 |
| `allowResizing` | `[AllowResizing]` `None`/`Columns`/`Rows`/`Both`/`ColumnsAllCells`/`RowsAllCells`/`BothAllCells` (d=Columns) | 크기 조절 |
| `allowDragging` | `[AllowDragging]` `None`/`Columns`/`Rows`/`Both` (d=Columns) | 열/행 드래그 이동 |
| `allowMerging` | `[AllowMerging]` `None`/`Cells`/`ColumnHeaders`/`RowHeaders`/`AllHeaders`/`All` (d=None) | 셀 병합 |
| `allowPinning` | `[AllowPinning]` `None`/`SingleColumn`/`MultiColumn`/... (d=None) | 열 고정 UI |
| `selectionMode` | `[SelectionMode]` `None`/`Cell`/`CellRange`/`Row`/`RowRange`/`ListBox` (d=CellRange) | 선택 단위 |
| `selection` | `CellRange` | 현재 선택 범위 |
| `frozenColumns` | `number` (d=0) | 좌측 고정 열 수 |
| `frozenRows` | `number` (d=0) | 상단 고정 행 수 |
| `headersVisibility` | `[HeadersVisibility]` `None`/`Column`/`Row`/`All` (d=All) | 헤더 표시 |
| `autoSizeMode` | `[AutoSizeMode]` `None`/`Headers`/`Cells`/`Both` (d=Both) | 자동 크기 산정 기준 |
| `autoClipboard` | `boolean` (d=true) | Ctrl+C/V Excel 호환 |
| `showSort` | `boolean` (d=true) | 정렬 화살표 표시 |
| `showGroups` | `boolean` (d=true) | 그룹 행 표시 |
| `showAlternatingRows` | `boolean` (d=true) | 줄무늬 |
| `showMarquee` | `boolean` (d=false) | Excel식 선택 테두리 |
| `showErrors` | `boolean` (d=true) | `getError` 결과를 셀에 표시 |
| `validateEdits` | `boolean` (d=true) | 편집 시 검증 수행 |
| `itemFormatter` | `(panel,r,c,cell)=>void` | 셀 명령형 포맷터 |
| `itemValidator` | `(r,c,parsing)=>string` | 셀 검증 콜백 |
| `keyActionEnter` | `[KeyAction]` `None`/`MoveDown`/`MoveAcross`/`Cycle`/`CycleOut`/`MoveAcrossOut` (d=MoveDown) | Enter 동작 |
| `keyActionTab` | `[KeyAction]` (d=None) | Tab 동작 |
| `childItemsPath` | `string` \| `string[]` | 트리 그리드용 자식 경로 |
| `groupHeaderFormat` | `string` | 그룹 헤더 표시 형식 |
| `newRowAtTop` | `boolean` (d=false) | 신규행을 상단에 |
| `quickAutoSize` | `boolean` (d=true) | 빠른 자동 크기(렌더 셀만) |
| `deferResizing` | `boolean` (d=false) | 리사이즈 미리보기 |
| `imeEnabled` | `boolean` (d=false) | IME(한글 등) 입력 |
| `isDisabled` | `boolean` (d=false) | 비활성화 |
| `stickyHeaders` | `boolean` (d=false) | 스크롤 시 헤더 고정 |
| `bigCheckboxes` | `boolean` (d=false) | 큰 체크박스 |
| `treeIndent` | `number` | 트리 들여쓰기 px |
| `virtualizationThreshold` | `number` | 가상화 임계 행 수 |

---

## 3. FlexGrid — 메서드

| 메서드 | 시그니처 / 반환 | 의미 |
|---|---|---|
| `getCellData` | `(r, c, formatted: boolean) => any` | 셀 값. `false`=원시값, `true`=포맷 문자열 |
| `setCellData` | `(r, c, value, refresh?, custom?) => boolean` | 셀 값 설정 |
| `getColumn` | `(name) => Column` | 이름/바인딩으로 열 |
| `getMergedRange` | `(panel, r, c, clip?) => CellRange` | 병합 범위 |
| `select` | `(rng \| r, c?, show?) => void` | 선택 지정 |
| `scrollIntoView` | `(r, c) => boolean` | 셀이 보이도록 스크롤 |
| `startEditing` | `(fullEdit?, r?, c?) => boolean` | 편집 시작 |
| `finishEditing` | `(cancel?) => boolean` | 편집 종료/확정 |
| `canEditCell` | `(r, c) => boolean` | 편집 가능 여부 |
| `refresh` | `(fullUpdate=true) => void` | 전체 갱신 |
| `refreshCells` | `(fullUpdate, recycle?, state?) => void` | 셀만 갱신(itemFormatter 재적용) |
| `invalidate` | `(fullUpdate=true) => void` | 비동기 재렌더 예약 |
| `autoSizeColumn(s)` | `(c, header?, extra?) / (firstCol?, lastCol?, ...)` | 열 너비 자동 |
| `autoSizeRow(s)` | 유사 | 행 높이 자동 |
| `beginUpdate` / `endUpdate` | `() => void` | 갱신 일괄 처리(성능) |
| `deferUpdate` | `(fn) => void` | 함수 실행 동안 갱신 보류 |
| `collapseGroupsToLevel` | `(level) => void` | 그룹 레벨까지 접기 |
| `getCellBoundingRect` | `(r, c, ...) => Rect` | 셀 위치 |
| `hitTest` | `(pt \| x, y) => HitTestInfo` | 좌표→셀 |
| `getClipString` / `setClipString` | clipboard 텍스트 | 복붙 제어 |
| `focus` | `() => void` | 포커스 |
| `dispose` | `() => void` | 정리(React unmount 시 자동) |
| `toggleDropDownList` | `() => boolean` | 현재 셀 드롭다운 토글 |

---

## 4. FlexGrid — 이벤트 (`grid.event.addHandler(fn)`)

React에서는 동일 이름을 prop으로 전달: `<FlexGrid cellEditEnding={(s,e)=>...} />`.
대부분의 args는 `(sender, args)`. 취소 가능 이벤트는 `e.cancel = true`.

| 이벤트 | args 타입 | 취소 | 용도 |
|---|---|---|---|
| `initialized` | `(grid)` | — | (React) 컨트롤 인스턴스 획득 |
| `itemsSourceChanged` | `EventArgs` | — | 데이터 소스 교체됨 |
| `selectionChanging` / `selectionChanged` | `CellRangeEventArgs` | ✓(changing) | 선택 변경 |
| `beginningEdit` | `CellRangeEventArgs` | ✓ | 편집 진입 차단 |
| `prepareCellForEdit` | `CellRangeEventArgs` | — | 에디터 준비 후 커스터마이즈 |
| `cellEditEnding` | `CellEditEndingEventArgs` | ✓ | 값 확정 직전 검증 (핵심) |
| `cellEditEnded` | `CellRangeEventArgs` | — | 확정 후 연쇄 계산 |
| `rowEditStarting`/`Started`/`Ending`/`Ended` | `CellRangeEventArgs` | ✓(ing) | 행 단위 편집 |
| `deletingRow` / `deletedRow` | `CellRangeEventArgs` | ✓(ing) | 행 삭제 |
| `rowAdded` | `CellRangeEventArgs` | — | 신규행 커밋됨 |
| `formatItem` | `FormatItemEventArgs` | — | 셀 렌더 시 포맷(이벤트형) |
| `pasting` / `pasted` | `CellRangeEventArgs` | ✓(ing) | 붙여넣기 검증 |
| `copying` / `copied` | `CellRangeEventArgs` | ✓(ing) | 복사 |
| `sortingColumn` / `sortedColumn` | `CellRangeEventArgs` | ✓(ing) | 정렬 |
| `resizingColumn` / `resizedColumn` | `CellRangeEventArgs` | ✓(ing) | 열 크기 |
| `draggingColumn` / `draggedColumn` | `CellRangeEventArgs` | ✓(ing) | 열 이동 |
| `groupCollapsedChanging`/`Changed` | `CellRangeEventArgs` | ✓(ing) | 그룹 접기 |
| `loadingRows` / `loadedRows` | `EventArgs` | — | 가상화 행 로드 |
| `updatingView` / `updatedView` / `updatingLayout` / `updatedLayout` | `EventArgs` | — | 렌더 라이프사이클 |
| `gotFocus` / `lostFocus` | `EventArgs` | — | 포커스 |
| `scrollPositionChanged` | `EventArgs` | — | 스크롤 |

`CellEditEndingEventArgs` 주요 멤버: `row`, `col`, `panel`, `cancel`, `stayInEditMode`, `data`.
`FormatItemEventArgs` 주요 멤버: `panel`, `row`, `col`, `cell`(HTMLElement), `range`.

---

## 5. Column — 속성

코드: `{ binding:'qty', header:'수량', ... }` / React: `<FlexGridColumn binding="qty" header="수량" .../>`.

| 속성 | 타입 / 값 | 의미 |
|---|---|---|
| `binding` | `string` | 데이터 속성명 (필수). `a.b.c` 중첩 경로 가능 |
| `header` | `string` | 헤더 텍스트 |
| `dataType` | `'String'`/`'Number'`/`'Boolean'`/`'Date'` `[DataType]` | 데이터 타입 |
| `format` | `string` | 표시 포맷 (10장) |
| `width` | `number` \| `string` | px 숫자 또는 `'*'`/`'2*'`(스타) / `'150'` |
| `minWidth` / `maxWidth` | `number` | 너비 제약 |
| `align` | `'left'`/`'center'`/`'right'` | 정렬 |
| `isReadOnly` | `boolean` | 열 읽기전용 |
| `isRequired` | `boolean` (d=true) | 빈 값 불가 |
| `allowSorting` | `boolean` (d=true) | 정렬 허용 |
| `allowResizing` | `boolean` | 크기조절 허용 |
| `allowDragging` | `boolean` | 이동 허용 |
| `allowMerging` | `boolean` | 병합 허용(그리드 allowMerging과 함께) |
| `cssClass` | `string` | 셀 CSS 클래스 |
| `cssClassAll` | `string` | 셀+헤더 CSS 클래스 |
| `dataMap` | `DataMap` \| `any[]` | 코드↔명칭 매핑/드롭다운 (7장) |
| `dataMapEditor` | `[DataMapEditor]` `Auto`/`DropDownList`/`AutoComplete`/`RadioButtons`/`None` | 매핑 에디터 종류 |
| `editor` | `Control` | 커스텀 에디터(InputDate 등) |
| `cellTemplate` | `(ctx)=>string` | 셀 커스텀 렌더(CellMaker 결과) |
| `aggregate` | `[Aggregate]` `Sum`/`Avg`/`Cnt`/`Max`/`Min`/... | 그룹/합계행 집계 |
| `visible` | `boolean` (d=true) | 표시 여부 |
| `wordWrap` | `boolean` | 자동 줄바꿈 |
| `multiLine` | `boolean` | 멀티라인 편집 |
| `mask` | `string` | 입력 마스크(예: `'000-0000'`) |
| `inputType` | `string` | input 타입(`'tel'` 등) |
| `isContentHtml` | `boolean` | 셀 내용을 HTML로 |
| `dropDownCssClass` | `string` | dataMap 드롭다운 CSS |
| `sortMemberPath` | `string` | 정렬 기준 다른 속성 |
| `quickAutoSize` | `boolean` | 빠른 자동크기 대상 |
| `name` | `string` | 열 식별자(getColumn 용) |

---

## 6. CollectionView — 옵션 / 속성 / 메서드

```ts
new CollectionView(sourceArray, { /* 아래 옵션 */ });
```

### 옵션·속성
| 멤버 | 타입 / 값 | 의미 |
|---|---|---|
| `sourceCollection` | `any[]` | 원본 배열 (교체 시 뷰 갱신) |
| `items` | `any[]` (ro) | 정렬/필터/페이징 적용된 결과 |
| `currentItem` / `currentPosition` | `any` / `number` | 현재 항목 (그리드 선택과 연동) |
| `sortDescriptions` | `SortDescription[]` | `new SortDescription('field', asc:boolean)` |
| `groupDescriptions` | `GroupDescription[]` | `new PropertyGroupDescription('field')` |
| `filter` | `(item)=>boolean` | 술어 필터 |
| `filters` | `IPredicate[]` (ro) | 추가 필터 컬렉션 |
| `pageSize` / `pageIndex` / `pageCount` | `number` | 페이징 |
| `trackChanges` | `boolean` (d=false) | 변경 추적 활성화 |
| `itemsAdded` / `itemsEdited` / `itemsRemoved` | `ObservableArray` (ro) | 추적된 변경(trackChanges 필요) |
| `newItemCreator` | `()=>any` | 신규행 기본 객체 생성 |
| `getError` | `(item, prop)=>string\|null` | 셀 검증 |
| `sortComparer` | `(a,b)=>number` | 커스텀 정렬 비교 |
| `sortNulls` | `[SortNulls]` `First`/`Last` | null 정렬 위치 |
| `useStableSort` | `boolean` | 안정 정렬 |
| `canAddNew`/`canRemove`/`canFilter`/`canGroup`/`canSort` | `boolean` (ro) | 지원 여부 |
| `isAddingNew`/`isEditingItem`/`isUpdating`/`isEmpty` | `boolean` (ro) | 상태 |

### 메서드
| 메서드 | 의미 |
|---|---|
| `addNew()` / `commitNew()` / `cancelNew()` | 신규행 트랜잭션 |
| `editItem(item)` / `commitEdit()` / `cancelEdit()` | 편집 트랜잭션 |
| `remove(item)` / `removeAt(idx)` | 삭제 |
| `clearChanges()` | 변경 추적 컬렉션 초기화(저장 후) |
| `refresh()` | 정렬/필터 재적용 |
| `deferUpdate(fn)` | 일괄 변경 |
| `getAggregate(type, binding, currentPage?)` | 집계값 |
| `moveCurrentTo(item)` / `moveCurrentToFirst/Last/Next/Previous/Position(n)` | 현재 항목 이동 |
| `moveToPage(n)` / `moveToFirst/Last/Next/PreviousPage()` | 페이지 이동 |

### 이벤트
`collectionChanged`, `currentChanging`(✓cancel), `currentChanged`, `sourceCollectionChanging/Changed`, `pageChanging`(✓)/`pageChanged`.

> **변경 추적 규칙(공식)**: CollectionView의 메서드(`editItem/commitEdit`, `addNew/commitNew`, `remove`)를 통한 변경만 추적된다. 데이터 객체 직접 수정은 추적되지 않는다. FlexGrid 셀 편집은 내부적으로 이 메서드를 사용하므로 자동 추적된다.

---

## 7. DataMap — 코드/명칭 드롭다운

```ts
import { DataMap } from '@mescius/wijmo.grid';

// sourceArray, keyPath(저장값), displayPath(표시값)
const plantMap = new DataMap(plantList, 'code', 'name');

// 열 연결
{ binding: 'plantCode', header: '공장', dataMap: plantMap, dataMapEditor: 'DropDownList' }
```
| 멤버 | 의미 |
|---|---|
| `getDisplayValue(key)` | 코드→명칭 |
| `getKeyValue(display)` | 명칭→코드 |
| `getDisplayValues(item?)` | 표시값 목록 |
| `isEditable` | 자유 입력 허용 |
| `sortByDisplayValues` | 표시값 정렬 |
| `collectionView` | 내부 CV(동적 lookup 갱신 시) |

동적 lookup: 서버에서 받은 뒤 `new DataMap(...)` 재할당 → `grid.invalidate()`.

---

## 8. CellMaker — 셀 위젯 (`column.cellTemplate`)

```ts
import { CellMaker } from '@mescius/wijmo.grid.cellmaker';
```
| 함수 | 옵션(주요) | 용도 |
|---|---|---|
| `CellMaker.makeButton({text, click, cssClass, attributes})` | `${item.x}` 보간 가능 | 버튼 셀 |
| `CellMaker.makeLink({text, href, click})` | | 링크 셀 |
| `CellMaker.makeImage({label, value})` | | 이미지 셀 |
| `CellMaker.makeRating({range, min, max})` | | 별점 셀 |
| `CellMaker.makeSparkline({markers, maxPoints, label})` | `SparklineMarkers` | 스파크라인 |

`click: (e, ctx) => {...}` 에서 `ctx.item`=행 데이터, `ctx.row`/`ctx.col`=인덱스, `ctx.value`=셀 값.

---

## 9. 주요 Enum (React JSX에서 문자열 리터럴로 전달 가능)

```
SelectionMode : None | Cell | CellRange | Row | RowRange | ListBox
AllowMerging  : None | Cells | ColumnHeaders | RowHeaders | AllHeaders | All
AllowResizing : None | Columns | Rows | Both | ColumnsAllCells | RowsAllCells | BothAllCells
AllowDragging : None | Columns | Rows | Both
AllowSorting  : None | SingleColumn | MultiColumn
HeadersVisibility : None | Column | Row | All
AutoSizeMode  : None | Headers | Cells | Both
KeyAction     : None | MoveDown | MoveAcross | Cycle | CycleOut | MoveAcrossOut
DataType      : Empty | Boolean | Number | Date | String | Array | Object   (열에는 'String'/'Number'/'Date'/'Boolean')
Aggregate     : None | Sum | Cnt | Avg | Max | Min | Rng | Std | Var | StdPop | VarPop | First | Last | CntAll
CellType      : None | Cell | ColumnHeader | RowHeader | TopLeft | ColumnFooter | BottomLeft
DataMapEditor : Auto | DropDownList | AutoComplete | RadioButtons | None
```

> 코드(타입스크립트)에서는 `import { SelectionMode } from '@mescius/wijmo.grid'; grid.selectionMode = SelectionMode.Row;`
> JSX에서는 `selectionMode="Row"` 문자열로 가능(interop이 파싱).

---

## 10. 포맷 문자열 (Globalize / .NET 스타일)

| 숫자 | 의미 | 예 |
|---|---|---|
| `n0`/`n2` | 천단위 구분, 소수 0/2자리 | `12,345` / `12,345.00` |
| `c`/`c2` | 통화 | `₩12,345` |
| `p`/`p1` | 퍼센트 | `12.3%` |
| `f2` | 고정 소수 | `12.30` |
| `d` | 정수 | `12345` |
| `#,##0.##` | 커스텀 | `1,234.5` |

| 날짜 | 의미 | 예 |
|---|---|---|
| `d` / `D` | 짧은/긴 날짜 | culture 의존 |
| `yyyy-MM-dd` | 커스텀 (월=대문자 MM) | `2026-06-17` |
| `yyyy-MM-dd HH:mm:ss` | 일시 (24h) | `2026-06-17 14:30:00` |
| `HH:mm` | 시:분 | `14:30` |

> **함정**: 월은 **대문자 `MM`**, 분은 소문자 `mm`. `yyyy-mm-dd`는 월 자리에 분이 들어간다.

---

## 11. React Interop — 컴포넌트 & 사용 규칙

| 컴포넌트 | 패키지 | 비고 |
|---|---|---|
| `FlexGrid` | `@mescius/wijmo.react.grid` | 루트 그리드 |
| `FlexGridColumn` | 〃 | 자식으로 배치, props=Column 속성 |
| `FlexGridCellTemplate` | 〃 | `cellType` + `template` JSX 커스텀 셀 |
| `FlexGridFilter` | `...react.grid.filter` | 자식으로 추가하면 컬럼 필터 활성 |
| `FlexGridSearch` | `...react.grid.search` | 별도 검색 박스, `grid` prop 연결 |
| `GroupPanel` | `...react.grid.grouppanel` | 드래그 그룹 패널 |

규칙:
- props는 camelCase: `itemsSource`, `isReadOnly`, `allowAddNew`, `autoGenerateColumns`, `frozenColumns`, `selectionMode`.
- 인스턴스 접근: `initialized={(g)=>{ ref.current = g; }}`.
- `CollectionView`는 `useMemo`/`useRef`로 1회 생성(렌더마다 재생성 금지 — trackChanges/선택/스크롤 리셋됨).
- `FlexGridCellTemplate`의 `cellType`: `'Cell'`/`'CellEdit'`/`'ColumnHeader'`/`'RowHeader'`/`'Group'`/`'ColumnFooter'`.

---

## 12. 보조 모듈 한 줄 요약

| 모듈 | 핵심 |
|---|---|
| `wijmo.grid.filter` | `new FlexGridFilter(grid)` 또는 `<FlexGridFilter/>` — 엑셀식 컬럼 필터 |
| `wijmo.grid.search` | `<FlexGridSearch grid={ref}/>` — 전체 텍스트 검색 |
| `wijmo.grid.grouppanel` | 드래그 앤 드롭 그룹화 패널 |
| `wijmo.grid.xlsx` | `FlexGridXlsxConverter.saveAsync(grid, opts, 'x.xlsx')` / `loadAsync` |
| `wijmo.grid.pdf` | `FlexGridPdfConverter.export(grid, 'x.pdf', opts)` |
| `wijmo.grid.multirow` | `MultiRow` — 한 데이터 행을 여러 표시 행으로(다단 레이아웃) |
| `wijmo.grid.detail` | `FlexGridDetailProvider` — 행 확장 마스터-디테일 |
| `wijmo.grid.immutable` | 불변 데이터/Redux 연동 바인딩 |
| `wijmo.grid.transposed` | 행↔열 전치 그리드 |

---

## 13. 최소 동작 보일러플레이트 (React + TS, copy-paste)

```tsx
import { useMemo, useRef, useEffect } from 'react';
import { CollectionView, SortDescription } from '@mescius/wijmo';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';
import { DataMap } from '@mescius/wijmo.grid';
import type { FlexGrid as FlexGridCtl } from '@mescius/wijmo.grid';
import '@mescius/wijmo.styles/wijmo.css';

type Row = { plantCode: string; itemCode: string; qty: number; planDate: Date };

export function PlanGrid({ rows, plants }: { rows: Row[]; plants: {code:string;name:string}[] }) {
  const gridRef = useRef<FlexGridCtl>();
  const plantMap = useMemo(() => new DataMap(plants, 'code', 'name'), [plants]);

  // CollectionView는 1회 생성 (변경추적 유지)
  const view = useMemo(() => new CollectionView<Row>(rows, {
    trackChanges: true,
    sortDescriptions: [new SortDescription('planDate', true)],
    getError: (item, prop) => (prop === 'qty' && item.qty < 0 ? '수량은 0 이상' : null),
  }), []);

  // 비동기로 데이터가 나중에 도착하면 소스만 교체
  useEffect(() => { view.sourceCollection = rows; }, [rows, view]);

  const save = () => {
    const payload = {
      added: view.itemsAdded.slice(),
      edited: view.itemsEdited.slice(),
      removed: view.itemsRemoved.slice(),
    };
    // ... 서버 저장 후
    view.clearChanges();
    return payload;
  };

  return (
    <FlexGrid
      itemsSource={view}
      autoGenerateColumns={false}
      selectionMode="Row"
      allowAddNew={true}
      allowDelete={true}
      frozenColumns={2}
      showErrors={true}
      initialized={(g: FlexGridCtl) => { gridRef.current = g; }}
      cellEditEnding={(s, e) => {
        const col = s.columns[e.col];
        if (col.binding === 'qty' && Number(s.activeEditor?.value) < 0) e.cancel = true;
      }}
    >
      <FlexGridColumn binding="plantCode" header="공장"   dataMap={plantMap} width={140} />
      <FlexGridColumn binding="itemCode"  header="품목"   width={160} />
      <FlexGridColumn binding="qty"       header="수량"   format="n0" align="right" />
      <FlexGridColumn binding="planDate"  header="계획일" dataType="Date" format="yyyy-MM-dd" width="*" />
      <FlexGridFilter />
    </FlexGrid>
  );
}
```

---

## 14. 공식 문서 링크 (1차 출처)

- 한국어 도움말 허브: `https://www.mescius.co.kr/docs#wijmo`
- 한국어 데모/포럼: `https://dev.mescius.co.kr`
- FlexGrid API: `https://developer.mescius.com/wijmo/api/classes/Wijmo_Grid.Flexgrid.html`
- Column API: `https://developer.mescius.com/wijmo/api/classes/Wijmo_Grid.Column.html`
- CollectionView API: `https://developer.mescius.com/wijmo/api/classes/Wijmo.Collectionview.html`
- React 컴포넌트 가이드: `https://developer.mescius.com/wijmo/docs/GettingStarted/React-Components`
- 데모 인덱스: `https://developer.mescius.com/wijmo/demos/`

> 본 레퍼런스는 5.20261.50 기준이며, 마이너 기본값/Enum 확장은 버전에 따라 달라질 수 있다. 특정 동작 확정이 필요하면 위 API 페이지에서 해당 멤버를 직접 확인할 것.
