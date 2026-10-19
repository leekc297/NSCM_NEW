// ⭐ 공용 Wijmo OLAP PivotGrid 래퍼 — NSCM 첫 OLAP 적용(DMF0035 Demand Plan Waterfall, 2026-08-06).
//   사용자 지시: waterfall 계열 그리드는 Wijmo OLAP 표준 컴포넌트 사용.
//   구성: @mescius/wijmo.olap PivotEngine(분석 엔진) + @mescius/wijmo.react.olap PivotGrid(표시).
//   데이터 계약: itemsSource 는 long-format 행(축 컬럼들 + 값 컬럼) — SP 가 wide(PIVOT) 커서를
//   반환하는 화면은 unpivotWideRows() 로 변환 후 전달한다.
//   ⚠ 공용 DataGrid 의 부가기능(useResultColumns/summary tooltip/hotkey 연동)은 OLAP 판에 없음 —
//   Excel 내보내기는 exportExcel() ref 메서드(wijmo.grid.xlsx FlexGridXlsxConverter) 사용.
import { PivotEngine, PivotField } from '@mescius/wijmo.olap';
import { PivotGrid } from '@mescius/wijmo.react.olap';
import {
  forwardRef,
  useEffect,
  useImperativeHandle,
  useMemo,
  useRef,
  type ReactElement,
} from 'react';

/** OLAP 필드 정의 — PivotEngine 필드 바인딩 (binding = 데이터 행 키). */
export interface OlapFieldDef {
  binding: string;
  header?: string;
  /** 값 필드 표시 포맷 (예: 'n3' = 소수 3자리, 'n0'). */
  format?: string;
  /** 값 필드 집계 (기본 Sum). PivotField.aggregate 문자열 키. */
  aggregate?: 'Sum' | 'Avg' | 'Max' | 'Min' | 'Cnt';
}

export interface OlapPivotGridProps {
  /** long-format 데이터 행 (행/열 축 컬럼 + 값 컬럼 보유). */
  itemsSource: Record<string, unknown>[];
  /** 행 축 필드 (좌측 고정 계층 — 순서대로 계층화). */
  rowFields: OlapFieldDef[];
  /** 열 축 필드 (기간 축 등 — 순서대로 계층화). */
  columnFields: OlapFieldDef[];
  /** 값 필드 (집계 대상). */
  valueFields: OlapFieldDef[];
  /**
   * 등록만 하고 어느 축에도 두지 않는 필드 — 필드 레일에서 드래그로 배치할 후보 (DMF0035 사용자 지시 2026-08-28:
   * UI CATEGORY 전체 컬럼 등록·DEFAULT 만 Rows / BUCKET 3종 등록·선택 버킷만 Columns).
   */
  extraFields?: OlapFieldDef[];
  /**
   * 사용자가 레일/드래그로 축 구성을 바꿨을 때(engine.viewDefinitionChanged) 각 축의 필드 **헤더** 목록을 통지.
   * 화면이 버킷 필드 이동 → 조회조건 bucket 갱신 같은 후속 처리를 한다. props 재적용으로 인한 변경은 통지하지 않는다.
   */
  onLayoutChange?: (layout: { rows: string[]; columns: string[]; filters: string[]; values: string[] }) => void;
  /**
   * 내부 PivotGrid(FlexGrid 파생) 인스턴스가 준비된 직후 통지 — 화면이 formatItem/헤더 높이/필터 등 그리드 후처리를
   * 붙일 때 ref 폴링 대신 이 시점을 deps 로 쓴다 (ref 만 보면 마운트 전 effect 가 빈손으로 끝난다).
   */
  onGridInit?: (grid: unknown) => void;
  /**
   * ⭐ [E20260902-PIVOTCOUNT] **피벗 후 행수**(= 그리드·Excel 에 실제로 그려지는 행수) 통지.
   *   사용자 지시 2026-09-02: DMF0035 건수 표기를 원천 행수가 아니라 피벗 결과 기준으로 바꾼다.
   *   배경 — 원천(SP O_RC1) 행수와 피벗 행수는 다르다. PivotEngine 은 `rowFields` 조합으로 그룹핑하므로
   *   축에 없는 컬럼으로만 갈리는 원천 행들은 **한 행으로 병합**된다
   *   (SALES div81 실사고: UI 1,150건 표기 vs Excel 1,144행 = 병합 6행).
   *   그리드의 `updatedLayout`(행·열 재생성 완료) 시점에 **`grid.rows.length`** 를 전달한다.
   *   (⛔ `engine.pivotView.items.length` 는 그리드 행수와 다르다 — 본문 구현부 주석 참조)
   */
  onPivotRowCountChange?: (rowCount: number) => void;
  /** 소계/총계 표시 (waterfall 은 기본 미표시 — AS-IS footer SUM 은 열 총계로 대체 가능). */
  showRowTotals?: 'None' | 'Subtotals' | 'GrandTotals';
  showColumnTotals?: 'None' | 'Subtotals' | 'GrandTotals';
  /** 그리드 높이 CSS 값. 미지정 시 flex 채움(flex:1 1 0 — ViewContainer flex column 표준). */
  height?: string;
  /**
   * 컬럼 폭 자동 최적화 (opt-in — DMF0035 사용자 지정 2026-08-20).
   * 피벗 뷰 갱신 시 행 축 헤더=내용 기준 autosize, 값 컬럼=내용 기준 autosize 후 MIN/MAX 캡.
   */
  autoFitColumns?: boolean;
  className?: string;
}

