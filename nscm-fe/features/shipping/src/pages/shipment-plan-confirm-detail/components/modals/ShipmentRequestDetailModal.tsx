/**
 * SSP0012 변경요청 상세(Request Info) 팝업 — AS-IS SCM0002_ShipmentPlanRequestPopup 이식 (W10/G3).
 *   Shipment Plan Confirm Detail 그리드의 CHANGE_REQ_NO 셀 클릭(값 있을 때) → 이 팝업.
 *   상단 폼(요청정보, O_RC2) + 하단 그리드(Confirmed vs Change 비교, O_RC1) 읽기전용.
 *
 * 조회 proc = PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING(P_CHANGE_REQUEST_NO, P_LANGUAGE,
 *   O_RC1 비교그리드 / O_RC2 요청폼 / O_RESULT_CURSOR) = AS-IS SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING.
 *   SSP0003 등록분이 이미 배포 — API_M(P_SSP0003_GET_DRAFTING)·PROC_M 재사용, SSP0012/main 버튼+권한만 등록
 *   (design/06_register_change_req_drafting_btn_auth.sql). 자매 구현: shipment-plan-mobility-it/ShipmentChangeRequestDraftingModal.
 *   컬럼/레이아웃은 AS-IS SCM0002 cs L138~178(AddColumn·ColumnHeaderSpan)·O_RC2 SELECT 실측(자매와 동일 계약).
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
import { useSessionStore } from '@shared/stores';

import { MENU_ID, REQ_DRAFTING_BTN, SHEETS } from '../../shipment-plan-confirm-detail.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  changeReqNo?: string;
}

type GridRow = Record<string, unknown>;
type FormRow = Record<string, unknown>;

// 2줄로 접히는 leaf 헤더 라벨을 수용하는 맨 아래 헤더 행 높이(px). 자매 ConfirmDetailModal 과 동일.
const LEAF_HEADER_HEIGHT = 34;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS SCM0002 그리드 컬럼 — 식별열 + "Confirmed"/"Change" 2단 그룹헤더(cs L138~178).
//   sClsLblNm 로 2단 그룹헤더 렌더(Confirmed/Change). 식별열은 그룹 없음(스팬) + 좌측 고정.
const DRAFTING_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'ERP_SO_NO', colLblNm: 'SO No', colWth: 110, horzAlgnCd: 'C', fixed: true, visible: true, display: true },
  { colNm: 'PROJECT_NAME', colLblNm: 'Project Name', colWth: 110, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 90, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 110, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'FROM_SITE', colLblNm: 'From Site', colWth: 80, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'TO_SITE', colLblNm: 'To Site', colWth: 110, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 75, horzAlgnCd: 'C', fixed: true, visible: true, display: true },
  // Confirmed
  { colNm: 'LT_DAY', colLblNm: 'L/T(Day)', colWth: 70, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'ETD', colLblNm: 'ETD', colWth: 90, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'ETA', colLblNm: 'ETA', colWth: 90, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 75, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 100, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 90, horzAlgnCd: 'R', sClsLblNm: 'Confirmed', visible: true, display: true },
  // Change
  { colNm: 'NEW_LT_DAY', colLblNm: 'L/T(Day)', colWth: 70, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_ETD', colLblNm: 'ETD', colWth: 90, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_ETA', colLblNm: 'ETA', colWth: 90, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 75, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 100, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 90, horzAlgnCd: 'R', sClsLblNm: 'Change', visible: true, display: true },
  // 마지막 Confirm ID (AS-IS cs L160). 그룹 없음(후미 스크롤 열).
  { colNm: 'CONFIRM_ID', colLblNm: 'Confirm ID', colWth: 130, horzAlgnCd: 'L', visible: true, display: true },
];

// 요청정보 폼 셀 — 라벨/값 배치(4열: 라벨 | 값 | 라벨 | 값).
const FLabel = ({ children }: { children: string }) => (
  <Box sx={{ color: '#555', fontSize: 12, textAlign: 'right', alignSelf: 'center', pr: 0.5 }}>
    {children}
  </Box>
);
const FValue = ({
  children,
  wide,
  tall,
}: {
  children: string;
  wide?: boolean;
  tall?: boolean;
}) => (
  <Box
    sx={{
      gridColumn: wide ? '2 / 5' : undefined,
      minHeight: tall ? 64 : 26,
      border: '1px solid #d0d0d0',
      borderRadius: '2px',
      px: 1,
      py: '4px',
      fontSize: 12,
      bgcolor: '#fafafa',
      whiteSpace: wide ? 'pre-wrap' : 'nowrap',
      overflow: tall ? 'auto' : 'hidden',
      textOverflow: tall ? undefined : 'ellipsis',
    }}
  >
    {children}
  </Box>
);

// 요청정보 폼 (O_RC2) — AS-IS "Request Confirm Detail" 섹션(라벨|값|라벨|값 2단).
const RequestForm = ({ form, changeReqNo }: { form: FormRow | null; changeReqNo: string }) => (
  <Box
    sx={{
      display: 'grid',
      gridTemplateColumns: '88px minmax(0, 1fr) 88px minmax(0, 1fr)',
      columnGap: 1,
      rowGap: 0.75,
      alignItems: 'stretch',
    }}
  >
    <FLabel>Request No</FLabel>
    <FValue wide>{str(form?.CHANGE_REQ_NO) || changeReqNo}</FValue>
    <FLabel>Requestor</FLabel>
    <FValue>{str(form?.REQUEST_USER)}</FValue>
    <FLabel>Dept Name</FLabel>
    <FValue>{str(form?.REQUEST_DEPT)}</FValue>
    <FLabel>Approval</FLabel>
    <FValue>{str(form?.APPROVAL_USER)}</FValue>
    <FLabel>Dept Name</FLabel>
    <FValue>{str(form?.APPROVAL_DEPT_NAME)}</FValue>
    <FLabel>Title</FLabel>
    <FValue>{str(form?.REQUEST_TITLE)}</FValue>
    <FLabel>Change Reason</FLabel>
    <FValue>{str(form?.CHANGE_REASON_CODE)}</FValue>
    <FLabel>Reason Detail</FLabel>
    <FValue wide tall>
      {str(form?.CHANGE_REASON_DETAIL)}
    </FValue>
  </Box>
);

export const ShipmentRequestDetailModal = ({ open, modalClose, changeReqNo }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const langCd = useSessionStore(s => s.session.langCd);

  // P_SSP0003_GET_REQ_DRAFTING — o_rc1=비교그리드 / o_rc2=요청폼. SHT_NM='main'(버튼/권한 등록).
  const { data: res } = useQuery({
    queryKey: ['ssp0012ReqDrafting', changeReqNo, langCd],
    queryFn: async () => {
      const r = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${REQ_DRAFTING_BTN}/call-proc`, {
        changeRequestNo: changeReqNo,
        language: langCd ?? '',
      });
      const result = r.data?.result as { o_rc1?: GridRow[]; o_rc2?: FormRow[] } | undefined;
      return { grid: result?.o_rc1 ?? [], form: result?.o_rc2?.[0] ?? null };
    },
    enabled: open && !!changeReqNo,
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(res?.grid ?? []), [res]);
  const staticColumns = useMemo(() => [buildNoColumn('No'), ...DRAFTING_COLUMNS], []);

  if (!changeReqNo) return null;

  return (
    <CustomDialog
      size={1180}
      height={560}
      position='basic'
      open={open}
      title={t('_ssp0012.requestDetailTitle', { defaultValue: 'Request Info Popup' })}
      handleClose={modalClose}
      customContentArea={
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1.5, p: 1.5 }}>
          <Box sx={{ fontWeight: 700, textAlign: 'center', fontSize: 14 }}>
            {t('_ssp0012.requestDetailSection', { defaultValue: 'Request Confirm Detail' })}
          </Box>
          <RequestForm form={res?.form ?? null} changeReqNo={changeReqNo} />
          <Box sx={{ flex: 1, minHeight: 0 }}>
            <DataGrid
              gridRef={gridRef}
              isReadOnly
              headersVisibility={HeadersVisibility.Column}
              staticColumns={staticColumns}
              itemsSource={rows as never}
              // 2단 헤더(Confirmed/Change) 아래 리프 라벨("Trans Mode"·"Shipment Date")이 두 줄로
              //   접혀 둘째 줄이 잘린다. 공용 headerRowHeight(columnHeaders.rows.defaultSize)는 식별열이
              //   두 행을 세로병합한 명시 높이(48/2=24)를 못 이겨 안 먹으므로, 자매 ConfirmDetailModal
              //   선례대로 맨 아래(leaf) 헤더 행 높이를 직접 올린다. updatedLayout 재적용 + 동일값 guard
              //   로 레이아웃 갱신에도 유지 & 루프 방지.
              initialized={grid => {
                const applyLeafHeaderHeight = () => {
                  const headerRows = grid.columnHeaders?.rows;
                  if (!headerRows || headerRows.length === 0) return;
                  const leaf = headerRows[headerRows.length - 1];
                  if (Math.round(leaf.height ?? 0) !== LEAF_HEADER_HEIGHT)
                    leaf.height = LEAF_HEADER_HEIGHT;
                };
                applyLeafHeaderHeight();
                grid.updatedLayout.addHandler(applyLeafHeaderHeight);
              }}
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
