import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  type CellRangeEventArgs,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef, type Ref } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  GRID_CASCADE_CLEAR,
  GRID_CASCADE_FILTERS,
  MAIN_COLUMNS,
  MSG,
} from '../sales-future-price.constants';
import type { FuturePriceRow } from '../sales-future-price.types';
import styles from '../SalesFuturePrice.module.scss';
import {
  currencyCodesFromRateMap,
  type ExchangeRateMap,
  getExchangeRate,
  isExchangeTargetMeasure,
} from '../salesPriceExchange';
import type { MeasureMeta } from '../useSalesFuturePriceStore';
import { groupKeyOf } from '../utils/futurePriceGroup';

interface Props {
  rows: FuturePriceRow[];
  gridRef: Ref<FlexGridType<FuturePriceRow>>;
  // ⭐ F4 Filter — 피처가 FlexGridFilter 를 직접 소유(공용 DataGrid 의 filterColumns:[''] 기본 생성 회피).
  //   3단 머지 동적(W_/M_) 컬럼은 필터 대상 제외(filterChanging cancel + 영속 sanitize) + filterApplied 시
  //   헤더높이/LOC backcolor 재적용(invalidate(true)→updatedLayout) → 머지헤더/높이 충돌 없이 활성 (2026-06-28).
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save(편집행 'U') — 변경 셀 추적 (EditTracker.getOriginalValues()). 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  //   FuturePriceRow 는 WijmoRowItem 제약 위반(index sig) → EditTracker default generic 사용.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  onPopupCellDblClick?: (modalKey: string, row: FuturePriceRow) => void;
  divisionId?: string;
  // ⭐ 편집가능 division 게이트 (메타/LOOKUP 구동 — SalesFuturePrice.tsx isEditableDivision).
  //   false = 편집제약 division → 동적 셀 편집불가(노랑 미표시) + beginningEdit 차단. 기본 true(호환).
  editable?: boolean;
  bucketType?: BUCKET_TYPE;
  // ⭐ master hook §2.5 — admin SYS0004 UI Category Setup 동적 메타 (전체 속성 반영)
  staticColumns?: RawFlexGridColumnConfig[];
  staticMeasures?: MeasureMeta[];
  // Insert LOC 행 동적셀 편집 시 형제 measure 환율 재계산 연동용 (부모가 exchangeData 로 build).
  exchangeRateMap?: ExchangeRateMap;
}

// 셀 값 → 문자열 (unknown 안전 변환 — no-base-to-string 회피, cascade 필터/비교용)
const cellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// FlexGridColumn 렌더링용 통합 column meta
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  fixed: boolean;
  scale?: number;
  _ctrlType?:
    | 'FPText'
    | 'FPModal'
    | 'FPComboBox'
    | 'FPCheckBox'
    | 'FPDate'
    | 'FPDateTime'
    | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
  _comboKey?: string;
  // hook #92 column-division-id-visibility — admin DIVISION_ID(콤마 토큰 리스트) 복사값(ATTRIBUTE3).
  //   공란/undefined = 항상 표시 / 값 있으면 선택 division 토큰 포함 시만 표시.
  _divisionAllow?: string;
}

// SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과는 wide format —
//   28 fixed cols + 동적 W_YYYYMMDD 또는 M_YYYYMM cols
// FE 가 동적 col binding 을 결과 keys 에서 추출

const getDynKey = (
  binding: string
): { kind: 'W' | 'M' | null; ym: string; mmdd: string; wk: string } => {
  if (/^W_\d{8}$/.test(binding)) {
    const d = binding.slice(2);
    const y = Number(d.slice(0, 4));
    const m = Number(d.slice(4, 6)) - 1;
    const dd = Number(d.slice(6, 8));
    const date = new Date(Date.UTC(y, m, dd));
    const dn = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dn);
    const yStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    const wk = Math.ceil(((date.getTime() - yStart.getTime()) / 86400000 + 1) / 7);
    return {
      kind: 'W',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      mmdd: `${d.slice(4, 6)}${d.slice(6, 8)}`,
      wk: `W${String(wk).padStart(2, '0')}`,
    };
  }
  if (/^M_\d{6}$/.test(binding)) {
    const d = binding.slice(2);
    return { kind: 'M', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, mmdd: '', wk: '' };
  }
  return { kind: null, ym: '', mmdd: '', wk: '' };
};

