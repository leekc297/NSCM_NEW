import { CellType, SelectionMode, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import {
  CustomDialog,
  CustomDropdown,
  DataGrid,
  ResultArea,
  SearchArea,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { LBL, MENU_ID, SHEETS } from '../../shipment-request-electrode.constants';
import type { BodItemPopupRow, RequestDetailRow } from '../../shipment-request-electrode.types';
import { str } from '../../utils/shipment-request-electrode.save';

// ITEM_ID 더블클릭 → BOD/Item 선택 팝업(AS-IS SSP0022_BodItemPopup "Model by DivisionPopup", SpdDetail_CellDoubleClick
//   cs:1046-1071). 이 화면 전용(screen-local) 팝업으로 둔다 — shipping 표준(SSP0024 ElectrodeItemByDivisionModal /
//   SSP0025 RequestorPicItemByDivisionModal / SSP0045·SSP0026 BodItemRouteModal). 공용 MaterialByDivisionModal·
//   ModelByDivisionPopup 은 각각 자재/모델 '한 코드'만 돌려주고 route(From+To) 결합 조회가 아니라 SSP0022 의
//   "Item+Model+BOD 결합 + route" 동작과 1:1 이 아니다.
//   리스트 SP = SSP0022_GET_ITEM_POPUP(배포됨, From+To Site route 조회). 선택 행이 ITEM_ID/MODEL_ID/INCOTERMS/
//   TRANSPORT_MODE/BOD_ID/CONFIRM_DAY 를 모두 담아, 선택 1회로 호출부가 그 6칸을 채운다(AS-IS cs:1063-1068 등가).
//   admin 팝업 컬럼 메타가 없어(SSP0022 는 4시트만 등록) 컬럼은 FE 정의한다(ETA 팝업·SSP0026 BodItemRouteModal 동형).

export interface BodItemSelection {
  ITEM_ID: string;
  MODEL_ID: string;
  INCOTERMS: string;
  TRANSPORT_MODE: string;
  BOD_ID: string;
  CONFIRM_DAY: string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 더블클릭한 상세 행(From/To/Incoterms/Trans 선행 입력 완료 상태). null 이면 조회하지 않는다. */
  row: RequestDetailRow | null;
  /** 조회조건 Plan Date(AS-IS P_PLAN_START_YYYYMMDD). */
  planDate: string;
  /** 선택 확정 — 호출부가 상세 행에 6칸을 채운다(AS-IS SetValue + FindData_BOD 등가). */
  onSelect: (picked: BodItemSelection) => void;
}

const column = (
  colNm: string,
  colLblNm: string,
  colWth: number,
  align: 'L' | 'C' | 'R' = 'C'
): RawFlexGridColumnConfig => ({
  colNm,
  colLblNm,
  horzAlgnCd: align,
  colWth,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
});

// 비활성 콤보(Div/From/To)의 표시용 옵션 — 호출 행에서 온 코드 한 건을 옵션으로 넣어 CustomDropdown 이 그 값을
//   선택 상태로 보이게 한다(AS-IS clbDivision/clbFromSite/clbToSite 가 값 세팅 후 Enabled=false 였던 것 등가).
const selfOption = (value: string): { label: string; value: string }[] =>
  value ? [{ label: value, value }] : [];

export const BodItemModal = ({ open, modalClose, row, planDate, onSelect }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<BodItemPopupRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  // itemId 는 Model 입력용 draft, filters 는 실제 조회조건(commit). 둘을 분리해 키 입력마다 재조회되지 않게 하고
  //   (Search/Enter 때만 commit — AS-IS Find 버튼 등가), 모달을 열 때 그 행 기준으로 초기화한다. 형제
  //   BodItemRouteModal(shipment-request-semi) 동형.
  const [itemId, setItemId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.BOD_ITEM_POPUP> | undefined>(
    undefined
  );

  // 조회조건 시드 — AS-IS FindData_BOD(cs:3902-3910) 와 동일 셋(Div/From/To/Item/BOD/Incoterms/Transport/PlanDate).
  //   division 은 ORIGIN_DIVISION_ID 우선(BOD 조회 기준). itemId 시드는 행의 ITEM_ID(신규행이면 빈값=전체, SP LIKE).
  //   필수: 열릴 때만(open false→true) 초기화한다 — 열려 있는 동안 상위 값 변화로 입력을 덮지 않고, 재오픈 시
  //   이전 검색어가 다음 행 팝업에 잔존하지 않게 draft/조회조건을 함께 리셋한다.
  useEffect(() => {
    if (!open || !row) return;
    const seed = str(row.ITEM_ID);
    setItemId(seed);
    setFilters({
      divisionId: str(row.ORIGIN_DIVISION_ID) || str(row.DIVISION_ID),
      fromSiteId: str(row.FROM_SITE),
      toSiteId: str(row.TO_SITE),
      itemId: seed,
      bodId: str(row.BOD_ID),
      incoterms: str(row.INCOTERMS),
      transportMode: str(row.TRANSPORT_MODE),
      planStartYyyymmdd: planDate,
    } as ProcRequest<MENU_ID, SHEETS.BOD_ITEM_POPUP>);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // Search/Enter 에서만 draft(itemId) 를 조회조건에 commit → 재조회. 나머지 키는 기존 조회조건 유지(불변 참조).
  const handleSearch = () => {
    setFilters(prev =>
      prev ? ({ ...prev, itemId } as ProcRequest<MENU_ID, SHEETS.BOD_ITEM_POPUP>) : prev
    );
  };

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.BOD_ITEM_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM_POPUP,
    tabId: `${MENU_ID}_BodItemModal`,
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;
  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  // AS-IS InitSpread(cs:208-215) 표시 컬럼은 visible=true 인 Div/Model/Material 3개뿐이다(DivisionName/Incoterms/
  //   Transport/BodId/ConfirmDay 는 visible=false=hidden). 선택 반환에 쓰는 INCOTERMS/TRANSPORT_MODE/BOD_ID/
  //   CONFIRM_DAY 는 그리드 컬럼이 아니어도 selectedItems 의 데이터 행에 그대로 담겨 와 pick() 이 읽는다.
  const columns = useMemo<RawFlexGridColumnConfig[]>(
    () => [
      column('DIVISION_ID', t(LBL.DIV, 'Div'), 70),
      column('MODEL_ID', t(LBL.MODEL, 'Model'), 160, 'L'),
      column('ITEM_ID', t(LBL.MATERIAL, 'Material'), 160, 'L'),
    ],
    [t]
  );

  const pick = (picked: BodItemPopupRow | undefined) => {
    if (!picked) return;
    onSelect({
      ITEM_ID: str(picked.ITEM_ID),
      MODEL_ID: str(picked.MODEL_ID),
      INCOTERMS: str(picked.INCOTERMS),
      TRANSPORT_MODE: str(picked.TRANSPORT_MODE),
      BOD_ID: str(picked.BOD_ID),
      CONFIRM_DAY: str(picked.CONFIRM_DAY),
    });
    modalClose();
  };

  const handleOk = () => {
    const grid = gridRef.current;
    // wijmo selectedItems 는 any[] 라 행 타입으로 좁힌다.
    const picked = grid?.selectedItems?.[0] as BodItemPopupRow | undefined;
    if (!picked) {
      void setAlert({ type: 'alert', content: t('MSG00071', 'No rows selected.') });
      return;
    }
    pick(picked);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    pick(GridUtils.getRow(grid, ht.row) as BodItemPopupRow | undefined);
  };

  return (
    <CustomDialog
      open={open}
      size={760}
      height={380}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Model by DivisionPopup</h2>
        </div>
      }
      customContentArea={
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, height: '100%' }}>
          {/* AS-IS 팝업 조회조건: Div / From Site / To Site 는 호출 행 값으로 비활성 표시, Model 만 입력(cs 스크린샷). */}
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_GRID, 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t(LBL.DIV, 'Div')}
                    labelAlign='right'
                    render={() => {
                      const v = row ? str(row.DIVISION_ID) : '';
                      return <CustomDropdown disabled value={v} options={selfOption(v)} />;
                    }}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t(LBL.FROM_SITE, 'From Site')}
                    labelAlign='right'
                    render={() => {
                      const v = row ? str(row.FROM_SITE) : '';
                      return <CustomDropdown disabled value={v} options={selfOption(v)} />;
                    }}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label='To Site'
                    labelAlign='right'
                    render={() => {
                      const v = row ? str(row.TO_SITE) : '';
                      return <CustomDropdown disabled value={v} options={selfOption(v)} />;
                    }}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t(LBL.MODEL, 'Model')}
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
          {/* 그리드 영역 — 조회 중 스피너(ProgressIndicator)와 결과 건수(ResultArea "총 N건")를 노출한다.
              참조 팝업(ModelByDivisionPopup/BodItemRouteModal) 동형. 고정 높이 420 박스가 스피너의 position 기준. */}
          <div
            style={{
              position: 'relative',
              display: 'flex',
              flexDirection: 'column',
              flex: 1,
              minHeight: 320,
            }}
          >
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<BodItemPopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={columns}
                selectionMode={SelectionMode.ListBox}
                isReadOnly
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
