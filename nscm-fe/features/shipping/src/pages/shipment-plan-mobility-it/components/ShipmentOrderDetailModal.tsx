/**
 * SSP0015 Order Detail 팝업 — AS-IS SSP0300_OrderDetailPopup 이식.
 *   Shipment Confirm Detail 그리드의 ERP_SO_NO 셀 더블클릭(값 있을 때) → 이 팝업.
 *   SO/DO 주문상세(읽기전용 그리드)를 ERP_SO_NO 기준으로 조회한다.
 *
 * 조회 proc 은 `P_SSP0300_GET_ORDER_DETAIL`(standalone PROCEDURE)로 **배포돼 있다**.
 *   종전 주석의 "PKG_SSP0300 미배포"는 패키지 이름으로만 찾아 생긴 오판이었다(DB 실측 2026-10-02).
 *   그 프로시저는 2026-10-02 까지 하드코딩 더미(10/20 · 1000 · 600/400)였고 AS-IS 실쿼리
 *   (SSP_ANL_SHIP_ERP_SO + _DO)로 교체했다 — SSP0200 과 공유하므로 이 화면도 함께 해소됐다.
 *   상세·근거: .atlas/gscm-design/SSP0200/design/08_fix_order_detail_proc.sql
 */
import { HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import { useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button } from '@shared/lges';
import { Box } from '@shared/mui';

import { MENU_ID, ORDER_DETAIL_BTN, SHEETS } from '../shipment-plan-mobility-it.constants';

// ERP_SO_NO 더블클릭 컨텍스트 (AS-IS Form_Load 4 파라미터).
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

// AS-IS SSP0300 그리드 컬럼(비전극 기준 SO 라벨 + DO + Confirm ID). cs:135~150.
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

export const ShipmentOrderDetailModal = ({ open, data, onClose }: Props) => {
  const gridRef = useRef<FlexGrid>(undefined);

  // P_SSP0300_GET_ORDER_DETAIL — PROC_M 실측 파라미터 divisionId/erpSoNo/confirmId/itemId -> o_rc1.
  //   SHT_NM 은 **'main'** 이다 — 이 팝업은 confirmDetail 그리드에서 열리지만 API 매핑
  //   (SCM_ADM_MNU_BTN_MPG_M)과 버튼권한이 SSP0015/main 으로 등록돼 있다. 종전엔 confirmDetail 로
  //   호출해 해석 단계에서 막혔다(SYS_LOG 기록조차 안 남음). 자매 SSP0200 도 main 으로 통일돼 있다.
  const { data: res } = useQuery({
    queryKey: ['ssp0015OrderDetail', data?.divisionId, data?.erpSoNo, data?.confirmId, data?.itemId],
    queryFn: async () => {
      const r = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${ORDER_DETAIL_BTN}/call-proc`, {
        divisionId: data?.divisionId ?? '',
        erpSoNo: data?.erpSoNo ?? '',
        confirmId: data?.confirmId ?? '',
        itemId: data?.itemId ?? '',
      });
      return (r.data?.result as { o_rc1?: OrderDetailRow[] })?.o_rc1 ?? [];
    },
    enabled: open && !!data?.erpSoNo,
    // 전역 기본값 staleTime: Infinity 를 그대로 두면 같은 SO 재오픈 시 영영 재조회하지 않아
    //   옛 결과가 고정된다(SSP0200 에서 실제 발생, 2026-10-02). ERP 연동 주문상세라 매번 최신이어야 한다.
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(res ?? []), [res]);
  const staticColumns = useMemo(() => [buildNoColumn('No'), ...ORDER_DETAIL_COLUMNS], []);

  if (!data) return null;

  return (
    <CustomDialog
      size={760}
      height={460}
      position='basic'
      open={open}
      // AS-IS 폼 캡션 그대로 — SSP0300_OrderDetailPopup.Designer.cs:109 `this.Text = "ERP Order Detail"`.
      title='ERP Order Detail'
      handleClose={onClose}
      customContentArea={
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1, p: 1 }}>
          <Box sx={{ flex: 1, minHeight: 0 }}>
            <DataGrid
              gridRef={gridRef}
              isReadOnly
              headersVisibility={HeadersVisibility.Column}
              staticColumns={staticColumns}
              itemsSource={rows as never}
            />
          </Box>
          <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={onClose} />
          </Box>
        </Box>
      }
    />
  );
};