export interface OlapPivotGridRef {
  engine: PivotEngine | null;
  /** 내부 PivotGrid(FlexGrid 파생) 인스턴스 — SubTitle 등 FlexGrid 소비 컴포넌트 연동용. */
  grid: unknown;
  /** 현재 피벗 뷰를 xlsx 로 저장. */
  exportExcel: (fileName: string) => void;
}

// wijmo.olap ShowTotals 실측: None=0 / GrandTotals=1 / Subtotals=2 (d.ts enum 순서 — 뒤바꾸면
// 총계만↔소계+총계 선택이 반전되는 오류)
const TOTALS = { None: 0, GrandTotals: 1, Subtotals: 2 } as const;
const AGGS = { Sum: 1, Cnt: 2, Avg: 3, Max: 4, Min: 5 } as const;

const applyFields = (
  collection: { clear: () => void; push: (f: PivotField) => void },
  engine: PivotEngine,
  defs: OlapFieldDef[],
  isValue: boolean
) => {
  collection.clear();
  for (const def of defs) {
    // 필드 키 = header(없으면 binding) — 같은 binding 을 다른 이름으로 여러 번 등록할 수 있다
    //   (예: DMF0035 버킷 3종 Monthly/Weekly/Daily 가 모두 PERIOD 에 바인딩).
    const field = engine.fields.getField(def.header ?? def.binding);
    if (!field) continue;
    if (def.format) field.format = def.format;
    if (isValue) field.aggregate = AGGS[def.aggregate ?? 'Sum'];
    collection.push(field);
  }
};

const headersOf = (c: { length: number; [i: number]: PivotField }): string[] =>
  Array.from({ length: c.length }, (_, i) => c[i].header);

