import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  DIVISION_ESS,
  LINE_COMBO,
  LINE_ID_EMPTY,
  MEASURE,
  OP_GROUP_PACK,
  OPERATION_GROUP_CODE,
} from '../integration-psi.constants';
import type { MainRow } from '../integration-psi.types';
import {
  buildFixedColumns,
  buildPivotColumns,
  fixedBindingSet,
} from '../utils/integrationPsiColumns';
import {
  type AuthContext,
  type EditLockContext,
  hasEditAuth,
  isBohCellEditable,
  isEssEditableColorCell,
  isPivotCellLocked,
  isPivotColumn,
} from '../utils/integrationPsiEditLock';

// 편집가능 셀 배경색 — AS-IS SetBGColor2 편집모드 연두(140,240,60) (design 03 §3-Color C1/C2).
//   hook#95 표준(편집가능=Yellow 계열)로 매핑. 잠금/실적 셀은 표준 회색.
const EDITABLE_BG_COLOR = '#e8fce0'; // 연두(편집가능 pivot 셀)
const LOCKED_BG_COLOR = '#f5f5f5'; // 회색(잠금 pivot 셀)

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const toNum = (v: unknown): number => {
  if (v === undefined || v === null || v === '') return 0;
  const n =
    typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : 0;
};

// 화면 operation_group 표시명(Pack/Cell/Electrode) → 셀콤보 매핑코드 (design 03 §2-D cs:1744-1755).
//   GET SP 는 OPERATION_GROUP 을 SEGMENT2(표시명)로 반환하므로 표시명 기준으로 매핑한다.
const opGroupCode = (row: Record<string, unknown>): string => {
  const name = s(row.OPERATION_GROUP);
  if (name === 'Pack') return OPERATION_GROUP_CODE.Pack; // P
  if (name === 'Cell') return OPERATION_GROUP_CODE.Cell; // A
  return OPERATION_GROUP_CODE.Electrode; // 기타 → E
};

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns: RawFlexGridColumnConfig[];
  division: string;
  auth: AuthContext;
  // MULTI_CHILD_ITEM lookup NAME 목록 (design 03 §1-L / L7 모듈 반제품 편집 예외). 미조회 시 빈 Set.
  multiChildItems: ReadonlySet<string>;
  // ESS(div82·Pack) 신규행 LINE_ID 콤보 분기 A 원천 — P_SCP0111_GET_ESS_PACK_LINE 결과 pool(COMPANY_ID 필터).
  //   SP 미배선 상태(05_register 대기)면 빈 배열 → 분기 A 후보 0건(design 03 §6 확인필요).
  essPackLineRows: ComboResponse[];
  // 파생검증 D1/D2 불일치 경고 — AS-IS "수량 불일치"(경고만, 저장 미차단). 메시지는 page 가 표시.
  onDerivMismatch: () => void;
  onFocus: () => void;
}

