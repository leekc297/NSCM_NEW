import { DataType } from '@mescius/wijmo';
import { CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useTabid } from '@shared/stores';

import { COMBO, INIT_SET, MENU_ID, SHEETS } from '../safety-stock.constants';
import type { MainRow } from '../safety-stock.types';
import { matchSiteByDivision } from '../utils/safety-stock.util';
import { isMainCellEditable } from '../utils/safetyStockEditLock';

// FROM/TO_YYYYMMDD 날짜 컬럼 — admin 메타가 FPDate 라 InputDate(달력) 에디터는 붙지만 dataType 미설정
//   (columnMapping getDataType→undefined) + 셀값이 "2026-06-01 00:00:00" 문자열(GET TO_DATE→BE
//   Jackson)이라 달력이 Date 에 못 묶여 비어 떴다. 페이지(rows)에서 Date 로 변환하고 여기서 두 컬럼의
//   dataType=Date + format='yyyy-MM-dd' 를 명시해 달력 편집·yyyy-MM-dd 표시를 함께 성립시킨다
//   (updatedLayout 마다 재적용 — columnGroups 재대입 리셋 대비, 이미 설정돼 있으면 건너뜀).
//   자매 SCP0127 PrecedeSafetyStockDayGrid 동형.
const DATE_COLUMNS = ['FROM_YYYYMMDD', 'TO_YYYYMMDD'];
const applyDateColumnTypes = (g: FlexGridType): void => {
  for (const binding of DATE_COLUMNS) {
    const col = g.getColumn(binding);
    if (!col) continue;
    if (col.dataType !== DataType.Date) col.dataType = DataType.Date;
    if (col.format !== 'yyyy-MM-dd') col.format = 'yyyy-MM-dd';
  }
};

interface Props {
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  itemModalOpen: boolean;
  onItemModalOpenChange: (open: boolean) => void;
}

/**
 * 메인 그리드 — design/03_grid-columns.md §3.1 white-list 재현. TO-BE 는 EditButton 편집모드
 * 토글(잠금 토글 절차)만 이식하지 않으며(§11 전 화면 공통 결정), 편집가능 여부는 신규/기존행
 * 구분 없이 컬럼 white-list 로 판정한다(design 01 §2 L108·L113) — DIVISION_ID·감사컬럼·ITEM_ID
 * 를 뺀 나머지는 기존행도 즉시 편집 가능(판정 로직은 utils/safetyStockEditLock.ts
 * `isMainCellEditable` 단일 진실원 — 공용 `isCellEditable` prop 부재, DataGrid 는 조건부 편집을
 * `beginningEdit`/`pastingCell` 로 위임).
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/01_layout.md §2 L9,
 * 02_search-combo.md §4.6 확정 재사용) — gridSignals#12 SetText 재현. buttonGuards#4·#5
 * (헤더 더블클릭 제외 / 잠금 시 팝업 차단)를 재현하되, TO-BE 는 "비편집모드" 축이 제거돼
 * (Edit 미이식) 헤더 더블클릭만 제외한다.
 *
 * 셀 콤보 5칼럼의 콤보 SQL_ID(Type/PlanGroup/ScmSite/StageAll/YesOrNo)는 `SCM_ADM_CMBO_SQL_M`
 * 전건 등록 확인(ora.py 실측). Division cascade(AS-IS SpdMain_EditStarting SetComboDataRow dt* 재현)는
 * 컬럼별로 둘로 나뉜다: PlanGroup/Stage 는 admin 메타 ATTRIBUTE2='DIVISION_ID:DIVISION_ID'
 * (05_register.sql)로 공용 DataGrid 가 행 DIVISION_ID 기준 자동 좁힘(표준 관례, SCP0001/SDM5010
 * 동일 — 화면 코드 없음). Site 는 AS-IS EE 분기(EE행→81/40/82, EE_*→81_*)가 ATTRIBUTE2 단순일치로
 * 표현 불가라 화면 코드(matchSiteByDivision)로 처리(아래 siteDataMap). VALUE_TYPE/VALID_YN 은
 * 전역(COVER_DAY_TYPE·Y/N)이라 cascade 없이 메타 경로 그대로 둔다.
 */
