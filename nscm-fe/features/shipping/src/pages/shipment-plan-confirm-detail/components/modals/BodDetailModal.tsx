/**
 * SSP0012 BOD 상세 팝업 — AS-IS SCM0002_ShipmentPlanConfirmBODPopup 이식 (W9).
 *   Shipment Plan Confirm Detail 그리드의 INCOTERMS 셀 클릭 → 이 팝업(경로/사이트/포트/운송요일 상세).
 *
 * 조회 proc = PKG_SCM0002.P_SCM0002_GET_SHIPMENT_PLAN_CONFIRM_BOD_POPUP(P_DIVISION_ID, P_BOD,
 *   O_RC1 경로상세 / O_RESULT_CURSOR) = AS-IS SCM.SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP(p_division_id, p_bod).
 *   컬럼/2단 헤더는 AS-IS cs L143~186(AddTextColumn·ColumnHeaderSpan) 실측 — From Site/To Site(각 4열),
 *   Departure Port/Arrival Port(각 3열) 스팬, Division·Trans Mode·Lead Time·Days 단독. 전열 읽기전용.
 *
 *   공유 팝업(AS-IS SSP0001+SSP0012). 현재 TO-BE 소비자는 SSP0012 하나라 화면 로컬 구현(배치 A) —
 *   SSP0001 전환 시 shared 컴포넌트로 승격. 등록: design/07_register_bod_popup_btn_auth.sql(멱등).
 *   divisionId 는 EE 분기 시 ORIGIN_FROM_DIVISION_ID 가 들어온다(그리드 clickHandler 에서 해소).
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

import { BOD_DETAIL_BTN, MENU_ID, SHEETS } from '../../shipment-plan-confirm-detail.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId?: string;
  bodId?: string;
}

type GridRow = Record<string, unknown>;

// AS-IS SCM0002 BOD 팝업 컬럼(cs L143~186). sClsLblNm 로 2단 그룹헤더, 나머지는 단독(단일 tier).
const BOD_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  // From Site (4열 스팬)
  { colNm: 'FROM_SITE', colLblNm: 'Code', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'From Site', visible: true, display: true },
  { colNm: 'FROM_CITY_NAME', colLblNm: 'City Name', colWth: 130, horzAlgnCd: 'L', sClsLblNm: 'From Site', visible: true, display: true },
  { colNm: 'FROM_COUNTRY', colLblNm: 'Country', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'From Site', visible: true, display: true },
  { colNm: 'FROM_CITY', colLblNm: 'City', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'From Site', visible: true, display: true },
  // To Site (4열 스팬)
  { colNm: 'TO_SITE', colLblNm: 'Code', colWth: 100, horzAlgnCd: 'L', sClsLblNm: 'To Site', visible: true, display: true },
  { colNm: 'TO_CITY_NAME', colLblNm: 'City Name', colWth: 130, horzAlgnCd: 'L', sClsLblNm: 'To Site', visible: true, display: true },
  { colNm: 'TO_COUNTRY', colLblNm: 'Country', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'To Site', visible: true, display: true },
  { colNm: 'TO_CITY', colLblNm: 'City', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'To Site', visible: true, display: true },
  // 단독
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 40, horzAlgnCd: 'L', visible: true, display: true },
  // AS-IS 단독 "Lead Time"(LT_TOTAL). 공용 DataGrid 는 컬럼을 그룹명으로 묶어, 이 라벨이 아래 분해그룹
  //   sClsLblNm 'Lead Time' 과 같으면 7컬럼이 한 그룹으로 병합돼 순서가 당겨진다(AS-IS FarPoint 는 인덱스 배치라 충돌 없음).
  //   충돌 회피 위해 단독 컬럼은 'L/T' 로 표기(메인 그리드 L/T(Day) 와 동일 축약) — 분해그룹만 'Lead Time' 유지.
  { colNm: 'LT_TOTAL', colLblNm: 'L/T', colWth: 40, horzAlgnCd: 'R', visible: true, display: true },
  // Departure Port (3열 스팬)
  { colNm: 'D_PORT_NAME', colLblNm: 'Port', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Departure Port', visible: true, display: true },
  { colNm: 'D_COUNTRY', colLblNm: 'Country', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Departure Port', visible: true, display: true },
  { colNm: 'D_PORT_CODE', colLblNm: 'Port Code', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Departure Port', visible: true, display: true },
  // Arrival Port (3열 스팬)
  { colNm: 'A_PORT_NAME', colLblNm: 'Port', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Arrival Port', visible: true, display: true },
  { colNm: 'A_COUNTRY', colLblNm: 'Country', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Arrival Port', visible: true, display: true },
  { colNm: 'A_PORT_CODE', colLblNm: 'Port Code', colWth: 80, horzAlgnCd: 'L', sClsLblNm: 'Arrival Port', visible: true, display: true },
  // 운송 요일 Mon~Sun — AS-IS cs:189 "Departure days" 2단 그룹헤더(7열 스팬).
  { colNm: 'DAYS_MON', colLblNm: 'Mon', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_TUE', colLblNm: 'Tue', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_WED', colLblNm: 'Wed', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_THU', colLblNm: 'Thu', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_FRI', colLblNm: 'Fri', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_SAT', colLblNm: 'Sat', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  { colNm: 'DAYS_SUN', colLblNm: 'Sun', colWth: 40, horzAlgnCd: 'C', sClsLblNm: 'Departure days', visible: true, display: true },
  // Lead Time 구간별 분해 — AS-IS cs:173-178 + "Lead Time" 2단 그룹헤더(6열 스팬, cs:189). 전부 우측정렬 숫자.
  { colNm: 'LT_DEPARTURE_INLAND', colLblNm: 'Departure Inland', colWth: 80, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
  { colNm: 'LT_WAIT_SHIPPING', colLblNm: 'Waiting For Shipping', colWth: 100, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
  { colNm: 'LT_VOYAGE', colLblNm: 'Voyage', colWth: 60, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
  { colNm: 'LT_LAY_OFF_CLEARANCE', colLblNm: 'Lay Off/Customs Clearance', colWth: 110, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
  { colNm: 'LT_ARRIVAL_INLAND', colLblNm: 'Arrival Inland', colWth: 80, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
  { colNm: 'LT_SUM', colLblNm: 'Total L/T', colWth: 70, horzAlgnCd: 'R', sClsLblNm: 'Lead Time', visible: true, display: true },
];

export const BodDetailModal = ({ open, modalClose, divisionId, bodId }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);

  // P_SCM0002_GET_SHIPMENT_PLAN_CONFIRM_BOD_POPUP — o_rc1=경로상세. SHT_NM='main'(버튼/권한 등록).
  const { data: rowsRaw } = useQuery({
    queryKey: ['ssp0012BodDetail', divisionId, bodId],
    queryFn: async () => {
      // PROC_M IN COL_NM 과 일치해야 함 — 실등록 키는 divisionId / bod(= bodId 아님, DB 실측 2026-10-15).
      const r = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${BOD_DETAIL_BTN}/call-proc`, {
        divisionId: divisionId ?? '',
        bod: bodId ?? '',
      });
      const result = r.data?.result as { o_rc1?: GridRow[] } | undefined;
      return result?.o_rc1 ?? [];
    },
    enabled: open && !!divisionId && !!bodId,
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(rowsRaw ?? []), [rowsRaw]);
  const staticColumns = useMemo(() => [buildNoColumn('No'), ...BOD_COLUMNS], []);

  if (!divisionId || !bodId) return null;

  return (
    <CustomDialog
      size={1180}
      height={420}
      position='basic'
      open={open}
      title={t('_ssp0012.bodDetailTitle', { defaultValue: 'BOD Detail' })}
      handleClose={modalClose}
      customContentArea={
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1.5, p: 1.5 }}>
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
              buttonLabel={t('_ssp0012.close', { defaultValue: 'Close' })}
              onClick={modalClose}
            />
          </Box>
        </Box>
      }
    />
  );
};
