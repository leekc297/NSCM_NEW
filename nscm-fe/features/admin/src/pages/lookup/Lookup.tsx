import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import _ from '@foundation/lodash';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { LookupDetailGrid } from './components/LookupDetailGrid';
import { LookupForm } from './components/LookupForm';
import { LookupMasterGrid } from './components/LookupMasterGrid';
import type { RESPONSE_SET } from './lookup.constants';
import { MENU_ID, SHEETS } from './lookup.constants';
import styles from './Lookup.module.scss';
import {
  EMPTY_LOOKUP_DETAIL_ROW,
  EMPTY_LOOKUP_MASTER_ROW,
  findDuplicateDetailRow,
  findDuplicateMasterRow,
  sanitizeDetailRow,
} from './lookup.utils';
import { useLookupStore } from './useLookupStore';

export const Lookup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const masterGridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>>>();
  const masterGridFilterRef = useRef<FlexGridFilter>();
  const detailGridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>>>();
  const detailGridFilterRef = useRef<FlexGridFilter>();

  const filters = useLookupStore(state => state.filters);
  const searchParams = useLookupStore(state => state.searchParams);
  const isOpenSearchArea = useLookupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useLookupStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useLookupStore(state => state.fetchStaticColumns);
  const activeGrid = useLookupStore(state => state.activeGrid);
  const setFilters = useLookupStore(state => state.setFilters);
  const selectedLookupType = useLookupStore(state => state.selectedLookupType);
  const masterStaticColumns = useLookupStore(state => state.staticColumns.lookupMaster);
  const detailStaticColumns = useLookupStore(state => state.staticColumns.lookupDetail);

  const { saveWithValidation } = useSaveWithValidation();
  const queryClient = useQueryClient();
  const setToast = useMessageStore(state => state.setToast);

  const { data: masterData, refetch: refetchMaster } = useTabProcQuery<
    MENU_ID,
    SHEETS.LOOKUP_MASTER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
    filters: filters[SHEETS.LOOKUP_MASTER],
    enabled: !!filters[SHEETS.LOOKUP_MASTER],
  });

  const { data: detailData } = useTabProcQuery<MENU_ID, SHEETS.LOOKUP_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    filters: filters[SHEETS.LOOKUP_DETAIL],
    enabled: !!filters[SHEETS.LOOKUP_DETAIL],
  });

  const { mutate: mutateMaster } = useProcMutation<
    MENU_ID,
    SHEETS.LOOKUP_MASTER,
    RESPONSE_SET.SAVE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
  });

  const { mutate: mutateDetail } = useProcMutation<
    MENU_ID,
    SHEETS.LOOKUP_DETAIL,
    RESPONSE_SET.SAVE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    onSuccess: () => {
      // AS-IS SCM0003_AFTER_LOOKUP_MASTER_DETAIL — Lookup Detail 저장 후처리 (fire-and-forget).
      // AS-IS DoAfterSave 의 try/catch 빈 catch 패턴 보존 — 실패해도 사용자 흐름 차단 X.
      void apiClient
        .post(`/${MENU_ID}/${SHEETS.LOOKUP_DETAIL}/AFTER_SAVE/call-proc`, {
          programId: MENU_ID,
          sheetName: selectedLookupType ?? '',
          debugMode: 'F',
        })
        .catch((e: unknown) => {
          // eslint-disable-next-line no-console
          console.warn('[SYS0010] AFTER_SAVE post-process failed (non-blocking):', e);
        });

      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    },
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const handleSubmit = () => {
    const next = { ...searchParams };
    if (_.isEqual(next, filters[SHEETS.LOOKUP_MASTER])) void refetchMaster();
    else setFilters();
  };

  const onInsert = () => {
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      if (!selectedLookupType) {
        void setAlert({
          type: 'alert',
          content: t('LBL00620', 'Please select a Lookup Type first.'),
        });
        return;
      }
      GridAction.addRow(detailGridRef.current, {
        ...EMPTY_LOOKUP_DETAIL_ROW,
        LOOKUP_TYPE: selectedLookupType,
      });
      return;
    }
    if (!masterGridRef.current) return;
    GridAction.addRow(masterGridRef.current, { ...EMPTY_LOOKUP_MASTER_ROW });
  };

  const onDelete = () => {
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      GridAction.removeRow(detailGridRef.current);
      return;
    }
    if (!masterGridRef.current) return;
    GridAction.removeRow(masterGridRef.current);
  };

  const onSave = () => {
    if (activeGrid === 'sub') {
      const rows = detailData?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
      const duplicate = findDuplicateDetailRow(rows);
      if (duplicate) {
        void setAlert({
          type: 'alert',
          content: t('MSG00060', '_동일한 {0}이(가) 존재합니다.'),
        });
        return;
      }
      const sanitized = rows.map(sanitizeDetailRow);
      saveWithValidation(sanitized, detailStaticColumns, mutateDetail);
      return;
    }
    const rows = masterData?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
    const duplicate = findDuplicateMasterRow(rows);
    if (duplicate) {
      void setAlert({
        type: 'alert',
        content: t('MSG00060', '_동일한 {0}이(가) 존재합니다.'),
      });
      return;
    }
    saveWithValidation(rows, masterStaticColumns, mutateMaster);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: onInsert,
    delete: onDelete,
    save: onSave,
    manual: false,
    upload: false,
  };

  const dataCount =
    activeGrid === 'sub' ? (detailData?.o_rc?.length ?? 0) : (masterData?.o_rc?.length ?? 0);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <LookupForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={activeGrid === 'sub' ? detailGridRef : masterGridRef}
        gridFilter={activeGrid === 'sub' ? detailGridFilterRef : masterGridFilterRef}
        dataCount={dataCount}
        excelFileName='Lookup'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <div className={styles.outerModule}>
        <TitleArea isSubTitle title={t('LBL00618', 'Lookup Type')} depth='h4' />
        <div className={styles.tableWrapper}>
          <div className={styles.masterGrid}>
            <LookupMasterGrid
              gridRef={masterGridRef}
              gridFilterRef={masterGridFilterRef}
              data={masterData?.o_rc ?? []}
            />
          </div>
          <div className={styles.innerModule}>
            <TitleArea isSubTitle title={t('LBL00619', 'Lookup Values')} depth='h4' />
            <div className={styles.detailGrid}>
              <LookupDetailGrid
                gridRef={detailGridRef}
                gridFilterRef={detailGridFilterRef}
                data={detailData?.o_rc ?? []}
              />
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
