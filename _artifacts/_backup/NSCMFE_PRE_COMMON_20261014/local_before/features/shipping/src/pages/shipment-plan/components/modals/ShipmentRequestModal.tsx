import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { LBL, MENU_ID, MSG, PROGRAM_ID, SHEETS } from '../../shipment-plan.constants';

interface Props {
  open: boolean;
  // R8: 팝업 종료(취소 포함) 후 페이지가 무조건 Main 재조회 — modalClose 가 그 트리거를 겸한다.
  modalClose: () => void;
  tabId: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 후 Request 팝업 (AS-IS SSP0060_ShipmentPlanRequestPopup — 01 R8):
//   Main 저장 성공 시 무조건 오픈(_sRequestNo='') + 팝업 결과와 무관하게 재조회(페이지 소유).
//   목록 = GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING('') / 실행 = SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN(P_TITLE)
//   — 두 SP 모두 PKG_SSP0060 배포 실측(roslyn ShipmentPlanRequestPopup.json 의 SP 목록과 일치).
//   주의: 팝업 내부 ERP IF 체인(PR_SSP_ANL_*, SSP0202_* 등)은 TO-BE 미배포 — convert-sp 후속(04 보고).
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 60 },
  { colNm: 'ERP_SO_NO', colLblNm: 'SO No', colWth: 110 },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 130 },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 110 },
  { colNm: 'FROM_SITE_DESCRIPTION', colLblNm: 'From Site', colWth: 120 },
  { colNm: 'TO_SITE_DESCRIPTION', colLblNm: 'To Site', colWth: 120 },
  { colNm: 'SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 100 },
  { colNm: 'SHIPMENT_CONFIRM_QTY', colLblNm: 'Shipment Qty', colWth: 100, horzAlgnCd: 'R' },
  { colNm: 'CHANGE_REASON_CODE', colLblNm: 'Change Reason', colWth: 110 },
  { colNm: 'CHANGE_REASON_DETAIL', colLblNm: 'Reason Detail', colWth: 140 },
];

export const ShipmentRequestModal = ({ open, modalClose, tabId }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType>();
  const [title, setTitle] = useState('');

  const filters = useMemo(
    () => ({
      changeRequestNo: '', // AS-IS pop._sRequestNo='' (R8 — 사용자 drafting 전건)
      userId: session.userId ?? '',
      language: session.langCd ?? '',
    }),
    [session.userId, session.langCd]
  );

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    filters,
    enabled: open,
  });
  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  const { mutate: mutateRequest } = useProcMutation<MENU_ID, SHEETS.REQUEST_DRAFTING_MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DRAFTING_MAIN,
    tabId,
    onSuccess: () => {
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      void refetch(); // 팝업 내 목록만 갱신 — Main 재조회는 닫힘 시 페이지가 수행(R8)
    },
  });

  const handleRequest = () => {
    if (rows.length === 0) {
      setToast({
        type: 'error',
        message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
      });
      return;
    }
    const userId = session.userId ?? '';
    // payload 키 = SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN 13 IN 실측(camelCase) — PROC_M(convert-sp) 등재 대상
    mutateRequest(
      rows.map(row => ({
        activeFlag: 'I',
        divisionId: str(row.DIVISION_ID),
        changeReqNo: str(row.CHANGE_REQ_NO),
        confirmId: str(row.CONFIRM_ID),
        shipmentQty: str(row.SHIPMENT_CONFIRM_QTY),
        shipmentDate: str(row.SHIPMENT_DATE),
        newYyyymmdd: str(row.NEW_YYYYMMDD),
        newQty: str(row.NEW_QTY),
        userId,
        changeReasonCode: str(row.CHANGE_REASON_CODE),
        changeReasonDetail: str(row.CHANGE_REASON_DETAIL),
        title,
        programId: PROGRAM_ID,
      }))
    );
  };

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
        <Stack direction='column' spacing={1}>
          <FormItem
            label={t(LBL.TITLE, '_Title')}
            labelAlign='right'
            render={() => (
              <InputField fullWidth value={title} onChange={e => setTitle(e.target.value)} />
            )}
          />
          <DataGrid
            gridRef={gridRef}
            isReadOnly
            itemsSource={rows as unknown as WijmoRowItem[]}
            staticColumns={POPUP_COLUMNS}
          />
          {/* 하단 버튼 — 액션 먼저, Close 마지막 (nscm-patterns §3.7 정렬 규약) */}
          <Stack direction='row' justifyContent='flex-end' spacing={1}>
            <Button appearance='contained' priority='primary' onClick={handleRequest}>
              {t(LBL.REQUEST, '_Request')}
            </Button>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t(LBL.CLOSE, '_Close')}
            </Button>
          </Stack>
        </Stack>
      }
    />
  );
};
