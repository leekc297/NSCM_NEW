/**
 * DMF0045 TR_MODE 셀 BOD Item/Project/Route 선택 팝업 (AS-IS DMF0046 GetBODItemPrjRoutePopup, design 03 §3).
 *
 * 트리거 = 신규행(action='I') TR_MODE 셀 더블클릭(전제 ITEM_ID — 없으면 그리드가 선차단). 다건 선택 가능하며
 *   확정 시 부모(applyPopupFill BOD)가 c_* 반환을 현재 행 7칸(FROM_SITE/TO_SITE/INCOTERMS/TR_MODE/
 *   BOD_ID/END_CUSTOMER/TEAM_NAME_KO)에 매핑한다.
 *
 * 주의: 공용 features/master 팝업 카탈로그에 이 SP 의 1:1 대응이 없다 — Hard Boundary(convert-core §2.2)상
 *   타 feature 에 새 컴포넌트를 만들 수 없어 화면 폴더에 로컬 구성한다(shipping SSP0045 BodItemRouteModal 선례).
 * 주의: DMF0046 GetBODItemPrjRoutePopup 미배포 → 조회 런타임 미완. 배선·가드·파라미터는 완비, 실행은 SP 배포 후.
 * 주의: 팝업 컬럼도 admin 메타 단일 원천(memory popup-grid-columns-admin-meta). SCM_MST_SHEET_COLUMNS
 *   PROGRAM_ID='DMF0045' SHEET_NAME='bodPopup' — FE 하드코딩 컬럼 배열 금지(register.sql 등록 대상).
 */
import { CellType, HeadersVisibility, SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BOD_POPUP_TITLE_KEY, LBL, MENU_ID, MSG_NO_ROWS_SELECTED, SHEETS } from '../../dmf0045.constants';
import type { BodItemReturn, BodPopupRow } from '../../dmf0045.types';

import styles from './BodItemRouteModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(다건) 전달 — 부모가 c_* 반환을 현재 행 7칸에 매핑한다(applyPopupFill BOD).
  setSelectedValue: (rows: BodItemReturn[]) => void;
  // AS-IS DMF0046 팝업 파라미터 — divisionId + itemId(전제) + fromYyyymmdd.
  preSearchParams: {
    divisionId: string;
    itemId: string;
    fromYyyymmdd: string;
  };
}

export const BodItemRouteModal = ({ open, modalClose, setSelectedValue, preSearchParams }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [itemId, setItemId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.BOD_POPUP> | undefined>(
    undefined
  );

  // 팝업 컬럼 admin 메타(SCM_MST_SHEET_COLUMNS bodPopup) — 모달 자기완결 fetch(부모 store 미확장).
  //   BE 미응답/미등록 시 빈 배열 유지(하드코딩 fallback 금지 — 룰 #91).
  const [popupColumns, setPopupColumns] = useState<RawFlexGridColumnConfig[]>([]);
  useEffect(() => {
    if (!open) return;
    let alive = true;
    void (async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: SHEETS.BOD_POPUP, divisionId: preSearchParams.divisionId }
        );
        if (alive) setPopupColumns(result.data.result ?? []);
      } catch {
        // silent — 메타 미응답 시 빈 목록 유지(console 금지 룰)
      }
    })();
    return () => {
      alive = false;
    };
  }, [open, preSearchParams.divisionId]);

  useEffect(() => {
    if (!open) return;
    setItemId(preSearchParams.itemId);
    setFilters({
      divisionId: preSearchParams.divisionId,
      itemId: preSearchParams.itemId,
      fromYyyymmdd: preSearchParams.fromYyyymmdd,
      programId: MENU_ID,
    } as ProcRequest<MENU_ID, SHEETS.BOD_POPUP>);
    // 열릴 때만 초기화 — 열려 있는 동안 상위 값 변화로 입력을 덮지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.BOD_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_POPUP,
    tabId: `${MENU_ID}_BodItemRouteModal`,
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as unknown as BodPopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...popupColumns],
    [t, popupColumns]
  );

  const handleSearch = () => {
    setFilters(prev => ({ ...(prev ?? {}), itemId }) as ProcRequest<MENU_ID, SHEETS.BOD_POPUP>);
  };

  // AS-IS OKButtonClick 그리드 행 → c_* 반환 매핑(design 03 §3 근거표). 호출 화면은 이 계약만 안다.
  const toSelection = (row: BodPopupRow): BodItemReturn => ({
    c_FROM_SITE: row.FROM_SITE,
    c_TO_SITE: row.TO_SITE,
    c_INCOTERMS: row.INCOTERMS,
    c_TRANSPORT_MODE: row.TRANSPORT_MODE,
    c_BOD_ID: row.BOD_ID,
    c_END_CUSTOMER: row.END_CUSTOMER,
    c_DEPT_NAME_KO: row.DEPT_NAME_KO,
  });

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG_NO_ROWS_SELECTED, { defaultValue: 'No rows selected.' }),
      });
      return;
    }
    setSelectedValue(selections.map(toSelection));
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정(단건 빠른 경로).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodPopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([toSelection(dataItem)]);
    modalClose();
  };

  return (
    <CustomDialog
      size={1400}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(BOD_POPUP_TITLE_KEY, { defaultValue: 'BOD Item Master' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={preSearchParams.divisionId} />}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.MODEL, '_Model')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId}
                        onChange={e => setItemId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                headersVisibility={HeadersVisibility.Column}
                // 다건 선택 = ListBox(grid.selectedItems 다건 반환). AS-IS CHK 체크박스 컬럼 대체.
                selectionMode={SelectionMode.ListBox}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
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
