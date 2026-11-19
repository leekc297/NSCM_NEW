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
import type { DerivMismatchDetail, MainRow } from '../integration-psi.types';
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
  isEssGreenCell,
  isInsertRowCellEditable,
  isPivotCellLocked,
  isPivotCellValueEmpty,
  isPivotColumn,
} from '../utils/integrationPsiEditLock';

// 편집가능 셀 배경색 — 기본은 hook#95 표준(편집가능=Yellow wj-cell-editable / 잠금=흰색). 단
//   ESS(div82) C1/C2 행(design 03 §3-Color)만은 AS-IS SetBGColor2 연두(140,240,60)를 복원한다
//   (cs:757/782, isEssGreenCell). ESS Pack Prod Plan·페어 Cell In-house 기간셀을 연두로 구분한다.
const ESS_EDIT_GREEN = 'rgb(140, 240, 60)';
// 음수 폰트색 — AS-IS NumberCellType.NegativeRed=true 재현(SpreadInfo.cs AddNumColumn, 표준 Color.Red).
//   기간(월) pivot 셀·BOH_QTY·CELL_CF 등 숫자 컬럼의 음수 값을 빨간 글자로 표시한다.
//   주의: 아래 셀 서식 쓰기 가드(setStyle)가 브라우저 정규화 readback('rgb(...)')과 등호를 맞추려면
//   색 리터럴도 rgb 표기여야 한다(#ff0000 은 읽을 때 'rgb(255, 0, 0)' 로 돌아와 가드가 매번 빗나간다).
const NEGATIVE_RED_COLOR = 'rgb(255, 0, 0)';
// 잠금/읽기전용 셀 배경 흰색 — rgb 표기(가드 readback 일치, 위 NEGATIVE_RED_COLOR 주석).
const LOCKED_WHITE = 'rgb(255, 255, 255)';

