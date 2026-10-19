import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

import { LBL, MENU_ID, SHEETS } from '../../shipment-plan.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  tabId: string;
  changeReqNo: string;
}

// AS-IS SSP0060_ShipmentPlanConfirmDetailPopup (§4e#5 — CHANGE_REQ_NO 클릭, 표시전용).
//   데이터: P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(P_CHANGE_REQUEST_NO/P_USER_ID/P_LANGUAGE — 배포 실측).
//   팝업 전용 컬럼(커서 SELECT 실측 발췌) — admin 메타 미등재 팝업 시트라 화면 상수로 정의한다.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 60 },
  { colNm: 'ERP_SO_NO', colLblNm: 'SO No', colWth: 110 },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code', colWth: 110 },
  { colNm: 'PROJECT_NAME', colLblNm: 'Project Name', colWth: 130 },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 80 },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 110 },
  { colNm: 'PRODUCT_LEVEL1', colLblNm: 'Product Level1', colWth: 100 },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 130 },
  { colNm: 'FROM_SITE_DESCRIPTION', colLblNm: 'From Site', colWth: 120 },
  { colNm: 'TO_SITE_DESCRIPTION', colLblNm: 'To Site', colWth: 120 },
  { colNm: 'SOLDTO_DESCRIPTION', colLblNm: 'Sold To', colWth: 120 },
  { colNm: 'SHIPTO_DESCRIPTION', colLblNm: 'Ship To', colWth: 120 },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80 },
  { colNm: 'SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 100 },
  { colNm: 'SHIPMENT_CONFIRM_QTY', colLblNm: 'Shipment Qty', colWth: 100, horzAlgnCd: 'R' },
  { colNm: 'ETD', colLblNm: 'ETD', colWth: 100 },
  { colNm: 'ETA', colLblNm: 'ETA', colWth: 100 },
];

export const ConfirmDetailModal = ({ open, modalClose, tabId, changeReqNo }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);
  const gridRef = useRef<FlexGridType>();

  const filters = useMemo(
    () => ({
      changeRequestNo: changeReqNo,
      userId: session.userId ?? '',
      language: session.langCd ?? '',
    }),
    [changeReqNo, session.userId, session.langCd]
  );

  const { data } = useTabProcQuery<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    filters,
    enabled: open && changeReqNo !== '',
  });
  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1080}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      title={t(LBL.REQUEST, '_Request')}
      customContentArea={
        <DataGrid
          gridRef={gridRef}
          isReadOnly
          itemsSource={rows as unknown as WijmoRowItem[]}
          staticColumns={POPUP_COLUMNS}
        />
      }
    />
  );
};
