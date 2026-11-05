import { DataType } from '@mescius/wijmo';
import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { useWaterfallShipmentPlanSemiStore } from '../useWaterfallShipmentPlanSemiStore';
import { BUCKET_TYPE, kindOf, MENU_ID } from '../waterfall-shipment-plan-semi.constants';
import type { SpreadTitleRow, WaterfallRow } from '../waterfall-shipment-plan-semi.types';

// SCP0018 메인 그리드 — AS-IS spdMain('Waterfall Shipment Plan' 단일 시트) 1:1 조회 전용.
//   정적 24열 = SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0018', 03_grid-columns.md §1) 하드코딩 금지.
//   동적 pivot D_/W_/M_/B_(hidden)/ISO = 캘린더 SP(PKG_SCP0009, 미배포) 응답 기반 (§2).
//   Bucket×Sum visible 매트릭스(§2.5) — 서버 재조회 없이 클라 컬럼 visible 토글만 수행.
//   Set_SumValues 파생(D_→W_/M_ 재계산, INVENTORY=잔고 마지막값) 은 §3.2 — BE/SP 미배포 상태라
//   이 게이트는 SP 응답이 실제로 들어올 때까지 실행 검증 불가(ERROR, 04_react-gap.md 명시).

interface DynColMeta {
  binding: string;
  kind: 'D' | 'W' | 'M' | 'B';
  large: string;
  small: string;
  leaf: string;
  mmdd: string;
  dayCode: string;
}

interface WaterfallShipmentPlanSemiGridProps {
  gridRef: MutableRefObject<FlexGrid<WaterfallRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: WaterfallRow[];
  spreadTitle: SpreadTitleRow[];
}

// 01_layout.md §2 트리거A/B, 03_grid-columns.md §3.1 — Division 접두 EE 여부로 3컬럼 visible 토글.
//   admin staticColumns 의 다른 속성(폭/정렬 등)은 그대로 두고 이 3컬럼의 visible 만 화면 로컬 규칙으로
//   덮어쓴다 — 나머지 컬럼은 admin 메타 리터럴을 그대로 보존(CLAUDE.md §2 항목4).
const EE_TOGGLE_COLUMNS = ['ELECTRODE_TYPE', 'ORIGIN_FROM_DIVISION_ID', 'ORIGIN_TO_DIVISION_ID'];

export const WaterfallShipmentPlanSemiGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
}: WaterfallShipmentPlanSemiGridProps) => {
  const searchParams = useWaterfallShipmentPlanSemiStore(state => state.searchParams);
  const rawStaticColumns = useWaterfallShipmentPlanSemiStore(state => state.staticColumns);

  const bucket = searchParams.bucket;
  const isWeeklyIso = bucket === BUCKET_TYPE.WEEKLY_ISO;
  const isEE = searchParams.divisionId.trim().toUpperCase().startsWith('EE');

  // 그리드 재생성 4트리거(Form_Load/조회/Measure팝업OK/Bucket변경) 마다 재계산 — mount 1회 고정 금지.
  const staticColumns = useMemo(
    () =>
      rawStaticColumns.map(col =>
        EE_TOGGLE_COLUMNS.includes(col.colNm) ? { ...col, visible: isEE } : col
      ),
    [rawStaticColumns, isEE]
  );

  // 동적 pivot 컬럼 메타 — 03_grid-columns.md §2.2 (SP 컬럼 계약, 확인 필요 — SP 본문 ERROR).
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    return (spreadTitle ?? [])
      .map(r => {
        const binding = String(r.COLUMN_NAME ?? '');
        const kind = kindOf(binding);
        if (!kind) return null;
        return {
          binding,
          kind,
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          mmdd: String(r.MMDD_LABEL_NAME ?? ''),
          dayCode: String(r.DAY_CODE ?? '').toUpperCase(),
        } as DynColMeta;
      })
      .filter((m): m is DynColMeta => m !== null);
  }, [spreadTitle]);

  // Bucket×Sum visible 매트릭스 — 03_grid-columns.md §2.5 표 그대로.
  const dynVisible = (kind: DynColMeta['kind']): boolean => {
    if (kind === 'B') return false; // B_ 숨김 헬퍼 컬럼 — Bucket 전환과 무관하게 항상 숨김
    if (isWeeklyIso) return kind === 'W'; // WEEKLY_ISO: D_/M_ 항상 숨김, W_(ISO)만 표시
    if (bucket === BUCKET_TYPE.WEEKLY)
      return kind === 'W' || (kind === 'M' && searchParams.isSumChecked);
    if (bucket === BUCKET_TYPE.MONTHLY) return kind === 'M';
    // DAILY(기본) — D_ 항상 표시, W_/M_ 은 Sum 체크 연동
    return kind === 'D' || ((kind === 'W' || kind === 'M') && searchParams.isSumChecked);
  };

  // 동적 컬럼 nested(3단 — ISO: MMDD/주차/SUM, NotISO: 월/주/SUM) — 03_grid-columns.md §2.3/2.4.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    if (isWeeklyIso) {
      return dynColMetas
        .filter(m => m.kind === 'W')
        .map(m => ({
          header: m.mmdd || m.binding,
          align: 'center',
          allowSorting: false,
          columns: [
            {
              header: m.leaf || 'SUM',
              align: 'center',
              allowSorting: false,
              columns: [
                {
                  binding: m.binding,
                  header: 'SUM',
                  align: 'right',
                  format: 'n0',
                  isReadOnly: true,
                  allowSorting: false,
                  visible: dynVisible(m.kind),
                },
              ],
            },
          ],
        }));
    }
    const largeMap = new Map<string, { label: string; subs: Map<string, DynColMeta[]> }>();
    dynColMetas.forEach(m => {
      const ymKey = m.large || m.binding.slice(2, 8);
      let group = largeMap.get(ymKey);
      if (!group) {
        group = { label: m.large || ymKey, subs: new Map() };
        largeMap.set(ymKey, group);
      }
      const subKey = m.kind === 'M' ? 'SUM' : m.small || 'SUM';
      if (!group.subs.has(subKey)) group.subs.set(subKey, []);
      group.subs.get(subKey)?.push(m);
    });
    return [...largeMap.values()].map(group => ({
      header: group.label,
      align: 'center',
      allowSorting: false,
      columns: [...group.subs.entries()].map(([subLabel, metas]) => ({
        header: subLabel,
        align: 'center',
        allowSorting: false,
        columns: metas.map(m => ({
          binding: m.binding,
          // B_ 컬럼은 항상 숨김 텍스트 — 나머지는 리프 라벨.
          header: m.kind === 'D' ? m.leaf || m.binding : 'SUM',
          align: m.kind === 'B' ? 'left' : 'right',
          format: m.kind === 'B' ? undefined : 'n0',
          dataType: m.kind === 'B' ? DataType.String : undefined,
          isReadOnly: true,
          allowSorting: false,
          visible: dynVisible(m.kind),
          width: m.kind === 'B' ? 0 : undefined,
        })),
      })),
    }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, isWeeklyIso, bucket, searchParams.isSumChecked]);

  // Bucket 전환 시(§2.5 매트릭스 재계산) — 컬럼 visible 재적용 트리거.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.columns.forEach(col => {
      const kind = kindOf(col.binding ?? '');
      if (!kind) return;
      col.visible = dynVisible(kind);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, dynamicColumns, bucket, searchParams.isSumChecked]);

  return (
    <DataGrid<WaterfallRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      isReadOnly
      // 03_grid-columns.md §3.3 — SmartColMerge(프레임워크 공통, 4트리거) 대응. 정확한 병합 대상열은
      //   확인 필요(FIXED_FLAG=Y measure_label 컬럼 + 좌측 키컬럼군 추정, §6#6) — 잠정 All 적용.
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useHotkey
    />
  );
};
