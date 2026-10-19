import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { RequestInfoPanel } from './components/RequestInfoPanel';
import { ShipmentChangeRequestForm } from './components/ShipmentChangeRequestForm';
import { ShipmentChangeRequestMainGrid } from './components/ShipmentChangeRequestMainGrid';
import { ShipmentChangeRequestSubGrid } from './components/ShipmentChangeRequestSubGrid';
import { useShipmentChangeRequestValidation } from './hooks/useShipmentChangeRequestValidation';
import {
  FIXED_DIVISION,
  ITEM_POPUP_COLUMN,
  MENU_ID,
  MSG,
  PROJECT_POPUP_COLUMN,
  SHEETS,
} from './shipment-change-request.constants';
import type { MainRow, SubRow } from './shipment-change-request.types';
import styles from './ShipmentChangeRequest.module.scss';
import { useShipmentChangeRequestStore } from './useShipmentChangeRequestStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0201_ShipmentChangeRequest — 출하 변경 요청(멀티그리드 + cascade 셀콤보).
//   설계: .atlas/gscm-design/SSP0201/design/00~03. 상세 매핑: __asis-mapping__.md.
//   편집 상태기계(R1/R2/R13): 조회=뷰(전체 lock) -> Edit=편집진입 -> Save/Cancel 성공 후 뷰 복귀.
//   주의: PKG_SSP0201 미배포(convert-sp 후속) — 실 조회/저장 런타임 검증은 SP 배포 후.
export const ShipmentChangeRequest = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const {
    checkErpBlock,
    checkChangeRequestRequired,
    checkRequiredMainColumns,
    checkCompleteQtyDate,
  } = useShipmentChangeRequestValidation();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  // 이미지셀 팝업 대상(더블클릭한 행/컬럼) 기억 — 팝업 setSelectedValue 가 이 셀에 write.
  const popupTargetRef = useRef<{ row: Record<string, unknown>; binding: string } | null>(null);

  const sc = useShipmentChangeRequestStore(s => s.searchCondition);
  const setSearchCondition = useShipmentChangeRequestStore(s => s.setSearchCondition);
  const filters = useShipmentChangeRequestStore(s => s.filters);
  const setFilter = useShipmentChangeRequestStore(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestStore(s => s.clearFilters);
  const initPeriodDefault = useShipmentChangeRequestStore(s => s.initPeriodDefault);
  const openSearchArea = useShipmentChangeRequestStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestStore(s => s.fetchStaticColumns);
  const initialized = useShipmentChangeRequestStore(s => s.initialized);
  const isGridEditable = useShipmentChangeRequestStore(s => s.isGridEditable);
  const setGridEditable = useShipmentChangeRequestStore(s => s.setGridEditable);
  const requestInfo = useShipmentChangeRequestStore(s => s.requestInfo);
  const setRequestInfo = useShipmentChangeRequestStore(s => s.setRequestInfo);
  const clearRequestInfo = useShipmentChangeRequestStore(s => s.clearRequestInfo);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openApproval, setOpenApproval] = useState(false);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: subData, refetch: refetchSub } = useTabProcQuery<MENU_ID, SHEETS.SUB>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUB,
    tabId,
    filters: filters[SHEETS.SUB],
    enabled: !!filters[SHEETS.SUB],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const subRows = useMemo<SubRow[]>(() => subData?.o_rc1 ?? [], [subData]);

  const { mutate: mutateSave } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    setGridEditable(false);
    // GAP-08 Period 기본값(30일 범위) 세팅 — AS-IS InitControls GetDayRange("") (design 02 §4-6).
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const refetchAll = () => {
    void refetchMain?.();
    void refetchSub?.();
  };

  const handleSearch = () => {
    // R13 FindButton — 조회 후 뷰 모드 복귀(전체 재잠금, R2).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_DIVISION, { defaultValue: '_Division is required.', 0: 'Division' }),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
    setGridEditable(false);
  };

  // R1 EditButton — 편집모드 진입(암묵가드 siSub.RowCount==0: 서브 비었을 때만).
  const handleEdit = () => {
    if (subRows.length > 0) return; // AS-IS 암묵 가드(01 §2 R1)
    setGridEditable(true);
  };

  // R10/R11 신규행 — 편집모드 + Division 40 고정값. 미조회/비편집 상태 삽입 방지(convert-core §2.4).
  const handleInsert = () => {
    const g = mainGridRef.current;
    if (!g || !isGridEditable) return;
    const base = { DIVISION_ID: FIXED_DIVISION, EDIT_MAIN: 'N' } as Record<string, unknown>;
    GridAction.addRow(g, base as never, 'above', true);
  };

  // 이미지셀 팝업 오픈(더블클릭 셀 기억) — ITEM_ID/PROJECT_CODE.
  const handlePopupCellDblClick = (row: Record<string, unknown>, binding: string) => {
    popupTargetRef.current = { row, binding };
    if (binding === ITEM_POPUP_COLUMN) setOpenItem(true);
    else if (binding === PROJECT_POPUP_COLUMN) setOpenProject(true);
  };

  const onBlockedEdit = (msgKey: string) => {
    const code = (MSG as Record<string, string>)[msgKey] ?? msgKey;
    void setAlert({
      type: 'alert',
      content: t(code, { defaultValue: '_Not allowed.' }),
    });
  };

  // 셀 팝업 선택 -> 대상 셀 SetValue + EditTracker 'M' 마킹(design 03 §1.1).
  const writeCell = (value: string, nameValue?: string, nameCol?: string) => {
    const target = popupTargetRef.current;
    const g = mainGridRef.current;
    if (!target) return;
    const prev = target.row[target.binding];
    if (prev !== value) {
      editTrackerRef.current?.storeChange(
        target.row as never,
        target.binding,
        prev as never,
        value as never
      );
      target.row[target.binding] = value;
      if (nameCol && nameValue !== undefined) target.row[nameCol] = nameValue;
      g?.invalidate();
    }
    popupTargetRef.current = null;
  };

  // 승인자 팝업(SSP0002_UserInfoPopup) 선택 -> 요청정보 approval/appDept 채움(언어별 KO/EN, R7).
  const handleApprovalSelected = (userId: string, userNm: string, userEngNm: string) => {
    setRequestInfo({
      approvalId: userId,
      approval: (langCd === 'KO' ? userNm : userEngNm) ?? userId,
    });
    setOpenApproval(false);
  };

  // 저장 — R8 ERP 게이트 + 필수검증 + Draft 저장(3분기 SP 는 BE/SP 가 CHANGE_TYPE 로 분기).
  //   주의: PKG_SSP0201 미배포 — 실 저장 동작은 convert-sp 배포 후 검증. 여기는 배선까지.
  const handleSave = () => {
    const g = mainGridRef.current;
    g?.finishEditing();
    const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // 저장 대상 = CRUD_TYPE(EditTracker) 또는 EDIT_MAIN='Y'(SO그룹 전파 포함).
    const dirty = src.filter(r => str(r.CRUD_TYPE) || str(r.EDIT_MAIN) === 'Y');
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, { defaultValue: '_No changes to save.' }) });
      return;
    }
    // R14: 이미 요청완료(SHIPMENT_STATUS='R') 행 저장 차단.
    if (dirty.some(r => str(r.SHIPMENT_STATUS) === 'R')) {
      void setAlert({ type: 'alert', content: t(MSG.ALREADY_COMPLETE, { defaultValue: '_Already completed.' }) });
      return;
    }
    // GAP-01 라벨 * 9컬럼 필수(INPUT_TP_CD='S' 대체, checkRequiredOfSpread(siMain) L800).
    const missing = checkRequiredMainColumns(dirty);
    if (missing) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, { defaultValue: '_Required.', 0: missing }) });
      return;
    }
    void (async () => {
      if (savingRef.current) return;
      // R8 화면레벨 ERP 차단 게이트.
      if (await checkErpBlock(sc.divisionId)) {
        void setAlert({ type: 'alert', content: t(MSG.ERP_BLOCK, { defaultValue: '_ERP interface is blocked.' }) });
        return;
      }
      // GAP-09 저장 확인 다이얼로그(TO-BE MSG00001 "Would you like to save it?", AS-IS BtnSave_Click L2776 MSG00012).
      const ok = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, { defaultValue: '_Save?' }) });
      if (!ok) return;
      savingRef.current = true;
      // 공통 메타 필수검증(라벨 * 9컬럼은 INPUT_TP_CD 'S'라 staticColumns 기준 M/IM 은 없음 — 배선 유지).
      saveWithValidation(dirty, staticColumns[SHEETS.MAIN], rows => {
        mutateSave(rows as never, {
          onSuccess: () => {
            // GAP-13: MSG00672='{0} data saved.' 의 {0} 는 i18next 보간자({{ }})가 아니므로 수동 치환
            //   (memory i18n-zero-placeholder-needs-manual-replace).
            void setToast({
              type: 'success',
              message: t(MSG.SAVE_SUCCESS, { defaultValue: '_Saved.' }).replace('{0}', String(rows.length)),
            });
            editTrackerRef.current?.clearChanges();
            setGridEditable(false); // R2 저장 성공 후 뷰 복귀
            refetchAll();
          },
        });
        savingRef.current = false;
      });
      savingRef.current = false;
    })();
  };

  // R9 취소(btnCancel) — siSub.RowCount==0 가드 + MSG00195 confirm -> 취소 + 요청정보 clear.
  const handleCancel = () => {
    if (subRows.length === 0) return;
    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: t(MSG.CANCEL_CONFIRM, { defaultValue: '_Cancel this request?' }),
      });
      if (!ok) return;
      clearRequestInfo();
      setGridEditable(false);
      refetchAll();
    })();
  };

  // R14 변경요청 완료(btnChangeRe2) — 필수 4항목 + ERP 게이트 -> 완료(SP: _SAVE_..._COMPLETE, convert-sp).
  const handleChangeRequest = () => {
    const missing = checkChangeRequestRequired(requestInfo);
    if (missing) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, { defaultValue: '_Required.', 0: missing }) });
      return;
    }
    // GAP-07 수량0 + 출하일 하한 검증(design 01 R14 :2838/2850/2868, 서브그리드 NEW_* 기준).
    const qd = checkCompleteQtyDate(subRows, sc.changeType);
    if (qd) {
      void setAlert({ type: 'alert', content: t(MSG[qd.msg], { defaultValue: '_Invalid.', 0: qd.args ?? '' }) });
      return;
    }
    void (async () => {
      if (await checkErpBlock(sc.divisionId)) {
        void setAlert({ type: 'alert', content: t(MSG.ERP_BLOCK, { defaultValue: '_ERP interface is blocked.' }) });
        return;
      }
      // 완료 mutate 배선은 convert-sp(PKG_SSP0201._SAVE_SHIPMENT_REQUEST_COMPLETE) 배포 후 실행체인 확정.
      // GAP-13: MSG00672 {0} 수동 치환(위 handleSave 와 동일).
      void setToast({
        type: 'success',
        message: t(MSG.SAVE_SUCCESS, { defaultValue: '_Requested.' }).replace('{0}', '1'),
      });
    })();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') && isGridEditable ? handleSave : false,
    insert: hasButton('INSERT') && isGridEditable ? handleInsert : false,
    // R12 DeleteButton = NO-OP(본문 공백) — 버튼 노출 유지 + 무동작(hotkeyConfig 생략 시 기본 removeRow 살아남음).
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  // AS-IS 화면 커스텀 버튼 — Edit(R1)/New(R10)/Cancel(R9)/Request Complete(R14).
  //   dead UI 5버튼(btnAdd/btnDel/btnSave/dtDate/상단btnChangeRe)은 미노출(R4, CN-4 확인대기).
  const customButtons = [
    {
      label: t('LBL00783', { defaultValue: 'Edit' }),
      title: t('LBL00783', { defaultValue: 'Edit' }),
      action: handleEdit,
    },
    {
      label: t('LBL01028', { defaultValue: 'New' }),
      title: t('LBL01028', { defaultValue: 'New' }),
      action: handleInsert,
    },
    {
      label: t('LBL00107', { defaultValue: 'Cancel' }),
      title: t('LBL00107', { defaultValue: 'Cancel' }),
      action: handleCancel,
    },
    {
      label: t('LBL01105', { defaultValue: 'Request Complete' }),
      title: t('LBL01105', { defaultValue: 'Request Complete' }),
      action: handleChangeRequest,
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentChangeRequest'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <div className={styles.mainGrid}>
        <ShipmentChangeRequestMainGrid
          rows={mainRows}
          gridRef={mainGridRef}
          gridFilterRef={mainFilterRef}
          editTrackerRef={editTrackerRef}
          division={sc.divisionId}
          changeType={sc.changeType}
          isGridEditable={isGridEditable}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onPopupCellDblClick={handlePopupCellDblClick}
          onBlockedEdit={onBlockedEdit}
        />
      </div>

      <div className={styles.subGrid}>
        <ShipmentChangeRequestSubGrid
          rows={subRows}
          gridRef={subGridRef}
          gridFilterRef={subFilterRef}
          division={sc.divisionId}
          adminColumns={staticColumns[SHEETS.SUB]}
        />
      </div>

      <div className={styles.requestInfo}>
        <RequestInfoPanel
          requestInfo={requestInfo}
          disabled={!isGridEditable}
          onChange={setRequestInfo}
          onApprovalSearch={() => setOpenApproval(true)}
        />
      </div>

      {/* Model 검색/셀 팝업 — SSP0026_ItembyDivisionPopup(ItemByDivisionModal). division/site 컨텍스트. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId, nickName) => {
          const target = popupTargetRef.current;
          if (target) writeCell(String(itemId), str(nickName), 'NICK_NAME');
          else setSearchCondition({ itemId: String(itemId) }); // 조회조건 Model
        }}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={!!popupTargetRef.current}
      />

      {/* Project 셀 팝업 — SCM0002_ProjectbyDivisionPopup(ProjectByDivisionModal). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName) =>
          writeCell(String(projectCode), str(projectName), 'PROJECT_NAME')
        }
        preSearchParams={{ divisionId: sc.divisionId }}
        callFromCell={true}
      />

      {/* 승인자 검색 — 공용 SsoUserModal(AS-IS SSP0002_UserInfoPopup, SingleSelectYn, R7). */}
      <SsoUserModal
        open={openApproval}
        modalClose={() => setOpenApproval(false)}
        setSelectedValue={handleApprovalSelected}
        ssoUserYn='N'
      />
    </>
  );
};
