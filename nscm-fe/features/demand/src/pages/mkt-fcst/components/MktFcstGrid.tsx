import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellRangeEventArgs,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  DIVISION,
  GRID_CASCADE_CLEAR,
  GRID_CASCADE_FILTERS,
  GRID_EDIT_COMBO,
  MAIN_COLUMNS,
  MEASURE_MODEL_CLEAR_COLS,
  MEASURE_MODEL_KEEP,
  MSG,
  PR_MENU_LABELS,
} from '../mkt-fcst.constants';
import type { MktFcstRow, SpreadTitleRow } from '../mkt-fcst.types';
import styles from '../MktFcst.module.scss';
import type { BucketInfo, CurrentWeekInfo, MeasureMeta } from '../useMktFcstStore';
import { buildEditCutoff, dynKindOf, evalDynCell, thisWeekMondayYmd } from '../utils/mkt-fcst.editLock';
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

interface Props {
  rows: MktFcstRow[];
  gridRef: Ref<FlexGridType<MktFcstRow>>;
  // ⭐ F4 Filter — 피처가 FlexGridFilter 직접 소유. 동적(M_/W_/D_) 컬럼 필터 cancel + 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적 + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
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
  // hook #92 — admin DIVISION_ID(콤마 토큰 리스트) 복사값(ATTRIBUTE3).
  _divisionAllow?: string;
}

