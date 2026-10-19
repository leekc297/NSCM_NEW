import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { GroupCodeManagementForm } from './components/GroupCodeManagementForm';
import { GroupCodeManagementGrid } from './components/GroupCodeManagementGrid';
import { GroupCodeRtfGubunModal } from './components/GroupCodeRtfGubunModal';
import { MENU_ID, MSG, RESPONSE_SET, SHEETS } from './group-code-management.constants';
import type { GroupCodeRow } from './group-code-management.types';
import { useGroupCodePicCheck } from './hooks/useGroupCodePicCheck';
import { useGroupCodeManagementStore } from './useGroupCodeManagementStore';
import {
  GROUP_CODE5_COLUMN,
  PIC_ID_COLUMN,
  PIC_NAME_COLUMN,
} from './utils/group-code-management.editLock';
import { buildSaveRows } from './utils/group-code-management.save';

// AS-IS GSCM SCP0080_GroupCodeManagement (Model Code Master, Forms.UIL/Supply 정본):
//   - 단일 그리드 + division→sheetNm 동적 컬럼셋 (pivot 아님, SHEET_MEASURE=0)
//   - 편집토글 락(EDIT 버튼) + 셀콤보 4 + 셀팝업 2(GROUP_CODE5/PIC_ID) + CRUD 저장
//   - 조회 SP P_SCP0080_GET_GROUP_CODE_MANAGEMENT(10 IN) / 저장 SP P_SCP0080_SAVE_..(39 IN CLOB)
//   - 설계 근거: .atlas/gscm-design/SCP0080/design/01_layout.md / 02_search-combo.md / 03_grid-columns.md
//   - 대표참조: SalesFuturePrice(DMF0020, 동적컬럼) + SalesSite(DMF0004, CRUD 저장)
export const GroupCodeManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<GroupCodeRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  // 편집행 변경 셀 추적 — 공용 DataGrid 가 new EditTracker(grid) 로 초기화. CRUD_TYPE 자동 마킹.
  const editTrackerRef = useRef<EditTracker<GroupCodeRow>>(undefined);

  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);
  // SAVE SP P_USER_ID = 행별 감사 사용자(M.LAST_UPDATED_BY = A.USER_ID). 세션 userId 를 행마다 반복 전달.
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { checkPicRegistered } = useGroupCodePicCheck();

  // 중복 저장 가드 — call-proc 응답 전 재클릭 방지.
  const savingRef = useRef(false);

  // PIC_ID 셀 더블클릭 팝업 — 대상 행 기억(팝업 setSelectedValue 가 이 행에 write).
  const picTargetRef = useRef<GroupCodeRow | null>(null);
  const [openUser, setOpenUser] = useState(false);

  // GROUP_CODE5(82) 셀 더블클릭 팝업(RTFGubun) — 대상 행 기억(팝업 확정 시 이 행 GROUP_CODE5 에 write).
  const rtfTargetRef = useRef<GroupCodeRow | null>(null);
  const [openRtf, setOpenRtf] = useState(false);

  const sc = useGroupCodeManagementStore(s => s.searchCondition);
  const filters = useGroupCodeManagementStore(s => s.filters);
  const setFilter = useGroupCodeManagementStore(s => s.setFilter);
  const clearFilters = useGroupCodeManagementStore(s => s.clearFilters);
  const openSearchArea = useGroupCodeManagementStore(s => s.openSearchArea);
  const setOpenSearchArea = useGroupCodeManagementStore(s => s.setOpenSearchArea);
  const staticColumns = useGroupCodeManagementStore(s => s.staticColumns);
  const fetchStaticColumns = useGroupCodeManagementStore(s => s.fetchStaticColumns);
  const initialized = useGroupCodeManagementStore(s => s.initialized);
  const isEditMode = useGroupCodeManagementStore(s => s.isEditMode);
  const setEditMode = useGroupCodeManagementStore(s => s.setEditMode);

  const { saveWithValidation } = useSaveWithValidation();
  // ui-dynamic-property-management §3 — Menu Button 권한 동적 fetch (하드코딩 금지)
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 메인 그리드 조회 SP (P_SCP0080_GET_GROUP_CODE_MANAGEMENT — 10 IN + O_RC1)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // itemsSource 참조 안정화 — 조회 전 매 렌더 새 `?? []` 로 신규행이 리렌더에 사라지는 것 방지.
  //   division 이 바뀌면 새 [] 를 만들어(deps 에 divisionId) 그리드를 비운다.
  const rows = useMemo<GroupCodeRow[]>(
    () => (data as { o_rc1?: GroupCodeRow[] })?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [data, sc.divisionId]
  );

  // 진입 시 1회 admin 컬럼 메타 + 저장 조회조건 fetch (초기화 가드).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns(sc.divisionId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns(sc.divisionId);
  };

  // 변경행 -> 39 IN CLOB '^' 연접 payload -> SAVE SP call-proc (ShipmentModelPic/DMF0020 handleSave 경로).
  //   scalar CLOB 계약이라 mutate(행배열) 가 아니라 apiClient.post 로 직접 전송(공용 foundation client).
  const doSave = (dirty: GroupCodeRow[]) => {
    void (async () => {
      if (savingRef.current) return;
      // 화면 고유 저장검증(§3-4 V-DATE-ORDER/V-ENDCUST-LEN, 81* 게이트) + 39 IN '^' payload 조립.
      //   검증 실패 시 null -> 저장 중단(buildSaveRows 가 toast 표시).
      const payload = buildSaveRows(dirty, sc.divisionId, sessionUserId ?? '', t, setToast);
      if (!payload) return;

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
          payload
        );
        // false-success 차단 — 인터셉터가 500/CODE≠0 도 resolve 할 수 있다(R-SAVE-RESULT MSG00284).
        if (res.status >= 400 || Number(res.data?.code)) {
          const reason =
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.SAVE_RESULT, { defaultValue: '_Save failed.' });
          void setAlert({ type: 'alert', content: reason });
          return; // 편집 유지 — 사용자가 수정 후 재저장.
        }
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '_Saved.', 0: dirty.length }),
        });
        editTrackerRef.current?.clearChanges();
        void refetch?.();
      } catch (e) {
        const msg = e instanceof Error ? e.message : t(MSG.SAVE_RESULT, { defaultValue: '_Save failed.' });
        void setAlert({ type: 'alert', content: msg });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    // 변경/신규 행이 없으면 "수정한 내용이 없습니다" toast (V-NOCHANGE, MSG00133).
    //   dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다.
    const src = (grid?.collectionView?.sourceCollection ?? []);
    const dirtyRows = src.filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }
    // 공통 필수검증(useSaveWithValidation) 배선 후 doSave — 메타 M/IM 컬럼 자동 차단(convert-core §2.4).
    saveWithValidation(dirtyRows, staticColumns[RESPONSE_SET.MAIN], doSave);
  };

  // PIC_ID 셀 더블클릭(편집모드) -> UserInfoPopup 오픈. 대상 행 기억(§3-3 R-POPUP-PIC).
  const handlePicCellDblClick = (row: GroupCodeRow) => {
    picTargetRef.current = row;
    setOpenUser(true);
  };

  // 팝업 선택 -> PIC_ID/PIC_NAME SetValue + EditTracker 'M' 마킹. 이후 SCP0050 즉시 검증(§3-4 R-PIC-CHECK):
  //   미등록 USER_ID(검증 커서에 없음)면 셀 클리어 + MSG00251. 검증 호출 실패도 안전하게 클리어(false-success 방지).
  //   PIC_NAME 은 조회전용 파생 컬럼이라 표시 목적으로만 갱신(SAVE payload 미포함).
  const handleUserSelected = (userId: string, userNm: string, userEngNm: string) => {
    const target = picTargetRef.current;
    const grid = gridRef.current;
    picTargetRef.current = null;
    if (!target) return;
    const prev = target[PIC_ID_COLUMN];
    if (prev !== userId) {
      editTrackerRef.current?.storeChange(target, PIC_ID_COLUMN, prev as never, userId as never);
      target[PIC_ID_COLUMN] = userId;
      target[PIC_NAME_COLUMN] = (langCd === 'KO' ? userNm : userEngNm) ?? '';
      grid?.invalidate();
    }
    void (async () => {
      if (!userId) return;
      const ok = await checkPicRegistered(userId);
      if (ok) return;
      target[PIC_ID_COLUMN] = '';
      target[PIC_NAME_COLUMN] = '';
      grid?.invalidate();
      void setAlert({
        type: 'alert',
        content: t(MSG.PIC_CHECK, { defaultValue: '_PIC is not a registered user.' }),
      });
    })();
  };

  // GROUP_CODE5(82) 셀 더블클릭(편집모드) -> RTFGubun 팝업 오픈. 대상 행 기억(§3-3 R-POPUP-RTFGUBUN).
  const handleRtfCellDblClick = (row: GroupCodeRow) => {
    rtfTargetRef.current = row;
    setOpenRtf(true);
  };

  // 팝업 선택 -> GROUP_CODE5 <- NAME SetValue + EditTracker 'M' 마킹(AS-IS item.Name, cs:1674).
  //   RTFGubun 은 PIC 처럼 별도 재검증 없음 — 팝업 후보 자체가 유효값이다.
  const handleRtfSelected = (name: string) => {
    const target = rtfTargetRef.current;
    const grid = gridRef.current;
    rtfTargetRef.current = null;
    if (!target) return;
    const prev = target[GROUP_CODE5_COLUMN];
    if (prev === name) return;
    editTrackerRef.current?.storeChange(target, GROUP_CODE5_COLUMN, prev as never, name as never);
    target[GROUP_CODE5_COLUMN] = name;
    grid?.invalidate();
  };

  // 편집토글(EDIT) — AS-IS IsEditMode 재현. isEditMode 를 뒤집는다(그리드 read-only 게이트).
  //   토글 off 시 편집중 변경을 롤백(재조회 없이 원복)한다.
  const handleEditToggle = () => {
    if (isEditMode) {
      gridRef.current?.finishEditing();
      editTrackerRef.current?.clearChanges();
      clearFilters();
    }
    setEditMode();
  };

  // Button 매핑 (01_layout.md §2 B-1~B-7):
  //   SEARCH(실동작) / EDIT(customButton 토글) / SAVE(실동작) / EXCEL(SubTitle 자동)
  //   INSERT/DELETE 는 AS-IS 무동작(NO-OP) — false·키생략 금지, 명시적 () => undefined.
  //   모든 표준 버튼은 hasButton() 조건부(admin USE_YN/USER_GR 권한 미부여 시 자동 숨김).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') && isEditMode ? handleSave : false,
    // AS-IS 는 INSERT/DELETE 버튼이 있으나 클릭 시 아무 동작도 하지 않는다(공용 addRow/removeRow 미연결).
    //   NO-OP 은 false 로 숨기지 않고 무동작 함수로 재현한다(01_layout.md §2 B-2/B-4, §6 V-7~V-9).
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && <GroupCodeManagementForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='GroupCodeManagement'
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={
          hasButton('EDIT')
            ? [
                {
                  label: isEditMode
                    ? t('LBL00013', { defaultValue: 'Cancel' })
                    : t('LBL00012', { defaultValue: 'Edit' }),
                  title: isEditMode
                    ? t('LBL00013', { defaultValue: 'Cancel' })
                    : t('LBL00012', { defaultValue: 'Edit' }),
                  action: handleEditToggle,
                },
              ]
            : undefined
        }
      />

      <GroupCodeManagementGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        staticColumns={staticColumns[RESPONSE_SET.MAIN]}
        divisionId={sc.divisionId}
        isEditMode={isEditMode}
        onPicCellDblClick={handlePicCellDblClick}
        onRtfCellDblClick={handleRtfCellDblClick}
      />

      {/* PIC 검색 — 공용 SsoUserModal(AS-IS UserInfoPopup). 등록 사용자(SCM_ADM_USER_M) 기준. */}
      <SsoUserModal
        open={openUser}
        modalClose={() => setOpenUser(false)}
        setSelectedValue={handleUserSelected}
        ssoUserYn='N'
      />

      {/* GROUP_CODE5(82) 셀팝업 — AS-IS CommonDataSCPPopup(RTFGubun). 화면 로컬 모달(§3-3 R-POPUP-RTFGUBUN). */}
      <GroupCodeRtfGubunModal
        open={openRtf}
        modalClose={() => setOpenRtf(false)}
        divisionId={sc.divisionId}
        setSelectedValue={handleRtfSelected}
      />
    </>
  );
};
