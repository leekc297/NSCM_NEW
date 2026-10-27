import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
// import { type MutableRefObject, useEffect, useMemo } from 'react';
import { type MutableRefObject, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { PLANT_EDITABLE_COLUMNS } from '../project-route.constants';
import type { BomKey, PlantRow, SiteKey } from '../project-route.types';
import { deriveOrgDates } from '../utils/projectRoute.plantDerive';

interface Props {
  gridRef: MutableRefObject<FlexGrid<PlantRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PlantRow> | undefined>;
  data: PlantRow[];
  staticColumns: RawFlexGridColumnConfig[];
  siteKey: SiteKey | null;
  bomKey: BomKey | null;
  // CELL_TYPE 'CA*' 는 편집불가(design/03 R-EDIT). BOM 더블클릭으로 넘어온 cellType 로 판정.
  readOnly: boolean;
  // A5 spdPlant_CellDoubleClick → CAPA New Model 팝업(design/03, 2026-09-22 신규 배선). AS-IS 는
  //   그리드 전체 잠금 토글("Action" 컬럼 비표시=편집모드 아님)로 더블클릭의 의미를 가른다 —
  //   잠김(기본 조회 상태)이면 팝업, Edit 버튼으로 풀린 상태면 무반응(그 상태에선 대신 셀을 바로
  //   고친다). TO-BE 는 그 그리드 단위 토글이 없고 5개 컬럼이 항상 바로 편집 가능하므로(상시편집
  //   구조적 대체, 04_impl-gap-audit), "편집 가능한 셀이냐"를 그 대체 기준으로 쓴다 — 편집 가능
  //   컬럼(PLANT_EDITABLE_COLUMNS) 더블클릭은 그대로 셀 편집에 맡기고(무반응), 그 외 컬럼(읽기전용
  //   정보 컬럼) 더블클릭에서만 팝업을 연다. 그래야 AS-IS 처럼 "편집 동작"과 "팝업 열기"가 서로
  //   부딪히지 않는다.
  onRowDblClick: (row: PlantRow) => void;
  // 툴바 Filter(F4) 대상 추적용 — 이 그리드가 포커스를 얻으면 화면이 focusedSheetRef 를 갱신한다.
  gotFocus?: () => void;
}

// PRIORITY 양의 정수만 키인('.', '-' 입력 차단). AS-IS AddNumColumn 정수, N7(>=1) 과 정합.
const PLANT_NUMBER_RULES = {
  PRIORITY: { positiveOnly: true, integerOnly: true },
};

// Plant Assign(siPlant) — 편집 CRUD. PLANT_SITE_ID·VALID_YN·PRIORITY·FROM·TO 5개만 편집가능,
//   키/감사/파생 열은 잠금(design/03 §1.3, R-EDIT/R-INS-LOCK). FROM/TO 변경 → ORG/MERGE 파생(R-ORG).
export const ProjectRoutePlantGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  siteKey,
  bomKey,
  readOnly,
  onRowDblClick,
  gotFocus,
}: Props) => {
  // 셀 콤보(design/03 §4.5): PLANT_SITE_ID=PlantByDivisionOperationItem_SCP(division/operation/item),
  //   VALID_YN=YesOrNo. 파라미터는 홑따옴표 규약(nscm-patterns §3.3, comboParams 로 @토큰 치환).
  //   안전망(04_impl-gap-audit M1②): DB 메타가 아직 base 콤보(@itemId)로 바인딩돼 있고 `_SCP`(@param3)
  //   교정은 별도 DB 승인 대상이라, itemId/param3 둘 다 실어 base/`_SCP` 어느 쪽이 바인딩돼도 정합시킨다
  //   (makeComboQuery 는 SQL 에 없는 잉여 토큰을 무해하게 무시).
  const comboParams = useMemo(
    () => ({
      divisionId: `'${siteKey?.divisionId ?? ''}'`,
      operationGroup: `'${bomKey?.operationId ?? ''}'`,
      itemId: `'${bomKey?.itemId ?? ''}'`,
      param3: `'${bomKey?.itemId ?? ''}'`,
    }),
    [siteKey, bomKey]
  );

  // 편집 가능 컬럼 화이트리스트 강제(R-EDIT/R-INS-LOCK). admin 메타가 관대해도 5개 외 편집 차단.
  //   CELL_TYPE 'CA*'(readOnly) 면 전 컬럼 편집 차단.
  // handleInitialized 로 이관(useEffect 는 gridRef 미준비로 첫 로드 시 미부착).
  // useEffect(() => {
  //   const grid = gridRef.current;
  //   if (!grid) return;
  //   const beginningEditHandler = (
  //     s: FlexGrid<PlantRow>,
  //     e: { cancel: boolean; col: number }
  //   ) => {
  //     if (readOnly) {
  //       e.cancel = true;
  //       return;
  //     }
  //     const binding = s.columns[e.col]?.binding ?? '';
  //     const editable: readonly string[] = PLANT_EDITABLE_COLUMNS;
  //     if (!editable.includes(binding)) e.cancel = true;
  //   };
  //   grid.beginningEdit.addHandler(beginningEditHandler);
  //   return () => {
  //     try {
  //       grid.beginningEdit.removeHandler(beginningEditHandler);
  //     } catch {
  //       /* unmount race */
  //     }
  //   };
  // }, [gridRef, readOnly]);

  // PRIORITY 정수만 허용(AS-IS AddNumColumn 정수). '.' 키 차단, 커밋/붙여넣기 시 소수 버림.
  // handleInitialized 로 이관(useEffect 는 gridRef 미준비로 첫 로드 시 미부착).
  // useEffect(() => {
  //   const grid = gridRef.current;
  //   if (!grid) return;
  //   const isPriority = (col: number) => grid.columns[col]?.binding === 'PRIORITY';
  //   // const truncText = (v: string) => {
  //   //   const n = Number(v.replace(/,/g, ''));
  //   //   return Number.isFinite(n) ? String(Math.trunc(n)) : v;
  //   // };
  //   // 소수 버림 + 비숫자 제거(한글 IME 입력 정리 포함).
  //   const truncText = (v: string) => v.split('.')[0].replace(/\D/g, '');
  //   // const blockDotKey = (ev: KeyboardEvent) => {
  //   //   if (ev.key !== '.' && ev.key !== 'Decimal') return;
  //   //   if (!isPriority(grid.selection.col)) return;
  //   //   ev.preventDefault();
  //   // };
  //   // 키인은 숫자만. 제어키와 Ctrl/Meta/Alt 조합은 통과.
  //   const blockNonDigitKey = (ev: KeyboardEvent) => {
  //     if (ev.key.length !== 1 || ev.ctrlKey || ev.metaKey || ev.altKey) return;
  //     if (/\d/.test(ev.key) || !isPriority(grid.selection.col)) return;
  //     ev.preventDefault();
  //   };
  //   const truncOnCommit = (s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
  //     if (!isPriority(e.col)) return;
  //     const ed = s.activeEditor;
  //     // if (!ed || !ed.value.includes('.')) return;
  //     if (!ed || /^\d*$/.test(ed.value)) return;
  //     ed.value = truncText(ed.value);
  //   };
  //   const truncOnPaste = (_s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
  //     // if (!isPriority(e.col) || typeof e.data !== 'string' || !e.data.includes('.')) return;
  //     if (!isPriority(e.col) || typeof e.data !== 'string' || /^\d*$/.test(e.data)) return;
  //     e.data = truncText(e.data);
  //   };
  //   // grid.hostElement.addEventListener('keydown', blockDotKey, true);
  //   grid.hostElement.addEventListener('keydown', blockNonDigitKey, true);
  //   grid.cellEditEnding.addHandler(truncOnCommit);
  //   grid.pastingCell.addHandler(truncOnPaste);
  //   return () => {
  //     try {
  //       // grid.hostElement?.removeEventListener('keydown', blockDotKey, true);
  //       grid.hostElement?.removeEventListener('keydown', blockNonDigitKey, true);
  //       grid.cellEditEnding.removeHandler(truncOnCommit);
  //       grid.pastingCell.removeHandler(truncOnPaste);
  //     } catch {
  //       /* unmount race */
  //     }
  //   };
  // }, [gridRef]);

  // readOnly 는 BOM 선택마다 바뀌므로 initialized 1회 closure 대신 ref 로 참조.
  const readOnlyRef = useRef(readOnly);
  readOnlyRef.current = readOnly;

  // Wijmo initialized 는 setTimeout 으로 늦게 호출돼 화면 useEffect 시점엔 gridRef 가 비어 있다.
  //   그리드 생성 시점에 직접 건다.
  const handleInitialized = (grid: FlexGrid<PlantRow>) => {
    // 편집 가능 컬럼 화이트리스트(R-EDIT/R-INS-LOCK), readOnly 면 전 컬럼 차단.
    grid.beginningEdit.addHandler((s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
      const editable: readonly string[] = PLANT_EDITABLE_COLUMNS;
      if (readOnlyRef.current || !editable.includes(s.columns[e.col]?.binding ?? '')) e.cancel = true;
    });

    // PRIORITY 숫자 외 문자(영문/한글/기호) 키인 차단. numberRules 는 '.', '-' 만 막아 보강.
    const isPriority = (col: number) => grid.columns[col]?.binding === 'PRIORITY';
    grid.hostElement.addEventListener(
      'keydown',
      (ev: KeyboardEvent) => {
        if (ev.key.length !== 1 || ev.ctrlKey || ev.metaKey || ev.altKey) return;
        if (/\d/.test(ev.key) || !isPriority(grid.selection.col)) return;
        ev.preventDefault();
      },
      true
    );
    // 한글 IME 조합은 막을 수 없어 조합 종료 시 숫자만 남긴다.
    grid.prepareCellForEdit.addHandler((s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
      const editor = s.activeEditor;
      if (!editor || !isPriority(e.col)) return;
      const keepDigits = () => {
        const digits = editor.value.replace(/\D/g, '');
        if (digits !== editor.value) editor.value = digits;
      };
      editor.addEventListener('beforeinput', (ev: InputEvent) => {
        if (!ev.isComposing && ev.data && /\D/.test(ev.data)) ev.preventDefault();
      });
      editor.addEventListener('input', (ev: Event) => {
        if (!(ev as InputEvent).isComposing) keepDigits();
      });
      editor.addEventListener('compositionend', keepDigits);
    });
  };

  // FROM/TO 변경 → ORG_FROM/ORG_TO/MERGE_DATE 파생(R-ORG). EditTracker 뒤 실행 위해 prop 경유.
  const handleCellEdit = (grid: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    if (binding !== 'FROM_YYYYMMDD' && binding !== 'TO_YYYYMMDD') return;

    const record = dataItem as Record<string, unknown>;
    const derived = deriveOrgDates(record.FROM_YYYYMMDD, record.TO_YYYYMMDD);
    (Object.keys(derived) as (keyof typeof derived)[]).forEach(col => {
      editTrackerRef.current?.storeChange(dataItem, col, record[col] as string, derived[col]);
      record[col] = derived[col];
    });
    GridUtils.refreshRow(grid, e.row);
  };

  // A5(cs L1389-1446) — 더블클릭 시 CAPA New Model 팝업. 편집 가능 컬럼(위 Props.onRowDblClick
  //   주석 참고)은 셀 편집에 맡기고 무반응 — 그 외 컬럼만 팝업을 연다.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    const editable: readonly string[] = PLANT_EDITABLE_COLUMNS;
    if (!readOnly && editable.includes(binding)) return;
    const row = grid.rows[ht.row]?.dataItem as PlantRow | undefined;
    if (row) onRowDblClick(row);
  };

  return (
    <DataGrid<PlantRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      comboParams={comboParams}
      numberRules={PLANT_NUMBER_RULES}
      initialized={handleInitialized}
      cellEditEnded={handleCellEdit}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
