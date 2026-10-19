// SCP0125 신규행 기본값 N1~N4 — 순수함수(design 03_grid-columns.md §3.2 / gridSignals G17·G23·G29·G34).
//
// division 은 **확정 `searchParams`** 에서 온다 — 조회 전 `filters` 는 비어 있어 그쪽을 쓰면
//   하드코딩 폴백으로 새는 사고가 난다(CommonCheckList Division 절 / nscm-patterns §5-15).
//
// CUTOFF 기준일은 B2 결정(goal.md §7)에 따라 **표시 위젯과 같은 값**이다 — AS-IS 는 표시일 /
//   조회 기준일 / 신규행 CUTOFF 가 4지점에서 어긋나는데(§5 K2 / §6 U2) 그 결함을 재현하지 않는다.
//   단 `Elec. Demand` 는 AS-IS 도 GM 분기가 없어 **항상 주단위 콤보**를 쓴다(cs:788) → 그대로 유지.

import type { ComboResponse } from '@foundation/models';

import {
  CHG_TYPE,
  COL,
  DIVISION_CODE,
  ELEC_DEMAND_PLAN_TYPE,
  NOT_APPLICABLE,
  TABS,
} from '../workbench.constants';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

export interface InsertContext {
  divisionId: string;
  versionNo: string;
  /** 표시 위젯과 일치하는 기준일(주단위 콤보 또는 일단위 DatePicker) — B2 단일 원천 */
  planStartYyyymmdd: string;
  /** 주단위 콤보 값 — `Elec. Demand` 의 `PLAN_START_YYYYMMDD` 전용(GM 분기 없음) */
  planStartWeekly: string;
  /** `init` O_RC1 — MKT FCST 신규행 CUTOFF 를 선택 Version 의 YYYYMMDD 에서 가져온다(F10) */
  versionAll: ComboResponse[];
}

export const buildInsertRow = (tab: TABS, ctx: InsertContext): Record<string, string> => {
  const row: Record<string, string> = {
    [COL.DIVISION_ID]: ctx.divisionId,
    [COL.CHG_TYPE]: CHG_TYPE.NEW,
  };

  switch (tab) {
    case TABS.MKT_FCST: {
      // N1 (cs:729~753)
      const version = ctx.versionAll.find(
        item => str(item[COL.DIVISION_ID]) === ctx.divisionId && str(item.CODE) === ctx.versionNo
      );
      row[COL.VERSION_NO] = ctx.versionNo;
      row[COL.CUTOFF_YYYYMMDD] = str(version?.[COL.YYYYMMDD]);
      // G16 — division 이 소형(40)이 아니면 Cell Prod site 를 '-' 고정(셀 잠금은 editLock 담당).
      if (ctx.divisionId !== DIVISION_CODE.SMALL) row[COL.CELL_PROD_SITE_ID] = NOT_APPLICABLE;
      break;
    }
    case TABS.STOCK:
    case TABS.STOCK_ELEC:
      // N2 (cs:756~785)
      row[COL.CUTOFF_YYYYMMDD] = ctx.planStartYyyymmdd;
      break;
    case TABS.ELEC_DEMAND:
      // N3 (cs:786~801)
      row[COL.PLAN_START_YYYYMMDD] = ctx.planStartWeekly;
      row[COL.PLAN_TYPE] = ELEC_DEMAND_PLAN_TYPE;
      break;
    case TABS.STOCK_2ND_OCV:
      // N4 (cs:804~833)
      row[COL.CUTOFF_YYYYMMDD] = ctx.planStartYyyymmdd;
      break;
  }

  return row;
};
