/**
 * Request Info Popup (Request Confirm Detail) — shipping 도메인 공용.
 *   AS-IS SSP0060_ShipmentPlanConfirmDetailPopup(SSP0060)·SCM0002_ShipmentPlanRequestPopup(SSP0021) 이식.
 *   Detail 그리드의 CHANGE_REQ_NO 셀 더블클릭(값 있을 때) → 이 팝업. 변경요청의 Confirmed(확정) vs
 *   Change(변경) 값을 나란히 보여주는 읽기전용 팝업이다.
 *
 * 두 AS-IS 팝업은 SSP0060 쪽이 상위집합이다(헤더 + Confirmed/Change 2단 + Confirm/Plan ID·Diff Qty·
 *   Change Reason·Reason Detail). SCM0002(SSP0021)는 그 부분집합이라 **SSP0060 레이아웃으로 커버**한다
 *   (사용자 결정 2026-10-20 — 항목 대사 결과 데이터 손실 없음. Title 1필드만 미표시).
 *
 * 데이터 proc(화면별 등록, call-proc action=SEARCH):
 *   - SSP0060: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING (배포·등록 완료, ora.py 실측)
 *   - SSP0021: 동일 proc 재사용 권장(변경요청은 CHANGE_REQ_NO 키라 화면 비종속) — SSP0021/confirmDetail
 *     버튼매핑을 이 proc 으로 등록해야 한다(운영 메타, 사용자 실행). 미등록이면 조회가 비어 팝업이 빈다.
 *   IN  = changeRequestNo / userId / language (proc P_CHANGE_REQUEST_NO/P_USER_ID/P_LANGUAGE)
 *   OUT = o_rc1(그리드 라인) · o_rc2(헤더 1행)
 *
 * AS-IS 호출부: cs CHANGE_REQ_NO 컬럼 셀 + 값 비공백이면 popup{ _sRequestNo }.ShowDialog().
 */
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { CustomDialog, DataGrid } from '@shared/components';
import { Box } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

interface Props {
  open: boolean;
  onClose: () => void;
  changeReqNo: string;
  /** 조회 proc 매핑용 메뉴 ID (예: 'SSP0060'). call-proc 경로에 쓴다. */
  menuId: string;
  /** 버튼매핑 시트명 — 두 화면 모두 'confirmDetail'. */
  sheetName: string;
}

// AS-IS 헤더 패널 필드(popup SetChangeRequestInfo) — Request No/Requestor/Dept/Approval/Dept.
interface HeaderInfo {
  CHANGE_REQ_NO?: string;
  REQUEST_USER?: string;
  REQUEST_DEPT?: string;
  APPROVAL_USER?: string;
  APPROVAL_DEPT_NAME?: string;
}

type DetailRow = Record<string, unknown>;

