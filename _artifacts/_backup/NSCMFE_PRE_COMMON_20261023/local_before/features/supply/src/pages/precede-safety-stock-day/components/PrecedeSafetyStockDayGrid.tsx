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

import { INIT_SET, MENU_ID, SEARCH_COMBO_ID, SHEETS } from '../precede-safety-stock-day.constants';
import type { PrecedeSafetyStockDayRow } from '../precede-safety-stock-day.types';
import { matchSiteByDivision } from '../utils/precede-safety-stock-day.util';
import { isMainCellEditable } from '../utils/precedeSafetyStockDayEditLock';

// FROM/TO_YYYYMMDD 날짜 컬럼 — admin 메타가 FPDate 라 columnMapping 이 InputDate(달력) 에디터를
//   붙이지만 dataType 을 비워 둬(getDataType→undefined) 달력이 Date 값에 못 묶이고, 셀 값도 GET SP
//   TO_DATE→BE Jackson('yyyy-MM-dd HH:mm:ss') 직렬화로 문자열이라 더블클릭 달력이 비어 떴다.
//   → 페이지(rows)에서 값을 Date 로 변환하고, 여기서 두 컬럼의 dataType=Date + format='yyyy-MM-dd'
//     를 명시해 (a) 달력 편집 정상 (b) 표시 yyyy-MM-dd 를 함께 해결한다. updatedLayout 마다 재적용
//     (columnGroups 재대입으로 리셋될 수 있음, 이미 설정돼 있으면 건너뛰어 재귀 invalidate 방지).
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
  gridRef: MutableRefObject<FlexGridType<PrecedeSafetyStockDayRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PrecedeSafetyStockDayRow> | undefined>;
  data: PrecedeSafetyStockDayRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  itemModalOpen: boolean;
  onItemModalOpenChange: (open: boolean) => void;
}

/**
 * 메인 그리드 — 편집가능 여부는 신규/기존행 구분 없이 컬럼 white-list 로 판정한다
 * (design/03_grid-columns.md §4.2·§4.3, G-01 iter-2 갱신). TO-BE 는 AS-IS EditButton 편집모드
 * 토글(SwitchLock 잠금 토글 절차)만 이식하지 않으며(asis_to_tobe.md §11 전 화면 공통 결정),
 * DIVISION_ID·감사4칼럼을 뺀 10칼럼은 조회 직후부터 기존행도 즉시 편집 가능하다(자매 SCP0128
 * SafetyStockGrid 동형). 판정 로직은 utils/precedeSafetyStockDayEditLock.ts `isMainCellEditable`
 * 단일 진실원(공용 `isCellEditable` prop 부재, DataGrid 는 조건부 편집을 `beginningEdit`/
 * `pastingCell` 로 위임).
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/03_grid-columns.md §4.2·
 * 00_checklist.md gridSignals#13 SetText) — 조회조건(§4.6)과 별개 인스턴스. buttonGuards#4·#5
 * (00_checklist.md §4d — 헤더 더블클릭 제외 / 잠금 시 팝업 차단)를 재현하되, TO-BE 는 "비편집
 * 모드" 축이 §11 로 제거돼 ITEM_ID 가 편집가능 컬럼인 한 신규/기존행 모두 더블클릭으로 팝업을
 * 연다. dblClick 은 DataGrid 공용 prop(hostElement 네이티브 리스너)을 쓴다 — MaterialByDivision
 * Modal 자체의 그리드 더블클릭 처리와 동일 패턴(hitTest 로 셀 판별).
 *
 * 셀 콤보 5칼럼의 콤보 SQL_ID(Type/PlanGroup/ScmSite/StageAll/YesOrNo)는 `SCM_ADM_CMBO_SQL_M`
 * 전건 등록 확인(ora.py 실측). Division cascade(AS-IS SpdMain_EditStarting SetComboDataRow dt*
 * 재현)는 컬럼별로 둘로 나뉜다: PlanGroup/Stage 는 admin 메타 ATTRIBUTE2='DIVISION_ID:DIVISION_ID'
 * (05_register.sql)로 공용 DataGrid 가 행 DIVISION_ID 기준 자동 좁힘(표준 관례, SCP0001/SDM5010
 * 동일 — 화면 코드 없음). Site 는 AS-IS EE 분기(EE행→81/40/82, EE_*→81_*)가 ATTRIBUTE2 단순일치로
 * 표현 불가라 화면 코드(matchSiteByDivision)로 처리(아래 siteDataMap). VALUE_TYPE/VALID_YN 은
 * 전역(COVER_DAY_TYPE·Y/N)이라 cascade 없이 메타 경로 그대로 둔다.
 *
 * G-04(iter-2) — AS-IS `SmartColMerge()`(gridSignals#12, line897, `SpdMain_TopChange` 경로)에
 * 대응하는 셀 병합(allowMerging/MergeManager) 배선이 이 컴포넌트에 없다. 병합 대상 칼럼은
 * AS-IS `.cs` 원본(GSCM 미러 SCP0127 폴더 부재, 이번 회차도 재확인 — 여전히 파일 없음) 없이는
 * 확정할 수 없다 — grep 0건을 "병합 없음"으로 단정하지 않고(guides/grid-behavior-parity.md 원칙)
 * "확인 필요(원본 미접근)" 상태를 이 주석으로 명시한다. 원본 확보 시 재작업 대상.
 */
export const PrecedeSafetyStockDayGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  itemModalOpen,
  onItemModalOpenChange,
}: Props) => {
  const dblClickRowRef = useRef<PrecedeSafetyStockDayRow | undefined>(undefined);

  // 붙여넣기 NAME→CODE 역조회용 Plan Group 전량(AS-IS SpdMain_ClipboardPasted .cs:1097·1108~1112).
  //   조회조건과 동일 CMBO. Form 과 같은 queryKey 라 react-query 가 1회로 합친다.
  const [planGroups] = useTabComboQueries({ filters: [SEARCH_COMBO_ID.PLAN_GROUP] });
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
  //   재부착한다([[wijmo-columngroups-recreate-datamap]], SCP0128 SafetyStockGrid 동형).
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

    // 편집 진입 가부 — 컬럼 white-list 판정(위 컴포넌트 헤더 주석 참조).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row || !isMainCellEditable(binding, row)) {
        e.cancel = true;
        return;
      }
      // ITEM_ID 는 팝업 셀 — 인라인 편집이 아니라 더블클릭 팝업으로만 채운다(nscm-patterns.md
      //   §5-16 팝업 셀 편집취소 의무). beginningEdit 을 취소해 기본 텍스트 편집을 막는다.
      if (binding === 'ITEM_ID') {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // AS-IS SpdMain_ClipboardPasted(.cs:1108~1112) — OPMZ_PLAN_GR_ID 셀에 NAME 텍스트를 붙여넣으면
    //   planGroups 에서 NAME 매칭으로 CODE 를 역조회해 치환(SCP0128 SafetyStockGrid 동형).
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as PrecedeSafetyStockDayRow | undefined;
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

  // buttonGuards#4 — 헤더 더블클릭 제외(00_checklist.md §4d). buttonGuards#5 의 "비편집모드" 축은
  //   §11 로 제거돼(Edit 토글 미이식) ITEM_ID 가 편집가능 컬럼인 한 신규/기존행 모두 팝업을 연다.
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
      <DataGrid<PrecedeSafetyStockDayRow>
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
        preSearchParams={{ divisionId, scpModuleType: 'SCP0127' }}
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
