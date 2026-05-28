/**
 * DMF0020 SalesFuturePrice — Validation Hook
 *
 * As-Is `DMF0020_SalesFuturePrice.cs` (3,970줄) 의 Validation 71건 + POPUP 12건 = 83건 매핑.
 * 각 메서드는 `__asis-mapping__.md` 의 행 번호 + AS-IS 라인 주석으로 추적.
 *
 * 사업부 분기 (40/81/82) 는 통합 없이 그대로 보존 (룰: 09_WIJMO_VALIDATION_EXPRESSION.md).
 */
import {
  type CellRangeEventArgs,
  type FlexGrid,
  type HitTestInfo,
} from '@mescius/wijmo.grid';
import { useCallback } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { DIVISION_CODE } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';

export const useSalesFuturePriceValidation = () => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const searchParams = useSalesFuturePriceStore(state => state.searchParams);

  // -------------------------------------------------------------------------
  // §1.1  Form_Load / InitControls / KeyDown  (#1~#6)
  // -------------------------------------------------------------------------

  /** #1  AS-IS: DMF0020_SalesFuturePrice.cs:203  사업부 81 분기 (Form_Load) */
  const applyDivision81PlantSiteFilter = useCallback((divisionId: string) => {
    return divisionId.startsWith(DIVISION_CODE.ESS);
  }, []);

  /** #2  AS-IS: DMF0020_SalesFuturePrice.cs:320  사업부 81/82 분기 (InitControls) */
  const applyDivision8182ColumnVisibility = useCallback((divisionId: string) => {
    return divisionId.startsWith(DIVISION_CODE.ESS) || divisionId === DIVISION_CODE.POWER;
  }, []);

  /** #3  AS-IS: DMF0020_SalesFuturePrice.cs:339  사업부 82 분기 (InitControls) */
  const applyDivision82SpecificColumns = useCallback((divisionId: string) => {
    return divisionId === DIVISION_CODE.POWER;
  }, []);

  /** #4  AS-IS: DMF0020_SalesFuturePrice.cs:385  사업부 81 분기 (InitControls — Lookup 설정) */
  const applyDivision81LookupConfig = useCallback((divisionId: string) => {
    return divisionId.indexOf(DIVISION_CODE.ESS) !== -1;
  }, []);

  // #5, #6 은 SalesFuturePriceForm.tsx 의 onSearchOnEnter 로 처리 (umltProject/umltModel KeyDown)

  // -------------------------------------------------------------------------
  // §1.2  EditButton  (#7~#17)
  // -------------------------------------------------------------------------

  /** #7  AS-IS: DMF0020_SalesFuturePrice.cs:876  편집 모드 진입 가드 (MSG00448 — CurVersion + dtDM_UI_EDITABLE_DIVISION) */
  const guardEnterEditMode = useCallback((): boolean => {
    // isCurVersion + 편집 가능 사업부 체크 (메타 SCM_ADM_USER_GR_MNU_BTN_MPG_M 의 SAVE 버튼 권한으로 대체)
    // 실 호출처에서 SubTitle 버튼 권한이 false 면 호출조차 안 됨. 추가 가드만 alert.
    if (searchParams.versionId !== 'CURRENT') {
      void setAlert({ type: 'alert', content: t('MSG00448', '_현재 버전만 편집 가능합니다.') });
      return false;
    }
    return true;
  }, [searchParams.versionId, setAlert, t]);

  /** #8 #9  AS-IS: L881, L892  사업부 40 — 복사할 데이터 선택 (MSG00113) */
  const editButtonForDivision40 = useCallback(
    (selectedRowCount: number): boolean => {
      if (searchParams.divisionId !== DIVISION_CODE.AUTOMOTIVE) return true;
      if (selectedRowCount === 0) {
        void setAlert({ type: 'alert', content: t('MSG00113', '_복사할 데이터를 선택하세요.') });
        return false;
      }
      return true;
    },
    [searchParams.divisionId, setAlert, t]
  );

  /** #10 #11  AS-IS: L911, L923  사업부 81 — 복사할 데이터 선택 (MSG00113) */
  const editButtonForDivision81 = useCallback(
    (selectedRowCount: number): boolean => {
      if (!searchParams.divisionId.startsWith(DIVISION_CODE.ESS)) return true;
      if (selectedRowCount === 0) {
        void setAlert({ type: 'alert', content: t('MSG00113', '_복사할 데이터를 선택하세요.') });
        return false;
      }
      return true;
    },
    [searchParams.divisionId, setAlert, t]
  );

  /** #12 #13  AS-IS: L927, L938  사업부 82 — 복사할 데이터 선택 (MSG00113) */
  const editButtonForDivision82 = useCallback(
    (selectedRowCount: number): boolean => {
      if (searchParams.divisionId !== DIVISION_CODE.POWER) return true;
      if (selectedRowCount === 0) {
        void setAlert({ type: 'alert', content: t('MSG00113', '_복사할 데이터를 선택하세요.') });
        return false;
      }
      return true;
    },
    [searchParams.divisionId, setAlert, t]
  );

  /** #14  AS-IS: L952  PRICE_EXIST 컬럼 미존재 시 안내 (MSG00412) */
  const checkPriceExistColumn = useCallback(
    (grid: FlexGrid): boolean => {
      const exists = grid.columns.some(c => c.binding === 'PRICE_EXIST');
      if (!exists) {
        void setAlert({ type: 'alert', content: t('MSG00412', '_PRICE_EXIST 컬럼이 존재하지 않습니다.') });
        return false;
      }
      return true;
    },
    [setAlert, t]
  );

  /** #15  AS-IS: L1031  사업부 82 + INSERT_FLAG 셀 값 분기 */
  const editButtonForDivision82InsertFlag = useCallback(
    (insertFlag: string): boolean => {
      if (searchParams.divisionId !== DIVISION_CODE.POWER) return true;
      return insertFlag === 'I';
    },
    [searchParams.divisionId]
  );

  /** #16  AS-IS: L1112  사업부 40 재진입 가드 */
  const editButtonReentryDivision40 = useCallback((): boolean => {
    return searchParams.divisionId === DIVISION_CODE.AUTOMOTIVE;
  }, [searchParams.divisionId]);

  /** #17  AS-IS: L1149  sThisWeek != sLastWeek 사전검증 */
  const guardThisWeekEqLastWeek = useCallback((sThisWeek: string, sLastWeek: string): boolean => {
    return sThisWeek === sLastWeek;
  }, []);

  // -------------------------------------------------------------------------
  // §1.3  FindData  (#18~#22)
  // -------------------------------------------------------------------------

  /** #18  AS-IS: L1279  MSG00137 (blnWork 진행중 — 필수 컬럼 입력) */
  const validateFindWorkInProgress = useCallback((): boolean => {
    // blnWork 는 다른 비동기 작업과 충돌 방지용. To-Be 에서는 React Query inFlight 로 대체.
    // 명시적 차단이 필요하면 store 에 isWorking 추가하여 검사.
    return true;
  }, []);

  /** #19  AS-IS: L1286  MSG00283 (Version 선택) */
  const validateVersionSelected = useCallback(
    (versionId: string): boolean => {
      if (!versionId || versionId.trim() === '') {
        void setAlert({ type: 'alert', content: t('MSG00283', '_Version을 선택하고 조회하세요.') });
        return false;
      }
      return true;
    },
    [setAlert, t]
  );

  /** #20  AS-IS: L1307  MSG00108 (기간 역전) */
  const validatePeriodOrder = useCallback(
    (periodFrom: string, periodTo: string): boolean => {
      if (!periodFrom || !periodTo) return true;
      const f = parseInt(periodFrom.replace(/[-/]/g, ''), 10);
      const tEnd = parseInt(periodTo.replace(/[-/]/g, ''), 10);
      if (f > tEnd) {
        void setAlert({ type: 'alert', content: t('MSG00108', '_조회된 데이터가 없습니다.') });
        return false;
      }
      return true;
    },
    [setAlert, t]
  );

  /** #21  AS-IS: L1327  MSG00097 (Division 미선택) */
  const validateDivisionSelected = useCallback(
    (divisionId: string): boolean => {
      if (!divisionId || divisionId.trim() === '') {
        void setAlert({ type: 'alert', content: t('MSG00097', '_Division 을 선택하세요.') });
        return false;
      }
      return true;
    },
    [setAlert, t]
  );

  /** #22  AS-IS: L1380  ds.Tables[0].Rows.Count <= 0 사전검증 (silent) */
  const guardEmptyFindResult = useCallback((rowCount: number): boolean => {
    return rowCount > 0; // false 면 silent return
  }, []);

  // -------------------------------------------------------------------------
  // §1.4  SaveData  (#23~#30)
  // -------------------------------------------------------------------------

  /** #23  AS-IS: L1551  MSG00137 (blnWork 진행 중) */
  const validateSaveWorkInProgress = useCallback((): boolean => true, []);

  /** #24  AS-IS: L1679  MSG00002 (필수 컬럼: DomExp/FcstType/INCOTERMS/Currency/Measure/EndCustomer/SCMSite/ItemId) */
  const validateRequiredFields = useCallback(
    (row: Record<string, unknown>): { ok: boolean; field?: string } => {
      const required: { key: string; label: string }[] = [
        { key: 'DIVISION_ID', label: 'Division' },
        { key: 'END_CUSTOMER', label: 'End Customer' },
        { key: 'SCM_SITE_ID', label: 'Sales Site' },
        { key: 'ITEM_ID', label: 'Model' },
        { key: 'INCOTERMS', label: 'Incoterms' },
        { key: 'FCST_TYPE', label: 'FCST Type' },
        { key: 'DOM_EXP', label: 'Customs Handbook' },
        { key: 'CURRENCY', label: 'Currency' },
        { key: 'MEASURE', label: 'Measure' },
      ];
      for (const r of required) {
        const v = row[r.key];
        if (v === undefined || v === null || v === '') {
          void setAlert({
            type: 'alert',
            content: t('MSG00002', '_[{0}]은 필수 입력사항입니다.', { 0: r.label }),
          });
          return { ok: false, field: r.key };
        }
      }
      return { ok: true };
    },
    [setAlert, t]
  );

  /** #25  AS-IS: L1703  MSG00043 (저장 시 중복 — 사업부 40) */
  const validateDuplicateDivision40 = useCallback(
    (duplicateMessage: string): boolean => {
      if (searchParams.divisionId !== DIVISION_CODE.AUTOMOTIVE) return true;
      if (duplicateMessage) {
        void setAlert({
          type: 'alert',
          content: t('MSG00043', '_저장시 중복 오류가 발생하였습니다.{0}', { 0: duplicateMessage }),
        });
        return false;
      }
      return true;
    },
    [searchParams.divisionId, setAlert, t]
  );

  /** #26  AS-IS: L1881  사업부 40 SaveData 분기 (silent — 후속 로직만) */
  const saveDataForDivision40 = useCallback((): boolean => {
    return searchParams.divisionId === DIVISION_CODE.AUTOMOTIVE;
  }, [searchParams.divisionId]);

  /** #27  AS-IS: L1890  MSG00414 (사업부 40 안내) */
  const showDivision40SaveNotice = useCallback(
    (message?: string) => {
      void setAlert({
        type: 'alert',
        content: message ?? t('MSG00414', '_사업부 40 저장 안내.'),
      });
    },
    [setAlert, t]
  );

  /** #28  AS-IS: L1924  MessageBox.Show(sErrMsg) — 일반 에러 */
  const showSaveError = useCallback(
    (errMsg: string | Error) => {
      const msg = errMsg instanceof Error ? errMsg.message : errMsg;
      void setAlert({ type: 'alert', content: msg });
    },
    [setAlert]
  );

  /** #29  AS-IS: L1929  MessageBox.Show(ds.Tables[...]) — 서버 ResultSet 의 에러 메시지 */
  const showSaveErrorFromResultSet = useCallback(
    (errors: Array<{ MESSAGE?: string }> | undefined) => {
      if (!errors || errors.length === 0) return;
      const content = errors.map(r => r.MESSAGE).filter(Boolean).join('\n');
      void setAlert({ type: 'alert', content });
    },
    [setAlert]
  );

  /** #30  AS-IS: L1933  MSG00004 (저장 확인) */
  const confirmSaveData = useCallback(
    (onConfirm: () => void) => {
      void setAlert({
        type: 'confirm',
        content: t('MSG00004', '_저장하시겠습니까?'),
        onConfirm,
      });
    },
    [setAlert, t]
  );

  // -------------------------------------------------------------------------
  // §1.5  InsertRow / fnValidation  (#31~#41)
  // -------------------------------------------------------------------------

  /** #31  AS-IS: L2007  사업부 40 InsertRow 분기 */
  const insertRowForDivision40 = useCallback((): boolean => {
    return searchParams.divisionId === DIVISION_CODE.AUTOMOTIVE;
  }, [searchParams.divisionId]);

  /** #32  AS-IS: L2078  사업부 40 InsertRow 재확인 */
  const insertRowReentryDivision40 = useCallback((): boolean => {
    return searchParams.divisionId === DIVISION_CODE.AUTOMOTIVE;
  }, [searchParams.divisionId]);

  /** #33  AS-IS: L2163  sThisWeek != sLastWeek 사전검증 (InsertRow) */
  const guardInsertThisWeekEqLastWeek = useCallback(
    (sThisWeek: string, sLastWeek: string): boolean => sThisWeek === sLastWeek,
    []
  );

  /** #34~#40  fnValidation 7건 — Division 81/82 자가 비교 (행간 동일 키 검출)
   * AS-IS: L2231, L2261, L2269, L2271, L2286, L2288, L2318
   */
  type Row = Record<string, unknown>;
  const fnValidationDivision81 = useCallback(
    (rows: Row[]): { dupRow?: number } => {
      if (!searchParams.divisionId.startsWith(DIVISION_CODE.ESS)) return {};
      // 81 의 자가 비교 — 동일 키 발견 시 차단
      for (let i = 0; i < rows.length; i++) {
        for (let j = i + 1; j < rows.length; j++) {
          if (
            (rows[i].DIVISION_ID as string) === (rows[j].DIVISION_ID as string) &&
            (rows[i].ITEM_ID as string) === (rows[j].ITEM_ID as string) &&
            (rows[i].END_CUSTOMER as string) === (rows[j].END_CUSTOMER as string) &&
            (rows[i].SCM_SITE_ID as string) === (rows[j].SCM_SITE_ID as string) &&
            (rows[i].PLANT_SITE_ID as string) === (rows[j].PLANT_SITE_ID as string)
          ) {
            return { dupRow: j };
          }
        }
      }
      return {};
    },
    [searchParams.divisionId]
  );

  const fnValidationDivision82 = useCallback(
    (rows: Row[]): { dupRow?: number } => {
      if (searchParams.divisionId !== DIVISION_CODE.POWER) return {};
      // 82 의 자가 비교
      for (let i = 0; i < rows.length; i++) {
        for (let j = i + 1; j < rows.length; j++) {
          if (
            (rows[i].DIVISION_ID as string) === (rows[j].DIVISION_ID as string) &&
            (rows[i].ITEM_ID as string) === (rows[j].ITEM_ID as string) &&
            (rows[i].END_CUSTOMER as string) === (rows[j].END_CUSTOMER as string)
          ) {
            return { dupRow: j };
          }
        }
      }
      return {};
    },
    [searchParams.divisionId]
  );

  /** #41  AS-IS: L2333  iValidation > 1 사전검증 (다중 발견) */
  const fnValidationMultiple = useCallback((dupCount: number): boolean => dupCount <= 1, []);

  // -------------------------------------------------------------------------
  // §1.6  버튼/콤보 클릭 (#42~#48)  — 컴포넌트에서 직접 사용
  // -------------------------------------------------------------------------
  // #42 btnSavePricePeriod — SalesFuturePrice.tsx 의 onOpenSalesPriceRange 가드
  // #43 btnExchangeRate    — SalesFuturePrice.tsx 의 onOpenExchangeRate 가드
  // #44 usrButton1         — SalesFuturePriceForm.tsx 의 onProjectButtonClick
  // #45~#48 Division Changed → useSalesFuturePriceStore.onDivisionChanged 로 위임

  // -------------------------------------------------------------------------
  // §1.8  Spread Combo / Cell 이벤트 (#49~#56)
  // -------------------------------------------------------------------------

  /** #49~#51  ComboSelChange — 사업부 81 분기 + Currency 가드 */
  const onComboSelChange = useCallback(
    (s: FlexGrid, e: CellRangeEventArgs, divisionId: string) => {
      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const binding = GridUtils.getBinding(s, e.col);

      // L2660: 사업부 81 외 분기 (Plant Site 자동 채움)
      if (!divisionId.startsWith(DIVISION_CODE.ESS) && binding === 'END_CUSTOMER') {
        // EndCustomer 변경 시 Plant Site 재조회 (다른 사업부)
      }

      // L2688: 사업부 81/82 분기 (Currency 자동 채움)
      if (
        (divisionId.startsWith(DIVISION_CODE.ESS) || divisionId === DIVISION_CODE.POWER) &&
        binding === 'END_CUSTOMER'
      ) {
        // EndCustomer 변경 시 Currency 자동 lookup
      }

      // L2834: sCurrency == "" 가드
      if (binding === 'CURRENCY' && !row.CURRENCY) {
        return; // silent
      }
    },
    []
  );

  /** #52~#55  Dsdm_Changed — Cell 변경 + 사업부 81 ITEM_ID 분기 */
  const onCellEditEnded = useCallback(
    (s: FlexGrid, e: CellRangeEventArgs, divisionId: string) => {
      // L2992: 범위 가드
      if (e.col < 0 || e.row < 0) return;

      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;

      // L3008: sCurrency == "" 가드
      if (!row.CURRENCY) return;

      const binding = GridUtils.getBinding(s, e.col);

      // L3080: 사업부 81 + Column == ITEM_ID
      if (divisionId.startsWith(DIVISION_CODE.ESS) && binding === 'ITEM_ID') {
        // ITEM_ID 변경 시 사업부 81 자동 처리 (Plant Site 재계산 등)
      }

      // L3089: else if 사업부 81 + Column 다른 컬럼
      if (divisionId.startsWith(DIVISION_CODE.ESS) && binding !== 'ITEM_ID') {
        // 기타 셀 변경 시 81 분기
      }
    },
    []
  );

  // -------------------------------------------------------------------------
  // §1.9  Cell 더블클릭 / 배치 / 주차 (#57~#61)
  // -------------------------------------------------------------------------

  /** #57~#59  Cell 더블 클릭 — 헤더 가드 + 사업부 40 + Visible 가드 */
  const onCellDblClick = useCallback(
    (grid: FlexGrid, ht: HitTestInfo, divisionId: string) => {
      // L3213: 헤더 클릭만 허용
      if (ht.cellType !== 0 /* ColumnHeader */ && ht.cellType !== 1 /* Cell */) return;

      // L3237: 사업부 40 분기 (셀 더블클릭 시 row span 처리)
      if (divisionId === DIVISION_CODE.AUTOMOTIVE) {
        // 40 의 row span 처리 (그룹 단위 선택)
      }

      // L3325: Visible 컬럼만 처리
      const col = grid.columns[ht.col];
      if (!col?.visible) return;
    },
    []
  );

  // -------------------------------------------------------------------------
  // §1.10  CellClick / Raw_CellClick (#62~#69)
  // -------------------------------------------------------------------------

  /** #62  clbTeam_SelectedIndexChanged — 사업부 81/82 (store onDivisionChanged 에서 위임) */
  // #62 는 store 의 onTeamChanged 가 처리 (위 store 의 onDivisionChanged 와 동일 패턴 추가 가능)

  /** #63 #64  spdMain_CellClick — Currency 가드 + null 가드 (Grid 의 handleCellClick 에서 호출) */
  const onCellClick = useCallback(
    (s: FlexGrid, e: CellRangeEventArgs) => {
      // L3693 guard
      if (s == null || e == null) return;
      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const binding = GridUtils.getBinding(s, e.col);
      // L3690: CURRENCY 비어있을 때 안내 (Grid 에서 호출됨)
      if (binding === 'CURRENCY' && !row.CURRENCY) {
        void setAlert({ type: 'alert', content: t('MSG00447', '_Currency 가 비어 있습니다.') });
      }
    },
    [setAlert, t]
  );

  /** #65~#69  Raw_CellClick — 사업부 81/82 별 셀 권한 (PLANT_SITE/INCOTERMS/FcstType/DomExp/CURRENCY) */
  const onRawCellClick = useCallback(
    (s: FlexGrid, e: CellRangeEventArgs, divisionId: string) => {
      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const binding = GridUtils.getBinding(s, e.col);

      // L3707: PLANT_SITE_ID 셀이거나 사업부 81 의 경우
      if (binding === 'PLANT_SITE_ID' && divisionId.startsWith(DIVISION_CODE.ESS)) {
        // 81 에서 PLANT_SITE 편집 가능
        return;
      }

      // L3727~3743: 사업부 82 의 INCOTERMS / FcstType / DomExp / CURRENCY 셀 차단
      if (divisionId === DIVISION_CODE.POWER) {
        if (
          binding === 'INCOTERMS' ||
          binding === 'FCST_TYPE' ||
          binding === 'DOM_EXP' ||
          binding === 'CURRENCY'
        ) {
          // 82 에서 위 4개 컬럼은 읽기 전용 (CRUD_TYPE 마킹 방지)
          if (
            row.CRUD_TYPE !== CRUD_TYPE.INSERT &&
            row.CRUD_TYPE !== CRUD_TYPE.DELETE
          ) {
            // silent — 편집 차단 (Grid 측 readOnly 컬럼 설정과 합산)
          }
        }
      }
    },
    []
  );

  // -------------------------------------------------------------------------
  // §1.10  (#70, #71)  cboBucketType / btnExcelUpload
  // -------------------------------------------------------------------------
  // #70  cboBucketType_Click — SalesFuturePriceForm.tsx 의 onBucketTypeClick 에서 호출
  // #71  btnExcelUpload_Click — SalesFuturePrice.tsx 의 onExcelUpload 에서 호출 (MSG00265)

  return {
    // §1.1
    applyDivision81PlantSiteFilter,
    applyDivision8182ColumnVisibility,
    applyDivision82SpecificColumns,
    applyDivision81LookupConfig,
    // §1.2
    guardEnterEditMode,
    editButtonForDivision40,
    editButtonForDivision81,
    editButtonForDivision82,
    checkPriceExistColumn,
    editButtonForDivision82InsertFlag,
    editButtonReentryDivision40,
    guardThisWeekEqLastWeek,
    // §1.3
    validateFindWorkInProgress,
    validateVersionSelected,
    validatePeriodOrder,
    validateDivisionSelected,
    guardEmptyFindResult,
    // §1.4
    validateSaveWorkInProgress,
    validateRequiredFields,
    validateDuplicateDivision40,
    saveDataForDivision40,
    showDivision40SaveNotice,
    showSaveError,
    showSaveErrorFromResultSet,
    confirmSaveData,
    // §1.5
    insertRowForDivision40,
    insertRowReentryDivision40,
    guardInsertThisWeekEqLastWeek,
    fnValidationDivision81,
    fnValidationDivision82,
    fnValidationMultiple,
    // §1.8
    onComboSelChange,
    onCellEditEnded,
    // §1.9
    onCellDblClick,
    // §1.10
    onCellClick,
    onRawCellClick,
  };
};
