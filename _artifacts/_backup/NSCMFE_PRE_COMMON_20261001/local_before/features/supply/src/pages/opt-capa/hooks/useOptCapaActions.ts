import type { FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState, type MutableRefObject } from 'react';

import type { HotkeyConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { useSaveWithValidation, useTabBtnPermissions } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  COLUMN,
  EXCEL_FORM_FILE_NAME,
  GRID_SHEETS,
  LBL,
  LINE_TYPE_DEFAULT,
  MENU_ID,
  MSG,
  SHEETS,
  SHEET_LABEL,
  VALID_YN_DEFAULT,
  EE_UC_DIVISION_TOKEN,
  type GridSheet,
} from '../opt-capa.constants';
import type { GridRow } from '../opt-capa.types';
import { useOptCapaStore } from '../useOptCapaStore';
import { resolveFilterCodes, str } from '../utils/optCapa.candidates';
import { buildExcelFormColumns, buildExcelFormRows } from '../utils/optCapa.excelForm';
import { buildFlatSavePayload, isPersistedRow } from '../utils/optCapa.save';
import { buildFeatureButtonVisibility } from '../utils/optCapa.sheetVisibility';

import { submitOptCapaSave } from './useOptCapaSave';
import { useOptCapaValidation } from './useOptCapaValidation';

/**
 * 공용 `useSaveWithValidation` 에 **Daily Capa 에서만** 넘기는 빈 필수컬럼 목록.
 *
 * AS-IS 는 필수검증 원천이 시트에 따라 갈린다(사용자 판정 D-3′ / iter-3 감사 G3-1):
 *   · 나머지 7시트 = 공용 헬퍼 `DataUtil.checkRequiredOfSpread(siMain)` **라이브 7건**
 *     (cs:1311·1866·2089·2390·2648·2907·3160) → 헤더 라벨 `*` 전건이 필수.
 *   · Daily Capa  = 그 호출이 **주석처리**(cs:1572)돼 있고 로컬 상호배타 4건만 본다.
 *
 * 그래서 Daily Capa 만 메타 목록을 끊고(빈 배열) 화면 로컬 규칙
 * (`useOptCapaValidation.findMissingRequired`)에 맡긴다. 7시트는 `staticColumns[sheet]` 를 그대로
 * 넘겨 공용 훅의 메타 검증을 살린다 — 공용 훅이 숨긴 컬럼(`visible !== false`)과 `S` 컬럼
 * (`isEditableForRow`)을 이미 거르므로 "필수인데 채울 수 없는 셀" 은 생기지 않는다.
 *
 * 이 배열을 8시트 전건에 넘기면(iter-3 상태) AS-IS 보다 **약한** 검증이 되어 예컨대 Ramp-up 신규행의
 * `EFCY`(라벨 `Efficiency*`) 공백이 FE 를 무경고 통과하고 `SCP_OPMZ_RAMP_UP.EFCY` NOT NULL 에서
 * ORA-01400 으로 **배치 전건 롤백**된다.
 */
const NO_META_REQUIRED_COLUMNS: RawFlexGridColumnConfig[] = [];

interface Args {
  tabId: string;
  /** 노출 탭 파생 결과(`effectiveSheet`) — 노출 탭 0건이면 `undefined` 다. */
  sheet: GridSheet | undefined;
  /** 권한 Division 0건 게이트(R01) 판정값. */
  hasDivisionAuth: boolean;
  /** 노출 탭 목록 — 탭 전환 가드가 index → 시트 변환에 쓴다. */
  visibleSheets: readonly GridSheet[];
  /** 그리드 조회 진행 여부 — 탭 전환을 **조용히** 막는다(R09). */
  isFetching: boolean;
  /** 활성 시트 그리드 재조회 — Batch Save / Excel upload 완료 경로가 쓴다. */
  refetchGrid: () => void;
  gridRefs: Record<GridSheet, MutableRefObject<FlexGrid | undefined>>;
  editTrackerRefs: Record<GridSheet, MutableRefObject<EditTracker | undefined>>;
}

