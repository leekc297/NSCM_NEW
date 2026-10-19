import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { LBL, MENU_ID, POPUP_SHEET } from '../../bod-item.constants';
import type { BodPopupRow } from '../../bod-item.types';
import { toDateOnly } from '../../utils/bod-item.util';

import styles from './GetBodItemModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 선택 BOD 행(들) — 부모가 신규행 FROM_SITE_NAME/TO_SITE_NAME/BOD_ID/INCOTERMS/TRANSPORT_MODE 채움. */
  setSelectedValue: (rows: BodPopupRow[]) => void;
  preSearchParams: { divisionId: string; itemId: string; planGroup: string };
}

// AS-IS SCM0002_GetBODItemPopup 그리드 컬럼(전수) — 반환 커서(o_rc1) 컬럼과 1:1.
//   BOD_ID 는 AS-IS 도 비표시(선택 시 cascade 반환값으로만 사용, 행 데이터엔 남는다).
//   Voyage(Mon~Sun) 는 AS-IS 상위 그룹헤더이나 다단 헤더 리스크로 평탄 컬럼으로 둔다.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'FROM_SITE_NAME', colLblNm: 'From Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'TO_SITE_NAME', colLblNm: 'To Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 130, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'PRIORITY', colLblNm: 'Priority', colWth: 70, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'BOD_ITEM_VALID', colLblNm: 'BOD Item Valid', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  // Voyage 그룹헤더(AS-IS) — sClsLblNm 로 Mon~Sun 을 묶는다(DataGrid 헤더 병합으로 상위 'Voyage' 렌더).
  { colNm: 'DAYS_MON', colLblNm: 'Mon', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_TUE', colLblNm: 'Tue', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_WED', colLblNm: 'Wed', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_THU', colLblNm: 'Thu', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_FRI', colLblNm: 'Fri', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_SAT', colLblNm: 'Sat', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_SUN', colLblNm: 'Sun', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'LEAD_TIME', colLblNm: 'L/T(Day)', colWth: 80, horzAlgnCd: 'R', visible: true, display: true },
  { colNm: 'FROM_YYYYMMDD', colLblNm: 'From', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'TO_YYYYMMDD', colLblNm: 'To', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
];

/**
 * GetBODItem 팝업(로컬) — Excluded BOD_ID 셀 더블클릭(03 §5-7). retList 다건 선택 → 신규행 cascade 채움.
 * 주의: 조회 SP(bodPopup)는 PKG_SCP0030 에 미배포(convert-sp 후속) — 배선 완비, 런타임 데이터는 SP 배포 후.
 */
export const GetBodItemModal = ({ open, modalClose, setSelectedValue, preSearchParams }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<BodPopupRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [filters, setFilters] = useState<ProcRequest<MENU_ID, typeof POPUP_SHEET.BOD> | undefined>(
    undefined
  );

  useEffect(() => {
    if (!open) return;
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      itemId: preSearchParams.itemId ?? '',
      planGroup: preSearchParams.planGroup ?? '',
    });
  }, [open, preSearchParams.divisionId, preSearchParams.itemId, preSearchParams.planGroup]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, typeof POPUP_SHEET.BOD>({
    menuId: MENU_ID,
    sheetName: POPUP_SHEET.BOD,
    tabId: 'SCP0030_GetBodItemModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  // From/To(FROM_YYYYMMDD·TO_YYYYMMDD)는 FPDateText 라 BE 의 datetime 을 date-only 로 정규화.
  const rows = useMemo(
    () =>
      withRowNo(
        (data?.o_rc1 ?? []).map(row => {
          const r = row as { FROM_YYYYMMDD?: string; TO_YYYYMMDD?: string };
          return {
            ...row,
            FROM_YYYYMMDD: toDateOnly(r.FROM_YYYYMMDD ?? ''),
            TO_YYYYMMDD: toDateOnly(r.TO_YYYYMMDD ?? ''),
          };
        }) as unknown as BodPopupRow[]
      ),
    [data]
  );
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodPopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
  };

  return (
    <CustomDialog
      size={750}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* LBL00343 은 DB 에 'Item Popup' 으로 등록돼 재사용 시 오표기 → 신규 시맨틱 키 사용(한 코드 다의미 금지). */}
          <h2 className='headerTitle'>{t('LBL_BOD_ITEM_MASTER', { defaultValue: 'BOD Item Master' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<BodPopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox
                staticColumns={staticColumns}
                itemsSource={rows}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t(LBL.OK, '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
