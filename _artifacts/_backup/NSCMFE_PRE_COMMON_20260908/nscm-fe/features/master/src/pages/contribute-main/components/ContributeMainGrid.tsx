import { DataType, toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type CellEditEndingEventArgs,
  type CellRangeEventArgs,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { SHEETS } from '../contribute-main.constants';
import type { MainRow } from '../types';
import { useContributeMainStore } from '../useContributeMainStore';

interface Props {
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
}

// AS-IS analysis.md §10 — 다단 헤더 (period 라벨 + RBU 한글명 leaf) + Y#/M# 동적 PIVOT.
// BASE 6 컬럼: admin SHEET_COLUMNS (staticColumns) 로 동적 fetch — 하드코딩 0.
// PIVOT 컬럼: SP 응답 row[k] 에서 derive — dynamicColumns prop 으로 DataGrid 전달.
// chkYear: true → Y# (연도총계) / false → M# (월별).
const RBU_NAME_MAP: Record<string, string> = {
  RBU_0001: '대만',
  RBU_0002: '중국-화남',
  RBU_0008: '중국-화북',
  RBU_0003: '미주',
  RBU_0004: '유럽',
  RBU_0005: '일본',
  RBU_0007: '인도',
  RBU_0006: '기타',
  RBU_0999: '구분',
};
// 구분(Contribution Type) 컬럼 — 나머지 RBU 들이 기여율(숫자)인 것과 달리 문자열 컬럼.
const RBU_DIVISION = 'RBU_0999';
// 행 단위 입력 활성화 기준 — BE 가 내려주는 EDIT_FLAG 가 'Y' 인 행만 편집 가능.
// AS-IS DMF0043_Contribute_Main.cs L204 `LockRange(... EDIT_FLAG='N')` 의 TO-BE 대응.
// 주의: EDIT_FLAG 는 서버가 준 권한 값이므로 편집 여부 마킹으로 덮어쓰지 않는다
// (덮어쓰면 한 번 수정한 행이 잠겨버린다). dirty 마킹은 CRUD_TYPE 으로 한다.
const ROW_EDITABLE_FLAG = 'Y';
const isRowEditable = (row: MainRow | null | undefined): boolean =>
  row?.EDIT_FLAG === ROW_EDITABLE_FLAG;
// 구분 컬럼 입력 제한 — 숫자가 하나라도 섞이면 커밋 시점에 폐기 (문자만 저장).
const DIGIT_RE = /\d/;
// 폐기 사유 안내 — AS-IS 코드에는 없던 TO-BE 전용 메시지.
const DIVISION_TEXT_ONLY_MSG = {
  code: 'MSG_DIVISION_TEXT_ONLY',
  fallback: '구분 컬럼에는 숫자를 입력할 수 없습니다. 문자만 입력해 주세요.',
} as const;
const RBU_ORDER = [
  'RBU_0001',
  'RBU_0002',
  'RBU_0008',
  'RBU_0003',
  'RBU_0004',
  'RBU_0005',
  'RBU_0007',
  'RBU_0006',
  'RBU_0999',
];

interface DynColLeaf {
  binding: string;
  period: string;
  periodLabel: string;
  leafLabel: string;
  rbuCode: string;
}

// export 는 테스트 전용 — 구분(RBU_0999) 컬럼의 dataType 회귀를 잡는 단위 테스트가 참조한다.
//   (별도 파일로 빼지 않는 대신 fast-refresh 경고만 국소 해제)
// eslint-disable-next-line react-refresh/only-export-components
export const buildDynamicColumns = (data: MainRow[], chkYear: boolean): FlexGridColumnConfig[] => {
  if (!data || data.length === 0) return [];
  const prefix = chkYear ? 'Y#' : 'M#';
  const allKeys = new Set<string>();
  for (const row of data) {
    for (const k of Object.keys(row)) {
      if (k.startsWith(prefix)) allKeys.add(k);
    }
  }
  const leaves: DynColLeaf[] = Array.from(allKeys)
    .map(k => {
      const [, period, corp] = k.split('#');
      return {
        binding: k,
        period: period ?? '',
        periodLabel:
          period?.length === 6 ? `${period.slice(0, 4)}-${period.slice(4)}` : (period ?? ''),
        leafLabel: RBU_NAME_MAP[corp ?? ''] ?? corp ?? '',
        rbuCode: corp ?? '',
      };
    })
    .sort((a, b) => {
      const periodCmp = a.period.localeCompare(b.period);
      if (periodCmp !== 0) return periodCmp;
      return RBU_ORDER.indexOf(a.rbuCode) - RBU_ORDER.indexOf(b.rbuCode);
    });

  // DMF0007 customer-forecast-master 패턴 — 각 leaf 마다 별도 group (1:1) 으로 분리.
  // 같은 header 의 인접 group 은 wijmo 가 자동 가로 머지 → group cell rowspan 안 함.
  // ⭐ `height: 24` 의무 (= `HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH`, `columnMapping.ts:28`)
  // — DataGrid wrapper 가 staticColumns 만 자동 적용하므로 dynamicColumns 는 화면에서 명시.
  return leaves.map(leaf => {
    // RBU_0999 (구분 컬럼) = readonly. 그 외 Y#/M# = OPTIONAL 편집 가능.
    // GridUtils.isEditableCell 가 column._inputEditType 없으면 default false (편집 불가)
    // 처리 → 동적 컬럼에 명시 의무 (hook #70 P2 related).
    const isRbu999 = leaf.rbuCode === RBU_DIVISION;
    return {
      header: leaf.periodLabel || leaf.period,
      align: 'center',
      allowSorting: false,
      allowMerging: false,
      height: 24,
      visible: true,
      columns: [
        {
          binding: leaf.binding,
          header: leaf.leafLabel,
          width: 80,
          align: 'right',
          // 구분 컬럼은 문자 컬럼 — 숫자 서식(n2) 을 걸면 wijmo 가 값을 숫자로 파싱/표시한다.
          // dataType 을 명시하지 않으면 itemsSource 첫 값으로 추론돼 빈 데이터일 때 Number 로
          // 잡히는 사고가 나므로 String 고정.
          // 필수: 'f2' (fixed-point) — 'n2' 는 천단위 콤마를 붙인다(1234 입력 -> "1,234.00").
          //   입력한 숫자가 콤마 없이 그대로 보여야 한다(사용자 요구 2026-08-23). 소수 2자리는 유지.
          //   format 을 비우면 안 된다 — wijmo 기본 서식이 콤마를 다시 붙인다.
          //   'd0' 계열도 콤마는 없지만 columnMapping.isNumericFormat 이 'd' 를 제외해
          //   normalizeDynamicColumns 의 dataType=Number 자동 지정이 빠진다. 'f2' 는 그대로 유지된다.
          ...(isRbu999 ? { dataType: DataType.String } : { format: 'f2' }),
          allowSorting: false,
          allowMerging: false,
          height: 24,
          visible: true,
          _inputEditType: isRbu999
            ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
            : CELL_INPUT_EDIT_TYPE.OPTIONAL,
        },
      ],
    };
  }) as FlexGridColumnConfig[];
};

export const ContributeMainGrid = ({ gridRef, gridFilterRef, editTrackerRef, data }: Props) => {
  const internalRef = useRef<FlexGridType<MainRow> | undefined>();
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const chkYear = useContributeMainStore(s => s.searchParams.chkYear);
  const staticColumns = useContributeMainStore(s => s.staticColumns[SHEETS.MAIN]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns(data, chkYear),
    [data, chkYear]
  );

  // 동적 PIVOT 컬럼 cell coloring — 동적 컬럼 (admin 메타 없음) 에서 wrapper 의
  // formatEditableColumns 가 isEditableCell=false 로 판정해 wj-cell-editable 을 제거.
  // 따라서 wrapper 가 등록한 이후(=mount 시점) 핸들러를 다시 등록 → FIFO 호출 순서에서
  // wrapper 다음에 호출되어 최종 toggle 결과가 살아남음.
  // 색은 행 단위로 갈린다 — EDIT_FLAG='Y' 행만 노랑(편집), 나머지는 회색(잠금).
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;
    const handler = (_s: FlexGridType<MainRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const col = e.panel.columns[e.col];
      if (!col?.binding) return;
      if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
      const editable = isRowEditable(e.panel.rows[e.row]?.dataItem as MainRow | undefined);
      toggleClass(e.cell, 'wj-cell-editable', editable);
      toggleClass(e.cell, 'wj-cell-non-editable', !editable);
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handler);
  }, [staticColumns, dynamicColumns]);

  // 다단 헤더 row 높이는 buildDynamicColumns 의 group/leaf 객체 안 `height: 24` 로 해결됨.
  // (DataGrid wrapper 의 HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH = 24 정합).
  // hook #70 P2 — internalRef 는 useEffect 에서 gridRef.current 가 set 된 후 동기화.
  useEffect(() => {
    if (gridRef.current) internalRef.current = gridRef.current;
  }, [staticColumns, dynamicColumns]);

  // 동적 컬럼 (Y#/M#) 의 편집 허용 여부를 행 단위로 결정한다 (2026-08-11 사용자 요구).
  //   EDIT_FLAG='Y' → 편집 허용, 그 외('N' 등) → 잠금.
  // 공용 DataGrid wrapper 의 setEditableColumns 는 GridUtils.isEditableCell 로 판정하는데,
  // 동적 컬럼은 admin SHEET_COLUMNS 메타가 없어 컬럼 인덱스 정합이 보장되지 않는다 →
  // 여기서 (wrapper 다음 FIFO 로) 행 값 기준으로 최종 판정을 덮어쓴다.
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;
    const handler = (
      _s: FlexGridType<MainRow>,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const col = grid.columns[e.col];
      if (!col?.binding) return;
      if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
      e.cancel = !isRowEditable(grid.rows[e.row]?.dataItem as MainRow | undefined);
    };
    grid.beginningEdit.addHandler(handler);
    // 붙여넣기도 같은 게이트를 탄다 — 공용 wrapper 의 setEditableColumns 가 pastingCell 에도
    //   isEditableCell 을 걸어 두므로(`dataGridUtils.ts` L283), 여기서 덮어쓰지 않으면
    //   타이핑과 Ctrl+V 의 허용 범위가 어긋난다 (잠긴 행 붙여넣기 통과 / 허용 행 붙여넣기 차단).
    //   주의: 등록 순서 의존 — wijmo Event 는 등록 순서대로 호출한다. 이 effect 는 아래
    //   구분(RBU_0999) 숫자 거부 effect 보다 먼저 실행되므로 그 거부(cancel=true)가 최종값으로
    //   살아남는다. 두 effect 의 순서를 바꾸면 숫자 차단이 풀린다.
    grid.pastingCell.addHandler(handler as never);
    return () => {
      grid.beginningEdit.removeHandler(handler);
      grid.pastingCell.removeHandler(handler as never);
    };
  }, [staticColumns, dynamicColumns]);

  // ⭐ 2026-08-10 사용자 요구 — 구분(RBU_0999) 컬럼은 문자만 저장. 나머지 Y#/M# 은 기여율(숫자).
  //   타이핑 자체는 막지 않는다 — 숫자 컬럼에 'ㅇㅇㅇ' 를 쳐도 입력은 되고 셀을 벗어나는 순간
  //   버려지는 것과 동일한 방식 (cellEditEnding 에서 cancel → wijmo 가 편집값을 폐기하고
  //   원래 값으로 되돌림). `stayInEditMode` 는 쓰지 않는다 — 편집기가 갇혀 커서가 안 빠진다.
  //   pastingCell 은 편집모드가 아닌 그리드 단위 Ctrl+V 경로.
  //
  //   ⭐ 2026-08-11 — 폐기를 조용히 하지 않는다. 값이 사유 없이 사라지면 사용자에겐 버그와
  //   구분되지 않는다 (실제 그렇게 리포트됨). cancel 과 함께 반드시 사유를 알린다.
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;

    const isDivisionCol = (col: number) =>
      (grid.columns[col]?.binding ?? '').endsWith(RBU_DIVISION);

    // 알림은 편집 종료 처리가 끝난 뒤에 띄운다 — cellEditEnding 안에서 바로 모달을 열면
    //   wijmo 가 editor 를 정리하기 전에 포커스를 뺏겨 편집기가 남는다.
    const rejectWithNotice = () => {
      globalThis.setTimeout(() => {
        void setAlert({
          type: 'alert',
          content: t(DIVISION_TEXT_ONLY_MSG.code, DIVISION_TEXT_ONLY_MSG.fallback),
        });
      }, 0);
    };

    const editEndingHandler = (_s: FlexGridType<MainRow>, e: CellEditEndingEventArgs) => {
      if (!isDivisionCol(e.col)) return;
      if (!DIGIT_RE.test(grid.activeEditor?.value ?? '')) return;
      e.cancel = true; // 편집값 폐기 → 셀은 이전 값 유지
      rejectWithNotice();
    };

    const pastingHandler = (_s: FlexGridType<MainRow>, e: CellRangeEventArgs) => {
      if (!isDivisionCol(e.col)) return;
      if (!DIGIT_RE.test(String(e.data ?? ''))) return;
      e.cancel = true;
      rejectWithNotice();
    };

    grid.cellEditEnding.addHandler(editEndingHandler);
    grid.pastingCell.addHandler(pastingHandler);
    return () => {
      grid.cellEditEnding.removeHandler(editEndingHandler);
      grid.pastingCell.removeHandler(pastingHandler);
    };
  }, [staticColumns, dynamicColumns, setAlert, t]);

  // 사용자 F3 누르기 전 sort indicator 표시 사고 fix:
  // wijmo column.allowSorting 기본값 true → DataGrid wrapper 의 formatSortableColumns 가
  // 모든 column 에 wj-sort-unsorted-icon 표시. GridAction.toggleColumnSort(F3) 가 토글
  // 방식이라 default false 로 강제. 사용자가 F3 누르면 true 로 토글 → indicator 표시.
  useEffect(() => {
    const grid = internalRef.current;
    if (!grid) return;
    grid.columns.forEach(col => {
      col.allowSorting = false;
    });
    grid.invalidate();
  }, [dynamicColumns, staticColumns]);

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      staticColumns={staticColumns}
      // ⭐ 2026-08-11 — frozenColumns 를 화면에서 지정하지 않는다. 공용 DataGrid wrapper 가
      //   admin SHEET_COLUMNS 의 Fixed(=_fixed) 마지막 컬럼까지 자동 고정한다
      //   (`DataGrid.tsx` findLastIndex(_fixed)+1). contribute-view 와 동일 규약.
      //   ⚠️ 여기서 넘기면 wrapper 의 `{...gridProps}` 가 계산값 뒤에 펼쳐져 override 된다.
      //   기존 `staticColumns.filter(col => col.visible).length` 는 렌더 기준(`display`)이 아닌
      //   `visible` 로 세어 실제 표시 컬럼 수보다 적게 나왔고, 그래서 Fixed 가 형태(FORM)에
      //   걸려 있는데도 고정선이 제품군에서 끊겼다.
      dynamicColumns={dynamicColumns}
      itemsSource={data}
      allowMerging={AllowMerging.All}
      alternatingRowStep={0}
    />
  );
};
