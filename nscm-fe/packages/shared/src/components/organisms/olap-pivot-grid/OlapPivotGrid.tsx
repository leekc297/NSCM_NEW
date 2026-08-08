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
  /** 소계/총계 표시 (waterfall 은 기본 미표시 — AS-IS footer SUM 은 열 총계로 대체 가능). */
  showRowTotals?: 'None' | 'Subtotals' | 'GrandTotals';
  showColumnTotals?: 'None' | 'Subtotals' | 'GrandTotals';
  /** 그리드 높이 CSS 값. 미지정 시 flex 채움(flex:1 1 0 — ViewContainer flex column 표준). */
  height?: string;
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
    const field = engine.fields.getField(def.binding);
    if (!field) continue;
    if (def.header) field.header = def.header;
    if (def.format) field.format = def.format;
    if (isValue) field.aggregate = AGGS[def.aggregate ?? 'Sum'];
    collection.push(field);
  }
};

export const OlapPivotGrid = forwardRef<OlapPivotGridRef, OlapPivotGridProps>(
  (
    {
      itemsSource,
      rowFields,
      columnFields,
      valueFields,
      showRowTotals = 'None',
      showColumnTotals = 'None',
      height,
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

    useEffect(() => {
      engine.deferUpdate(() => {
        engine.itemsSource = itemsSource;
        // autoGenerateFields=false 라 필드 사전 등록 필요 — 바인딩 합집합으로 등록.
        // ⚠ PivotFieldCollection.getField() 는 **header 명**으로 조회하므로 등록 시 header=binding
        //   으로 두고, 표시 라벨은 applyFields 에서 필드 확보 후에 입힌다 (header=라벨로 등록하면
        //   binding 조회가 전부 실패 → 행/열/값 필드 0 → 그리드 백지).
        engine.fields.clear();
        for (const def of [...rowFields, ...columnFields, ...valueFields]) {
          engine.fields.push(new PivotField(engine, def.binding, def.binding));
        }
        applyFields(engine.rowFields, engine, rowFields, false);
        applyFields(engine.columnFields, engine, columnFields, false);
        applyFields(engine.valueFields, engine, valueFields, true);
        engine.showRowTotals = TOTALS[showRowTotals];
        engine.showColumnTotals = TOTALS[showColumnTotals];
      });
    }, [engine, itemsSource, rowFields, columnFields, valueFields, showRowTotals, showColumnTotals]);

    // PivotGrid 는 FlexGrid 파생 — initialized 로 인스턴스를 잡아 xlsx 변환에 사용
    const gridInstanceRef = useRef<unknown>(null);

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
            FlexGridXlsxConverter.saveAsync(
              grid as never,
              { includeColumnHeaders: true },
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
          }}
          style={{ height: '100%' }}
        />
      </div>
    );
  }
);
OlapPivotGrid.displayName = 'OlapPivotGrid';

