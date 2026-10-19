import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ShipmentLotSizeBatchModal } from './components/modals/ShipmentLotSizeBatchModal';
import { ShipmentLotSizeForm } from './components/ShipmentLotSizeForm';
import { ShipmentLotSizeGrid } from './components/ShipmentLotSizeGrid';
import { useShipmentLotSizeValidation } from './hooks/useShipmentLotSizeValidation';
import { LBL, LOT_SIZE_COLUMNS, MENU_ID, MSG, SHEETS } from './shipment-lot-size.constants';
import type { BatchMode, LotSizePopupRow, ShipmentLotSizeRow } from './shipment-lot-size.types';
import styles from './ShipmentLotSize.module.scss';
import { useShipmentLotSizeStore } from './useShipmentLotSizeStore';
import { buildColumns } from './utils/shipmentLotSize.columns';
import { isDefaultRevertRow } from './utils/shipmentLotSize.derive';
import { type LotSizeSaveRow, submitLotSizeSaveRequest } from './utils/shipmentLotSize.saveRequest';

interface InvalidCell {
  row: Record<string, unknown>;
  column: string;
}

// GET_INPUT 파라미터용 콤마 join — 체크행 1건당 정확히 1토큰(중복 제거 금지, 빈값도 자리 유지).
//   GET_INPUT SP 는 5개 CSV 를 UF_FX_STRING_SPLIT 으로 쪼갠 뒤 `A.SEQ=B.SEQ=C.SEQ=D.SEQ=E.SEQ` 로
//   위치 조인한다(PKG_SCP0028 body 438~467 실측 2026-09-30). 즉 다섯 리스트는 길이가 같고 i 번째끼리
//   한 행을 이루어야 한다 — 필드별로 중복을 제거하면 길이·위치가 어긋나 조합이 통째로 바뀐다.
//   SP 주석의 호출 예시도 2행이면 '40,40' / 'A,A' 처럼 중복을 그대로 싣는다(body 377~378).
//   AS-IS SaveData(팝업 cs:330~352)의 divList/operationList/... 누적과 동일하다.
const csvPositional = (rows: LotSizePopupRow[], field: string): string =>
  rows.map(r => safeString((r as Record<string, unknown>)[field]).trim()).join(',');

