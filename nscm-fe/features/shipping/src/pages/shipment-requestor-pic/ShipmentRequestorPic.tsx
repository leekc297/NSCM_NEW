import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ItemByDivisionModal,
  type ItemPopupMode,
} from './components/modals/ItemByDivisionModal';
import { ShipmentRequestorPicForm } from './components/ShipmentRequestorPicForm';
import { ShipmentRequestorPicGrid } from './components/ShipmentRequestorPicGrid';
import { useShipmentRequestorPicValidation } from './hooks/useShipmentRequestorPicValidation';
import {
  EDIT_EDITABLE_COLUMNS,
  INSERT_DEFAULT_VALID_YN,
  MAIN_COLUMNS,
  MENU_ID,
  MSG,
  POPUP_FILL_COLUMNS,
  REQUIRED_COLUMNS,
  SHEETS,
  USER_POPUP_NAME_COLUMN,
} from './shipment-requestor-pic.constants';
import type { MainRow, PopupRow } from './shipment-requestor-pic.types';
import styles from './ShipmentRequestorPic.module.scss';
import { useShipmentRequestorPicStore } from './useShipmentRequestorPicStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 필수(*) 컬럼 -> 표시 라벨(헤더에서 후행 '*' 제거). MSG00429 "{0} value is required." 의 {0}.
const REQUIRED_LABEL: Record<string, string> = MAIN_COLUMNS.reduce<Record<string, string>>(
  (map, col) => {
    map[col.key] = col.header.replace(/\*$/, '');
    return map;
  },
  {}
);

// 필수(*) 빈값 사전검사 — 공용 useSaveWithValidation 은 admin 컬럼메타(staticColumns)가 있어야 동작하고,
//   fetch 실패 시 빈 배열이라 검증이 통째로 skip 된다. 화면 편집모델(editLock) 기준으로 먼저 검사해
//   그 공백을 막는다(자매 SSP0024 findMissingRequired 동일 패턴, runtime-parity H1 계열 재발 방지).
//   신규행('I')=REQUIRED_COLUMNS 전건 / 기존행=REQUIRED_COLUMNS ∩ EDIT_EDITABLE_COLUMNS
//   (SITE_DESCRIPTION·ITEM_ID 는 기존행 잠금·GET 이 채우므로 제외 — admin 메타 'IM' 과 같은 의미).
//   첫 누락 컬럼 라벨 반환(없으면 null). design 03 §5 V10 / convert-core §2.4.
const findMissingRequired = (dirty: Record<string, unknown>[]): string | null => {
  for (const row of dirty) {
    const cols =
      str(row.CRUD_TYPE) === 'I'
        ? REQUIRED_COLUMNS
        : REQUIRED_COLUMNS.filter(c => EDIT_EDITABLE_COLUMNS.includes(c));
    for (const col of cols) {
      if (str(row[col]).trim() === '') return REQUIRED_LABEL[col] ?? col;
    }
  }
  return null;
};

// Item 팝업 오픈 컨텍스트 — 조회조건 버튼(ITEM/MODEL) 또는 그리드 셀(CELL, 신규행 6칸 채움).
interface ItemPopupState {
  mode: ItemPopupMode;
  preSearchParams: { divisionId?: string; plantSite?: string; itemId?: string; modelId?: string };
  row?: Record<string, unknown>; // CELL 모드일 때 채울 대상 신규행
}

