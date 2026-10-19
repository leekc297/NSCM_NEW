import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
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
  const setAlert = useMessageStore.getState().setAlert;
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

  // Request(Drafting) 저장 — 13 IN '^'-폴딩 단일 객체 + apiClient.post 직배선.
  //   SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN 도 파라미터 전건 VARCHAR → BE 미폴딩 + SP '^'-분해 다건이라
  //   useProcMutation 의 배열 {data:[]} 전송은 13 IN 전건 null 바인딩 → Drafting 미생성인데 성공 토스트
  //   (gap-audit iter-5 G03). Main/Confirm 저장과 동일 처방(자매 SSP0015 선례).
  const { mutate: mutateRequest } = useMutation({
    mutationKey: [tabId, SHEETS.REQUEST_DRAFTING_MAIN, 'SAVE'],
    mutationFn: async (payload: Record<string, string>) => {
      const res = await apiClient.post(
        `/${MENU_ID}/${SHEETS.REQUEST_DRAFTING_MAIN}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      // 업무결과 검사 (gap-audit G05) — o_rc1 RESULT_CODE!='S' 면 미저장(false-success 방지).
      const result = (
        res.data as {
          result?: {
            o_rc1?: { RESULT_CODE?: unknown; ERR_MESSAGE?: unknown }[];
            o_rc2?: { ERR_MESSAGE?: unknown }[];
          };
        }
      )?.result;
      const rc = result?.o_rc1?.[0];
      const resultCode = str(rc?.RESULT_CODE);
      if (resultCode && resultCode !== 'S') {
        const errMsg = str(rc?.ERR_MESSAGE) || str(result?.o_rc2?.[0]?.ERR_MESSAGE);
        throw new Error(errMsg || t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      void refetch(); // 팝업 내 목록만 갱신 — Main 재조회는 닫힘 시 페이지가 수행(R8)
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
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
    // payload 키 = SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN 13 IN(camelCase = PROC_M COL_NM). 컬럼별 '^'-폴딩.
    //   activeFlag/userId/title/programId 는 상수지만 세그먼트 수 정합을 위해 행마다 반복 폴딩한다.
    const fold = (sel: (r: Record<string, unknown>) => string): string =>
      rows.map(r => sel(r as Record<string, unknown>)).join('^');
    const payload: Record<string, string> = {
      activeFlag: rows.map(() => 'I').join('^'),
      divisionId: fold(r => str(r.DIVISION_ID)),
      changeReqNo: fold(r => str(r.CHANGE_REQ_NO)),
      confirmId: fold(r => str(r.CONFIRM_ID)),
      shipmentQty: fold(r => str(r.SHIPMENT_CONFIRM_QTY)),
      shipmentDate: fold(r => str(r.SHIPMENT_DATE)),
      newYyyymmdd: fold(r => str(r.NEW_YYYYMMDD)),
      newQty: fold(r => str(r.NEW_QTY)),
      userId: rows.map(() => userId).join('^'),
      changeReasonCode: fold(r => str(r.CHANGE_REASON_CODE)),
      changeReasonDetail: fold(r => str(r.CHANGE_REASON_DETAIL)),
      title: rows.map(() => title).join('^'),
      programId: rows.map(() => PROGRAM_ID).join('^'),
    };
    mutateRequest(payload);
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
