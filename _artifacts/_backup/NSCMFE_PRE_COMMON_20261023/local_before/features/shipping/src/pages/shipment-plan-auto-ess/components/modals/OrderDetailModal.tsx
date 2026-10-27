/**
 * SSP0021 ERP Order Detail 팝업 — AS-IS SSP0300_OrderDetailPopup 이식.
 *   Shipment Plan Detail 그리드의 ERP_SO_NO 셀 더블클릭(값 있을 때) -> 이 팝업.
 *   SO/DO 주문상세를 ERP_SO_NO 기준으로 조회하는 읽기전용 그리드다.
 *
 * AS-IS 호출부: GSCM.SSP.Plan.UIL/SSP0021_ShipmentPlan.cs L1591~1611
 *   `if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail)` +
 *   `if (e.Column == GetColumnIndex(ERP_SO_NO))` + `if (GetText(ERP_SO_NO) != "" && != null)` 가드 후
 *   `pop.Form_Load(_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N")`.
 *   자매 SSP0060(cs L1797~1812)·SSP0015(cs L1341~1343)와 **완전 동일한 호출**이라 파라미터 의미도 같다.
 *   5번째 electrode_yn 은 세 화면 모두 상수 "N"(비전극)이고, TO-BE proc 의 IN 파라미터는 4개뿐이라
 *   전달하지 않는다 — ALL_ARGUMENTS 실측: P_DIVISION_ID/P_ERP_SO_NO/P_CONFIRM_ID/P_ITEM_ID + O_RC1.
 *
 * 조회 proc `P_SSP0300_GET_ORDER_DETAIL` 은 **패키지가 아니라 standalone PROCEDURE** 이고 배포돼 있다.
 *   종전 __asis-mapping__ 의 "TO-BE 팝업 부재 — 미배선(확인필요)" 기술은 그 전제가 바뀌어 해소됐다:
 *   자매 SSP0060/SSP0200 작업에서 이 공용 proc 이 AS-IS 실쿼리로 교체됐고(SSP0200
 *   design/08_fix_order_detail_proc.sql), `SCM_ADM_API_M.P_SSP0300_GET_ORDER_DETAIL` 도
 *   **화면 비종속 공용으로 이미 등록**돼 있다(ora.py 실측). SSP0021 은 버튼매핑만 추가하면 된다.
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

import { MENU_ID, ORDER_DETAIL_BTN, SHEETS } from '../../shipment-plan-auto-ess.constants';

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

// AS-IS SSP0300 그리드 컬럼(비전극 기준 SO 라벨 + DO + Confirm ID) — SSP0300_OrderDetailPopup.cs:135~150.
const ORDER_DETAIL_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'SO_NO', colLblNm: 'SO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
  {
    colNm: 'SO_ITEM_NO',
    colLblNm: 'SO Item No.',
    colWth: 100,
    horzAlgnCd: 'C',
    visible: true,
    display: true,
  },
  {
    colNm: 'SO_ITEM_QTY',
    colLblNm: 'SO Item Qty',
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

  // SHT_NM 은 **'main'** 이다 — 이 팝업은 planDetail 그리드에서 열리지만 API 매핑
  //   (SCM_ADM_MNU_BTN_MPG_M)과 버튼권한을 SSP0021/main 으로 등록한다. 자매 SSP0060·SSP0200 도
  //   main 으로 통일돼 있다(SSP0015 는 종전 confirmDetail 로 호출해 @AuthCheck 해석 단계에서
  //   막혔고 SYS_LOG 기록조차 남지 않았다 — 같은 함정 반복 금지).
  //   등록: .atlas/gscm-design/SSP0021/design/21_register_sibling_port_btn_auth.sql
  const { data: res } = useQuery({
    queryKey: [
      'ssp0021OrderDetail',
      data?.divisionId,
      data?.erpSoNo,
      data?.confirmId,
      data?.itemId,
    ],
    queryFn: async () => {
      const r = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${ORDER_DETAIL_BTN}/call-proc`, {
        divisionId: data?.divisionId ?? '',
        erpSoNo: data?.erpSoNo ?? '',
        confirmId: data?.confirmId ?? '',
        itemId: data?.itemId ?? '',
      });
      return (r.data?.result as { o_rc1?: OrderDetailRow[] })?.o_rc1 ?? [];
    },
    // SO 가 없으면(공백 또는 SP 플레이스홀더 '-') 조회하지 않는다. 팝업 오픈 자체는 호출부
    //   (ShipmentPlanAutoEssDetailGrid ERP_SO_NO 분기)가 막지만, SO 없이 열리는 경로가 생겨도
    //   무의미한 SP 호출이 나가지 않게 여기서도 막는다. '-' 의 출처는 PKG_SSP0021 L3880.
    enabled: open && !!data?.erpSoNo && data.erpSoNo.trim() !== '-',
    // 전역 기본값 staleTime: Infinity 를 그대로 두면 같은 SO 재오픈 시 영영 재조회하지 않아 옛
    //   결과가 고정된다(SSP0200 에서 실제 발생). ERP 연동 주문상세라 매번 최신이어야 한다.
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
