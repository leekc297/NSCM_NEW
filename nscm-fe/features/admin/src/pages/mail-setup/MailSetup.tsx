import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MailCategoryGrid } from './components/MailCategoryGrid';
import { MailContentDialog } from './components/MailContentDialog';
import { MailMessageGrid } from './components/MailMessageGrid';
import { MailReceiverPanel } from './components/MailReceiverPanel';
import { MailSetupForm } from './components/MailSetupForm';
import { MailSqlDialog } from './components/MailSqlDialog';
import { MENU_ID, SHEETS, USE_TYPE_CODE } from './mail-setup.constants';
import type {
  AllReceiverRow,
  CategoryRow,
  MessageRow,
  SelReceiverRow,
} from './mail-setup.types';
import { createEmptyCategory, joinBulk, validateCyclePeriod } from './mail-setup.util';
import styles from './MailSetup.module.scss';
import { useMailSetupStore } from './useMailSetupStore';

const today = () => new Date().toISOString().slice(0, 10).replace(/-/g, '');

/** CRUD_TYPE 정규화 — 'C'(CREATE)도 신규 'I' 로 (SP action 규약은 I/M/D 3종) */
const statusOf = (row: { CRUD_TYPE?: string }) =>
  row.CRUD_TYPE === CRUD_TYPE.CREATE ? CRUD_TYPE.INSERT : (row.CRUD_TYPE ?? '');

/** 저장 대상 행 — GridAction/EditTracker 가 마킹한 CRUD_TYPE('I'/'M'/'D') 만 (hook #99) */
const isChangedRow = (row: { CRUD_TYPE?: string }) =>
  row.CRUD_TYPE === CRUD_TYPE.INSERT ||
  row.CRUD_TYPE === CRUD_TYPE.CREATE ||
  row.CRUD_TYPE === CRUD_TYPE.MODIFY ||
  row.CRUD_TYPE === CRUD_TYPE.DELETE;

/** 활성그리드 라우팅 대상 (hook #97 — AS-IS 포커스 시트 분기 E01/E19/InsertRow) */
type FocusedGrid = 'category' | 'message' | 'selReceiver' | 'allReceiver';

