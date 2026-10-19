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

import { SmsCategoryGrid } from './components/SmsCategoryGrid';
import { SmsContentDialog } from './components/SmsContentDialog';
import { SmsMessageGrid } from './components/SmsMessageGrid';
import { SmsReceiverPanel } from './components/SmsReceiverPanel';
import { SmsSetupForm } from './components/SmsSetupForm';
import { MENU_ID, SHEETS, USE_TYPE_CODE } from './sms-setup.constants';
import type { AllReceiverRow, CategoryRow, MessageRow, SelReceiverRow } from './sms-setup.types';
import { hasDuplicate, joinBulk, pickChangedRows, validateCyclePeriod } from './sms-setup.util';
import styles from './SmsSetup.module.scss';
import { useSmsSetupStore } from './useSmsSetupStore';

type FocusedGrid = 'category' | 'message' | 'allReceiver';

const today = () => new Date().toISOString().slice(0, 10).replace(/-/g, '');

export const SmsSetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const categoryGridRef = useRef<FlexGrid<CategoryRow>>();
  const categoryFilterRef = useRef<FlexGridFilter>();
  const messageGridRef = useRef<FlexGrid<MessageRow>>();
  const messageFilterRef = useRef<FlexGridFilter>();
  const allReceiverGridRef = useRef<FlexGrid<AllReceiverRow>>();
  const allReceiverFilterRef = useRef<FlexGridFilter>();
  const selReceiverGridRef = useRef<FlexGrid<SelReceiverRow>>();
  const selReceiverFilterRef = useRef<FlexGridFilter>();

  // Category(상시 표시) / Message / All_Receiver(탭 전환) 중 F8/F9 가 향할 그리드 — TactTime.tsx 의
  // 단일 SubTitle + focused 전환 패턴과 동일(그리드마다 별도 SubTitle 을 두지 않는다).
  const [focused, setFocused] = useState<FocusedGrid>('category');

  const filters = useSmsSetupStore(state => state.filters);
  const receiverFilters = useSmsSetupStore(state => state.receiverFilters);
  const searchParams = useSmsSetupStore(state => state.searchParams);
  const setFilters = useSmsSetupStore(state => state.setFilters);
  const setReceiverFilters = useSmsSetupStore(state => state.setReceiverFilters);
  const receiverSearchParams = useSmsSetupStore(state => state.receiverSearchParams);
  const fetchStaticColumns = useSmsSetupStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useSmsSetupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSmsSetupStore(state => state.setOpenSearchArea);
  const activeTab = useSmsSetupStore(state => state.activeTab);
  const setActiveTab = useSmsSetupStore(state => state.setActiveTab);
  const selectedCategoryId = useSmsSetupStore(state => state.selectedCategoryId);
  const selectedCategoryDesc = useSmsSetupStore(state => state.selectedCategoryDesc);
  const openContentDialog = useSmsSetupStore(state => state.openContentDialog);
  const closeContentDialog = useSmsSetupStore(state => state.closeContentDialog);
  const contentTargetLanguage = useSmsSetupStore(state => state.contentTargetLanguage);
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

  const { data: allReceiverData, refetch: refetchAllReceiver } = useTabProcQuery<
    MENU_ID,
    SHEETS.ALL_RECEIVER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.ALL_RECEIVER,
    tabId,
    filters: receiverFilters,
    enabled: !!receiverFilters,
  });

  // selReceiver 는 categoryId 만 요구(useType discriminator 없음) — SCM0007 전용 SP 이기 때문
  const selReceiverFilters = useMemo(
    () => ({ categoryId: selectedCategoryId }),
    [selectedCategoryId]
  );

  const { data: selReceiverData, refetch: refetchSelReceiver } = useTabProcQuery<
    MENU_ID,
    SHEETS.SEL_RECEIVER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SEL_RECEIVER,
    tabId,
    filters: selReceiverFilters,
    enabled: !!selectedCategoryId,
  });

  const categoryRows = categoryData?.o_rc1 ?? [];
  const messageRows = messageData?.o_rc1 ?? [];
  const allReceiverRows = allReceiverData?.o_rc1 ?? [];
  const selReceiverRows = selReceiverData?.o_rc1 ?? [];

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  const handleSearchReceiver = () => {
    if (!receiverSearchParams.group.trim() && !receiverSearchParams.phone.trim()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00691', '_Enter one of the search criteria {0}.'),
      });
      return;
    }
    setReceiverFilters();
  };

  // 선택된 Category 가 아직 저장되지 않은 신규 행(F8)인지 — Message/Receiver 를 그 행의 빈
  // CATEGORY_ID 에 물려 저장하면 조회 불가능한 고아 행이 생긴다(handleInsert/handleAddReceiver 공용
  // 가드). store 에 캐시하지 않고 클릭 시점에 그리드에서 직접 읽는다 — selectionChanged 의 기존
  // dedup(`selectedCategoryId` 동일 시 무시)이 "미선택"과 "CATEGORY_ID 빈 신규행"을 둘 다 빈 문자열로
  // 취급해 캐시된 상태가 stale 해질 수 있기 때문.
  const isSelectedCategoryUnsaved = () => {
    const selected = categoryGridRef.current?.selectedItems as CategoryRow[] | undefined;
    return selected?.[0]?.CRUD_TYPE === CRUD_TYPE.INSERT;
  };

  const afterSave = (refetch?: () => void) => {
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    refetch?.();
    setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
  };

  /** Category 저장 — '^' bulk payload (apiClient.post 직접 호출 의무) — SYS0017 과 동일 공유 SP */
  const handleSaveCategory = async () => {
    const changed = pickChangedRows(
      categoryGridRef.current?.itemsSource as CategoryRow[] | undefined
    );
    if (!changed.length) return;

    // 중복 검증은 변경분이 아니라 그리드 전체 대상 — AS-IS ChkCategoryValidation 과 동일 규약.
    const allCategoryRows =
      (categoryGridRef.current?.itemsSource as CategoryRow[] | undefined) ?? [];
    if (hasDuplicate(allCategoryRows, row => row.CATEGORY_DESC)) {
      void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
      return;
    }

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

  /** Message 저장 — '^' bulk payload — SYS0017 과 동일 공유 SP */
  const handleSaveMessage = async () => {
    const changed = pickChangedRows(
      messageGridRef.current?.itemsSource as MessageRow[] | undefined
    );
    if (!changed.length) return;

    if (changed.some(row => row.CRUD_TYPE !== CRUD_TYPE.DELETE && !row.LANGUAGE_CODE)) {
      void setAlert({ type: 'alert', content: t('MSG00429', '_{0} is a required value.') });
      return;
    }

    // 동일 Category 안 Language 중복 — AS-IS ChkMsgValidation 과 동일 규약. Message 조회 자체가
    // selectedCategoryId 로 필터되어 로드된 행이 모두 같은 Category 소속이라 별도 축 비교 불필요.
    const allMessageRows = (messageGridRef.current?.itemsSource as MessageRow[] | undefined) ?? [];
    if (hasDuplicate(allMessageRows, row => row.LANGUAGE_CODE)) {
      // AS-IS ChkMsgValidation(cs:1221-1229) 은 MSG00060 을 "동일한 {0}이(가) 존재합니다." + Language
      // 인자로 호출한다. 공유 MSG00060 의 현재 번역은 {0} 치환을 지원하지 않아(다른 화면과 공유) 이
      // 화면 전용 MSG01448 로 동일한 문구를 재현한다.
      void setAlert({ type: 'alert', content: t('MSG01448', '_동일한 Language Code가 존재합니다.') });
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

  /**
   * SMS Group 마스터 저장 — SCM.SCM0007_SAVE_RECIPIENT_SMS_GROUP.
   * AS-IS SaveButton 엔트리포인트가 SAVE_RECIPIENT_MASTER/MESSAGE 와 함께 이 SP 도 호출하므로
   * All_Receiver 그리드도 이 화면에서 직접 CRUD 되는 대상이다(Mail 의 읽기전용 수신자 마스터와 다름).
   */
  const handleSaveGroup = async () => {
    const changed = pickChangedRows(
      allReceiverGridRef.current?.itemsSource as AllReceiverRow[] | undefined
    );
    if (!changed.length) return;

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.ALL_RECEIVER}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        smsGroupName: joinBulk(changed.map(row => row.SMS_GROUP_NAME)),
        smsPhone: joinBulk(changed.map(row => row.SMS_PHONE)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchAllReceiver);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  /** 카테고리별 SMS Group 할당 저장 — SCM.SCM0007_SAVE_RECIPIENT_SMS_ASSIGN */
  const handleSaveAssign = async () => {
    const changed = pickChangedRows(
      selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined
    );
    if (!changed.length) return;

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.SEL_RECEIVER}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        smsGroupName: joinBulk(changed.map(row => row.SMS_GROUP_NAME)),
        smsPhone: joinBulk(changed.map(row => row.SMS_PHONE)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchSelReceiver);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
    }
  };

  // AS-IS SaveButton 엔트리포인트가 4 SP(MASTER/MESSAGE/SMS_ASSIGN/SMS_GROUP)를 한 번에 호출한다
  // (screen-analysis.json entryPoints.SaveButton.sps) — 탭 비활성 그리드도 함께 저장한다.
  const handleSave = () => {
    void handleSaveCategory();
    void handleSaveMessage();
    void handleSaveAssign();
    void handleSaveGroup();
  };

  /**
   * 수신자 추가 — All_Receiver(SMS Group) 선택 행을 Sel_Receiver 로 (중복 차단).
   *
   * grid.selectedItems(= 현재 선택)를 그대로 쓴다. Group Name 컬럼은 동일 값 인접 행을 하나로
   * 시각 병합해 보여주는데(CustomMergeManager), 그 병합 셀을 클릭하면 wijmo 가 selection 을
   * 병합 블록 전체로 넓혀 selectedItems 가 같은 Group Name 을 가진 행을 모두 반환한다 — 이 화면은
   * 그 동작을 그대로 의도한 동작(그룹 전체 이동)으로 쓴다. 값이 겹치지 않는 Cell Phone 컬럼이나
   * ▶ 버튼으로 단일 행만 선택했을 때는 selectedItems 가 그 한 행만 반환해 한 행만 이동한다.
   */
  // Category 가 아직 저장되지 않았으면 Sel_Receiver 배정도 조회 불가능한 CATEGORY_ID 를 물게 된다
  // — handleInsert(message 분기)와 동일한 방어선.
  const canAddReceiver = () => {
    if (!selectedCategoryId) return false;
    if (isSelectedCategoryUnsaved()) {
      void setAlert({ type: 'alert', content: t('MSG00005', '_변경사항을 먼저 저장하세요.') });
      return false;
    }
    return true;
  };

  // ▶ 버튼(전체 선택)과 Group Name 더블클릭(그룹 전체 선택)이 공유하는 이동 로직 — 어떤 방식으로
  // 골랐든 미확정 행 제외 → 중복 검증 → Sel_Receiver 추가 → All_Receiver 제거 규칙은 동일하다.
  const moveReceiversToSel = (rawItems: AllReceiverRow[]) => {
    if (!rawItems.length) return;

    // Group Name 더블클릭은 wijmo 기본 동작으로 그 셀의 편집 모드를 함께 연다(그리드가 표준 편집을
    // 허용하는 그리드라서). 편집기가 열린 채로 splice 하면 invalidate() 가 편집기를 정리하지 못해
    // 이동된 행이 다른 셀을 클릭하기 전까지 좌측에 그대로 남아 보인다 — gridAction.discardChanges 와
    // 동일하게 데이터를 건드리기 전에 먼저 편집을 종료한다.
    allReceiverGridRef.current?.finishEditing(true);

    // AS-IS BtnRAdd_Click(cs:1439-1460) — 선택 행이 아직 미확정(신규 삽입/삭제 표시) 상태면 조용히
    // 제외한다(에러 메시지 없음). 저장 전 행을 그대로 옮기면 존재하지 않는 SMS_GROUP_NAME 을 참조하게 된다.
    const selected = rawItems.filter(
      item => item.CRUD_TYPE !== CRUD_TYPE.INSERT && item.CRUD_TYPE !== CRUD_TYPE.DELETE
    );
    if (!selected.length) return;

    const target = selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined;
    if (!target) return;

    // AS-IS SetSelData(cs:1568-1574) 는 SMS_GROUP_NAME + CATEGORY_ID + SMS_PHONE 3개가 모두 같을 때만
    // 중복으로 본다(Sel_Receiver 는 이미 selectedCategoryId 로 필터돼 있어 CATEGORY_ID 는 항상 동일하므로
    // GROUP_NAME+PHONE 비교로 충분). GROUP_NAME 만 비교하면 같은 그룹의 다른 전화번호까지 중복으로
    // 오판해 정상적인 다른 행 추가가 막힌다.
    const duplicated = selected.find(item =>
      target.some(
        row =>
          row.SMS_GROUP_NAME === item.SMS_GROUP_NAME &&
          row.SMS_PHONE === item.SMS_PHONE &&
          row.CRUD_TYPE !== CRUD_TYPE.DELETE
      )
    );
    if (duplicated) {
      // AS-IS SetSelData(cs:1568-1574) 는 MSG00060 을 "동일한 CELLPHONENUM : {0}(가) 존재합니다."
      // + 실제 전화번호 인자로 호출한다. 공유 MSG00060 은 {0} 치환을 지원하지 않아(다른 화면과 공유)
      // 이 화면 전용 MSG01450 으로 동일한 문구(전화번호 값 포함)를 재현한다.
      void setAlert({
        type: 'alert',
        content: t('MSG01450', '_동일한 CELLPHONENUM : {{0}}(가) 존재합니다.', {
          0: duplicated.SMS_PHONE,
        }),
      });
      return;
    }

    selected.forEach(item => {
      target.push({
        CATEGORY_ID: selectedCategoryId,
        SMS_GROUP_NAME: item.SMS_GROUP_NAME,
        SMS_PHONE: item.SMS_PHONE,
        ACTIVE_FLAG: 'Y',
        CRUD_TYPE: CRUD_TYPE.INSERT,
      });
    });
    selReceiverGridRef.current?.collectionView?.refresh();
    selReceiverGridRef.current?.invalidate();

    // AS-IS SetSelData(cs:1588-1596) — 이동된 행은 All_Receiver 시트에서도 제거한다(단순 화면 이동이며
    // 마스터 삭제가 아니므로 CRUD_TYPE 표시 없이 itemsSource 에서만 제외).
    //
    // source.splice() 로 배열만 직접 잘라내고 collectionView.refresh()(범용 Refresh 통지)로
    // 반영하던 이전 방식은, Group Name 더블클릭이 그 두 번째 클릭에서 wijmo 자체 편집 진입을
    // 동기로 먼저 타는 것과 겹치면 splice 가 반영되지 않고 다른 행을 클릭하기 전까지 좌측에 그대로
    // 남아 보였다. GridAction.removeRow 가 신규행(Insert) 제거에 쓰는 것과 동일하게
    // editableCollectionView.remove(item) 로 바꾼다 — CollectionView 가 소스 배열 splice 까지 직접
    // 수행하면서 그 항목·인덱스를 명시한 Remove 통지를 쏴 그리드가 바로 그 행만 정확히 지운다.
    const editableCollectionView = allReceiverGridRef.current?.editableCollectionView;
    if (editableCollectionView) {
      selected.forEach(item => editableCollectionView.remove(item));
      allReceiverGridRef.current?.invalidate();
    }
  };

  /**
   * 수신자 추가 — All_Receiver(SMS Group) 선택 행을 Sel_Receiver 로 (중복 차단).
   *
   * grid.selectedItems(= 현재 선택)를 그대로 쓴다. Group Name 컬럼은 동일 값 인접 행을 하나로
   * 시각 병합해 보여주는데(CustomMergeManager), 그 병합 셀을 클릭하면 wijmo 가 selection 을
   * 병합 블록 전체로 넓혀 selectedItems 가 같은 Group Name 을 가진 행을 모두 반환한다 — 이 화면은
   * 그 동작을 그대로 의도한 동작(그룹 전체 이동)으로 쓴다. 값이 겹치지 않는 Cell Phone 컬럼이나
   * ▶ 버튼으로 단일 행만 선택했을 때는 selectedItems 가 그 한 행만 반환해 한 행만 이동한다.
   */
  const handleAddReceiver = () => {
    if (!canAddReceiver()) return;
    const selectedRaw = allReceiverGridRef.current?.selectedItems as AllReceiverRow[] | undefined;
    if (!selectedRaw?.length) return;
    moveReceiversToSel(selectedRaw);
  };

  // Group Name 더블클릭 전용 — 병합 블록(인접 행만)이 아니라 itemsSource 전체에서 같은
  // SMS_GROUP_NAME 을 가진 행을 모두 찾아 이동한다(정렬/필터로 같은 그룹 행이 떨어져 있어도 전체 이동).
  const handleAddReceiverGroup = (groupName: string) => {
    if (!canAddReceiver()) return;
    const source = allReceiverGridRef.current?.itemsSource as AllReceiverRow[] | undefined;
    if (!source) return;
    const groupItems = source.filter(item => item.SMS_GROUP_NAME === groupName);
    moveReceiversToSel(groupItems);
  };

  /** 수신자 제거 — Sel_Receiver 선택 행 삭제 마킹 */
  const handleRemoveReceiver = () => {
    const selected = selReceiverGridRef.current?.selectedItems as SelReceiverRow[] | undefined;
    if (!selected?.length) return;

    selected.forEach(row => {
      row.CRUD_TYPE = CRUD_TYPE.DELETE;
    });
    selReceiverGridRef.current?.collectionView?.refresh();
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

  /**
   * F8 Insert — focused 그리드에 따라 분기(AS-IS InsertRow() 의 siCategory/siMessage/siAllReceiver
   * 3분기 대응). Category 는 ACTIVE_FLAG 기본값 "Y"(InsertRow() 774행), Message 는 선택된 Category
   * 정보 상속(786행 대응), All_Receiver 는 AS-IS 도 기본값 없음(796행).
   */
  const handleInsert = () => {
    if (focused === 'message') {
      if (!messageGridRef.current) return;
      // 선택된 Category 가 아직 저장되지 않은 신규 행(F8)이면 Message 를 그 행의 CATEGORY_ID(빈 값)에
      // 물려 저장하게 되어 조회 불가능한 고아 행이 생긴다(AS-IS 는 Category 를 먼저 저장한 뒤에만
      // 메시지를 등록하는 흐름을 전제로 한다) — 저장을 먼저 안내하고 삽입 자체를 막는다.
      if (isSelectedCategoryUnsaved()) {
        void setAlert({ type: 'alert', content: t('MSG00005', '_변경사항을 먼저 저장하세요.') });
        return;
      }
      GridAction.addRow(
        messageGridRef.current,
        {
          USE_TYPE_CODE,
          CATEGORY_ID: selectedCategoryId,
          CATEGORY_DESC: selectedCategoryDesc,
          // LANGUAGE_CODE 를 undefined 로 두면 Wijmo 콤보 편집기가 활성화되지 않고 텍스트 입력으로
          // 대체된다(sales-site 등 참고 화면은 콤보 편집 컬럼을 삽입 시 항상 명시적으로 채운다).
          // AS-IS InsertRow() 도 Language 기본값을 주지 않으므로 빈 값 시작이라는 업무 동작은 동일하다.
          LANGUAGE_CODE: '',
        },
        'above',
        // preserveMergeManager: Category 컬럼을 Insert 행도 병합해 보여주는 ColumnInsertMergeManager
        // (SmsMessageGrid.tsx 설치)를 addRow 기본 동작(new CustomMergeManager 로 교체)이 매번
        // 덮어써서 병합이 풀리는 문제를 막는다.
        true
      );
      return;
    }
    if (focused === 'allReceiver') {
      if (!allReceiverGridRef.current) return;
      GridAction.addRow(allReceiverGridRef.current, {});
      return;
    }
    if (!categoryGridRef.current) return;
    GridAction.addRow(categoryGridRef.current, { ACTIVE_FLAG: 'Y' });
  };

  /** F9 Delete — focused 그리드 대상. */
  const handleDelete = () => {
    if (focused === 'message') {
      // Message/All_Receiver 는 ACTIVE_FLAG 가 없어 진짜 삭제 대상 — deleteOnlyNew 를 주지 않는다.
      // preserveMergeManager=true: Category 컬럼용 ColumnInsertMergeManager(SmsMessageGrid.tsx 설치)가
      //   F9 삭제로 일반 CustomMergeManager 로 되돌아가 병합이 풀리는 문제를 막는다.
      if (messageGridRef.current) GridAction.removeRow(messageGridRef.current, false, true);
      return;
    }
    if (focused === 'allReceiver') {
      if (allReceiverGridRef.current) GridAction.removeRow(allReceiverGridRef.current);
      return;
    }
    // Category 는 ACTIVE_FLAG 로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
    // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
    //   (기존 카테고리 비활성은 ACTIVE_FLAG='N' 으로 처리 — 직접 삭제하면 하위 메시지/수신자까지
    //    캐스케이드 삭제되므로 F9 로는 신규행만 지운다).
    if (categoryGridRef.current) GridAction.removeRow(categoryGridRef.current, true);
  };

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
      <SmsSetupForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={
          focused === 'message'
            ? messageGridRef
            : focused === 'allReceiver'
              ? allReceiverGridRef
              : categoryGridRef
        }
        gridFilter={
          focused === 'message'
            ? messageFilterRef
            : focused === 'allReceiver'
              ? allReceiverFilterRef
              : categoryFilterRef
        }
        dataCount={
          focused === 'message'
            ? messageRows.length
            : focused === 'allReceiver'
              ? allReceiverRows.length
              : categoryRows.length
        }
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <SmsCategoryGrid
        gridRef={categoryGridRef}
        gridFilterRef={categoryFilterRef}
        data={categoryRows}
        onFocus={() => setFocused('category')}
      />

      {/* Message/Receiver 는 탭 전환이라 한 번에 하나만 보이지만, 상단 SubTitle 건수는 Category
          고정이라 탭 쪽 건수를 알 수 없었다 — 탭 버튼에 각자 건수를 표시한다. */}
      <div className={styles.tabBar}>
        <button
          type='button'
          className={activeTab === 'message' ? styles.tabActive : styles.tab}
          onClick={() => {
            setActiveTab('message');
            setFocused('message');
          }}
        >
          {/* AS-IS Designer.cs:316/378 은 탭 텍스트("Message Setup"/"Receiver Setup")를 로케일과
              무관하게 항상 영문 그대로 표시한다(하드코딩, 번역 없음). 공유 LBL00383("메시지 설정")은
              Mail Setup/Notice 화면에서 이미 한국어로 정상 번역되어 쓰이므로 그대로 두고, 이 화면
              전용 LBL01046로 AS-IS 동일 문구(영문 고정)를 재현한다. */}
          {t('LBL01046', '_Message Setup')} ({messageRows.length})
        </button>
        <button
          type='button'
          className={activeTab === 'receiver' ? styles.tabActive : styles.tab}
          onClick={() => {
            setActiveTab('receiver');
            setFocused('allReceiver');
          }}
        >
          {t('LBL01047', '_Receiver Setup')} ({selReceiverRows.length})
        </button>
      </div>

      {activeTab === 'message' ? (
        <SmsMessageGrid
          gridRef={messageGridRef}
          gridFilterRef={messageFilterRef}
          data={messageRows}
          onOpenContent={row =>
            openContentDialog(row.LANGUAGE_CODE, row.MESSAGE_CONTENT ?? '', false)
          }
          onFocus={() => setFocused('message')}
        />
      ) : (
        <SmsReceiverPanel
          allGridRef={allReceiverGridRef}
          allGridFilterRef={allReceiverFilterRef}
          selGridRef={selReceiverGridRef}
          selGridFilterRef={selReceiverFilterRef}
          allReceivers={allReceiverRows}
          selReceivers={selReceiverRows}
          onSearchReceiver={handleSearchReceiver}
          onAddReceiver={handleAddReceiver}
          onAddReceiverGroup={handleAddReceiverGroup}
          onRemoveReceiver={handleRemoveReceiver}
          onAllReceiverFocus={() => setFocused('allReceiver')}
        />
      )}

      <SmsContentDialog onApply={handleApplyContent} />
    </>
  );
};
