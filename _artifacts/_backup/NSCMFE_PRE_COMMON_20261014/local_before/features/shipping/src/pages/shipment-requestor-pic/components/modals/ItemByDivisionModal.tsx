/**
 * SSP0025 전용 Material/Model 선택 팝업 (AS-IS SSP0025_ItembyDivisionPopup, 전극 item 마스터).
 *
 * 주의: 공용 features/master ItemByDivisionModal(COM0008, DM0002_ItembyDivisionPopup)과 겉모습은 같지만
 *   호출 SP·조회조건·반환컬럼이 다르다(design 02 §4.6). 이 팝업은 전용 SP
 *   PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP 을 쓰고 ItemId/DivisionId/ElectrodeType/ModelId/
 *   NickName/CellType 6 프로퍼티를 반환한다. 공용 모달을 그대로 재사용하지 말 것(convert-core §2.6 의미 패리티).
 *
 * 두 호출 경로:
 *   - 조회조건 버튼(btnItemId/btnModelId): 다중 선택 -> 부모가 ItemId/ModelId 만 추출해 텍스트 채움.
 *   - 그리드 셀(ITEM_ID 더블클릭): 단건 선택 -> 부모가 6칸 일괄 채움(design 03 §3 R12 cs:642~666).
 *
 * 주의: PKG_SSP0025 미배포(goal.md ②) -> 조회 SP 는 런타임 미완. 배선 완비, 실행은 convert-sp 배포 후.
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

import { LBL, MENU_ID, SHEETS } from '../../shipment-requestor-pic.constants';
import type { PopupRow } from '../../shipment-requestor-pic.types';

import styles from './ItemByDivisionModal.module.scss';

// 팝업 조회 모드(design 02 §4.6): ITEM(btnItemId)/MODEL(btnModelId)/CELL(그리드 셀 R12).
export type ItemPopupMode = 'ITEM' | 'MODEL' | 'CELL';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(들) 그대로 전달 — 부모가 용도에 맞게 추출(버튼=id 다건 / 셀=6칸 일괄).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 02 §4.6): divisionId / plantSite / item(model).
  preSearchParams: { divisionId?: string; plantSite?: string; itemId?: string; modelId?: string };
  // 셀 호출(단건, 6칸 채움) vs 버튼 호출(다건, id 채움).
  callFromCell: boolean;
  // AS-IS BtnType 등가 — 검색칸을 Material/Model 중 무엇으로 쓸지 결정한다(Popup cs:214~221).
  //   값으로 추론하면 Model 이 빈 채로 팝업을 열었을 때 Material 모드로 오판하므로 명시 전달한다.
  mode: ItemPopupMode;
}

// AS-IS 팝업 그리드 컬럼 (Popup/SSP0025_ItembyDivisionPopup.cs:243~253 — 폭/정렬 그대로).
//   gap-resolve iter-1 A04: 종전 5컬럼은 Division_code·From Site Code·From Site·UOM·Pancake 5건이 누락돼 있었다.
//   From Site 는 이 팝업의 행 식별축이다(같은 ITEM_ID 가 from-site 별로 중복) — 없으면 어느 행인지 구분 불가.
//   DIVISION_NAME 은 AS-IS 도 hidden 이라 제외.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division_code', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE_CODE', colLblNm: 'From Site Code', colWth: 70, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE', colLblNm: 'From Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Material', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'CELL_TYPE', colLblNm: 'Cell Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 100, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ITEM_UOM', colLblNm: 'UOM', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'UOM_CONVERT_IN_TACT_TIME', colLblNm: 'Pancake (m/cell)', colWth: 120, horzAlgnCd: 'R', scale: 5, visible: true, display: true },
];

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
  mode,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  // 검색 키워드 1칸 — 모드에 따라 Material(ITEM) 또는 Model(MODEL) 필터로 나간다.
  //   gap-resolve iter-1 A03: 종전에는 MODEL 모드에서도 입력값을 항상 `itemId` 키에 실어
  //   `ITEM_ID IN (모델값) AND MODEL_ID IN (원래값)` 이 되어 재검색이 항상 0건이었다.
  //   AS-IS 는 BtnType 으로 Material/Model 입력칸을 하나만 노출한다(Popup cs:214~221).
  const [keyword, setKeyword] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);
  const isModelMode = mode === 'MODEL';

  useEffect(() => {
    if (!open) return;
    // 열자마자 컨텍스트로 조회 (design 02 §4.6 — 셀/버튼 호출 동일 preSearchParams 사용).
    setKeyword(preSearchParams.itemId ?? preSearchParams.modelId ?? '');
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      plantSite: preSearchParams.plantSite ?? '',
      itemId: preSearchParams.itemId ?? '',
      modelId: preSearchParams.modelId ?? '',
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
  }, [
    open,
    preSearchParams.divisionId,
    preSearchParams.plantSite,
    preSearchParams.itemId,
    preSearchParams.modelId,
  ]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SSP0025_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    // 모드에 맞는 키에만 실어 보낸다 — 반대쪽 키는 비워야 AND 조건이 서로를 0건으로 만들지 않는다.
    setFilters(
      prev =>
        ({
          ...(prev ?? {}),
          itemId: isModelMode ? '' : keyword,
          modelId: isModelMode ? keyword : '',
        }) as ProcRequest<MENU_ID, SHEETS.POPUP>
    );
  };

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
          <h2 className='headerTitle'>{t(LBL.ITEM_BY_DIVISION, '_Item by Division')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_MODAL, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.PLANT_SITE, '_Plant Site')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.plantSite ?? ''} />
                    )}
                  />
                </Grid>
                {/* 모드별 단일 검색칸 — AS-IS 는 BtnType 으로 반대쪽 칸을 숨긴다(Popup cs:214~221). */}
                <Grid size={4}>
                  <FormItem
                    label={
                      isModelMode
                        ? t(LBL.MODEL, '_Model')
                        : t(LBL.MATERIAL, '_Material')
                    }
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={keyword}
                        onChange={e => setKeyword(e.target.value)}
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
