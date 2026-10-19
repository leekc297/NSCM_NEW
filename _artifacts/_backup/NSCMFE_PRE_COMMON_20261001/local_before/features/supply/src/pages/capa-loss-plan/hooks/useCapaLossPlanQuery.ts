import { useMemo } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { useTabProcQuery } from '@shared/hooks';

import {
  MENU_ID,
  PROGRESS_STATUS,
  SHEETS,
  SHEET_TYPE,
  type GridSheet,
  type SheetType,
} from '../capa-loss-plan.constants';
import type {
  DayCountRow,
  FiltersBySheet,
  MeasureTargetRow,
  Scp0106Row,
  SpreadTitleRow,
} from '../capa-loss-plan.types';
import {
  buildPeriodColumns,
  periodColumnSignature,
  toPeriodColumnNames,
} from '../utils/capaLossPlan.dateColumns';
import { buildEditableMeasures, buildScpPlanFixedColumns, readScpPlanRange } from '../utils/capaLossPlan.editLock';
import {
  buildDayCountMap,
  buildProdCapaDMap,
  type DayCountEntry,
  type ProdCapaDRow,
} from '../utils/capaLossPlan.recalc';

interface UseCapaLossPlanQueryParams {
  tabId: string;
  filters: FiltersBySheet;
  /** 확정 조회조건(`applied ?? searchCondition`) 기준 시트 — 조회 후 조건만 바꿔도 따라가지 않는다. */
  sheetName: GridSheet;
  progressStatus: string;
  sheetType: SheetType;
  isEditMode: boolean;
}

export interface CapaLossPlanQueryResult {
  rows: Scp0106Row[];
  periodColumns: FlexGridColumnConfig[];
  periodColumnNames: string[];
  /** GET measure 결과셋의 `*_TARGET_YN` 에서 만든 편집가능 measure 집합(03 V-23). */
  editableMeasures: Set<string>;
  /** 1차 컷오프 x LINE 의 생산확정기간 잠금 컬럼. 그 외 시트는 빈 집합(03 R-06). */
  scpPlanFixedColumns: Set<string>;
  /** 기간 키 -> 일수. 실패 시 소비부가 기본 30 으로 떨어진다(V-41). */
  dayCounts: Map<string, DayCountEntry>;
  /** LINE 재계산의 DDN 분모(별도 결과셋). */
  prodCapaD: Map<string, number>;
  refetch: () => void;
}

/**
 * 조회 2종(데이터 + 동적 기간 헤더)과 그 파생값의 단일 출처.
 * Page 는 조립만 하므로(구조 룰 #9) 결과셋 해체·파생 계산을 여기로 분리했다.
 *
 * **결과셋 개수가 상태별로 2~4개 가변**이다(00 §5 영역3, hook #80):
 *   CURRENT/PRE 3(data/measure/dayCnt) · CUTOFF_MODEL 2 · LINE 3~4(+prodCapaD).
 * 커서 **이름**은 `PKG_SCP0106` 배포 후 `all_arguments` 로 확정되므로(현재 미배포) 이름에 의존하지
 * 않고 **응답 객체의 배열 값을 순서대로** 집는다. 배포 후 표준 이름(`o_rc1..`)이면 순서가 같다.
 * 배포 시 이 함수 1곳만 이름 기반으로 바꾸면 된다 — 04 리포트 §9 #80 참조.
 */
export const useCapaLossPlanQuery = ({
  tabId,
  filters,
  sheetName,
  progressStatus,
  sheetType,
  isEditMode,
}: UseCapaLossPlanQueryParams): CapaLossPlanQueryResult => {
  const dataQuery = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName,
    tabId,
    filters: filters[sheetName],
    enabled: !!filters[sheetName],
  });
  // 동적 기간 헤더 — 그리드 데이터와 별도 시트로 조회한다(03 §2.1).
  const spreadTitleQuery = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const cursors = useMemo<unknown[][]>(() => {
    const data = dataQuery.data as Record<string, unknown> | undefined;
    if (!data) return [];
    return Object.values(data).filter(Array.isArray) as unknown[][];
  }, [dataQuery.data]);

  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(nscm-patterns §5-4).
  const rows = useMemo<Scp0106Row[]>(() => (cursors[0] ?? []) as Scp0106Row[], [cursors]);
  const measureRows = useMemo<MeasureTargetRow[]>(
    () => (cursors[1] ?? []) as MeasureTargetRow[],
    [cursors]
  );
  const dayCountRows = useMemo<DayCountRow[]>(() => (cursors[2] ?? []) as DayCountRow[], [cursors]);
  const prodCapaDRows = useMemo<ProdCapaDRow[]>(
    () => (cursors[3] ?? []) as ProdCapaDRow[],
    [cursors]
  );

  const spreadTitleRows = useMemo<SpreadTitleRow[]>(() => {
    const data = spreadTitleQuery.data as Record<string, unknown> | undefined;
    const first = data ? (Object.values(data).find(Array.isArray) as SpreadTitleRow[]) : undefined;
    return first ?? [];
  }, [spreadTitleQuery.data]);

  // 컬럼 재조립 억제 — 내용 서명이 같으면 같은 참조를 유지한다(Wijmo 전 컬럼 재생성 방지).
  const periodSignature = periodColumnSignature(spreadTitleRows);
  const periodColumns = useMemo(
    () => buildPeriodColumns(spreadTitleRows, isEditMode),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature, isEditMode]
  );
  const periodColumnNames = useMemo(
    () => toPeriodColumnNames(spreadTitleRows),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature]
  );

  const editableMeasures = useMemo(
    () => buildEditableMeasures(measureRows, progressStatus, sheetType),
    [measureRows, progressStatus, sheetType]
  );

  const scpPlanFixedColumns = useMemo(() => {
    const isFirstLine =
      progressStatus === PROGRESS_STATUS.FIRST_CUTOFF && sheetType === SHEET_TYPE.LINE;
    if (!isFirstLine) return new Set<string>();
    const { startYm, endYm } = readScpPlanRange(rows);
    return buildScpPlanFixedColumns(periodColumnNames, startYm, endYm);
  }, [progressStatus, sheetType, rows, periodColumnNames]);

  const dayCounts = useMemo(() => buildDayCountMap(dayCountRows), [dayCountRows]);
  const prodCapaD = useMemo(() => buildProdCapaDMap(prodCapaDRows), [prodCapaDRows]);

  return {
    rows,
    periodColumns,
    periodColumnNames,
    editableMeasures,
    scpPlanFixedColumns,
    dayCounts,
    prodCapaD,
    // 저장 성공 후 재조회 — filters 가 그대로라 refetch 가 맞다(nscm-patterns §5-1 예외).
    refetch: () => void dataQuery.refetch?.(),
  };
};
