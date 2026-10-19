import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MailCategoryGrid } from './components/MailCategoryGrid';
import { MailContentDialog } from './components/MailContentDialog';
import { MailMessageGrid } from './components/MailMessageGrid';
import { MailReceiverPanel } from './components/MailReceiverPanel';
import { MailSetupForm } from './components/MailSetupForm';
import { MailSqlDialog } from './components/MailSqlDialog';
import { MENU_ID, SHEETS, USE_TYPE_CODE } from './mail-setup.constants';
import type { AllReceiverRow, CategoryRow, MessageRow, SelReceiverRow } from './mail-setup.types';
import { joinBulk, pickChangedRows, validateCyclePeriod } from './mail-setup.util';
import styles from './MailSetup.module.scss';
import { useMailSetupStore } from './useMailSetupStore';

const today = () => new Date().toISOString().slice(0, 10).replace(/-/g, '');

type FocusedGrid = 'category' | 'message' | 'receiver';

export const MailSetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const categoryGridRef = useRef<FlexGrid<CategoryRow>>();
  const categoryFilterRef = useRef<FlexGridFilter>();
  const messageGridRef = useRef<FlexGrid<MessageRow>>();
  const messageFilterRef = useRef<FlexGridFilter>();
  const allReceiverGridRef = useRef<FlexGrid<AllReceiverRow>>();
  const allReceiverFilterRef = useRef<FlexGridFilter>();
  const selReceiverGridRef = useRef<FlexGrid<SelReceiverRow>>();
  const selReceiverFilterRef = useRef<FlexGridFilter>();

  // Category(상시 표시) / Message / Sel_Receiver(탭 전환) 중 F8/F9 가 향할 그리드.
  // AS-IS InsertRow(E07)는 Category/Message 2분기, DeleteButton(E19)은 Category/Message/Sel_Receiver
  // 3분기라 Insert 는 receiver 포커스에서 아무 것도 하지 않는다(수신자는 Add 버튼으로만 추가).
  const [focused, setFocused] = useState<FocusedGrid>('category');

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
  const allReceiverRows = allReceiverData?.o_rc1 ?? [];
  const selReceiverRows = selReceiverData?.o_rc1 ?? [];

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
    // Receiver 탭에서 Department/User ID 를 채워둔 채 F5(전역 조회)를 누르면 아래 수신자
    // 검색도 함께 실행 — 비어 있으면 건드리지 않는다(빈 값 경고는 Search 버튼 클릭 시에만).
    if (
      activeTab === 'receiver' &&
      (receiverSearchParams.dept.trim() || receiverSearchParams.user.trim())
    ) {
      setReceiverFilters();
    }
  };

  const handleSearchReceiver = () => {
    if (!receiverSearchParams.dept.trim() && !receiverSearchParams.user.trim()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00691', '_Enter one of the search criteria {0}.'),
      });
      return;
    }
    setReceiverFilters();
  };

  const afterSave = (refetch?: () => void) => {
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    refetch?.();
    // Alert 대신 Toast 로 통일 (useCustomQueryClient.ts 기본 onSuccess 와 동일 패턴)
    // void setAlert({
    //   type: 'alert',
    //   content: t('MSG00672', '_{0} data saved.').replace('{0}', String(savedCount)),
    // });
    setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
  };

  /** Category 저장 — '^' bulk payload (apiClient.post 직접 호출 의무) */
  const handleSaveCategory = async () => {
    const changed = pickChangedRows(
      categoryGridRef.current?.itemsSource as CategoryRow[] | undefined
    );
    if (!changed.length) return;

    // 검증 대상은 화면에 보이는 행이 아니라 편집 흔적이 남은 모든 행 — 스크롤 밖 행도 포함된다.
    for (const row of changed) {
      if (row.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
      const violation = validateCyclePeriod(row);
      if (violation) {
        void setAlert({
          type: 'alert',
          content: t(violation, '_Required period value is missing.'),
        });
        return;
      }
    }

    if (changed.some(row => row.CRUD_TYPE === CRUD_TYPE.DELETE)) {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00694', '_Deleting a category also deletes its messages and recipients.'),
      });
      if (!confirmed) return;
    }

    const createdBy = changed.map(() => '');
    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
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
        createdBy: joinBulk(createdBy),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(createdBy),
      });
      afterSave(refetchCategory);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  /** Message 저장 — '^' bulk payload */
  const handleSaveMessage = async () => {
    const changed = pickChangedRows(
      messageGridRef.current?.itemsSource as MessageRow[] | undefined
    );
    if (!changed.length) return;

    if (changed.some(row => row.CRUD_TYPE !== CRUD_TYPE.DELETE && !row.LANGUAGE_CODE)) {
      void setAlert({ type: 'alert', content: t('MSG00429', '_{0} is a required value.') });
      return;
    }

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.MESSAGE}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        language: joinBulk(changed.map(row => row.LANGUAGE_CODE)),
        title: joinBulk(changed.map(row => row.MAIL_TITLE)),
        content: joinBulk(changed.map(row => row.MESSAGE_CONTENT)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchMessage);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  /** 수신자 저장 실행부 — Save(F7) 버튼(그리드 전체 변경분) */
  const saveReceiverRows = async (changed: SelReceiverRow[]) => {
    if (!changed.length) return;

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.SEL_RECEIVER}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        userId: joinBulk(changed.map(row => row.USERID)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchSelReceiver);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  /** 수신자 저장 — '^' bulk payload (Save 버튼 — 그리드에 남아있는 편집 흔적 전부) */
  const handleSaveReceiver = () => {
    const changed = pickChangedRows(
      selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined
    );
    return saveReceiverRows(changed);
  };

  const handleSave = () => {
    void (activeTab === 'message' ? handleSaveMessage() : handleSaveReceiver());
    void handleSaveCategory();
  };

  /**
   * F8 Insert — focused 그리드에 따라 분기(AS-IS InsertRow() E07: Category/Message 2분기).
   * Category 는 ACTIVE_FLAG 기본값 "Y", Message 는 선택된 Category 정보 상속.
   * receiver 포커스는 분기가 없다 — Sel_Receiver 는 Add 버튼(좌측 그리드에서 옮기는 방식)으로만
   * 채워지는 시트라 AS-IS 도 빈 행 삽입을 지원하지 않는다.
   */
  const handleInsert = () => {
    if (focused === 'receiver') return;
    if (focused === 'message') {
      if (!messageGridRef.current) return;
      GridAction.addRow(
        messageGridRef.current,
        {
          USE_TYPE_CODE,
          CATEGORY_ID: selectedCategoryId,
          CATEGORY_DESC: selectedCategoryDesc,
          // LANGUAGE_CODE 를 undefined 로 두면 Wijmo 콤보 편집기가 활성화되지 않고 텍스트 입력으로
          // 대체된다. AS-IS InsertRow() 도 Language 기본값을 주지 않으므로 빈 값 시작은 동일하다.
          LANGUAGE_CODE: '',
        },
        'above',
        // preserveMergeManager: Category 컬럼을 Insert 행도 병합해 보여주는 ColumnInsertMergeManager
        // (MailMessageGrid.tsx 설치)를 addRow 기본 동작(new CustomMergeManager 로 교체)이 매번
        // 덮어써서 병합이 풀리는 문제를 막는다.
        true
      );
      return;
    }
    if (!categoryGridRef.current) return;
    GridAction.addRow(categoryGridRef.current, { ACTIVE_FLAG: 'Y' });
  };

  /**
   * F9 Delete — focused 그리드에 따라 분기(AS-IS DeleteButton() E19: Category/Message/Sel_Receiver
   * 3분기). All_Receiver 는 AS-IS 도 삭제 대상이 아니다(읽기전용 사용자 목록).
   */
  const handleDelete = () => {
    if (focused === 'message') {
      // Message 는 ACTIVE_FLAG 가 없어 진짜 삭제 대상 — deleteOnlyNew 를 주지 않는다.
      // preserveMergeManager=true: Category 컬럼용 ColumnInsertMergeManager(MailMessageGrid.tsx 설치)가
      //   F9 삭제로 일반 CustomMergeManager 로 되돌아가 병합이 풀리는 문제를 막는다.
      if (messageGridRef.current) GridAction.removeRow(messageGridRef.current, false, true);
      return;
    }
    if (focused === 'receiver') {
      if (selReceiverGridRef.current) GridAction.removeRow(selReceiverGridRef.current);
      return;
    }
    // Category 는 ACTIVE_FLAG 로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
    // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
    //   (기존 카테고리 비활성은 ACTIVE_FLAG='N' 으로 처리 — 직접 삭제하면 하위 메시지/수신자까지
    //    캐스케이드 삭제되므로 F9 로는 신규행만 지운다).
    if (categoryGridRef.current) GridAction.removeRow(categoryGridRef.current, true);
  };

  // 삭제 대신 주석 보존 (2026-09-15) — focused 분기 추가 전 구버전. handleDelete 로 대체됨.
  // Category 는 ACTIVE_FLAG 로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 카테고리 비활성은 ACTIVE_FLAG='N' 으로 처리 — 직접 삭제하면 하위 메시지/수신자까지
  //    캐스케이드 삭제되므로 F9 로는 신규행만 지운다).
  //   주의: Message/Receiver 그리드는 ACTIVE_FLAG 가 없어 이 화면 F9 의 대상이 아니다
  //   (SubTitle 은 categoryGridRef 에만 연결돼 있다).
  // const handleDeleteCategory = () => {
  //   if (!categoryGridRef.current) return;
  //   GridAction.removeRow(categoryGridRef.current, true);
  // };

  /**
   * 수신자 추가 실행부 — Add 버튼(다중 선택)에서 호출 (중복 차단).
   * 실제로 추가된 행을 반환한다(현재 호출부는 미사용 — 확장 여지).
   */
  const addReceivers = (items: AllReceiverRow[]): SelReceiverRow[] => {
    if (!selectedCategoryId || !items.length) return [];

    const target = selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined;
    if (!target) return [];

    const duplicated = items.find(item =>
      target.some(row => row.USERID === item.USERID && row.CRUD_TYPE !== CRUD_TYPE.DELETE)
    );
    if (duplicated) {
      void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
      return [];
    }

    const appended: SelReceiverRow[] = items.map(item => ({
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
    }));
    target.push(...appended);
    selReceiverGridRef.current?.collectionView?.refresh();
    return appended;
  };

  /**
   * 수신자 제거 실행부 — Remove 버튼(다중 선택)에서 호출.
   * 아직 저장 안 된 신규행(INSERT)은 목록에서 바로 splice — GridAction.removeRow 와 동일 규약(저장 대상 아님).
   * 이미 저장된 행은 CRUD_TYPE=DELETE 로 마킹 — Save(F7) 버튼을 눌러야 반영된다.
   */
  const removeReceivers = (items: SelReceiverRow[]): SelReceiverRow[] => {
    if (!items.length) return [];

    const grid = selReceiverGridRef.current;
    const toSave: SelReceiverRow[] = [];
    items.forEach(row => {
      if (row.CRUD_TYPE === CRUD_TYPE.CREATE || row.CRUD_TYPE === CRUD_TYPE.INSERT) {
        grid?.editableCollectionView.remove(row);
      } else {
        row.CRUD_TYPE = CRUD_TYPE.DELETE;
        toSave.push(row);
      }
    });
    grid?.collectionView?.refresh();
    return toSave;
  };

  /** 수신자 추가 — 좌측 선택 행을 우측으로 (Add 버튼 — Save 버튼을 눌러야 반영) */
  const handleAddReceiver = () => {
    const selected = allReceiverGridRef.current?.selectedItems as AllReceiverRow[] | undefined;
    if (!selected?.length) return;
    addReceivers(selected);
  };

  /** 수신자 제거 — 우측 선택 행 삭제 마킹 (Remove 버튼 — Save 버튼을 눌러야 반영) */
  const handleRemoveReceiver = () => {
    const selected = selReceiverGridRef.current?.selectedItems as SelReceiverRow[] | undefined;
    if (!selected?.length) return;
    removeReceivers(selected);
  };

  const handleSaveSqlText = async (sqlText: string) => {
    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.SQL_TEXT}/SAVE/call-proc`, {
        useType: USE_TYPE_CODE,
        module: selectedModuleCode,
        submodule: selectedSubModuleCode,
        categoryId: selectedCategoryId,
        // BE 제네릭 바인딩은 SCM_ADM_PROC_M.COL_NM 을 키로 요청 JSON 에서 값을 꺼낸다
        // (BaseService.makeProcedure). PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_MASTER_U 의
        // 5번째 IN 파라미터는 COL_NM='sqlText' 로 등록돼 있다(02_P2_proc_m.sql) — 'sql' 로
        // 보내면 params.get("sqlText") 가 undefined 라 P_SQL 이 항상 NULL 로 바인딩된다
        // (2026-09-14 실측: 저장 성공 응답에도 DB 는 계속 NULL — 이 키 불일치가 원인).
        sqlText,
        lastUpdatedBy: '',
      });
      closeSqlDialog();
      // afterSave 의 invalidateQueries([MENU_ID])는 실제 쿼리키([tabId, sheetName, ...])와
      // prefix 가 안 맞아 아무 것도 무효화하지 못한다(다른 저장은 refetch 콜백으로 우회해왔음).
      // SQL_TEXT 쿼리는 다이얼로그 쪽에 있어 refetch 참조를 못 넘기므로 키를 직접 무효화한다 —
      // 전역 staleTime:Infinity 라 이게 없으면 재저장 후에도 팝업이 저장 전 캐시를 계속 보여준다.
      void queryClient.invalidateQueries({ queryKey: [tabId, SHEETS.SQL_TEXT] });
      afterSave();
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  const handleApplyContent = (content: string) => {
    const rows = messageGridRef.current?.itemsSource as MessageRow[] | undefined;
    const target = rows?.find(row => row.LANGUAGE_CODE === contentTargetLanguage);
    if (target) {
      target.MESSAGE_CONTENT = content;
      // 다이얼로그 편집은 셀 편집 이벤트를 타지 않아 EditTracker 가 못 잡는다 — 수동으로 M 표시.
      target.CRUD_TYPE = target.CRUD_TYPE ?? CRUD_TYPE.MODIFY;
      messageGridRef.current?.collectionView?.refresh();
    }
    closeContentDialog();
  };

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // sort/filter/condition/resetCondition/excel 은 미지정 = 기본 활성(DefaultButtonActions) — 공통버튼 표준
  // 삭제 대신 주석 보존 (2026-09-15) — focused 분기 추가 전 구버전. insert 키가 없어 F8 기본 동작이
  // SubTitle 의 grid prop(당시 categoryGridRef 고정)에만 꽂혔다.
  //   delete: handleDeleteCategory,
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
      {/* 삭제 대신 주석 보존 (2026-09-15) — focused 분기 추가 전 구버전, categoryGridRef 고정.
          grid={categoryGridRef}
          gridFilter={categoryFilterRef}
          dataCount={categoryRows.length}
      */}
      <SubTitle
        menuId={MENU_ID}
        grid={
          focused === 'message'
            ? messageGridRef
            : focused === 'receiver'
              ? selReceiverGridRef
              : categoryGridRef
        }
        gridFilter={
          focused === 'message'
            ? messageFilterRef
            : focused === 'receiver'
              ? selReceiverFilterRef
              : categoryFilterRef
        }
        dataCount={
          focused === 'message'
            ? messageRows.length
            : focused === 'receiver'
              ? selReceiverRows.length
              : categoryRows.length
        }
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <MailCategoryGrid
        gridRef={categoryGridRef}
        gridFilterRef={categoryFilterRef}
        data={categoryRows}
        onOpenSqlDialog={row => {
          selectCategory(row);
          openSqlDialog();
        }}
        onFocus={() => setFocused('category')}
      />

      {/* Message/Receiver 는 탭 전환이라 한 번에 하나만 보이지만, 상단 SubTitle 건수는 Category
          고정이라 탭 쪽 건수를 알 수 없었다 — 탭 버튼에 각자 건수를 표시한다. */}
      <div className={styles.tabBar}>
        {/* 삭제 대신 주석 보존 (2026-09-15) — focused 분기 추가 전 구버전.
            onClick={() => setActiveTab('message')}
        */}
        <button
          type='button'
          className={activeTab === 'message' ? styles.tabActive : styles.tab}
          onClick={() => {
            setActiveTab('message');
            setFocused('message');
          }}
        >
          {t('LBL00383', '_Message Setup')} ({messageRows.length})
        </button>
        {/* 삭제 대신 주석 보존 (2026-09-15) — focused 분기 추가 전 구버전.
            onClick={() => setActiveTab('receiver')}
        */}
        <button
          type='button'
          className={activeTab === 'receiver' ? styles.tabActive : styles.tab}
          onClick={() => {
            setActiveTab('receiver');
            setFocused('receiver');
          }}
        >
          {t('LBL00774', '_Receiver Setup')} ({selReceiverRows.length})
        </button>
      </div>

      {activeTab === 'message' ? (
        <MailMessageGrid
          gridRef={messageGridRef}
          gridFilterRef={messageFilterRef}
          data={messageRows}
          onOpenContent={row =>
            openContentDialog(row.LANGUAGE_CODE, row.MESSAGE_CONTENT ?? '', false)
          }
          onFocus={() => setFocused('message')}
        />
      ) : (
        <MailReceiverPanel
          allGridRef={allReceiverGridRef}
          allGridFilterRef={allReceiverFilterRef}
          selGridRef={selReceiverGridRef}
          selGridFilterRef={selReceiverFilterRef}
          allReceivers={allReceiverRows}
          selReceivers={selReceiverRows}
          onSearchReceiver={handleSearchReceiver}
          onAddReceiver={handleAddReceiver}
          onRemoveReceiver={handleRemoveReceiver}
          onSelReceiverFocus={() => setFocused('receiver')}
        />
      )}

      <MailContentDialog onApply={handleApplyContent} />
      <MailSqlDialog tabId={tabId} onSave={handleSaveSqlText} />
    </>
  );
};
