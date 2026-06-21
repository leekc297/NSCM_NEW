// SYS0012 Auth Approval — 관리자가 사용자 권한 신청 승인/반려
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { isEmpty } from 'lodash';
import { useEffect, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './auth-approval.constants';
import type { ApprovalRow } from './auth-approval.types';
import { AuthApprovalForm } from './components/AuthApprovalForm';
import { AuthApprovalGrid } from './components/AuthApprovalGrid';
import { AuthRejectPopup } from './components/AuthRejectPopup';
import { useAuthApprovalStore } from './useAuthApprovalStore';

const collectCheckedRows = <T,>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (const element of grid.rows) {
    const row = element;
    if (row?.isSelected) rows.push(row.dataItem as T);
  }
  return rows;
};

export const AuthApproval = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ApprovalRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>();

  const initialized = useAuthApprovalStore(s => s.initialized);
  const fetchSearchConditions = useAuthApprovalStore(s => s.fetchSearchConditions);
  const fetchStaticColumns = useAuthApprovalStore(s => s.fetchStaticColumns);
  const filters = useAuthApprovalStore(s => s.filters);
  const setFilter = useAuthApprovalStore(s => s.setFilter);
  const openSearchArea = useAuthApprovalStore(s => s.openSearchArea);
  const setOpenSearchArea = useAuthApprovalStore(s => s.setOpenSearchArea);

  const openRejectPopup = useAuthApprovalStore(s => s.openRejectPopup);
  const setOpenRejectPopup = useAuthApprovalStore(s => s.setOpenRejectPopup);
  const rejectTarget = useAuthApprovalStore(s => s.rejectTarget);
  const setRejectTarget = useAuthApprovalStore(s => s.setRejectTarget);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  useEffect(() => {
    if (!initialized) {
      void fetchSearchConditions();
      void fetchStaticColumns();
    }
    if (!filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = () => {
    setFilter();
    // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
    void fetchStaticColumns();
  };

  // SAVE 패턴 — useProcMutation 의 array wrap (`{data:[...]}`) 매핑 결함 회피
  // (메모리 `feedback_save_sp_bulk_payload_apiclient_post` — DMF0043 ContributeMain 표준).
  // apiClient.post 직접 호출 + 응답 코드 검사 + invalidateQueries.
  const handleApprove = async () => {
    const selected = collectCheckedRows(gridRef.current);
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00619', '_승인할 항목을 선택해 주십시오.') });
      return;
    }
    if (!isEmpty(selected.filter(item => item.STATUS === 'APPROVED'))) {
      void setAlert({ type: 'alert', content: t('MSG00621', '_승인대기중인 항목만 선택 해 주십시오.') });
      return;
    }
    if (!isEmpty(selected.filter(item => item.STATUS === 'REJECTED'))) {
      void setAlert({ type: 'alert', content: t('MSG00621', '_승인대기중인 항목만 선택 해 주십시오.') });
      return;
    }
    const validRows = selected.filter(r => !!r.REQUEST_ID);
    if (validRows.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00619', '_승인할 항목을 선택해 주십시오.') });
      return;
    }
    try {
      const response = await apiClient.post<{ code?: string; message?: string }>(
        `/${MENU_ID}/${SHEETS.MAIN}/APPROVE/call-proc`,
        { data: validRows.map(r => ({ REQUEST_ID: r.REQUEST_ID })) }
      );
      if (response.data?.code === '0') {
        await queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00622', '_승인 완료') });
      } else {
        void setAlert({
          type: 'alert',
          content: response.data?.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        });
      }
    } catch (err) {
      void setAlert({
        type: 'alert',
        content: (err as Error).message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
    }
  };

  const doReject = async (reason: string) => {
    // AS-IS BtnReject_Click L197 — popup 통과 후 2중 검증 (popup.reason.Length > 0)
    if (!reason || reason.trim().length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00181', '_Reject Reason을 입력하세요.') });
      return;
    }
    const validRows = rejectTarget.filter(r => !!r.REQUEST_ID);
    if (validRows.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00620', '_반려할 항목을 선택해 주십시오.') });
      return;
    }
    try {
      const response = await apiClient.post<{ code?: string; message?: string }>(
        `/${MENU_ID}/${SHEETS.MAIN}/REJECT/call-proc`,
        {
          data: validRows.map(r => ({
            REQUEST_ID: r.REQUEST_ID,
            REJECT_REASON: reason ?? '',
          })),
        }
      );
      if (response.data?.code === '0') {
        await queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00623', '_반려 완료') });
        setOpenRejectPopup(false);
      } else {
        void setAlert({
          type: 'alert',
          content: response.data?.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        });
      }
    } catch (err) {
      void setAlert({
        type: 'alert',
        content: (err as Error).message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
    }
  };

  const handleReject = () => {
    const selected = collectCheckedRows(gridRef.current);
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00620', '_반려할 항목을 선택해 주십시오.') });
      return;
    }
    if (!isEmpty(selected.filter(item => item.STATUS === 'APPROVED'))) {
      void setAlert({ type: 'alert', content: t('MSG00621', '_승인대기중인 항목만 선택 해 주십시오.') });
      return;
    }
    if (!isEmpty(selected.filter(item => item.STATUS === 'REJECTED'))) {
      void setAlert({ type: 'alert', content: t('MSG00621', '_승인대기중인 항목만 선택 해 주십시오.') });
      return;
    }
    setRejectTarget(selected);
    setOpenRejectPopup(true);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    delete: false,
    save: false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    { label: t('LBL00623', 'Approve'), action: () => handleApprove() },
    { label: t('LBL00624', 'Reject'), action: () => handleReject() },
  ];

  const rows = (data?.o_rc ?? []) as unknown as ApprovalRow[];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <AuthApprovalForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='AuthApproval'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      {openRejectPopup && <AuthRejectPopup onReject={doReject} />}
      <AuthApprovalGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
    </>
  );
};