// AS-IS SSP0060_ShipmentPlanConfirmDetailPopup.cs InitSpread 표시 컬럼(visible=true 분).
//   Confirmed/Change 6컬럼씩 2단 병합 — sClsLblNm 으로 그룹(TWO_DEPTH). 독립 컬럼은 자기 라벨 그룹.
const grouped = (sCls: string) => ({ sClsLblNm: sCls });
// 주의: DataGrid 는 staticColumns 를 `display` 플래그로 거른다(미지정이면 렌더 제외) — 전 컬럼에
//   visible/display: true 를 주입한다. 이게 빠지면 No 코너만 그려지고 데이터 컬럼이 전부 사라진다.
const CONFIRM_DETAIL_COLUMNS: RawFlexGridColumnConfig[] = (
  [
  { colNm: 'CONFIRM_ID', colLblNm: 'Confirm/Plan ID', colWth: 110, horzAlgnCd: 'L' },
  { colNm: 'ERP_SO_NO', colLblNm: 'SO No', colWth: 110, horzAlgnCd: 'C' },
  { colNm: 'PROJECT_NAME', colLblNm: 'Project Name', colWth: 130, horzAlgnCd: 'L' },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 90, horzAlgnCd: 'L' },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 110, horzAlgnCd: 'L' },
  { colNm: 'FROM_SITE', colLblNm: 'From Site', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'TO_SITE', colLblNm: 'To Site', colWth: 100, horzAlgnCd: 'L' },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 70, horzAlgnCd: 'C' },
  // Confirmed(확정) 6컬럼
  { colNm: 'LT_DAY', colLblNm: 'L/T(Day)', colWth: 60, horzAlgnCd: 'C', ...grouped('Confirmed') },
  { colNm: 'ETD', colLblNm: 'ETD', colWth: 80, horzAlgnCd: 'C', ...grouped('Confirmed') },
  { colNm: 'ETA', colLblNm: 'ETA', colWth: 80, horzAlgnCd: 'C', ...grouped('Confirmed') },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 70, horzAlgnCd: 'C', ...grouped('Confirmed') },
  { colNm: 'SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 90, horzAlgnCd: 'C', ...grouped('Confirmed') },
  { colNm: 'SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 70, horzAlgnCd: 'R', ...grouped('Confirmed') },
  // Change(변경) 6컬럼 — NEW_* 바인딩
  { colNm: 'NEW_LT_DAY', colLblNm: 'L/T(Day)', colWth: 60, horzAlgnCd: 'C', ...grouped('Change') },
  { colNm: 'NEW_ETD', colLblNm: 'ETD', colWth: 80, horzAlgnCd: 'C', ...grouped('Change') },
  { colNm: 'NEW_ETA', colLblNm: 'ETA', colWth: 80, horzAlgnCd: 'C', ...grouped('Change') },
  { colNm: 'NEW_TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 70, horzAlgnCd: 'C', ...grouped('Change') },
  { colNm: 'NEW_SHIPMENT_DATE', colLblNm: 'Shipment Date', colWth: 90, horzAlgnCd: 'C', ...grouped('Change') },
  { colNm: 'NEW_SHIPMENT_CONFIRM_QTY', colLblNm: 'Qty', colWth: 70, horzAlgnCd: 'R', ...grouped('Change') },
  // 꼬리 독립 컬럼
  { colNm: 'DIFF_QTY', colLblNm: 'Diff Qty', colWth: 70, horzAlgnCd: 'R' },
  { colNm: 'CHANGE_REASON_CODE', colLblNm: 'Change Reason', colWth: 110, horzAlgnCd: 'L' },
  { colNm: 'CHANGE_REASON_DETAIL', colLblNm: 'Reason Detail', colWth: 130, horzAlgnCd: 'L' },
] as RawFlexGridColumnConfig[]
).map(c => ({ visible: true, display: true, ...c }));

// 헤더 패널 한 칸(라벨 + 읽기전용 값).
const HeaderField = ({ label, value }: { label: string; value: string }) => (
  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, minWidth: 0 }}>
    <Box sx={{ width: 90, flexShrink: 0, fontSize: 12, color: 'text.secondary' }}>{label}</Box>
    <Box
      sx={{
        flex: 1,
        minWidth: 0,
        px: 1,
        py: 0.5,
        fontSize: 12,
        border: '1px solid',
        borderColor: 'divider',
        borderRadius: 0.5,
        bgcolor: 'action.hover',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        whiteSpace: 'nowrap',
      }}
    >
      {value}
    </Box>
  </Box>
);

export const ConfirmDetailModal = ({ open, onClose, changeReqNo, menuId, sheetName }: Props) => {
  const session = useSessionStore(s => s.session);
  const gridRef = useRef<FlexGridType>();

  const { data } = useQuery({
    queryKey: ['confirmDetail', menuId, sheetName, changeReqNo, session.userId, session.langCd],
    queryFn: async () => {
      // useTabProcQuery 기본 action 과 동일한 SEARCH 경로(apiClient.callProc 와 같은 URL).
      const r = await apiClient.post(`/${menuId}/${sheetName}/SEARCH/call-proc`, {
        changeRequestNo: changeReqNo,
        userId: session.userId ?? '',
        language: session.langCd ?? '',
      });
      return r.data?.result as { o_rc1?: DetailRow[]; o_rc2?: HeaderInfo[] };
    },
    enabled: open && changeReqNo !== '',
    // 변경요청 상세는 CHANGE_REQ_NO 키라 재오픈마다 최신이 안전하다(ERP 연동 OrderDetail 과 같은 규약).
    staleTime: 0,
  });

  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);
  const header = useMemo(() => data?.o_rc2?.[0] ?? {}, [data]);

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1400}
      height={520}
      handleClose={onClose}
      disableButtonCancel
      disableScale
      // AS-IS 폼 캡션 그대로 — SSP0060_ShipmentPlanConfirmDetailPopup.Designer.cs `this.Text`.
      title='Request Info Popup'
      customContentArea={
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1, p: 1 }}>
          {/* 상단 헤더 패널 (AS-IS SetChangeRequestInfo — Request No/Requestor/Dept/Approval/Dept) */}
          <Box
            sx={{
              flexShrink: 0,
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              columnGap: 2,
              rowGap: 0.5,
            }}
          >
            <Box sx={{ gridColumn: '1 / -1' }}>
              <HeaderField label='Request No' value={header.CHANGE_REQ_NO ?? ''} />
            </Box>
            <HeaderField label='Requestor' value={header.REQUEST_USER ?? ''} />
            <HeaderField label='Dept Name' value={header.REQUEST_DEPT ?? ''} />
            <HeaderField label='Approval' value={header.APPROVAL_USER ?? ''} />
            <HeaderField label='Dept Name' value={header.APPROVAL_DEPT_NAME ?? ''} />
          </Box>
          {/* 그리드 (AS-IS siMain — 읽기전용, Confirmed/Change 2단 병합) */}
          <Box sx={{ flex: 1, minHeight: 0 }}>
            <DataGrid
              gridRef={gridRef}
              isReadOnly
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={CONFIRM_DETAIL_COLUMNS}
            />
          </Box>
        </Box>
      }
    />
  );
};
