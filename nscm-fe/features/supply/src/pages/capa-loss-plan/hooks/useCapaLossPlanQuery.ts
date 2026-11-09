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
  /** 편집권한 — `canEdit = hasButton('EDIT')`. 기간 컬럼 폭 2모드(80/140) 선택에만 쓴다. */
  isEditMode: boolean;
}

/** 응답 객체에서 이름으로 배열 커서를 안전하게 집는다(배열 아니면 빈 배열) — 모듈 스코프라 memo dep 아님. */
const pickCursor = (src: Record<string, unknown> | undefined, name: string): unknown[] =>
  Array.isArray(src?.[name]) ? (src?.[name] as unknown[]) : [];

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
 * `PKG_SCP0106` 배포 후 응답은 프레임워크 커서(`o_result_cursor`/`DATARESULT`)가 섞여 오고 객체 키
 * 순서도 보장되지 않으므로, 아래는 **표준 OUT 커서 이름**(`o_rc1..o_rc4`)으로 집는다. RS 매핑은
 * 시트별로 갈린다(03 §4.2) — grid=o_rc1 고정, measure/dayCnt 는 CURRENT 와 LINE 이 다름.
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

  // 배포된 SP 응답은 o_result_cursor(RESULT_CD='S')·DATARESULT 프레임워크 커서가 섞여 오고 객체 키
  //   순서도 보장되지 않는다 → 예전의 "배열을 순서대로 집기(cursors[0])" 는 첫 배열이 o_result_cursor 라
  //   그리드가 결과코드 1행만 받는다(SCP0106 실사고 2026-11-03). 설계 03 §4.2(hook #80)대로 **커서 이름**
  //   으로 집는다. RS 매핑(시트별): grid=RS1=o_rc1(항상) / CURRENT·CUTOFF_MODEL: measure=o_rc2·dayCnt=o_rc3
  //   / LINE: prodCapaD=o_rc2·measure=o_rc3·dayCnt=o_rc4(measure RS2↔RS3 이 시트별로 갈림).
  const data = dataQuery.data as Record<string, unknown> | undefined;
  const isLineSheet = sheetType === SHEET_TYPE.LINE;

  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(nscm-patterns §5-4).
  const rows = useMemo<Scp0106Row[]>(() => pickCursor(data, 'o_rc1') as Scp0106Row[], [data]);
  const measureRows = useMemo<MeasureTargetRow[]>(
    () => pickCursor(data, isLineSheet ? 'o_rc3' : 'o_rc2') as MeasureTargetRow[],
    [data, isLineSheet]
  );
  const dayCountRows = useMemo<DayCountRow[]>(
    () => pickCursor(data, isLineSheet ? 'o_rc4' : 'o_rc3') as DayCountRow[],
    [data, isLineSheet]
  );
  const prodCapaDRows = useMemo<ProdCapaDRow[]>(
    () => (isLineSheet ? (pickCursor(data, 'o_rc2') as ProdCapaDRow[]) : []),
    [data, isLineSheet]
  );

  const spreadTitleRows = useMemo<SpreadTitleRow[]>(() => {
    const td = spreadTitleQuery.data as Record<string, unknown> | undefined;
    // 동적 기간 헤더도 이름 기반(o_rc1) — 첫 배열(o_result_cursor, RESULT_CD)을 집으면 title 이 안 잡혀
    //   기간컬럼 0 개가 된다(그리드와 동일 커서 버그, 2026-11-03).
    return Array.isArray(td?.o_rc1) ? (td?.o_rc1 as SpreadTitleRow[]) : [];
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