// AS-IS GSCM.SCP.Forms.UIL Analysis/SCP0111_IntegrationPSI spdMain — 고정 24열(SCM_MST_SHEET_COLUMNS 메타)
//   + 서버측 동적 YYYYMM PIVOT(P_SCP0111_GET_INTEGRATION_PSI O_RC). 편집잠금 L1~L23·조건색 C1/C2·
//   병합 M1~M4·신규행 LINE_ID 셀콤보(§2-D 분기 A/B)를 integrationPsiEditLock 순수함수로 재현.
//   메뉴/버튼/컬럼 메타 미등록(design 00 실측) → 05_register.sql(Task#5). 상수 이식 금지(메타 주도).
export const IntegrationPsiGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  division,
  auth,
  multiChildItems,
  essPackLineRows,
  onDerivMismatch,
  onFocus,
}: Props) => {
  // 분기 B 원천 — LineByOperationPlantId_SCP_ALL 전량 로드 후 PLANT_ID+SHOP_GROUP_ID 클라 필터
  //   (design 03 §2-D — AS-IS dtLineAll + DBUtils.Filter). 셀콤보는 신규행('I')에만 노출.
  const [lineByPlantRows] = useTabComboQueries({ filters: [LINE_COMBO.BY_PLANT] });

  // 편집 권한 보유 여부 — 편집 권한 전용 컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 가시성 기준.
  const canEdit = useMemo(() => hasEditAuth(auth), [auth]);

  const fixedBindings = useMemo(() => fixedBindingSet(adminColumns), [adminColumns]);
  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, canEdit),
    [adminColumns, canEdit]
  );
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], fixedBindings),
    [rows, fixedBindings]
  );

  const lockCtx = useMemo<EditLockContext>(
    () => ({ division, auth, multiChildItems }),
    [division, auth, multiChildItems]
  );

  // LINE_ID 신규행 셀콤보(insert-only) — 단일 DataMap 의 getDisplayValues 가 CRUD_TYPE='I' 행에만
  //   분기 A/B 후보를 돌려준다(insert-only-combo-hardcode 규약). 조회행/필터패널(행 컨텍스트 없음)은
  //   전체 목록 유지. 후보 = "-" 선두 + 각 분기 필터결과(design 03 §2-D 후처리 cs:1784-1788).
  const lineDataMap = useMemo(() => {
    const branchB = (lineByPlantRows ?? []).filter(r => s(r.CODE).trim() !== '');
    const branchA = (essPackLineRows ?? []).filter(r => s(r.CODE).trim() !== '');
    const all = [...branchA, ...branchB];
    if (all.length === 0) return null;
    const dataMap = new DataMap(all, 'CODE', 'NAME');
    const labels = (list: ComboResponse[]): string[] => [
      LINE_ID_EMPTY,
      ...list.map(r => String(dataMap.getDisplayValue(r.CODE))),
    ];
    dataMap.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as Record<string, unknown>;
      // 조회행(CRUD_TYPE 없음) / 행 컨텍스트 없는 호출(필터 패널) = 전체 목록(콤보 강제 안 함).
      if (s(row.CRUD_TYPE) !== 'I') return labels(all);
      const opCode = opGroupCode(row);
      // 분기 A — division=='82' && operation_group=='P'(ESS Pack): COMPANY_ID 필터(design 03 §2-D cs:1758).
      if (division === DIVISION_ESS && opCode === OP_GROUP_PACK) {
        const company = s(row.COMPANY_ID);
        return labels(branchA.filter(r => s(r.COMPANY_ID) === company));
      }
      // 분기 B — 그 외: PLANT_ID + SHOP_GROUP_ID(=OPERATION_GROUP 코드) 필터(design 03 §2-D cs:1769).
      const plant = s(row.PLANT_ID);
      return labels(
        branchB.filter(r => s(r.PLANT_ID) === plant && s(r.SHOP_GROUP_ID) === opCode)
      );
    };
    return dataMap;
  }, [lineByPlantRows, essPackLineRows, division]);

  // 잠금/색 핸들러가 최신값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const lockCtxRef = useRef(lockCtx);
  lockCtxRef.current = lockCtx;
  const fixedBindingsRef = useRef(fixedBindings);
  fixedBindingsRef.current = fixedBindings;
  const divisionRef = useRef(division);
  divisionRef.current = division;
  const onDerivMismatchRef = useRef(onDerivMismatch);
  onDerivMismatchRef.current = onDerivMismatch;

  // LINE_ID DataMap 지속 적용 — 공용 DataGrid 가 매 렌더 columnGroups 재대입으로 메타 콤보맵을
  //   덮으므로 updatedLayout 마다 재부착([[wijmo-columngroups-recreate-datamap]] 규약).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      if (!lineDataMap) return;
      const col = g.columns.getColumn('LINE_ID');
      if (col && col.dataMap !== lineDataMap) col.dataMap = lineDataMap;
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, lineDataMap, rows]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전건 잠금(L19) baseline + pivot 편집셀/BOH 셀만 해제 (design 03 §3-Lock).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      // BOH_QTY 셀 — measure=INV & seqFlag[1]=6 & isEdit 권한.
      if (binding === 'BOH_QTY') {
        if (!isBohCellEditable(row, lockCtxRef.current)) e.cancel = true;
        return;
      }
      // LINE_ID 셀 — 신규행('I')만 콤보 편집(design 03 §2-D 가드).
      if (binding === 'LINE_ID') {
        if (s(row.CRUD_TYPE) !== 'I') e.cancel = true;
        return;
      }
      // pivot(YYYYMM) 기간셀 — L2~L23 잠금 규칙. 고정 컬럼은 전건 잠금.
      if (!isPivotColumn(binding, fixedBindingsRef.current)) {
        e.cancel = true;
        return;
      }
      if (isPivotCellLocked(row, lockCtxRef.current)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 파생검증 D1/D2 (design 03 §3-Deriv) — ESS(div82) 수정 시 PROD_PLAN×CELL_CF ↔ IN_HOUSE_MOVING
    //   정합을 같은 아이템·월 기준으로 검증(경고만, 저장은 막지 않음). CELL_CF 결측 시 1 대체(cs:1997-2000).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      if (divisionRef.current !== DIVISION_ESS) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const measure = s(row.MEASURE);
      if (measure !== MEASURE.PROD_PLAN && measure !== MEASURE.IN_HOUSE_MOVING) return;

      const src = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      const item = s(row.ITEM_ID);
      const ym = binding;
      const cellCf = toNum(row.CELL_CF) || 1; // CELL_CF 결측/0 = 1 대체

      // ΣPROD_PLAN(same item, 해당월) × CELL_CF.
      const sumProdPlan = src
        .filter(r => s(r.ITEM_ID) === item && s(r.MEASURE) === MEASURE.PROD_PLAN)
        .reduce((a, r) => a + toNum(r[ym]), 0);
      // ΣIN_HOUSE_MOVING(toProduct=item, valueType≠'-', 해당월).
      const sumInHouse = src
        .filter(
          r =>
            s(r.TO_PRODUCT) === item &&
            s(r.MEASURE) === MEASURE.IN_HOUSE_MOVING &&
            s(r.VALUE_TYPE) !== '-'
        )
        .reduce((a, r) => a + toNum(r[ym]), 0);

      if (Math.round(sumProdPlan * cellCf) !== Math.round(sumInHouse)) {
        onDerivMismatchRef.current();
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 조건부 배경색 — ESS 편집가능 셀 연두(C1/C2), 잠금 pivot 셀 회색(hook#95 표준).
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      if (ev.panel.cellType !== CellType.Cell) return;
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return; // 고정 컬럼은 색상 대상 아님
      const row = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const ctx = lockCtxRef.current;
      if (isPivotCellLocked(row, ctx)) {
        ev.cell.style.backgroundColor = LOCKED_BG_COLOR;
        return;
      }
      // 편집가능 + ESS 조건색 대상 = 연두(C1/C2). 그 외 편집가능 셀은 기본색.
      if (isEssEditableColorCell(row, divisionRef.current)) {
        ev.cell.style.backgroundColor = EDITABLE_BG_COLOR;
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 고정 식별 컬럼 세로 병합(M1~M4 SmartColMerge) — pivot 컬럼은 병합 제외(buildPivotColumns allowMerging=false).
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = !isPivotColumn(b, fixedBindingsRef.current);
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
