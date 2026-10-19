/**
 * SSP0045 BOD Item/Project/Route 선택 팝업 (AS-IS `SCM0002_GetBODItemPrjRoutePopup`, PU04 / design 03 §3.2 R10).
 *
 * 트리거 = 신규행 `TR_MODE` 셀 클릭(진입 가드 BG08~BG12 는 그리드가 선처리). 다건 선택이 가능하며,
 * 확정 시 부모가 첫 건은 현재 행에, 2건째부터는 새 행을 만들어 8칸(S47~S54)을 매핑한다.
 *
 * 주의: 공용 `features/master` 팝업 카탈로그에 이 SP 의 1:1 대응이 없다(design 02 §4.6 재사용 금지 후보와도 별개).
 *   Hard Boundary(convert-core §2.2)상 타 feature 에 새 컴포넌트를 만들 수 없으므로 화면 폴더에 로컬 구성한다
 *   — 자매 SCP0033/SSP0024/SSP0025 와 동일 방식.
 * 주의: `PKG_SSP0045` 미배포(goal ②) → 조회 런타임 미완. 배선·가드·파라미터는 완비, 실행은 convert-sp 배포 후.
 */
import { CellType, HeadersVisibility, SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { buildNoColumn, GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  BOD_POPUP_TITLE_KEY,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
} from '../../shipment-request-semi.constants';
import type { BodItemRow, BodPopupRow } from '../../shipment-request-semi.types';
import { useShipmentRequestSemiStore } from '../../useShipmentRequestSemiStore';

import styles from './BodItemRouteModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 선택 행(다건) 전달 — 부모가 행 생성 + 8칸 매핑을 수행한다. */
  setSelectedValue: (rows: BodItemRow[]) => void;
  /** AS-IS 팝업 파라미터 5종(design 00 §4e PU04). */
  preSearchParams: {
    divisionId: string;
    operationGroup: string;
    itemId: string;
    fromYyyymmdd: string;
  };
}

export const BodItemRouteModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [itemId, setItemId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.BOD_POPUP> | undefined>(
    undefined
  );

  useEffect(() => {
    if (!open) return;
    setItemId(preSearchParams.itemId);
    setFilters({
      divisionId: preSearchParams.divisionId,
      operationGroup: preSearchParams.operationGroup,
      itemId: preSearchParams.itemId,
      fromYyyymmdd: preSearchParams.fromYyyymmdd,
      programId: MENU_ID,
    } as ProcRequest<MENU_ID, SHEETS.BOD_POPUP>);
    // 열릴 때만 초기화한다 — 열려 있는 동안 상위 값 변화로 입력을 덮지 않는다.
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
  // 팝업 컬럼도 admin 메타 단일 원천이다(메모리 popup-grid-columns-admin-meta-not-hardcoded).
  //   원천 = `SCM_MST_SHEET_COLUMNS` PROGRAM_ID='SSP0045' SHEET_NAME='bodPopup' 22행
  //   (05_register.sql 8 — AS-IS `SCM0002_GetBODItemPrjRoutePopup.InitSpread` 실측 이관).
  //   iter-1 의 FE 하드코딩 8칸 배열은 AS-IS 컬럼셋과도 달랐다(react-gap-audit G-08).
  const popupColumns = useShipmentRequestSemiStore(s => s.popupColumns);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, { defaultValue: 'No' })), ...popupColumns],
    [t, popupColumns]
  );

  const handleSearch = () => {
    setFilters(
      prev => ({ ...(prev ?? {}), itemId }) as ProcRequest<MENU_ID, SHEETS.BOD_POPUP>
    );
  };

  // AS-IS `OKButtonClick`(cs:315-332) 의 그리드 행 → `retList` DTO 매핑을 그대로 옮긴 것.
  //   호출 화면은 이 c_* 계약만 알면 되고 팝업 SP 컬럼명 변화에 끌려가지 않는다.
  const toSelection = (row: BodPopupRow): BodItemRow => ({
    C_FROM_SITE: row.FROM_SITE,
    C_TO_SITE: row.TO_SITE,
    C_TRANSPORT_MODE: row.TRANSPORT_MODE,
    C_INCOTERMS: row.INCOTERMS,
    C_LT_DAY: row.LEAD_TIME,
    C_FROZEN_YYYYMMDD: row.FROZEN_YYYYMMDD,
    C_BOD_ID: row.BOD_ID,
    C_BOD_FROM_YYYYMMDD: row.BOD_FROM_YYYYMMDD,
    C_BOD_TO_YYYYMMDD: row.BOD_TO_YYYYMMDD,
  });

  // AS-IS `retList` 다건 반영(BG13/BG14).
  //   선택 0건이면 AS-IS(cs:337-340)와 동일하게 `MSG00071` 안내 후 차단한다. iter-2 까지는 "등가 코드가
  //   없다"는 판단으로 무동작이었으나, 실측상 TO-BE `MSG00071` 이 'No rows selected.' 로 문구까지
  //   일치한다(react-gap-audit iter-2 L-02).
  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_ROWS_SELECTED, { defaultValue: 'No rows selected.' }),
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
      // AS-IS `bodPopup.Width = 1400`(cs:1237 실측) 그대로. iter-3 까지 주석은 1400 인데 값은 1000
      //   이어서 근거와 코드가 어긋나 있었다(N-10). 표시 컬럼이 From/To(BOD 기간) 2칸을 포함해
      //   총 14칸이라 1000 에서는 가로 스크롤이 생긴다 — AS-IS 근거값으로 맞춘다.
      size={1400}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* i18n: AS-IS 팝업 시트명 `"BOD Item Master"`(SCM0002_GetBODItemPrjRoutePopup.cs:49)를
              문구 기준으로 역조회한 실측 코드 `MNU00158` 을 쓴다(hook #114). iter-1 의 자유 형식 키
              `_ssp0045.bodPopupTitle` 은 convert-core §2.4 금지 대상이었다. */}
          <h2 className='headerTitle'>
            {t(BOD_POPUP_TITLE_KEY, { defaultValue: 'BOD Item Master' })}
          </h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, { defaultValue: 'Division' })}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.OPERATION_GROUP, { defaultValue: 'Operation group' })}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.operationGroup} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.MODEL, { defaultValue: 'Model' })}
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
                // AS-IS 는 `CHK` 체크박스 컬럼으로 다건을 고르고 OK 에서 체크된 행만 모은다
                //   (SCM0002_GetBODItemPrjRoutePopup.cs:165, :311-334). TO-BE 는 데이터가 아닌
                //   어포던스를 컬럼으로 만들지 않고 행 선택(Ctrl/Shift)으로 대체한다 — `ListBox` 라야
                //   `grid.selectedItems` 가 다건을 돌려준다(기본 MultiRange 는 셀 범위 기준).
                selectionMode={SelectionMode.ListBox}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          {/* 액션 버튼 먼저, Close 를 마지막에 — flex-end 정렬이라 DOM 마지막이 최우측(nscm-patterns §3.7). */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t(LBL.OK, { defaultValue: 'OK' })}
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
              buttonLabel={t(LBL.CLOSE, { defaultValue: 'Close' })}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
