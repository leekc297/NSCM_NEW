import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ItemByDivisionModal } from './components/modals/ItemByDivisionModal';
import { ShipmentSemiDeptDayForm } from './components/ShipmentSemiDeptDayForm';
import { ShipmentSemiDeptDayGrid } from './components/ShipmentSemiDeptDayGrid';
import { useShipmentSemiDeptDayValidation } from './hooks/useShipmentSemiDeptDayValidation';
import {
  ELECTRODE_DIVISION_PREFIX,
  INSERT_DEFAULT_VALID_YN,
  GET_ALIAS_S_VALID_YN,
  MENU_ID,
  NON_ELECTRODE_EXCLUDED_SUFFIX,
  MSG,
  POPUP_FILL_MAP,
  REQUIRED_COLUMN_LABELS,
  REQUIRED_COLUMNS,
  SHEETS,
} from './shipment-semi-dept-day.constants';
import type { DupLedgerRow, MainRow, PopupRow } from './shipment-semi-dept-day.types';
import styles from './ShipmentSemiDeptDay.module.scss';
import { useShipmentSemiDeptDayStore } from './useShipmentSemiDeptDayStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Item 팝업 오픈 컨텍스트 — 신규행 ITEM_ID 셀(대상 행 + 조회 division/item).
interface ItemPopupState {
  row: Record<string, unknown>;
  preSearchParams: { divisionId?: string; itemId?: string };
}

