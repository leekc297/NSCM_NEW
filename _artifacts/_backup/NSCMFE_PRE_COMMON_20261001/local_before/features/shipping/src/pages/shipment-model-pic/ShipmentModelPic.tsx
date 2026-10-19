import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentModelPicForm } from './components/ShipmentModelPicForm';
import { ShipmentModelPicGrid } from './components/ShipmentModelPicGrid';
import { useShipmentModelPicValidation } from './hooks/useShipmentModelPicValidation';
import { MENU_ID, MSG, SHEETS, USER_POPUP_NAME_COLUMN } from './shipment-model-pic.constants';
import type { MainRow } from './shipment-model-pic.types';
import styles from './ShipmentModelPic.module.scss';
import { useShipmentModelPicStore } from './useShipmentModelPicStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0014_ShipmentModelPIC — 단일 그리드(spdMain) Shipment Model PIC.
//   설계: .atlas/gscm-design/SSP0014/design/00~03. 상세 매핑: __asis-mapping__.md.
//   편집 상태기계: 조회=전체 lock(뷰) -> Edit(SwitchLock)=편집진입 -> Save 성공 후 뷰 복귀.
//   Insert/Delete = NO-OP(cs:254/259 override 주석) -> 툴바 Search/Save/Edit 만.
export const ShipmentModelPic = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkUsersRegistered } = useShipmentModelPicValidation();

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  // 이미지셀 팝업 대상 셀(더블클릭한 행/컬럼) 기억 — 팝업 setSelectedValue 가 이 셀에 write.
  const popupTargetRef = useRef<{ row: Record<string, unknown>; binding: string } | null>(null);

  const sc = useShipmentModelPicStore(s => s.searchCondition);
  const setSearchCondition = useShipmentModelPicStore(s => s.setSearchCondition);
  const filters = useShipmentModelPicStore(s => s.filters);
  const setFilter = useShipmentModelPicStore(s => s.setFilter);
  const clearFilters = useShipmentModelPicStore(s => s.clearFilters);
  const openSearchArea = useShipmentModelPicStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentModelPicStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentModelPicStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentModelPicStore(s => s.fetchStaticColumns);
  const initialized = useShipmentModelPicStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [openItem, setOpenItem] = useState(false);
  const [openUser, setOpenUser] = useState(false);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division 필수 (design 02 §6, checkRequiredOfSearch cs:300).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_DIVISION, { defaultValue: '_Division is required.', 0: 'Division' }),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 이미지셀 팝업(UserInfoPopup) 오픈 — 더블클릭한 셀 기억.
  const handleUserCellDblClick = (row: Record<string, unknown>, binding: string) => {
    popupTargetRef.current = { row, binding };
    setOpenUser(true);
  };

  // 팝업 선택 -> 대상 셀에 UserID SetValue(AS-IS cs:649 등) + EditTracker 'M' 마킹.
  //   ID 컬럼(USER_ID/PART_LEADER/TEAM_LEADER)은 짝 이름 컬럼(USER_NAME 등)도 함께 채운다 —
  //   AS-IS UserInfoPopup 이 선택 시 ID+Name 을 동시에 SetValue 하는 동작 재현(언어별 KO/EN).
  //   이름 컬럼은 조회전용('S')이라 SAVE payload 에는 포함되지 않고 표시 목적으로만 갱신한다.
  const handleUserSelected = (userId: string, userNm: string, userEngNm: string) => {
    const target = popupTargetRef.current;
    const grid = gridRef.current;
    if (!target) return;
    const prev = target.row[target.binding];
    if (prev !== userId) {
      editTrackerRef.current?.storeChange(target.row as never, target.binding, prev as never, userId as never);
      target.row[target.binding] = userId;
      const nameCol = USER_POPUP_NAME_COLUMN[target.binding];
      if (nameCol) target.row[nameCol] = (langCd === 'KO' ? userNm : userEngNm) ?? '';
      grid?.invalidate();
    }
    popupTargetRef.current = null;
  };

  // 변경행만 ^-delim CLOB 조립 -> SAVE SP (design 03 §4, DMF0020 handleSave 경로).
  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      // 저장 전 사용자 등록 검증(GET_USER_ID_CHECK) — 미등록 시 MSG00251 중단(design 03 §4).
      const check = await checkUsersRegistered(dirty);
      if (!check.ok) {
        if (check.invalidUser) {
          void setAlert({
            type: 'alert',
            content: t(MSG.USER_NOT_REGISTERED, {
              // MSG00251 = AS-IS GSCM 알람과 동일 문구(design 10). SCM_ADM_MSG_M + public/locales 등록.
              //   locale 미로드 시 fallback 도 등록 문구와 동일하게 둔다.
              defaultValue: `SSP Planner 권한이 없는 사용자 입니다 . User ID : ${check.invalidUser}`,
              0: check.invalidUser,
            }),
          });
        } else {
          // 검증 호출 실패(엔드포인트 미등록/네트워크) — false-success 방지, 저장 중단.
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAIL, { defaultValue: '_Save failed (user check unavailable).' }),
          });
        }
        return;
      }

      // 변경행 키(division/from_site/item_id) + 편집값(user/valid/leader/mail) ^-delim 누적.
      const acc: Record<string, string[]> = {
        activeFlag: [],
        divisionId: [],
        fromSite: [],
        itemId: [],
        userId: [],
        validYn: [],
        partLeader: [],
        teamLeader: [],
        mailUser1: [],
        mailUser2: [],
        mailUser3: [],
        mailUser4: [],
        mailUser5: [],
      };
      for (const r of dirty) {
        acc.activeFlag.push(str(r.CRUD_TYPE) || 'M');
        acc.divisionId.push(str(r.DIVISION_ID));
        acc.fromSite.push(str(r.FROM_SITE));
        acc.itemId.push(str(r.ITEM_ID));
        acc.userId.push(str(r.USER_ID));
        acc.validYn.push(str(r.VALID_YN));
        acc.partLeader.push(str(r.PART_LEADER));
        acc.teamLeader.push(str(r.TEAM_LEADER));
        acc.mailUser1.push(str(r.MAIL_USER1));
        acc.mailUser2.push(str(r.MAIL_USER2));
        acc.mailUser3.push(str(r.MAIL_USER3));
        acc.mailUser4.push(str(r.MAIL_USER4));
        acc.mailUser5.push(str(r.MAIL_USER5));
      }
      const payload: Record<string, string> = {};
      for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');
      // createId = SAVE SP P_CREATE_ID(VARCHAR2 단일 스칼라). SP 본문이 CREATED_BY/LAST_UPDATED_BY 에
      //   그대로 넣으므로 '^' 다행 join 금지(다건 저장 시 "user^user" 감사컬럼 오염). AS-IS 도 단일값
      //   p_create_id=UserInfo.UserId(cs:401,507). BE 가 가로채는 createdBy 키명 회피(nscm-patterns §5-11).
      payload.createId = sessionUserId ?? '';

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
          payload
        );
        // false-success 차단(nscm-patterns §5-10) — 인터셉터가 500/CODE≠0 도 resolve 할 수 있다.
        if (res.status >= 400 || Number(res.data?.code)) {
          const reason =
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.SAVE_FAIL, { defaultValue: '_Save failed.' });
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
        const msg = e instanceof Error ? e.message : t(MSG.SAVE_FAIL, { defaultValue: '_Save failed.' });
        void setAlert({ type: 'alert', content: msg });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, { defaultValue: '_No changes to save.' }) });
      return;
    }
    // 공통 필수검증(useSaveWithValidation) 배선 후 doSave — 메타 M/IM 컬럼 자동 차단(convert-core §2.4).
    //   SSP0014 SHEET_COLUMNS 전행 'S'라 현재 차단 대상 없음(편집셀 필수는 화면 로직/사용자검증으로 처리).
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], doSave);
  };

  // Edit 토글 제거 — 그리드는 조회 직후부터 기본 편집 가능(별도 Edit 진입 없음, 사용자 지시).
  //   Insert/Delete = AS-IS override 공란(no-op) 재현 — 버튼은 노출하되 클릭 시 아무 동작 안 함.
  //     AS-IS: protected override void InsertButton() { //InsertRow(); } / DeleteButton 동일(첨부).
  //   주의: hotkeyConfig 에서 insert/delete 를 생략하면 공용 SubTitle 기본값(addRow/removeRow)이
  //     그대로 살아 버튼이 실제 동작한다 — no-op 로 만들려면 반드시 () => undefined 를 명시한다
  //     (false 로 두면 버튼 자체가 숨는다 — AS-IS 는 버튼 노출 + 무동작이라 no-op 이 정답).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: () => undefined,
    delete: () => undefined,
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
      {openSearchArea && (
        <ShipmentModelPicForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentModelPic'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentModelPicGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          division={sc.divisionId}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onUserCellDblClick={handleUserCellDblClick}
          onFocus={() => undefined}
        />
      </div>

      {/* 이미지셀 사용자 검색 — 공용 SsoUserModal (AS-IS UserInfoPopup, SingleSelectYn). */}
      <SsoUserModal
        open={openUser}
        modalClose={() => setOpenUser(false)}
        setSelectedValue={(userId, userNm, userEngNm) => handleUserSelected(userId, userNm, userEngNm)}
        ssoUserYn='N'
      />

      {/* Model 검색 — 공용 ItemByDivisionModal (AS-IS SCM0002_ItembyDivisionPopup). division/site 컨텍스트. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
