/**
 * SCP0033 Item by Division 선택 팝업 (AS-IS SCM0002_ItembyDivisionPopup, design 03 §3.4 cs:477~489).
 *
 * 주의: 공용 features/master ItemByDivisionModal 과 겉모습은 같지만 화면 경계(Hard Boundary, convert-core §2.2)상
 *   feature 간 직접 import 를 금지하므로 화면 폴더에 로컬 구성한다. 자매 SSP0024/SSP0025 동일 방식.
 *   반환 = ItemID/NickName(+ ModelId 표시). 신규행 확정 시 부모가 ITEM_ID + NICK_NAME 동반 세팅(cs:487~488).
 *
 * 팝업 division 파라미터(design 02 §2 교차기재 / 03 §3.4 cs:471) = 조회조건 체크 division 을 전극 포함 재구성
 *   (UIUtils.GetAllDivisionCheckedElectrode). 행의 DIVISION_ID 가 아니라 조회 체크리스트가 필터 원천이다.
 *   전극 포함 재구성(GetAllDivisionCheckedElectrode)의 세부 변환은 팝업 SP(SCM0002) 소관 — 여기선 체크 division 을
 *   그대로 전달한다(SP 미배포로 런타임 미완, convert-sp 후속). 신규행 ITEM_ID 셀 가드(cs:463)는 행 DIVISION_ID 기준(그리드).
 *
 * 주의: SCM0002/PKG_SCP0033 팝업 SP 미배포(goal.md ②) -> 조회 런타임 미완. 배선 완비, 실행은 convert-sp 배포 후.
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

import { LBL, MENU_ID, SHEETS } from '../../shipment-semi-dept-day.constants';
import type { PopupRow } from '../../shipment-semi-dept-day.types';

import styles from './ItemByDivisionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행 전달 — 부모가 ItemID/NickName 추출(신규행 셀 채움).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 03 §3.4): divisionId(체크 division 재구성) / itemId(행 ITEM_ID seed).
  preSearchParams: { divisionId?: string; itemId?: string };
}

const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 160, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 140, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Item', colWth: 140, horzAlgnCd: 'L', visible: true, display: true },
];

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [itemId, setItemId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);

  useEffect(() => {
    if (!open) return;
    // 열자마자 컨텍스트로 조회 (design 03 §3.4 — 신규행 셀 호출 preSearchParams).
    setItemId(preSearchParams.itemId ?? '');
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      itemId: preSearchParams.itemId ?? '',
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
  }, [open, preSearchParams.divisionId, preSearchParams.itemId]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SCP0033_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as unknown as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    setFilters(prev => ({ ...(prev ?? {}), itemId }) as ProcRequest<MENU_ID, SHEETS.POPUP>);
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as PopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기 (신규행 셀 채움 단건 빠른 경로).
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
      size={720}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* LBL00343 의 TO-BE 등록 문구는 3언어 모두 'Item Popup' 이다(실측). i18next 는 등록키를 우선하므로
              defaultValue 는 표시되지 않는다 — 'Item by Division' 을 fallback 에 남겨두면 실제 화면과 달라
              읽는 사람을 오도한다(LBL00654='M$' 와 같은 함정). 등록 문구로 맞춘다. */}
          <h2 className='headerTitle'>{t(LBL.ITEM_POPUP_TITLE, '_Item Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={6}>
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