export const OlapPivotGrid = forwardRef<OlapPivotGridRef, OlapPivotGridProps>(
  (
    {
      itemsSource,
      rowFields,
      columnFields,
      valueFields,
      extraFields,
      onLayoutChange,
      onGridInit,
      onPivotRowCountChange,
      showRowTotals = 'None',
      showColumnTotals = 'None',
      height,
      autoFitColumns = false,
      className,
    },
    ref
  ): ReactElement => {
    // PivotEngine 은 마운트당 1개 유지 — itemsSource/필드 변경 시 재구성(deferUpdate 배치).
    const engineRef = useRef<PivotEngine | null>(null);
    const engine = useMemo(() => {
      const e =
        engineRef.current ??
        new PivotEngine({
          autoGenerateFields: false,
          showRowTotals: TOTALS[showRowTotals],
          showColumnTotals: TOTALS[showColumnTotals],
        });
      engineRef.current = e;
      return e;
      // showTotals 변경은 아래 effect 에서 반영 — engine 재생성 금지
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // props 재적용 중에는 onLayoutChange 를 내지 않는다(사용자 조작만 통지)
    const applyingRef = useRef(false);
    useEffect(() => {
      applyingRef.current = true;
      engine.deferUpdate(() => {
        engine.itemsSource = itemsSource;
        // autoGenerateFields=false 라 필드 사전 등록 필요 — 축 필드 + 후보(extraFields) 합집합으로 등록.
        // ⚠ PivotFieldCollection.getField() 는 **header 명**으로 조회하므로 필드 키 = header(없으면 binding).
        //   같은 binding 을 다른 header 로 중복 등록할 수 있어야 한다(버킷 3종 → PERIOD) — 키는 header 로 유일.
        engine.fields.clear();
        const seen = new Set<string>();
        for (const def of [...rowFields, ...columnFields, ...valueFields, ...(extraFields ?? [])]) {
          const key = def.header ?? def.binding;
          if (seen.has(key)) continue;
          seen.add(key);
          const f = new PivotField(engine, def.binding, key);
          if (def.format) f.format = def.format;
          engine.fields.push(f);
        }
        applyFields(engine.rowFields, engine, rowFields, false);
        applyFields(engine.columnFields, engine, columnFields, false);
        applyFields(engine.valueFields, engine, valueFields, true);
        engine.showRowTotals = TOTALS[showRowTotals];
        engine.showColumnTotals = TOTALS[showColumnTotals];
      });
      applyingRef.current = false;
    }, [
      engine,
      itemsSource,
      rowFields,
      columnFields,
      valueFields,
      extraFields,
      showRowTotals,
      showColumnTotals,
    ]);

    // 사용자 축 편집(레일 DnD 등) 통지 — viewDefinitionChanged 는 props 재적용에도 발화하므로 applyingRef 로 가른다
    const onLayoutChangeRef = useRef(onLayoutChange);
    onLayoutChangeRef.current = onLayoutChange;
    useEffect(() => {
      const h = () => {
        if (applyingRef.current || engine.isUpdating) return;
        onLayoutChangeRef.current?.({
          rows: headersOf(engine.rowFields),
          columns: headersOf(engine.columnFields),
          filters: headersOf(engine.filterFields),
          values: headersOf(engine.valueFields),
        });
      };
      engine.viewDefinitionChanged.addHandler(h);
      return () => engine.viewDefinitionChanged.removeHandler(h);
    }, [engine]);

    // PivotGrid 는 FlexGrid 파생 — initialized 로 인스턴스를 잡아 xlsx 변환에 사용
    const gridInstanceRef = useRef<unknown>(null);
    const onGridInitRef = useRef(onGridInit);
    onGridInitRef.current = onGridInit;

    // ⭐ [E20260902-PIVOTCOUNT] 피벗 후 행수 통지 — **그리드가 실제로 그리는 행**을 센다.
    //
    // ⛔ 쓰면 안 되는 것 2가지 (2026-09-02 실측 반증):
    //   1) 화면의 원천 배열 길이(`data.length`) — 피벗과 무관해 축을 바꿔도 안 변한다.
    //      실측: Rows 를 DIVISION·MEASURE 2개로 줄여 **그리드가 5행**이 됐는데도 표기는 1,150 유지.
    //   2) `engine.pivotView.items.length` — 엔진 출력 뷰 항목 수이지 그리드 행수가 아니다.
    // ✅ `grid.rows.length` = 화면에 그려지는 행이자 `FlexGridXlsxConverter` 가 내보내는 바로 그 집합
    //    ⇒ 표기 = 그리드 = Excel 이 정의상 일치한다 (SALES div81 UI 1,150 vs Excel 1,144 불일치 해소).
    //
    // 트리거는 그리드의 **`updatedLayout`**(행·열 재생성 완료). `engine.updatedView` 시점에는 그리드가
    // 아직 행을 다시 만들기 전이라 직전 행수를 집는다 — 폭 자동맞춤이 같은 이유로 updatedLayout 을 쓴다.
    const countCbRef = useRef(onPivotRowCountChange);
    countCbRef.current = onPivotRowCountChange;
    const notifyRowCount = useRef<() => void>(() => {});
    notifyRowCount.current = () => {
      const g = gridInstanceRef.current as { rows?: { length: number } } | null;
      countCbRef.current?.(g?.rows?.length ?? 0);
    };
    // 언마운트(= 내부 PivotGrid dispose) 통지 — 화면이 dispose 된 인스턴스를 붙들고 columnHeaders 등에 접근하지 않게
    useEffect(
      () => () => {
        gridInstanceRef.current = null;
        onGridInitRef.current?.(null);
      },
      []
    );

    // ── 컬럼 폭 자동 최적화 (opt-in — DMF0035 사용자 지정 2026-08-20) ────────────────
    //   목적: 셀 데이터가 **2행(줄바꿈)으로 표시되지 않도록** 내용 전체가 1행에 들어가는 폭으로
    //   맞춘다. ①wordWrap 강제 해제(줄바꿈 자체 차단) ②행 축 헤더·값 컬럼 모두 내용 폭 기준
    //   autosize(상한 캡 없음 — 캡이 있으면 줄바꿈이 되살아난다) ③값 컬럼 하한만 유지.
    //   ⚠ 트리거는 **그리드의 updatedLayout** 이다 — PivotGrid 는 engine.updatedView 를 받아
    //   컬럼을 재생성하므로, engine 이벤트에 걸면 재생성이 폭을 덮어써 반영되지 않는다.
    //   autoSize 가 다시 updatedLayout 을 발화시키므로 busy 플래그로 재귀를 끊는다.
    const autoFitRef = useRef(autoFitColumns);
    autoFitRef.current = autoFitColumns;
    const fitBusyRef = useRef(false);
    const lastFitSignRef = useRef('');
    // [FITONCE 2026-08-27] 자동맞춤은 **피벗 뷰 갱신(engine.updatedView = 조회/필드 변경) 직후 1회**만.
    //   종전엔 updatedLayout 마다 폭 서명이 바뀌면 재맞춤해, 사용자가 컬럼을 드래그로 줄여도
    //   그 리사이즈가 updatedLayout 을 발화 → 즉시 최적화 폭으로 되돌아갔다(사용자 신고 2026-08-27).
    //   updatedView 에서 pending 을 세우고, 그 뒤 첫 updatedLayout 에서만 소비한다.
    const fitPendingRef = useRef(false);
    const fitColumns = useRef<() => void>(() => {});
    fitColumns.current = () => {
      const VALUE_MIN = 64;
      interface FitColumn {
        renderWidth: number;
        width: number | null;
        wordWrap: boolean;
      }
      interface FitGrid {
        deferUpdate: (fn: () => void) => void;
        autoSizeColumns: (first?: number, last?: number, header?: boolean, extra?: number) => void;
        columns: FitColumn[] & { length: number };
        rowHeaders: { columns: FitColumn[] & { length: number } };
      }
      const g = gridInstanceRef.current as FitGrid | null;
      if (!autoFitRef.current || fitBusyRef.current || !g || !g.columns.length) return;
      // 뷰 갱신으로 예약된 맞춤만 수행 — 사용자 컬럼 리사이즈가 만든 layout 이벤트는 무시(폭 보존)
      if (!fitPendingRef.current) return;
      fitPendingRef.current = false;
      // 이미 이 폭 구성으로 맞춰 둔 상태면 재적용하지 않는다 — autoSize→layout→autoSize 진동 차단
      const sign = (grid: FitGrid) =>
        [
          ...Array.from({ length: grid.rowHeaders.columns.length }, (_, i) =>
            Math.round(grid.rowHeaders.columns[i].renderWidth)
          ),
          '|',
          ...Array.from({ length: grid.columns.length }, (_, i) =>
            Math.round(grid.columns[i].renderWidth)
          ),
        ].join(',');
      if (sign(g) === lastFitSignRef.current) return;
      fitBusyRef.current = true;
      try {
        g.deferUpdate(() => {
          // 줄바꿈 차단 — autosize 는 단일행 기준 내용 폭을 계산한다
          for (let i = 0; i < g.columns.length; i += 1) g.columns[i].wordWrap = false;
          for (let i = 0; i < g.rowHeaders.columns.length; i += 1)
            g.rowHeaders.columns[i].wordWrap = false;
          g.autoSizeColumns(0, g.rowHeaders.columns.length - 1, true, 8);
          g.autoSizeColumns(0, g.columns.length - 1, false, 8);
          for (let i = 0; i < g.columns.length; i += 1) {
            const c = g.columns[i];
            if (c.renderWidth < VALUE_MIN) c.width = VALUE_MIN;
          }
        });
        lastFitSignRef.current = sign(g);
      } finally {
        // deferUpdate 가 유발한 layout 이벤트까지 흘려보낸 뒤 해제
        requestAnimationFrame(() => {
          fitBusyRef.current = false;
        });
      }
    };

    useImperativeHandle(ref, () => ({
      engine: engineRef.current,
      get grid() {
        return gridInstanceRef.current;
      },
      exportExcel: (fileName: string) => {
        // 동적 import 로 초기 번들 회피 (DataGrid 의 excel export 와 동일 컨버터)
        void import('@mescius/wijmo.grid.xlsx').then(({ FlexGridXlsxConverter }) => {
          const grid = gridInstanceRef.current;
          if (grid) {
            // ⭐ [E20260902-OLAPXLSALL] includeRowHeaders 필수 — PivotGrid 는 **행 축 필드(rowFields)를
            //   rowHeaders 패널**에 렌더하고(wijmo.olap `showRowFieldHeaders` = "top-left panel"),
            //   IFlexGridXlsxOptions.includeRowHeaders 기본값은 **false** 다. 따라서 이 옵션이 없으면
            //   xlsx 에는 columnFields 로 만들어진 **동적(기간) 컬럼만** 담기고 고정 행축 컬럼
            //   (VERSION_NO / MEASURE / ITEM_ID …)이 통째로 빠진다 (사용자 신고 2026-09-02
            //   "동적 COLUMN만 다운로드"). 두 패널을 모두 켜야 화면과 동일한 전체 표가 나온다.
            // ⭐ [E20260902-OLAPXLSALLCOL] includeColumns 로 **숨김 컬럼까지 전량 포함**한다.
            //   기본 동작은 `column.visible === false` 를 내보내지 않는다. PivotGrid 는 값 필드가
            //   1개일 때 값 헤더 열을 숨기거나(showValueFieldHeaders) 폭 계산 중 일부 열을
            //   숨김 상태로 두는 경우가 있어, 화면에 보이는 표와 xlsx 가 달라진다.
            //   사용자 요구 2026-09-02 "OLAP COLUMN 전체 보이도록 DOWNLOAD".
            FlexGridXlsxConverter.saveAsync(
              grid as never,
              {
                includeColumnHeaders: true,
                includeRowHeaders: true,
                includeColumns: () => true,
              },
              fileName
            );
          }
        });
      },
    }));

    // flex column 페이지(ViewContainer)의 Result 영역으로 직접 놓이는 경우 height:'100%' 는
    // 부모 명시 높이가 없어 0 으로 붕괴 — flex 채움을 기본으로 남은 높이를 차지한다.
    return (
      <div
        className={className}
        style={height ? { height, minHeight: 0 } : { flex: '1 1 0', minHeight: 0 }}
      >
        <PivotGrid
          itemsSource={engine}
          showSelectedHeaders='All'
          initialized={(g: unknown) => {
            gridInstanceRef.current = g as never;
            onGridInitRef.current?.(g);
            const grid = g as { updatedLayout?: { addHandler: (h: () => void) => void } };
            // 뷰 갱신(조회/필드 변경) → 맞춤 예약. PivotGrid 는 이 뒤 컬럼을 재생성하고 updatedLayout 을 낸다.
            engine.updatedView.addHandler(() => {
              fitPendingRef.current = true;
            });
            // 컬럼 재생성이 끝난 뒤(레이아웃 갱신 완료)에 폭을 잡는다 — §autoFitColumns 참조.
            //   사용자 리사이즈의 updatedLayout 은 pending 이 없어 통과(폭 유지) — [FITONCE]
            grid.updatedLayout?.addHandler(() => {
              fitColumns.current();
              // [E20260902-PIVOTCOUNT] 행 재생성이 끝난 이 시점의 grid.rows.length 가 곧 화면·Excel 행수
              notifyRowCount.current();
            });
          }}
          style={{ height: '100%' }}
        />
      </div>
    );
  }
);
OlapPivotGrid.displayName = 'OlapPivotGrid';
