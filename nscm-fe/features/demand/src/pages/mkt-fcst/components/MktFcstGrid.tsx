import { Aggregate, toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellRangeEventArgs,
  CellType,
  type Column,
  type DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { rebindFilterColumns } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  AS_SITE_MEASURE,
  BUCKET_TYPE,
  DIVISION,
  INSERT_DEFAULT_MEASURE,
  MAIN_COLUMNS,
  MEASURE_MODEL_CLEAR_COLS,
  MEASURE_MODEL_KEEP,
  MSG,
  PR_MENU_LABELS,
} from '../mkt-fcst.constants';
import type { MktFcstRow, SpreadTitleRow } from '../mkt-fcst.types';
import styles from '../MktFcst.module.scss';
import type { BucketInfo, CurrentWeekInfo, MeasureMeta } from '../useMktFcstStore';
import { useMktFcstStore } from '../useMktFcstStore';
import { logComboEdit, logComboSetup } from '../utils/mkt-fcst.comboDebug'; // 임시 디버그 (확인 후 삭제)
import {
  buildEditCutoff,
  dynKindOf,
  evalDynCell,
  isPastDynColumn,
  thisWeekMondayYmd,
} from '../utils/mkt-fcst.editLock';
import {
  applyCascadeClear,
  asComboRows,
  buildComboSig,
  buildDataMap,
  buildEditComboFilter,
  buildEditDataMap,
  buildGridComboFilter,
  buildWsSupportComboFilters,
  type CascadeRule,
  type EditComboConfig,
  filterComboRowsByRow,
  filterFcstTypeRows,
  filterMeasureEditRows,
  GRID_CASCADE_CLEAR,
  GRID_CASCADE_FILTERS,
  GRID_EDIT_COMBO,
  ROW_PARAM_EDIT_COMBO,
  rowParamComboKey,
  rowSalesSite,
  SALES_SITE_BINDINGS,
  shouldSwapEditCombo,
} from '../utils/mkt-fcst.gridCombos';
import { getDynKey, HierarchicalMergeManager } from '../utils/mkt-fcst.merge';
import {
  buildPrContextRequest,
  type PrContextAction,
  type PrContextResult,
  toCellStr,
} from '../utils/mkt-fcst.prContext';
import { dispatchRecalc, type RecalcAccessor } from '../utils/mkt-fcst.recalc';
import { parseSspSyncMap, type SspSyncState } from '../utils/mkt-fcst.sspSync';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위. 표시 규칙/드릴다운 판정용.
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// 음수 값 글자색 (demand-manager / sales-monitoring 과 동일 톤)
const NEGATIVE_COLOR = '#c0392b';

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// 수량 셀 = 동적 기간 컬럼(M_/W_/D_). 좌측 정적 컬럼은 정수 규칙 대상이 아니다.
const isQtyBinding = (binding: string): boolean => /^[MWD]_/.test(binding);

// 수량 정수화 — 소수점 이하 버림(1.5 -> 1). 반올림이 아닌 이유: AS-IS 주/월 분배가
//   정수 몫+나머지 가산이라 반올림하면 합이 어긋난다.
const truncQty = (v: unknown): unknown => {
  if (v == null || v === '') return v;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? Math.trunc(n) : v;
};

/**
 * 음수면 빨간 글자, 아니면 원복 (demand-manager paintNegative 동일 규약).
 *
 * 필수: 음수가 아닐 때 반드시 지운다 — Wijmo 는 셀 DOM 을 재사용하므로 칠하기만 하면
 * 스크롤 뒤 엉뚱한 셀에 색이 남는다.
 * 필수: important 로 넣는다 — 편집/잠금 셀 클래스가 color 를 !important 로 잡아
 * 일반 인라인 색은 밀린다.
 */
const paintNegative = (cell: HTMLElement, value: number): void => {
  if (value < 0) cell.style.setProperty('color', NEGATIVE_COLOR, 'important');
  else cell.style.removeProperty('color');
};

// ⚠️ 임시 로컬 디버그용 (mkt-fcst.comboDebug 와 함께 삭제). cascade 규칙 → 사람이 읽는 한 줄.
const describeCascade = (cascade: CascadeRule[], row: Record<string, unknown>): string =>
  cascade
    .map(
      x =>
        `행.${x.rowKey}='${toCellStr(row[x.rowKey])}' → 콤보.${x.comboKey}` +
        (x.strict ? '(완전일치)' : '')
    )
    .join('  /  ');

interface Props {
  rows: MktFcstRow[];
  gridRef: MutableRefObject<FlexGridType<MktFcstRow> | undefined>;
  // F4 Filter — 인스턴스는 공용 DataGrid 소유. 정적/동적(M_/W_/D_) 컬럼 모두 필터 대상 + 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적 + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker<MktFcstRow> | undefined>;
  // 행 단위 편집 콤보(ROW_PARAM_EDIT_COMBO) 선조회 호출구 — 그리드 밖에서 행 값이 바뀔 때 부모가 부른다.
  //   필요한 이유: 선조회는 cellEditEnded 에만 걸려 있는데 Project Code 는 FPModal 팝업 셀이라
  //   셀 편집을 타지 않는다. 팝업으로 Project 를 고르면 MktFcstEditMeasure 파라미터 조합이
  //   바뀌는데 캐시가 안 데워져, 다음 Measure 편집 진입이 스왑에 실패하고 조회 콤보가 그대로 뜬다
  //   (전체 Measure 목록이 보이는 증상). 응답이 도착한 뒤 다시 열면 정상이라 간헐적으로 보인다.
  //   호출부는 MktFcst.tsx ProjectByDivisionModal.setSelectedValue — applyCascadeClear 옆.
  prefetchRowParamComboRef?: MutableRefObject<((row: Record<string, unknown>) => void) | undefined>;
  onPopupCellDblClick?: (modalKey: string, row: MktFcstRow) => void;
  // ⭐ Phase 2e — contextMenu PR (Request/View PR + History). 검증 통과 결과를 MktFcst.tsx 로 전달.
  onPrContext?: (action: PrContextAction, result: PrContextResult) => void;
  // ⭐ Phase 2e — SSP↔MKT 비교 popup (Div40 & MKT_FCST_RP & 동기화색 셀 CellDblClick).
  onSspCompare?: (row: MktFcstRow, ymd: string) => void;
  divisionId?: string;
  bucketType?: BUCKET_TYPE;
  // ⭐ Sum 체크박스 — M_/W_ 합계 컬럼 표시 토글 (AS-IS chkSum L4723). 조회 없이 즉시 반영.
  sumYn?: boolean;
  // ⭐ admin SYS0004 UI Category Setup 동적 메타 (전체 속성 반영)
  staticColumns?: RawFlexGridColumnConfig[];
  staticMeasures?: MeasureMeta[];
  // ⭐ DMF0003_GET_SPREAD_TITLE 결과 — 동적 PIVOT 기간 컬럼(라벨/정렬/구조)의 1차 소스.
  spreadTitle?: SpreadTitleRow[];
  // ⭐ Phase 2b — main query O_RC2(8주 bucket)·O_RC3(현재 주차). 과거/Div40 8주 cutoff 산출 입력.
  bucketInfo?: BucketInfo | null;
  currentWeekInfo?: CurrentWeekInfo | null;
  // ⭐ division 편집허용(메타 구동, MktFcst.tsx isEditableDivision). false = 편집제약 division →
  //   전 동적 셀 잠금(편집불가). Insert/Delete/Save 버튼은 부모(hotkeyConfig)에서 함께 미표시.
  editable?: boolean;
}

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
}