export const SafetyStockGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  itemModalOpen,
  onItemModalOpenChange,
}: Props) => {
  const dblClickRowRef = useRef<MainRow | undefined>(undefined);

  // AS-IS SpdMain_ClipboardPasted(.cs:1111~1131) 파생 1건 재현(goal.md v2 ④-6) — OPMZ_PLAN_GR_ID
  //   컬럼에 NAME 텍스트를 붙여넣으면 dtPlanGroup 에서 NAME 매칭으로 CODE 를 역조회해 치환한다.
  //   TO_YYYYMMDD 리셋 로직은 AS-IS SpdMain_EditChange 가 이벤트 미배선(dead code, ④-7)이라 이관
  //   대상이 아니다 — 재현하지 않는다.
  const [planGroups] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupsRef = useRef(planGroups);
  planGroupsRef.current = planGroups;

  // 셀 콤보 Division cascade —
  //   · PlanGroup/Stage: admin 메타 ATTRIBUTE2='DIVISION_ID:DIVISION_ID'(05_register.sql)로 공용
  //     DataGrid 가 행 DIVISION_ID 기준 자동 좁힘(표준 관례, SCP0001/SDM5010 동일). 화면 코드 없음.
  //   · Site: AS-IS RefreshSiteByDivision 의 EE 분기(EE행→81/40/82)는 ATTRIBUTE2 단순일치로 표현
  //     불가라 화면 코드로 처리(init o_rc2 + matchSiteByDivision). Form 과 같은 queryKey 라 init 호출은
  //     react-query 가 1회로 합친다.
  const tabId = useTabid();
  const initFilters = useMemo(() => ({ divisionId: '', scmSiteId: '' }), []);
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: initFilters,
    enabled: true,
  });
  const siteDataMap = useMemo(() => {
    const site = (initData?.[INIT_SET.SITE] ?? []).filter(r =>
      matchSiteByDivision(r.DIVISION_ID, divisionId)
    );
    return site.length ? new DataMap(site, 'CODE', 'NAME') : null;
  }, [initData, divisionId]);

  // 공용 DataGrid 가 콤보 응답마다 메타 dataMap 으로 재대입하므로 Site dataMap 을 updatedLayout 마다
  //   재부착한다([[wijmo-columngroups-recreate-datamap]], IntegrationPsiGrid.tsx LINE_ID 선례).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      if (!siteDataMap) return;
      const col = g.getColumn('SCM_SITE_ID');
      if (col && col.dataMap !== siteDataMap) col.dataMap = siteDataMap;
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, siteDataMap]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row || !isMainCellEditable(binding, row)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // gridSignals#14(.cs:1123~1125) — OPMZ_PLAN_GR_ID 붙여넣기 시 NAME->CODE 역조회 치환.
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) return;
      const pastedText = String(row.OPMZ_PLAN_GR_ID ?? '');
      if (pastedText === '') return;
      const matched = planGroupsRef.current?.find(item => item.NAME === pastedText);
      if (!matched || matched.CODE === pastedText) return;
      editTrackerRef.current?.storeChange(row, 'OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID, matched.CODE);
      row.OPMZ_PLAN_GR_ID = matched.CODE;
      sender.invalidate();
    };
    g.pastedCell.addHandler(pastedCellHandler as never);

    // 날짜 컬럼 dataType/format 적용 — 즉시 1회 + 레이아웃 재계산(컬럼 재생성)마다 재적용.
    applyDateColumnTypes(g);
    g.updatedLayout.addHandler(applyDateColumnTypes);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler as never);
        g.updatedLayout?.removeHandler(applyDateColumnTypes);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // buttonGuards#4 — 헤더 더블클릭 제외. buttonGuards#5 — AS-IS 가드 `IsLock(...) ||
  //   (CRUD_TYPE!=I) && !_isEditMode`(.cs:980)에서 `_isEditMode`(Edit 모드) 축은 §11 로 제거돼
  //   실질 가드가 사라진다(Edit 모드였으면 기존행도 팝업이 열렸음). TO-BE 는 ITEM_ID 가 편집가능
  //   컬럼인 한(isMainCellEditable) 신규/기존행 모두 더블클릭으로 Item 팝업을 연다(design 01 §2 L116).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    dblClickRowRef.current = row;
    onItemModalOpenChange(true);
  };

  return (
    <>
      <DataGrid<MainRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => onItemModalOpenChange(false)}
        preSearchParams={{ divisionId, scpModuleType: 'SCP0128' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            // gridSignals#12 SetText(e.Row, ITEM_ID, sItemId) 재현.
            editTrackerRef.current?.storeChange(row, 'ITEM_ID', row.ITEM_ID, items);
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          onItemModalOpenChange(false);
        }}
      />
    </>
  );
};
