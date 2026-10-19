/**
 * SSP0024 전용 Material/Model 선택 팝업 (AS-IS SSP0024_ItembyDivisionPopup, 전극 item 마스터).
 *
 * 주의: 공용 features/master ItemByDivisionModal(COM0008, DM0002_ItembyDivisionPopup)과 겉모습은 같지만
 *   호출 SP·조회조건·반환컬럼이 다르다(design 02 §4.6). 이 팝업은 전용 SP
 *   PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP(원천 SCP_MST_FINAL_ITEM)을 쓰고 10 프로퍼티를 반환한다.
 *   공용 모달을 그대로 재사용하지 말 것(nscm-patterns §2.6 콤보/팝업 의미 패리티).
 *
 * 두 호출 경로:
 *   - 조회조건 버튼(btnMaterialId/btnModelId): 다중 선택 -> 부모가 MaterialId/ModelId 만 추출해 텍스트 채움.
 *   - 그리드 셀(MATERIAL_ID 더블클릭): 단건 선택 -> 부모가 10칸 일괄 채움(design 03 §3.2 cs:570~579).
 *
 * 주의: PKG_SSP0024 미배포(goal.md ②) -> 조회 SP 는 런타임 미완. 배선 완비, 실행은 convert-sp 배포 후.
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../../shipment-master-electrode.constants';
import type { PopupRow } from '../../shipment-master-electrode.types';

import styles from './ItemByDivisionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(들) 그대로 전달 — 부모가 용도에 맞게 추출(버튼=id 다건 / 셀=10칸 일괄).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 02 §4.6): divisionId / plantSiteCode / materialId.
  preSearchParams: { divisionId?: string; plantSiteId?: string; materialId?: string };
  // 셀 호출(단건, 10칸 채움) vs 버튼 호출(다건, id 채움).
  callFromCell: boolean;
}

// AS-IS InitSpread(Popup/SSP0024_ItembyDivisionPopup.cs:214~224) 의 노출 컬럼 10종을 순서·라벨·폭 그대로.
//   AS-IS 는 DIVISION_NAME 1컬럼만 visible=false 로 숨긴다(11 중 10 노출).
//   admin 메타(`SCM_MST_SHEET_COLUMNS`)에 이 팝업 시트 행이 없어(실측: SSP0024 는 'Ship Master Elec' 25행
//   단일 시트) 화면 정의를 쓴다 — 메타가 등록되면 그쪽이 authoritative 다(임의 등록 금지, convert-core §2.3).
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'PLANT_SITE_CODE', colLblNm: 'Plant Site Code', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'PLANT_SITE_ID', colLblNm: 'Plant Site', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MATERIAL_ID', colLblNm: 'Material', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 150, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'CELL_TYPE', colLblNm: 'Cell Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 150, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ITEM_UOM', colLblNm: 'UOM', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'UOM_CONVERT_IN_TACT_TIME', colLblNm: 'Pancake (m/cell)', colWth: 120, horzAlgnCd: 'R', scale: 4, visible: true, display: true },
];

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [materialId, setMaterialId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);

  useEffect(() => {
    if (!open) return;
    // 열자마자 컨텍스트로 조회 (design 02 §4.6 — 셀/버튼 호출 동일 preSearchParams 사용).
    setMaterialId(preSearchParams.materialId ?? '');
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      plantSiteId: preSearchParams.plantSiteId ?? '',
      materialId: preSearchParams.materialId ?? '',
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
  }, [open, preSearchParams.divisionId, preSearchParams.plantSiteId, preSearchParams.materialId]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SSP0024_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', { defaultValue: 'No' })), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    setFilters(prev => ({ ...(prev ?? {}), materialId }) as ProcRequest<MENU_ID, SHEETS.POPUP>);
  };

  // AS-IS FindData 는 조회 결과가 **정확히 1건**이면 클릭 없이 그 행을 확정하고 팝업을 닫는다
  //   (Popup/SSP0024_ItembyDivisionPopup.cs:284~298). 조회 1회당 한 번만 발동하도록 filters 참조로 잠근다
  //   (같은 결과로 재렌더될 때 반복 닫힘 방지). gap-resolve iter-1 A06.
  const autoPickedRef = useRef<unknown>(undefined);
  useEffect(() => {
    if (!open || loading || !filters) return;
    if (autoPickedRef.current === filters) return;
    if (rows.length !== 1) return;
    autoPickedRef.current = filters;
    setSelectedValue([rows[0] as PopupRow]);
    modalClose();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, loading, filters, rows]);

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as PopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기 (셀 호출 단건 빠른 경로).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as PopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
  };

  return (
    <CustomDialog
      size={900}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00343', { defaultValue: 'Item by Division' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00641', { defaultValue: 'Division' })}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00005', { defaultValue: 'Plant Site' })}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.plantSiteId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00021', { defaultValue: 'Material' })}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={materialId}
                        onChange={e => setMaterialId(e.target.value)}
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
                useCheckbox={!callFromCell}
                headersVisibility={callFromCell ? HeadersVisibility.Column : HeadersVisibility.All}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel='OK'
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
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
