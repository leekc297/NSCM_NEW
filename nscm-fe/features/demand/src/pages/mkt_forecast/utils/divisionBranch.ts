import { DIVISION, type MainColumnMeta } from '../mkt-forecast-master.constants';

// AS-IS DMF0003_1_MktFcst.cs Division 3-way 분기 (validation.md 114건):
//   - Div 40 (Mobility & IT) : 8주 관리, Weekly Bucket 기본, W_tag column editable
//                              Division40 / Customer40 / ScmSiteId40 / ItemId40 visible
//                              MEASURE 'MKT_FCST_RP' editable only (8주 이내 cell)
//   - Div 81 (ESS)            : PlantSiteId 필수, NewFlag visible, VMI_STD_DIO visible
//                              End Customer 단위 세분화 (NewFlag, BUCKET — 2023-11 미완성)
//                              계획구간 MKT FCST 입력 Block (2020-12-16 해제)
//   - Div 82 (Automotive)     : JV Planner 권한 필수, INCOTERMS 권한 정리 (2021-11-18)
//                              CELL_TYPE / Cell/Module / Cell/Car / Module/Car column 표시
//                              FCST_TYPE 권한 정리 (2021-11-02)

export type DivisionVisibility = {
  showDivision40Cols: boolean;
  showEssNewFlag: boolean;
  showPlantSiteRequired: boolean;
  showCellType: boolean;
  showJvPlannerOnly: boolean;
  editableWeeklyOnly: boolean;
  defaultBucket: 'D' | 'W' | 'M';
};

export const getDivisionVisibility = (divisionId: string): DivisionVisibility => {
  const prefix = divisionId.substring(0, 2);

  if (divisionId === DIVISION.MOBILITY) {
    return {
      showDivision40Cols: true,
      showEssNewFlag: false,
      showPlantSiteRequired: false,
      showCellType: false,
      showJvPlannerOnly: false,
      editableWeeklyOnly: true,
      defaultBucket: 'W',
    };
  }

  if (prefix === DIVISION.ESS) {
    return {
      showDivision40Cols: false,
      showEssNewFlag: true,
      showPlantSiteRequired: true,
      showCellType: false,
      showJvPlannerOnly: false,
      editableWeeklyOnly: false,
      defaultBucket: 'M',
    };
  }

  if (divisionId === DIVISION.AUTOMOTIVE) {
    return {
      showDivision40Cols: false,
      showEssNewFlag: false,
      showPlantSiteRequired: false,
      showCellType: true,
      showJvPlannerOnly: true,
      editableWeeklyOnly: false,
      defaultBucket: 'M',
    };
  }

  return {
    showDivision40Cols: false,
    showEssNewFlag: false,
    showPlantSiteRequired: false,
    showCellType: false,
    showJvPlannerOnly: false,
    editableWeeklyOnly: false,
    defaultBucket: 'W',
  };
};

// Division 별 visible columns 필터
export const filterColumnsByDivision = (
  columns: MainColumnMeta[],
  divisionId: string,
): MainColumnMeta[] => {
  const vis = getDivisionVisibility(divisionId);

  return columns.filter(col => {
    // 40 전용 columns (Division40 / Customer40 / ScmSiteId40 / ItemId40)
    if (col.key.endsWith('40')) {
      return vis.showDivision40Cols;
    }
    // CELL_TYPE — Div 82 전용
    if (col.key === 'CELL_TYPE') {
      return vis.showCellType;
    }
    // PLANT_SITE_ID — Div 81 visible (다른 div 도 표시되지만 81 만 필수)
    // VMI_YN — Div 81 ESS 만 표시
    if (col.key === 'VMI_YN') {
      return vis.showEssNewFlag;
    }
    // 기본: visible: false 가 아닌 모든 col 표시
    return col.visible !== false;
  });
};
