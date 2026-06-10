// SCM0009 Auth Approval — 관리자가 사용자 권한 신청 승인/반려
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './auth-approval.constants';
import type { ApprovalRow } from './auth-approval.types';
import { AuthApprovalForm } from './components/AuthApprovalForm';
import { AuthApprovalGrid } from './components/AuthApprovalGrid';
import { useAuthApprovalStore } from './useAuthApprovalStore';

const collectCheckedRows = <T,>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (let i = 0; i < grid.rows.length; i += 1) {
    const row = grid.rows[i];
    if (row?.isSelected) rows.push(row.dataItem as T);
  }
  return rows;
};

export const AuthApproval = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ApprovalRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const initialized = useAuthApprovalStore(s => s.initialized);
  const fetchSearchConditions = useAuthApprovalStore(s => s.fetchSearchConditions);
  const fetchStaticColumns = useAuthApprovalStore(s => s.fetchStaticColumns);
  const filters = useAuthApprovalStore(s => s.filters);
  const setFilter = useAuthApprovalStore(s => s.setFilter);
  const openSearchArea = useAuthApprovalStore(s => s.openSearchArea);
  const setOpenSearchArea = useAuthApprovalStore(s => s.setOpenSearchArea);

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

  const { mutate: mutateApprove } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: 'APPROVE' as never,
    tabId,
  });

  const { mutate: mutateReject } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: 'REJECT' as never,
    tabId,
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
  };

  const handleApprove = () => {
    const selected = collectCheckedRows(gridRef.current);
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: '승인할 항목을 선택해 주십시오.' });
      return;
    }
    const payload = selected.map(r => ({ REQUEST_ID: r.REQUEST_ID })) as never[];
    mutateApprove(payload, {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: '승인 완료' });
      },
    });
  };

  const handleReject = () => {
    const selected = collectCheckedRows(gridRef.current);
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: '반려할 항목을 선택해 주십시오.' });
      return;
    }
    const payload = selected.map(r => ({
      REQUEST_ID: r.REQUEST_ID,
      REJECT_REASON: '',
    })) as never[];
    mutateReject(payload, {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: '반려 완료' });
      },
    });
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
    { label: 'Approve', action: () => void handleApprove() },
    { label: 'Reject', action: () => void handleReject() },
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

      <AuthApprovalGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
    </>
  );
};
