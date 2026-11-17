import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL, MENU_ID, SHEETS } from '../../production-plan-line.constants';
import type { LoadRow } from '../../production-plan-line.types';
import { useProductionPlanLineStore } from '../../useProductionPlanLineStore';
import { buildPivotColumns } from '../../utils/productionPlanLineColumns';

import styles from './ProductionPlanLineLoadModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
}

// design 01 §P — Load 팝업. 부모 조회조건 주입(setLoadFilter), 완전 읽기전용, Find/Close.
//   고정 표시 컬럼 = AS-IS SCP0013_ProductionPlanLineLoadPopup(cs:157-160): Plant Site·Building·Operation·Line.
//   SP(P_SCP0013_LINE_LOAD_POPUP) 반환 컬럼 실측(PKG body 4029~4039, ora.py 2026-10-07):
//     DIVISION_ID·SCM_SITE_ID·OPERATION_ID·LINE_ID·ORIGIN_DIVISION_ID·ELECTRODE_TYPE·LINE_NAME·
//     FACTORY_ID·FACTORY_NAME(/* Building */)·TYPE + 동적 pivot.
//   → 표시 4컬럼(SCM_SITE_ID/FACTORY_NAME/OPERATION_ID/LINE_NAME)만 visible, AS-IS 미표기 고정컬럼은
//     visible:false 로 선언해 공용 DataGrid 자동노출을 차단한다. (구: SCM_SITE_DESCRIPTION·ITEM_ID 는 SP 미반환이라 빈칸이었음)
const LOAD_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'SCM_SITE_ID', colLblNm: 'Plant Site', colWth: 150, visible: true },
  { colNm: 'FACTORY_NAME', colLblNm: 'Building', colWth: 160, visible: true },
  { colNm: 'OPERATION_ID', colLblNm: 'Operation', colWth: 150, visible: true },
  { colNm: 'LINE_NAME', colLblNm: 'Line', colWth: 90, visible: true },
  // AS-IS 미표기 SP 고정컬럼 — 숨김(DataGrid 자동노출 차단)
  { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 0, visible: false },
  { colNm: 'LINE_ID', colLblNm: 'Line ID', colWth: 0, visible: false },
  { colNm: 'ORIGIN_DIVISION_ID', colLblNm: 'Origin Div', colWth: 0, visible: false },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode', colWth: 0, visible: false },
  { colNm: 'FACTORY_ID', colLblNm: 'Factory ID', colWth: 0, visible: false },
  { colNm: 'TYPE', colLblNm: 'Type', colWth: 0, visible: false },
].map(c => ({
  ...c,
  fixed: false,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const ProductionPlanLineLoadModal = ({ open, modalClose }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType<LoadRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const filters = useProductionPlanLineStore(s => s.filters[SHEETS.LOAD]);
  // Load pivot 은 부모 메인 조회의 bucket/chkSum 형상을 그대로 따른다(AS-IS Load = 메인 동일 pivot).
  const bucket = useProductionPlanLineStore(s => s.searchCondition.bucket);
  const chkSum = useProductionPlanLineStore(s => s.searchCondition.chkSum);

  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.LOAD>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOAD,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });
  const rows = useMemo<LoadRow[]>(() => (data as { o_rc1?: LoadRow[] })?.o_rc1 ?? [], [data]);
  // 동적 pivot(D_/W_/M_) 3단 헤더 — 메인 그리드와 동일 빌더 재사용(L6). 읽기전용이라 드릴다운 없음.
  //   식별 컬럼은 staticColumns(LOAD_COLUMNS), 그 외 비-pivot 컬럼은 공용 DataGrid 자동생성이 노출.
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSum),
    [rows, bucket, chkSum]
  );

  // AS-IS 서브헤더 재현 — 실제 조회에 쓰인 LOAD 필터값으로 구성(화면 표시 = 조회 파라미터 일치 보장).
  //   Div / Operation Group / Plan Date / Plan Type / Seq / Period(from~to). Plant Site·Line 은 AS-IS 비표기라 제외.
  const conditionSummary = filters
    ? `Div:${filters.divisionId ?? ''} / Operation Group:${filters.operationGroup ?? ''} / Plan Date:${filters.planStartYyyymmdd ?? ''} / Plan Type:${filters.planType ?? ''} / Seq:${filters.seq ?? ''} / Period:${filters.fromYyyymmdd ?? ''} ~ ${filters.toYyyymmdd ?? ''}`
    : '';

  // 팝업 그리드는 완전 읽기전용 (design 01 P3 LockColumn(1,maxCol,true) — col0 선택만).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
  }, [rows]);

  // 컬럼 헤더 높이 — 메인 그리드(ProductionPlanLineGrid handleGridInitialized)와 동일하게 총 48px 를 tier
  //   수로 나눠 각 헤더 행에 강제한다. 기본값이면 3단(월/주/일) 헤더가 과도하게 높아 메인/타 그리드와 안 맞는다
  //   (사용자 지시 2026-10-08). 컬럼그룹 재대입마다 updatedLayout 에서 재적용.
  const handleGridInit = useCallback((grid: FlexGridType) => {
    const applyHeaderHeight = () => {
      const hdrRows = grid.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      const target = Math.round(48 / hdrRows.length);
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== target) {
          hdrRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== target) {
        hdrRows.defaultSize = target;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    applyHeaderHeight();
    grid.updatedLayout.addHandler(applyHeaderHeight);
  }, []);

  return (
    <CustomDialog
      open={open}
      size={1000}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      subTitle={conditionSummary}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* AS-IS 'Line Load(%) Popup' — TO-BE 전용 LBL 미탐이라 영문 리터럴 유지(임의 코드 신설 금지 §2.3). */}
          <h2 className='headerTitle'>Line Load(%) Popup</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          {/* 조회 로딩 표시 — 전역 스피너(MDIContainer useIsBusy)는 z-index 999 라 모달(z-index 1300)
              뒤에 깔려 보이지 않는다. 그래서 팝업 조회 로딩은 모달 안에서 직접 렌더한다(기준: SSP0003 액션 로딩). */}
          {isFetching && (
            <div className={styles.loadingOverlay}>
              <ProgressIndicator shape='circular' open />
            </div>
          )}
          <div className={styles.gridWrapper}>
            <ResultArea title='' count={rows.length} gridRef={gridRef as never} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                isReadOnly
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={LOAD_COLUMNS}
                dynamicColumns={pivotColumns}
                initialized={handleGridInit}
              />
            </ResultArea>
          </div>
          <Stack direction='row' justifyContent='flex-end' marginTop={1}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