// AS-IS GSCM.SCP.Forms.UIL SCP0028_Shipment_Lot_Size — 단일 그리드 마스터 편집 화면(domain SSP/Shipping).
//   설계: .atlas/gscm-design/SCP0028/design/00~03. 상세 매핑: __asis-mapping__.md.
//   버튼 파리티(design 01 §2, iter-2 재정합):
//     - 툴바 Insert/Delete = 둘 다 노출 + 무동작(사용자 지시 2026-10-07). Insert 는 AS-IS 빈 구현 파리티(R10),
//       Delete 도 no-op 로 맞췄다(종전 removeRow(신규행만)은 'I' 행이 안 생기는 이 화면에서 실효 없었음).
//     - 커스텀 버튼 Input/Delete(btnInput/btnDelete) = 일괄입력/삭제 팝업(R5/R6) — 별도 어포던스.
//       배치는 BtnArea(SubTitle customButtons) — 사용자 지시 2026-09-30(조회영역 extraButtons 에서 이동,
//       SSP0003 과 동형). 자격 미충족 시 '숨김'이 아니라 'disabled'(살아 보이는 죽은 버튼 방지).
//   편집은 NSCM 상시편집 표준(Edit 토글 미이식, 자매 SSP0025/SCP0005 동형) — INPUT_TP_CD 메타 화이트리스트로
//   4컬럼(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN)만 조회 직후 즉시 편집. hasButton('EDIT')은 권한 판정 전용.
export const ShipmentLotSize = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { validateRows } = useShipmentLotSizeValidation();
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집권한 판정 — 로드 시 1회(토글 아님). EDIT 권한 없으면 그리드 읽기전용, 있으면 4컬럼 조회 후 즉시 편집(G1).
  //   AS-IS Edit 버튼/편집모드 토글은 미이식(NSCM 상시편집 표준, memory editbutton-toggle-not-ported).
  const canEdit = hasButton('EDIT');

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useShipmentLotSizeStore(s => s.searchCondition);
  const setSearchCondition = useShipmentLotSizeStore(s => s.setSearchCondition);
  const filters = useShipmentLotSizeStore(s => s.filters);
  const setFilter = useShipmentLotSizeStore(s => s.setFilter);
  const openSearchArea = useShipmentLotSizeStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentLotSizeStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentLotSizeStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentLotSizeStore(s => s.fetchStaticColumns);
  const clearFilters = useShipmentLotSizeStore(s => s.clearFilters);
  const initialized = useShipmentLotSizeStore(s => s.initialized);

  // 일괄입력 후보(GET_INPUT) 로드 오버레이 — null 이면 메인 조회 결과 표시(design 01 R5).
  //   상시편집 표준(Edit 토글 미이식): 편집모드 state 없음. 편집가부는 컬럼 메타 화이트리스트만 판정.
  const [inputRows, setInputRows] = useState<ShipmentLotSizeRow[] | null>(null);
  const [invalidCells, setInvalidCells] = useState<InvalidCell[]>([]);
  const [itemModalOpen, setItemModalOpen] = useState(false);
  const [batchMode, setBatchMode] = useState<BatchMode | null>(null);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const mainRows = useMemo<ShipmentLotSizeRow[]>(() => data?.o_rc1 ?? [], [data]);
  // 일괄입력 후보가 로드돼 있으면 그리드는 후보를 보여준다(편집모드). 아니면 메인 조회 결과.
  const rows = useMemo<ShipmentLotSizeRow[]>(() => inputRows ?? mainRows, [inputRows, mainRows]);
  // 저장 필수검증용 컬럼셋 — 그리드와 동일하게 admin fetch 성공 시 admin authoritative, 실패/미등록 시 constants
  //   fallback(편집 4컬럼 INPUT_TP_CD='M'·'*' 라벨 방출). staticColumns 를 그대로 넘기면 fetch 실패 시 빈 배열이라
  //   useSaveWithValidation 필수검사가 통째로 건너뛰어진다(sheet-columns 이중경로 함정) — fallback 로 대칭 유지.
  const saveColumns = useMemo(
    () => buildColumns(LOT_SIZE_COLUMNS, staticColumns[SHEETS.MAIN]),
    [staticColumns]
  );

  useEffect(() => {
    // mount 시 filters 초기화 — AS-IS Form_Load 자동조회 없음(design 02 §4). keep-alive 잔존 filters 로
    //   stale 자동조회가 나가지 않게 진입마다 비워 명시 Search 전까지 막는다(nscm-patterns §5-7).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // cascade 상위(Division) 변경 = 하위 reset·콤보 재조회(store/Form) + Grid 비움(store 가 filters clear) +
  //   편집중 상태(신규 후보·CRUD 추적·위반셀) 초기화 — convert-core §5-5 / design 02 §3(G2 해소).
  //   store 가 filters 를 비우면 useTabProcQuery 키가 바뀌어 그리드가 비므로, 여기선 오버레이/추적만 초기화한다.
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    setInputRows(null);
    setInvalidCells([]);
    editTrackerRef.current?.clearChanges();
  }, [sc.divisionId]);

  const handleSearch = () => {
    // 필수 조회조건(design 01 R9) — Division 미선택(권한 0건 R1 포함) 시 조회 차단 + 안내.
    if (!safeString(sc.divisionId).trim()) {
      // MSG00429='{0} value is required.'(등록) — i18next 기본 보간자가 {{ }} 라 {0}은 t() 인자로 안 채워진다.
      //   자매 관례대로 .replace('{0}', 라벨)로 Division 삽입(memory i18n-zero-placeholder-needs-manual-replace).
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_VALUE, '_{0} value is required.').replace(
          '{0}',
          t(LBL.DIVISION, 'Division')
        ),
      });
      return;
    }
    setInputRows(null); // 일괄입력 후보 오버레이 해제 — 메인 조회 결과 표시
    setInvalidCells([]);
    setFilter();
    void fetchStaticColumns();
  };

  const submitSave = async (saveRows: LotSizeSaveRow[], isDelete: boolean) => {
    const result = await submitLotSizeSaveRequest(saveRows, sessionUserId ?? '', isDelete);
    if (!result.ok) {
      setToast({ type: 'error', message: result.message ?? t(MSG.SAVE_FAIL, '_Failed to save.') });
      return false;
    }
    setToast({
      type: 'success',
      message: isDelete
        ? t(MSG.DELETE_SUCCESS, '_Deleted successfully.')
        : t(MSG.SAVE_SUCCESS, '_Saved successfully.'),
    });
    editTrackerRef.current?.clearChanges();
    setInputRows(null);
    void refetch();
    return true;
  };

  // 편집행 → SAVE payload 행 (키/편집값 직송).
  //   activeFlag 는 신규/수정 구분 없이 'M' 고정 — SAVE SP 분기는 'M'(UPDATE, SQL%ROWCOUNT=0 이면 INSERT)과
  //   'D'(DELETE) 둘뿐이고 'I' 분기가 없다(PKG_SCP0028 body 690~751 실측 2026-09-30). 'M' 자체가 upsert 라
  //   일괄입력 후보(미등록 키)도 이 분기에서 INSERT 된다 — AS-IS 도 같은 경로다(툴바 InsertRow 는 무동작이라
  //   'I' 행 자체가 생기지 않는다).
  const toSaveRow = (r: Record<string, unknown>): LotSizeSaveRow => ({
    activeFlag: 'M',
    DIVISION_ID: r.DIVISION_ID,
    OPERATION_GROUP_ID: r.OPERATION_GROUP_ID,
    FROM_SITE: r.FROM_SITE,
    TO_SITE: r.TO_SITE,
    ITEM_ID: r.ITEM_ID,
    TRANS_MODE_CODE: r.TRANS_MODE_CODE,
    LOT_SIZE: r.LOT_SIZE,
    INCREMENT: r.INCREMENT,
    SPLIT_YN: r.SPLIT_YN,
    VALID_YN: r.VALID_YN,
  });

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // 기본값 회귀행(M & LOT=''&INC=''&VALID='Y'&SPLIT='N')은 변경취소로 제외(design 03 §3-13).
    const dirty = src.filter(r => r.CRUD_TYPE && !(r.CRUD_TYPE === 'M' && isDefaultRevertRow(r)));
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No modifications have been made.') });
      return;
    }
    setInvalidCells([]);
    // 저장검증 3종(design 03 §4.3): LOT<INC / 0값 (클라) → 통과 후 메타 필수검증(saveWithValidation) → SAVE.
    const v = validateRows(dirty);
    if (!v.ok) {
      setInvalidCells(v.invalidCells);
      return;
    }
    saveWithValidation(
      dirty as unknown as ShipmentLotSizeRow[],
      saveColumns,
      changed => void submitSave((changed as Record<string, unknown>[]).map(toSaveRow), false)
    );
  };

  // 일괄입력(btnInput, design 01 R5): 팝업 선택 후보 → GET_INPUT 재조회 → 후보행 로드.
  //   상시편집이라 후보 4컬럼은 로드 즉시 편집 가능(AS-IS 자동 EditButton(R3) = 상시편집으로 흡수).
  //   저장 대상은 '로드된 후보 전부'가 아니라 '사용자가 고친 행'뿐이다(아래 CRUD_TYPE 주석).
  const handleBatchInputConfirm = async (picked: LotSizePopupRow[]) => {
    setBatchMode(null);
    if (picked.length === 0) return;
    // 팝업은 즉시 닫고 후보가 그리드에 꽂힐 때까지 전역 로딩바 표시(사용자 결정 2026-09-30).
    //   종전엔 팝업만 닫히고 POST 동안 아무 피드백이 없어 "OK 눌러도 반응 없다"로 보였다.
    //   AS-IS FindInput 도 팝업을 닫은 뒤 ProgressForm 을 띄운다(cs:396·403·454) — 순서 동일.
    setProgress(50); // 0<v<100 = 표시. 완료는 finally 의 setProgress(100)=리셋(useUIStore 규약).
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/INSERT/call-proc`,
        {
          // divisionId 도 체크행별 CSV 다 — AS-IS FindInput(cs:417)이 popup 의 divList 를 그대로 넘긴다.
          //   화면 조회조건(sc.divisionId) 단일값을 넘기면 A 는 1토큰인데 C/D/E 는 N 토큰이라
          //   SEQ 위치조인에서 첫 행만 살아남는다(후보가 1건으로 쪼그라드는 증상).
          divisionId: csvPositional(picked, 'DIVISION_ID'),
          operationGroup: csvPositional(picked, 'OPERATION_GROUP_ID'),
          fromSite: csvPositional(picked, 'FROM_SITE'),
          toSite: csvPositional(picked, 'TO_SITE'),
          itemId: csvPositional(picked, 'ITEM_ID'),
          userId: sessionUserId ?? '',
        }
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Failed to load candidates.') });
        return;
      }
      const result = (res.data?.result ?? {}) as { o_rc1?: ShipmentLotSizeRow[] };
      // CRUD_TYPE 을 주입하지 않는다 — 후보는 '조회된 행'으로 올리고, 실제로 고친 행만 EditTracker 가
      //   'M' 으로 찍는다(원래 값으로 되돌리면 자동 해제). AS-IS 도 FindInput 이 올린 행을 스프레드가
      //   편집 시점에 'M' 으로 표시하고 미편집·기본값 행은 action 을 비워 저장에서 뺀다(cs:588~594·631~654).
      //   전건 'I' 주입은 두 사고를 냈다: (a) 후보 전부가 필수검증 대상이라 한 행만 채우면 저장이 막힘
      //   (b) SAVE SP 에 'I' 분기가 없어(body 690~751 실측) 보내도 조용히 무시됨.
      const candidates = result.o_rc1 ?? [];
      // 후보 0건은 그냥 두면 그리드만 조용히 비어 "OK 눌러도 아무 일도 안 난다"로 보인다 — 명시 안내하고
      //   기존 조회결과를 유지한다(오버레이 미적용).
      if (candidates.length === 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NO_CANDIDATE, '_No data have been retrieved.'),
        });
        return;
      }
      setInputRows(candidates); // 후보 오버레이 로드(상시편집 — 4컬럼 즉시 편집)
    } catch {
      setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Failed to load candidates.') });
    } finally {
      setProgress(100); // 성공/실패/0건 어느 경로로 빠져나가도 로딩바 해제
    }
  };

  // 일괄삭제(btnDelete, design 01 R6): 팝업 선택 후보 → active_flag='D'(lot/inc 0, valid 'N') SAVE → 재조회.
  //   SAVE SP 'D' 분기 삭제키 실측(ora.py PKG_SCP0028 body): DIVISION_ID/OPERATION_GROUP/FROM_SITE/TO_SITE/
  //   ITEM_ID 5키 — TRANS_MODE_CODE 는 삭제 WHERE 에 없다(G5 해소). POPUP SP O_RC1 이 이 5키를 전건 반환
  //   (실측: DIVISION_ID/OPERATION_GROUP_ID/FROM_SITE/TO_SITE/ITEM_ID)하므로 삭제키 공백 없음.
  const handleBatchDeleteConfirm = (picked: LotSizePopupRow[]) => {
    setBatchMode(null);
    if (picked.length === 0) return;
    const deleteRows: LotSizeSaveRow[] = picked.map(r => {
      const rec = r as Record<string, unknown>;
      return {
        activeFlag: 'D',
        DIVISION_ID: rec.DIVISION_ID,
        OPERATION_GROUP_ID: rec.OPERATION_GROUP_ID,
        FROM_SITE: rec.FROM_SITE,
        TO_SITE: rec.TO_SITE,
        ITEM_ID: rec.ITEM_ID,
        // AS-IS FindDelete(cs:498)는 행마다 리터럴 'X' 를 싣는다 — POPUP O_RC1 이 TRANS_MODE_CODE 를
        //   반환하지 않아 rec 값으로는 빈 토큰이 되고, '^'-split 자리수만 맞던 종전 코드와 값이 달라진다.
        //   SAVE 'D' 분기의 삭제 WHERE 는 5키뿐이라(G5 실측) 동작에는 영향이 없지만 파라미터 형식을 맞춘다.
        TRANS_MODE_CODE: 'X',
        LOT_SIZE: '0',
        INCREMENT: '0',
        SPLIT_YN: 'N',
        VALID_YN: 'N',
      };
    });
    void submitSave(deleteRows, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // 툴바 Insert/Delete = 둘 다 '노출 + 무동작'(사용자 지시 2026-10-07 — 기본 버튼은 살리고 기능은 없앤다).
    //   Insert 는 AS-IS InsertRow() 빈 구현 파리티(R10)로 원래 no-op 였고, Delete 도 여기서 no-op 로 맞춘다
    //   (종전 GridAction.removeRow(grid, true) = 신규행만 제거. 이 화면은 Insert 가 no-op 라 'I' 행이 생기지
    //   않고, 일괄입력 후보도 CRUD_TYPE 미주입 '조회행'이라 실제로 지워지는 행이 없었다 — 동작 손실 없음).
    //   실삭제는 일괄삭제 팝업(btnDelete, R6 = BtnArea 커스텀 버튼)만 담당한다.
    //   금지: 숨김(false) 하드코딩 / 키 생략 / hasButton 게이트 제거(AUTH-01).
    //   버튼 노출 여부는 코드가 아니라 DB 권한 메타 `SCM_ADM_USER_GR_MNU_BTN_MPG_M.USE_YN` 이 정한다(AUTH-02).
    //   실측 이력(2026-10-07): 10:32 'N'(minyonglee1) → 11:52 'Y' 복구·동작확인 → 14:53 다시 'N'(admin).
    //   즉 현재는 두 버튼이 '숨김'이고, 그게 정상이다. 보이게 하려면 그 4행을 'Y' 로 올린다
    //   (design/99_btn_auth_restore_insert_delete.sql · 되돌리기 _rollback.sql).
    //   참고: 등록 테이블 SCM_ADM_MNU_BTN_MPG_M.USE_YN 은 노출 판정에 쓰이지 않는다 — 권한 SP
    //   PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH 가 그 테이블을 조인조차 하지 않는다(실측 2026-10-07).
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    save: hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  // 일괄입력/삭제 팝업은 확정 Division 이 있어야 후보를 조회한다(팝업 Div 초기값·POPUP SP 필수 IN).
  //   Division 콤보가 비면(R1 권한 0건) 기본선택도 못 되므로 이 조건이 조회영역 noAuth 게이트를 함께 흡수한다.
  const noDivision = !safeString(sc.divisionId).trim();

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentLotSizeForm
          onSearch={handleSearch}
          onItemSearch={() => setItemModalOpen(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentLotSize'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        // btnInput/btnDelete(R5/R6) — BtnArea 우측 버튼. 툴바 Insert(no-op)/Delete(remove-new)와 별개 어포던스.
        customButtons={[
          {
            label: t(LBL.INPUT, '_Input'),
            action: () => setBatchMode('I'),
            disabled: noDivision,
          },
          {
            label: t(LBL.DELETE, '_Delete'),
            action: () => setBatchMode('D'),
            disabled: noDivision,
          },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ShipmentLotSizeGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          canEdit={canEdit}
          invalidCells={invalidCells}
          onFocus={() => undefined}
        />
      </div>

      {/* Model/Nickname 조회조건 팝업 — MaterialByDivisionModal(COM0013).
          주의: 이 배선은 AS-IS 파리티가 아니라 의도적 이탈이다(사용자 지시 2026-10-08).
          AS-IS 는 `new SCM0002_ItembyDivisionPopup()` (cs:245) + `Form_Load(true, division,
          sScmSite="", sProject="", sItemId)` (cs:247) 로, 규약상 TO-BE 1:1 은 ModelByDivisionPopup
          (menuId SCM0002 / sheet ModelPopup → PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)이다.
          여기서 쓰는 COM0013 은 조회 SP 가 PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION 로 달라
          후보 목록·그리드 컬럼이 AS-IS 와 다르다 — 사용자가 그 차이를 알고 선택했다.
          되돌리려면 ModelByDivisionPopup + params{divisionId/scmSiteId:''/projectCode:''/itemId} 다.
          이력: COM0008(ItemByDivisionModal) → ModelByDivisionPopup(사용자 지적 2026-10-07)
                → MaterialByDivisionModal(COM0013, 사용자 지시 2026-10-08, AS-IS 파리티 포기). */}
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        // AS-IS Form_Load 첫 인자 bMultiSelect=true (cs:247) — 체크 다중선택, 반환은 ','-join.
        //   받은 'A,B' 는 GET SP 의 콤마 목록 조건(body 350~351 INSTR)이 그대로 처리한다.
        multiCheckbox
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          // 빈값 고정 — 팝업은 operationGroup 을 disabled 표시 후 조회 SP 에 그대로 싣는다.
          //   조회조건 sc.operationGroup 은 미선택 시 'ALL' 센티널이라 그대로 넘기면 SP 가 코드값
          //   'ALL' 로 필터해 0건이 된다. 공용 호출 규약(자매 SCP 화면 전부)도 빈값이다.
          operationGroup: '',
          itemId: sc.itemId,
        }}
        // AS-IS cs:253 `if (popItem.ItemID != "")` — 빈 선택이면 기존 입력을 덮지 않는다.
        //   COM0013 이 함께 주는 itemName/className/nickName 은 이 화면이 쓰지 않는다(값=ITEM_ID).
        setSelectedValue={items => {
          if (items) setSearchCondition({ itemId: items });
        }}
      />

      {/* 일괄입력/삭제 팝업 — SCM0002_ShipmentLotSizePopup (design 01 R5/R6) */}
      <ShipmentLotSizeBatchModal
        open={batchMode !== null}
        mode={batchMode ?? 'I'}
        divisionId={sc.divisionId}
        onClose={() => setBatchMode(null)}
        onConfirm={picked =>
          batchMode === 'D' ? handleBatchDeleteConfirm(picked) : void handleBatchInputConfirm(picked)
        }
      />
    </>
  );
};
