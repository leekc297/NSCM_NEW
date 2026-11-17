import { HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import { useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL, MENU_ID, ORDER_DETAIL_BTN, SHEETS } from '../../shipment-change-request-plan.constants';

/**
 * SSP0200 SO 주문상세 팝업 — AS-IS SSP0300_OrderDetailPopup 이식.
 *
 * 진입: 메인 그리드 ERP_SO_NO 셀 더블클릭, **값이 있을 때만**. action(신규/수정) 무관한
 *   조회 전용 드릴다운이다(AS-IS cs:4858~4878 — ERP_SO_NO 가 ''/null 이면 아무 것도 안 한다).
 * 전달 컨텍스트 4종은 AS-IS `pop.Form_Load(_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N")` 과 같다.
 *   마지막 "N"(electrode_yn)은 팝업 안에서 **컬럼 라벨만** 가르는 값이라(Y 면 SO* -> PO*,
 *   팝업 cs:133~145) SSP0200 은 항상 "N" = SO 라벨 고정이다. 조회 파라미터가 아니므로 전송하지 않는다.
 * 그리드는 전 컬럼 잠금(AS-IS LockColumn(0, Max, true)) — 읽기 전용이다.
 */
export interface OrderDetailContext {
  divisionId: string;
  erpSoNo: string;
  confirmId: string;
  itemId: string;
}

interface Props {
  open: boolean;
  data: OrderDetailContext | null;
  onClose: () => void;
}

// AS-IS 팝업 컬럼 7종(cs:141~150, electrode_yn='N' 분기). 자매 SSP0015 이식본과 폭/라벨을 맞춘다.
const ORDER_DETAIL_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'SO_NO', colLblNm: 'SO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'SO_ITEM_NO', colLblNm: 'SO Item No.', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'SO_ITEM_QTY', colLblNm: 'SO Item Qty', colWth: 110, horzAlgnCd: 'R', visible: true, display: true },
  { colNm: 'DO_NO', colLblNm: 'DO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DO_ITEM_NO', colLblNm: 'DO Item No.', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DO_ITEM_QTY', colLblNm: 'DO Item Qty.', colWth: 110, horzAlgnCd: 'R', visible: true, display: true },
  { colNm: 'CONFIRM_ID', colLblNm: 'Confirm ID', colWth: 130, horzAlgnCd: 'C', visible: true, display: true },
];

type OrderDetailRow = Record<string, unknown>;

export const OrderDetailModal = ({ open, data, onClose }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);

  // P_SSP0300_GET_ORDER_DETAIL — PROC_M 실측 파라미터 divisionId/erpSoNo/confirmId/itemId -> o_rc1.
  const { data: res } = useQuery({
    queryKey: ['ssp0200OrderDetail', data?.divisionId, data?.erpSoNo, data?.confirmId, data?.itemId],
    queryFn: async () => {
      const r = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/${ORDER_DETAIL_BTN}/call-proc`,
        {
          divisionId: data?.divisionId ?? '',
          erpSoNo: data?.erpSoNo ?? '',
          confirmId: data?.confirmId ?? '',
          itemId: data?.itemId ?? '',
        }
      );
      return (r.data?.result as { o_rc1?: OrderDetailRow[] })?.o_rc1 ?? [];
    },
    // ERP_SO_NO 가 없으면 AS-IS 가 팝업 자체를 안 띄우므로 조회도 하지 않는다.
    enabled: open && !!data?.erpSoNo,
    // 전역 기본값이 staleTime: Infinity 라 그냥 두면 같은 SO 를 다시 열 때 **영영 재조회하지 않는다**
    //   (사용자 신고 2026-10-02: SP 수정 후에도 예전 결과가 계속 떴다). 이 팝업은 ERP 연동 주문상세라
    //   열 때마다 최신이어야 하므로 휘발성으로 돌린다 — 콤보와 같은 규약(VOLATILE_QUERY_OPTIONS).
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(res ?? []), [res]);
  const staticColumns = useMemo(() => [buildNoColumn('No'), ...ORDER_DETAIL_COLUMNS], []);

  if (!data) return null;

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={760}
      height={460}
      handleClose={onClose}
      disableButtonCancel
      // AS-IS 폼 캡션 그대로 — SSP0300_OrderDetailPopup.Designer.cs:109 `this.Text = "ERP Order Detail"`.
      //   로케일 무관 고정 영문이라 i18n 키를 쓰지 않는다(AS-IS 도 리소스가 아닌 리터럴).
      title='ERP Order Detail'
      customContentArea={
        <Stack direction='column' spacing={1} height='100%'>
          <DataGrid
            gridRef={gridRef}
            isReadOnly
            headersVisibility={HeadersVisibility.Column}
            staticColumns={staticColumns}
            itemsSource={rows as never}
          />
          {/* 조회 전용 팝업이라 닫기 버튼만 둔다(AS-IS 도 OK 없이 닫기만). */}
          <Stack direction='row' justifyContent='flex-end'>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CANCEL, '_취소')}
              onClick={onClose}
            />
          </Stack>
        </Stack>
      }
    />
  );
};
