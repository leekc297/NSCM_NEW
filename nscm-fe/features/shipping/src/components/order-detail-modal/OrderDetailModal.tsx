/**
 * ERP Order Detail 팝업 (shipping 도메인 공용) — AS-IS SSP0300_OrderDetailPopup 이식.
 *   Shipment Plan/Confirm 계열 화면의 Detail 그리드 ERP_SO_NO 셀 더블클릭(값 있을 때) → 이 팝업.
 *   SO/DO 주문상세를 ERP_SO_NO 기준으로 조회하는 읽기전용 그리드다.
 *
 * AS-IS 호출부는 화면마다 동일하다 — `pop.Form_Load(_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, electrode_yn)`.
 *   5번째 electrode_yn 은 **컬럼 라벨만** 가르는 값이고(Y 면 첫 3컬럼 SO* → PO*, SSP0300_OrderDetailPopup.cs:133~145)
 *   조회 proc `P_SSP0300_GET_ORDER_DETAIL` 의 IN 은 4개(DIVISION_ID/ERP_SO_NO/CONFIRM_ID/ITEM_ID)뿐이라
 *   전송하지 않는다 — ALL_ARGUMENTS 실측: P_DIVISION_ID/P_ERP_SO_NO/P_CONFIRM_ID/P_ITEM_ID + O_RC1.
 *   이 proc 은 standalone PROCEDURE 로 배포돼 있고(STATUS=VALID) `SCM_ADM_API_M` 에도 화면 비종속
 *   공용으로 등록돼 있다(2026-10-08 ora.py 실측). 종전 각 화면 주석의 "PKG_SSP0300 미배포" 는
 *   패키지 이름으로만 찾아 생긴 오판이었다. 근거: .atlas/gscm-design/SSP0200/design/08_fix_order_detail_proc.sql
 *
 * 화면별 차이는 props(menuId/shtNm/btnId/electrode/closeLabel)로만 흡수한다 — 화면 전용 사본을 두지 않는다.
 *   버튼매핑·권한(SCM_ADM_MNU_BTN_MPG_M)은 화면마다 <menuId>/main/<btnId> 로 등록한다(SHT_NM='main'
 *   통일 — SSP0015 는 종전 confirmDetail 로 호출해 @AuthCheck 해석 단계에서 막혔다. 같은 함정 반복 금지).
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
  /** 조회 proc 매핑용 메뉴 ID (예: 'SSP0060'). API 경로·쿼리키에 쓴다. */
  menuId: string;
  /** 버튼매핑 시트명 — 전 화면 'main' 으로 통일돼 있다(SHEETS.MAIN). */
  shtNm: string;
  /** Order Detail 조회 버튼 ID (예: 'GET_ORDER_DETAIL', ORDER_DETAIL_BTN). */
  btnId: string;
  /**
   * 전극(electrode_yn='Y') 여부. true 면 첫 3컬럼 라벨이 SO* → PO* 로 바뀐다
   * (데이터 컬럼명 SO_NO/SO_ITEM_NO/SO_ITEM_QTY 는 동일, 라벨만 다름 — 팝업 cs:133~145). 기본 false.
   */
  electrode?: boolean;
  /** 닫기 버튼 라벨. 기본 'Close'(AS-IS 도 리소스가 아닌 리터럴). */
  closeLabel?: string;
}

// AS-IS SSP0300 그리드 컬럼(DO + Confirm ID 공통, 첫 3컬럼만 SO/PO 라벨이 갈림) — cs:133~150.
const buildOrderDetailColumns = (electrode: boolean): RawFlexGridColumnConfig[] => {
  const so = electrode ? 'PO' : 'SO';
  return [
    { colNm: 'SO_NO', colLblNm: `${so} NO.`, colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
    { colNm: 'SO_ITEM_NO', colLblNm: `${so} Item No.`, colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
    { colNm: 'SO_ITEM_QTY', colLblNm: `${so} Item Qty`, colWth: 110, horzAlgnCd: 'R', visible: true, display: true },
    { colNm: 'DO_NO', colLblNm: 'DO NO.', colWth: 120, horzAlgnCd: 'C', visible: true, display: true },
    { colNm: 'DO_ITEM_NO', colLblNm: 'DO Item No.', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
    { colNm: 'DO_ITEM_QTY', colLblNm: 'DO Item Qty.', colWth: 110, horzAlgnCd: 'R', visible: true, display: true },
    { colNm: 'CONFIRM_ID', colLblNm: 'Confirm ID', colWth: 130, horzAlgnCd: 'C', visible: true, display: true },
  ];
};

type OrderDetailRow = Record<string, unknown>;

export const OrderDetailModal = ({
  open,
  data,
  onClose,
  menuId,
  shtNm,
  btnId,
  electrode = false,
  closeLabel = 'Close',
}: Props) => {
  const gridRef = useRef<FlexGrid>(undefined);

  const { data: res } = useQuery({
    queryKey: [
      'orderDetail',
      menuId,
      shtNm,
      btnId,
      data?.divisionId,
      data?.erpSoNo,
      data?.confirmId,
      data?.itemId,
    ],
    queryFn: async () => {
      const r = await apiClient.post(`/${menuId}/${shtNm}/${btnId}/call-proc`, {
        divisionId: data?.divisionId ?? '',
        erpSoNo: data?.erpSoNo ?? '',
        confirmId: data?.confirmId ?? '',
        itemId: data?.itemId ?? '',
      });
      return (r.data?.result as { o_rc1?: OrderDetailRow[] })?.o_rc1 ?? [];
    },
    // SO 가 없으면(공백 또는 SP 플레이스홀더 '-') 조회하지 않는다. 팝업 오픈 자체는 호출부(Detail 그리드
    //   ERP_SO_NO 분기)가 막지만, SO 없이 열리는 경로가 생겨도 무의미한 SP 호출이 나가지 않게 여기서도 막는다.
    //   '-' 의 출처: PKG_SSP0060 L4491 / PKG_SSP0021 L3880 (`'-' AS ERP_SO_NO`).
    enabled: open && !!data?.erpSoNo && data.erpSoNo.trim() !== '-',
    // 전역 기본값 staleTime: Infinity 를 그대로 두면 같은 SO 재오픈 시 영영 재조회하지 않아 옛 결과가
    //   고정된다(SSP0200 에서 실제 발생, 2026-10-02). ERP 연동 주문상세라 매번 최신이어야 한다.
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(res ?? []), [res]);
  const staticColumns = useMemo(
    () => [buildNoColumn('No'), ...buildOrderDetailColumns(electrode)],
    [electrode]
  );

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
              buttonLabel={closeLabel}
              onClick={onClose}
            />
          </Box>
        </Box>
      }
    />
  );
};
