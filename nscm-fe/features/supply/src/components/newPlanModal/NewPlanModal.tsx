import { CellType, DataMap, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { attachRowNoHeader } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import {
  applyBodPick,
  applyCellChange,
  type BodPick,
  buildNewCheckArgs,
  buildNewSaveArgs,
  buildSavedItemIds,
  createClonedRow,
  createEmptyRow,
  findMissingRequired,
  getRequiredColumns,
  hasDuplicateRows,
  isCellEditable,
  isColumnVisible,
  isBodClickColumn,
  isEeDivision,
  isPlanTypeLocked,
  isSaveSuccess,
  judgeCheckResult,
  type NewPlanColumnKey,
  type NewPlanContext,
  type NewPlanRow,
} from './newPlan';
import {
  ELECTRODE_LOOKUP_TYPE,
  isSaveResultFailure,
  LBL,
  MSG,
  NEW_POPUP_SHEET,
  NEW_TITLE_KEY,
  operationGroupComboArgs,
} from './newPlan.constants';
import { NewPlanBodModal } from './NewPlanBodModal';
import styles from './NewPlanModal.module.scss';

// AS-IS SCM0002_ShipmentPlanInsertPopup(Shipment Plan FG/SEMI 의 New 버튼 팝업)을 옮긴 공용 모달.
//   설계: .atlas/gscm-design/SCM0002/design/00_checklist.md ~ 03_grid-columns.md. 저장 계약은 03 §3.
//   흐름: 행 입력(BOD 셀 클릭으로 BOD 모달) → 필수값 → 클라이언트 중복 → 저장 확인 → 서버 중복(newCheck) → 저장(savePopup).
//   newCheck/savePopup 은 SCM_ADM_MNU_BTN_MPG_M 의 `${menuId}/newCheck/SEARCH`, `${menuId}/savePopup/SAVE` 로 호출한다
//   (design/11_register_new_plan_popup.sql). sesUserId 는 서버가 로그인 세션에서 넣는다.

const COMBO_ID = {
  BOD_ITEM: 'BODItem_SCP',
  ORIGIN_DIVISION: 'OriginDivision_SCP',
  PROJECT: 'ProjectCdName_SCP',
  SITE: 'SiteMasterAll_SCP',
  LOOKUP: 'LookupCommon',
} as const;

const NEW_CHECK_SHEET = 'newCheck';
const SAVE_POPUP_SHEET = 'savePopup';

// 그리드 행 — 편집 모델에 호출 화면 컨텍스트(읽기 전용 5컬럼)와 공용 그리드가 읽는 CRUD_TYPE/EDIT_FLAG 를 붙인다.
interface GridRow extends NewPlanRow {
  CRUD_TYPE: 'I';
  EDIT_FLAG: 'Y';
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  planSeq: string;
  operationGroup: string;
}

interface ComboData {
  models: ComboResponse[]; // BODItem_SCP — FROM_DIVISION_ID/TO_DIVISION_ID 포함
  originDivs: ComboResponse[];
  projects: ComboResponse[]; // ProjectCdName_SCP — NAME2, DIVISION_ID, SCM_SITE_ID, ITEM_ID 포함
  fromSites: ComboResponse[];
  toSites: ComboResponse[];
  electrodes: ComboResponse[];
  operationGroups: ComboResponse[]; // Operation Group 컬럼 표시용(코드 → 이름)
}

const EMPTY_COMBOS: ComboData = {
  models: [],
  originDivs: [],
  projects: [],
  fromSites: [],
  toSites: [],
  electrodes: [],
  operationGroups: [],
};

interface Props {
  open: boolean;
  modalClose: () => void;
  context: NewPlanContext;
  // 호출 화면이 SCP0009 인지 SCP0010 인지 — call-proc 경로의 메뉴 ID 로 쓴다.
  menuId: string;
  // 저장 성공 뒤 호출. 호출 화면이 비EE 일 때 Item 조회조건을 채우고 재조회 여부를 묻는다(AS-IS .cs:1149-1162).
  onSaved: (itemIds: string[]) => void;
}

const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

const distinctByCode = (rows: ComboResponse[]): ComboResponse[] => {
  const seen = new Set<string>();
  return rows.filter(r => {
    const code = str(r.CODE);
    if (!code || seen.has(code)) return false;
    seen.add(code);
    return true;
  });
};

const toGridRow = (ctx: NewPlanContext, row: NewPlanRow): GridRow => ({
  ...row,
  CRUD_TYPE: 'I',
  EDIT_FLAG: 'Y',
  divisionId: ctx.divisionId,
  planStartYyyymmdd: ctx.planStartYyyymmdd,
  planType: ctx.planType,
  planSeq: ctx.planSeq,
  operationGroup: ctx.operationGroupId,
});

// 컬럼 정의. 읽기 전용 컨텍스트 5개 다음에 편집 컬럼 21개, 순서는 AS-IS InitSpread(.cs:267-293)와 같다.
interface ColumnDef {
  key: string;
  label: string;
  width: number;
  align: 'L' | 'C' | 'R';
  combo?: boolean;
  // 2단 헤더 — 대분류(AS-IS Voyage)와 소분류(요일)
  group?: { large: string; small: string };
}

const VOYAGE_GROUP = (day: string): { large: string; small: string } => ({ large: 'Voyage', small: day });

const CONTEXT_COLUMNS: ColumnDef[] = [
  { key: 'divisionId', label: 'Div', width: 60, align: 'C' },
  { key: 'planStartYyyymmdd', label: 'Plan Date', width: 90, align: 'C' },
  { key: 'planType', label: 'Plan Type', width: 80, align: 'C' },
  { key: 'planSeq', label: 'Seq', width: 60, align: 'C' },
  { key: 'operationGroup', label: 'Operation Group', width: 100, align: 'C' },
];

const DATA_COLUMNS: (ColumnDef & { key: NewPlanColumnKey })[] = [
  { key: 'itemId', label: 'Model', width: 130, align: 'L', combo: true },
  { key: 'projectCode', label: 'Project Code', width: 110, align: 'L', combo: true },
  { key: 'electrodeType', label: 'Electrode Type', width: 100, align: 'L', combo: true },
  { key: 'projectName', label: 'Project', width: 100, align: 'L' },
  { key: 'originFromDivisionId', label: 'Origin From Div', width: 100, align: 'C', combo: true },
  { key: 'fromSite', label: 'From Site', width: 150, align: 'C', combo: true },
  { key: 'originToDivisionId', label: 'Origin To Div', width: 100, align: 'C', combo: true },
  { key: 'toSite', label: 'To Site', width: 150, align: 'C', combo: true },
  { key: 'bodId', label: 'BOD', width: 80, align: 'C' },
  { key: 'incoterms', label: 'Incoterms', width: 100, align: 'L' },
  { key: 'transportMode', label: 'Trans Mode', width: 90, align: 'L' },
  { key: 'voyageMon', label: 'Mon', width: 45, align: 'C', group: VOYAGE_GROUP('Mon') },
  { key: 'voyageTue', label: 'Tue', width: 45, align: 'C', group: VOYAGE_GROUP('Tue') },
  { key: 'voyageWed', label: 'Wed', width: 45, align: 'C', group: VOYAGE_GROUP('Wed') },
  { key: 'voyageThu', label: 'Thu', width: 45, align: 'C', group: VOYAGE_GROUP('Thu') },
  { key: 'voyageFri', label: 'Fri', width: 45, align: 'C', group: VOYAGE_GROUP('Fri') },
  { key: 'voyageSat', label: 'Sat', width: 45, align: 'C', group: VOYAGE_GROUP('Sat') },
  { key: 'voyageSun', label: 'Sun', width: 45, align: 'C', group: VOYAGE_GROUP('Sun') },
  { key: 'ltDay', label: 'L/T(Day)', width: 90, align: 'R' },
  { key: 'fromYyyymmdd', label: 'From', width: 100, align: 'C' },
  { key: 'toYyyymmdd', label: 'To', width: 100, align: 'C' },
];

// 사용자가 직접 값을 고르는 컬럼(콤보). 나머지는 BOD 팝업이 채우거나 읽기 전용이다.
const EDIT_CANDIDATE_KEYS = new Set<string>([
  'itemId',
  'projectCode',
  'projectName',
  'electrodeType',
  'originFromDivisionId',
  'originToDivisionId',
]);

// admin 컬럼 메타(SCM_MST_SHEET_COLUMNS)엔 순번 필드가 없어(RawFlexGridColumnConfig) 이 바인딩 키
//   순서(AS-IS InitSpread, CONTEXT 다음 DATA)로 재정렬한다.
const COLUMN_POS = new Map<string, number>(
  [...CONTEXT_COLUMNS, ...DATA_COLUMNS].map((c, i) => [c.key, i] as const)
);

export const NewPlanModal = ({ open, modalClose, context, menuId, onSaved }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [rows, setRows] = useState<GridRow[]>([]);
  const [combos, setCombos] = useState<ComboData>(EMPTY_COMBOS);
  const [saving, setSaving] = useState(false);
  const [bodTargetKey, setBodTargetKey] = useState<string | null>(null);
  // 컬럼 구조 메타. null=조회 전, []=미등록/실패(하드코딩 fallback), 값=admin 등록본(authoritative).
  const [adminCols, setAdminCols] = useState<RawFlexGridColumnConfig[] | null>(null);

  // 최신 값을 핸들러(그리드 이벤트, effect 밖)에서 읽기 위한 참조.
  const ctxRef = useRef(context);
  ctxRef.current = context;
  const rowsRef = useRef<GridRow[]>([]);
  rowsRef.current = rows;
  const combosRef = useRef(combos);
  combosRef.current = combos;

  const ee = isEeDivision(context.divisionId);

  // 열릴 때 빈 행 1개로 시작하고 콤보 후보를 읽는다(AS-IS InitControls + InsertRow, .cs:160-219, 375-440).
  useEffect(() => {
    if (!open) return;
    setRows([toGridRow(context, createEmptyRow(context))]);
    setBodTargetKey(null);
    let cancelled = false;
    const toSiteType = context.programId === 'FG' ? 'SALES' : 'PLANT';
    const load = async () => {
      try {
        const [models, originDivs, projects, fromSites, toSites, electrodes, operationGroups] = await Promise.all([
          apiClient.getCombo({
            comboId: COMBO_ID.BOD_ITEM,
            divisionId: context.divisionId,
            operationGroup: context.operationGroupId,
            siteType: toSiteType,
          }),
          ee ? apiClient.getCombo({ comboId: COMBO_ID.ORIGIN_DIVISION }) : Promise.resolve([]),
          // AS-IS 는 ProjectCdName(originToDiv, "", "") — 비EE 는 originToDiv 가 division, EE 는 빈 값(.cs:186-187, 202).
          context.programId === 'FG'
            ? apiClient.getCombo({
                comboId: COMBO_ID.PROJECT,
                divisionId: ee ? '' : context.divisionId,
                scmSiteId: '',
                itemId: '',
              })
            : Promise.resolve([]),
          apiClient.getCombo({ comboId: COMBO_ID.SITE, siteType: 'PLANT', divisionId: '' }),
          apiClient.getCombo({ comboId: COMBO_ID.SITE, siteType: toSiteType, divisionId: '' }),
          ee ? apiClient.getCombo({ comboId: COMBO_ID.LOOKUP, lookupType: ELECTRODE_LOOKUP_TYPE }) : Promise.resolve([]),
          apiClient.getCombo(operationGroupComboArgs(context.programId, ee)),
        ]);
        if (!cancelled) setCombos({ models, originDivs, projects, fromSites, toSites, electrodes, operationGroups });
      } catch {
        if (!cancelled) {
          setCombos(EMPTY_COMBOS);
          void setAlert({ type: 'alert', content: t(MSG.SYSTEM_ERROR, '_System error.') });
        }
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
    // 열릴 때의 호출 화면 조건만 쓴다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // 컬럼 구조는 admin 메타(SCM_MST_SHEET_COLUMNS, SHEET_NAME=NEW_POPUP_SHEET)를 authoritative 로 쓴다.
  //   divisionId 를 실어 보내면 SP(PR_GET_SHEET_COLUMN_LIST)가 DIVISION_ID 로 걸러 그 division 에 보일
  //   컬럼만 반환한다(EE 전용 Origin Div·Electrode 는 EE 조회에서만). 미등록 화면(FG 등)·조회 실패 시 []로
  //   두어 staticColumns 가 하드코딩 CONTEXT/DATA 컬럼을 fallback 으로 쓴다(메인 그리드와 동일 패턴).
  useEffect(() => {
    if (!open) return undefined;
    let cancelled = false;
    apiClient
      .post<RawFlexGridColumnConfig[]>(`/admin/menu/${menuId}/column`, {
        sheetNm: NEW_POPUP_SHEET,
        divisionId: context.divisionId,
      })
      .then(res => {
        if (!cancelled) setAdminCols(res.data.result ?? []);
      })
      .catch(() => {
        if (!cancelled) setAdminCols([]);
      });
    return () => {
      cancelled = true;
    };
  }, [open, menuId, context.divisionId]);

  // 행별 후보. EE 는 Origin From/To Div 쌍으로 Model 후보를 거른다(AS-IS dtBODItemAll.Select, .cs:773).
  const modelCodesFor = (row: NewPlanRow): string[] =>
    distinctByCode(
      ee
        ? combosRef.current.models.filter(
            m =>
              str(m.FROM_DIVISION_ID) === row.originFromDivisionId && str(m.TO_DIVISION_ID) === row.originToDivisionId
          )
        : combosRef.current.models
    ).map(m => str(m.CODE));

  // Project Code 후보 — `-` 를 항상 먼저 두고, BOD 의 To Div/To Site 와 Model 에 맞는 행을 붙인다(AS-IS .cs:1068-1094).
  const projectRowsFor = (row: NewPlanRow): ComboResponse[] =>
    combosRef.current.projects.filter(
      p =>
        str(p.DIVISION_ID) === row.originToDivisionId &&
        str(p.SCM_SITE_ID) === row.toSite &&
        str(p.ITEM_ID) === row.itemId
    );

  // 컬럼별 DataMap. 컬럼 전체 맵은 라벨 조회용 전체 후보이고, 드롭다운 후보는 getDisplayValues(row)로 행마다 좁힌다
  //   (편집 때마다 column.dataMap 을 갈아끼우면 그 컬럼 모든 행이 좁혀져 쓰지 않는다 — foundation columnMapping 주석).
  const dataMaps = useMemo(() => {
    const plain = (rowsIn: ComboResponse[]) => new DataMap(distinctByCode(rowsIn), 'CODE', 'NAME');

    const modelMap = plain(combos.models);
    modelMap.getDisplayValues = (item?: unknown) => {
      if (!item) return distinctByCode(combos.models).map(m => str(m.NAME));
      return modelCodesFor(item as NewPlanRow).map(code => modelMap.getDisplayValue(code));
    };

    const projectMap = plain([{ CODE: '-', NAME: '-' } as ComboResponse, ...combos.projects]);
    projectMap.getDisplayValues = (item?: unknown) => {
      if (!item) return distinctByCode(combos.projects).map(p => str(p.NAME));
      const matched = distinctByCode(projectRowsFor(item as NewPlanRow));
      return ['-', ...matched.map(p => str(p.CODE))].map(code => projectMap.getDisplayValue(code));
    };

    return {
      itemId: modelMap,
      projectCode: projectMap,
      originFromDivisionId: plain(combos.originDivs),
      originToDivisionId: plain(combos.originDivs),
      fromSite: plain(combos.fromSites),
      toSite: plain(combos.toSites),
      electrodeType: plain(combos.electrodes),
      operationGroup: plain(combos.operationGroups),
    } as Record<string, DataMap>;
    // modelCodesFor/projectRowsFor 는 ref 를 읽어 항상 최신 후보를 본다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [combos, ee]);

  const requiredKeys = useMemo(() => new Set<string>(getRequiredColumns(context)), [context]);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    // 필수 `*` 라벨은 런타임(operationGroup=E 등)에 달려 있어 메타로 고정하지 않고 여기서 덮는다.
    const withStar = (col: RawFlexGridColumnConfig): RawFlexGridColumnConfig => {
      const key = col.colNm as NewPlanColumnKey;
      const base = col.colLblNm.endsWith('*') ? col.colLblNm.slice(0, -1) : col.colLblNm;
      return { ...col, colLblNm: requiredKeys.has(key) ? `${base}*` : base };
    };

    // admin 등록본(SCM_MST_SHEET_COLUMNS)이 있으면 구조·가시성 모두 메타가 결정한다 — division별 표시는
    //   SP 가 divisionId 로 걸러 반환하고(DIVISION_ID), FG전용(projectCode) 축은 VISIBLE_FLAG 로 표현된다.
    //   따라서 isColumnVisible 코드 오버레이를 쓰지 않는다(필수 `*`만 런타임). 알려진 바인딩 키 순서로
    //   재정렬하고(메타엔 순번 필드 없음) 알 수 없는 컬럼은 버린다.
    if (adminCols && adminCols.length > 0) {
      return adminCols
        .filter(c => COLUMN_POS.has(c.colNm))
        .sort((a, b) => (COLUMN_POS.get(a.colNm) ?? 0) - (COLUMN_POS.get(b.colNm) ?? 0))
        .map(c =>
          withStar({
            ...c,
            // 이 팝업은 컬럼 개인화가 없어 display 는 visible 을 따른다 — admin DEFAULT_FLAG(→display) 가
            //   숨김('N')이어도 보이는 컬럼은 그려지게 한다(메인 그리드와 달리 개인화 숨김 구분이 불필요).
            display: c.visible,
            // 그룹 없는 컬럼의 lCls/sCls 는 undefined 여야 THREE_DEPTH 헤더가 colLblNm 으로 fallback·병합된다.
            //   API 는 미그룹 컬럼에 null 을 주는데, columnMapping.normalizeRequiredMark 가 null 을 ''(빈 문자열)로
            //   바꿔 `?? colLblNm` fallback 이 깨지고(빈 문자열은 nullish 아님) 헤더가 빈 3단으로 펼쳐져 세로
            //   병합이 안 된다(columnMapping.ts L657 주석). 하드코딩 경로처럼 undefined 로 맞춘다.
            lClsLblNm: c.lClsLblNm && c.lClsLblNm.trim() !== '' ? c.lClsLblNm : undefined,
            sClsLblNm: c.sClsLblNm && c.sClsLblNm.trim() !== '' ? c.sClsLblNm : undefined,
          })
        );
    }

    // fallback — 컴포넌트 하드코딩 정의(미등록 화면/조회 실패). 메타가 없으니 조건부 표시(isColumnVisible)와
    //   필수 `*`를 코드로 입힌다.
    const toRaw = (c: ColumnDef, editable: boolean): RawFlexGridColumnConfig =>
      ({
        colNm: c.key,
        colLblNm: c.label,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: false,
        visible: true,
        display: true,
        uppercase: false,
        // 편집 가능 여부는 beginningEdit 이 행마다 판정한다. 컬럼 단위로는 후보가 될 수 있는 컬럼만 연다.
        inputTpCd: editable ? CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        cellCtrlObjTpCd: c.combo ? CELL_CONTROL_TYPE.COMBO : CELL_CONTROL_TYPE.TEXT,
        ...(c.group ? { lClsLblNm: c.group.large, sClsLblNm: c.group.small } : {}),
      }) as RawFlexGridColumnConfig;
    return [
      ...CONTEXT_COLUMNS.map(c => toRaw(c, false)),
      ...DATA_COLUMNS.map(c => toRaw(c, EDIT_CANDIDATE_KEYS.has(c.key))),
    ].map(col => {
      const key = col.colNm as NewPlanColumnKey;
      const visible = isColumnVisible(context, key);
      return withStar({ ...col, visible, display: visible });
    });
  }, [context, requiredKeys, adminCols]);

  // 그리드 핸들러와 DataMap 부착. 그리드는 데이터가 도착한 뒤에 생성되므로 준비될 때까지 프레임마다 재시도한다.
  useEffect(() => {
    if (!open) return undefined;
    let raf = 0;
    let cleanup: (() => void) | undefined;

    const applyMaps = (g: FlexGrid) => {
      if (g.activeEditor) return;
      let touched = false;
      Object.entries(dataMaps).forEach(([key, map]) => {
        const col = g.getColumn(key);
        if (col && col.dataMap !== map) {
          col.dataMap = map;
          touched = true;
        }
      });
      if (touched) g.invalidate();
    };

    const setup = (): boolean => {
      const g = gridRef.current;
      if (!g || !g.columnHeaders) return false;
      attachRowNoHeader(g, t(LBL.NO, '_No'));

      const beginningEditHandler = (s: FlexGrid, e: { cancel: boolean; row: number; col: number }) => {
        const key = (s.columns[e.col]?.binding ?? '') as NewPlanColumnKey;
        const row = s.rows[e.row]?.dataItem as GridRow | undefined;
        if (!row || !isCellEditable(ctxRef.current, row, key)) e.cancel = true;
      };
      g.beginningEdit.addHandler(beginningEditHandler);

      // 콤보 값이 바뀌면 AS-IS SpdMain_ComboSelChange(.cs:733-825)의 cascade 를 적용한다.
      const cellEditEndedHandler = (s: FlexGrid, e: { row: number; col: number }) => {
        const key = (s.columns[e.col]?.binding ?? '') as NewPlanColumnKey;
        const row = s.rows[e.row]?.dataItem as GridRow | undefined;
        if (!row || !EDIT_CANDIDATE_KEYS.has(key)) return;
        const value = str(row[key]);
        let options: { itemStillValid?: boolean; projectName?: string } = {};
        if (key === 'originFromDivisionId' || key === 'originToDivisionId') {
          options = { itemStillValid: modelCodesFor(row).includes(row.itemId) };
        } else if (key === 'projectCode') {
          const matched = projectRowsFor(row).find(p => str(p.CODE) === value);
          options = { projectName: value === '-' ? '-' : str(matched?.NAME2) };
        }
        Object.assign(row, applyCellChange(row, key, value, options));
        s.invalidate();
      };
      g.cellEditEnded.addHandler(cellEditEndedHandler);

      // 노란 편집 배경은 공용 그리드가 컬럼 설정만 보고 입히므로, 행마다 잠긴 셀(예: BOD 선택 전 Project Code,
      //   비EE 의 Project)은 여기서 셀 단위로 다시 판정한다. 공용 핸들러보다 뒤에 등록돼 나중에 실행된다.
      const formatEditableHandler = (s: FlexGrid, e: { panel: { cellType: CellType }; cell: HTMLElement; row: number; col: number }) => {
        if (e.panel.cellType !== CellType.Cell) return;
        const key = (s.columns[e.col]?.binding ?? '') as NewPlanColumnKey;
        // BOD 셀은 직접 입력은 막혀 있지만 클릭으로 BOD 팝업을 여는 셀이라 항상 팝업 아이콘을 보인다(AS-IS 이미지 셀, .cs:678-692).
        //   공용 래퍼는 편집 가능 컬럼에만 이 클래스를 붙이므로 여기서 직접 붙인다.
        e.cell.classList.toggle('wj-cell-popup', isBodClickColumn(key));
        // 다른 화면의 팝업 입력 셀과 같이 입력 수단이 있는 칸으로 보이도록 노란 편집 배경을 입힌다.
        if (isBodClickColumn(key)) {
          e.cell.classList.toggle('wj-cell-editable', !!s.rows[e.row]?.dataItem);
          return;
        }
        if (!EDIT_CANDIDATE_KEYS.has(key)) return;
        const row = s.rows[e.row]?.dataItem as GridRow | undefined;
        e.cell.classList.toggle('wj-cell-editable', !!row && isCellEditable(ctxRef.current, row, key));
      };
      g.formatItem.addHandler(formatEditableHandler);

      // BOD 컬럼 클릭 → BOD 팝업. 선행 값이 없으면 먼저 선택하라는 안내(AS-IS .cs:973-1111).
      const clickHandler = (ev: MouseEvent) => {
        const ht = g.hitTest(ev);
        if (ht.cellType !== CellType.Cell) return;
        if ((g.columns[ht.col]?.binding ?? '') !== 'bodId') return;
        const row = g.rows[ht.row]?.dataItem as GridRow | undefined;
        if (!row) return;
        const missing = !row.originFromDivisionId
          ? 'Origin From Div'
          : !row.originToDivisionId
            ? 'Origin To Div'
            : !row.itemId
              ? 'Model'
              : '';
        if (missing) {
          void setAlert({
            type: 'alert',
            content: t(MSG.SELECT_FIRST, '_First, select {0}.').replace('{0}', missing),
          });
          return;
        }
        setBodTargetKey(row.rowKey);
      };
      g.hostElement.addEventListener('click', clickHandler);

      applyMaps(g);
      const layoutHandler = () => applyMaps(g);
      g.updatedLayout.addHandler(layoutHandler);

      cleanup = () => {
        try {
          g.beginningEdit?.removeHandler(beginningEditHandler);
          g.cellEditEnded?.removeHandler(cellEditEndedHandler);
          g.formatItem?.removeHandler(formatEditableHandler);
          g.updatedLayout?.removeHandler(layoutHandler);
          g.hostElement?.removeEventListener('click', clickHandler);
        } catch {
          /* unmount race */
        }
      };
      return true;
    };

    const tick = () => {
      if (!setup()) raf = requestAnimationFrame(tick);
    };
    tick();
    return () => {
      cancelAnimationFrame(raf);
      cleanup?.();
    };
    // setup 안의 핸들러는 ref 로 최신 값을 읽는다. DataMap 이 바뀌면 다시 붙인다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, dataMaps, staticColumns]);

  // BOD 팝업 결과 반영 — 첫 행은 호출 행에, 나머지는 복제 행으로 아래에 붙인다(AS-IS .cs:1000-1104).
  const handleBodPicked = (picks: BodPick[]) => {
    const targetKey = bodTargetKey;
    if (!targetKey || picks.length === 0) return;
    const withProjectDefault = (row: NewPlanRow): NewPlanRow => {
      if (context.programId !== 'FG') return row;
      // 후보가 `-` 하나뿐이면 자동 선택한다(.cs:1096-1100).
      return projectRowsFor(row).length === 0 ? { ...row, projectCode: '-', projectName: '-' } : row;
    };
    setRows(prev => {
      const index = prev.findIndex(r => r.rowKey === targetKey);
      if (index < 0) return prev;
      const target = prev[index];
      Object.assign(target, withProjectDefault(applyBodPick(target, picks[0])));
      const clones = picks.slice(1).map(p => toGridRow(context, withProjectDefault(applyBodPick(createClonedRow(context, target), p))));
      return [...prev.slice(0, index + 1), ...clones, ...prev.slice(index + 1)];
    });
    setBodTargetKey(null);
    gridRef.current?.invalidate();
  };

  // 행 추가 — 선택 행(없으면 마지막 행)을 복제한다(AS-IS InsertRow2, .cs:722, 1043-1045).
  const handleInsert = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const selectedKey = grid ? (grid.rows[grid.selection.row]?.dataItem as GridRow | undefined)?.rowKey : undefined;
    setRows(prev => {
      const index = Math.max(
        0,
        prev.findIndex(r => r.rowKey === selectedKey)
      );
      const base = prev[selectedKey ? index : prev.length - 1];
      const next = toGridRow(context, base ? createClonedRow(context, base) : createEmptyRow(context));
      const at = selectedKey ? index + 1 : prev.length;
      return [...prev.slice(0, at), next, ...prev.slice(at)];
    });
  };

  // 행 삭제 — 마지막 1행은 지울 수 없다(AS-IS .cs:350, 726). AS-IS SpreadInfo.Delete()(.cs:7490-7519)는
  //   선택 블록이 있으면 그 블록의 row~row2 전체를 지운다 — row 하나만 보면 여러 행을 잡고 Delete 눌러도
  //   첫 행만 지워진다(2026-10-13 SCP0009 실측). 이 모달을 공용으로 쓰는 shipment-plan-semi 도 같은
  //   AS-IS 파리티 결함이라 화면 구분 없이 전체 적용한다(2026-10-13 사용자 지시).
  const handleDelete = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    if (!grid) {
      void setAlert({ type: 'alert', content: t(MSG.NO_ROW_SELECTED, '_No rows selected.') });
      return;
    }
    const { row, row2 } = grid.selection;
    const top = Math.min(row, row2);
    const bottom = Math.max(row, row2);
    const selectedKeys = new Set<unknown>();
    for (let r = top; r <= bottom; r += 1) {
      const key = (grid.rows[r]?.dataItem as GridRow | undefined)?.rowKey;
      if (key) selectedKeys.add(key);
    }
    if (selectedKeys.size === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_ROW_SELECTED, '_No rows selected.') });
      return;
    }
    setRows(prev => {
      const remaining = prev.filter(r => !selectedKeys.has(r.rowKey));
      return remaining.length === 0 ? prev : remaining;
    });
  };

  const systemError = () => void setAlert({ type: 'alert', content: t(MSG.SYSTEM_ERROR, '_System error.') });

  // 서버 중복 검사 → 저장. 둘 다 call-proc 응답의 o_rc1 첫 행 첫 열로 판정한다(AS-IS Rows[0][0], .cs:538-555, 646-673).
  const runSave = async (target: GridRow[]) => {
    setSaving(true);
    try {
      const check = await apiClient.post<{ o_rc1?: Record<string, unknown>[] }>(
        `/${menuId}/${NEW_CHECK_SHEET}/SEARCH/call-proc`,
        buildNewCheckArgs(context, target)
      );
      if (isSaveResultFailure(check)) return systemError();
      const verdict = judgeCheckResult((check.data?.result?.o_rc1 ?? [])[0]);
      if (verdict.status === 'DUPLICATE') {
        return void setAlert({
          type: 'alert',
          content: t(MSG.ALREADY_REGISTERED, '_Plan for this model is already registered.\n{0}').replace('{0}', verdict.detail),
        });
      }
      if (verdict.status !== 'OK') return systemError();

      const save = await apiClient.post<{ o_rc1?: Record<string, unknown>[] }>(
        `/${menuId}/${SAVE_POPUP_SHEET}/SAVE/call-proc`,
        buildNewSaveArgs(context, target)
      );
      if (isSaveResultFailure(save) || !isSaveSuccess((save.data?.result?.o_rc1 ?? [])[0])) return systemError();

      // 성공 — SCP0013 New 팝업(ProductionPlanInsertModal handleSave)과 동일한 저장 UX 로 통일(사용자 요청
      //   2026-10-13): 저장 중 Save 버튼 비활성(saving)+API 중 전역 busy 딤 → 성공 토스트(z-index 9999, 제일
      //   위)를 띄우고 재조회(onSaved) 후 팝업을 닫는다. 토스트는 닫힘과 함께 메인 위에 보인다(linger·차단형
      //   alert 제거). onSaved 는 비EE 만 재조회 confirm, EE 는 무동작(AS-IS BtnNew_Click .cs:4934-4948).
      setToast({ type: 'success', message: t(MSG.SAVE_DONE, '_Saved.') });
      onSaved(buildSavedItemIds(target));
      modalClose();
    } catch {
      systemError();
    } finally {
      setSaving(false);
    }
  };

  const handleSave = () => {
    gridRef.current?.finishEditing();
    // 저장 대상 스냅샷(행 얕은 복사) — 저장 confirm·서버 왕복(newCheck SP 가 수초 걸릴 수 있다) 동안
    //   그리드 행 객체가 재렌더/invalidate 로 유발된 cellEditEnded(Object.assign)로 비워져, newCheck 는
    //   값이 있었는데 저장은 빈 행을 보내 ORA-20002(NOT NULL)로 실패하던 레이스를 막는다(실측 2026-10-12).
    //   buildNewCheck/SaveArgs 는 스칼라 필드만 읽으므로 얕은 복사로 충분(mutate 되는 원본과 분리).
    const target = rowsRef.current.map(r => ({ ...r }));
    if (isPlanTypeLocked(context.planType)) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This Plan can not be modified.') });
      return;
    }
    if (findMissingRequired(context, target)) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Please enter the required fields.') });
      return;
    }
    if (hasDuplicateRows(target)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.DUPLICATE_NEW, '_There are duplicate entries among the newly entered data.'),
      });
      return;
    }
    // 저장 전 확인("저장하시겠습니까") 제거(사용자 요청 2026-10-12) — 검증 통과 시 바로 저장한다.
    void runSave(target);
  };

  const bodTarget = rows.find(r => r.rowKey === bodTargetKey);

  return (
    <>
      <CustomDialog
        open={open}
        size={1400}
        height={520}
        type='modal'
        position='basic'
        handleClose={modalClose}
        disableButtonCancel
        // 컬럼 콤보 드롭다운이 다이얼로그 밖에 붙어 MUI FocusTrap 이 선택을 끊는다(다른 편집 그리드 모달과 같은 사유).
        disableEnforceFocus
        customHeaderTitle={
          <div className='headerContainer'>
            <div className='headerDot' />
            <h2 className='headerTitle'>{t(NEW_TITLE_KEY, 'Shipment Plan Insert')}</h2>
          </div>
        }
        customContentArea={
          <div className={styles.dialogContent}>
            <div className={styles.gridWrapper}>
              <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
                <DataGrid<WijmoRowItem>
                  gridRef={gridRef}
                  gridFilterRef={gridFilterRef}
                  itemsSource={rows as unknown as WijmoRowItem[]}
                  staticColumns={staticColumns}
                  autoGenerateColumns={false}
                  allowSorting={false}
                  className={styles.grid}
                />
              </ResultArea>
            </div>
            <div className={styles.buttonWrapper}>
              <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Insert' onClick={handleInsert} />
              <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Delete' onClick={handleDelete} />
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t(LBL.SAVE, '_Save')}
                iconComponent={<ControlConfirmIcon size='small' />}
                iconPosition='leading'
                disabled={saving}
                onClick={handleSave}
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t(LBL.CLOSE, '_Close')}
                onClick={modalClose}
              />
            </div>
          </div>
        }
      />
      <NewPlanBodModal
        open={bodTargetKey !== null && !!bodTarget}
        modalClose={() => setBodTargetKey(null)}
        setSelectedValue={handleBodPicked}
        params={{
          menuId,
          divisionId: context.divisionId,
          planStartYyyymmdd: context.planStartYyyymmdd,
          planType: context.planType,
          planSeq: context.planSeq,
          operationGroupId: context.operationGroupId,
          originFromDivisionId: bodTarget?.originFromDivisionId ?? '',
          originToDivisionId: bodTarget?.originToDivisionId ?? '',
          itemId: bodTarget?.itemId ?? '',
          programId: context.programId,
        }}
      />
    </>
  );
};