// 셀 서식 쓰기 가드 — 값이 그대로면 쓰지 않아 불필요한 스타일 무효화(Recalculate style)를 줄인다.
//   읽기(style/classList)는 리플로우를 강제하지 않으므로 가드 자체는 저렴하다(2026-11-17 프로파일 대응).
const setStyle = (
  el: HTMLElement,
  prop: 'color' | 'backgroundColor',
  value: string
): void => {
  if (el.style[prop] !== value) el.style[prop] = value;
};
const setClass = (el: HTMLElement, name: string, on: boolean): void => {
  if (el.classList.contains(name) !== on) el.classList.toggle(name, on);
};

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
  // 파생검증 D1/D2 불일치 경고 — AS-IS "수량 불일치"(경고만, 저장 미차단). 수치 상세는 page 가 조립해 표시.
  onDerivMismatch: (detail: DerivMismatchDetail) => void;
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

  // 관리컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 가시성 기준 — ADMIN 전용(hasEditAuth=isAdmin).
  //   SCM PI Admin/SCP Planner 는 BOH 편집 권한이 있어도 관리컬럼은 안 보인다(AS-IS SetVisibleSheetColumns).
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
  // pivot(YYYYMM) 컬럼은 rows 의 **키 집합**에서만 결정된다(buildPivotColumns 가 Object.keys 만 읽고 값은 안 본다).
  //   그래서 저장/재조회로 값만 바뀌고 월 구조가 같은데도 rows 참조가 바뀌면, 종전엔 pivotColumns 가 매번
  //   새 배열이 되어 공용 DataGrid 의 columnGroups 가 통째로 재생성됐다 → 다단 헤더가 부풀었다 줄며 깜빡였다
  //   (SCP0098/DMF0021 선례 [[dynamic-columns-memo-on-data-identity-rebuilds-header-flash]]). 값이 아니라
  //   'pivot 키 서명'으로 memo 해 월 구조가 같은 재조회에선 같은 컬럼 참조를 유지한다(컬럼 재생성 0).
  const pivotKeySig = useMemo(() => {
    const keys = new Set<string>();
    for (const r of rows as unknown as Record<string, unknown>[]) {
      for (const k of Object.keys(r)) if (isPivotColumn(k, fixedBindings)) keys.add(k);
    }
    return [...keys].sort().join(',');
  }, [rows, fixedBindings]);
  const pivotColumns = useMemo(
    () =>
      buildPivotColumns(
        rows as unknown as Record<string, unknown>[],
        fixedBindings,
        periodMonths
      ),
    // rows 참조가 아니라 키 서명으로 재생성 — 월 구조가 같은 재조회는 컬럼을 다시 만들지 않는다.
    //   값 갱신은 itemsSource(rows) 교체로 셀에 반영되므로 컬럼 재생성 없이도 표시가 최신이다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [pivotKeySig, fixedBindings, periodMonths]
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

  // C2 연두 판정용 — PROD_PLAN 행의 ITEM_ID 집합(AS-IS dtPSIAll 필터 cs:767-769 대응).
  //   IN_HOUSE_MOVING(셀) 행의 TO_PRODUCT 가 이 집합에 있으면 PROD_PLAN 페어가 존재하는 것이다.
  const prodPlanItemIds = useMemo(() => {
    const set = new Set<string>();
    (rows ?? []).forEach(r => {
      const row = r as unknown as Record<string, unknown>;
      if (s(row.MEASURE) === MEASURE.PROD_PLAN) {
        const id = s(row.ITEM_ID);
        if (id) set.add(id);
      }
    });
    return set;
  }, [rows]);

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
  const prodPlanItemIdsRef = useRef(prodPlanItemIds);
  prodPlanItemIdsRef.current = prodPlanItemIds;

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
      // pivot(YYYYMM) 기간셀 — AS-IS EditButton 권한 2-분기(SCP0111_IntegrationPSI.cs 실측).
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return false;
      // ① ADMIN(System Administrator, cs:573-589): 측정값 제한 없이 값(공백 아님) 셀 편집. 측정값 행
      //    잠금(isPivotCellLocked)을 건너뛴다 — "Admin 권한의 경우 전체 컬럼 edit"(2024-07-31).
      // ② 그 외(일반/PI Admin/Planner, cs:603-739): 측정값/seqFlag/division 행 잠금 적용.
      if (!lockCtxRef.current.auth.isAdmin && isPivotCellLocked(row, lockCtxRef.current)) {
        return false;
      }
      // 공통: 셀단위 빈값 잠금(cs:587/662/703 qty=="" → lock) — 값 있는 셀만 편집(0 은 값 있음).
      return !isPivotCellValueEmpty(row, binding);
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

    // 파생검증 D1/D2 (design 03 §3-Deriv, AS-IS cs:1945-2129) — ESS(div82) 수정 시 PROD_PLAN×CELL_CF
    //   ↔ IN_HOUSE_MOVING 정합을 아이템·월 기준으로 검증(경고만, 저장은 막지 않음). D1(Pack PROD_PLAN,
    //   seqFlag[0]='2')과 D2(Cell IN_HOUSE_MOVING, seqFlag[0]='3')는 앵커·집계 범위가 달라 분기별로 재현한다.
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 정수 강제 — 숫자셀(기간 pivot / BOH_QTY)에 소수가 들어오면 버림(AS-IS NumberCellType DecimalPlaces=0,
      //   BOH 는 SP 가 TRUNC). dataType=Number 라 문자는 Wijmo 가 커밋 거부한다. 소수만 여기서 정규화.
      //   커스텀 편집기를 쓰지 않아(기본 셀 편집 유지) 방향키 이동·'-' 입력·엔터 커밋이 정상 동작한다.
      if (row && (binding === 'BOH_QTY' || isPivotColumn(binding, fixedBindingsRef.current))) {
        const v = row[binding];
        if (typeof v === 'number' && !Number.isInteger(v)) {
          row[binding] = Math.trunc(v);
          sender.invalidate(); // 데이터만 바꿔선 셀 표시가 안 갱신 — 재그림 요청(편집 종료 시 1회).
        }
      }
      // MEASURE_LABEL 콤보 선택 → MEASURE(코드) 동기. 저장(baseCell)은 row.MEASURE 를 쓰므로 반드시 코드를 채운다.
      if (binding === 'MEASURE_LABEL' && row) {
        const code = measureCodeByLabelRef.current.get(s(row.MEASURE_LABEL));
        if (code) row.MEASURE = code;
      }
      if (divisionRef.current !== DIVISION_ESS) return;
      if (!isPivotColumn(binding, fixedBindingsRef.current)) return;
      if (!row) return;
      // AS-IS action!='M' → 신규행('I') 제외. 저장된 행 수정만 파생검증 대상(cs:1973-1974).
      if (s(row.CRUD_TYPE) === 'I') return;

      const measure = s(row.MEASURE);
      const seqHead = s(row.SEQ_FLAG).slice(0, 1); // AS-IS seqFlag.Substring(0,1) — 제품유형 분기
      const src = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      const ym = binding;

      // 주의: D1(Pack PROD_PLAN)과 D2(Cell IN_HOUSE_MOVING)는 앵커 아이템과 집계 범위가 서로 달라
      //   (cs:1992-2058 vs 2061-2127) 한 식으로 합칠 수 없다. 합치면 D2 가 ITEM_ID(=Cell 자신)로
      //   집계해 매칭행이 0 이 되어 불일치여도 경고가 안 뜬다 — 분기별로 재현한다.

      // D1 — Pack 의 Prod Plan 수정(seqFlag[0]='2'): ΣPROD_PLAN(same item)×CELL_CF ↔
      //   ΣIN_HOUSE_MOVING(toProduct=item, valueType≠'-'). CELL_CF 는 수정행 값(결측/0 = 1).
      if (measure === MEASURE.PROD_PLAN && seqHead === '2') {
        const item = s(row.ITEM_ID);
        const cellCf = toNum(row.CELL_CF) || 1;
        const prodQty = src
          .filter(r => s(r.ITEM_ID) === item && s(r.MEASURE) === MEASURE.PROD_PLAN)
          .reduce((a, r) => a + toNum(r[ym]), 0);
        const prodSum = prodQty * cellCf;
        const inhouseRows = src.filter(
          r =>
            s(r.TO_PRODUCT) === item &&
            s(r.MEASURE) === MEASURE.IN_HOUSE_MOVING &&
            s(r.VALUE_TYPE) !== '-'
        );
        const inhouseQty = inhouseRows.reduce((a, r) => a + toNum(r[ym]), 0);
        // AS-IS 는 매칭 In-house 행의 ITEM_ID 를 메시지에 쓴다(cs:2043 — 마지막 매칭행 기준).
        const inhouseItem = inhouseRows.length
          ? s(inhouseRows[inhouseRows.length - 1].ITEM_ID)
          : '';
        // AS-IS 정확 비교(cs:2049 prodSum != inhouseQty) — 동일 IEEE754 연산이라 bit 단위 일치.
        //   round 를 거치면 소수 단위 불일치를 놓친다(경고 누락). CELL_CF 정수 데이터에선 결과 동일.
        if (prodSum !== inhouseQty) {
          onDerivMismatchRef.current({
            kind: 'D1',
            itemId: item,
            counterpartId: inhouseItem,
            prodQty,
            inhouseQty,
            shouldBe: prodSum,
          });
        }
        return;
      }

      // D2 — Cell 의 In-house Moving 수정(seqFlag[0]='3'): ΣIN_HOUSE_MOVING(same item·toProduct,
      //   valueType≠'-') ↔ ΣPROD_PLAN(item=toProduct)×CELL_CF. CELL_CF 는 PROD_PLAN 행에서 취한다
      //   (cs:2104-2110, 마지막 매칭 PROD_PLAN 행 값 — 결측 시 1).
      if (measure === MEASURE.IN_HOUSE_MOVING && seqHead === '3') {
        const item = s(row.ITEM_ID);
        const toProduct = s(row.TO_PRODUCT);
        const inhouseQty = src
          .filter(
            r =>
              s(r.ITEM_ID) === item &&
              s(r.MEASURE) === MEASURE.IN_HOUSE_MOVING &&
              s(r.TO_PRODUCT) === toProduct &&
              s(r.VALUE_TYPE) !== '-'
          )
          .reduce((a, r) => a + toNum(r[ym]), 0);
        let cellCf = 1;
        const prodQty = src
          .filter(r => s(r.ITEM_ID) === toProduct && s(r.MEASURE) === MEASURE.PROD_PLAN)
          .reduce((a, r) => {
            cellCf = toNum(r.CELL_CF) || 1;
            return a + toNum(r[ym]);
          }, 0);
        // AS-IS 정확 비교(cs:2118 prodSum != inhouseQty).
        if (prodQty * cellCf !== inhouseQty) {
          onDerivMismatchRef.current({
            kind: 'D2',
            itemId: item,
            counterpartId: toProduct,
            prodQty,
            inhouseQty,
            shouldBe: inhouseQty / cellCf, // AS-IS: inhouseQty / cell_CF (cs:2124)
          });
        }
        return;
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

      // 음수 빨강 폰트 — AS-IS NumberCellType.NegativeRed=true(SpreadInfo.cs AddNumColumn) 재현.
      //   숫자 컬럼(기간 pivot / BOH_QTY / CELL_CF)의 음수 값에만 빨간 글자. 셀 재사용 대비 양수는 색 초기화.
      if (
        binding === 'BOH_QTY' ||
        binding === 'CELL_CF' ||
        isPivotColumn(binding, fixedBindingsRef.current)
      ) {
        setStyle(ev.cell, 'color', toNum(row[binding]) < 0 ? NEGATIVE_RED_COLOR : '');
      }

      // admin 신규행 — 수정가능 셀 양식을 **표준 wj-cell-editable**(다른 셀·화면과 동일한 편집가능 배경)로
      //   통일한다. 이 컬럼들은 메타 INPUT_TP_CD='S' 라 공용 formatItem 이 isEditableCell=false 로 양식을
      //   안 입힌다 → 편집은 되지만(applyEditGate override) 잠긴 것처럼 보이던 문제를 여기서 덮는다.
      //   DIVISION_ID 만 잠금(나머지 전 컬럼 edit — LINE 콤보/ Model·Nick Name 팝업 포함, AS-IS cs:976).
      //   pivot 경로가 남긴 인라인 배경색을 비워 클래스 배경이 그대로 뜨게 한다.
      if (s(row.CRUD_TYPE) === 'I' && ctx.auth.isAdmin) {
        setStyle(ev.cell, 'backgroundColor', '');
        setClass(ev.cell, 'wj-cell-editable', binding !== '' && binding !== 'DIVISION_ID');
        return;
      }

      // BOH_QTY — 컬럼 메타(EDIT_FLAG)가 **전 행**에 편집가능(노랑 wj-cell-editable) 양식을 입히지만,
      //   실제 편집은 행 단위다(measure=INV & seqFlag[1]=6 & 권한 — isBohCellEditable). 편집 불가 BOH 셀은
      //   잠금처럼 보이도록 wj-cell-editable 를 떼고 회색 배경을 준다(사용자 지시 2026-10-30, 시각 혼동 제거).
      //   편집 가능 셀은 클래스를 남기고 인라인 배경을 비워 표준 편집가능(노랑) 양식이 그대로 뜨게 한다.
      //   편집 불가 BOH 셀은 **흰색**(일반 읽기전용 셀과 동일)으로 둔다(사용자 지시 2026-10-30).
      if (binding === 'BOH_QTY') {
        const bohEditable = isBohCellEditable(row, ctx);
        setClass(ev.cell, 'wj-cell-editable', bohEditable);
        setStyle(ev.cell, 'backgroundColor', bohEditable ? '' : LOCKED_WHITE);
        return;
      }

      if (!isPivotColumn(binding, fixedBindingsRef.current)) return; // 고정 컬럼은 색상 대상 아님
      // ESS(div82) C1/C2 연두 복원 — AS-IS SetBGColor2(iRow, startDate~endDate, 연두) (cs:757/782).
      //   AS-IS 는 C1/C2 행의 **기간 전체**를 연두로 칠한 뒤(757/782) 빈 월 셀만 잠그므로(801-805) 빈 셀도
      //   연두가 유지된다 → 아래 잠금/빈값 노랑·흰색 판정보다 먼저 적용해 행 범위 전체를 연두로 둔다.
      //   ADMIN 은 AS-IS 에서 연두 분기(cs:597 else)를 타지 않으므로 제외 — ADMIN 편집셀은 종전처럼 노랑.
      if (!ctx.auth.isAdmin && isEssGreenCell(row, ctx.division, prodPlanItemIdsRef.current)) {
        setClass(ev.cell, 'wj-cell-editable', false); // 공용이 입힌 노랑 제거
        setStyle(ev.cell, 'backgroundColor', ESS_EDIT_GREEN); // 연두(140,240,60)
        return;
      }
      // 편집가능 pivot 셀 = **노랑**(BOH 편집가능과 동일 wj-cell-editable), 잠금 셀 = **흰색**.
      //   AS-IS EditButton 권한 2-분기와 동일 기준으로 노랑/흰색 결정(isCellEditable 과 1:1):
      //   ① ADMIN(System Administrator): 측정값 제한 없이 값(공백 아님)이면 노랑(cs:573-589).
      //   ② 그 외: 측정값 행 잠금(isPivotCellLocked) + 공통 빈값 잠금(cs:587/662/703).
      const locked =
        (!ctx.auth.isAdmin && isPivotCellLocked(row, ctx)) ||
        isPivotCellValueEmpty(row, binding);
      if (locked) {
        setClass(ev.cell, 'wj-cell-editable', false); // 공용이 입힌 노랑 제거
        setStyle(ev.cell, 'backgroundColor', LOCKED_WHITE); // 잠금 = 평평한 흰색(테마 얼룩무늬 제거)
      } else {
        setClass(ev.cell, 'wj-cell-editable', true); // 편집가능 = 노랑(BOH 와 동일)
        setStyle(ev.cell, 'backgroundColor', ''); // 인라인 비워 클래스 노랑이 그대로 뜨게
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

    // 숫자셀(기간 pivot / BOH_QTY) 문자·소수점 키 입력 차단 — dataType=Number 는 커밋만 거부하고 입력칸은
    //   열려 문자가 보였다(사용자 지시 2026-11-02). 커스텀 편집기(InputNumber)는 방향키 이동을 깨므로 쓰지 않고,
    //   keydown 에서 숫자·'-' 외 단일 문자만 막는다 — 제어키(방향키·Backspace·Enter·Tab)·단축키(Ctrl/Meta)는 통과.
    const blockNonIntegerKey = (ev: KeyboardEvent) => {
      if (ev.ctrlKey || ev.metaKey || ev.altKey) return; // 복사/붙여넣기·단축키 허용
      if (ev.key.length !== 1) return; // 방향키·Backspace·Delete·Enter·Tab 등 제어키 허용
      const binding = g.columns[g.selection?.col ?? -1]?.binding ?? '';
      if (binding !== 'BOH_QTY' && !isPivotColumn(binding, fixedBindingsRef.current)) return;
      if (/[0-9]/.test(ev.key) || ev.key === '-') return; // 숫자·음수부호만 허용(정수)
      ev.preventDefault(); // 문자·소수점 등은 입력칸에 들어오지 못하게
    };
    g.hostElement.addEventListener('keydown', blockNonIntegerKey);

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
        g.hostElement?.removeEventListener('keydown', blockNonIntegerKey);
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
