import { DataType, toggleClass } from '@mescius/wijmo';
import { CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useTabid } from '@shared/stores';

import { COMBO, INIT_SET, MENU_ID, MSG, SHEETS } from '../demand-exception.constants';
import type { MainRow } from '../demand-exception.types';
import { toYmd8 } from '../utils/demand-exception.util';
import { isMainCellEditable } from '../utils/demandExceptionEditLock';
import { matchSiteByDivision } from '../utils/demandExceptionSiteCascade';

// FROM/TO_YYYYMMDD 날짜 컬럼 — admin 메타가 FPDate 라 InputDate(달력) 에디터는 붙지만 dataType 미설정
//   (columnMapping getDataType→undefined) + 셀값이 "2026-06-01 00:00:00" 문자열(GET TO_DATE→BE
//   Jackson)이라 달력이 Date 에 못 묶여 비어 떴다. 페이지(rows)에서 Date 로 변환(toGridDate)하고 여기서
//   두 컬럼의 dataType=Date + format='yyyy-MM-dd' 를 명시해 'yyyy-MM-dd' 표시·달력 편집을 함께
//   성립시킨다(updatedLayout 마다 재적용 — 컬럼 재생성 리셋 대비). 형제 SCP0127/SCP0128 동형.
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
 * 메인 그리드 — design/03_grid-columns.md §3 white-list 재현. TO-BE 는 EditButton 편집모드 토글(잠금
 * 토글 절차)만 이식하지 않으며(asis_to_tobe.md §11), 편집가능 여부는 신규/기존행 구분 없이 컬럼
 * white-list 로 판정한다 — 별도 Edit 버튼 없이 기존행도 바로 수정 가능(판정 로직은
 * utils/demandExceptionEditLock.ts `isMainCellEditable` 단일 진실원 — 공용 `isCellEditable` prop
 * 부재, DataGrid 는 조건부 편집을 `beginningEdit`/`pastingCell` 로 위임). 형제 SCP0128 과 동일 구조.
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/02_search-combo.md §4.6 확정
 * 재사용) — gridSignals#13 SetText 재현. buttonGuards#4·#5(헤더 더블클릭 제외 / 잠금 시 팝업 차단)를
 * 재현하되, TO-BE 는 "비편집모드" 축이 제거돼(Edit 미이식) 헤더 더블클릭만 제외한다(신규/기존행 공통).
 *
 * 날짜 역전 리셋(gridSignals#14, From>To 시 TO_YYYYMMDD 공백 리셋)은 cellEditEnded 에서 재현.
 *
 * 셀 콤보 SQL_ID 전건 등록 확인(ora.py 실측 2026-10-13): OPMZ_PLAN_GR_ID=PlanGroup / SCM_SITE_ID=
 * ScmSite / STAGE=StageDemandException(AS-IS o_rc7 ATTRIBUTE3='Y' 신버전) / VALID_YN·STOCK_EXCEPTION=
 * YesOrNo. Division cascade 는 컬럼별로 둘로 나뉜다: PlanGroup/Stage 는 admin 메타 ATTRIBUTE2=
 * 'DIVISION_ID:DIVISION_ID'(SCP0129_GRID_COMBO_CASCADE_* register.sql)로 공용 DataGrid 가 행
 * DIVISION_ID 기준 자동 좁힘(화면 코드 없음). Site 는 AS-IS EE 분기라 화면 코드(아래 siteDataMap)로
 * 처리. VALID_YN/STOCK_EXCEPTION 은 전역(Y/N)이라 cascade 없이 메타 경로 그대로 둔다.
 *
 * SmartColMerge(.cs:868) — AS-IS `siMain.SmartColMerge()` 무인자라 병합 대상 컬럼이 코드상 드러나지
 * 않는다(SCP0128 프레임워크 분석상 COLMERGE 컬럼 부재 → 런타임 no-op 가능성 높음, 미검증). 임의 컬럼
 * 추정 금지 — `allowMerging` 미배선 유지(확인 필요, design-gap G-02).
 *
 * ClipboardPasted(.cs:1065~1085) — OPMZ_PLAN_GR_ID NAME→CODE 역조회는 아래 pastedCell 핸들러로 재현.
 *
 * 편집가능 셀 시각 강조(`wj-cell-editable`) — 공용 `formatItem`은 컬럼메타 INPUT_TP_CD(M/O)로
 * 판정하므로 DIVISION_ID(메타 M 이나 white-list 잠금)·ITEM_ID(팝업 전용)도 편집 가능처럼 표시된다.
 * 화면이 `isMainCellEditable` 단일 진실원으로 자체 `formatItem` 핸들러를 뒤에 덧대 두 컬럼의
 * 잘못된 강조를 끈다(addHandler 등록 순서상 이 핸들러가 공용 핸들러 뒤에 실행돼 재설정).
 */
export const DemandExceptionGrid = ({
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
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  // AS-IS SpdMain_ClipboardPasted(.cs:1065~1085) 재현 — OPMZ_PLAN_GR_ID 셀에 Plan Group NAME 을
  //   붙여넣으면 CMBO `PlanGroup`(CODE/NAME) 에서 NAME 매칭으로 CODE 를 역조회해 치환한다. 형제
  //   SCP0128 SafetyStockGrid pastedCell 과 동형.
  const [planGroups] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupsRef = useRef(planGroups);
  planGroupsRef.current = planGroups;

  // 셀 콤보 Division cascade —
  //   · OPMZ_PLAN_GR_ID(PlanGroup)/STAGE(StageDemandException): admin 메타 ATTRIBUTE2=
  //     'DIVISION_ID:DIVISION_ID'(_deploy_packages/SCP0129_GRID_COMBO_CASCADE_*)로 공용 DataGrid 가
  //     행 DIVISION_ID 기준 자동 좁힘(화면 코드 없음, 표준 관례 — SCP0001/SDM5010/SCP0128 동일).
  //   · SCM_SITE_ID(ScmSite): AS-IS RefreshSiteByDivision 의 EE 분기(EE→81/40/82, EE_*→81_*)는
  //     ATTRIBUTE2 단순일치로 표현 불가라 화면 코드로 처리(init o_rc2 + matchSiteByDivision). Form 과
  //     같은 queryKey 라 init 호출은 react-query 가 1회로 합친다. 형제 SCP0128 SafetyStockGrid 동형.
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
  //   재부착한다([[wijmo-columngroups-recreate-datamap]], SafetyStockGrid 선례).
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

    // 공용 formatItem 은 컬럼메타 INPUT_TP_CD(M/O)로 wj-cell-editable 을 판정하므로 DIVISION_ID
    //   (메타 M 이나 white-list 잠금)·ITEM_ID(팝업 전용)도 편집 가능처럼 강조된다. 화면이 같은 단일
    //   진실원(isMainCellEditable)으로 재판정해 두 컬럼의 강조를 끈다(DataGrid 가 공용 핸들러를 먼저
    //   붙이므로 이 핸들러가 나중에 같은 클래스를 재설정 — addHandler 는 등록 순서대로 실행됨).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      toggleClass(e.cell, 'wj-cell-editable', isMainCellEditable(binding, row));
    };
    g.formatItem.addHandler(formatItemHandler);

    // From>To 역전 시 TO_YYYYMMDD 공백 리셋. FROM/TO 는 그리드에서 Date(FPDate)라 String() 사전식
    //   비교(요일명까지 포함된 "Tue Jun 10 2025…")는 오탐을 낸다 — toYmd8 로 'YYYYMMDD' 8자리로
    //   정규화해 날짜 대소를 바르게 비교한다(저장 검증 validateDemandExceptionRow 와 동일 규칙).
    //   참고: AS-IS SpdMain_EditChange 는 InitEvent 에서 주석처리(미배선)라 live 체크가 원래 없고
    //   저장 시 MSG00219 만 있었다 — 이 live 가드는 TO-BE 편의 추가분(저장 검증이 최종 방어선).
    const cellEditEndedHandler = (
      sender: FlexGridType<MainRow>,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'FROM_YYYYMMDD') return;
      const row = GridUtils.getRow(sender, e.row);
      if (!row) return;
      const from = toYmd8(row.FROM_YYYYMMDD);
      const to = toYmd8(row.TO_YYYYMMDD);
      if (!from || !to || from <= to) return;
      void setAlert({ type: 'alert', content: t(MSG.DATE_RANGE_INVALID, '_Invalid period (start > end).') });
      editTrackerRef.current?.storeChange(row, 'TO_YYYYMMDD', row.TO_YYYYMMDD, '');
      row.TO_YYYYMMDD = '';
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);

    // gridSignals#15(.cs:1079) — OPMZ_PLAN_GR_ID 붙여넣기 시 NAME→CODE 역조회 치환.
    const pastedCellHandler = (sender: FlexGridType<MainRow>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row);
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
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler as never);
        g.updatedLayout?.removeHandler(applyDateColumnTypes);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // buttonGuards#4 — 헤더 더블클릭 제외. buttonGuards#5(AS-IS `IsLock || (CRUD!=I) && !_isEditMode`)
  //   에서 `_isEditMode` 축은 §11(Edit 미이식)로 제거돼 실질 가드가 사라진다(Edit 모드였으면 기존행도
  //   팝업이 열렸음). ITEM_ID 가 편집가능 컬럼인 한 신규/기존행 모두 더블클릭으로 Item 팝업을 연다
  //   (형제 SCP0128 SafetyStockGrid 와 동일).
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
        preSearchParams={{ divisionId, scpModuleType: 'SCP0129' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            // gridSignals#13 SetText(e.Row, ITEM_ID, sItemId) 재현.
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
