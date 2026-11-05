import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';

import {
  CELL_COMBO_LOOKUP,
  DIVISION_ESS,
  INSERT_POPUP_COLS,
  LINE_COMBO,
  LINE_ID_EMPTY,
  MEASURE,
  MENU_ID,
  OP_GROUP_PACK,
  OPERATION_GROUP_CODE,
} from '../integration-psi.constants';
import type { MainRow } from '../integration-psi.types';
import type { MeasureMeta } from '../useIntegrationPsiStore';
import {
  buildFixedColumns,
  buildPivotColumns,
  fixedBindingSet,
  periodMonthRange,
} from '../utils/integrationPsiColumns';
import {
  type AuthContext,
  type EditLockContext,
  hasEditAuth,
  isBohCellEditable,
  isEssEditableColorCell,
  isInsertRowCellEditable,
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

// 고정목록 셀콤보 생성 — identity DataMap(value=display=값). 중복/공백 제거 후 비면 undefined(미부착).
//   Wave1 코드성 컬럼(OPERATION_GROUP/INCOTERMS/PLAN_TYPE/MEASURE_LABEL)을 유효값으로 제한하는 용도.
const buildCellCombo = (values: string[]): DataMap | undefined => {
  const uniq = [...new Set(values.map(v => v.trim()).filter(Boolean))].map(v => ({ V: v }));
  return uniq.length ? new DataMap(uniq, 'V', 'V') : undefined;
};

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns: RawFlexGridColumnConfig[];
  division: string;
  // 조회기간 From/To (YYYYMM) — 조회 **전에도** 기간 월을 컬럼으로 만든다(AS-IS SetCalendar cs:334/345).
  //   검색조건의 현재 선택값이지 조회에 쓰인 filters 값이 아니다 — AS-IS 도 InitSpread 시점의 콤보 선택값을 읽는다.
  fromYyyymm: string;
  toYyyymm: string;
  auth: AuthContext;
  // MULTI_CHILD_ITEM lookup NAME 목록 (design 03 §1-L / L7 모듈 반제품 편집 예외). 미조회 시 빈 Set.
  multiChildItems: ReadonlySet<string>;
  // SCM_MST_SHEET_MEASURE 7행 — MEASURE_LABEL 신규행 셀콤보 원천(label↔code 동기). (Wave1)
  measures: MeasureMeta[];
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
  fromYyyymm,
  toYyyymm,
  auth,
  multiChildItems,
  measures,
  essPackLineRows,
  onDerivMismatch,
  onFocus,
}: Props) => {
  // 분기 B 원천 — LineByOperationPlantId_SCP_ALL 전량 로드 후 PLANT_ID+SHOP_GROUP_ID 클라 필터
  //   (design 03 §2-D — AS-IS dtLineAll + DBUtils.Filter). 셀콤보는 신규행('I')에만 노출.
  const [lineByPlantRows] = useTabComboQueries({ filters: [LINE_COMBO.BY_PLANT] });

  // Wave1 신규행 셀콤보 원천 lookup (OPERATION_GROUP / INCOTERMS / PLAN_TYPE) — 코드성 컬럼 오입력 차단.
  const [opGroupLk, incotermsLk, planTypeLk] = useTabLookupQueries({
    filters: [
      CELL_COMBO_LOOKUP.OPERATION_GROUP,
      CELL_COMBO_LOOKUP.INCOTERMS,
      CELL_COMBO_LOOKUP.PLAN_TYPE,
    ],
  });

  // admin 신규행 Model/Nick Name Item 팝업(MaterialByDivisionModal) — 더블클릭한 그리드 행을 기억해 채운다.
  const [openItemModal, setOpenItemModal] = useState(false);
  const [itemModalRow, setItemModalRow] = useState(-1);

  // 편집 권한 보유 여부 — 편집 권한 전용 컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 가시성 기준.
  const canEdit = useMemo(() => hasEditAuth(auth), [auth]);

  const fixedBindings = useMemo(() => fixedBindingSet(adminColumns), [adminColumns]);
  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, canEdit),
    [adminColumns, canEdit]
  );
  // 조회기간 월 목록 — AS-IS SetCalendar 가 CalendarMonth 로 열거하는 From~To 구간(cs:345).
  const periodMonths = useMemo(
    () => periodMonthRange(fromYyyymm, toYyyymm),
    [fromYyyymm, toYyyymm]
  );
  const pivotColumns = useMemo(
    () =>
      buildPivotColumns(
        rows as unknown as Record<string, unknown>[],
        fixedBindings,
        periodMonths
      ),
    [rows, fixedBindings, periodMonths]
  );

  const lockCtx = useMemo<EditLockContext>(
    () => ({ division, auth, multiChildItems }),
    [division, auth, multiChildItems]
  );

  // LINE_ID 신규행 셀콤보(insert-only) — 단일 DataMap 의 getDisplayValues 가 CRUD_TYPE='I' 행에만
  //   분기 A/B 후보를 돌려준다(insert-only-combo-hardcode 규약). 조회행/필터패널(행 컨텍스트 없음)은
  //   전체 목록 유지. 후보 = "-" 선두 + 각 분기 필터결과(design 03 §2-D 후처리 cs:1784-1788).
  const lineDataMap = useMemo(() => {
    // 표시문자열 = **LINE_ID 코드 그대로**. 콤보 SQL 은 NAME 을 `LINE_ID || ' ' || LINE_NAME` 으로 주지만
    //   (SCM_ADM_CMBO_SQL_M 'LineByOperationPlantId_SCP_ALL' 실측) AS-IS 는 바인딩 직전에
    //   `dtLine.Rows[i]["NAME"] = dtLine.Rows[i]["CODE"]` 로 **NAME 을 CODE 로 덮어쓴다**(cs:1779~1782).
    //   NAME 을 그대로 쓰면 AS-IS 가 코드만 보여주던 칸에 "코드 라인명"이 뜬다.
    const toCodeLabeled = (rows: ComboResponse[]): ComboResponse[] =>
      rows
        .filter(r => s(r.CODE).trim() !== '')
        .map(r => ({ ...r, NAME: s(r.CODE) }) as ComboResponse);

    const branchB = toCodeLabeled(lineByPlantRows ?? []);
    const branchA = toCodeLabeled(essPackLineRows ?? []);
    // sentinel "-" 는 **DataMap 컬렉션에 실제 행으로** 넣는다(AS-IS cs:1784~1788 dtLine.Rows.InsertAt).
    //   라벨 목록에만 넣으면 사용자가 "-" 를 골라도 getKeyValue 가 컬렉션에서 못 찾아 값이 되돌아오지 않는다.
    //   Insert 신규행의 기본값이 "-" 이므로(LINE_ID_EMPTY) 되돌리는 경로가 반드시 있어야 한다.
    const sentinel = { CODE: LINE_ID_EMPTY, NAME: LINE_ID_EMPTY } as unknown as ComboResponse;
    const all = [sentinel, ...branchA, ...branchB];
    // 주의: 라인 원천이 비어도 **null 을 돌려주지 않는다**. null 이면 컬럼에 dataMap 이 안 붙어
    //   드롭다운 자체가 사라진다 — AS-IS 는 dtLine 이 0건이어도 "-" 한 건으로 콤보를 만든다.
    const dataMap = new DataMap(all, 'CODE', 'NAME');
    // 후보 라벨 = "-" 선두 + 필터결과(AS-IS cs:1784 InsertAt(0)). `all` 에 sentinel 이 들어 있으므로
    //   목록에서 한 번 걸러 중복 "-" 가 두 줄로 보이는 것을 막는다.
    const labels = (list: ComboResponse[]): string[] => [
      LINE_ID_EMPTY,
      ...list
        .filter(r => s(r.CODE) !== LINE_ID_EMPTY)
        .map(r => String(dataMap.getDisplayValue(r.CODE))),
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

  // Wave1 신규행 셀콤보 (OPERATION_GROUP / INCOTERMS / PLAN_TYPE / MEASURE_LABEL) — 코드성 컬럼을 유효값으로
  //   제한해 오입력(예: "test")을 원천 차단(사용자 지시 2026-10-19). identity DataMap(value=display)이라
  //   **조회행 표시는 불변**(값이 목록에 없으면 원문 유지) + 편집은 admin 신규행만 열려(isCellEditable) 드롭다운이
  //   조회행엔 안 뜬다. LINE_ID(§2-D 캐스케이드)와 달리 고정 목록이라 getDisplayValues override 불필요.
  // OPERATION_GROUP: 셀에 **표시명**(SEGMENT2=Pack/Cell/Electrode) 저장 — opGroupCode·일반 SP 와 일관
  //   (admin payload 가 코드로 변환, buildAdminPayload). 코드로 저장하면 opGroupCode 가 깨진다.
  const opGroupDataMap = useMemo(
    () => buildCellCombo((opGroupLk ?? []).map(r => s(r.SEGMENT2))),
    [opGroupLk]
  );
  // INCOTERMS: 코드(SEGMENT1=DAP…) + "-"(Prod Plan/Inv 등 비적용행이 "-" 라 포함). 셀=코드=저장값.
  const incotermsDataMap = useMemo(
    () => buildCellCombo([LINE_ID_EMPTY, ...(incotermsLk ?? []).map(r => s(r.SEGMENT1))]),
    [incotermsLk]
  );
  // PLAN_TYPE: 코드(SEGMENT1=FN/MA/PR/SE/TE). 그리드 표시도 코드.
  const planTypeDataMap = useMemo(
    () => buildCellCombo((planTypeLk ?? []).map(r => s(r.SEGMENT1))),
    [planTypeLk]
  );
  // MEASURE: "Measure" 열(MEASURE_LABEL)에 라벨 콤보. 선택 시 MEASURE(코드)를 cellEditEnded 로 동기(저장은 코드).
  const measureDataMap = useMemo(
    () => buildCellCombo((measures ?? []).map(m => s(m.colLblNm))),
    [measures]
  );
  const measureCodeByLabel = useMemo(() => {
    const map = new Map<string, string>();
    (measures ?? []).forEach(m => {
      const label = s(m.colLblNm);
      if (label) map.set(label, s(m.colNm));
    });
    return map;
  }, [measures]);

  // 잠금/색 핸들러가 최신값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const lockCtxRef = useRef(lockCtx);
  lockCtxRef.current = lockCtx;
  const fixedBindingsRef = useRef(fixedBindings);
  fixedBindingsRef.current = fixedBindings;
  const divisionRef = useRef(division);
  divisionRef.current = division;
  const onDerivMismatchRef = useRef(onDerivMismatch);
  onDerivMismatchRef.current = onDerivMismatch;
  const measureCodeByLabelRef = useRef(measureCodeByLabel);
  measureCodeByLabelRef.current = measureCodeByLabel;

  // 셀콤보 DataMap 지속 적용 — 공용 DataGrid 가 매 렌더 columnGroups 재대입으로 메타 콤보맵을
  //   덮으므로 updatedLayout 마다 재부착([[wijmo-columngroups-recreate-datamap]] 규약). LINE_ID + Wave1 4종.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const setMap = (binding: string, map?: DataMap) => {
      const col = g.columns.getColumn(binding);
      if (col && map && col.dataMap !== map) col.dataMap = map;
    };
    const apply = () => {
      setMap('LINE_ID', lineDataMap);
      setMap('OPERATION_GROUP', opGroupDataMap);
      setMap('INCOTERMS', incotermsDataMap);
      setMap('PLAN_TYPE', planTypeDataMap);
      setMap('MEASURE_LABEL', measureDataMap);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [
    gridRef,
    lineDataMap,
    opGroupDataMap,
    incotermsDataMap,
    planTypeDataMap,
    measureDataMap,
    rows,
  ]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 셀 1건의 편집 허용 판정 — 조회직후 전건 잠금(L19) baseline 에서 pivot 편집셀/BOH/LINE_ID 만 해제
    //   (design 03 §3-Lock). 공용 DataGrid 의 컬럼레벨 게이트(INPUT_TP_CD)를 통과한 셀에 **행단위** 규칙을 더한다.
    const isCellEditable = (sender: FlexGridType, rowIdx: number, colIdx: number): boolean => {
      const binding = sender.columns[colIdx]?.binding ?? '';
      const row = sender.rows[rowIdx]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return false;
      // 신규행('I') — AS-IS InsertRow 가 삽입 직후 거는 잠금이 가장 먼저다(cs:976/1054/1057).
      //   일반 유저는 **LINE_ID 하나만** 열린다 → 기간(월) 수량칸은 신규행에서 입력 불가.
      //   아래 pivot L2~L23 규칙은 **저장된 행**의 규칙이므로 신규행에 적용하면 AS-IS 보다 느슨해진다.
      //   (부수효과: 월 셀이 잠기므로 unfoldSaveCells 의 신규 modiQty 가 전부 0 → SP 의 무조건 INV
      //    재계산(L921)이 재고를 흔들지 않는다 — U-11 사고의 구조적 예방.)
      if (s(row.CRUD_TYPE) === 'I') {
        return isInsertRowCellEditable(binding, lockCtxRef.current.auth);
      }
      // BOH_QTY 셀 — measure=INV & seqFlag[1]=6 & isEdit 권한.
      if (binding === 'BOH_QTY') return isBohCellEditable(row, lockCtxRef.current);
      // LINE_ID 셀 — 신규행 전용(위에서 처리). 저장된 행의 Line 은 AS-IS 도 잠겨 있다(cs:550 LockColumn 범위).
      if (binding === 'LINE_ID') return false;
      // pivot(YYYYMM) 기간셀 — L2~L23 잠금 규칙. 고정 컬럼은 전건 잠금.
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return false;
      return !isPivotCellLocked(row, lockCtxRef.current);
    };

    // admin 신규행(CRUD='I')은 식별컬럼 INPUT_TP_CD='S' 의 **컬럼레벨 잠금**(공용 setEditableColumns →
    //   GridUtils.isEditableCell)까지 넘어 DIVISION_ID 외 전체 컬럼을 연다(AS-IS cs:976 "Admin 전체 컬럼 edit").
    //   우리 핸들러는 공용 게이트 **뒤에** 등록돼 마지막에 돌므로(DataGrid.tsx setEditableColumns 순서),
    //   이 경우에만 e.cancel 을 양방향으로 확정해 공용 cancel 을 되돌린다. 그 외 경로는 종전처럼 가산(cancel=true)만
    //   한다 — 저장행 BOH/pivot 은 공용 게이트의 EDIT_FLAG 분기를 유지해야 하므로 override 하지 않는다.
    const applyEditGate = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (s(row?.CRUD_TYPE) === 'I' && lockCtxRef.current.auth.isAdmin) {
        // admin 신규행: Model/Nick Name(INSERT_POPUP_COLS)은 인라인 편집이 아니라 Item 팝업(dblClick)으로
        //   채우므로 두 컬럼만 인라인 편집을 막는다. 나머지는 isCellEditable(= DIVISION_ID 외 전체)대로 연다.
        const binding = sender.columns[e.col]?.binding ?? '';
        const editable =
          isCellEditable(sender, e.row, e.col) && !INSERT_POPUP_COLS.has(binding);
        e.cancel = !editable;
        return;
      }
      if (!isCellEditable(sender, e.row, e.col)) e.cancel = true;
    };

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      applyEditGate(sender, e);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기도 같은 규칙으로 막는다. 공용 DataGrid 는 pastingCell 에 **컬럼레벨만** 보는 핸들러를 건다
    //   (dataGridUtils.ts:391 `grid.pastingCell.addHandler(defaultEditHandler)` → isEditableCell).
    //   기간 컬럼을 OPTIONAL 로 연 뒤에는 그 게이트를 전부 통과하므로, 행단위 잠금셀에도 붙여넣기가
    //   들어갈 수 있다 — beginningEdit 로 막은 셀이 Ctrl+V 로는 열리는 비대칭이 생긴다. 여기서 맞춘다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      applyEditGate(sender, e);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 파생검증 D1/D2 (design 03 §3-Deriv) — ESS(div82) 수정 시 PROD_PLAN×CELL_CF ↔ IN_HOUSE_MOVING
    //   정합을 같은 아이템·월 기준으로 검증(경고만, 저장은 막지 않음). CELL_CF 결측 시 1 대체(cs:1997-2000).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // MEASURE_LABEL 콤보 선택 → MEASURE(코드) 동기. 저장(baseCell)은 row.MEASURE 를 쓰므로 반드시 코드를 채운다.
      if (binding === 'MEASURE_LABEL' && row) {
        const code = measureCodeByLabelRef.current.get(s(row.MEASURE_LABEL));
        if (code) row.MEASURE = code;
      }
      if (divisionRef.current !== DIVISION_ESS) return;
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return;
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
      const row = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const ctx = lockCtxRef.current;

      // admin 신규행 — 수정가능 셀 양식을 **표준 wj-cell-editable**(다른 셀·화면과 동일한 편집가능 배경)로
      //   통일한다. 이 컬럼들은 메타 INPUT_TP_CD='S' 라 공용 formatItem 이 isEditableCell=false 로 양식을
      //   안 입힌다 → 편집은 되지만(applyEditGate override) 잠긴 것처럼 보이던 문제를 여기서 덮는다.
      //   DIVISION_ID 만 잠금(나머지 전 컬럼 edit — LINE 콤보/ Model·Nick Name 팝업 포함, AS-IS cs:976).
      //   pivot 경로가 남긴 인라인 배경색을 비워 클래스 배경이 그대로 뜨게 한다.
      if (s(row.CRUD_TYPE) === 'I' && ctx.auth.isAdmin) {
        ev.cell.style.backgroundColor = '';
        ev.cell.classList.toggle(
          'wj-cell-editable',
          binding !== '' && binding !== 'DIVISION_ID'
        );
        return;
      }

      if (!isPivotColumn(binding, fixedBindingsRef.current)) return; // 고정 컬럼은 색상 대상 아님
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

    // admin 신규행 Model/Nick Name 셀 더블클릭 → Item 팝업(MaterialByDivisionModal). 인라인 편집은
    //   applyEditGate 가 막으므로(INSERT_POPUP_COLS) 더블클릭이 유일한 입력 경로다. 팝업 선택이
    //   ITEM_ID(Model)+NICK_NAME 을 함께 채운다(operation-lt 선례). Cell Model/CF 는 범위 밖(1단계).
    const dblclickHandler = (ev: MouseEvent) => {
      const grid = gridRef.current;
      if (!grid) return;
      const ht = grid.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = grid.columns[ht.col]?.binding ?? '';
      const row = grid.rows[ht.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (s(row.CRUD_TYPE) !== 'I' || !lockCtxRef.current.auth.isAdmin) return;
      if (!INSERT_POPUP_COLS.has(binding)) return;
      setItemModalRow(ht.row);
      setOpenItemModal(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 고정 식별 컬럼 세로 병합(M1~M4 SmartColMerge) — pivot 컬럼은 병합 제외(buildPivotColumns allowMerging=false).
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = !isPivotColumn(b, fixedBindingsRef.current);
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  return (
    <>
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
      {/* admin 신규행 Model/Nick Name 입력 — 조회영역과 동일한 MaterialByDivisionModal(COM0013) 재사용.
          더블클릭한 행(itemModalRow)에 선택 결과(itemId=Model, nickName)를 함께 채운다(1단계: Model/Nickname). */}
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={(itemId, _itemName, _itemClassName, nickName) => {
          const grid = gridRef.current;
          const row = GridUtils.getRow(grid, itemModalRow) as
            | Record<string, unknown>
            | undefined;
          if (!row || s(row.CRUD_TYPE) !== 'I') return;
          if (itemId) row.ITEM_ID = itemId;
          if (nickName !== undefined) row.NICK_NAME = s(nickName);
          GridUtils.refreshRow(grid, itemModalRow);
        }}
        preSearchParams={{
          divisionId: division,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: '',
        }}
      />
    </>
  );
};
