/**
 * SSP0023(전극) ERP Order Detail 팝업 — AS-IS SSP0300_OrderDetailPopup 이식.
 *   Shipment Plan Detail 그리드의 ERP_SO_NO(화면 라벨 "PO No") 셀 더블클릭(값 있을 때) → 이 팝업.
 *   SO/DO 주문상세를 ERP_SO_NO 기준으로 조회하는 읽기전용 그리드다.
 *
 * AS-IS 호출부: GSCM.SSP.Plan.UIL/SSP0023_ShipmentPlanElectrode.cs SpdDetail_CellDoubleClick
 *   (shtPlanDetail 활성 + ERP_SO_NO 비공백 가드 후)
 *   `pop.Form_Load(_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "Y")`.
 *   자매 SSP0015/SSP0060 은 5번째 electrode_yn="N"(비전극)이고 이 화면만 "Y"(전극)다.
 *
 * electrode_yn="Y" 차이 — SSP0300_OrderDetailPopup.cs:133~145 InitSpread:
 *   Y 면 첫 3컬럼 라벨이 PO NO. / PO Item No. / PO Item Qty (비전극은 SO ...).
 *   데이터 컬럼명(SO_NO/SO_ITEM_NO/SO_ITEM_QTY)과 나머지 컬럼(DO_NO 등 + Confirm ID)은 동일하고
 *   조회 proc 의 IN 파라미터도 4개(DIVISION_ID/ERP_SO_NO/CONFIRM_ID/ITEM_ID)로 같다 — 라벨만 다르다.
 *   그래서 전극 전용 모달은 라벨만 PO 로 둔 자매(shipment-plan) OrderDetailModal 의 변형이다.
 *
 * 조회 proc `P_SSP0300_GET_ORDER_DETAIL`(standalone PROCEDURE)은 배포돼 있다 —
 *   STATUS=VALID, ALL_ARGUMENTS = P_DIVISION_ID/P_ERP_SO_NO/P_CONFIRM_ID/P_ITEM_ID + O_RC1
 *   (자매 SSP0060 19_register 근거, 2026-10-08 ora.py 실측). SSP0015/0060/0200 공유 프로시저다.
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

import { MENU_ID, ORDER_DETAIL_BTN, SHEETS } from '../../shipment-plan-electrode.constants';

// ERP_SO_NO 더블클릭 컨텍스트 (AS-IS Form_Load 앞 4 파라미터).
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

// AS-IS SSP0300 그리드 컬럼(전극 기준 PO 라벨 + DO + Confirm ID) — SSP0300_OrderDetailPopup.cs:133~150.
//   electrode_yn="Y" 분기라 첫 3컬럼 라벨이 PO(데이터 컬럼명은 SO_* 그대로).
const ORDER_DETAIL_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'SO_NO', colLblNm: 'PO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
  {
    colNm: 'SO_ITEM_NO',
    colLblNm: 'PO Item No.',
    colWth: 100,
    horzAlgnCd: 'C',
    visible: true,
    display: true,
  },
  {
    colNm: 'SO_ITEM_QTY',
    colLblNm: 'PO Item Qty',
    colWth: 110,
    horzAlgnCd: 'R',
    visible: true,
    display: true,
  },
  { colNm: 'DO_NO', colLblNm: 'DO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
  {
    colNm: 'DO_ITEM_NO',
    colLblNm: 'DO Item No.',
    colWth: 100,
    horzAlgnCd: 'C',
    visible: true,
    display: true,
  },
  {
    colNm: 'DO_ITEM_QTY',
    colLblNm: 'DO Item Qty.',
    colWth: 110,
    horzAlgnCd: 'R',
    visible: true,
    display: true,
  },
  {
    colNm: 'CONFIRM_ID',
    colLblNm: 'Confirm ID',
    colWth: 130,
    horzAlgnCd: 'C',
    visible: true,
    display: true,
  },
];

type OrderDetailRow = Record<string, unknown>;

export const OrderDetailModal = ({ open, data, onClose }: Props) => {
  const gridRef = useRef<FlexGrid>(undefined);

  // SHT_NM 은 'main' 이다 — 이 팝업은 planDetail 그리드에서 열리지만 API 매핑
  //   (SCM_ADM_MNU_BTN_MPG_M)과 버튼권한을 SSP0023/main 으로 등록한다. 자매 SSP0015/0060/0200 통일.
  //   등록: .atlas/gscm-design/SSP0023/design/06_register_order_detail_btn_auth.sql
  const { data: res } = useQuery({
    queryKey: [
      'ssp0023OrderDetail',
      data?.divisionId,
      data?.erpSoNo,
      data?.confirmId,
      data?.itemId,
    ],
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
    // SO 가 없으면(공백 또는 SP 플레이스홀더 '-') 조회하지 않는다. 팝업 오픈 자체는 호출부
    //   (Detail 그리드 ERP_SO_NO 분기)가 막지만, SO 없이 열리는 경로가 생겨도 무의미한 SP 호출이
    //   나가지 않게 여기서도 막는다(자매 SSP0060 선례 — SP 가 SO 미존재를 '-' 로 채운다).
    enabled: open && !!data?.erpSoNo && data.erpSoNo.trim() !== '-',
    // ERP 연동 주문상세라 매번 최신이어야 한다 — 전역 staleTime: Infinity 면 같은 SO 재오픈 시
    //   옛 결과가 고정된다(자매 SSP0200 에서 실제 발생, 2026-10-02).
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
      // AS-IS 폼 캡션 그대로 — SSP0300_OrderDetailPopup.Designer.cs `this.Text = "ERP Order Detail"`.
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
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </Box>
        </Box>
      }
    />
  );
};
