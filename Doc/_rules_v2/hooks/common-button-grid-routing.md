# Hook #97 — common-button-grid-routing (공통버튼 표시·활성그리드 라우팅 + 행번호 컬럼)

> **트리거**: 화면 버튼/그리드 CRUD (T01 신규 / T01M 수정 / SubTitle hotkeyConfig / 다중 그리드 Insert·Delete / "No 컬럼")
> **상태**: ⭐⭐ 필수 (사용자 명시 2026-06-28, SYS0011/SYS0012/SYS0013)
> **PR 차단**: 그리드 안/위에 자체 Add/Delete 버튼 신설 금지(공통버튼 사용). rownum 중복 컬럼 금지.

---

## §1. 공통버튼은 SubTitle `hotkeyConfig` 만으로 표시 (권한 비-gating)
- `SubTitle`(packages/shared/.../sub-title/SubTitle.tsx)은 `buttonActions.insert/delete/save !== false` 면 **무조건 렌더**. 별도 권한 gating 없음.
- 즉 **공통 INSERT/DELETE 추가 = `hotkeyConfig.insert/delete = handler` 만** 하면 됨. 버튼 메타(`SCM_ADM_MNU_BTN_MPG_M`) 변경은 표시 조건이 아님(권한 일관성 위해 등록은 권장이나 표시엔 불필요).
- ❌ **그리드 모듈 안/상단(TitleArea rightButtons·자체 toolbar div)에 Add/Delete 버튼 신설 금지** → 상단 공통버튼으로 일원화 (SYS0011 myAuthList / SYS0013 columns·parameters toolbar 제거).

## §2. 다중 그리드 — 공통 Insert/Delete 를 활성(focused) 그리드로 라우팅
한 화면에 편집 그리드가 여럿이면(예: SYS0013 Columns·Condition / DMF0008 4그리드):
1. `focusedGrid` state + 각 그리드 래퍼 `onClickCapture={() => setFocused('x')}`.
2. 공통 `handleInsert/Delete` 가 `focusedGrid` 기준 분기(해당 그리드 track 함수 호출).
3. `SubTitle` 의 `grid`/`gridFilter` prop 도 focused 그리드 ref (Sort/Filter/Excel 대상 일치).
4. (탭/페이지 분기 시) `hotkeyConfig` 를 `activePage` 로 분기(Register=main / View=focused).
- 참조: `SYS0013 DynamicQuery.tsx` (focusedViewGrid) · `DMF0008 ErpEdiMaster.tsx` (focusedSheet, [[feedback_dmf0008_multigrid_save_and_routing]]).

## §3. No(행번호) 컬럼 — 그리드 유형별 2 방식
기존 rowHeader 인덱스 컬럼(1,2,3)이 이미 있으니 **중복 데이터 컬럼 주입 주의**.
| 그리드 | rowHeader 상태 | 방식 |
|---|---|---|
| **체크박스 없음**(selectionMode Row / isReadOnly) | rowHeader 인덱스가 1,2,3 표시 | **헤더 라벨만** 추가 — `formatItem` 에서 `e.panel.cellType === CellType.TopLeft` 코너 셀에 `e.cell.textContent='No'` + `e.cell.style.fontWeight='normal'`(헤더 기본 bold 해제). 1회 부착 가드. |
| **`useCheckbox`** | rowHeader 를 체크박스가 점유(행번호 없음) | **별도 No 컬럼 주입** — `staticColumns` 앞에 `{colNm:'ROW_NO', colLblNm:t('No'), inputTpCd:'S', ...}` + `itemsSource` 행에 `ROW_NO=index+1` 주입(withRowNo). |
- ❌ 체크박스 없는 그리드에 데이터 No 컬럼 주입 → rowHeader 인덱스와 **중복**. ❌ formatItem `textContent`만으로 주입컬럼 채우려다 미표시(데이터 바인딩이 확실).
- 참조: `features/authority/.../auth-request/auth-request.grid-utils.ts` (`buildNoColumn`/`withRowNo`/`attachRowNoHeader`).

## §4. CRUD pending — 부모키 변경 시 미저장 즉시 reset
마스터-디테일(부모 선택 → 자식 그리드 편집) 화면: 부모키(selectedId/SQL_ID) 변경 시 자식의 **미저장 Insert/Delete/Modify(pending+insertedRows)를 즉시 초기화**. 다른 부모로 이동 시 저장 안 한 행이 남으면 안 됨.
- 참조: `SYS0013 useDynamicQueryStore.setSelectedQueryId` (columns/parameters pending clear).

## §5. cross-ref
- 짝 hook: `subtitle-button-actions`(공통버튼 11종) · `screen-conventions` · `datagrid-shared-component-mandatory`
- wijmo: TopLeft 코너 = `Doc/wijmo-flexgrid-api-reference.md`