// AS-IS GSCM.SSP.Plan.UIL SSP0025_ShipmentRequestorPIC — 단일 그리드(spdMain) Shipment Requestor PIC.
//   설계: .atlas/gscm-design/SSP0025/design/00~03,07. 상세 매핑: __asis-mapping__.md.
//   편집 파리티(사용자 결정 2026-09-23): **Edit 버튼 없이 진입 즉시 편집. 단 편집권한은 화면 Load 시점에
//     판정하고, 권한이 없으면 수정 불가(읽기전용)**. 권한 원천 = admin 버튼권한 EDIT. 셀 단위 허용 범위는
//     edit-lock(권한×행상태)이 판정한다 — 상세·금지사항은 아래 canEdit/editMode 주석 참조.
//   Insert=신규행(빈행+기본값) / Delete=신규행 removeRow·기존행 VALID_YN='N'(active-flag #138).
export const ShipmentRequestorPic = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkUsersRegistered } = useShipmentRequestorPicValidation();

  // i18n 보간 헬퍼 — 메시지 본문은 `{0}` 인데 i18next 기본 보간자는 `{{ }}` 라 `t(key,{0:v})` 로는 치환되지 않는다.
  //   저장소 관례(공용 useSaveWithValidation:93, demand/admin 다수)대로 수동 replace 한다.
  const msg = (key: string, fallback: string, arg?: string | number): string => {
    const text = t(key, { defaultValue: fallback });
    return arg === undefined ? text : text.replace('{0}', String(arg));
  };

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  // 이미지셀(User/Part/Team) 팝업 대상 셀(더블클릭한 행/컬럼) 기억 — 팝업 선택값이 이 셀에 write.
  const userTargetRef = useRef<{ row: Record<string, unknown>; binding: string } | null>(null);

  const sc = useShipmentRequestorPicStore(s => s.searchCondition);
  const setSearchCondition = useShipmentRequestorPicStore(s => s.setSearchCondition);
  const filters = useShipmentRequestorPicStore(s => s.filters);
  const setFilter = useShipmentRequestorPicStore(s => s.setFilter);
  const clearFilters = useShipmentRequestorPicStore(s => s.clearFilters);
  const openSearchArea = useShipmentRequestorPicStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentRequestorPicStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentRequestorPicStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentRequestorPicStore(s => s.fetchStaticColumns);
  const initialized = useShipmentRequestorPicStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [itemPopup, setItemPopup] = useState<ItemPopupState | null>(null);
  const [openUser, setOpenUser] = useState(false);

  // 편집권한 = **화면 Load 시점 1회 판정**(사용자 결정 2026-09-23). 권한이 있으면 진입 즉시 편집 가능하고,
  //   없으면 화면 전체가 읽기전용이다. AS-IS 의 EditButton→SwitchLock 2-상태(cs:204~230)와 Edit 버튼은
  //   재현하지 않는다 — "수정 버튼 없애고, 화면 열리면 기본 Edit 기능" + "권한 없으면 수정 못하도록".
  //
  //   권한 원천 = admin 버튼권한 `MNU_BTN_CD='EDIT'`(`useTabBtnPermissions`, mount 시 1회 fetch + cache).
  //     AS-IS 는 `GetSSPUserCheck()`(cs:505) → SP `SSP0002_GET_USER_INFO_LIST` 로 "SSP Planner 등록
  //     사용자인가"를 서버 판정했는데, 그 TO-BE 등가가 이 버튼권한이다(design 01 §2.2). DB 실측상
  //     EDIT 는 ADMIN·SSP Planner 두 그룹에만 USE_YN='Y' 로 부여돼 AS-IS 판정 대상과 일치한다.
  //   주의: 이 화면의 `USER_CHECK` API 는 `PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK`(저장 전 담당자
  //     등록 검증)라 계약이 달라 권한 게이트로 전용 금지(convert-core §2.6). 자매 SSP0024 는 USER_CHECK 가
  //     `PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST` 라 서버 판정이 가능하지만 SSP0025 엔 그 API 가 미등록이다.
  //     서버 판정으로 올리려면 SSP0025 에 SSP0002 API 등록 + PKG_SSP0002 배포가 선행돼야 한다.
  //   금지: Edit 버튼(customButtons)·편집모드 토글 state 를 다시 추가하지 마라 — 사용자 결정으로 제거된 것이다.
  //   권한 로딩 중(`isLoading`)에는 hasButton 이 false 라 읽기전용으로 시작한다(안전 기본값).
  const canEdit = hasButton('EDIT');
  const editMode = canEdit;

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

  // Division 변경 = Grid 초기화 (convert-core §5-5, design 02 §5 / goal ④). 이전 division 의 조회결과·
  //   신규행·편집추적을 비운다 — AS-IS(cs:699 SetChangedControl)는 Plant Site 재조회만 하고 그리드를
  //   그대로 두지만, 이전 division 행이 편집 가능한 채 남으면 저장 payload 에 섞이므로 TO-BE 표준을 따른다.
  //   컬럼메타 재조회는 불요 — SSP0025 는 division 무관(SCM_MST_SHEET_COLUMNS.DIVISION_ID NULL 19행 실측).
  //   초기 mount/persist 복원은 제외(실제 '변경'일 때만). 재조회는 Search 게이트로만(refetch 직접호출 금지).
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    const grid = gridRef.current;
    const source = grid?.collectionView?.sourceCollection as Record<string, unknown>[] | undefined;
    if (source) {
      for (let i = source.length - 1; i >= 0; i -= 1) {
        if (source[i]?.CRUD_TYPE === 'I') source.splice(i, 1);
      }
      grid?.collectionView?.refresh();
    }
    editTrackerRef.current?.clearChanges();
    clearFilters(); // filters[MAIN] 제거 -> query disabled -> rows 비움
  }, [sc.divisionId, clearFilters]);

  const handleSearch = () => {
    // Division 필수 (design 02 §4/§6, checkRequiredOfSearch cs:249).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: msg(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 조회조건 Item 팝업(ITEM 모드) — divisionId/plantSite/item 컨텍스트, 반환 ItemId 만 채움.
  const handleItemSearch = () => {
    setItemPopup({
      mode: 'ITEM',
      preSearchParams: {
        divisionId: sc.divisionId,
        plantSite: sc.plantSiteIds.join(','),
        itemId: sc.itemId,
      },
    });
  };

  // 조회조건 Model 팝업(MODEL 모드) — 반환 ModelId 만 채움.
  const handleModelSearch = () => {
    setItemPopup({
      mode: 'MODEL',
      preSearchParams: {
        divisionId: sc.divisionId,
        plantSite: sc.plantSiteIds.join(','),
        modelId: sc.modelId,
      },
    });
  };

  // 그리드 셀 Item 팝업(CELL 모드, 신규행 R12) — 행의 division/plantSite 컨텍스트, 6칸 일괄 채움.
  const handleItemCellDblClick = (row: Record<string, unknown>) => {
    // PlantSite(=TO_SITE) 미선택이면 MSG(필수) 후 중단(design 03 §3 R12 cs:642, MSG00093 Plant Site).
    if (!str(row.TO_SITE) && !str(row.SITE_DESCRIPTION)) {
      void setAlert({
        type: 'alert',
        content: msg(MSG.REQUIRED_FIELD, '_{0} value is required.', 'Plant Site'),
      });
      return;
    }
    setItemPopup({
      mode: 'CELL',
      row,
      preSearchParams: {
        divisionId: str(row.DIVISION_ID),
        plantSite: str(row.TO_SITE),
        itemId: str(row.ITEM_ID),
      },
    });
  };

  // Item 팝업 확정 — 모드별 처리(버튼=id 채움 / 셀=6칸 일괄, design 03 §3 R12).
  const handleItemSelected = (picked: PopupRow[]) => {
    const ctx = itemPopup;
    if (!ctx) return;
    if (ctx.mode === 'ITEM') {
      setSearchCondition({
        itemId: picked.map(r => str(r.ITEM_ID)).filter(Boolean).join(','),
      });
    } else if (ctx.mode === 'MODEL') {
      setSearchCondition({
        modelId: picked.map(r => str(r.MODEL_ID)).filter(Boolean).join(','),
      });
    } else if (ctx.row) {
      // CELL — 신규행 6칸 일괄 대입(DIVISION_ID/ITEM_ID/ELECTRODE_TYPE/MODEL_ID/NICK_NAME/CELL_TYPE).
      const target = ctx.row;
      const first = picked[0] as Record<string, unknown> | undefined;
      if (first) {
        for (const key of POPUP_FILL_COLUMNS) {
          const value = str(first[key]);
          const prev = target[key];
          if (prev !== value) {
            editTrackerRef.current?.storeChange(target as never, key, prev as never, value as never);
            target[key] = value;
          }
        }
        gridRef.current?.invalidate();
      }
    }
  };

  // 이미지셀(User/Part/Team) 팝업 오픈 — 더블클릭한 셀 기억(design 03 §3 R16~R18).
  const handleUserCellDblClick = (row: Record<string, unknown>, binding: string) => {
    userTargetRef.current = { row, binding };
    setOpenUser(true);
  };

  // 팝업 선택 -> 대상 셀에 UserID SetValue + EditTracker 'M' 마킹. 짝 이름 컬럼도 언어별로 채운다(UX 개선, §6-C3).
  //   이름 컬럼은 조회전용('S')이라 SAVE payload 미포함 — 표시 목적만 갱신.
  const handleUserSelected = (userId: string, userNm: string, userEngNm: string) => {
    const target = userTargetRef.current;
    if (!target) return;
    const prev = target.row[target.binding];
    if (prev !== userId) {
      editTrackerRef.current?.storeChange(
        target.row as never,
        target.binding,
        prev as never,
        userId as never
      );
      target.row[target.binding] = userId;
      const nameCol = USER_POPUP_NAME_COLUMN[target.binding];
      if (nameCol) target.row[nameCol] = (langCd === 'KO' ? userNm : userEngNm) ?? '';
      gridRef.current?.invalidate();
    }
    userTargetRef.current = null;
  };

  // 신규행 추가 — 빈 행 + 기본값(상위행 복사 아님, design 03 §5.2). DIVISION_ID=확정 searchParams(CommonCheckList).
  //   VALID_YN='Y'(R7). AS-IS 신규행은 콤보/팝업으로 채운다 — 여기선 division·valid 만 초기 세팅.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!canEdit) return; // 편집권한 없음 — 버튼도 안 뜨지만 단축키 경로까지 막는다.
    GridAction.addRow(grid, {
      DIVISION_ID: sc.divisionId,
      VALID_YN: INSERT_DEFAULT_VALID_YN,
    } as unknown as Partial<MainRow>);
  };

  // 삭제(R19, active-flag #138) — 신규행('I')만 removeRow, 기존행은 VALID_YN='N'+저장('M')로 비활성화.
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!canEdit) return; // 편집권한 없음 — 단축키 경로 차단.
    const selected = (grid.selectedItems ?? []) as Record<string, unknown>[];
    if (selected.length === 0) return;
    const tracker = editTrackerRef.current;
    for (const row of selected) {
      if (row.CRUD_TYPE === 'I') continue; // 신규행은 아래 removeRow 로 제거
      const prev = row.VALID_YN;
      if (prev !== 'N') {
        tracker?.storeChange(row as never, 'VALID_YN', prev as never, 'N' as never);
        row.VALID_YN = 'N';
      }
    }
    // deleteOnlyNew=true — 신규행('I')만 제거, 기존행은 'D' 마킹 안 함(물리삭제 없음, 07 보완6).
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  // 변경행만 ^-delim 조립 -> SAVE SP (design 03 §4.3, DMF0020 handleSave 경로).
  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      // 저장 전 사용자 등록 검증(GET_USER_ID_CHECK) — 미등록 시 안내 후 중단(design 03 §4.3 V11).
      //   메시지는 AS-IS MSG00251 의 TO-BE 등가 MSG01261(문구 역조회, constants MSG 주석).
      const check = await checkUsersRegistered(dirty);
      if (!check.ok) {
        void setAlert({
          type: 'alert',
          content: check.invalidUser
            ? msg(
                MSG.USER_NOT_REGISTERED,
                '_This user does not have permission to the SSP Planner. User ID : {0}',
                check.invalidUser
              )
            : msg(MSG.SAVE_FAIL, '_Save failed.'),
        });
        return;
      }

      // 저장 파라미터(design 03 §4.3): activeFlag(CRUD_TYPE) / division_id / to_site / item_id /
      //   user_id / valid_yn / part_leader / team_leader. MERGE 키 = division+to_site+item(3컬럼, 07 보완3).
      const acc: Record<string, string[]> = {
        activeFlag: [],
        divisionId: [],
        toSite: [],
        itemId: [],
        userId: [],
        validYn: [],
        partLeader: [],
        teamLeader: [],
      };
      for (const r of dirty) {
        acc.activeFlag.push(str(r.CRUD_TYPE) || 'M');
        acc.divisionId.push(str(r.DIVISION_ID));
        acc.toSite.push(str(r.TO_SITE));
        acc.itemId.push(str(r.ITEM_ID));
        acc.userId.push(str(r.USER_ID));
        acc.validYn.push(str(r.VALID_YN));
        acc.partLeader.push(str(r.PART_LEADER));
        acc.teamLeader.push(str(r.TEAM_LEADER));
      }
      const payload: Record<string, string> = {};
      for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');
      // createId = SAVE SP P_CREATE_ID(단일 스칼라, 세션 UserId). '^' 다행 join 금지(감사컬럼 오염 방지).
      //   BE 가 가로채는 createdBy 키명 회피(nscm-patterns §5-11).
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
            msg(MSG.SAVE_FAIL, '_Save failed.');
          void setAlert({ type: 'alert', content: reason });
          return; // 편집 유지 — 사용자가 수정 후 재저장.
        }
        void setToast({
          type: 'success',
          message: msg(MSG.SAVE_SUCCESS, '_{0} data saved.', dirty.length),
        });
        editTrackerRef.current?.clearChanges();
        void refetch?.();
      } catch (e) {
        const reason = e instanceof Error ? e.message : msg(MSG.SAVE_FAIL, '_Save failed.');
        void setAlert({ type: 'alert', content: reason });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleSave = () => {
    if (!canEdit) return; // 편집권한 없음 — 단축키 경로 차단.
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: msg(MSG.NO_CHANGES, '_No changes to save.') });
      return;
    }
    // 화면 사전검사 — admin 컬럼메타 fetch 실패 시 공용 검증이 skip 되는 구간을 막는다.
    const missing = findMissingRequired(dirty);
    if (missing) {
      void setAlert({
        type: 'alert',
        content: msg(MSG.REQUIRED_FIELD, '_{0} value is required.', missing),
      });
      return;
    }
    // 공통 필수검증(useSaveWithValidation) — admin 메타 INPUT_TP_CD(M/IM) + 라벨 `*` 기준으로
    //   편집가능행 빈값이면 alert·차단(convert-core §2.4). 통과 시 doSave.
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], doSave);
  };

  // 편집계 버튼(Insert/Delete/Save)은 버튼권한 + **편집권한(canEdit)** 둘 다 있어야 노출한다.
  //   권한이 없으면 아예 버튼이 뜨지 않아 수정 경로가 막힌다(셀 잠금과 이중 방어).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: canEdit && hasButton('INSERT') ? handleInsert : false,
    delete: canEdit && hasButton('DELETE') ? handleDelete : false,
    save: canEdit && hasButton('SAVE') ? handleSave : false,
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
        <ShipmentRequestorPicForm
          onSearch={handleSearch}
          onItemSearch={handleItemSearch}
          onModelSearch={handleModelSearch}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentRequestorPic'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentRequestorPicGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          division={sc.divisionId}
          editMode={editMode}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onItemCellDblClick={handleItemCellDblClick}
          onUserCellDblClick={handleUserCellDblClick}
          onDivisionRequired={() =>
            void setAlert({
              type: 'alert',
              content: msg(MSG.REQUIRE_DIVISION, '_Please select Division.'),
            })
          }
          onFocus={() => undefined}
        />
      </div>

      {/* 이미지셀 사용자 검색 — 공용 SsoUserModal (AS-IS UserInfoPopup, 단일 선택). */}
      <SsoUserModal
        open={openUser}
        modalClose={() => setOpenUser(false)}
        setSelectedValue={(userId, userNm, userEngNm) =>
          handleUserSelected(userId, userNm, userEngNm)
        }
        ssoUserYn='N'
      />

      {/* Material/Model 검색 — 화면전용 ItemByDivisionModal(SSP0025 전용 SP). 버튼(ITEM/MODEL) + 셀(CELL). */}
      <ItemByDivisionModal
        open={!!itemPopup}
        modalClose={() => setItemPopup(null)}
        setSelectedValue={handleItemSelected}
        preSearchParams={itemPopup?.preSearchParams ?? {}}
        callFromCell={itemPopup?.mode === 'CELL'}
        mode={itemPopup?.mode ?? 'ITEM'}
      />
    </>
  );
};