export const MailSetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const categoryGridRef = useRef<FlexGrid<CategoryRow>>();
  const categoryFilterRef = useRef<FlexGridFilter>();
  const categoryEditTrackerRef = useRef<EditTracker<CategoryRow>>();
  const messageGridRef = useRef<FlexGrid<MessageRow>>();
  const messageFilterRef = useRef<FlexGridFilter>();
  const messageEditTrackerRef = useRef<EditTracker<MessageRow>>();
  const allReceiverGridRef = useRef<FlexGrid<AllReceiverRow>>();
  const allReceiverFilterRef = useRef<FlexGridFilter>();
  const selReceiverGridRef = useRef<FlexGrid<SelReceiverRow>>();
  const selReceiverFilterRef = useRef<FlexGridFilter>();
  const selReceiverEditTrackerRef = useRef<EditTracker<SelReceiverRow>>();
  // 활성그리드 (F8 Insert / F9 Delete 라우팅) — AS-IS 포커스 시트 분기 대응
  const focusedGridRef = useRef<FocusedGrid>('category');

  const filters = useMailSetupStore(state => state.filters);
  const receiverFilters = useMailSetupStore(state => state.receiverFilters);
  const searchParams = useMailSetupStore(state => state.searchParams);
  const setFilters = useMailSetupStore(state => state.setFilters);
  const setReceiverFilters = useMailSetupStore(state => state.setReceiverFilters);
  const receiverSearchParams = useMailSetupStore(state => state.receiverSearchParams);
  const fetchStaticColumns = useMailSetupStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useMailSetupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMailSetupStore(state => state.setOpenSearchArea);
  const activeTab = useMailSetupStore(state => state.activeTab);
  const setActiveTab = useMailSetupStore(state => state.setActiveTab);
  const focusedArea = useMailSetupStore(state => state.focusedArea);
  const setFocusedArea = useMailSetupStore(state => state.setFocusedArea);
  const movedReceivers = useMailSetupStore(state => state.movedReceivers);
  const pushMovedReceivers = useMailSetupStore(state => state.pushMovedReceivers);
  const restoreMovedReceivers = useMailSetupStore(state => state.restoreMovedReceivers);
  const selectedCategoryId = useMailSetupStore(state => state.selectedCategoryId);
  const selectedCategoryDesc = useMailSetupStore(state => state.selectedCategoryDesc);
  const selectedModuleCode = useMailSetupStore(state => state.selectedModuleCode);
  const selectedSubModuleCode = useMailSetupStore(state => state.selectedSubModuleCode);
  const selectCategory = useMailSetupStore(state => state.selectCategory);
  const openSqlDialog = useMailSetupStore(state => state.openSqlDialog);
  const closeSqlDialog = useMailSetupStore(state => state.closeSqlDialog);
  const openContentDialog = useMailSetupStore(state => state.openContentDialog);
  const closeContentDialog = useMailSetupStore(state => state.closeContentDialog);
  const contentTargetLanguage = useMailSetupStore(state => state.contentTargetLanguage);
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const queryClient = useQueryClient();

  const { t } = useTranslation();

  const { data: categoryData, refetch: refetchCategory } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  // useTabProcQuery 는 filters 를 참조 비교(prevKeyRef !== filters)하므로
  // 인라인 객체를 넘기면 매 렌더 새 참조 → 무한 재조회. 반드시 메모이즈한 참조를 전달한다.
  const categoryDetailFilters = useMemo(
    () => ({ useType: USE_TYPE_CODE, categoryId: selectedCategoryId }),
    [selectedCategoryId]
  );

  const { data: messageData, refetch: refetchMessage } = useTabProcQuery<MENU_ID, SHEETS.MESSAGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MESSAGE,
    tabId,
    filters: categoryDetailFilters,
    enabled: !!selectedCategoryId,
  });

  const { data: allReceiverData } = useTabProcQuery<MENU_ID, SHEETS.ALL_RECEIVER>({
    menuId: MENU_ID,
    sheetName: SHEETS.ALL_RECEIVER,
    tabId,
    filters: receiverFilters,
    enabled: !!receiverFilters,
  });

  const { data: selReceiverData, refetch: refetchSelReceiver } = useTabProcQuery<
    MENU_ID,
    SHEETS.SEL_RECEIVER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SEL_RECEIVER,
    tabId,
    filters: categoryDetailFilters,
    enabled: !!selectedCategoryId,
  });

  const categoryRows = categoryData?.o_rc1 ?? [];
  const messageRows = messageData?.o_rc1 ?? [];
  const selReceiverRows = selReceiverData?.o_rc1 ?? [];
  // 좌측 All Receiver = 조회 결과 - ▶ 이동분(백업) — AS-IS 는 이동 행을 좌측에서 물리 제거(E14-4)
  const allReceiverRows = useMemo(() => {
    const rows = allReceiverData?.o_rc1 ?? [];
    if (movedReceivers.length === 0) return rows;
    const moved = new Set(movedReceivers.map(row => row.USERID));
    return rows.filter(row => !moved.has(row.USERID));
  }, [allReceiverData, movedReceivers]);

  /** 활성그리드 갱신 — All Receiver 영역만 F5 를 사용자 조회로 분기 (E01/E13) */
  const focusGrid = (target: FocusedGrid) => {
    focusedGridRef.current = target;
    setFocusedArea(target === 'allReceiver' ? 'receiver' : 'category');
  };

  const handleSearchReceiver = () => {
    if (!receiverSearchParams.dept.trim() && !receiverSearchParams.user.trim()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00691', '_Enter one of the search criteria {0}.').replace(
          '{0}',
          `[${t('LBL00615', '_Department')}, ${t('LBL00339', '_User ID(Name)')}]`
        ),
      });
      return;
    }
    setReceiverFilters();
  };

  /** F5 — 포커스 영역 분기: Receiver 검색영역/All Receiver = 사용자 조회, 그 외 = 마스터 조회 (E01) */
  const handleSearch = () => {
    if (activeTab === 'receiver' && focusedArea === 'receiver') {
      handleSearchReceiver();
      return;
    }
    // E02-3 — 마스터 재조회 시 하위 영역 클리어 (AS-IS FindData_Main L391~393 1:1):
    //   Message/Sel_Receiver = setFilters 의 선택 categoryId 리셋으로 쿼리 비활성·빈 데이터,
    //   All_Receiver = receiverFilters·▶ 이동 백업 리셋(store setFilters), 편집 추적분은 명시 클리어.
    messageEditTrackerRef.current?.clearChanges();
    selReceiverEditTrackerRef.current?.clearChanges();
    setFilters();
    void fetchStaticColumns();
  };

  /** 저장 성공 공통 — 탭 쿼리키 invalidate + 재조회 + 건수 toast (MSG00672 {0} 치환) */
  const afterSave = (savedCount: number, refetch?: () => void) => {
    // 탭 쿼리키 prefix 는 tabId — [MENU_ID] invalidate 는 아무 쿼리와도 안 맞는 죽은 코드였음
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    refetch?.();
    void setToast({
      type: 'success',
      message:
        savedCount > 0
          ? t('MSG00672', '_{0} data saved.').replace('{0}', String(savedCount))
          : t('MSG00606', '_저장되었습니다.'),
    });
  };

  /** 저장 실패 공통 — axios 인터셉터가 오류도 resolve 하므로 status/code 직접 판정 (정본 business-plan.api) */
  const isSaveFailed = (res: { status: number; data: unknown }) =>
    res.status >= 400 || Boolean(Number((res.data as { code?: string })?.code));

  const alertSaveFailed = (res?: { data: unknown }) => {
    const message = (res?.data as { message?: string } | undefined)?.message?.trim();
    void setAlert({ type: 'alert', content: message || t('MSG00690', '_Failed to save.') });
  };

  /** Category 저장 — '^' bulk payload (apiClient.post 직접 호출 의무). 저장 여부 반환 */
  const handleSaveCategory = async (): Promise<boolean> => {
    const changed = (categoryGridRef.current?.itemsSource as CategoryRow[] | undefined)?.filter(
      isChangedRow
    );
    if (!changed?.length) return true;

    for (const row of changed) {
      if (statusOf(row) === CRUD_TYPE.DELETE) continue;
      const violation = validateCyclePeriod(row);
      if (violation) {
        void setAlert({ type: 'alert', content: t(violation, '_Required period value is missing.') });
        return false;
      }
    }

    // B1 — Category 중복 검사 (AS-IS ChkCategoryValidation L1454~1493 1:1 / 제약매트릭스 B1):
    //   키 = CATEGORY_ID 단독 (2023-03 개정 DESC→ID — 원문 주석 "키와 상관없이 동일한 카테고리
    //   네임이 없도록 한다"). 변경(I/M) 행마다 삭제('D') 행 제외 전 행 대비 동일값 count > 1 →
    //   MSG00060 중단. 신규 행은 ID 공란(SP 채번 G1) — AS-IS 도 공란끼리 동일값으로 계수(원문 유지).
    const liveRows = (
      (categoryGridRef.current?.itemsSource as CategoryRow[] | undefined) ?? []
    ).filter(row => statusOf(row) !== CRUD_TYPE.DELETE);
    for (const row of changed) {
      if (statusOf(row) === CRUD_TYPE.DELETE) continue;
      const key = row.CATEGORY_ID ?? '';
      if (liveRows.filter(other => (other.CATEGORY_ID ?? '') === key).length > 1) {
        void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
        return false;
      }
    }

    if (changed.some(row => statusOf(row) === CRUD_TYPE.DELETE)) {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00694', '_Deleting a category also deletes its messages and recipients.'),
      });
      if (!confirmed) return false;
    }

    // 감사 2키 = FE 필수 전달 (BE 자동 주입은 sesUserId 키뿐 — 계보 feedback_callproc_audit_keys_fe_mandatory)
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    try {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(statusOf)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        module: joinBulk(changed.map(row => row.MODULE_CODE)),
        submodule: joinBulk(changed.map(row => row.SUB_MODULE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID)),
        categoryDesc: joinBulk(changed.map(row => row.CATEGORY_DESC)),
        cycleClassCode: joinBulk(changed.map(row => row.CYCLE_CLASS_CODE)),
        detailClassCode: joinBulk(changed.map(row => row.DETAIL_CLASS_CODE)),
        sendTimeText: joinBulk(changed.map(row => row.SEND_TIME_TEXT)),
        sendMinTimeText: joinBulk(changed.map(row => row.SEND_MIN_TIME_TEXT)),
        active: joinBulk(changed.map(row => row.ACTIVE_FLAG)),
        createdBy: joinBulk(changed.map(() => sesUserId)),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => sesUserId)),
      });
      if (isSaveFailed(res)) {
        alertSaveFailed(res);
        return false;
      }
      categoryEditTrackerRef.current?.clearChanges();
      afterSave(changed.length, refetchCategory);
      return true;
    } catch {
      alertSaveFailed();
      return false;
    }
  };

  /** Message 저장 — '^' bulk payload + Language 필수(A5) + (CATEGORY_ID+LANGUAGE) 중복 검사(B2) */
  const handleSaveMessage = async () => {
    const rows = messageGridRef.current?.itemsSource as MessageRow[] | undefined;
    const changed = rows?.filter(isChangedRow);
    if (!changed?.length) return;

    if (changed.some(row => statusOf(row) !== CRUD_TYPE.DELETE && !row.LANGUAGE_CODE)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00429', '_{0} is a required value.').replace('{0}', 'Language'),
      });
      return;
    }

    // B2 — 삭제('D') 행 제외 전 행 대비 (CATEGORY_ID+LANGUAGE_CODE) 중복 → MSG00060 중단
    const keys = new Set<string>();
    for (const row of rows ?? []) {
      if (statusOf(row) === CRUD_TYPE.DELETE) continue;
      const key = `${row.CATEGORY_ID || selectedCategoryId}${row.LANGUAGE_CODE ?? ''}`;
      if (keys.has(key)) {
        void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
        return;
      }
      keys.add(key);
    }

    const sesUserId = useSessionStore.getState().session.userId ?? '';
    try {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MESSAGE}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(statusOf)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        language: joinBulk(changed.map(row => row.LANGUAGE_CODE)),
        title: joinBulk(changed.map(row => row.MAIL_TITLE)),
        content: joinBulk(changed.map(row => row.MESSAGE_CONTENT)),
        createdBy: joinBulk(changed.map(() => sesUserId)),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => sesUserId)),
      });
      if (isSaveFailed(res)) {
        alertSaveFailed(res);
        return;
      }
      messageEditTrackerRef.current?.clearChanges();
      afterSave(changed.length, refetchMessage);
    } catch {
      alertSaveFailed();
    }
  };

  /** 수신자 저장 — '^' bulk payload (중복은 추가 시점 차단 완료 — E18) */
  const handleSaveReceiver = async () => {
    const changed = (selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined)?.filter(
      isChangedRow
    );
    if (!changed?.length) return;

    const sesUserId = useSessionStore.getState().session.userId ?? '';
    try {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.SEL_RECEIVER}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(statusOf)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        userId: joinBulk(changed.map(row => row.USERID)),
        createdBy: joinBulk(changed.map(() => sesUserId)),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => sesUserId)),
      });
      if (isSaveFailed(res)) {
        alertSaveFailed(res);
        return;
      }
      selReceiverEditTrackerRef.current?.clearChanges();
      afterSave(changed.length, refetchSelReceiver);
    } catch {
      alertSaveFailed();
    }
  };

  /** F7 — AS-IS SaveData 순차 저장 (Category → 활성 탭 시트). Category 검증 실패 시 중단 */
  const handleSave = () => {
    void (async () => {
      const categoryOk = await handleSaveCategory();
      if (!categoryOk) return;
      await (activeTab === 'message' ? handleSaveMessage() : handleSaveReceiver());
    })();
  };

  /** F8 — 활성그리드 라우팅 (hook #97): Category/Message 만 신규 행 (AS-IS InsertRow E07) */
  const handleInsert = () => {
    if (focusedGridRef.current === 'message' && activeTab === 'message') {
      const grid = messageGridRef.current;
      if (!grid) return;
      // E07 — 마스터 미선택 시 차단 (CATEGORY_ID/DESC 는 선택 마스터 자동 승계)
      if (!selectedCategoryId) {
        void setAlert({ type: 'alert', content: t('MSG00014', '_No row selected.') });
        return;
      }
      GridAction.addRow(grid, {
        USE_TYPE_CODE,
        CATEGORY_ID: selectedCategoryId,
        CATEGORY_DESC: selectedCategoryDesc,
      });
      return;
    }
    if (focusedGridRef.current === 'category') {
      const grid = categoryGridRef.current;
      if (!grid) return;
      GridAction.addRow(grid, createEmptyCategory());
    }
    // Receiver 영역 — AS-IS InsertRow 는 Category/Message 시트만 처리 (수신자 추가는 ▶)
  };

  /** F9 — 활성그리드 라우팅: 선택 행 'D' 마킹 / 신규('I') 행 즉시 제거 (AS-IS E19) */
  const handleDelete = () => {
    const focused = focusedGridRef.current;
    let removed: boolean;
    if (focused === 'category') {
      if (!categoryGridRef.current) return;
      removed = GridAction.removeRow(categoryGridRef.current);
    } else if (focused === 'message' && activeTab === 'message') {
      if (!messageGridRef.current) return;
      removed = GridAction.removeRow(messageGridRef.current);
    } else if (focused === 'selReceiver' && activeTab === 'receiver') {
      if (!selReceiverGridRef.current) return;
      removed = GridAction.removeRow(selReceiverGridRef.current);
    } else {
      // All Receiver 는 삭제 대상 아님 (AS-IS E19)
      return;
    }
    if (!removed) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No row selected.') });
    }
  };

  /** 수신자 추가 — ▶ 버튼/좌측 더블클릭 공통 경로 (E14): 중복 전체 중단 + 좌측 제거·백업 push */
  const handleAddReceiver = () => {
    if (!selectedCategoryId) return;

    const selected = allReceiverGridRef.current?.selectedItems as AllReceiverRow[] | undefined;
    if (!selected?.length) return;

    const target = selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined;
    if (!target) return;

    // B3 — (USE_TYPE, CATEGORY_ID, USER_ID) 중복 1건이라도 있으면 전체 중단 (삭제 'D' 행 제외)
    const duplicated = selected.find(item =>
      target.some(
        row =>
          row.USE_TYPE_CODE === USE_TYPE_CODE &&
          (row.CATEGORY_ID || selectedCategoryId) === selectedCategoryId &&
          row.USERID === item.USERID &&
          statusOf(row) !== CRUD_TYPE.DELETE
      )
    );
    if (duplicated) {
      void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
      return;
    }

    selected.forEach(item => {
      target.push({
        USE_TYPE_CODE: USE_TYPE_CODE,
        CATEGORY_ID: selectedCategoryId,
        CATEGORY_DESC: selectedCategoryDesc,
        USERID: item.USERID,
        USERNAME: item.USERNAME,
        DEPT_NAME: item.DEPT_NAME,
        EMAIL: item.EMAIL,
        CELLPHONENUM: item.CELLPHONENUM,
        LANGUAGE: item.LANGUAGE,
        CRUD_TYPE: CRUD_TYPE.INSERT,
      });
    });
    // 이동 성공분 좌측 제거(파생 filter) + 백업 push (E14-4 dtAllReceiver)
    pushMovedReceivers(selected);
    selReceiverGridRef.current?.collectionView?.refresh();
  };

  /** 수신자 제거 — ◀ (E15): 'I' 행 배열 제거+백업 복원 / 기존 행 'D' 마킹 */
  const handleRemoveReceiver = () => {
    const selected = selReceiverGridRef.current?.selectedItems as SelReceiverRow[] | undefined;
    if (!selected?.length) return;

    const source = selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined;
    if (!source) return;

    const restoredUserIds: string[] = [];
    selected.forEach(row => {
      if (statusOf(row) === CRUD_TYPE.INSERT) {
        const index = source.indexOf(row);
        if (index >= 0) source.splice(index, 1);
        restoredUserIds.push(row.USERID);
      } else {
        row.CRUD_TYPE = CRUD_TYPE.DELETE;
      }
    });
    // 제거된 신규 행만 백업에서 빼서 좌측 복원 (기존 행 'D' 는 저장 시 반영 — E15)
    restoreMovedReceivers(restoredUserIds);
    selReceiverGridRef.current?.collectionView?.refresh();
  };

  const handleSaveSqlText = async (sqlText: string) => {
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    try {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.SQL_TEXT}/SAVE/call-proc`, {
        useType: USE_TYPE_CODE,
        module: selectedModuleCode,
        submodule: selectedSubModuleCode,
        categoryId: selectedCategoryId,
        sqlText,
        lastUpdatedBy: sesUserId,
      });
      if (isSaveFailed(res)) {
        alertSaveFailed(res);
        return;
      }
      closeSqlDialog();
      afterSave(0);
    } catch {
      alertSaveFailed();
    }
  };

  const handleApplyContent = (content: string) => {
    const rows = messageGridRef.current?.itemsSource as MessageRow[] | undefined;
    const target = rows?.find(row => row.LANGUAGE_CODE === contentTargetLanguage);
    if (target) {
      target.MESSAGE_CONTENT = content;
      if (!isChangedRow(target)) target.CRUD_TYPE = CRUD_TYPE.MODIFY;
      messageGridRef.current?.collectionView?.refresh();
    }
    closeContentDialog();
  };

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // sort/filter/condition/resetCondition/excel 은 미지정 = 기본 활성(DefaultButtonActions) — 공통버튼 표준
  const hotkeyConfig: HotkeyConfig = {
    manual: false,
    search: handleSearch,
    save: handleSave,
    insert: handleInsert,
    delete: handleDelete,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <MailSetupForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={categoryGridRef}
        gridFilter={categoryFilterRef}
        dataCount={categoryRows.length}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <MailCategoryGrid
        gridRef={categoryGridRef}
        gridFilterRef={categoryFilterRef}
        editTrackerRef={categoryEditTrackerRef}
        data={categoryRows}
        onGridClick={() => focusGrid('category')}
        onOpenSqlDialog={row => {
          selectCategory(row);
          openSqlDialog();
        }}
      />

      <div className={styles.tabBar}>
        <button
          type='button'
          className={activeTab === 'message' ? styles.tabActive : styles.tab}
          onClick={() => setActiveTab('message')}
        >
          {t('LBL00383', '_Message Setup')}
        </button>
        <button
          type='button'
          className={activeTab === 'receiver' ? styles.tabActive : styles.tab}
          onClick={() => setActiveTab('receiver')}
        >
          {t('LBL00774', '_Receiver Setup')}
        </button>
      </div>

      {activeTab === 'message' ? (
        <MailMessageGrid
          gridRef={messageGridRef}
          gridFilterRef={messageFilterRef}
          editTrackerRef={messageEditTrackerRef}
          data={messageRows}
          onGridClick={() => focusGrid('message')}
          onOpenContent={row =>
            openContentDialog(row.LANGUAGE_CODE, row.MESSAGE_CONTENT ?? '', false)
          }
        />
      ) : (
        <MailReceiverPanel
          allGridRef={allReceiverGridRef}
          allGridFilterRef={allReceiverFilterRef}
          selGridRef={selReceiverGridRef}
          selGridFilterRef={selReceiverFilterRef}
          selEditTrackerRef={selReceiverEditTrackerRef}
          allReceivers={allReceiverRows}
          selReceivers={selReceiverRows}
          onSearchReceiver={handleSearchReceiver}
          onAddReceiver={handleAddReceiver}
          onRemoveReceiver={handleRemoveReceiver}
          onFocusAllArea={() => focusGrid('allReceiver')}
          onFocusSelArea={() => focusGrid('selReceiver')}
        />
      )}

      <MailContentDialog onApply={handleApplyContent} />
      <MailSqlDialog tabId={tabId} onSave={handleSaveSqlText} />
    </>
  );
};
