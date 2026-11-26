/**
 * SSP0019 REQUEST_NO(=CHANGE_REQ_NO) 드릴다운 Request Info 팝업 — AS-IS SCM0002_ShipmentPlanRequestPopup 이식.
 *   Shipment Change History 그리드 REQUEST_NO 이미지셀 클릭(값 있을 때) → 이 팝업(design 03 §3-4 / 00 §4e #1).
 *   상단 폼(요청정보, O_RC2) + 하단 그리드(Confirmed vs Change 비교, O_RC1) 읽기전용.
 *
 * 조회 proc = PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING(P_CHANGE_REQUEST_NO, P_LANGUAGE,
 *   O_RC1 비교그리드 / O_RC2 요청폼) = AS-IS SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(SCM0002.cs:240, 2파라미터).
 *   API_M(P_SSP0003_GET_DRAFTING)·PROC_M 은 SSP0003 등록분 재사용, SSP0019/main 버튼+권한만 등록
 *   (design/08_register_confirm_detail_btn_auth.sql). 호출: /SSP0019/main/GET_REQ_DRAFTING/call-proc.
 *   자매 동형: shipment-plan-confirm-detail/ShipmentRequestDetailModal(SSP0012)·
 *   shipment-plan-mobility-it/ShipmentChangeRequestDraftingModal(SSP0015) — 동일 AS-IS 팝업·동일 proc.
 *   컬럼/레이아웃은 AS-IS SCM0002.cs InitSpread(L138~180)·SetChangeRequestInfo(L267~287) 실측 1:1.
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

import { MENU_ID, REQ_DRAFTING_BTN, SHEETS } from '../../shipment-change-history.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  requestNo?: string;
}

type GridRow = Record<string, unknown>;
type FormRow = Record<string, unknown>;

// 2줄로 접히는 leaf 헤더 라벨을 수용하는 맨 아래 헤더 행 높이(px). 자매 ConfirmDetailModal 과 동일.
const LEAF_HEADER_HEIGHT = 34;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS SCM0002.cs InitSpread 컬럼(L138~180) — 식별열 7 + "Confirmed"/"Change" 2단 그룹헤더 6+6 + CONFIRM_ID.
//   sClsLblNm 로 2단 그룹헤더(Confirmed/Change). 식별열·CONFIRM_ID 는 그룹 없음. Freeze(0, INCOTERMS+1)=7열.
const DRAFTING_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'ERP_SO_NO', colLblNm: 'SO No', colWth: 100, horzAlgnCd: 'C', fixed: true, visible: true, display: true },
  { colNm: 'PROJECT_NAME', colLblNm: 'Project Name', colWth: 110, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 90, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 100, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'FROM_SITE', colLblNm: 'From Site', colWth: 70, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'TO_SITE', colLblNm: 'To Site', colWth: 100, horzAlgnCd: 'L', fixed: true, visible: true, display: true },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 70, horzAlgnCd: 'C', fixed: true, visible: true, display: true },
  // Confirmed(확정) 6컬럼
  { colNm: 'LT_DAY', colLblNm: 'L/T(Day)', colWth: 65, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'ETD', colLblNm: 'ETD', colWth: 85, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'ETA', colLblNm: 'ETA', colWth: 85, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 70, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 95, horzAlgnCd: 'C', sClsLblNm: 'Confirmed', visible: true, display: true },
  { colNm: 'SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 75, horzAlgnCd: 'R', sClsLblNm: 'Confirmed', visible: true, display: true },
  // Change(변경) 6컬럼 — NEW_* 바인딩
  { colNm: 'NEW_LT_DAY', colLblNm: 'L/T(Day)', colWth: 65, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_ETD', colLblNm: 'ETD', colWth: 85, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_ETA', colLblNm: 'ETA', colWth: 85, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 70, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 95, horzAlgnCd: 'C', sClsLblNm: 'Change', visible: true, display: true },
  { colNm: 'NEW_SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 75, horzAlgnCd: 'R', sClsLblNm: 'Change', visible: true, display: true },
  // 마지막 Confirm ID (AS-IS cs L160, 그룹 없음·후미 스크롤 열).
  { colNm: 'CONFIRM_ID', colLblNm: 'Confirm ID', colWth: 110, horzAlgnCd: 'L', visible: true, display: true },
];

// 요청정보 폼 셀 — 라벨/값 배치(4열: 라벨 | 값 | 라벨 | 값).
const FLabel = ({ children }: { children: string }) => (
  <Box sx={{ color: '#555', fontSize: 12, textAlign: 'right', alignSelf: 'center', pr: 0.5 }}>
    {children}
  </Box>
);
const FValue = ({ children, wide, tall }: { children: string; wide?: boolean; tall?: boolean }) => (
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

// 요청정보 폼 (O_RC2) — AS-IS SetChangeRequestInfo(SCM0002.cs:267~287) 8필드, AS-IS 화면 배치 그대로:
//   Request No(wide) / Requestor|Dept / Approval|Dept / Title|Change Reason / Reason Detail(wide tall).
const RequestForm = ({ form, requestNo }: { form: FormRow | null; requestNo: string }) => (
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
    <FValue wide>{str(form?.CHANGE_REQ_NO) || requestNo}</FValue>
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

export const ShipmentPlanRequestModal = ({ open, modalClose, requestNo }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const langCd = useSessionStore(s => s.session.langCd);

  // P_SSP0003_GET_REQ_DRAFTING — o_rc1=비교그리드 / o_rc2=요청폼. SHT_NM='main'(버튼/권한 등록).
  const { data: res } = useQuery({
    queryKey: ['ssp0019ReqDrafting', requestNo, langCd],
    queryFn: async () => {
      const r = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${REQ_DRAFTING_BTN}/call-proc`, {
        changeRequestNo: requestNo,
        language: langCd ?? '',
      });
      const result = r.data?.result as { o_rc1?: GridRow[]; o_rc2?: FormRow[] } | undefined;
      return { grid: result?.o_rc1 ?? [], form: result?.o_rc2?.[0] ?? null };
    },
    enabled: open && !!requestNo,
    staleTime: 0,
  });

  const rows = useMemo(() => withRowNo(res?.grid ?? []), [res]);
  const staticColumns = useMemo(() => [buildNoColumn('No'), ...DRAFTING_COLUMNS], []);

  if (!requestNo) return null;

  return (
    <CustomDialog
      size={1180}
      height={560}
      position='basic'
      open={open}
      title={t('_ssp0019.requestDetailTitle', { defaultValue: 'Request Info Popup' })}
      handleClose={modalClose}
      customContentArea={
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1.5, p: 1.5 }}>
          {/* AS-IS 섹션 캡션 "Request Confirm Detail"(가운데 굵게) — 자매 SSP0012 동일. */}
          <Box sx={{ fontWeight: 700, textAlign: 'center', fontSize: 14 }}>
            {t('_ssp0019.requestDetailSection', { defaultValue: 'Request Confirm Detail' })}
          </Box>
          <RequestForm form={res?.form ?? null} requestNo={requestNo} />
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
              buttonLabel={t('_ssp0019.close', { defaultValue: 'Close' })}
              onClick={modalClose}
            />
          </Box>
        </Box>
      }
    />
  );
};