export const SalesFuturePriceGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onPopupCellDblClick,
  divisionId,
  editable = true,
  bucketType = BUCKET_TYPE.WEEKLY,
  staticColumns,
  staticMeasures,
  exchangeRateMap,
}: Props) => {
  const { t } = useTranslation();
  const bucketPrefix = bucketType === BUCKET_TYPE.MONTHLY ? 'M' : 'W';
  // cellEditEnded 핸들러(effect 내부)가 최신 환율맵을 stale 없이 참조 — ref 로 보관.
  const exchangeRateMapRef = useRef(exchangeRateMap);
  exchangeRateMapRef.current = exchangeRateMap;

  // ⭐ MEASURE 표시명 = UI Category Setup Measure 메타(COLUMN_NAME→COLUMN_LABEL_NAME) 기반 DataMap.
  //   (2026-07-07 사용자 요구) admin 이 COLUMN_NAME='RTF_SYS_RP' / COLUMN_LABEL_NAME='RTF' 로 등록 →
  //   SP 원시 measure 코드('RTF_SYS_RP')를 라벨('RTF')로 표시 + 콤보(옵션=measure 목록)로 동작.
  //   ⚠️ 하드코딩 금지 — 코드→라벨 리터럴 매핑 대신 admin 메타를 단일 source 로 사용. 메타 미로드 시 null(=raw 코드 표시).
  //   staticMeasures 는 SalesFuturePrice.tsx 의 handleInsert(신규행 measure 개수)에서도 사용.
  const measureDataMap = useMemo<DataMap | null>(() => {
    // BE GridMeasure DTO = camelCase(colNm/colLblNm). 정렬은 SP 반환 순서 유지(배열 순서).
    const list = (staticMeasures ?? [])
      .filter(m => !!(m.colNm ?? '').trim())
      .map(m => ({
        CODE: m.colNm.trim(),
        NAME: (m.colLblNm ?? m.colNm).trim() || m.colNm.trim(),
      }));
    if (list.length === 0) return null;
    return new DataMap(list, 'CODE', 'NAME');
  }, [staticMeasures]);

  // ⭐ master hook §4 — admin SYS0004 staticColumns 가 있으면 전체 속성 사용,
  //   없으면 MAIN_COLUMNS hardcode fallback (BE 실패 시 화면 작동 보장)
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    if (!staticColumns || staticColumns.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>(c => ({
        binding: c.key,
        header: c.header,
        width: c.width ?? 100,
        align: c.align ?? 'C',
        visible: true,
        fixed: false,
        _ctrlType: c._ctrlType,
        _inputEditType: c._inputEditType,
        _modalKey: c._modalKey,
        _comboKey: c._comboKey,
      }));
    }
    return staticColumns.map(sc => {
      const fb = MAIN_COLUMNS.find(m => m.key === sc.colNm);
      return {
        binding: sc.colNm,
        header: sc.colLblNm || fb?.header || sc.colNm,
        width: sc.colWth ?? fb?.width ?? 100,
        align: sc.horzAlgnCd ?? fb?.align ?? 'C',
        visible: sc.visible !== false,
        fixed: sc.fixed === true,
        scale: sc.scale,
        // ⭐ cell type / combo 는 UI Category(DB) 를 authoritative 로 사용 — 상수 fallback 제거 (2026-07-01).
        //   기존 `?? fb?._ctrlType` 는 admin 이 cell type 을 '삭제(NULL)' 해도 MAIN_COLUMNS 상수(FPComboBox)로
        //   되돌려 콤보가 계속 표시되는 사고 (DIVISION_ID '82 명칭'). staticColumns 미로드 시엔 상단 MAIN_COLUMNS 분기가 담당.
        _ctrlType: sc.cellCtrlObjTpCd,
        _inputEditType: sc.inputTpCd ?? fb?._inputEditType,
        _modalKey: sc.attribute1 ?? fb?._modalKey,
        // ⭐ 콤보 SQL_ID = UI Category Setup 의 CELL_COMBO_DATA_TYPE(cellCboDataTp). 삭제(NULL) 시 콤보 미적용(상수 fallback 제거).
        _comboKey: sc.cellCboDataTp ?? sc.attribute2,
      } as MergedColumnMeta;
    });
  }, [staticColumns]);

  // ⭐ division 필터는 SP(PR_GET_SHEET_COLUMN_LIST)가 SCM_MST_SHEET_COLUMNS.DIVISION_ID 컬럼으로
  //   서버측 처리 (store.fetchStaticColumns(divisionId), 2026-07-07 — attribute3 미사용).
  //   FE 는 visible 만 필터. (divisionId 변경 시 store 가 컬럼 재조회 → staticColumns 갱신.)
  void divisionId; // division 은 SP 서버측 필터로 이관 — prop 은 부모 호환/미래 cascade 용 보존
  const visibleColumns = useMemo(() => mergedColumns.filter(c => c.visible), [mergedColumns]);
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.binding), [visibleColumns]);

  // ===== Grid 내 combo column dropdown — useTabComboQueries + Wijmo DataMap =====
  //   AS-IS .cs SetCellTypeCombo(dtXxx) → TO-BE 는 UI Category(cellCboDataTp) 메타로 이관 (combo SQL_ID = admin 관리).
  // ⭐ UI Category Setup(CELL_COMBO_DATA_TYPE=cellCboDataTp) 기반 콤보 로딩 — 하드코딩 comboId 전면 제거
  //   (2026-07-01 사용자 요구). FPComboBox 컬럼의 combo SQL_ID 를 그대로 사용 → admin 콤보 변경 즉시 반영.
  //   공용 DataGrid 표준(staticColumns 의 cellCboDataTp)과 동일 방식 — comboId 문자열만 전달
  //   (세션 파라미터 @sesUserId/@mnuId/@langCd 는 BE 자동 채움).
  const comboColumns = useMemo(
    () => visibleColumns.filter(c => c._ctrlType === 'FPComboBox' && !!c._comboKey),
    [visibleColumns]
  );
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(c => c._comboKey as string),
  });
  // dataMap 재생성 안정화 — comboId + row count 시그니처가 바뀔 때만 rebuild
  //   (react-query 의 data 참조는 갱신 전까지 안정적이라, count 변화로 로드 완료를 감지).
  const comboSig = comboColumns
    .map((c, i) => `${c._comboKey}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      m[c.binding] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // ⭐ cascade (hook #59 / AS-IS spdMain_ComboSelChange L2612~2757) — 편집 진입 시 행 컨텍스트
  //   dataMap 스왑에 쓰는 콤보 원본 rows + 전체 dataMap 원복용 ref 미러 (핸들러 useEffect deps 밖 참조).
  const comboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  const dataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    const rowsByBinding: Record<string, Record<string, unknown>[]> = {};
    comboColumns.forEach((c, i) => {
      rowsByBinding[c.binding] = (comboResults[i] ?? []) as unknown as Record<string, unknown>[];
    });
    comboRowsRef.current = rowsByBinding;
    dataMapsRef.current = dataMaps;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, dataMaps]);
  // 편집 시작 셀의 (binding, oldVal) — cellEditEnded 에서 실제 값 변경 여부 판정(불필요 clear 방지).
  const editingCellRef = useRef<{ binding: string; oldVal: unknown } | null>(null);

  // 동적 컬럼 keys 추출 — SP 결과 모든 row 의 union
  //   Bucket=W → W_yyyymmdd 중 주 시작일(월요일 OR 월 1일) / Bucket=M → M_yyyymm 만
  //   ⭐ 2026-06-28: SP 는 월경계에서 주차를 분할 반환(W_20260629(6월 월요일) + W_20260701(7월 1일)).
  //      "월요일만" 필터는 월경계 분할 주차(비월요일 시작=월 1일)를 버려 7/1 시작 주차가 누락됨 →
  //      "월요일 OR 월 1일" 로 완화(YYYYMM 단위로 동일 주차라도 월 다르면 표현 — 사용자 요구).
  const dynBindings = useMemo<string[]>(() => {
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    const matchPrefix = bucketPrefix === 'M' ? /^M_\d+$/ : /^W_\d+$/;
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (!matchPrefix.test(k)) continue;
        if (bucketPrefix === 'W') {
          const d = k.slice(2);
          const dt = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
          // 주 시작일 = 월요일(getUTCDay===1) 또는 월 1일(getUTCDate===1, 월경계 분할 주차)
          if (dt.getUTCDay() !== 1 && dt.getUTCDate() !== 1) continue;
        }
        set.add(k);
      }
    }
    return [...set].sort();
  }, [rows, bucketPrefix]);

  // ⭐ 과거 주차/월 편집불가 cutoff = "이번 주 월요일" (AS-IS L893: Today + (Monday(1) - DayOfWeek)).
  //   formatItem(gray) + beginningEdit(lock) 동일 기준. JS getDay(Sun=0)는 .NET DayOfWeek 와 동일.
  const todayCutoff = useMemo(() => {
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    now.setDate(now.getDate() + (1 - now.getDay())); // 이번 주 월요일
    const ymd = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(
      now.getDate()
    ).padStart(2, '0')}`;
    return { week: ymd, month: ymd.slice(0, 6) };
  }, []);

  // ⭐ combo dataMap 적용 = 아래 헤더높이와 동일한 persistent `updatedLayout` 핸들러에 통합(L621~).
  //   이유: 공유 DataGrid 가 매 렌더 columnGroups 재적용 시 컬럼의 dataMap 을 undefined 로 덮음
  //         (DataGrid.tsx §wrapper-level only — 화면 useEffect/one-shot 은 rebuild 에 덮여 무효).
  //   → one-shot 으로 set 하면 직후 rebuild 에 코드(명칭 미표시) 회귀. updatedLayout 마다 재적용(guard)으로 영속.
  //   ⚠️ 다중 updatedLayout 핸들러는 hook #93 경쟁 사고 원인 → 헤더높이 핸들러 1곳에 합쳐서 처리(invalidate 미호출).

  // ⭐ 룰 #60 — DataGrid wrapper 의무. visibleColumns + dynBindings → staticColumns + dynamicColumns prop.
  //    initialized prop 미사용 (wrapper 의 자동 기능 보존 — `{...gridProps}` override 회피).
  //    복합 로직 (3단 헤더 / formatItem / beginningEdit / cellEditEnded / mergeManager / dblclick / scroll)
  //    은 useEffect 로 분리 등록 + cleanup.
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        colNm: c.binding,
        colLblNm: c.header,
        sClsLblNm: (c as { _sClsLblNm?: string })._sClsLblNm,
        lClsLblNm: (c as { _lClsLblNm?: string })._lClsLblNm,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        inputTpCd:
          c._inputEditType === 'S'
            ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
            : c._inputEditType === 'M'
              ? CELL_INPUT_EDIT_TYPE.MANDATORY
              : c._inputEditType === 'IM'
                ? CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY
                : c._inputEditType === 'IO'
                  ? CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY
                  : CELL_INPUT_EDIT_TYPE.OPTIONAL,
        scale: c.scale,
      })),
    [visibleColumns]
  );
  // ⭐ 3단 nested (사용자 요구 2026-06-21 유지) — year-month → week → day.
  //   1단 group  = 대상년월 ('YYYY-MM') / Monthly: ymLabel.
  //   2단 group  = 주차 ('Wxx', ISO week native Date) / Monthly: 'SUM'.
  //   3단 leaf   = 일자 ('MMDD') / Monthly: ''.
  //   height 미지정 — Wijmo Column 은 height 속성 미지원(무시). 헤더 높이는 updatedLayout 효과가 columnHeaders.rows 로 전담.
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynBindings.length === 0) return [];
    const isoWeek = (yyyymmdd: string): number => {
      const d = new Date(
        Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
      );
      const day = d.getUTCDay() || 7;
      d.setUTCDate(d.getUTCDate() + 4 - day);
      const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
      return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
    };
    type YmBucket = { ymLabel: string; weeks: Map<string, FlexGridColumnConfig[]> };
    const ymMap = new Map<string, YmBucket>();
    for (const b of dynBindings) {
      const isMonthly = b.startsWith('M_');
      const ymd = b.slice(2);
      const ym = ymd.slice(0, 6);
      const ymLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
      const mmdd = isMonthly ? '' : ymd.slice(4, 8);
      const wLabel = isMonthly ? 'SUM' : `W${isoWeek(ymd)}`;
      let bucket = ymMap.get(ym);
      if (!bucket) {
        bucket = { ymLabel, weeks: new Map() };
        ymMap.set(ym, bucket);
      }
      if (!bucket.weeks.has(wLabel)) bucket.weeks.set(wLabel, []);
      bucket.weeks.get(wLabel)!.push({
        binding: b,
        header: mmdd,
        align: 'right',
        format: 'n3',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // ⭐ LOC-only editable (#70 P7) — 동적 셀은 'S'(read-only) 로 wrapper 자동 editable 색/편집 차단.
        //   LOC row 만 아래 beginningEdit 에서 명시적으로 e.cancel=false 로 편집 허용.
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        _display: true,
      });
    }
    return [...ymMap.values()].map(bucket => ({
      header: bucket.ymLabel,
      align: 'center',
      columns: [...bucket.weeks.entries()].map(([wLabel, dayCols]) => ({
        header: wLabel,
        align: 'center',
        columns: dayCols,
      })),
    }));
  }, [dynBindings]);

  // ⭐ grid 핸들러 + mergeManager useEffect 분리 등록.
  //    DataGrid wrapper 의 자동 기능 (setEditableColumns / setSortableColumns / formatItem default 등) 보존.
  //    deps = [visibleColumns, dynBindings] — column 변경 시 handler 재등록 (closure 정합).
  //    null guard 강화 — DataGrid wrapper 의 initialized handler 시점 vs useEffect timing 차이.
  //    ⚠ 헤더 높이는 본 효과에서 조작하지 않음 — 아래 updatedLayout 단일 효과가 전담 (height 경쟁 금지).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<FuturePriceRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // ⭐ 홀수/짝수 행 zebra (사용자 명시 2026-06-28) — Wijmo 표준 alternatingRowStep=1 → 클래스 없는 셀(White 기본)에
    //   foundation `.wj-cell.wj-alt`(#F7F7F8) 자동 적용. 명시 설정으로 zebra 보장(편집 yellow/과거 gray 셀은 우선).
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGridType<FuturePriceRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        // 동적 W/M = Wijmo nested 자동 (group cell + leaf).
        // 정적 column verticalSpan = mergeManager 의 ColumnHeader 분기로 row 0~2 merge.
        e.cell.style.textAlign = 'center';
        return;
      }

      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;
      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: FuturePriceRow })?.dataItem;
      const meta = visibleColumns.find(c => c.binding === col.binding);
      const isDyn = !meta && /^[WM]_/.test(col.binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';
      const isLocRow = String(rowItem?.MEASURE ?? '') === 'LOC';

      // 동적 col — LOC row 만 editable (AS-IS L2108: Measure='LOC' 가 아니면 LockRange2)
      //   ⚠ Wijmo 셀 재활용 시 editable/non-editable 클래스가 한 셀에 동시 잔존 →
      //     나중 정의된 non-editable(!important)이 이겨 회색 표시 사고. 두 클래스 상호배타 toggle 의무.
      //     wrapper formatEditableColumns 가 'S' 동적 col 의 editable 을 먼저 끄지만 feature 가 나중 실행 → 우선.
      if (isDyn) {
        // ⭐ backcolor 규칙 (사용자 명시 2026-06-28):
        //   - LOC measure 행의 동적 셀만 색상 대상. 비-LOC(RTF/KRW/USD) 동적 셀 = White(클래스 없음).
        //   - LOC: 현재/미래 주차 = Yellow(편집가능) / 과거 주차(이번 주 월요일 이전) = Gray(편집불가, AS-IS L893~921).
        //   gray(wj-cell-non-editable)는 LOC 과거주차에만 적용 — 그 외 비편집은 회색칠 금지(기본 White).
        if (!isLocRow) {
          toggleClass(e.cell, 'wj-cell-editable', false);
          toggleClass(e.cell, 'wj-cell-non-editable', false);
          return;
        }
        const tag = col.binding.slice(2);
        const isPast = col.binding.startsWith('M_')
          ? tag < todayCutoff.month
          : tag < todayCutoff.week;
        // 편집제약 division(메타 LOOKUP 구동, 82만 편집) 은 편집가능(노란) 표시 안 함.
        toggleClass(e.cell, 'wj-cell-editable', !isPast && editable);
        toggleClass(e.cell, 'wj-cell-non-editable', isPast);
        // ⭐ 변경 셀 빨강 (AS-IS red cell) — EditTracker 가 기록한 사용자 변경 셀만 빨간 글자.
        //   Wijmo 셀 재활용 → 미변경 셀은 color 제거(잔존 방지).
        const changedRec = editTrackerRef?.current?.getOriginalValues().get(rowItem as never);
        if (changedRec && col.binding in changedRec) {
          e.cell.style.setProperty('color', '#d32f2f', 'important');
        } else {
          e.cell.style.removeProperty('color');
        }
        return;
      }

      // Fixed col cell coloring
      //   Insert row 의 IM (필수) + IO (옵션) 모두 editable (사용자 요구 2026-06-03 v3)
      //   MEASURE 는 'S' (read-only, RTF/KRW/USD/LOC 고정)
      //   FPModal (popup) 은 cell 우측에 공용 OpenInNew 아이콘(DMF0006 동일) 표시 + dblClick popup
      if (meta) {
        // INSERT 고정컬럼(MEASURE 앞, 머지된 공유셀) = 편집가능 Yellow. MEASURE='S' → White.
        //   (가격 동적셀의 LOC-한정 backcolor 는 위 isDyn 분기에서 별도 처리.)
        // ⭐ 정적 컬럼 backcolor (사용자 명시 2026-06-28): InsertRow 의 IM/IO = Yellow(편집가능),
        //   그 외(조회/비-insert) = White(기본). gray 미적용 — 정적 컬럼은 절대 회색칠하지 않음.
        //   FPModal 팝업셀(MODEL/PROJECT)은 insert 시 팝업으로 편집 가능하므로 _inputEditType 무관 색칠.
        const editableForInsert =
          isInsert &&
          (meta._inputEditType === 'IM' ||
            meta._inputEditType === 'IO' ||
            meta._ctrlType === 'FPModal');
        toggleClass(e.cell, 'wj-cell-editable', editableForInsert);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        // ⭐ 전용 클래스 is-insert-editable 로 solid Yellow 보장(scss `.grid` scope !important).
        toggleClass(e.cell, 'is-insert-editable', editableForInsert);
        // ⭐ 최종 보장 (2026-06-30) — inline !important 배경은 모든 스타일시트·핸들러 순서를 이김(Wijmo 표준 셀 포맷).
        if (editableForInsert) e.cell.style.setProperty('background-color', '#fff8cd', 'important');
        else e.cell.style.removeProperty('background-color');
        // ⭐ FPModal 팝업셀 아이콘 = DMF0006 과 동일(MUI OpenInNew). (2026-07-01 사용자 요구: 구 🔍 이모지 → DMF0006 모양)
        //   DMF0020 module scss 의 wj-cell-popup override(그라데이션 배경 + '↗') 및 insert 노란배경과 충돌 방지 위해
        //   wj-cell-popup 클래스는 쓰지 않고, 전용 span(.popup-icon + styles.popupIcon)으로 동일 SVG 아이콘만 렌더.
        toggleClass(e.cell, 'wj-cell-popup', false);
        if (editableForInsert && meta._ctrlType === 'FPModal') {
          const cellEl = e.cell;
          cellEl.style.cursor = 'pointer';
          cellEl.title = `${meta.header} 팝업 (더블클릭)`;
          // ⚠️ cellEl.style.position 은 절대 건드리지 않음 — Wijmo 셀 position:absolute override 시 머지셀 파손(2026-06-30).
          //   아이콘 span(position:absolute)은 셀의 기존 absolute 를 containing block 으로 anchor 하므로 override 불필요.
          cellEl.style.paddingRight = '20px';
          if (!cellEl.querySelector('.popup-icon')) {
            const icon = document.createElement('span');
            icon.className = `popup-icon ${styles.popupIcon}`;
            cellEl.appendChild(icon);
          }
        } else {
          // 팝업 아닌 편집셀/비-insert 셀 — 잔존 아이콘 span 제거(셀 재활용 대비).
          e.cell.querySelector('.popup-icon')?.remove();
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 시 row 단위 제어 — Insert row 만 fixed cols 편집 허용
    //   FPModal popup cell 은 직접 입력 차단 (dblClick popup 만 허용)
    //   동적 col 은 LOC row 만 편집 허용 (AS-IS .cs L2108)
    const beginningEditHandler = (
      s: FlexGridType<FuturePriceRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      // 편집제약 division(메타 LOOKUP 구동, 82만 편집) 컨텍스트는 읽기전용 — 모든 셀 편집 차단.
      if (!editable) {
        e.cancel = true;
        return;
      }
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
      const isInsert = row?.CRUD_TYPE === 'I';
      // INSERT: 고정컬럼(MEASURE 앞)은 머지된 공유셀이라 행 무관 편집 허용(앵커=최상단 행, cellEditEnded 가 4행 동기화).
      //   가격(동적 W_/M_) 컬럼은 아래 분기에서 LOC 행만 편집 허용. MEASURE='S' 는 meta 분기에서 차단.
      const meta = visibleColumns.find(c => c.binding === binding);

      // Fixed col — Insert row 의 IM/IO + popup 차단
      if (meta) {
        if (!isInsert) {
          e.cancel = true;
          return;
        }
        if (meta._ctrlType === 'FPModal') {
          e.cancel = true;
          return;
        }
        if (meta._inputEditType === 'S') {
          e.cancel = true;
          return;
        }
        // ⭐ cascade dataMap 스왑 (hook #59 / AS-IS SetCellTypeCombo 행 단위 combo 재구성 1:1):
        //   FPComboBox 편집 진입 시 해당 행의 상위 셀 값으로 콤보 후보 필터 → 컬럼 dataMap 교체.
        //   관대 통과: 행 상위 값 또는 콤보 row 필터 키가 비면 통과 (searchFields toOptions 관용구 —
        //   사내 미이관 필터 키(END_CUSTOMER 콤보의 DEPT_ID 등)는 데이터 적재 시 자동 활성).
        //   스왑 dataMap 은 cellEditEnded 진입 시 전체 dataMap 으로 원복 (타 행 CODE→NAME 표시 보존).
        editingCellRef.current = {
          binding,
          oldVal: row ? (row as Record<string, unknown>)[binding] : undefined,
        };
        const cascade = GRID_CASCADE_FILTERS[binding];
        if (meta._ctrlType === 'FPComboBox' && cascade && row) {
          const src = comboRowsRef.current[binding] ?? [];
          const rowRec = row as unknown as Record<string, unknown>;
          const filtered = src.filter(cr =>
            cascade.every(({ rowKey, comboKey }) => {
              const rv = cellStr(rowRec[rowKey]).trim();
              const cv = cellStr(cr[comboKey]).trim();
              return !rv || rv === 'ALL' || !cv || rv === cv;
            })
          );
          // Map 복합 키 dedup (hook #59 §3) — 필터 후 division 컨텍스트 유지
          const dedup = [
            ...new Map(
              filtered.map(cr => [`${cellStr(cr.DIVISION_ID)}|${cellStr(cr.CODE)}`, cr])
            ).values(),
          ];
          col.dataMap = new DataMap(dedup, 'CODE', 'NAME');
        }
        return;
      }
      // Dynamic col — LOC row 만 편집 허용 (#70 P7: wrapper read-only 'S' 를 LOC 만 명시 override).
      //   FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper setEditableColumns 보다 우선.
      if (/^[WM]_/.test(binding)) {
        const isLoc = String(row?.MEASURE ?? '') === 'LOC';
        if (!isLoc) {
          e.cancel = true; // LOC 외 동적 셀 편집 차단
          return;
        }
        // AS-IS L893~921 — LOC 라도 과거 주차/월(이번 주 월요일 이전)은 lock (formatItem gray 와 동일 cutoff).
        const tag = binding.slice(2);
        const isPast = binding.startsWith('M_')
          ? tag < todayCutoff.month
          : tag < todayCutoff.week;
        if (isPast) {
          e.cancel = true; // 과거 주차/월 편집 차단
          return;
        }
        // Currency 빈값 가드 (MSG00447) — 통화 미설정 행은 가격(LOC) 편집 불가 (AS-IS spdMain_CellClick).
        if (String(row?.CURRENCY ?? '').trim() === '') {
          e.cancel = true;
          void useMessageStore.getState().setAlert({
            type: 'alert',
            content: t(MSG.CURRENCY_EMPTY, '_Currency 가 비어 있습니다.'),
          });
          return;
        }
        e.cancel = false; // LOC + 현재/미래 + 통화 있음 → 편집 허용
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Insert row 편집 종료 시 — 같은 INSERT_GROUP_ID 4 measure row 동기화.
    const cellEditEndedHandler = (s: FlexGridType<FuturePriceRow>, e: { row: number; col: number }) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      // ⭐ cascade 스왑 원복 — beginningEdit 에서 행 컨텍스트로 필터된 dataMap 을 전체 dataMap 으로
      //   되돌린다 (스왑이 남으면 필터 밖 CODE 를 가진 타 행의 명칭 변환이 깨짐). 편집 취소도 커버.
      if (GRID_CASCADE_FILTERS[binding] && dataMapsRef.current[binding]) {
        col.dataMap = dataMapsRef.current[binding];
      }
      const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
      if (!row) return;
      const items = s.collectionView.items;

      // (A) 동적 W_/M_ 셀 — LOC 행 입력/수정 시 형제 measure(KRW/USD/RTF) 환율 재계산 연동.
      //   insert('I') = 같은 INSERT_GROUP_ID / 기존('M'·조회) = 같은 groupKeyOf 형제 (저장 siblingsOf 동일 키).
      //   ⭐ 기존행도 즉시 표시 갱신 (AS-IS Dsdm_Changed) — 저장 payload 는 handleSave 가 LOC 기준 재계산(정합).
      if (/^[WM]_/.test(binding) && (row.MEASURE ?? '') === 'LOC') {
        const div = String(row.DIVISION_ID ?? '');
        const baseCur = String(row.CURRENCY ?? '');
        const yyyymm = binding.slice(2, 8); // W_yyyymmdd / M_yyyymm → yyyymm
        const locRaw = (row as Record<string, unknown>)[binding];
        const locPrice = locRaw == null || locRaw === '' ? '0' : String(locRaw as string | number);
        const erMap = exchangeRateMapRef.current;
        // ⭐ AS-IS 정합(사용자 실측 2026-07-08) — LOC 입력 시 통화 measure(KRW/USD)만 환율 재계산.
        //   RTF(RTF_SYS_RP)는 시스템 생성 measure(이동계획 판가) → 변경하지 않음(재조회 시 시스템 값이 정본).
        //   판정 = 환율 데이터의 통화코드 집합(하드코딩 금지). 미로드 시 기존 동작.
        const currencyCodes = currencyCodesFromRateMap(erMap);
        const isInsert = row.CRUD_TYPE === 'I';
        const gid = row.INSERT_GROUP_ID;
        const gkey = isInsert ? '' : groupKeyOf(row as Record<string, unknown>);
        for (const item of items) {
          if ((item.MEASURE ?? '') === 'LOC' || item === row) continue;
          const isSibling = isInsert
            ? item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid
            : item.CRUD_TYPE !== 'I' && groupKeyOf(item as Record<string, unknown>) === gkey;
          if (!isSibling) continue;
          const sm = String(item.MEASURE ?? '');
          if (!isExchangeTargetMeasure(currencyCodes, sm, baseCur)) continue; // RTF 등 비통화 measure 미변경
          (item as Record<string, unknown>)[binding] = erMap
            ? getExchangeRate(erMap, div, baseCur, sm, yyyymm, locPrice, null)
            : locPrice;
        }
        s.invalidate(true);
        return;
      }

      // (B) 고정 col — insert 전용 (같은 INSERT_GROUP_ID 4 measure row 좌측 fixed cols 동기화).
      if (row.CRUD_TYPE !== 'I') return;
      const gid = row.INSERT_GROUP_ID;
      if (!gid) return;
      const meta = visibleColumns.find(c => c.binding === binding);
      if (!meta) return;
      const newVal = (row as Record<string, unknown>)[binding];
      for (const item of items) {
        if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid && item !== row) {
          (item as Record<string, unknown>)[binding] = newVal;
        }
      }

      // ⭐ cascade 계단식 리셋 (AS-IS ComboSelChange clear 체인 L2666~2679/2706~2717/2727~2736/
      //   2740~2747 1:1) — 상위 combo 값이 실제로 바뀐 경우만, 같은 INSERT_GROUP_ID 4행의 하위 셀 clear.
      const clearTargets = GRID_CASCADE_CLEAR[binding];
      const prev = editingCellRef.current;
      const changed = prev?.binding === binding && cellStr(prev.oldVal) !== cellStr(newVal);
      if (clearTargets && changed) {
        for (const item of items) {
          if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid) {
            const rec = item as Record<string, unknown>;
            clearTargets.forEach(k => {
              rec[k] = '';
            });
          }
        }
      }
      editingCellRef.current = null;
      s.invalidate(true);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const col = g.columns[ht.col];
      const meta = visibleColumns.find(c => c.binding === col.binding);
      if (meta?._ctrlType !== 'FPModal' || meta._inputEditType !== 'IM') return;
      const row = g.rows[ht.row].dataItem as FuturePriceRow | undefined;
      if (!row || row.CRUD_TYPE !== 'I') return;
      if (meta._modalKey) onPopupCellDblClick?.(meta._modalKey, row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // ⭐ v4 (2026-06-21) — Scroll 시 머지 그룹 재계산 trigger.
    //   scrollPositionChanged → g.invalidate() → mergeManager 가 새 viewRange.row/row2 로
    //   머지 범위 재계산 → 새 viewport 첫 row 가 머지 그룹 top → cell content 항상 표시.
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 (Wijmo API: g.allowMerging + g.mergeManager) =====
    //   AllowMerging.All = ColumnHeaders | RowHeaders | Cells (헤더 + 데이터 cell 모두)
    g.allowMerging = AllowMerging.All;

    // 좌측 fixed cols + 동적 cols ColumnHeader 의 allowMerging 강제 (column 단위 flag)
    for (let i = 0; i < g.columns.length; i++) {
      g.columns[i].allowMerging = true;
    }

    // MergeManager subclass — 헤더 + Cell 계층 머지 (사용자 요구 2026-06-03 v5)
    class HierarchicalMergeManager extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';

        // ===== ① Data Cell — 좌측 fixed cols 계층 머지 (v4 viewport row 제한 패턴) =====
        if (panel.cellType === CellType.Cell && fixedBindings.includes(binding)) {
          const view = panel.rows;
          const rowItem = (i: number): Record<string, unknown> | undefined =>
            (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
          const cur = rowItem(r);
          if (!cur) return null;
          const minRow = panel.viewRange.row;
          const maxRow = panel.viewRange.row2;
          const measureIdx = fixedBindings.indexOf('MEASURE');
          const curIdx = fixedBindings.indexOf(binding);

          // 신규행(INSERT): 같은 INSERT_GROUP_ID 4행의 MEASURE 앞 고정컬럼만 세로 머지.
          //   (MEASURE 및 이후·가격 컬럼은 행별 분리 — measure 별 distinct.)
          //   머지셀 앵커=그룹 최상단 행 → beginningEdit 가 고정컬럼은 행 무관 편집 허용(공유값).
          if (cur.CRUD_TYPE === 'I') {
            if (measureIdx >= 0 && curIdx >= measureIdx) return null;
            const gid = cur.INSERT_GROUP_ID;
            const sameGroup = (i: number): boolean => {
              const it = rowItem(i);
              return !!it && it.CRUD_TYPE === 'I' && it.INSERT_GROUP_ID === gid;
            };
            let g1 = r,
              g2 = r;
            while (g1 > minRow && sameGroup(g1 - 1)) g1--;
            while (g2 < maxRow && sameGroup(g2 + 1)) g2++;
            if (g1 === g2) return null;
            return new CellRange(g1, c, g2, c);
          }

          const fixedIdx = fixedBindings.indexOf(binding);
          const leftBindings = fixedBindings.slice(0, fixedIdx + 1);
          const sameRow = (a: number, b: number): boolean => {
            const ra = rowItem(a);
            const rb = rowItem(b);
            if (!ra || !rb) return false;
            // 기존행이 신규행으로 확장/신규행과 병합 방지 (신규행은 위 분기에서 그룹 머지).
            if (ra.CRUD_TYPE === 'I' || rb.CRUD_TYPE === 'I') return false;
            return leftBindings.every(
              k =>
                ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
            );
          };
          let r1 = r,
            r2 = r;
          while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
          while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
          if (r1 === r2) return null;
          return new CellRange(r1, c, r2, c);
        }

        // ===== ② ColumnHeader — 정적 column verticalSpan + 동적 column horizontal merge =====
        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) {
            return new CellRange(0, c, panel.rows.length - 1, c);
          }
          const dyn = getDynKey(binding);
          if (dyn.kind === 'W') {
            if (r === 0) {
              let c1 = c,
                c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if (p.kind === 'W' && p.ym === dyn.ym) c1--;
                else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if (n.kind === 'W' && n.ym === dyn.ym) c2++;
                else break;
              }
              return new CellRange(0, c1, 0, c2);
            }
            if (r === 1) {
              let c1 = c,
                c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if (p.kind === 'W' && p.wk === dyn.wk && p.ym === dyn.ym) c1--;
                else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if (n.kind === 'W' && n.wk === dyn.wk && n.ym === dyn.ym) c2++;
                else break;
              }
              return new CellRange(1, c1, 1, c2);
            }
          }
        }
        return null;
      }
    }
    g.mergeManager = new HierarchicalMergeManager();

    g.invalidate(true);

    return () => {
      // cleanup 시점에 grid 가 unmount 됐을 수도 — null safe.
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, onPopupCellDblClick, todayCutoff]);

  // ⭐ hook #93 P-B — 다단 헤더 총높이 = 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3).
  //   별도 단일 효과(merge/format 효과와 분리 = 무간섭). height 조작은 오직 이 한 곳.
  //   원인: 공유 wrapper 가 columnGroups 재적용 시 정적 1단 컬럼에 height 48 부여 →
  //         Wijmo 규칙(헤더 row 높이 = 그 row 컬럼 height 의 max) → 정적 48 잔여 → 3행×48=144 비대.
  //   처리: 실제 rowCount(columnHeaders.rows.length) 로 per=48/rowCount → rows.defaultSize + 각 row.height.
  //         (Wijmo: Column 에는 height 속성 없음(no-op) → 헤더 row 높이는 columnHeaders.rows(Row.height)로만 제어.)
  //         정적 컬럼은 mergeManager verticalSpan(CellRange(0,c,rows-1,c)) 으로 시각적 풀높이 48 유지.
  //   wrapper rebuild 가 height 를 되돌리므로 updatedLayout 에 재적용 + guard 로 무한루프 방지.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<FuturePriceRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // (0-a) Filter sanitize — SubTitle F4(toggleColumnFilter) 가 선택셀 기준 binding 을 filterColumns 에
      //       push 하므로 사용자가 동적(W_/M_, 3단 머지) 컬럼 선택+F4 시 유입 가능 → 머지헤더 글리프 충돌.
      //       동적 binding 을 영속 제거(변경 시에만 set → 무한루프 차단). 정적 컬럼 필터만 허용.
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^[WM]_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
      // (0-b) combo dataMap 재적용 — wrapper columnGroups 재적용이 col.dataMap 을 undefined 로 덮으므로
      //     updatedLayout 마다 재부착(guard: 동일 참조면 skip → 무한루프 차단, invalidate 미호출).
      //     dataMaps 는 useTabComboQueries(피처) 결과 — divisionId 종속 cascade 포함 정확 적용.
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        // ⭐ MEASURE — UI Category Measure 메타 DataMap(RTF_SYS_RP→'RTF'). combo 와 동일하게 매 layout 재부착
        //   (wrapper columnGroups 재적용이 col.dataMap 을 undefined 로 덮으므로). 메타 없으면 해제(raw 코드).
        if (binding === 'MEASURE') {
          if (measureDataMap) {
            if (col.dataMap !== measureDataMap) col.dataMap = measureDataMap;
          } else if (col.dataMap) {
            col.dataMap = null;
          }
          continue;
        }
        const dm = dataMaps[binding];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const rowCount = headerRows.length; // 실제 rowCount (1/2/3) — dynBindings 파생 추정 금지
      const per = Math.round(48 / rowCount); // 1단 48 / 2단 24 / 3단 16
      // guard: 이미 목표면 skip (무한루프 방지)
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };

    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, dataMaps, measureDataMap, gridRef]);

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (공용 DataGrid 의 filterColumns:[''] 기본 생성 회피).
  //   다중 방어로 3단 머지 헤더/LOC backcolor 깨짐 재발 차단:
  //   ① filterChanging: 동적(W_/M_) 컬럼 필터 cancel (머지헤더 손상 원천 차단)
  //   ② filterApplied: g.invalidate(true) → updatedLayout(applyHeaderHeight: 헤더48/dataMap) + formatItem(LOC backcolor) 재적용
  //   ③ 영속 sanitize(위 applyHeaderHeight 0-a): toggleColumnFilter 가 push 한 동적 binding 제거
  //   deps 에 dynBindings/visibleColumns 포함 → grid ready(데이터 로드) 후 실행. key prop re-mount 시 grid 교체 감지 후 재생성.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<FuturePriceRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const isDynamic = (binding: string | null | undefined): boolean => /^[WM]_/.test(binding ?? '');
    const onFilterChanging = (_s: FlexGridFilter, e: CellRangeEventArgs) => {
      if (isDynamic(e.getColumn()?.binding)) e.cancel = true; // 동적 컬럼 필터 불가
    };
    const onFilterApplied = () => {
      g.invalidate(true); // 헤더높이/LOC backcolor 재적용 (updatedLayout + formatItem)
    };

    // 기존 filter 가 다른(re-mount 된) grid 에 붙어있으면 폐기 후 재생성.
    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
      // 초기 none filterable — SubTitle F4(toggleColumnFilter)로 정적 컬럼만 추가. 동적 글리프 방지.
      //   공용 DataGrid 와 동일하게 [''] 사용(빈배열=전체 필터러블 wijmo 모호성 회피).
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterChanging.addHandler(onFilterChanging);
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f?.filterChanging.removeHandler(onFilterChanging);
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef]);

  // ⭐ 조회조건 열기/닫기(extraConditions expand/collapse) 등으로 컨테이너 높이가 바뀌면
  //   계속 마운트된 Wijmo 그리드가 host 를 재측정하지 않아 하단 여백이 남는 사고(2026-06-30).
  //   gridContainer 크기 변경을 ResizeObserver 로 감지 → invalidate(true) 로 레이아웃 재계산해 빈틈 제거.
  const gridBoxRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const el = gridBoxRef.current;
    if (!el || typeof ResizeObserver === 'undefined') return;
    const ro = new ResizeObserver(() => {
      const g = (gridRef as { current: FlexGridType<FuturePriceRow> | null } | null)?.current;
      try {
        g?.invalidate(true);
      } catch {
        /* unmount race */
      }
    });
    ro.observe(el);
    return () => ro.disconnect();
  }, [gridRef]);

  return (
    <div className={styles.gridContainer} ref={gridBoxRef}>
      <DataGrid
        // ⭐ key prop — staticColumns 의 sCls/lCls 메타 변경 시 wrapper re-mount 강제.
        key={mainStaticColumns.map(c => `${c.colNm}|${c.sClsLblNm ?? ''}|${c.lClsLblNm ?? ''}`).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        // ⚠️ gridFilterRef 는 공용 DataGrid 에 전달하지 않음 — 피처가 FlexGridFilter 직접 소유(위 effect)해
        //   filterColumns/이벤트 완전 제어(동적 머지컬럼 제외 + 필터후 재적용). DataGrid 의 filterColumns:[''] 기본 회피.
        // ⭐ F7 Save(편집행 'U') — EditTracker 로 변경 셀 추적 + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
        editTrackerRef={editTrackerRef as never}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        // ⭐ 데이터 셀 머지 — wrapper 가 allowMerging prop(default ColumnHeaders)을 매 렌더 재적용해
        //   effect 의 g.allowMerging=All 을 되돌림 → 셀 머지 OFF. prop 으로 All 전달해 일관 적용.
        allowMerging={AllowMerging.All}
        // ⭐ 헤더 높이 — wrapper prop 미사용. 위 단일 useEffect(hook #93 P-B)가 전담
        //   (정적 48 잔여까지 정규화 필요 → prop 의 defaultSize 단독으로는 불가, height 조작 일원화).
      />
    </div>
  );
};