/**
 * 액션 핸들러 · 툴바 배선 일괄 — AS-IS toolbarOverride 5종 + 전용 3종 + 팝업 2종.
 *
 * 진입 Page(`OptCapa.tsx`)를 설계 규약 **≤400라인**(design 01 §7 hook #9, AS-IS 3,865라인 대비)
 * 안에 두기 위해 여기로 분리했다(iter-3 감사 G3-12). **기능 변경 0** — 옮기면서 바꾼 것은 감사
 * issue 로 지목된 4건(G3-1 필수검증 시트 분기 / G3-2 ALL payload / G3-3 excel 권한 게이트 /
 * G3-5 조회 이력 없는 재조회)뿐이고 나머지는 위치만 이동했다.
 *
 * 조회조건·편집모드 등 화면 상태는 이 훅이 `useOptCapaStore` 를 **직접** 구독한다 — 부모가 prop 으로
 * 다시 내려주면 같은 사실이 두 곳에 생긴다. 반대로 grid/EditTracker ref 는 8탭 동시 렌더 구조상
 * 부모가 소유해야 하므로(`createSheetRefs`) 인자로 받는다.
 */
export const useOptCapaActions = ({
  tabId,
  sheet,
  hasDivisionAuth,
  visibleSheets,
  isFetching,
  refetchGrid,
  gridRefs,
  editTrackerRefs,
}: Args) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateSave, validateSearch } = useOptCapaValidation();

  const sc = useOptCapaStore(s => s.searchParams);
  const applied = useOptCapaStore(s => s.applied);
  const filters = useOptCapaStore(s => s.filters);
  const activeSheet = useOptCapaStore(s => s.activeSheet);
  const editMode = useOptCapaStore(s => s.editMode);
  const staticColumns = useOptCapaStore(s => s.staticColumns);
  const setFilters = useOptCapaStore(s => s.setFilters);
  const setActiveSheet = useOptCapaStore(s => s.setActiveSheet);
  const setEditMode = useOptCapaStore(s => s.setEditMode);
  const fetchStaticColumns = useOptCapaStore(s => s.fetchStaticColumns);

  const [openBatch, setOpenBatch] = useState(false);
  const [openUpload, setOpenUpload] = useState(false);
  /**
   * Item 팝업은 더블클릭한 **행**을 들고 있어야 취소 시 셀 불변을 보장할 수 있다(R-11).
   * 어느 시트의 행인지도 함께 들고 있어야 확정 시 그 시트의 EditTracker·grid 에 반영된다.
   */
  const [itemPopup, setItemPopup] = useState<{ row: GridRow; sheet: GridSheet } | null>(null);

  /** 신규행 division 은 **확정 조회조건 우선**(CommonCheckList "확정 searchParams 기준 division"). */
  const divisionId = applied?.divisionId ?? sc.divisionId;

  /**
   * 권한 Division 0건 게이트(R01) 안내 — **1회만** 띄운다(useRef 가드).
   * TO-BE `MSG00097` 은 "Please select Division." 이라 재사용 금지 → `MSG00667` 이 문구 등가다.
   * 조회조건 영역 잠금은 `OptCapaForm` 이, 버튼 차단은 아래 `hotkeyConfig` 가 담당한다.
   */
  const authAlertedRef = useRef(false);
  useEffect(() => {
    if (hasDivisionAuth || authAlertedRef.current) return;
    authAlertedRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [hasDivisionAuth]);

  const handleSearch = () => {
    if (!hasDivisionAuth || !sheet) return;
    const failure = validateSearch(sc.fromYyyymm, sc.toYyyymm);
    if (failure) {
      void setAlert({
        type: 'alert',
        content: t(failure.msgId, { defaultValue: 'Please check the Period.' }),
      });
      return;
    }
    editTrackerRefs[sheet].current?.clearChanges();
    /**
     * Plant/Line 은 **ALL 이면 빈 배열**을 보낸다 — AS-IS `FindData_Main` cs:1159-1160 이
     * `ControlValues.Equals("ALL") ? string.Empty : GetCheckedListValue(...)` 다(G3-2).
     * 후보 전 CODE 전개값(`resolvePlantCodes`)은 셀 콤보 후보 산출 전용이며, 조회 payload 에 실으면
     * GET SP 의 `PLANT_ID IN (STRING_SPLIT(...))` 이 행 집합을 콤보 후보로 제한해 버린다.
     * Line 후보가 0건일 때도 ALL 은 ALL 이다 — 빈 CSV 로 필터를 끄는 것이 AS-IS 동작이다.
     */
    setFilters(sheet, resolveFilterCodes(sc.plantIds), resolveFilterCodes(sc.lineIds));
    void fetchStaticColumns(sc.divisionId);
  };

  /**
   * Batch Save / Excel upload 완료 후 재조회 — **조회 이력이 있을 때만** `refetch()` 다(G3-5).
   *
   * TanStack Query 의 `refetch()` 는 `enabled` 를 무시하고 queryFn 을 실행하므로, 한 번도 조회하지
   * 않은 상태(= `filters[sheet]` 없음)에서 부르면 파라미터 없는 SEARCH SP 가 돌고 빈 그리드가 된다.
   * Batch Save 버튼은 `No Work` × division≠`EE_UC` 만 만족하면 조회 없이도 보이므로 도달 가능하다.
   * AS-IS `BtnBatchSave_Click`(cs:3847-3859)은 `FindData_Main()` 을 불러 **정식 조회**를 한다.
   */
  const refreshAfterExternalSave = () => {
    if (sheet && filters[sheet]) {
      refetchGrid();
      return;
    }
    handleSearch();
  };

  /** Edit(F2 자리) — `hotkeyConfig.edit` 는 죽은 키이므로 `customButtons` 로만 노출된다(R16). */
  const handleEdit = () => {
    if (!sheet || !gridRefs[sheet].current) return;
    setEditMode(sheet, !editMode[sheet]);
  };

  /**
   * Insert(F8) — AS-IS `InsertButton`(cs:928-935).
   * **Daily Capa 는 버튼이 보이고 눌리지만 아무 행도 생기지 않는다**(if 미충족 = 무동작, R20).
   * 추가 전제 `IsLock == false`(cs:983) = 편집모드에서만 추가된다.
   *
   * 신규행 division 은 확정 조회조건(`applied`) 우선이지만 그건 값의 **출처 규약**이고 행 추가의
   * 전제조건이 아니다 — AS-IS 가드는 `siMain != null && IsLock == false` 뿐이고 기본값은
   * `cboDivision.ControlValues` 현재값(cs:988)이라 조회 전에도 편집모드면 행이 추가된다.
   */
  const handleInsert = () => {
    if (!sheet) return;
    if (sheet === SHEETS.DAILY_CAPA) return;
    const grid = gridRefs[sheet].current;
    if (!grid) return;
    if (!editMode[sheet]) return;
    const row: Record<string, unknown> = {
      [COLUMN.DIVISION_ID]: divisionId,
      [COLUMN.VALID_YN]: VALID_YN_DEFAULT,
    };
    // 비EE_UC 는 `LINE_TYPE` 기본값 `'-'`(cs:994-997·1017-1020). `LINE_TYPE` 이 없는 3시트
    //   (PrepRt/UtilRt/Yield)는 AS-IS 도 이 값을 넣지 않는다 — 없는 컬럼이라 무해하지만
    //   AS-IS 분기를 그대로 지킨다.
    if (
      divisionId !== EE_UC_DIVISION_TOKEN &&
      (sheet === SHEETS.NO_WORK ||
        sheet === SHEETS.SOP_EOP ||
        sheet === SHEETS.RAMP_UP ||
        sheet === SHEETS.RAMP_UP_ITVL)
    ) {
      row[COLUMN.LINE_TYPE] = LINE_TYPE_DEFAULT;
    }
    // 상위행 복사가 아니라 **빈 행 + 기본값**이다(AS-IS `siMain.Insert()` + `SetValue`, R-15).
    GridAction.addRow(grid, row as Partial<WijmoRowItem>);
  };

  /**
   * Delete(F9) — AS-IS `DeleteButton`(cs:763-831).
   *   · Daily Capa: 행 선택 필수 **AND** `PRE_KEY_VALUES` 첫 토큰 비공백(= 저장된 행)만.
   *   · 나머지 7시트: 무조건 삭제.
   * SAVE SP 의 `'D'` 는 **물리 DELETE** 이므로 `deleteOnlyNew` 를 쓰지 않는다(hook #138 비대상).
   *
   * `editMode` 가드는 **의도적 차이**다(사용자 판정 D-4) — AS-IS `DeleteButton` 에는 `IsLock` 가드가
   * 없어 조회 상태에서도 행이 지워진다. `handleSave` 쪽 가드와 성질이 다르다(그쪽은 AS-IS 파리티 —
   * 8개 `Save_*` 전건이 첫 줄에 `IsLock` 가드를 갖는다, cs:1251·1490·1804·2024·2308·2594·2853·3109).
   */
  const handleDelete = () => {
    if (!sheet) return;
    const grid = gridRefs[sheet].current;
    if (!grid) return;
    if (!editMode[sheet]) return;
    // 선택 필수 가드는 **Daily Capa 분기 안에만** 둔다(cs:772 `_currRowIdx < 0`). 나머지 7시트는
    //   AS-IS 가 `siMain.Delete()` 를 무조건 부르며, 표준 `GridAction.removeRow` 도 선택 행이
    //   없으면 스스로 무동작이라(`gridAction.ts:879-880`) 화면이 별도로 막을 필요가 없다(R-18).
    if (sheet === SHEETS.DAILY_CAPA) {
      const selected = (grid.selectedRows?.[0]?.dataItem ?? undefined) as GridRow | undefined;
      if (!selected) return;
      if (!isPersistedRow(selected)) return; // `PRE_KEY_VALUES` 첫 토큰 = 저장된 행만 삭제
    }
    GridAction.removeRow(grid);
    grid.invalidate();
  };

  /**
   * 저장 성공 후처리 — 토스트 + EditTracker clear + 편집모드 해제 + 활성 시트만 재조회.
   *
   * `useProcMutation` 의 기본 `onSuccess`(성공 토스트 + `invalidateQueries([tabId])`)를 쓰지 않으므로
   * (RP-1 해소로 `apiClient.post` 직접 호출로 전환 — {@link submitOptCapaSave}) 여기서 직접 한다.
   * 재조회는 **저장한 시트만**이다(CommonCheckList "필요 영역만 재조회") — `[tabId]` prefix 를 주면
   * 조회조건 마스터(`init`)까지 invalidate 돼 SP 가 불필요하게 다시 돈다.
   */
  const afterSaveSuccess = (savedSheet: GridSheet, savedCount: number) => {
    void setToast({
      type: 'success',
      message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
        '{0}',
        String(savedCount)
      ),
    });
    editTrackerRefs[savedSheet].current?.clearChanges();
    setEditMode(savedSheet, false);
    void queryClient.invalidateQueries({ queryKey: [tabId, savedSheet] });
  };

  /**
   * Save(F7) — 활성 시트 1건만 저장한다(AS-IS 8분기, cs:937-975).
   *
   * 검증 2단(**시트에 따라 주·부가 뒤바뀐다**):
   *   ① 공용 `useSaveWithValidation` — 7시트는 여기가 **정본 필수검증**이다(메타 `INPUT_TP_CD` M/IM
   *      또는 라벨 `*`). Daily Capa 는 {@link NO_META_REQUIRED_COLUMNS} 로 끊고 ②에 맡긴다.
   *   ② 화면 고유(`useOptCapaValidation`) — Daily Capa 상호배타 필수 4건 +
   *      키중복/키변경/기간중첩·역전/숫자·날짜/자릿수(전 시트 공통).
   *
   * `editMode` 가드는 AS-IS 파리티다 — 8개 `Save_*` 전건 첫 줄에 `IsLock` 가드가 있다.
   */
  const handleSave = () => {
    if (!sheet) return;
    const grid = gridRefs[sheet].current;
    if (!grid) return;
    grid.finishEditing();
    if (!editMode[sheet]) return;
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as GridRow[];
    const dirty = source.filter(row => {
      const crud = str(row.CRUD_TYPE);
      return crud === 'I' || crud === 'M' || crud === 'D';
    });
    if (dirty.length === 0) {
      void setToast({
        type: 'error',
        message: t(MSG.NO_CHANGES, { defaultValue: 'No changes to save.' }),
      });
      return;
    }
    /**
     * 공용 메타 필수검증의 대상 행 — **삭제행을 뺀다**(AS-IS 파리티).
     *
     * AS-IS 공용 헬퍼 `DataUtil.checkRequiredOfSpread`(`DataUtil.cs:23-65`)는 첫 분기에서
     * `action=='D'` 를 skip 한다. 공용 `useSaveWithValidation.findMissingMandatory`
     * (`useSaveWithValidation.ts:55-61`)에는 그 분기가 없어 `dirty`(I/M/D)를 그대로 넘기면
     * **삭제행의 빈 필수 셀이 저장을 차단**한다 — AS-IS 가 통과시키는 저장을 막는 초과 검증이다
     * (`04_impl-gap-audit.md` G4-4). 공용 훅은 Hard Boundary 밖이므로 네 번째 인자
     * `validationRows` 로 대상 행만 좁혀 해소한다(훅이 이미 지원하는 경로다).
     */
    const rowsForRequired = dirty.filter(row => str(row.CRUD_TYPE) !== 'D');

    // 검증 순서 = 필수 → 업무규칙(AS-IS cs:1573 → 1603 순서).
    saveWithValidation(
      dirty,
      sheet === SHEETS.DAILY_CAPA ? NO_META_REQUIRED_COLUMNS : staticColumns[sheet],
      rows => {
        const failure = validateSave({
          sheet,
          dirtyRows: rows,
          sourceRows: source,
          staticColumns: staticColumns[sheet],
        });
        if (failure) {
          const message = t(failure.msgId, { defaultValue: '' });
          void setAlert({
            type: 'alert',
            // i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 직접 치환한다.
            content: failure.arg ? message.replace('{0}', failure.arg) : message,
          });
          return;
        }
        const sesUserId = useSessionStore.getState().session.userId ?? '';
        // SAVE SP 는 컬럼별 `'^'`-결합 CLOB 계약이라 **평면 payload** 를 보낸다(RP-1 — 행 배열을
        //   그대로 보내면 전 파라미터가 NULL 바인딩된다). {@link buildFlatSavePayload} 주석 참조.
        void (async () => {
          const result = await submitOptCapaSave(sheet, buildFlatSavePayload(sheet, rows, sesUserId));
          if (!result.ok) {
            void setAlert({
              type: 'alert',
              content:
                result.message || t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
            });
            return;
          }
          afterSaveSuccess(sheet, rows.length);
        })();
      },
      rowsForRequired as unknown as WijmoRowItem[]
    );
  };

  /** Excel Form — 버튼 클릭 즉시 다운로드(헤더 11토큰만 있는 빈 양식, R06). */
  const handleExcelForm = () => {
    void GridAction.flatExcelDownload(
      buildExcelFormRows(),
      buildExcelFormColumns(),
      EXCEL_FORM_FILE_NAME
    );
  };

  /** Item 팝업 확정 — `ITEM_ID` + `NICK_NAME` 동시 채움. 취소 시 아무것도 바꾸지 않는다(R-11). */
  const handleItemSelect = (itemId: string, nickName: string) => {
    const row = itemPopup?.row;
    if (!row || !itemId || !itemPopup) return;
    // 더블클릭이 일어난 **그 시트**의 tracker/grid 에 반영한다(시트별 ref 분리).
    const tracker = editTrackerRefs[itemPopup.sheet].current;
    const target = row as unknown as WijmoRowItem;
    const prevItemId = row[COLUMN.ITEM_ID] as WijmoPrimitive;
    const prevNickName = row[COLUMN.NICK_NAME] as WijmoPrimitive;
    row[COLUMN.ITEM_ID] = itemId;
    row[COLUMN.NICK_NAME] = nickName;
    // 값 대입만으로는 `CRUD_TYPE` 이 서지 않아 저장에서 통째로 빠진다 — 공용 tracker 를 경유한다.
    tracker?.storeChange(target, COLUMN.ITEM_ID, prevItemId, itemId as WijmoPrimitive);
    tracker?.storeChange(target, COLUMN.NICK_NAME, prevNickName, nickName as WijmoPrimitive);
    gridRefs[itemPopup.sheet].current?.invalidate();
  };

  /**
   * 탭 전환 가드(R09·R10):
   *   · 조회 중(`isFetching`) → **조용히** 무시. 토스트·alert 추가 금지(AS-IS 도 메시지가 없다).
   *   · 편집 중 → 차단 + `MSG01149`({0} = 활성 시트 라벨). AS-IS `MSG00129` 번호는 쓰지 않는다.
   */
  const handleTabChange = (index: number) => {
    const next = visibleSheets[index];
    if (!next || !sheet) return;
    if (isFetching) return;
    if (editMode[sheet]) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SHEET_CHANGE_BLOCKED, {
          defaultValue: 'You are modifying {0} and can not change the sheet.',
        }).replace('{0}', SHEET_LABEL[sheet]),
      });
      return;
    }
    setActiveSheet(next);
  };

  // ── SubTitle 버튼 ───────────────────────────────────────────────────────────────────
  //   AS-IS toolbarOverride 5종(Find/Save/Delete/Edit/Insert) + 전용 3종. `hasButton` 을 곱한다.
  const featureButtons = useMemo(
    () => buildFeatureButtonVisibility(sheet ?? activeSheet, divisionId),
    [sheet, activeSheet, divisionId]
  );
  const authorized = hasDivisionAuth;

  /**
   * **생략·`false` 둘 다 금지**(R20 / design 01 §2.2 OV-05):
   *   · 키를 생략하면 공용 `SubTitle` 기본 핸들러(`addRow`/`removeRow`)가 살아나 Daily Capa 에서도
   *     행이 생기고, AS-IS 에 없던 동작이 붙는다.
   *   · `false` 로 두면 버튼이 **사라지는데** AS-IS 는 Save/Delete/Insert 버튼이 항상 보인다.
   * 그래서 편집모드를 ternary 조건에 넣지 않고 **핸들러 안에서** `editMode` 를 확인해 무동작으로
   * 처리한다(`handleSave`/`handleDelete`/`handleInsert` 첫 가드).
   */
  const hotkeyConfig: HotkeyConfig = {
    search: authorized && hasButton('SEARCH') ? handleSearch : false,
    save: authorized && hasButton('SAVE') ? handleSave : false,
    delete: authorized && hasButton('DELETE') ? handleDelete : false,
    insert: authorized && hasButton('INSERT') ? handleInsert : false,
    upload:
      authorized && hasButton('UPLOAD') && featureButtons.excelUpload
        ? () => setOpenUpload(true)
        : false,
    manual: false,
    /**
     * EXCEL — `SCM_ADM_MNU_BTN_MPG_M` 에 8 그리드 시트 × `EXCEL` 이 `USE_YN='Y'` 로 등록돼 있고
     * `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 이 4그룹에 부여한다 = **admin 관리 대상**이다. 키를 아예
     * 생략하면 공용 `SubTitle` 기본 액션(`GridAction.excelDownload`)이 무조건 살아나 admin 이
     * `USE_YN='N'` 으로 꺼도 버튼이 남는다(CLAUDE.md §2 체크3 / SCM0008 유형, iter-3 감사 G3-3).
     * 권한이 없을 때만 `excel: false` 를 넣어 숨기고, 있으면 **키 자체를 넣지 않는다** —
     * `excel: undefined` 로 쓰면 `{ ...DefaultButtonActions, ...hotkeyConfig }` 스프레드가 기본
     * 액션을 `undefined` 로 덮어써 버튼이 보이면서 눌리지 않는다. 자매 선례 `capa-teep-report`
     * ·`plan-control`·`project-route-electrode`·`shipment-request-semi` 동형.
     */
    ...(authorized && hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  /** 전용버튼 순서 = Excel Form → Batch Save → Edit(hook #120 / design 01 §4.4). */
  const customButtons = useMemo(
    () => [
      ...(authorized && hasButton('EXCEL') && featureButtons.excelForm
        ? [
            {
              label: t(LBL.EXCEL_FORM, { defaultValue: 'Excel Form' }),
              title: t(LBL.EXCEL_FORM, { defaultValue: 'Excel Form' }),
              action: handleExcelForm,
            },
          ]
        : []),
      ...(authorized && hasButton('SAVE') && featureButtons.batchSave
        ? [
            {
              label: t(LBL.BATCH_SAVE, { defaultValue: 'Batch Save' }),
              title: t(LBL.BATCH_SAVE, { defaultValue: 'Batch Save' }),
              action: () => setOpenBatch(true),
            },
          ]
        : []),
      ...(authorized && hasButton('EDIT')
        ? [
            {
              label: t(LBL.EDIT, { defaultValue: 'Edit' }),
              title: t(LBL.EDIT, { defaultValue: 'Edit' }),
              action: handleEdit,
            },
          ]
        : []),
    ],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [authorized, featureButtons, sheet, editMode, applied, t]
  );

  /** 조회조건 변경은 전 시트를 비우므로(`clearFilters`) EditTracker 도 8벌 전부 비운다. */
  const clearAllTrackers = () => {
    GRID_SHEETS.forEach(gridSheet => editTrackerRefs[gridSheet].current?.clearChanges());
  };

  return {
    divisionId,
    hotkeyConfig,
    customButtons,
    handleSearch,
    handleTabChange,
    handleItemSelect,
    refreshAfterExternalSave,
    clearAllTrackers,
    openBatch,
    closeBatch: () => setOpenBatch(false),
    openUpload,
    closeUpload: () => setOpenUpload(false),
    itemPopup,
    openItemPopup: (row: GridRow, rowSheet: GridSheet) => setItemPopup({ row, sheet: rowSheet }),
    closeItemPopup: () => setItemPopup(null),
  };
};