export const MktFcstGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  prefetchRowParamComboRef,
  onPopupCellDblClick,
  onPrContext,
  onSspCompare,
  divisionId,
  bucketType = BUCKET_TYPE.MONTHLY,
  sumYn = false,
  staticColumns,
  staticMeasures,
  spreadTitle,
  bucketInfo,
  currentWeekInfo,
  editable = true,
}: Props) => {
  const { t } = useTranslation();
  const bucketPrefix =
    bucketType === BUCKET_TYPE.MONTHLY ? 'M' : bucketType === BUCKET_TYPE.DAILY ? 'D' : 'W';
  void staticMeasures; // measure 는 MktFcst.tsx 의 handleInsert 에서 사용
  const division = divisionId ?? '';

  // ⭐ Phase 2c — 재계산(일↔주↔월) 재진입 차단 (AS-IS CanModelChange, .cs L2885).
  //   cellEditEnded 가 다른 셀을 set → setCellData 가 cellEditEnded 를 재유발할 수 있어 ref 가드로 차단.
  const canModelChangeRef = useRef(true);

  // ⭐ Phase 2e — contextMenu/paste 핸들러용 stable refs (handler closure 가 최신 callback/state 참조).
  const setAlert = useMessageStore.getState().setAlert;
  const onPrContextRef = useRef(onPrContext);
  onPrContextRef.current = onPrContext;
  const onSspCompareRef = useRef(onSspCompare);
  onSspCompareRef.current = onSspCompare;
  // ⭐ 부모(MktFcst)가 인라인 화살표로 넘기는 콜백 — 렌더마다 새 함수라 dep 에 넣으면
  //   검색조건 한 글자만 바뀌어도 아래 대형 핸들러 effect 가 통째로 재등록된다(= 깜빡임).
  //   ref 미러로 최신 참조만 전달하고 dep 에서는 제외한다 (onPrContext/onSspCompare 와 동일 패턴).
  const onPopupCellDblClickRef = useRef(onPopupCellDblClick);
  onPopupCellDblClickRef.current = onPopupCellDblClick;
  // ⭐ 현재 주/월 binding — formatItem(대형 effect deps 미포함) 이 최신값 참조하도록 ref 미러.
  //   AS-IS chkColor=false 경로 (평문 .cs L5654~5687): 현재 W_/M_ 컬럼 헤더 초록 Bold 강조.
  // bPasteContinue (AS-IS spdMain_EditChange L5411) — paste 연계 플래그.
  const pasteContinueRef = useRef(false);

  // ⭐ P2-① 현재기간 binding 집합 — 헤더 초록 Bold(전 버킷) + 데이터셀 왼쪽 초록 rail(최하위 표시 버킷 한정,
  //   formatItem shouldRailCurrentPeriod 에서 추가 필터) 공통 1차 판정.
  //   당월 M_(THIS_YYYYMM) / 당주 W_(THIS_YYYYMMWW) 는 O_RC3, 당일 D_ 는 클라이언트 오늘 날짜 파생
  //   (O_RC3 에 daily 필드 부재 → Daily bucket 현재일 강조 보강). 조회 응답(currentWeekInfo) 갱신 시 재산출.
  const currentPeriodBindings = useMemo<Set<string>>(() => {
    const s = new Set<string>();
    const m = (currentWeekInfo?.THIS_YYYYMM ?? '').trim();
    const w = (currentWeekInfo?.THIS_YYYYMMWW ?? '').trim();
    if (m) s.add(m);
    if (w) s.add(w);
    const now = new Date();
    const ymd = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(
      now.getDate()
    ).padStart(2, '0')}`;
    s.add(`D_${ymd}`);
    return s;
  }, [currentWeekInfo]);
  const currentPeriodBindingsRef = useRef(currentPeriodBindings);
  currentPeriodBindingsRef.current = currentPeriodBindings;

  // ⭐ admin staticColumns 우선, 없으면 MAIN_COLUMNS hardcode fallback (BE 실패 시 화면 작동 보장)
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
    return staticColumns.map(col => {
      const fb = MAIN_COLUMNS.find(m => m.key === col.colNm);
      // ⭐ admin 메타의 공란(' ')은 미지정으로 간주해 fallback 으로 — '' ?? x 는 '' 라서 trim 가드 필수
      //   (예: DIVISION_ID 의 CELL_OBJECT=' ' 가 FPComboBox fallback 을 가리던 문제).
      const nb = (v: string | undefined | null): string | undefined => v?.trim() || undefined;
      return {
        binding: col.colNm,
        header: col.colLblNm || fb?.header || col.colNm,
        width: col.colWth ?? fb?.width ?? 100,
        align: col.horzAlgnCd ?? fb?.align ?? 'C',
        visible: col.visible !== false,
        fixed: col.fixed === true,
        scale: col.scale,
        _ctrlType: (nb(col.cellCtrlObjTpCd) ?? fb?._ctrlType) as MergedColumnMeta['_ctrlType'],
        _inputEditType: (nb(col.inputTpCd) ??
          fb?._inputEditType) as MergedColumnMeta['_inputEditType'],
        // ⭐ #2 — DMF0003 corp ATTRIBUTE1/2 에는 division 토큰('81,82')이 들어있어 modalKey/comboKey 가 아님.
        //   따라서 하드코딩 fallback(MAIN_COLUMNS)을 우선해 ITEM_ID 등 popup/combo 식별자를 보존
        //   (corp attribute1 이 'ITEM' modalKey 를 division 토큰으로 덮어 Model popup 깨지던 사고 차단).
        _modalKey: fb?._modalKey ?? col.attribute1,
        // ⭐ 콤보 SQL_ID = admin CELL_COMBO_DATA_TYPE(cellCboDataTp) 1순위 (hook column-lookup 표준 —
        //   FcstType/CustomsHandbook 등 admin 등록명 즉시 반영), 없으면 하드코딩 fallback.
        _comboKey: nb(col.cellCboDataTp) ?? fb?._comboKey,
      } as MergedColumnMeta;
    });
  }, [staticColumns]);

  // visible=true + division 필터 (hook #92)
  const visibleColumns = useMemo(() => mergedColumns.filter(c => c.visible), [mergedColumns]);

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   mergedColumns 는 폭/표시만 옮기고 색은 안 담으므로 formatItem 이 staticColumns 에서 직접 읽는다
  //   (forecast-price/DMF0020 선례 동일). ref 로 최신 맵 전달 — 핸들러 재등록 불필요.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    (staticColumns ?? []).forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.binding), [visibleColumns]);

  // ===== Grid 내 combo column dropdown — UI Category 메타(cellCboDataTp) 기반 (DMF0020 표준) =====
  //   콤보 정의·파라미터 규약은 utils/mkt-fcst.gridCombos.ts 단일 출처. 여기서는 소비만 한다.
  const comboColumns = useMemo(
    () => visibleColumns.filter(c => c._ctrlType === 'FPComboBox' && !!c._comboKey),
    [visibleColumns]
  );
  // Sales site 컬럼은 @divisionId 도 실린다 (SiteByEndCustomer 의 40 전용 조인) — 판정은 gridCombos.
  const gridComboFilters = comboColumns.map((c: MergedColumnMeta) =>
    buildGridComboFilter(c.binding, c._comboKey as string, division)
  );
  const comboResults = useTabComboQueries({ filters: gridComboFilters });
  // W/S 권한 여부 — Div82 FCST Type 제약(A-06)의 예외 축. 상세 용도는 아래 W/S 분기 자료 블록 주석.
  //   콤보 필터가 소비하므로 그 블록보다 먼저 선언한다(ref 미러는 그대로 아래에 둔다).
  const wsPlannerYn = useMktFcstStore(s => s.wsPlannerYn);
  // dataMap 재생성 안정화 — comboId + row count 시그니처가 바뀔 때만 rebuild (DMF0020 동일).
  //   ⚠️ division 포함 — @divisionId 로 갈리는 콤보가 행 수만 같으면 이전 division 결과로 굳는다.
  //   wsPlannerYn 도 포함 — 조회(MktFcstWsPlannerYn)가 늦게 도착하면 false 로 만든 dataMap 이
  //   그대로 굳어 W/S 계정에 WS·WSF 가 끝내 안 보인다.
  const comboSig = `${division}|${wsPlannerYn ? 'Y' : 'N'}|${buildComboSig(
    comboColumns.map(c => c._comboKey),
    comboResults
  )}`;
  // A-06 [통합테스트 1st No.54] Div82 는 FCST Type 후보에서 WS·WSF 제외(2026-08-17 요구로 W/S
  //   권한 계정은 예외) — 조회 표시 dataMap 과 편집 후보(applyEditCombo)가 같은 filterFcstTypeRows 를
  //   거친다. 한쪽만 걸면 편집에서는 못 고르는데 조회 표시에는 남아 CODE→NAME 변환만 살아 있는
  //   불일치가 된다. 대상 아니면 원본 참조 그대로.
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      m[c.binding] = buildDataMap(
        filterFcstTypeRows(asComboRows(comboResults[i]), c.binding, division, wsPlannerYn)
      );
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // ⭐ cascade (hook #59 §5-G / DMF0020 이식) — 편집 진입 시 행 컨텍스트 dataMap 스왑용
  //   콤보 원본 rows + 전체 dataMap 원복용 ref 미러 (핸들러 useEffect deps 밖 참조).
  const comboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  const dataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    const rowsByBinding: Record<string, Record<string, unknown>[]> = {};
    comboColumns.forEach((c, i) => {
      // A-06 — dataMaps 와 같은 필터를 거친다(cascade 스왑·디버그 로그가 dataMap 과 어긋나지 않게).
      rowsByBinding[c.binding] = filterFcstTypeRows(
        asComboRows(comboResults[i]),
        c.binding,
        division,
        wsPlannerYn
      );
    });
    comboRowsRef.current = rowsByBinding;
    dataMapsRef.current = dataMaps;
    logComboSetup(
      '조회 표시',
      division,
      comboColumns.map((c: MergedColumnMeta, i: number) => ({
        binding: c.binding,
        comboId: c._comboKey ?? '',
        param: JSON.stringify(gridComboFilters[i]),
        rows: rowsByBinding[c.binding],
      }))
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, dataMaps]);

  // ⭐ 편집 전용 콤보 (GRID_EDIT_COMBO) — 편집 진입 시 dataMap 스왑, cellEditEnded 시 조회 dataMap 으로 원복.
  const editComboEntries = useMemo(() => Object.entries(GRID_EDIT_COMBO), []);
  // TEAM_ID(TeambyDivisionAuth) 처럼 로그인 사용자 권한으로 목록이 갈리는 콤보용 세션 값.
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  // 콤보 API(admin/combo)는 이 필터 객체를 그대로 POST 한다 → @divisionId 등 파라미터가 실려 나간다.
  const editComboFilters = editComboEntries.map(([, cfg]: [string, EditComboConfig]) =>
    buildEditComboFilter(cfg, division, sesUserId)
  );
  const editComboResults = useTabComboQueries({ filters: editComboFilters });
  // ⚠️ division 을 시그니처에 포함한다 — 편집 콤보는 @divisionId 로 갈리는데 division 이 바뀌어도
  //   행 수가 같으면(예 81→82 모두 7종) 시그니처가 동일해 dataMap 이 이전 division 값으로 굳는다.
  const editComboSig = `${division}|${sesUserId}|${buildComboSig(
    editComboEntries.map(([binding]) => binding),
    editComboResults
  )}`;
  const editDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    editComboEntries.forEach(([binding], i) => {
      m[binding] = buildDataMap(asComboRows(editComboResults[i]));
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);
  const editDataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    editDataMapsRef.current = editDataMaps;
  }, [editDataMaps]);
  // 편집 콤보 원본 rows (MEASURE W/S 분기 필터용 — dataMap 재구성 원천).
  const editComboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  /** 임시 디버그 — 편집 콤보에 실제로 보낸 파라미터(JSON) 미러. */
  const editComboParamRef = useRef<Record<string, string>>({});
  useEffect(() => {
    const byBinding: Record<string, Record<string, unknown>[]> = {};
    const paramByBinding: Record<string, string> = {};
    editComboEntries.forEach(([binding]: [string, EditComboConfig], i: number) => {
      byBinding[binding] = asComboRows(editComboResults[i]);
      paramByBinding[binding] = JSON.stringify(editComboFilters[i]);
    });
    editComboRowsRef.current = byBinding;
    editComboParamRef.current = paramByBinding;
    logComboSetup(
      '편집 전용',
      division,
      editComboEntries.map(([binding, cfg]: [string, EditComboConfig]) => ({
        binding,
        comboId: cfg.comboId,
        param: paramByBinding[binding],
        rows: byBinding[binding],
      }))
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);

  // ⭐ 행 단위 파라미터 편집 콤보 (MEASURE → MktFcstEditMeasure / INCOTERMS → AS_INCOTERMS) —
  //   정의는 gridCombos.ROW_PARAM_EDIT_COMBO. 그 행의 Div·Sales site 가 파라미터로 실려 화면 1회
  //   조회(useTabComboQueries)에 담을 수 없다 → 값이 정해지는 cellEditEnded 에서 apiClient.getCombo
  //   를 직접 호출해 "파라미터 조합" 을 키로 캐시한다 (DMF0082 SalesBucket 동형).
  //   beginningEdit 은 동기라 그 자리에서 await 할 수 없다 = 선조회가 유일한 방법.
  const rowParamComboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  const rowParamComboPendingRef = useRef<Set<string>>(new Set());
  // 조회는 끝났는데 0건인 파라미터 조합. rows 캐시([])만으로는 "아직 안 받음" 과 구분이
  //   안 돼 따로 표시한다 — applyRowParamCombo 가 재요청 대신 조회 콤보 유지로 넘어가는 근거다.
  const rowParamComboEmptyRef = useRef<Set<string>>(new Set());
  // 조회가 실패한 파라미터 조합. rows 캐시에는 안 넣으므로 다음 편집 진입에서 재시도된다.
  const rowParamComboFailedRef = useRef<Set<string>>(new Set());
  const fetchRowParamCombo = useCallback(
    (binding: string, row: Record<string, unknown>) => {
      const cfg = ROW_PARAM_EDIT_COMBO[binding];
      if (!cfg || (cfg.ready && !cfg.ready(row))) return;
      const param = cfg.buildParam(row, division, sesUserId);
      const key = rowParamComboKey(binding, param);
      // 같은 파라미터 조합은 1회만 — 캐시 hit / 진행 중이면 재요청하지 않는다.
      //   필수: 값의 진리값이 아니라 키 존재 여부로 본다. 판정 기준은 "받아 둔 적이 있는가"이고
      //   0건 응답도 받아 둔 것이다 — [] 가 truthy 라 우연히 동작하는 형태를 남기지 않는다.
      if (key in rowParamComboRowsRef.current || rowParamComboPendingRef.current.has(key)) return;
      rowParamComboPendingRef.current.add(key);
      rowParamComboFailedRef.current.delete(key);
      void apiClient
        .getCombo(param)
        .then(res => {
          const comboRows = asComboRows(res);
          rowParamComboRowsRef.current[key] = comboRows;
          if (comboRows.length === 0) {
            // 0건 = 스왑할 후보가 없다 → 조회 콤보가 편집에 그대로 쓰여 제약이 풀린 것처럼
            //   보인다. 콤보 등록/파라미터를 봐야 하는 상태라 조용히 넘기지 않는다
            //   (GRID_EDIT_COMBO 0건 경로와 같은 취지 — 그쪽은 편집 진입 때 logComboEdit 로 남긴다).
            rowParamComboEmptyRef.current.add(key);
            console.warn('[DMF0003] row-param combo returned 0 rows', { binding, param });
          } else {
            rowParamComboEmptyRef.current.delete(key);
          }
        })
        .catch((error: unknown) => {
          // 실패 시 조회 콤보 dataMap 이 그대로 남는다 — 조용히 삼키지 않는다.
          //   rows 캐시에는 넣지 않는다: 다음 편집 진입에서 다시 시도해 일시 오류를 복구한다.
          rowParamComboFailedRef.current.add(key);
          console.error('[DMF0003] row-param combo lookup failed', { binding, param }, error);
        })
        .finally(() => {
          rowParamComboPendingRef.current.delete(key);
        });
    },
    [division, sesUserId]
  );

  // ⭐ 워밍업 — 신규행 기본 Div = 검색 division (MktFcst.handleInsert) 이므로 그 조합만 미리 받아
  //   둔다. 행을 추가하자마자 Measure 를 눌러도 첫 진입부터 편집 후보가 뜨게 하는 용도.
  //   ready 게이트가 있는 콤보(INCOTERMS — Sales site 필요)는 여기서 자동으로 걸러진다.
  useEffect(() => {
    if (!division) return;
    Object.keys(ROW_PARAM_EDIT_COMBO).forEach(b =>
      fetchRowParamCombo(b, { DIVISION_ID: division })
    );
  }, [division, fetchRowParamCombo]);

  // 그리드 밖(FPModal 팝업)에서 행 값이 바뀐 경우의 선조회 호출구 — Props.prefetchRowParamComboRef
  //   주석 참조. 위 워밍업과 같은 일을 임의의 행 스냅샷으로 한다.
  //   ready 게이트가 있는 콤보(INCOTERMS — Sales site 필요)는 fetchRowParamCombo 가 알아서 거른다.
  useEffect(() => {
    if (!prefetchRowParamComboRef) return;
    prefetchRowParamComboRef.current = (row: Record<string, unknown>) => {
      Object.keys(ROW_PARAM_EDIT_COMBO).forEach(b => fetchRowParamCombo(b, row));
    };
    return () => {
      prefetchRowParamComboRef.current = undefined;
    };
  }, [prefetchRowParamComboRef, fetchRowParamCombo]);

  // [E20260402-001736] W/S 분기 자료 — wsPlannerYn(store) + W/S FcstType 4종(FcstTypeWs =
  //   SALES_TYPE_CODE2). 용도: MEASURE 편집 후보 필터(사이트 축 우선 / W/S 축은 사이트 미선택 행) /
  //   AS_FROM_SITE 조건부 편집(#128~130 — isAsFromSiteEditable 의 FCST_TYPE 축 담당.
  //   W/S Planner 축은 2026-08-14 요구로 제거 — wsPlannerYn 은 Measure 후보 필터,
  //   AS 사이트 Measure 값 셋팅(AS_SITE_MEASURE), Div82 FCST Type 예외(A-06)에서 쓴다).
  //   AS_FROM_SITE CMBO(= AS(비축)향 사이트 목록, @param1=division)는 행의 Sales site 가 비축향인지
  //   판정하는 유일한 근거다 — AS-IS dtAsSalesSite.Select("Name = …") 1:1. NAME 집합에 포함 = 비축향,
  //   미포함 = 고객향. 조건부 잠금(CE-02) / 값 클리어(CE-04) 가 이 판정을 쓴다.
  //   주의: Measure 를 사이트로 1종 고정하던 규칙(.cs 1-c)은 2026-08-10 요구로 걷어냈다가 2026-08-14
  //     요구로 AS 사이트 쪽 절반만 되살렸고, 2026-08-17 규칙표로 그 절반의 W/S 한정 조건을 풀었으며,
  //     2026-08-18 규칙표 4열로 일반 사이트 쪽 절반(고객향 -> MKT_FCST_RP 1종)까지 되살렸다 — 이제
  //     사이트가 정해진 행은 그룹과 무관하게 measure 가 1종으로 고정된다.
  //     값 셋팅(cellEditEnded)과 편집 후보 목록(filterMeasureEditRows) 양쪽에 같은 조건으로 건다.
  //     두 곳의 조건은 항상 일치해야 한다.
  //     비W/S 사용자 후보에서 AS_In_Req 를 빼던 블랙리스트(.cs 1-a/1-b)도 2026-08-14 제거 -> 2026-08-17
  //     규칙표로 재적용했다(사이트 미선택 행 한정). 규칙은 filterMeasureEditRows 주석 참조.
  //     따라서 wsPlannerRef 가 Measure 후보를 가르는 자리는 "사이트 미선택 행" 하나뿐이다.
  //     저장 검증(MSG00476)은 MktFcst.tsx 가 자체 조회분으로 한다.
  //   wsPlannerYn 선언은 위 콤보 dataMap 블록으로 올렸다(Div82 FCST Type 예외가 먼저 쓴다).
  const wsPlannerRef = useRef(false);
  wsPlannerRef.current = wsPlannerYn;
  const [wsFcstTypeRows, asSiteRows] = useTabComboQueries({
    filters: buildWsSupportComboFilters(division),
  });
  const wsFcstTypeSetRef = useRef<Set<string>>(new Set());
  useEffect(() => {
    wsFcstTypeSetRef.current = new Set(
      (wsFcstTypeRows ?? [])
        .map(r => toCellStr((r as { CODE?: unknown }).CODE).trim())
        .filter(Boolean)
    );
  }, [wsFcstTypeRows]);

  // 비축향 사이트명 집합 — CODE 가 아니라 NAME 으로 담는다(AS-IS 가 Name 컬럼으로 매칭하고,
  //   행의 SCM_SITE_ID 값도 사이트명 체계라 CODE 로 담으면 전건 미매칭 = 판정 무력화).
  //   적재 후 invalidate 필수: 콤보가 늦게 도착하면 AS_FROM_SITE 셀 색(편집 가능 표시)이 로드 전
  //   판정으로 굳는다 — 다시 그려야 잠금 상태와 색이 맞는다.
  const asSiteNamesRef = useRef<Set<string>>(new Set());
  useEffect(() => {
    asSiteNamesRef.current = new Set(
      (asSiteRows ?? []).map((r: { NAME?: unknown }) => toCellStr(r.NAME).trim()).filter(Boolean)
    );
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    g?.invalidate(true);
  }, [asSiteRows, gridRef]);

  /**
   * 행이 비축향(AS)인지 — 행의 Sales site 가 AS_FROM_SITE 목록에 있으면 true.
   * 사이트 미입력(신규행 첫 상태)은 아직 판정 불가라 false(= 고객향 취급, AS-IS 동일).
   */
  const isAsBoundRow = useCallback((row: unknown): boolean => {
    const site = rowSalesSite(row as Record<string, unknown> | undefined);
    return !!site && asSiteNamesRef.current.has(site);
  }, []);

  /**
   * AS_FROM_SITE(AS 출발 사이트) 편집 허용 판정 — 3축 전부 통과해야 true.
   *   (1) Insert 행 (FCST Type 을 셋팅하는 행)
   *   (2) FCST_TYPE 이 W/S 4종(FcstTypeWs)
   *   (3) 행이 고객향 + Sales site 입력됨
   * (3) 은 A-07 재적용분(2026-08-13) — CE-02(.cs L3480~3483) + 통합테스트 1st No.56-①.
   * 2026-08-14 요구로 W/S Planner 권한 축을 제거했다 — AS-IS(#128~130)는 W/S 단독 조건이었으나
   *   컬럼 자체는 DM Planner·DM ADMIN 에게도 노출되어(GET_SPREAD_TITLE p_type='LOAD') "보이는데
   *   잠긴" 상태가 되므로, 권한 축 없이 행 조건만으로 판정한다.
   *   필수: 저장 검증(MSG00476 — MktFcst.tsx)에서도 같은 축을 뺐다. 두 게이트의 축은 항상 일치해야 한다.
   * 판정을 formatItem(셀 색) 과 beginningEdit(입력 차단) 이 공유한다 — 색/입력 불일치 차단.
   */
  const isAsFromSiteEditable = useCallback(
    (row: unknown, isInsert: boolean): boolean => {
      if (!isInsert) return false;
      const rec = row as Record<string, unknown> | undefined;
      const ft = toCellStr(rec?.FCST_TYPE).trim();
      if (!wsFcstTypeSetRef.current.has(ft)) return false;
      // No.56-① Sales site 미입력 = 비축향 여부를 판정할 근거가 없다 → 사이트를 먼저 고르게 잠근다.
      //   저장 검증(MSG00476)도 사이트가 정해진 고객향 행에만 AS_FROM_SITE 를 요구한다.
      if (!rowSalesSite(rec)) return false;
      // CE-02 비축향(AS 사이트) 행은 그 자체가 AS 출발지라 따로 고를 대상이 아니다 → 항상 잠금.
      if (isAsBoundRow(rec)) return false;
      return true;
    },
    [isAsBoundRow]
  );

  // 편집 시작 셀의 (binding, oldVal) — cellEditEnded 에서 실제 값 변경 여부 판정(불필요 clear 방지).
  const editingCellRef = useRef<{ binding: string; oldVal: unknown } | null>(null);

  // ⭐ 동적 기간 컬럼 메타 — GET_SPREAD_TITLE 결과를 1차 소스로 사용 (DMF0020 패턴).
  //   ⭐ Sum 체크박스(AS-IS chkSum L4723/4772/4782) — 활성 bucket 외에 상위 합계 prefix 도 함께 렌더:
  //     Daily=D+W+M / Weekly=W+M / Monthly=M. 합계 컬럼(kind≠활성)은 표시만 sumYn 으로 토글
  //     (메인 SP 는 bucket 무관 D_/W_/M_ 데이터 키를 전부 반환 — 019 SP L295~328 실측).
  //   SP 결과 부재 시(BE 미적재 등) → SP 데이터 row 의 키 union 으로 fallback (라벨=binding 파생).
  type DynColMeta = {
    binding: string;
    kind: 'M' | 'W' | 'D';
    large: string;
    small: string;
    leaf: string;
    sort: number;
    /** SP 수신 순서. 정렬 tie-break + 헤더 2단 그룹 배치 기준 (mainDynamicColumns 참조). */
    seq: number;
  };
  // ⭐ 헤더 드릴다운(2026-07-03, AS-IS spdMain_CellDoubleClick 헤더 분기 L3416~3455) —
  //   AS-IS 는 전 버킷 컬럼이 스프레드에 상존하고 SetSpreadColumn 이 표시만 제어. 1:1 로
  //   D/W/M 전부 렌더하고 표시는 규칙(활성=표시/상위합계=sumYn/하위=숨김)+드릴 오버라이드로 제어.
  const allowedKinds = useMemo<ReadonlyArray<'M' | 'W' | 'D'>>(() => ['D', 'W', 'M'], []);
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
      /^M_\d{6}$/.test(b) ? 'M' : /^W_\d+$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;
    // (1) GET_SPREAD_TITLE 우선
    const titleRows = (spreadTitle ?? []).filter(r => {
      const k = kindOf(r.COLUMN_NAME ?? '');
      return !!k && allowedKinds.includes(k);
    });
    if (titleRows.length > 0) {
      return (
        titleRows
          .map<DynColMeta>((r, i) => ({
            binding: r.COLUMN_NAME,
            kind: kindOf(r.COLUMN_NAME)!,
            large: r.LARGE_CLASS_LABEL_NAME ?? '',
            small: r.SMALL_CLASS_LABEL_NAME ?? '',
            leaf: r.COLUMN_LABEL_NAME ?? '',
            sort: Number(r.SORT_ORDER_NO ?? 0),
            seq: i,
          }))
          // ⭐ 동률 tie-break 은 반드시 SP 수신 순서(seq) — binding 문자열로 깨면 안 된다.
          //   월 경계 분할 주는 A/B 두 행이 같은 주(BASIS_START_DATE 동일)라 SORT_ORDER_NO 가 완전히
          //   같다: 'W53+'(W_20261253) / '+W53'(W_20270153) 둘 다 2026122821. 같은 주의 앞/뒤 반쪽이라
          //   반드시 인접해야 하므로 SP 가 내려준 순서를 그대로 승계한다.
          .sort((a, b) => a.sort - b.sort || a.seq - b.seq)
      );
    }
    // (2) fallback — SP 데이터 row 키 union (라벨은 binding 파생)
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        const kind = kindOf(k);
        if (!kind || !allowedKinds.includes(kind)) continue;
        if (kind === 'W' && /^W_\d{8}$/.test(k)) {
          const d = k.slice(2);
          const dt = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
          // 주 시작일 = 월요일(getUTCDay===1) 또는 월 1일(월경계 분할 주차)
          if (dt.getUTCDay() !== 1 && dt.getUTCDate() !== 1) continue;
        }
        set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>((b, i) => {
      const dyn = getDynKey(b);
      return {
        binding: b,
        kind: kindOf(b)!,
        large: dyn.ym,
        small: dyn.sub,
        leaf: dyn.leaf,
        sort: 0,
        seq: i,
      };
    });
  }, [spreadTitle, rows, allowedKinds]);

  // binding 순서 목록 (머지 매니저 / 필터 sanitize / recalc 보행이 참조 — M/W/D interleave = AS-IS 순서)
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // ⭐ B2 — 표시 규칙 rank 분리 (M=0 상위 … D=2 하위):
  //   활성 bucket kind = 항상 표시 / 상위(rank<bucket) = 합계 → sumYn 토글 /
  //   하위(rank>bucket) = 기본 숨김 → 헤더 더블클릭 드릴로만 표시.

  const weekBindings = useMemo<string[]>(
    () => dynColMetas.filter(d => d.kind === 'W').map(d => d.binding),
    [dynColMetas]
  );

  // ⭐ 과거/Div40 8주 편집 cutoff (보강스펙 §1/§5) — O_RC2(8주 월)·O_RC3(현재 주) + 이번주 월요일.
  //   formatItem(배경색) + beginningEdit(편집 cancel) 두 곳에서 동일 기준 공유 (DMF0020 패턴).
  const editCutoff = useMemo(
    () => buildEditCutoff(bucketInfo ?? null, currentWeekInfo ?? null, new Date(), weekBindings),
    [bucketInfo, currentWeekInfo, weekBindings]
  );

  const summaryBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] < DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  const drillBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] > DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  // 드릴 오버라이드(binding → visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // ⭐ DataGrid wrapper 의무. visibleColumns → staticColumns prop.
  //   컬럼 고정(freeze) — 정적 컬럼(좌측: Div~MEASURE)은 전부 고정, 우측 동적 날짜 컬럼만 가로 스크롤
  //   (2026-07-24 사용자 지시 — 스크롤 시 measure 등 정보 컬럼은 고정, 날짜 PIVOT 컬럼만 이동).
  //   wrapper 가 frozenColumns = findLastIndex(_fixed)+1 계산 → 마지막 정적 컬럼만 fixed 표시하면
  //   그 앞 정적 컬럼 전부(0..last)가 함께 고정. 동적 컬럼은 dynamicColumns 로 뒤에 붙어 스크롤 유지.
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map((c, idx) => ({
        colNm: c.binding,
        colLblNm: c.header,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        // ⭐ 공용 DataGrid 자동 콤보 배선 (DataGrid.tsx cellCtrlObjTpCd===COMBO && cellCboDataTp →
        //   useTabComboQueries + dataMap 자동). 화면 자체 dataMaps(cascade 스왑·원복)와 동일 combo
        //   queryKey 라 react-query 캐시로 중복 호출 없음. (_ctrlType 문자열 값 = CELL_CONTROL_TYPE 값)
        cellCtrlObjTpCd: c._ctrlType as unknown as RawFlexGridColumnConfig['cellCtrlObjTpCd'],
        cellCboDataTp: c._comboKey,
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

  // ⭐ 동적 PIVOT 컬럼 — 3단 nested (대상년월 → 주차/SUM → leaf). 라벨 = GET_SPREAD_TITLE 제공값.
  //   kind 기반 (Sum 합계컬럼 동시 렌더 — AS-IS 월합계→주합계→일 interleave, SP SORT _01/_21/_31 동일):
  //     kind M: 2단='SUM'/3단='SUM' (세로머지 — 사용자 지정 2026-07-02. Monthly 활성/합계 공통)
  //     kind W: 2단=주차(small, 없으면 binding 파생)/3단='SUM' (Weekly 활성 + Daily 의 주합계 공통 —
  //             Daily 주합계는 같은 주 D_ leaf 들과 동일 주차 sub 에 합류, sub 내 첫 컬럼)
  //     kind D: 2단=주차/3단=일자(m.leaf)
  // ⭐ sumYn 최신값 ref — 컬럼그룹 rebuild(조회/bucket 변경 시) 시점의 초기 visible 계산용.
  //   (sumYn 토글 자체는 아래 imperative effect 가 rebuild 없이 flip — 스크롤/컬럼폭 보존 유지.)
  const sumYnRef = useRef(sumYn);
  sumYnRef.current = sumYn;

  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    /** order = 이 sub 에 처음 들어온 leaf 의 수신 인덱스 (= 2단 그룹 배치 순서). */
    type SubGroup = { order: number; cols: LeafCol[] };
    type SubBucket = Map<string, SubGroup>;
    type LargeBucket = { label: string; subs: SubBucket; order: number };
    const largeMap = new Map<string, LargeBucket>();
    const kindRank = { M: 0, W: 1, D: 2 } as const; // sub 내 leaf 순서 — 합계(W) 먼저, 일자(D) 다음
    dynColMetas.forEach((m, idx) => {
      // 1단 그룹 키 = binding 의 yyyymm (라벨은 large). 라벨만으로 묶으면 동명 월 충돌 → binding 기준.
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      // 2단 키 — kind 기반. W 는 SP small('Wxx') 우선, 없으면 binding 파생
      //   (W_yyyymm+ISO_WEEK → 'W'+slice(8) / W_yyyymmdd(8자리 fallback) → getDynKey isoWeek).
      const subKey =
        m.kind === 'M'
          ? 'SUM'
          : m.kind === 'W'
            ? (
                m.small ||
                (/^W_\d{7,9}$/.test(m.binding) && !/^W_\d{8}$/.test(m.binding)
                  ? `W${m.binding.slice(8)}`
                  : getDynKey(m.binding).sub)
              ).trim() || 'SUM'
            : (m.small || getDynKey(m.binding).sub).trim() || 'SUM';
      // ⭐ 2단(주차) 배치 순서 = 이 그룹의 첫 leaf 수신 인덱스. 1단(largeMap.order)과 동일한 규칙으로
      //   "데이터 넘어온 순서" 를 그대로 승계한다. 라벨의 주차 숫자로 정렬하면 연말 분할주가 어긋난다:
      //   SP 는 월 경계 주를 A/B 로 쪼개 'W53+'(12월 앞부분) / '+W53'(1월 뒷부분) 라벨을 주는데,
      //   숫자만 뽑으면 둘 다 53 이라 1월 그룹에서 W01~W04(1~4) 뒤로 밀리고, 같은 주의 앞/뒤 반쪽인
      //   W53+ 와 +W53 이 서로 떨어진다 (2026-12 → 2027-01 실측).
      let sub = bucket.subs.get(subKey);
      if (!sub) {
        sub = { order: idx, cols: [] };
        bucket.subs.set(subKey, sub);
      }
      sub.cols.push({
        binding: m.binding,
        // 3단(leaf) 라벨 — M/W 합계는 'SUM'(사용자 지정 2026-06-29/07-02) / D=일자(m.leaf).
        header: m.kind === 'D' ? m.leaf || m.small || 'SUM' : 'SUM',
        align: 'right',
        format: '#,##0.###',
        aggregate: Aggregate.Sum,
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        // ⭐ 초기 visible = 표시 규칙을 config 에 직접 반영 (2026-07-20 fix — 최초 조회 시 SUM 노출 사고):
        //   wrapper 가 columnGroups 재적용 시 Column 을 config 값으로 재생성하므로, imperative 숨김만으로는
        //   최초 렌더에서 상위 합계(SUM) 컬럼이 visible:true 로 나타났음. 규칙(활성=표시/상위 합계=sumYn/
        //   하위=숨김)을 빌드 시점에 명시(visible 명시 자체는 Excel 대응 룰 유지 — 값만 규칙 반영).
        //   sumYn 토글·드릴다운은 기존 imperative effect 가 계속 담당.
        visible:
          DYN_RANK[m.kind] < DYN_RANK[bucketPrefix]
            ? sumYnRef.current
            : DYN_RANK[m.kind] === DYN_RANK[bucketPrefix],
        height: 48,
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        _display: true,
      });
    });
    // sub 정렬: 'SUM'(월합계) 최우선 → 나머지는 수신 순서(order) 그대로.
    //   SUM 핀이 필요한 건 fallback 경로 때문 — binding 사전순(D_ < M_ < W_)이라 월합계가 일자 뒤로 간다.
    //   SP 경로에선 M_ 행의 SORT_ORDER_NO(월 시작일)가 이미 그 월의 최선두라 핀이 있어도 순서가 안 바뀐다.
    // leaf 정렬: 합계(M/W) 먼저 → 일자 binding 순.
    const sumFirst = (k: string): number => (k === 'SUM' ? 0 : 1);
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: 48,
        columns: [...bucket.subs.entries()]
          .sort(([ka, a], [kb, b]) => sumFirst(ka) - sumFirst(kb) || a.order - b.order)
          .map(([subLabel, sub]) => ({
            header: subLabel,
            align: 'center',
            height: 48,
            columns: sub.cols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas, bucketPrefix]);

  // ⭐ grid 핸들러 + mergeManager useEffect 분리 등록.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // 홀짝 zebra (#95) — 클래스 없는 셀 White 기본 + .wj-alt
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    // 현재기간 rail(초록 세로선) 대상 = 당주 W_ 컬럼 하나뿐 (사용자 지정 2026-07-29).
    //   당월 M_ SUM·당일 D_ 는 제외 — 헤더 초록 Bold 는 기존대로 M_/W_/D_ 전부 유지.
    const shouldRailCurrentPeriod = (binding: string): boolean =>
      dynKindOf(binding) === 'W' && currentPeriodBindingsRef.current.has(binding);

    const formatHandler = (s: FlexGridType<MktFcstRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.row === 0) {
          e.cell.textContent = e.col === 0 ? 'No.' : '';
          e.cell.style.textAlign = 'center';
          if (e.panel.rows.length > 1) {
            e.cell.style.height = `${e.panel.height}px`;
            e.cell.style.lineHeight = `${e.panel.height}px`;
            e.cell.style.zIndex = '1';
          }
        } else {
          // 하위 행 — 확장된 상단 셀이 덮으므로 라벨만 제거.
          e.cell.textContent = '';
        }
        return;
      }
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        const hb = col.binding ?? '';
        // ⭐ AS-IS chkColor=false 경로 1:1 (평문 .cs L5654~5687, 실행 화면 기본 상태) —
        //   현재 월(M_당월)/현재 주(W_당주) 컬럼 헤더를 초록 Bold 강조. O_RC3(THIS_YYYYMM/THIS_YYYYMMWW)
        //   binding 정확 일치로 판정 (AS-IS 는 tag yyyymm+iso_week 비교 — 동일 산출값).
        const isCurrentPeriod = !!hb && currentPeriodBindingsRef.current.has(hb);
        // 주말 일자 헤더 색 — 토요일 파랑 / 일요일 빨강 (D_ leaf 헤더 한정, forecast-price 동일 패턴).
        //   D_ 는 3단 leaf(일자)에서만 자기 라벨이 보인다(상위 row 는 월/주 머지에 덮임) → leaf row 한정.
        //   당월/당주 초록(W_/M_ 대상)과 컬럼이 겹치지 않으므로 초록이 아닐 때만 주말색을 판정한다.
        let weekendColor = '';
        if (!isCurrentPeriod && /^D_\d{8}$/.test(hb) && e.row === e.panel.rows.length - 1) {
          const ymd = hb.slice(2); // YYYYMMDD
          const dow = dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`).day();
          if (dow === 6)
            weekendColor = '#1565c0'; // 토 파랑
          else if (dow === 0) weekendColor = '#d32f2f'; // 일 빨강
        }
        e.cell.style.color = isCurrentPeriod ? '#1e8449' : weekendColor;
        e.cell.style.fontWeight = isCurrentPeriod ? '700' : '';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;

      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: MktFcstRow })?.dataItem;
      const meta = visibleColumns.find(c => c.binding === col.binding);
      const isDyn = !meta && /^[MWD]_/.test(col.binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';

      // ⭐ 동적 col 배경색 (#95 + 보강스펙 §1) — bucket×measure×division×past matrix.
      //   편집가능 = Yellow(wj-cell-editable) / 과거(이번주월요일·이번달·Div40 8주 이전) = Gray(wj-cell-non-editable)
      //   비활성 bucket(Daily 의 W_/M_ 등) = White(클래스 없음). 전체회색·inline 금지.
      //   (SSP 동기화 PaleGreen/PapayaWhip 색은 Phase 2c — 본 단계 미적용.)
      if (isDyn) {
        toggleClass(e.cell, 'mkt-cell-current-period', shouldRailCurrentPeriod(col.binding));
        // 음수 수량 = 빨간 글자. 아래 분기들이 각자 return 하므로 진입 직후 한 번만 칠한다.
        const dynVal = (rowItem as Record<string, unknown> | undefined)?.[col.binding];
        paintNegative(e.cell, toNumber(dynVal));

        const state = evalDynCell({
          binding: col.binding,
          row: rowItem,
          divisionId: division,
          bucketType,
          cutoff: editCutoff,
          editable,
        });
        // ⭐ Phase 2c — SSP 동기화 색 (보강스펙 §1, AS-IS L1414~1441). Div40·82 + D_ 셀 + ATTR1 토큰.
        //   PaleGreen(A=전체동기) / PapayaWhip(P=부분동기). #95 공존 규칙: 동기화 셀은 편집 Yellow 보다 동기화색 우선
        //   (AS-IS 도 SetBGColor 로 덮어씀, L1435). 따라서 동기화 셀이면 editable/non-editable 클래스 제거.
        let syncState: SspSyncState = null;
        if (dynKindOf(col.binding) === 'D') {
          const syncMap = parseSspSyncMap(rowItem, division);
          syncState = syncMap[col.binding] ?? null;
        }
        if (syncState) {
          toggleClass(e.cell, 'wj-cell-editable', false);
          toggleClass(e.cell, 'wj-cell-non-editable', false);
          toggleClass(e.cell, 'mkt-cell-ssp-full', syncState === 'A');
          toggleClass(e.cell, 'mkt-cell-ssp-partial', syncState === 'P');
          return;
        }
        toggleClass(e.cell, 'mkt-cell-ssp-full', false);
        toggleClass(e.cell, 'mkt-cell-ssp-partial', false);
        toggleClass(e.cell, 'wj-cell-editable', state.editable);
        // 실적 구간 = Gray — DMF0020(forecast-price) 파리티 (사용자 지시 2026-08-27).
        //   판정은 컬럼(기간) 단위 isPastDynColumn 이다. evalDynCell.isPast 를 쓰면 안 된다:
        //   그 함수는 division 편집제약·행 EDIT_FLAG!='Y'·비활성 bucket 에서 날짜를 보기 전에
        //   isPast=false 로 되돌아오므로, 읽기전용 measure 행(RTF/SCM FCST 등)만 흰색으로 남아
        //   실적 컬럼이 얼룩진다. DMF0020 은 컬럼 하나로 판정해 실적 구간이 고르게 회색이다.
        //   편집 차단은 그대로 evalDynCell(state.editable) 담당 — 색과 잠금의 역할만 나눈 것이다.
        toggleClass(
          e.cell,
          'wj-cell-non-editable',
          isPastDynColumn({ binding: col.binding, divisionId: division, cutoff: editCutoff })
        );
        return;
      }

      // ⭐ 종속 메저 단계별 indent (2026-07-13 사용자 요구 — AS-IS UP_FX_GetCommonDataList 'Measure'
      //   parity: 1단계 ' └ ' / 2단계(EDI 하위 세부) '    └ ' 공백4). 표시명은 admin 콤보
      //   dataMap('Measure' CMBO_SQL)에서 오며, 선행 공백이 HTML 에서 collapse 되면 전부 동일
      //   단계로 보이는 사고 → MEASURE 셀만 white-space 보존 (다른 컬럼 영향 0).
      if (col.binding === 'MEASURE') e.cell.style.whiteSpace = 'pre';

      // ⭐ 표시명은 언제나 조회 콤보 기준 (사용자 요구 2026-08-10 — "조회된 콤보에는 Measure,
      //   추가된 행에만 MktFcstEditMeasure"). 편집 후보 스왑(beginningEdit)은 col.dataMap 을 컬럼
      //   통째로 바꾸므로, 신규행 Measure 를 편집하는 동안 조회된 기존 행까지 편집 후보(2건) 기준으로
      //   렌더돼 이름이 사라진다. → 지금 편집 중인 셀이 아니면 조회 dataMap 이 아는 이름으로 다시 적는다.
      //   ⚠️ 조회 dataMap 이 모르는 코드는 그대로 둔다 — 편집 후보에만 있는 코드를 고른 신규행의
      //     표시를 원시 코드로 되돌리지 않기 위해서다.
      if (GRID_EDIT_COMBO[col.binding] || ROW_PARAM_EDIT_COMBO[col.binding]) {
        const er = s.editRange;
        const editingThisCell = !!er && er.row === e.row && er.col === e.col;
        const raw = (rowItem as Record<string, unknown> | undefined)?.[col.binding];
        if (!editingThisCell && raw != null && raw !== '') {
          const displayName: unknown = dataMapsRef.current[col.binding]?.getDisplayValue(raw);
          if (typeof displayName === 'string' && displayName !== raw) {
            e.cell.textContent = displayName;
          }
        }
      }

      // Fixed col cell coloring — Insert 행의 IM/IO = Yellow, 그 외 White
      if (meta) {
        // AS_FROM_SITE 는 FCST_TYPE + 사이트 종속 (2.1.4 / A-07) — beginningEdit 와 동일 판정 함수.
        const editableForInsert =
          col.binding === 'AS_FROM_SITE'
            ? isAsFromSiteEditable(rowItem, isInsert)
            : isInsert &&
              (meta._inputEditType === 'IM' ||
                meta._inputEditType === 'IO' ||
                meta._ctrlType === 'FPModal');
        toggleClass(e.cell, 'wj-cell-editable', editableForInsert);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        // ⭐ FPModal 팝업셀 아이콘 = DMF0020 과 동일(전용 span .popup-icon + MUI OpenInNew SVG mask —
        //   사용자 요구 2026-07-03). cell position override 금지(머지셀 파손) — span 의 absolute 는
        //   셀 기존 positioning 을 anchor 로 사용.
        toggleClass(e.cell, 'wj-cell-popup', false); // wrapper 자동 토글 클래스 무력화 (전용 span 사용)
        if (editableForInsert && meta._ctrlType === 'FPModal') {
          const cellEl = e.cell;
          cellEl.style.cursor = 'pointer';
          cellEl.title = `${meta.header} popup (double-click)`;
          cellEl.style.paddingRight = '20px';
          if (!cellEl.querySelector('.popup-icon')) {
            const icon = document.createElement('span');
            icon.className = `popup-icon ${styles.popupIcon}`;
            cellEl.appendChild(icon);
          }
        } else {
          e.cell.querySelector('.popup-icon')?.remove();
        }

        // ⭐ 개인화 색 (ColumnLayoutModal) — 우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color.
        //   inline !important 라 클래스보다 세므로 편집 가능 Insert 셀에는 배경을 칠하지 않는다.
        //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 컬럼 색이 남는다.
        const personalColor = colorMetaRef.current.get(col.binding);
        if (!editableForInsert && personalColor?.cell) {
          e.cell.style.setProperty('background-color', personalColor.cell, 'important');
        } else {
          e.cell.style.removeProperty('background-color');
        }
        // 글자색 우선순위: 음수 빨강 > 개인화 Text Color. 문자 컬럼은 toNumber 가 0 을 돌려주므로
        // 자연히 음수 판정에서 빠진다.
        const staticVal = (rowItem as Record<string, unknown> | undefined)?.[col.binding];
        if (toNumber(staticVal) < 0) {
          paintNegative(e.cell, -1);
        } else if (personalColor?.text) {
          e.cell.style.setProperty('color', personalColor.text, 'important');
        } else {
          e.cell.style.removeProperty('color');
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // ⭐ 편집 후보 스왑 공통부 — 화면 1회 조회 콤보(GRID_EDIT_COMBO)와 행 단위 파라미터 콤보
    //   (ROW_PARAM_EDIT_COMBO)가 꼬리를 공유한다: MEASURE W/S 분기 → 행 cascade → dataMap 교체.
    //   ⚠️ 어느 경로로 후보를 받아 왔든(화면 1회 / 행 단위 조회) 이 필터들은 똑같이 걸려야 한다.
    const swapEditCandidates = (opts: {
      col: Column;
      binding: string;
      rowRec: Record<string, unknown>;
      comboId: string;
      /** 그 후보를 받을 때 실제로 보낸 파라미터(JSON) — 디버그 로그용. */
      param?: string;
      dependsOn: string;
      src: Record<string, unknown>[];
      /** 필터로 좁혀진 게 없을 때 재사용할 memo dataMap. 없으면 매번 새로 만든다. */
      memo?: DataMap | null;
    }) => {
      const { col, binding, rowRec, comboId, param, dependsOn, src, memo } = opts;
      // [E20260402-001736] MEASURE 편집 후보 필터 — 규칙은 gridCombos.filterMeasureEditRows.
      //   사이트 축(asBoundRow·siteSelected)은 여기서 판정해 넘긴다: AS 사이트 목록(asSiteNamesRef)은
      //   화면 상태라 gridCombos 가 알 수 없다. AS 사이트 행은 그룹 무관 AS_In_Req 1종, 일반 사이트
      //   행은 그룹 무관 MKT_FCST_RP 1종, 사이트 미선택 행만 비W/S 면 AS_In_Req 제거 / W/S 면 응답
      //   그대로다(2026-08-17~18 규칙표).
      //   후보가 0건이면 필터 전 목록으로 되돌린다(선택지 전무 방지 — 기존 동작).
      const measured =
        binding === 'MEASURE'
          ? filterMeasureEditRows({
              src,
              wsPlanner: wsPlannerRef.current,
              asBoundRow: isAsBoundRow(rowRec),
              siteSelected: !!rowSalesSite(rowRec),
            })
          : src;
      const base = measured.length > 0 ? measured : src;
      // A-06 [통합테스트 1st No.54] Div82 FCST Type 후보에서 WS·WSF 제외(W/S 권한 계정은 예외 —
      //   2026-08-17 요구) — 조회 표시 dataMap 과 동일 함수(filterFcstTypeRows). MEASURE 와 달리
      //   0건 fallback 을 두지 않는다: 82 에서 WS·WSF 는 업무상 선택 불가이므로 되살리면 제약 자체가
      //   무의미해진다(82 도 남는 후보가 여러 종 있다).
      const restricted = filterFcstTypeRows(base, binding, division, wsPlannerRef.current);
      // ⭐ 편집 콤보에도 행 cascade 적용 (사용자 요구 2026-08-07 — END_CUSTOMER 는 신규행에서
      //   그 행의 DIVISION_ID·TEAM_ID 로 좁혀져야 한다). 규칙이 없는 컬럼은 그대로 통과.
      const cascade = GRID_CASCADE_FILTERS[binding];
      const candidates = cascade ? filterComboRowsByRow(restricted, rowRec, cascade) : restricted;
      logComboEdit({
        binding,
        comboId,
        param,
        dependsOn:
          dependsOn +
          (binding === 'MEASURE'
            ? '  /  후보필터(AS행=AS_In_Req / 일반사이트=MKT_FCST_RP / 미선택+비W-S=AS_In_Req 제거)' +
              `: W-S Planner=${wsPlannerRef.current} / AS 사이트행=${isAsBoundRow(rowRec)}` +
              ` / 사이트입력=${!!rowSalesSite(rowRec)}`
            : '') +
          (cascade ? '  /  ' + describeCascade(cascade, rowRec) : ''),
        before: src,
        after: candidates,
        keys: cascade?.map(x => x.comboKey),
      });
      // cascade 로 좁힌 결과는 0건이어도 그대로 (조회 cascade 규약과 동일).
      //   좁혀진 게 없으면 memo 된 편집 dataMap 재사용.
      col.dataMap = candidates.length === src.length && memo ? memo : buildEditDataMap(candidates);
    };

    // 행 단위 파라미터 편집 콤보 스왑 (ROW_PARAM_EDIT_COMBO) — 셀을 누른 지금 행의 현재 값으로
    //   파라미터를 다시 만들어 캐시에서 후보를 꺼낸다 = 사용자가 말한 "Cell 클릭 시 재조회".
    //   Div 를 바꿨으면 파라미터가 달라져 캐시 키도 달라진다(= 실조회).
    //   캐시가 아직 없으면(값이 방금 정해졌거나 응답 전) 요청만 걸고 이번엔 조회 dataMap 을 유지한다
    //   — 편집 진입은 동기라 여기서 await 할 수 없다. 다음 진입부터 편집 후보가 뜬다.
    //   0건 응답은 받아 둔 것으로 치고 재요청하지 않는다: 그 파라미터 조합에는 편집 후보가 없다는
    //   뜻이라 조회 콤보가 그대로 쓰인다(로그로 남긴다). 조회 실패만 다음 진입에서 재시도한다.
    //   반환값: 이 컬럼을 여기서 처리했는가. false 면 호출부가 일반 편집 콤보 경로로 계속 간다.
    const applyRowParamCombo = (
      col: Column,
      binding: string,
      rowRec?: Record<string, unknown>
    ): boolean => {
      const cfg = ROW_PARAM_EDIT_COMBO[binding];
      if (!cfg || !rowRec) return false;
      // ready 미충족(INCOTERMS: 행 Sales site 공란) → 스왑 없음 = 조회 콤보 그대로.
      if (cfg.ready && !cfg.ready(rowRec)) return true;
      const param = cfg.buildParam(rowRec, division, sesUserId);
      const key = rowParamComboKey(binding, param);
      const paramText = JSON.stringify(param);
      const cached = rowParamComboRowsRef.current[key];
      if (cached && cached.length > 0) {
        swapEditCandidates({
          col,
          binding,
          rowRec,
          comboId: cfg.comboId,
          param: paramText,
          dependsOn: '행 단위 콤보 조회 (그 행 값이 콤보 파라미터)',
          src: cached,
        });
        return true;
      }
      // 여기부터는 스왑 없음 = 조회 콤보 dataMap 이 그대로 편집에 쓰인다. 세 경우를 구분한다.
      //   (1) 조회 완료 0건 — 재요청해도 결과가 같다(캐시 키가 파라미터 조합이라 응답도 고정).
      //     GRID_EDIT_COMBO 0건 경로와 같은 모양으로 남긴다. 로그가 없으면 "편집 제약이 간헐적으로
      //     풀린다" 로만 보이고 원인을 짚을 수 없다.
      if (rowParamComboEmptyRef.current.has(key)) {
        logComboEdit({
          binding,
          comboId: cfg.comboId,
          param: paramText,
          dependsOn:
            '주의: 행 단위 편집 콤보 0건 → 조회 콤보 dataMap 유지. 콤보 등록/파라미터 확인 필요',
          before: [],
          after: [],
        });
        return true;
      }
      //   (2) 직전 조회 실패 — 아래에서 재시도한다. (3) 아직 안 받음(첫 진입/응답 전) — 요청만 건다.
      if (rowParamComboFailedRef.current.has(key)) {
        logComboEdit({
          binding,
          comboId: cfg.comboId,
          param: paramText,
          dependsOn: '주의: 직전 행 단위 편집 콤보 조회 실패 → 조회 콤보 dataMap 유지, 재시도',
          before: [],
          after: [],
        });
      }
      fetchRowParamCombo(binding, rowRec);
      return true;
    };

    // 편집 시작 — Insert 행만 fixed cols 편집 허용 (FPModal popup cell 직접 입력 차단)
    const beginningEditHandler = (
      s: FlexGridType<MktFcstRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as MktFcstRow | undefined;
      const isInsert = row?.CRUD_TYPE === 'I';
      const meta = visibleColumns.find(c => c.binding === binding);

      // [E20260402-001736] + 2.1.4 — AS_FROM_SITE 조건부 편집 (#90~95/#128~130 격차 해소).
      //   Insert 행 + W/S Planner + FCST_TYPE 이 W/S 4종 + 고객향(Sales site 입력·비축향 아님) 일 때만
      //   허용 — 4축 판정 본체는 isAsFromSiteEditable, formatItem 셀 색과 공유해 색/입력 불일치 차단.
      if (binding === 'AS_FROM_SITE') {
        if (!isAsFromSiteEditable(row, isInsert)) {
          e.cancel = true;
          return;
        }
        // 후보는 그 행의 Div 로 갈린다 (AS_FROM_SITE SQL 의 SEGMENT3 = @param1). 아래 일반 경로는
        //   meta 의 _inputEditType/_ctrlType 가드를 먼저 타므로(SP 자동추가 컬럼이라 메타가 다를 수
        //   있다) 여기서 직접 스왑한다. 원복은 cellEditEnded 의 ROW_PARAM_EDIT_COMBO 분기가 한다.
        editingCellRef.current = {
          binding,
          oldVal: (row as Record<string, unknown> | undefined)?.[binding],
        };
        applyRowParamCombo(col, binding, row as unknown as Record<string, unknown> | undefined);
        return;
      }

      if (meta) {
        if (!isInsert) {
          e.cancel = true;
          return;
        }
        if (meta._ctrlType === 'FPModal' || meta._inputEditType === 'S') {
          e.cancel = true;
          return;
        }
        // ⭐ cascade dataMap 스왑 (hook #59 §5-G / DMF0020 이식) — FPComboBox 편집 진입 시
        //   해당 행의 상위 셀 값으로 콤보 후보 필터 → 컬럼 dataMap 교체. 관대 통과(행 값·콤보 키
        //   공란/'ALL' = 통과). 스왑은 cellEditEnded 진입 시 전체 dataMap 으로 원복.
        editingCellRef.current = {
          binding,
          oldVal: row ? (row as Record<string, unknown>)[binding] : undefined,
        };
        // ⭐ 편집 전용 콤보 스왑 (MEASURE=편집가능 measure / TEAM_ID·END_CUSTOMER·SCM_SITE_ID=권한
        //   반영 / FCST_TYPE=조회 FCST_TYPE_NOT_ETC → 편집 FCST_TYPE). 조회 표시는 전체 dataMap,
        //   편집 후보만 교체 (AS-IS 편집/조회 이원화). cellEditEnded 에서 원복.
        const editCfg = GRID_EDIT_COMBO[binding];
        //   whenRowFilled(SCM_SITE_ID): 그 행 End Customer 가 공란이면 스왑 생략 = 조회 콤보
        //   'SiteByEndCustomer' 유지 → 아래 cascade 블록에서 DIVISION_ID 로만 좁힌다.
        const editRowRec = row as unknown as Record<string, unknown> | undefined;
        // 행 단위 파라미터 편집 콤보 (MEASURE→MktFcstEditMeasure / INCOTERMS→AS_INCOTERMS /
        //   AS_FROM_SITE→AS_FROM_SITE): "그 행의 값"이 콤보 파라미터라 화면 1회 조회에 담기지 않는다.
        //   본체는 applyRowParamCombo — AS_FROM_SITE 분기도 같은 함수를 쓴다.
        if (applyRowParamCombo(col, binding, editRowRec)) return;
        if (editCfg && shouldSwapEditCombo(editCfg, wsPlannerRef.current, editRowRec)) {
          const editRows = editComboRowsRef.current[binding] ?? [];
          // ⚠️ 편집 콤보 응답이 0건이면 스왑할 게 없다 → 조회 dataMap 유지(= insert 행에서도 조회
          //   콤보가 그대로 보인다). 파라미터 누락/미등록 콤보를 조용히 넘기지 않도록 로그를 남긴다.
          if (editRows.length === 0) {
            logComboEdit({
              binding,
              comboId: editCfg.comboId,
              param: editComboParamRef.current[binding],
              dependsOn:
                `⚠️ 편집 콤보 0건 (division='${division}') → 조회 콤보(${meta._comboKey ?? '-'})` +
                ' dataMap 유지. 콤보 등록/파라미터 확인 필요',
              before: [],
              after: [],
            });
          } else if (editRowRec) {
            swapEditCandidates({
              col,
              binding,
              rowRec: editRowRec,
              comboId: editCfg.comboId,
              param: editComboParamRef.current[binding],
              dependsOn: `division='${division}' (화면 1회 조회 편집 콤보)`,
              src: editRows,
              memo: editDataMapsRef.current[binding],
            });
            return;
          }
        }
        const cascade = GRID_CASCADE_FILTERS[binding];
        if (meta._ctrlType === 'FPComboBox' && cascade && row) {
          const src = comboRowsRef.current[binding] ?? [];
          const rowRec = row as unknown as Record<string, unknown>;
          const filtered = filterComboRowsByRow(src, rowRec, cascade);
          col.dataMap = buildEditDataMap(filtered);
          logComboEdit({
            binding,
            comboId: meta._comboKey ?? '-',
            dependsOn: describeCascade(cascade, rowRec),
            before: src,
            after: filtered,
            keys: cascade.map(x => x.comboKey),
          });
        }
        return;
      }
      // ⭐ 동적 col — bucket×measure×division×past matrix (보강스펙 §1). formatItem 과 동일 cutoff.
      //   FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper setEditableColumns('S' read-only) 보다 우선.
      if (/^[MWD]_/.test(binding)) {
        const state = evalDynCell({
          binding,
          row,
          divisionId: division,
          bucketType,
          cutoff: editCutoff,
          editable,
        });
        e.cancel = !state.editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // ⭐ 동적 셀 재계산 실행 — RecalcAccessor 구성 → dispatchRecalc → 변경 셀 EditTracker + grid 갱신.
    //   row[binding] 직접 read/write (Wijmo collectionView dataItem). 변경 셀은 storeChange + 비-insert 행 'M' 마킹.
    const runDynRecalc = (
      s: FlexGridType<MktFcstRow>,
      rowIdx: number,
      editedBinding: string,
      row: MktFcstRow
    ) => {
      const tracker = editTrackerRef?.current;
      const rec = row as Record<string, unknown>;
      const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
      const syncMap = parseSspSyncMap(row, division);
      const monday = thisWeekMondayYmd();
      const bucketRaw = typeof rec.BUCKET === 'string' && rec.BUCKET ? rec.BUCKET : '0000010';

      // 변경 전 원본 (EditTracker storeChange 의 originalValue 용). dispatch 가 set 하는 셀만 추적.
      const toNum = (v: unknown): number | null => {
        if (v == null || v === '') return null;
        const n =
          typeof v === 'number' ? v : Number(String(v as string | number).replace(/,/g, ''));
        return Number.isFinite(n) ? n : null;
      };

      const acc: RecalcAccessor = {
        dynBindings,
        get: b => toNum(rec[b]),
        set: (b, value) => {
          const prev = rec[b];
          rec[b] = value == null ? null : value;
          // EditTracker — 변경 셀 추적(비-insert 행 자동 'M'). originalValue=prev, newValue=신규.
          if (tracker && row.CRUD_TYPE !== 'I') {
            tracker.storeChange(row as never, b, (prev ?? null) as never, (value ?? null) as never);
          }
        },
        bucket: bucketRaw,
        sspSyncOf: (b: string): SspSyncState => syncMap[b] ?? null,
        thisMondayYmd: monday,
      };

      canModelChangeRef.current = false;
      try {
        const outcome = dispatchRecalc({
          acc,
          editedBinding,
          bucketType,
          divisionId: division,
          measure,
        });
        if (outcome.kind === 'forceWeekly') {
          // 동기화 합 강제상향 — W_ 셀을 wkSumSync 로 셋 후 재진입 (AS-IS L3451~3455).
          acc.set(outcome.binding, outcome.value);
          dispatchRecalc({
            acc,
            editedBinding: outcome.binding,
            bucketType,
            divisionId: division,
            measure,
          });
        }
        // ⭐ belowActual(MSG00225) — 월합계가 실적(과거 주합)보다 작으면 분배 미적용 + 즉시 안내
        //   (AS-IS spdMain_Changed L3842~3846 GMessageBox). 편집 시점에 표시(저장까지 지연 금지).
        if (outcome.kind === 'belowActual') {
          void setAlert({
            type: 'alert',
            content: t(MSG.BELOW_ACTUAL, '_수량은 0 이상의 값이어야 합니다 (실적 미만).'),
          });
        }
      } finally {
        canModelChangeRef.current = true;
      }
      void rowIdx;
      s.invalidate(true);
    };

    // 정적 셀 값이 확정된 뒤의 공통 후처리 — 직접 편집(cellEditEnded)과 붙여넣기(pastedCell)가
    //   같은 규칙을 타도록 함수로 뺐다(2026-08-19 사용자 요구: 셀 복사에도 하위값 초기화 적용).
    //   prev = 그 셀의 직전 값. 값이 실제로 바뀐 경우만 도는 동작(하위 셀 clear, 수량 클리어 등)의
    //     판정 근거라 붙여넣기 경로도 pastingCell 에서 직전 값을 잡아 넘겨야 한다.
    //   keepCols = 같은 붙여넣기에서 값이 함께 들어온 컬럼. 방금 붙여넣은 하위 값을 도로 지우면
    //     안 되므로 clear 대상에서 뺀다.
    const applyStaticCascade = (
      s: FlexGridType<MktFcstRow>,
      rowIdx: number,
      binding: string,
      prev: { binding: string; oldVal: unknown } | null,
      keepCols: readonly string[] = []
    ): void => {
      const meta = visibleColumns.find(c => c.binding === binding);
      if (!meta) return;
      // 붙여넣기 경로는 flush 가 한 박자 늦게 돌아 그 사이 행이 사라졌을 수 있다.
      const staticRow = s.rows[rowIdx]?.dataItem as MktFcstRow | undefined;
      if (!staticRow || staticRow.CRUD_TYPE !== 'I') return;
      const gid = staticRow.INSERT_GROUP_ID;
      if (!gid) return;
      const newVal = (staticRow as Record<string, unknown>)[binding];
      const view = s.collectionView;
      for (const item of view.items) {
        if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid && item !== staticRow) {
          (item as Record<string, unknown>)[binding] = newVal;
        }
      }

      // ⭐ cascade 계단식 리셋 (hook #59 §5-G / DMF0020 이식) — 상위 콤보 값이 실제로 바뀐 경우만
      //   같은 INSERT_GROUP 형제 행 포함 하위 셀 clear (END_CUSTOMER→SCM_SITE_ID 등).
      const changed = prev?.binding === binding && toCellStr(prev.oldVal) !== toCellStr(newVal);
      if (changed && GRID_CASCADE_CLEAR[binding]) {
        for (const item of view.items) {
          if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid) {
            applyCascadeClear(item as Record<string, unknown>, binding, keepCols);
          }
        }
      }
      // ⭐ 행 값 확정 → 그 값이 파라미터인 편집 콤보 후보 선조회 (Div/Sales site 변경 → MEASURE·
      //   INCOTERMS 재조회. 사용자 요구 2026-08-07·08-10). 편집 진입(beginningEdit)은 동기라 그
      //   자리에서 조회를 기다릴 수 없다 → 값이 정해지는 지금 미리 받아 둔다. 같은 파라미터 조합은
      //   캐시되어 한 번만 나간다.
      //   ⚠️ changed 게이트를 두지 않는다 — 형제 행 동기화/재선택으로 값이 그대로여도 캐시가
      //     비어 있을 수 있다(캐시 hit 이면 fetchRowParamCombo 가 즉시 return 하므로 무해).
      const editedRowRec = staticRow as unknown as Record<string, unknown>;
      Object.entries(ROW_PARAM_EDIT_COMBO).forEach(([b, cfg]) => {
        if (cfg.refreshOn.includes(binding)) fetchRowParamCombo(b, editedRowRec);
      });
      // ⭐ MEASURE 변경 시 model(품목) 컬럼 clear (AS-IS: measure 교체 시 종속 model 재선택 강제).
      //   예외 = MEASURE_MODEL_KEEP(AS_In_Req/BNPIn) 은 model 유지. 같은 INSERT_GROUP 형제 행 일괄.
      if (binding === 'MEASURE' && changed) {
        const nextMeasure = toCellStr(newVal);
        if (!MEASURE_MODEL_KEEP.includes(nextMeasure)) {
          for (const item of view.items) {
            if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid) {
              const rec = item as Record<string, unknown>;
              MEASURE_MODEL_CLEAR_COLS.forEach(k => {
                if (keepCols.includes(k)) return;
                rec[k] = '';
              });
            }
          }
        }
      }
      // Sales site 가 정해지면 Measure 를 그 사이트 전용 1종으로 셋팅 (.cs ComboSelChange 1-c /
      //   2026-08-17~18 규칙표 3·4열 — "AS Site 선택 후 AS_In_Req 만" / "비-AS Site 선택 후
      //   MKT_FCST_RP 만").
      //   그룹 조건은 없다: 규칙표 비고 "Site 변경 후 필터에는 그룹 조건 없음" 대로 W/S Planner 한정
      //   조건을 2026-08-17 에 걷어냈다 — DM Planner·DM ADMIN·그 외 그룹도 동일하게 셋팅된다.
      //   같은 조건으로 편집 후보 목록도 같은 1종만 남는다(filterMeasureEditRows) — 값만 바꾸고
      //   목록을 열어 두면 잠시 뒤 다른 measure 로 되돌릴 수 있어 두 곳의 조건은 항상 같이 움직인다.
      //   사이트를 비워 미선택으로 돌아가면 값을 건드리지 않는다 — 단 직전이 AS 사이트였고 값이
      //   AS_In_Req 로 남아 있으면 기본값으로 되돌린다. 비W/S 계정의 미선택 후보에는 AS_In_Req 가
      //   없어 그대로 두면 값과 목록이 어긋난다.
      //   주의: 이 프로그램 셋팅은 binding==='MEASURE' 가 아니라 위 Model clear 연쇄를 타지 않는다.
      //     사이트 변경 자체가 GRID_CASCADE_CLEAR(SCM_SITE_ID -> ITEM_ID 등)로 Model 계열을 이미
      //     비우므로 measure x model 조합이 어긋날 일은 없다.
      if (changed && SALES_SITE_BINDINGS.includes(binding)) {
        const nowAsBound = isAsBoundRow(staticRow);
        const siteSelected = !!rowSalesSite(staticRow);
        const wasAsBound = asSiteNamesRef.current.has(toCellStr(prev?.oldVal).trim());
        const curMeasure = toCellStr(staticRow.MEASURE).trim();
        let nextMeasure = '';
        if (nowAsBound) nextMeasure = AS_SITE_MEASURE;
        else if (siteSelected) nextMeasure = INSERT_DEFAULT_MEASURE;
        else if (wasAsBound && curMeasure === AS_SITE_MEASURE) {
          nextMeasure = INSERT_DEFAULT_MEASURE;
        }
        if (nextMeasure) {
          for (const item of view.items) {
            if (item.CRUD_TYPE !== 'I' || item.INSERT_GROUP_ID !== gid) continue;
            (item as Record<string, unknown>).MEASURE = nextMeasure;
          }
        }
      }
      // A-09 [CE-04] AS 조건 파기 시 AS_FROM_SITE 클리어 (.cs L3478~3483·3506·3587·3597) —
      //   편집 조건이 깨지면 이미 들어간 값을 비운다. isAsFromSiteEditable 은 셀을 잠그기만 하므로
      //   이 클리어가 없으면 잠긴 셀에 옛 값이 남아 그대로 저장된다(사용자가 지울 방법도 없다).
      //   판정을 isAsFromSiteEditable 로 직접 돌린다 — "잠김 = 값 없음" 불변식을 한 함수로 보장한다.
      //   트리거 컬럼 목록을 두지 않고 매 정적 편집마다 검사한다: 위 cascade clear 가 Sales Site 를
      //   비우는 경우처럼, 사용자가 만진 컬럼이 아닌 값이 바뀌어 조건이 깨지는 경로가 있다.
      //   필수: FcstTypeWs 콤보 미도착(집합 0건)이면 손대지 않는다 — 전건 오클리어 방지.
      if (wsFcstTypeSetRef.current.size > 0) {
        for (const item of view.items) {
          if (item.CRUD_TYPE !== 'I' || item.INSERT_GROUP_ID !== gid) continue;
          const rec = item as Record<string, unknown>;
          if (!toCellStr(rec.AS_FROM_SITE)) continue;
          if (!isAsFromSiteEditable(rec, true)) rec.AS_FROM_SITE = '';
        }
      }
      // A-08 [CG-05] I 행 키값 변경 시 수량 전량 클리어(.cs L5319~5379)는 2026-08-27 요구로 제거했다.
      //   증상: AS From Site 미입력 상태로 W35~W38 수량을 넣고 저장하면 MSG00476 이 AS From Site 를
      //   요구하는데, 그 값을 채우는 순간 키 변경으로 잡혀 방금 넣은 수량이 전부 날아갔다.
      //   저장 검증이 "수량 먼저 → AS From Site 나중" 순서를 강제하므로 매번 밟는 경로였다.
      //   그 대가로 키를 바꾼 행은 이전 키로 넣은 수량을 그대로 들고 저장된다 — 최종 키 기준의
      //   중복 검증(division.ts buildDuplicateKey)과 저장 검증이 남은 방어선이다.
      //   되살릴 때는 gridCombos.ROW_KEY_BINDINGS 를 키 목록으로 쓰던 형태를 참고할 것
      //   (changed 게이트 + keepCols 예외가 함께 있어야 한다).
    };

    // 편집 종료 — (A) 정적 cols = Insert 행 group 동기화 / (B) 동적 cols(D_/W_/M_) = 재계산 cascade.
    const cellEditEndedHandler = (s: FlexGridType<MktFcstRow>, e: { row: number; col: number }) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';

      // ⭐ cascade 스왑 원복 (hook #59 §5-G) — beginningEdit 의 행 컨텍스트 필터 dataMap 을 전체
      //   dataMap 으로 되돌린다 (스왑 잔존 시 필터 밖 CODE 보유 타 행의 명칭 변환이 깨짐. 취소도 커버).
      if (GRID_CASCADE_FILTERS[binding] && dataMapsRef.current[binding]) {
        col.dataMap = dataMapsRef.current[binding];
      }
      // ⭐ 편집 전용 콤보 원복 (MEASURE 등) — 편집 후보(유효분) dataMap 을 전체 표시 dataMap 으로
      //   되돌린다. 원복 누락 시 조회 표시에서 편집목록 밖 CODE 명칭 변환 손실.
      //   ROW_PARAM_EDIT_COMBO(MEASURE·INCOTERMS)도 동일 — 스왑이 남으면 파라미터가 다른 타 행의
      //   명칭 변환이 방금 편집한 행의 후보 기준으로 굳는다.
      if (
        (GRID_EDIT_COMBO[binding] || ROW_PARAM_EDIT_COMBO[binding]) &&
        dataMapsRef.current[binding]
      ) {
        col.dataMap = dataMapsRef.current[binding];
      }

      // ===== (B) 동적 셀(D_/W_/M_) 재계산 cascade (보강스펙 §2, AS-IS L3282~4175) =====
      if (dynKindOf(binding) && /^[MWD]_/.test(binding)) {
        if (!canModelChangeRef.current) return; // 재진입 차단 (AS-IS L2885)
        const row = s.rows[e.row].dataItem as MktFcstRow | undefined;
        if (!row) return;
        // 아래 재계산이 이 값을 읽어 합을 쌓으므로 한 번 더 버린다(드래그 채우기 등 에디터 미경유 경로).
        const qtyRec = row as Record<string, unknown>;
        const qtyInt = truncQty(qtyRec[binding]);
        if (qtyInt !== qtyRec[binding]) qtyRec[binding] = qtyInt;
        runDynRecalc(s, e.row, binding, row);
        return;
      }

      // ===== (A) 정적 셀 — 그룹 동기화 + cascade clear (붙여넣기와 공유하는 applyStaticCascade) =====
      applyStaticCascade(s, e.row, binding, editingCellRef.current);
      editingCellRef.current = null;
      s.invalidate(true);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // FPModal popup cell — dblClick popup (Insert 행 한정) + SSP↔MKT 비교 popup (동기화색 셀).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // ⭐ 헤더 드릴다운 (AS-IS spdMain_CellDoubleClick e.ColumnHeader L3416~3455 1:1) —
      //   M_ 헤더: 해당 월 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기.
      //   W_ 헤더: 해당 주 구간(다음 W_/M_ 전까지) D_ 토글.
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = dynKindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const col = g.getColumn(target);
          if (!col) return;
          if (hideOnly && !col.visible) return; // AS-IS: D_ 는 보이는 경우만 접기 (M_ 드릴)
          drillVisRef.current.set(target, hideOnly ? false : !col.visible);
        };
        for (let i = idx + 1; i < dynBindings.length; i++) {
          const t = dynBindings[i];
          const tk = dynKindOf(t);
          if (hk === 'M') {
            if (tk === 'M') break;
            if (tk === 'W') flip(t, false);
            else if (tk === 'D') flip(t, true);
          } else {
            if (tk === 'W' || tk === 'M') break;
            if (tk === 'D') flip(t, false);
          }
        }
        applyDynVisibilityRef.current?.();
        return;
      }
      if (ht.cellType !== CellType.Cell) return;
      const col = g.columns[ht.col];
      const binding = col.binding ?? '';

      // ⭐ Phase 2e — SSP↔MKT 비교 popup (AS-IS .cs L2628~2683).
      //   조건: Div40 & MEASURE='MKT_FCST_RP' & 동기화색(ATTR1 'A'/'P') 셀 (D_yyyymmdd 컬럼).
      if (dynKindOf(binding) === 'D' && /^D_\d{8}$/.test(binding)) {
        const row = g.rows[ht.row].dataItem as MktFcstRow | undefined;
        if (row && division === DIVISION.MOBILITY && row.MEASURE === 'MKT_FCST_RP') {
          const syncMap = parseSspSyncMap(row, division);
          if (syncMap[binding]) {
            onSspCompareRef.current?.(row, binding.slice(2));
            return;
          }
        }
      }

      // (PSI 드릴다운 제거 — 2026-07-03 사용자 결정. 평문 AS-IS DMF0003_MktFcst 의 더블클릭은
      //  SSP비교 모달(Div40)뿐. PSI 는 별개 변형 DMF0003_1_MktFcst 전용 — 패키지 보존.)

      const meta = visibleColumns.find(c => c.binding === binding);
      if (meta?._ctrlType !== 'FPModal' || meta._inputEditType !== 'IM') return;
      const row = g.rows[ht.row].dataItem as MktFcstRow | undefined;
      if (!row || row.CRUD_TYPE !== 'I') return;
      if (meta._modalKey) onPopupCellDblClickRef.current?.(meta._modalKey, row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // ⭐ Phase 2e — contextMenu PR (AS-IS contextMenuStrip1_ItemClicked, .cs L5510~5753).
    //   우클릭 → Request_PR / View_PR / Add_History / View_History 메뉴. 검증은 buildPrContextRequest
    //   (BNPIn measure + D_ 컬럼 + 과거일 제외 + Model dup + Project 동일). 통과 시 onPrContext 전달.
    let contextMenuEl: HTMLDivElement | null = null;
    let dismissOutsideRef: ((e: MouseEvent) => void) | null = null;
    const removeContextMenu = () => {
      if (contextMenuEl && contextMenuEl.parentNode)
        contextMenuEl.parentNode.removeChild(contextMenuEl);
      contextMenuEl = null;
      if (dismissOutsideRef) {
        document.removeEventListener('mousedown', dismissOutsideRef);
        document.removeEventListener('contextmenu', dismissOutsideRef);
      }
    };
    const handlePrAction = (action: PrContextAction) => {
      removeContextMenu();
      const ranges = g.selectedRanges ?? [];
      // 선택 셀 평탄화 (CellRange[] → PrCell[]) — 가시 컬럼만.
      const cells: { rowIdx: number; binding: string }[] = [];
      for (const r of ranges) {
        for (let row = r.topRow; row <= r.bottomRow; row++) {
          for (let c = r.leftCol; c <= r.rightCol; c++) {
            const b = g.columns[c]?.binding ?? '';
            if (b) cells.push({ rowIdx: row, binding: b });
          }
        }
      }
      if (cells.length === 0) {
        // AS-IS "선택된 셀이 없습니다." (.cs L5519).
        void setAlert({ type: 'alert', content: t('LBL00709', '_선택된 셀이 없습니다.') });
        return;
      }
      const div = division;
      const isDiv40 = div === DIVISION.MOBILITY;
      const cell = (rowIdx: number, binding: string): string => {
        const item = g.rows[rowIdx]?.dataItem as Record<string, unknown> | undefined;
        return toCellStr(item?.[binding]);
      };
      const acc = {
        getCell: cell,
        getMeasure: (r: number) => cell(r, 'MEASURE'),
        // Div40 = ItemId40/ScmSiteId40 (AS-IS L5573/5574), 외 = ItemId/ScmSiteId (L5578/5579).
        getItemId: (r: number) => cell(r, isDiv40 ? 'ITEM_ID40' : 'ITEM_ID') || cell(r, 'ITEM_ID'),
        getScmSiteId: (r: number) =>
          cell(r, isDiv40 ? 'SCM_SITE_ID40' : 'SCM_SITE_ID') || cell(r, 'SCM_SITE_ID'),
        getProjectCode: (r: number) => cell(r, 'PROJECT_CODE') || cell(r, 'PROJECT'),
        getDomExp: (r: number) => cell(r, 'DOM_EXP'),
        getFcstType: (r: number) => cell(r, 'FCST_TYPE'),
        getIncoterms: (r: number) => cell(r, 'INCOTERMS'),
        getPlantSiteId: (r: number) => cell(r, 'PLANT_SITE_ID'),
      };
      // ⭐ 격차⑤⑥ (2026-07-03) — V4 가드(bucketType/컬럼 Visible, AS-IS L5603) + 단일셀 메시지 버튼명.
      const result = buildPrContextRequest(action, cells, acc, {
        bucketType,
        isColVisible: b => g.getColumn(b)?.visible !== false,
        actionLabel: (() => {
          const m = PR_MENU_LABELS.find(x => x.name === action);
          return m ? t(m.lblKey, m.fallback) : action;
        })(),
      });
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: t(result.msgKey, { defaultValue: result.fallback, ...(result.msgParams ?? {}) }),
        });
        return;
      }
      // division 주입 (Request_PR request.divisionId 보강).
      result.request.divisionId = div;
      onPrContextRef.current?.(action, result);
    };
    // ⭐ 2026-07-03 견고화 — "메뉴 항목 클릭 무동작" fix: 구 구현은 document mousedown(once) dismiss 가
    //   항목 click 의 mousedown 단계에서 메뉴를 먼저 제거해 click 이 증발했다(우클릭이 반응 없어 보이는 원인).
    //   → ① 항목 실행을 mousedown(좌클릭)에서 수행 ② dismiss 는 메뉴 밖 mousedown 만(contains 가드,
    //   persistent 리스너 — removeContextMenu 에서 해제) ③ contextmenu 는 capture 등록(내부 전파 차단 대비).
    const dismissOutside = (e: MouseEvent) => {
      if (contextMenuEl && e.target instanceof Node && contextMenuEl.contains(e.target)) return;
      removeContextMenu();
    };
    dismissOutsideRef = dismissOutside;
    const contextMenuHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return; // 데이터 셀에서만 (조회 전 빈 그리드는 브라우저 기본 메뉴)
      ev.preventDefault();
      ev.stopPropagation();
      removeContextMenu();
      const menu = document.createElement('div');
      menu.className = 'mkt-pr-context-menu';
      menu.style.cssText = `position:fixed;left:${ev.clientX}px;top:${ev.clientY}px;z-index:9999;background:#fff;border:1px solid #c2c9d1;border-radius:4px;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12px;min-width:140px;padding:4px 0;`;
      // ⭐ 격차④ (2026-07-03) — 메뉴 표시명 i18n (LBL00740~743. AS-IS 메뉴 Text 1:1).
      for (const it of PR_MENU_LABELS) {
        const li = document.createElement('div');
        li.textContent = t(it.lblKey, it.fallback);
        li.style.cssText = 'padding:6px 14px;cursor:pointer;white-space:nowrap;';
        li.addEventListener('mouseenter', () => (li.style.background = '#eef3fb'));
        li.addEventListener('mouseleave', () => (li.style.background = ''));
        // mousedown 실행 — dismiss/DOM 제거와의 click 레이스 원천 차단 (좌클릭만).
        li.addEventListener('mousedown', e => {
          if (e.button !== 0) return;
          e.preventDefault();
          e.stopPropagation();
          handlePrAction(it.name);
        });
        menu.appendChild(li);
      }
      document.body.appendChild(menu);
      contextMenuEl = menu;
      document.addEventListener('mousedown', dismissOutside);
      document.addEventListener('contextmenu', dismissOutside);
    };
    // ⭐ 2026-07-27 사용자 요구 — 우클릭 PR 컨텍스트 메뉴 임시 비활성화(기능 보류, 향후 복구 가능).
    //   아래 등록 한 줄만 주석 해제하면 원복. (핸들러 정의부는 그대로 보존)
    // g.hostElement.addEventListener('contextmenu', contextMenuHandler, { capture: true });
    void contextMenuHandler; // 미사용 경고 방지 — 향후 복구 대비 정의 보존

    // ⭐ Phase 2e — spdMain_EditChange (AS-IS .cs L5407~5413). Measure 좌측 무시 + bPasteContinue=true.
    const editChangeHandler = (_s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      const measureIdx = g.columns.findIndex(c => c.binding === 'MEASURE');
      // AS-IS L5409: Measure 컬럼 인덱스 >= 편집 컬럼 인덱스면 무시 (좌측 키 컬럼 편집).
      if (measureIdx >= 0 && measureIdx >= e.col) return;
      pasteContinueRef.current = true;
    };
    g.cellEditEnding.addHandler(editChangeHandler);

    // 수량 셀 소수점 입력 차단 — '.' 키를 아예 못 치게 한다(2026-08-28 사용자 요구).
    //   capture 로 잡는 이유: Wijmo 에디터가 keydown 을 먼저 소비하면 이미 값이 들어간 뒤다.
    const blockQtyDotKey = (ev: KeyboardEvent) => {
      if (ev.key !== '.' && ev.key !== 'Decimal') return;
      if (!isQtyBinding(g.columns[g.selection.col]?.binding ?? '')) return;
      ev.preventDefault();
    };
    g.hostElement.addEventListener('keydown', blockQtyDotKey, true);

    // 키 입력 외 경로(셀 안에서 Ctrl+V, 드래그 채우기)로 들어온 소수는 커밋 시점에 버린다.
    //   에디터 값을 고쳐야 EditTracker 가 '1 -> 1.5 -> 1' 을 수정(M)으로 잡지 않는다.
    const truncQtyOnCommit = (s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      if (!isQtyBinding(g.columns[e.col]?.binding ?? '')) return;
      const ed = s.activeEditor;
      if (!ed || !ed.value.includes('.')) return;
      const n = truncQty(ed.value);
      if (typeof n === 'number') ed.value = String(n);
    };
    g.cellEditEnding.addHandler(truncQtyOnCommit);

    // ⭐ Phase 2e — spdMain_ClipboardPasted (AS-IS .cs L5416~5448). 붙여넣기된 셀이 ScmSiteId40(Div40)/
    //   ScmSiteId(81·82) 컬럼이면 해당 행 Measure/Incoterms 콤보 재조회·재설정.
    //   Wijmo 는 whole-range 'pasted' 이벤트가 없어 pastedCell(셀당) 사용. TO-BE 콤보 dataMap 은
    //   grid 전역(useTabComboQueries) 이므로 행 단위 재조회 대신 dataMap 재부착 + invalidate 로 표시 동기화.
    //   2026-08-19 사용자 요구 추가 — 붙여넣기도 콤보를 직접 바꿨을 때와 똑같이 하위 셀을 비운다.
    //     값이 덮이기 전이 직전 값을 잡을 유일한 시점이라 pastingCell 에서 기억해 둔다.
    //     처리는 셀마다 즉시 하지 않고 붙여넣기 한 번이 끝난 뒤(setTimeout 0) 모아서 한다 —
    //     즉시 하면 같은 붙여넣기로 뒤이어 들어올 하위 셀 값을 먼저 지워 버린다. 모아서 하면
    //     같은 행에 함께 붙여넣은 컬럼을 keepCols 로 넘겨 그 값만 살릴 수 있다.
    const pasteOldValues = new Map<string, unknown>();
    let pastedCells: { row: number; binding: string; oldVal: unknown }[] = [];
    let pasteFlushTimer: ReturnType<typeof setTimeout> | null = null;

    const pastingCellHandler = (s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      // 배치의 첫 셀이면(=flush 예약 없음) 이전 배치에서 취소돼 남은 값을 버린다.
      if (pasteFlushTimer === null) pasteOldValues.clear();
      const b = g.columns[e.col]?.binding ?? '';
      // Ctrl+V 는 에디터를 안 거치므로 값에서 직접 버린다. 셀 거부는 안 한다(대량 붙여넣기가 막힌다).
      if (isQtyBinding(b)) e.data = truncQty(e.data);
      const rec = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      pasteOldValues.set(`${e.row}:${e.col}`, rec?.[b]);
    };

    const flushPastedCascade = () => {
      pasteFlushTimer = null;
      const cells = pastedCells;
      pastedCells = [];
      pasteOldValues.clear();
      if (cells.length === 0) return;
      const pastedByRow = new Map<number, string[]>();
      for (const c of cells) {
        const cols = pastedByRow.get(c.row) ?? [];
        cols.push(c.binding);
        pastedByRow.set(c.row, cols);
      }
      for (const c of cells) {
        applyStaticCascade(
          g,
          c.row,
          c.binding,
          { binding: c.binding, oldVal: c.oldVal },
          pastedByRow.get(c.row) ?? []
        );
      }
      g.invalidate(true);
    };

    const pastedCellHandler = (_s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      const b = g.columns[e.col]?.binding ?? '';
      const key = `${e.row}:${e.col}`;
      if (b) {
        pastedCells.push({ row: e.row, binding: b, oldVal: pasteOldValues.get(key) });
        if (pasteFlushTimer === null) pasteFlushTimer = setTimeout(flushPastedCascade, 0);
      }
      pasteOldValues.delete(key);
      if (b !== 'SCM_SITE_ID' && b !== 'SCM_SITE_ID40') return;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
      g.invalidate(true);
      pasteContinueRef.current = false;
    };
    g.pastingCell.addHandler(pastingCellHandler);
    g.pastedCell.addHandler(pastedCellHandler);

    // Scroll 시 머지 그룹 재계산 (viewport sticky #38)
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 + HierarchicalMergeManager (utils/mkt-fcst.merge.ts) =====
    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new HierarchicalMergeManager(fixedBindings);
    g.invalidate(true);

    return () => {
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
        // ⭐ 2026-07-27 컨텍스트 메뉴 등록 비활성화에 맞춰 해제도 주석(등록 복구 시 함께 해제).
        // g.hostElement?.removeEventListener('contextmenu', contextMenuHandler, { capture: true });
        removeContextMenu();
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnding?.removeHandler(editChangeHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnding?.removeHandler(truncQtyOnCommit);
      } catch {
        /* unmount race */
      }
      try {
        g.hostElement?.removeEventListener('keydown', blockQtyDotKey, true);
      } catch {
        /* unmount race */
      }
      try {
        g.pastingCell?.removeHandler(pastingCellHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.pastedCell?.removeHandler(pastedCellHandler);
      } catch {
        /* unmount race */
      }
      if (pasteFlushTimer !== null) clearTimeout(pasteFlushTimer);
      try {
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // sesUserId — applyRowParamCombo 가 콤보 파라미터에 싣는다. 세션 값이라 재등록은 사실상 없다.
  }, [
    visibleColumns,
    dynBindings,
    fixedBindings,
    editCutoff,
    division,
    sesUserId,
    bucketType,
    dataMaps,
  ]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3) + combo dataMap 재적용.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // ⚠️ 여기서 filterColumns 를 sanitize 하지 말 것 — GridAction.toggleColumnFilter(F4) 가
      //   invalidate() 로 끝나 이 updatedLayout 핸들러를 즉시 깨우므로, 방금 켠 동적(M_/W_/D_)
      //   컬럼 필터가 한 프레임 만에 지워진다("생겼다 사라짐"). 동적 컬럼도 forecast-price 와
      //   동일하게 필터 대상이다.
      // (0-c) [공통 UC-07] 재조회해도 사용자가 걸어둔 **필터가 유지**되어야 한다.
      //   columnGroups 재대입이 Column 객체를 통째로 재생성하므로, FlexGridFilter 가 죽은 Column 을
      //   붙든 채 남아 "아이콘은 꺼졌는데 행은 걸러진" 상태가 된다. 끊긴 필터만 재바인딩한다.
      //   (끊긴 게 없으면 no-op — 되먹임 방지는 유틸 내부 가드가 담당. hook #133 §5 UC-07)
      rebindFilterColumns(g as unknown as FlexGridType<WijmoRowItem>, gridFilterRef?.current);
      // (0) combo dataMap 재적용 — wrapper columnGroups 재적용이 col.dataMap 을 덮으므로 재부착(guard)
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const rowCount = headerRows.length;
      const per = Math.round(48 / rowCount);
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
  }, [dynBindings, visibleColumns, dataMaps, gridRef, gridFilterRef]);

  // ⭐ B2 Sum 체크박스 + 헤더 드릴다운 — 동적 컬럼 visible 통합 적용 (AS-IS SetSpreadColumn +
  //   spdMain_CellDoubleClick 헤더 분기 1:1). 규칙: 활성 bucket=표시 / 상위 합계=sumYn /
  //   하위=숨김 — 셋 다 드릴 오버라이드(drillVisRef)가 우선. 컬럼그룹 rebuild 없이 imperative
  //   flip — 스크롤/컬럼폭 보존. wrapper 의 columnGroups 재적용이 visible 을 덮을 수 있어
  //   updatedLayout 마다 재적용 (dataMap 재부착과 동일 가드 패턴).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g) return;
    // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행과 동일 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, drillBindings, dynBindings, gridRef]);

  // ⭐ 현재 주/월/일 헤더·테두리 강조 — 조회 응답 갱신 시 formatItem 재실행 (currentPeriodBindings 최신값 반영).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    g?.invalidate(true);
  }, [currentWeekInfo, gridRef]);

  // F4 Filter — 정적/동적 컬럼 모두 필터 대상 + 필터후 머지/높이 재적용.
  //   FlexGridFilter 인스턴스는 공용 DataGrid 소유(gridFilterRef) — 여기서는 핸들러만 얹는다.
  //   금지: 여기서 new FlexGridFilter 생성. 두 번째 인스턴스가 itemsSourceChanged 에 거는 clear 가
  //   DataGrid 의 restore 뒤에 실행돼 복원한 필터를 도로 지운다(재조회·행추가 시 필터 해제, 2026-08-21 실측).
  //   인스턴스는 DataGrid 의 initialized(자식 mount)에서 만들어지므로 이 effect(부모) 시점엔 항상 있다.
  //   표준 = master/sales-site/components/SalesSiteGrid.tsx.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    const f = gridFilterRef?.current;
    if (!g || !f) return;

    const onFilterApplied = () => g.invalidate(true);

    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef]);

  return (
    <>
      <DataGrid<MktFcstRow>
        gridRef={gridRef}
        // 필터 인스턴스는 DataGrid 소유 — 위 F4 Filter effect 주석 참고.
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows}
        autoGenerateColumns={false}
        allowSorting={true}
        allowMerging={AllowMerging.All}
        useAggregationRow={false}
      />
    </>
  );
};