// AS-IS GSCM.SCP.Master.UIL SCP0033_Shipment_semi_dept_day — 단일 그리드(spdMain) Shipment Semi Dept Day.
//   설계: .atlas/gscm-design/SCP0033/design/00~03,07. 상세 매핑: __asis-mapping__.md. 도메인 SSP(features/shipping).
//   편집 규칙(design 03 §3.1 + 사용자 지시 2026-09-23): **상시 편집** — AS-IS 의 "조회직후 전잠금 -> Edit 로 개방"
//     단계와 Edit 버튼을 두지 않는다. 열리는 셀 범위는 그대로 editLock 이 행상태로 판정한다:
//     기존행 = DEPARTURE_DAY/VALID_YN, 신규행('I') = + DIVISION_ID(콤보)·ITEM_ID(팝업).
//   Delete=신규행('I')만 removeRow(기존행 D 마킹 금지, SAVE SP 에 D 분기 없음, hook #138).
//   SP 미배포(goal.md ②): PKG_SCP0033 -> 조회/저장 런타임 미완(convert-sp 후속).
export const ShipmentSemiDeptDay = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const { findDuplicate, findMissingRequired } = useShipmentSemiDeptDayValidation();

  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const savingRef = useRef(false);

  const sc = useShipmentSemiDeptDayStore(s => s.searchCondition);
  const filters = useShipmentSemiDeptDayStore(s => s.filters);
  const setFilter = useShipmentSemiDeptDayStore(s => s.setFilter);
  const clearFilters = useShipmentSemiDeptDayStore(s => s.clearFilters);
  const openSearchArea = useShipmentSemiDeptDayStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentSemiDeptDayStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentSemiDeptDayStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentSemiDeptDayStore(s => s.fetchStaticColumns);
  const initialized = useShipmentSemiDeptDayStore(s => s.initialized);
  const authDivisionIds = useShipmentSemiDeptDayStore(s => s.authDivisionIds);
  const divisionAuthLoaded = useShipmentSemiDeptDayStore(s => s.divisionAuthLoaded);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [itemPopup, setItemPopup] = useState<ItemPopupState | null>(null);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // GET Table[0] -> 그리드. S_VALUE_YN(별칭 오타 cs GET) -> S_VALID_YN 정정(design 03 §6-D).
  const rows = useMemo<MainRow[]>(() => {
    const list = (data?.o_rc1 ?? []) as Record<string, unknown>[];
    return list.map(r => {
      if (r[GET_ALIAS_S_VALID_YN.to] === undefined && r[GET_ALIAS_S_VALID_YN.from] !== undefined) {
        return { ...r, [GET_ALIAS_S_VALID_YN.to]: r[GET_ALIAS_S_VALID_YN.from] };
      }
      return r;
    }) as unknown as MainRow[];
  }, [data]);

  // GET Table[1] -> 중복체크 원장(dsValiChkBinding, design 03 §3.6/§4.1). NSCM 2번째 커서 o_rc2.
  const dupLedger = useMemo<DupLedgerRow[]>(
    () => (data as { o_rc2?: DupLedgerRow[] })?.o_rc2 ?? [],
    [data]
  );

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    // 권한 division 초기화/세팅은 Form 의 콤보 효과가 단독으로 한다 — 여기서 reset 하면 자식 효과가 먼저
    //   커밋되는 React 순서 때문에 set 이 덮여 조회가 영구히 막힌다(Form 주석 참조).
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 — AS-IS 는 필수 조회조건이 없다(Designer 에 Required 지정 없음 -> DataUtil.checkRequiredOfSearch(cs:239)
  //   가 항상 통과, design 02 §4). 단 Division 권한범위는 게이트한다.
  const handleSearch = () => {
    // 권한 후보 미도착: 이 상태로 조회하면 payload 가 빈값이 돼 권한 밖 division 까지 나온다(store.setFilter 주석).
    if (!divisionAuthLoaded) return;
    // 권한 division 0건 = AS-IS SetDivisionAuthCheck(BaseForm.cs:5995~6002, usrLayoutControl2.Enabled=false)
    //   -> 조회영역 무력화. TO-BE 는 3컨트롤 disable(Form) + 여기서 조회 경로(버튼/F5) 차단(design 01 §4 #1 "조회 불가").
    if (authDivisionIds.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // Insert — 신규행 추가. 기본값: VALID_YN='Y'(cs:206), DIVISION_ID 는 셀 콤보(Division_SCP)로 사용자 선택,
  //   ITEM_ID 는 팝업. AS-IS 의 IsLock 가드(cs:196 = 편집모드에서만 삽입)는 상시 편집이라 해당 없다.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      CRUD_TYPE: 'I',
      DIVISION_ID: '',
      VALID_YN: INSERT_DEFAULT_VALID_YN,
    } as unknown as Partial<MainRow>);
  };

  // Delete — 신규행('I')만 로컬 제거. 기존행 삭제 무시(D 마킹 금지, SAVE SP 에 D 분기 없음, design 03 §3.4 cs:186, hook #138).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    // deleteOnlyNew=true — 선택 신규행('I')만 제거, 기존행은 무변경(no-op, AS-IS DeleteButton return).
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  // 신규행 ITEM_ID 셀 더블클릭 -> SCM0002 Item 팝업(design 03 §3.4). 행 DIVISION_ID 가드는 Grid 에서 선처리.
  //   팝업 division 필터 = 행 DIVISION_ID 가 아니라 "조회조건 체크 division" 이다 — AS-IS cs:470~471 이
  //   `division = divisionId;` 를 바로 다음 줄에서 GetAllDivisionCheckedElectrode(clbDivision) 로 덮어쓴다.
  //   미체크면 AS-IS 는 ControlValues='ALL'(UsrCheckedList.cs:303~308)을 그대로 넘겨 팝업이 권한 전체를 본다
  //   -> TO-BE 도 빈 문자열이 아니라 권한 division 전체로 전개한다(조회 payload 와 같은 사유, store.setFilter).
  //   전극(EE) 재구성: AS-IS 는 값이 'EE' 로 시작하면 GetAllDivisionsExceptUCEE 로 치환한다
  //   (UIUtils.cs:160~170 -> :56~76). 그 치환은 권한 목록의 CODE 문자열만 보고 거르는 순수 필터라
  //   (뒤 2자 'UC' 제외 + 앞 2자 'EE' 제외) FE 가 authDivisionIds 만으로 그대로 재현할 수 있다.
  const handleItemCellDblClick = (row: Record<string, unknown>) => {
    const picked = sc.divisionIds.length > 0 ? sc.divisionIds : authDivisionIds;
    const popupDivisions = picked[0]?.startsWith(ELECTRODE_DIVISION_PREFIX)
      ? authDivisionIds.filter(
          c => !c.endsWith(NON_ELECTRODE_EXCLUDED_SUFFIX) && !c.startsWith(ELECTRODE_DIVISION_PREFIX)
        )
      : picked;
    setItemPopup({
      row,
      preSearchParams: {
        divisionId: popupDivisions.join(','),
        itemId: str(row.ITEM_ID),
      },
    });
  };

  // Item 팝업 확정 -> 신규행 ITEM_ID + NICK_NAME 동반 세팅(design 03 §3.2 cs:487~488).
  const handleItemSelected = (picked: PopupRow[]) => {
    const ctx = itemPopup;
    const first = picked[0] as Record<string, unknown> | undefined;
    if (!ctx || !first) return;
    const target = ctx.row;
    Object.entries(POPUP_FILL_MAP).forEach(([col, prop]) => {
      const value = str(first[prop]);
      const prev = target[col];
      if (str(prev) === value) return;
      editTrackerRef.current?.storeChange(target as never, col, prev as never, value as never);
      target[col] = value;
    });
    gridRef.current?.invalidate();
  };

  // 저장 — 변경행(I/M) ^-delim CLOB -> SAVE SP (design 03 §4.3, DMF0020/SSP0025 handleSave 경로). D 미전송.
  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      const grid = gridRef.current;
      const allRows = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      // 중복체크 2종(design 03 §4.4, MSG00060): 신규행 (DIVISION_ID+ITEM_ID) DB 원장 대비 + 그리드 내부 자기중복.
      const dup = findDuplicate(dirty, allRows, dupLedger);
      if (dup) {
        void setAlert({
          type: 'alert',
          // 등록 문구 MSG00060 은 '{0}' 슬롯이 없는 'Duplicate key exists.' 다(AS-IS 는 'The same {0} exists.'
          //   + ITEM_ID 인자였다). 어느 행이 중복인지 알 수 있게 대상 ITEM_ID 를 뒤에 붙인다.
          content: `${t(MSG.DUP_KEY, '_Duplicate key exists.')} [${dup}]`,
        });
        return;
      }

      // SAVE SP P_SCP0033_SAVE 파라미터(design 03 §4.3 cs:349~366): activeFlag(CRUD_TYPE I/M) / division_id /
      //   item_id / departure_day / valid_yn / s_valid_yn(신규행=valid_yn, 기존행=S_VALID_YN 원본). D 미전송.
      //   감사(created_by/creation_date/last_updated_by)는 SAVE SP MERGE 가 세션·서버로 처리(createId 단일 스칼라, §5-11).
      const acc: Record<string, string[]> = {
        activeFlag: [],
        divisionId: [],
        itemId: [],
        departureDay: [],
        validYn: [],
        sValidYn: [],
      };
      for (const r of dirty) {
        const flag = str(r.CRUD_TYPE) || 'M';
        acc.activeFlag.push(flag);
        acc.divisionId.push(str(r.DIVISION_ID));
        acc.itemId.push(str(r.ITEM_ID));
        acc.departureDay.push(str(r.DEPARTURE_DAY));
        acc.validYn.push(str(r.VALID_YN));
        // 신규행은 s_valid_yn = valid_yn, 기존행은 원본 S_VALID_YN 보존(cs:357/363).
        acc.sValidYn.push(flag === 'I' ? str(r.VALID_YN) : str(r.S_VALID_YN));
      }
      const payload: Record<string, string> = {};
      for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');
      // createId = 세션 사용자 단일 스칼라(감사키 회피, nscm-patterns §5-11). SP 가 CREATED_BY/LAST_UPDATED_BY 처리.
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
            t(MSG.SAVE_FAIL, '_Failed to save.');
          void setAlert({ type: 'alert', content: reason });
          return; // 편집 유지 — 사용자가 수정 후 재저장.
        }
        void setToast({
          type: 'success',
          // 등록 문구 MSG00672 는 '{0} data saved.' 인데 i18next 기본 보간자는 {{ }} 라 t() 인자로는
          //   치환되지 않는다(i18n.ts 에 interpolation.prefix 재정의 없음). 저장소 표준대로 replace 로 채운다.
          message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace(
            '{0}',
            String(dirty.length)
          ),
        });
        editTrackerRef.current?.clearChanges();
        void refetch?.(); // 저장 후 재조회(조회축 보존, hook #131) + 중복원장 갱신.
      } catch (e) {
        const msg =
          e instanceof Error ? e.message : t(MSG.SAVE_FAIL, '_Failed to save.');
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
    // I/M 만 전송(D 미전송 — SAVE SP 에 D 분기 없음, design 03 §4.3).
    const dirty = src.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      // 저장대상 0건(dirty 0 = 무변경) 안내. AS-IS 는 MSG00059("No data to save." cs:308)이나 TO-BE 미등록이라
      //   등록된 MSG00004("No changes to save.")로 환원(iter-2 G9, hook #114, 무변경 의미 정합).
      setToast({ type: 'error', message: t(MSG.NO_DATA, '_No changes to save.') });
      return;
    }
    // 화면 커스텀 필수검증(INPUT_TP_CD 비의존) — 저장대상행(신규 'I' + 편집 'M') DIVISION_ID·ITEM_ID 빈값 차단.
    //   컬럼 전건 INPUT_TP_CD='S'라 공용 useSaveWithValidation 만으론 필수판정이 스킵된다(§6-A 사문화 방지,
    //   메모리 input-tp-cd-search-only-kills-save-validation / SCP0020 실사고). AS-IS checkRequiredOfSpread(cs:318) 등가.
    const missingRequired = findMissingRequired(dirty, REQUIRED_COLUMNS);
    if (missingRequired) {
      const label = REQUIRED_COLUMN_LABELS[missingRequired] ?? missingRequired;
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${label}]`
        ),
      });
      return;
    }
    // 공용 필수검증(useSaveWithValidation)도 유지 — 향후 admin 이 INPUT_TP_CD=IM 등록 시 메타 기반으로 실효
    //   (convert-core §2.4 "커스텀 검증만으로 끝내지 말 것"). 현재는 'S' 전건이라 no-op, 위 커스텀이 실제 차단.
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], doSave);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
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
      {openSearchArea && <ShipmentSemiDeptDayForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentSemiDeptDay'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentSemiDeptDayGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          // 상시 편집(사용자 지시 2026-09-23) — Edit 버튼 없이 진입부터 편집 가능.
          //   단 **수정 권한 게이트는 유지한다**: AS-IS 도 BaseForm.OnClickEditButton(cs:3664~3672)이
          //   `!ViewModel.SecurityContext.CanUpdate` 면 MSG00096 후 EditButton() 자체를 부르지 않는다.
          //   TO-BE 의 그 축이 hasButton('EDIT')(SCM_ADM_USER_GR_MNU_BTN_MPG_M)이므로, 버튼만 없애고
          //   권한 판정은 남긴다 — 없애면 수정 권한 없는 사용자도 셀을 편집하게 된다.
          //   권한 미도착 중에는 false(잠김)에서 시작해 도착 시 열린다(안전한 방향).
          //   열리는 셀 범위는 그대로 editLock 이 행상태로 판정(기존행 DEPARTURE_DAY/VALID_YN,
          //   신규행 +DIVISION_ID/ITEM_ID). AS-IS 의 "조회직후 전잠금 -> Edit 로 개방" 단계만 없앤 것이다.
          isEditMode={hasButton('EDIT')}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onItemCellDblClick={handleItemCellDblClick}
          onDivisionRequired={() =>
            void setAlert({
              type: 'alert',
              content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
            })
          }
          onFocus={() => undefined}
        />
      </div>

      {/* 신규행 ITEM_ID 셀 팝업 — SCM0002 Item by Division(화면 로컬, 단건 선택 -> ITEM_ID+NICK_NAME). */}
      <ItemByDivisionModal
        open={!!itemPopup}
        modalClose={() => setItemPopup(null)}
        setSelectedValue={handleItemSelected}
        preSearchParams={itemPopup?.preSearchParams ?? {}}
      />
    </>
  );
};