export const MktFcstGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
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
  // ⭐ 현재 주/월 binding — formatItem(대형 effect deps 미포함) 이 최신값 참조하도록 ref 미러.
  //   AS-IS chkColor=false 경로 (평문 .cs L5654~5687): 현재 W_/M_ 컬럼 헤더 초록 Bold 강조.
  // bPasteContinue (AS-IS spdMain_EditChange L5411) — paste 연계 플래그.
  const pasteContinueRef = useRef(false);

  // ⭐ 과거/Div40 8주 편집 cutoff (보강스펙 §1/§5) — O_RC2(8주 월)·O_RC3(현재 주) + 이번주 월요일.
  //   formatItem(배경색) + beginningEdit(편집 cancel) 두 곳에서 동일 기준 공유 (DMF0020 패턴).
  const editCutoff = useMemo(
    () => buildEditCutoff(bucketInfo ?? null, currentWeekInfo ?? null),
    [bucketInfo, currentWeekInfo]
  );

  // ⭐ P2-① 현재기간 binding 집합 — 헤더 초록 Bold(기존) + 데이터셀 초록 테두리(신규) 공통 판정.
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
        // hook #92 — admin DIVISION_ID(콤마 토큰) 가시성.
        //   1순위 ATTRIBUTE3 = DIVISION_ID 정식 복사값(handoff #41, sub-division 81_UC 등 전체 토큰).
        //   2순위 ATTRIBUTE1 = corp 가 이미 보유한 cleaned division 토큰('40'/'81,82') — #41 미적용에도 즉시 동작.
        //   둘 다 공란이면 항상 표시(division 무관 컬럼).
        _divisionAllow: col.attribute3?.trim() || col.attribute1,
      } as MergedColumnMeta;
    });
  }, [staticColumns]);

  // visible=true + division 필터 (hook #92)
  const visibleColumns = useMemo(
    () =>
      mergedColumns.filter(c => {
        if (!c.visible) return false;
        const allow = c._divisionAllow?.trim();
        if (!allow) return true; // DIVISION_ID 공란 = 항상 표시
        if (!divisionId) return true;
        return allow
          .split(',')
          .map(s => s.trim())
          .includes(divisionId);
      }),
    [mergedColumns, divisionId]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.binding), [visibleColumns]);

  // ===== Grid 내 combo column dropdown — UI Category 메타(cellCboDataTp) 기반 (DMF0020 표준) =====
  //   ⭐ 2026-07-03 개편: 하드코딩 comboId + 객체형 파라미터({comboId, divisionId}) 전면 제거.
  //   근거(실측): BE makeComboQuery 는 @key 를 payload 값으로 "따옴표 없이" 치환(세션 sesUserId/sesLangCd 만
  //   따옴표 포함 주입) → divisionId 전달 시 `SEGMENT1 = 81`(숫자 비교) 이 되어 ORA-01722 위험,
  //   문자열 comboId 만 보내면 `@divisionId → ''` 로 0행 — 어느 쪽도 파라미터 콤보는 동작 불가.
  //   따라서 콤보 SQL 은 파라미터 없는 등록명(admin CELL_COMBO_DATA_TYPE)만 사용한다.
  const comboColumns = useMemo(
    () => visibleColumns.filter(c => c._ctrlType === 'FPComboBox' && !!c._comboKey),
    [visibleColumns]
  );
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(c => c._comboKey as string),
  });
  // dataMap 재생성 안정화 — comboId + row count 시그니처가 바뀔 때만 rebuild (DMF0020 동일).
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

  // ⭐ cascade (hook #59 §5-G / DMF0020 이식) — 편집 진입 시 행 컨텍스트 dataMap 스왑용
  //   콤보 원본 rows + 전체 dataMap 원복용 ref 미러 (핸들러 useEffect deps 밖 참조).
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

  // ⭐ 편집 전용 콤보 (MEASURE=MktFcstEditMeasure @div / INCOTERMS=IncotermsEdit) — 편집 진입 시 dataMap 스왑,
  //   cellEditEnded 시 조회 표시 dataMap 으로 원복. divisionParam=true 는 FE quoting('값') 전달(BE raw 치환 대응).
  const editComboEntries = useMemo(() => Object.entries(GRID_EDIT_COMBO), []);
  const editComboResults = useTabComboQueries({
    filters: editComboEntries.map(([, cfg]) =>
      cfg.divisionParam ? { comboId: cfg.comboId, divisionId: `'${division}'` } : cfg.comboId
    ),
  });
  const editComboSig = editComboResults
    .map((r, i) => `${editComboEntries[i]?.[0]}#${r?.length ?? 'x'}`)
    .join(',');
  const editDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    editComboEntries.forEach(([binding], i) => {
      const arr = (editComboResults[i] ?? []) as unknown as Record<string, unknown>[];
      m[binding] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);
  const editDataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    editDataMapsRef.current = editDataMaps;
  }, [editDataMaps]);

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
      return titleRows
        .map<DynColMeta>(r => ({
          binding: r.COLUMN_NAME,
          kind: kindOf(r.COLUMN_NAME)!,
          large: r.LARGE_CLASS_LABEL_NAME ?? '',
          small: r.SMALL_CLASS_LABEL_NAME ?? '',
          leaf: r.COLUMN_LABEL_NAME ?? '',
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
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
    return [...set].sort().map<DynColMeta>(b => {
      const dyn = getDynKey(b);
      return { binding: b, kind: kindOf(b)!, large: dyn.ym, small: dyn.sub, leaf: dyn.leaf, sort: 0 };
    });
  }, [spreadTitle, rows, allowedKinds]);

  // binding 순서 목록 (머지 매니저 / 필터 sanitize / recalc 보행이 참조 — M/W/D interleave = AS-IS 순서)
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // ⭐ B2 — 표시 규칙 rank 분리 (M=0 상위 … D=2 하위):
  //   활성 bucket kind = 항상 표시 / 상위(rank<bucket) = 합계 → sumYn 토글 /
  //   하위(rank>bucket) = 기본 숨김 → 헤더 더블클릭 드릴로만 표시.
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
  //   컬럼 고정(freeze)은 admin FIXED_FLAG 위임 (2026-07-04 사용자 지시 — hook ui-category-setup-column-meta
  //   §12: AS-IS Freeze(0, MEASURE+1) 하드코드 재현 해제. 사내 메타 전행 공란 실측 = 고정 0.
  //   admin SYS0004 에서 FIXED_FLAG='Y' 등록 시 화면 수정 없이 즉시 고정 — wrapper 가 _fixed findLastIndex+1 계산).
  //   PIVOT 동적 컬럼(우측)은 dynamicColumns 로 별도 전달.
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
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
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    type SubBucket = Map<string, LeafCol[]>;
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
            ? (m.small ||
                (/^W_\d{7,9}$/.test(m.binding) && !/^W_\d{8}$/.test(m.binding)
                  ? `W${m.binding.slice(8)}`
                  : getDynKey(m.binding).sub)
              ).trim() || 'SUM'
            : (m.small || getDynKey(m.binding).sub).trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)!.push({
        binding: m.binding,
        // 3단(leaf) 라벨 — M/W 합계는 'SUM'(사용자 지정 2026-06-29/07-02) / D=일자(m.leaf).
        header: m.kind === 'D' ? m.leaf || m.small || 'SUM' : 'SUM',
        align: 'right',
        format: 'n3',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48, // 다단 헤더 높이(#93) — wrapper 가 staticColumns 만 자동 처리, 동적은 명시 의무.
        // ⭐ 동적 셀은 'S'(read-only) — Phase 2a 는 표시 전용. 편집(2b)은 beginningEdit 에서 명시 허용.
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        _display: true,
      });
    });
    // sub 정렬: 'SUM'(월합계) 최우선 → 주차 오름차순. leaf 정렬: 합계(M/W) 먼저 → 일자 binding 순.
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: 48,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: 48,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas]);

  // ⭐ grid 핸들러 + mergeManager useEffect 분리 등록.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // 홀짝 zebra (#95) — 클래스 없는 셀 White 기본 + .wj-alt
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGridType<MktFcstRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // ⭐ AS-IS chkColor=false 경로 1:1 (평문 .cs L5654~5687, 실행 화면 기본 상태) —
        //   현재 월(M_당월)/현재 주(W_당주) 컬럼 헤더를 초록 Bold 강조. O_RC3(THIS_YYYYMM/THIS_YYYYMMWW)
        //   binding 정확 일치로 판정 (AS-IS 는 tag yyyymm+iso_week 비교 — 동일 산출값).
        const isCurrentPeriod =
          !!col.binding && currentPeriodBindingsRef.current.has(col.binding);
        e.cell.style.color = isCurrentPeriod ? '#1e8449' : '';
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
        // ⭐ P2-① 현재기간(당월/당주/당일) 세로 테두리 — 배경색과 독립(편집 Yellow·동기화색과 공존).
        toggleClass(
          e.cell,
          'mkt-cell-current-period',
          currentPeriodBindingsRef.current.has(col.binding)
        );
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
        // ⭐ Color 체크박스 제거 (2026-07-03 사용자 결정 — AS-IS 실행 UI 에 미표시·초기 false).
        //   AS-IS chkColor=false 경로 = 과거영역 Gray 배경 없음 (편집 잠금은 beginningEdit 에서 유지,
        //   편집 가능 Yellow 는 #95 표준 유지). Gray 는 어떤 경우에도 칠하지 않는다.
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        return;
      }

      // ⭐ 종속 메저 단계별 indent (2026-07-13 사용자 요구 — AS-IS UP_FX_GetCommonDataList 'Measure'
      //   parity: 1단계 ' └ ' / 2단계(EDI 하위 세부) '    └ ' 공백4). 표시명은 admin 콤보
      //   dataMap('Measure' CMBO_SQL)에서 오며, 선행 공백이 HTML 에서 collapse 되면 전부 동일
      //   단계로 보이는 사고 → MEASURE 셀만 white-space 보존 (다른 컬럼 영향 0).
      if (col.binding === 'MEASURE') e.cell.style.whiteSpace = 'pre';

      // Fixed col cell coloring — Insert 행의 IM/IO = Yellow, 그 외 White
      if (meta) {
        const editableForInsert =
          isInsert &&
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
      }
    };
    g.formatItem.addHandler(formatHandler);

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
        // ⭐ 편집 전용 콤보 스왑 (MEASURE=편집가능 measure / INCOTERMS=유효 Incoterms). 조회 표시는 전체
        //   dataMap, 편집 후보만 유효분으로 교체 (AS-IS 편집/조회 이원화). cellEditEnded 에서 원복.
        if (GRID_EDIT_COMBO[binding] && editDataMapsRef.current[binding]) {
          col.dataMap = editDataMapsRef.current[binding];
          return;
        }
        const cascade = GRID_CASCADE_FILTERS[binding];
        if (meta._ctrlType === 'FPComboBox' && cascade && row) {
          const src = comboRowsRef.current[binding] ?? [];
          const rowRec = row as unknown as Record<string, unknown>;
          const filtered = src.filter(cr =>
            cascade.every(({ rowKey, comboKey }) => {
              const rv = toCellStr(rowRec[rowKey]).trim();
              const cv = toCellStr(cr[comboKey]).trim();
              return !rv || rv === 'ALL' || !cv || rv === cv;
            })
          );
          // Map 복합 키 dedup (hook #59 §3) — 필터 후 division 컨텍스트 유지.
          const dedup = [
            ...new Map(
              filtered.map(cr => [`${toCellStr(cr.DIVISION_ID)}|${toCellStr(cr.CODE)}`, cr])
            ).values(),
          ];
          col.dataMap = new DataMap(dedup, 'CODE', 'NAME');
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
        const n = typeof v === 'number' ? v : Number(String(v as string | number).replace(/,/g, ''));
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
            tracker.storeChange(
              row as never,
              b,
              (prev ?? null) as never,
              (value ?? null) as never
            );
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

    // 편집 종료 — (A) 정적 cols = Insert 행 group 동기화 / (B) 동적 cols(D_/W_/M_) = 재계산 cascade.
    const cellEditEndedHandler = (s: FlexGridType<MktFcstRow>, e: { row: number; col: number }) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';

      // ⭐ cascade 스왑 원복 (hook #59 §5-G) — beginningEdit 의 행 컨텍스트 필터 dataMap 을 전체
      //   dataMap 으로 되돌린다 (스왑 잔존 시 필터 밖 CODE 보유 타 행의 명칭 변환이 깨짐. 취소도 커버).
      if (GRID_CASCADE_FILTERS[binding] && dataMapsRef.current[binding]) {
        col.dataMap = dataMapsRef.current[binding];
      }
      // ⭐ 편집 전용 콤보 원복 (MEASURE/INCOTERMS) — 편집 후보(유효분) dataMap 을 전체 표시 dataMap 으로
      //   되돌린다. 원복 누락 시 조회 표시에서 편집목록 밖 CODE 명칭 변환 손실.
      if (GRID_EDIT_COMBO[binding] && dataMapsRef.current[binding]) {
        col.dataMap = dataMapsRef.current[binding];
      }

      // ===== (B) 동적 셀(D_/W_/M_) 재계산 cascade (보강스펙 §2, AS-IS L3282~4175) =====
      if (dynKindOf(binding) && /^[MWD]_/.test(binding)) {
        if (!canModelChangeRef.current) return; // 재진입 차단 (AS-IS L2885)
        const row = s.rows[e.row].dataItem as MktFcstRow | undefined;
        if (!row) return;
        runDynRecalc(s, e.row, binding, row);
        return;
      }

      // ===== (A) 정적 셀 — Insert 행 group 좌측 cols 동기화 (Phase 2b 유지) =====
      const meta = visibleColumns.find(c => c.binding === binding);
      if (!meta) return;
      const staticRow = s.rows[e.row].dataItem as MktFcstRow | undefined;
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
      const clearTargets = GRID_CASCADE_CLEAR[binding];
      const prev = editingCellRef.current;
      const changed = prev?.binding === binding && toCellStr(prev.oldVal) !== toCellStr(newVal);
      if (clearTargets && changed) {
        for (const item of view.items) {
          if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid) {
            const rec = item as Record<string, unknown>;
            clearTargets.forEach(k => {
              rec[k] = '';
            });
          }
        }
      }
      // ⭐ MEASURE 변경 시 model(품목) 컬럼 clear (AS-IS: measure 교체 시 종속 model 재선택 강제).
      //   예외 = MEASURE_MODEL_KEEP(AS_In_Req/BNPIn) 은 model 유지. 같은 INSERT_GROUP 형제 행 일괄.
      if (binding === 'MEASURE' && changed) {
        const nextMeasure = toCellStr(newVal);
        if (!MEASURE_MODEL_KEEP.includes(nextMeasure)) {
          for (const item of view.items) {
            if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid) {
              const rec = item as Record<string, unknown>;
              MEASURE_MODEL_CLEAR_COLS.forEach(k => {
                rec[k] = '';
              });
            }
          }
        }
      }
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
      if (meta._modalKey) onPopupCellDblClick?.(meta._modalKey, row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // ⭐ Phase 2e — contextMenu PR (AS-IS contextMenuStrip1_ItemClicked, .cs L5510~5753).
    //   우클릭 → Request_PR / View_PR / Add_History / View_History 메뉴. 검증은 buildPrContextRequest
    //   (BNPIn measure + D_ 컬럼 + 과거일 제외 + Model dup + Project 동일). 통과 시 onPrContext 전달.
    let contextMenuEl: HTMLDivElement | null = null;
    let dismissOutsideRef: ((e: MouseEvent) => void) | null = null;
    const removeContextMenu = () => {
      if (contextMenuEl && contextMenuEl.parentNode) contextMenuEl.parentNode.removeChild(contextMenuEl);
      contextMenuEl = null;
      if (dismissOutsideRef) {
        document.removeEventListener('mousedown', dismissOutsideRef);
        document.removeEventListener('contextmenu', dismissOutsideRef);
      }
    };
    const handlePrAction = (action: PrContextAction) => {
      removeContextMenu();
      const ranges = (g.selectedRanges ?? []);
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
    g.hostElement.addEventListener('contextmenu', contextMenuHandler, { capture: true });

    // ⭐ Phase 2e — spdMain_EditChange (AS-IS .cs L5407~5413). Measure 좌측 무시 + bPasteContinue=true.
    const editChangeHandler = (_s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      const measureIdx = g.columns.findIndex(c => c.binding === 'MEASURE');
      // AS-IS L5409: Measure 컬럼 인덱스 >= 편집 컬럼 인덱스면 무시 (좌측 키 컬럼 편집).
      if (measureIdx >= 0 && measureIdx >= e.col) return;
      pasteContinueRef.current = true;
    };
    g.cellEditEnding.addHandler(editChangeHandler);

    // ⭐ Phase 2e — spdMain_ClipboardPasted (AS-IS .cs L5416~5448). 붙여넣기된 셀이 ScmSiteId40(Div40)/
    //   ScmSiteId(81·82) 컬럼이면 해당 행 Measure/Incoterms 콤보 재조회·재설정.
    //   Wijmo 는 whole-range 'pasted' 이벤트가 없어 pastedCell(셀당) 사용. TO-BE 콤보 dataMap 은
    //   grid 전역(useTabComboQueries) 이므로 행 단위 재조회 대신 dataMap 재부착 + invalidate 로 표시 동기화.
    const pastedCellHandler = (_s: FlexGridType<MktFcstRow>, e: CellRangeEventArgs) => {
      const b = g.columns[e.col]?.binding ?? '';
      if (b !== 'SCM_SITE_ID' && b !== 'SCM_SITE_ID40') return;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
      g.invalidate(true);
      pasteContinueRef.current = false;
    };
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
        // add 와 동일한 capture 플래그로 해제 (불일치 시 미해제 → 리스너 누적)
        g.hostElement?.removeEventListener('contextmenu', contextMenuHandler, { capture: true });
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
        g.pastedCell?.removeHandler(pastedCellHandler);
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
  }, [
    visibleColumns,
    dynBindings,
    fixedBindings,
    onPopupCellDblClick,
    editCutoff,
    division,
    bucketType,
    dataMaps,
  ]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3) + combo dataMap 재적용.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // (0-a) Filter sanitize — 동적(M_/W_/D_) binding 제거 (머지헤더 충돌 방지)
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^[MWD]_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
      // (0-b) combo dataMap 재적용 — wrapper columnGroups 재적용이 col.dataMap 을 덮으므로 재부착(guard)
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

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (동적 컬럼 필터 제외 + 필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MktFcstRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const isDynamic = (binding: string | null | undefined): boolean => /^[MWD]_/.test(binding ?? '');
    const onFilterChanging = (_s: FlexGridFilter, e: CellRangeEventArgs) => {
      if (isDynamic(e.getColumn()?.binding)) e.cancel = true;
    };
    const onFilterApplied = () => g.invalidate(true);

    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
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

  return (
    <div className={styles.gridContainer}>
      <DataGrid
        key={mainStaticColumns.map(c => c.colNm).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        editTrackerRef={editTrackerRef as never}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        allowMerging={AllowMerging.All}
      />
    </div>
  );
};
