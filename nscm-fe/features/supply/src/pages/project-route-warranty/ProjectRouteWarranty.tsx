import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ModelByDivisionPopup } from 'features/master/src/components';
import type { ModelSelection } from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ProjectRouteWarrantyForm } from './components/ProjectRouteWarrantyForm';
import { ProjectRouteWarrantyGrid } from './components/ProjectRouteWarrantyGrid';
import { useProjectRouteWarrantyValidation } from './hooks/useProjectRouteWarrantyValidation';
import {
  INSERT_BLOCKED_OPERATION_GROUPS,
  isSalesSitePopupDivision,
  MENU_ID,
  MSG,
  SAVE_VALIDATION_FALLBACK,
  NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
  NEW_ROW_DEFAULT_PRIORITY,
  NEW_ROW_DEFAULT_PROJECT_CODE,
  NEW_ROW_DEFAULT_SCM_SITE_ID,
  NEW_ROW_DEFAULT_VALID_YN,
  OPERATION_GROUP_WARRANTY,
  RESPONSE_SET,
  stripNoValuePlaceholder,
  SHEETS,
} from './project-route-warranty.constants';
import type { MainRow } from './project-route-warranty.types';
import { useProjectRouteWarrantyStore } from './useProjectRouteWarrantyStore';
import { toGridDate } from './utils/projectRouteWarranty.date';
import { submitWarrantySaveRequest } from './utils/projectRouteWarranty.saveRequest';

export const ProjectRouteWarranty = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);

  const gridRef = useRef<FlexGrid<MainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<MainRow>>();

  const initialized = useProjectRouteWarrantyStore(s => s.initialized);
  const filters = useProjectRouteWarrantyStore(s => s.filters);
  const searchParams = useProjectRouteWarrantyStore(s => s.searchParams);
  const staticColumns = useProjectRouteWarrantyStore(s => s.staticColumns);
  const openSearchArea = useProjectRouteWarrantyStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRouteWarrantyStore(s => s.setOpenSearchArea);
  const setFilters = useProjectRouteWarrantyStore(s => s.setFilters);
  const fetchStaticColumns = useProjectRouteWarrantyStore(s => s.fetchStaticColumns);
  const reset = useProjectRouteWarrantyStore(s => s.reset);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateWarrantySave } = useProjectRouteWarrantyValidation();
  const { saveWithValidation } = useSaveWithValidation();

  // 편집 권한 — mount 1회 판정. AS-IS Edit 잠금 토글은 미채용: 권한 있으면 조회 직후 바로 편집.
  //   주의: 이 화면 AS-IS 의 EditButton 은 SwitchLock() 순수 클라 잠금토글(Roslyn 실측 sps=[],
  //   Auth/Permission/MnuBtn 검사 0건)이라 권한 개념이 아니었고, DB(SCM_ADM_MNU_BTN_MPG_M)에도
  //   EDIT 버튼이 없다 — SEARCH/INSERT/DELETE/SAVE/EXCEL 만 등록됨(실측 2026-09-30). 그래서
  //   convert-core §2.4 의 hasButton('EDIT') 게이트를 그대로 쓰면 canEdit 이 항상 false 라
  //   Insert/Save/Delete 가 전부 dead 가 된다. 편집 가부는 실제 등록된 편집계 권한(INSERT 또는
  //   SAVE)으로 판정한다(사용자 결정 2026-09-30).
  const canEdit = hasButton('INSERT') || hasButton('SAVE');

  // ITEM_ID / Sales Site 셀 팝업(R-D6/R-D8). 어느 행·어느 용도로 열렸는지 추적한다.
  //   AS-IS 는 셀마다 다른 팝업을 연다: ITEM_ID → SCM0002_ItembyDivisionPopup(.cs:749),
  //   div=81 SCM_SITE_ID/PROJECT_CODE → SCP0048_ItembyDivisionPopupEx(.cs:777). TO-BE 도 이에 맞춰
  //   Model=ModelByDivisionPopup(SCM0002/ModelPopup), SalesSite=ItemByDivisionModal(COM0008)로 가른다.
  //   팝업은 둘이지만 열림 상태는 이 mode 하나로 관리한다(동시에 하나만 열린다).
  const [popupTarget, setPopupTarget] = useState<{
    row: MainRow;
    mode: 'item' | 'salesSite';
  } | null>(null);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // 참조 고정 필수: 이 배열이 그대로 DataGrid itemsSource 로 간다. useMemo 없이 매 렌더 새 배열을
  //   만들면, 셀 팝업 열기(setPopupTarget) 같은 리렌더마다 itemsSource 참조가 바뀌어 wijmo 가
  //   CollectionView 를 통째로 교체한다 → 그리드에 addRow 로 추가한 신규행이 사라진다
  //   (Model 더블클릭 시 "추가한 행이 사라짐" 증상). 자매 화면 outsourcing-capacity 와 동일 처방.
  //   FROM/TO_YYYYMMDD 는 Date 로 변환해 FPDate 달력 편집과 YYYY-MM-DD 표시가 성립하게 한다
  //   (ProjectRouteWarrantyGrid dataType=Date 와 짝, precede-safety-stock-day 패턴). 저장/검증은
  //   toYmd8 로 Date·문자열을 'YYYYMMDD' 8자리로 재정규화한다.
  const mainRows = useMemo<MainRow[]>(
    () =>
      (mainData?.[RESPONSE_SET.MAIN] ?? []).map(row => ({
        ...row,
        FROM_YYYYMMDD: toGridDate(row.FROM_YYYYMMDD) as unknown as string,
        TO_YYYYMMDD: toGridDate(row.TO_YYYYMMDD) as unknown as string,
      })),
    [mainData]
  );

  // mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) + F10 자가복구. reset()→initState() 가
  //   staticColumns 를 [] 로 비우고 initialized=false 로 돌리므로(컬럼 메타는 조회조건이 아니라
  //   admin 메타라 F10 초기화 대상이 아님), 컬럼 length 를 dep 에 넣어 비는 즉시 재조회한다
  //   (자매 SCP0039 master-validation 패턴). fetchStaticColumns 가 GET await 전에 initialized 를
  //   선점해 length 0→N 재실행 시 2중 복원을 막는다.
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId, staticColumns[RESPONSE_SET.MAIN].length]);

  // Search(F5) — filters 커밋 + 컬럼 메타 재조회. (편집모드 토글 미채용이라 조회 후 해제 단계 없음.)
  const handleSearch = useCallback(() => {
    setFilters();
    void fetchStaticColumns();
  }, [setFilters, fetchStaticColumns]);

  // Insert(design/03 §4.1) — Warranty 화면이라 opGroup∈{P,A} 신규행은 무언 차단(Insert 가드).
  //   신규행 기본값 세팅. DIVISION_ID 는 조회조건 division(len!=2 → "")으로 채운다.
  const handleInsert = () => {
    if (!canEdit) return;
    const blocked: readonly string[] = INSERT_BLOCKED_OPERATION_GROUPS;
    if (blocked.includes(searchParams.operationGroup)) return;
    const grid = gridRef.current;
    if (!grid) return;
    const div = searchParams.divisionId.length === 2 ? searchParams.divisionId : '';
    GridAction.addRow(grid, {
      DIVISION_ID: div,
      OPERATION_GROUP: OPERATION_GROUP_WARRANTY,
      OPERATION_GROUP_NAME: NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
      VALID_YN: NEW_ROW_DEFAULT_VALID_YN,
      SCM_SITE_ID: NEW_ROW_DEFAULT_SCM_SITE_ID,
      PROJECT_CODE: NEW_ROW_DEFAULT_PROJECT_CODE,
      PRIORITY: NEW_ROW_DEFAULT_PRIORITY,
    });
  };

  // Delete(design/03 R-G1) — 신규행('I')만 removeRow. 기존행은 무반응(alert 없음).
  const handleDelete = () => {
    const grid = gridRef.current;
    const sel = grid?.selectedItems?.[0] as MainRow | undefined;
    if (!grid || !sel || sel.CRUD_TYPE !== 'I') return;
    GridAction.removeRow(grid);
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3.4). dataItem 참조로 식별해 grid.formatItem 이 스크롤·
  //   재도색 때마다 다시 칠하도록 상태로 보관한다(뷰행 index DOM 직접칠은 스크롤 시 재활용돼 어긋난다).
  const [invalidCells, setInvalidCells] = useState<{ row: MainRow; column: string }[]>([]);

  // 실제 SAVE 호출(payload 조립 + false-success 판별). saveWithValidation 메타 필수검증 통과 후 호출.
  const submitSave = async (changed: MainRow[]) => {
    const result = await submitWarrantySaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({
        type: 'alert',
        content: result.message ?? t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
    editTrackerRef.current?.clearChanges();
    handleSearch();
  };

  // 커스텀 N1~N11 검증 후 실제 SAVE. 표준 필수검증(saveWithValidation) 통과 뒤에만 호출된다.
  //   AS-IS 는 표준 필수(checkRequiredOfSpread, cs:522)를 먼저 돌리고 그 다음 N1~N11(cs:531~)을
  //   돈다. TO-BE 도 그 순서를 지켜 빈 필수컬럼(Div/Model/Plant 등)은 표준검증이 "[항목] 입력하세요"
  //   로 먼저 안내하고, 그걸 통과한 뒤에야 N1~N11 업무규칙을 검사한다. 이렇게 해야 FROM/TO 공백이
  //   N8-a(silent)에 먼저 걸려 다른 필수 미입력까지 통째로 무언 차단되던 문제가 사라진다.
  const runCustomValidationThenSubmit = (source: MainRow[], changed: MainRow[]) => {
    const v = validateWarrantySave(source);
    if (!v.ok) {
      setInvalidCells(v.invalidCells);
      // 사용자 결정(2026-10-19): TO-BE 는 silent 분기도 안내 메시지를 띄운다. AS-IS N8-a 무언 차단은
      //   표준 필수검증이 FROM/TO(둘 다 M) 공백을 먼저 잡으므로 여기까지 공백으로 도달하지 않는다.
      //   혹시 남는 silent 케이스는 공통 검증실패 문구로 안내한다(무반응 방지).
      const msgId = v.msgId ?? MSG.SAVE_ERROR;
      const text = t(msgId, SAVE_VALIDATION_FALLBACK[msgId] ?? '_저장 검증 실패');
      void setAlert({
        type: 'alert',
        // msgArg 가 있으면 문구의 {0} 를 항목명으로 치환(N10 "[Sales Site Code, Project] 값은 필수…").
        content: v.msgArg ? text.replace('{0}', `[${v.msgArg}]`) : text,
      });
      return;
    }
    // 검증 통과 → 이전 하이라이트 제거 후 저장.
    setInvalidCells([]);
    void submitSave(changed);
  };

  // Save(design/03 §4.3) — 표준 필수검증 → 커스텀 N1~N11 → ^-delim CLOB SAVE.
  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as MainRow[];
    const changed = source.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // 표준 메타 필수검증(Div/Model/Plant/Priority/FROM/TO/Valid)이 먼저. 통과한 경우에만
    //   콜백에서 커스텀 N1~N11 을 돌려 저장한다(AS-IS cs:522 → cs:531 순서).
    saveWithValidation(changed, staticColumns[RESPONSE_SET.MAIN], () =>
      runCustomValidationThenSubmit(source, changed)
    );
  };

  // Reset Condition(F10) — 공용 동작(검색조건 삭제 + store initState). SCP0048 은 보존할 기간
  //   조건이 없어 기본 reset 을 그대로 쓴다.
  const handleResetCondition = () => {
    void (async () => {
      if (
        await setAlert({
          type: 'confirm',
          content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
        })
      ) {
        await GridAction.resetPersonalizedCondition(MENU_ID).then(() => {
          void setAlert({ type: 'alert', content: t('MSG00011', '_검색조건이 초기화 되었습니다.') });
          reset();
        });
      }
    })();
  };

  const handleExcelDownload = () => {
    const grid = gridRef.current;
    if (!grid) return;
    void GridAction.excelDownload(grid, 'ProjectRouteWarranty', setProgress);
  };

  // ITEM_ID 셀 더블클릭 → Item 팝업(R-D8). division 공백이면 MSG00093(R-G4).
  const handleItemCellDblClick = (row: MainRow) => {
    if (!String(row.DIVISION_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
      });
      return;
    }
    setPopupTarget({ row, mode: 'item' });
  };

  // div=81 SCM_SITE_ID/PROJECT_CODE 셀 더블클릭 → SalesSite 팝업(R-D6). AS-IS(cs:760-793)는 신규행
  //   (action=='I')·division=='81' 에서 SCP0048_ItembyDivisionPopupEx 를 열어 SCM_SITE_ID/PROJECT_CODE
  //   를 되돌려 받는다. Ex 팝업은 COM0008 백엔드라 base ItemByDivisionModal 을 mode='salesSite' 로 재사용한다.
  const handleSalesSiteCellDblClick = (row: MainRow) => {
    if (!isSalesSitePopupDivision(String(row.DIVISION_ID ?? ''))) return;
    if (!String(row.DIVISION_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
      });
      return;
    }
    setPopupTarget({ row, mode: 'salesSite' });
  };

  // ITEM_ID 팝업 확정 — 선택 품번을 해당 행에 반영(.toUpperCase). NICK_NAME(R-D2)은 팝업이 실어 준
  //   nickName 을 즉시 반영한다. AS-IS(.cs:759·844-864)는 팝업이 ITEM_ID 만 되쓰고, 그 변경이
  //   spdMain_Change 를 발화시켜 dsItemBinding 조회로 NICK_NAME 을 즉시 표시한다 — TO-BE 는 팝업
  //   응답(o_rc1)의 NICK_NAME 을 바로 받아 같은 결과를 낸다. 저장 SP 도 FN_GET_ITEM_NICKNAME 로
  //   재계산하지만, 화면 표시 지연을 없애기 위해 클라에서도 파생한다.
  const handleItemSelected = (itemId: string, nickName?: string) => {
    const target = popupTarget;
    setPopupTarget(null);
    const grid = gridRef.current;
    if (!target || target.mode !== 'item' || !grid) return;
    const row = target.row;
    const rec = row as Record<string, unknown>;
    const next = itemId.toUpperCase();
    editTrackerRef.current?.storeChange(row, 'ITEM_ID', rec.ITEM_ID as string, next);
    rec.ITEM_ID = next;
    if (nickName !== undefined) {
      editTrackerRef.current?.storeChange(row, 'NICK_NAME', rec.NICK_NAME as string, nickName);
      rec.NICK_NAME = nickName;
    }
    grid.collectionView?.refresh();
  };

  // Sales Site 팝업 확정(div=81) — AS-IS(cs:788-789) siMain.SetText(SCM_SITE_ID, popItem.ScmSiteId)
  //   + SetText(PROJECT_CODE, popItem.Project). 두 셀을 한 번에 반영한다.
  const handleSalesSiteSelected = (scmSiteId?: string, projectCode?: string) => {
    const target = popupTarget;
    setPopupTarget(null);
    const grid = gridRef.current;
    if (!target || target.mode !== 'salesSite' || !grid) return;
    const row = target.row;
    const rec = row as Record<string, unknown>;
    if (scmSiteId !== undefined) {
      editTrackerRef.current?.storeChange(row, 'SCM_SITE_ID', rec.SCM_SITE_ID as string, scmSiteId);
      rec.SCM_SITE_ID = scmSiteId;
    }
    if (projectCode !== undefined) {
      editTrackerRef.current?.storeChange(
        row,
        'PROJECT_CODE',
        rec.PROJECT_CODE as string,
        projectCode
      );
      rec.PROJECT_CODE = projectCode;
    }
    grid.collectionView?.refresh();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: canEdit && hasButton('INSERT') ? handleInsert : false,
    save: canEdit && hasButton('SAVE') ? handleSave : false,
    delete: canEdit && hasButton('DELETE') ? handleDelete : false,
    resetCondition: handleResetCondition,
    excel: handleExcelDownload,
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
      {openSearchArea && <ProjectRouteWarrantyForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ProjectRouteWarranty'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <ProjectRouteWarrantyGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={mainRows}
        staticColumns={staticColumns[RESPONSE_SET.MAIN]}
        invalidCells={invalidCells}
        onItemCellDblClick={handleItemCellDblClick}
        onSalesSiteCellDblClick={handleSalesSiteCellDblClick}
        divisionId={searchParams.divisionId}
      />

      {/* Model(ITEM_ID) 셀 팝업 — ModelByDivisionPopup(SCM0002/ModelPopup). AS-IS(.cs:749
          SCM0002_ItembyDivisionPopup)와 동일 백엔드다. AS-IS Form_Load(false, division, "", "", itemId)
          처럼 division/itemId 만 실어 좁힌다(scmSite/project 는 비움 → 팝업이 'ALL' 보정). */}
      <ModelByDivisionPopup
        open={popupTarget?.mode === 'item'}
        onClose={() => setPopupTarget(null)}
        onSelect={(selected: ModelSelection) => handleItemSelected(selected.itemId, selected.nickName)}
        params={{
          divisionId: String(popupTarget?.row.DIVISION_ID ?? ''),
          itemId: String(popupTarget?.row.ITEM_ID ?? ''),
        }}
      />

      {/* Sales Site(div=81) 셀 팝업 — base ItemByDivisionModal(COM0008). AS-IS Ex 팝업
          (SCP0048_ItembyDivisionPopupEx)과 동일 백엔드로 SCM_SITE_ID+PROJECT_CODE 를 되돌려 받는다. */}
      <ItemByDivisionModal
        open={popupTarget?.mode === 'salesSite'}
        modalClose={() => setPopupTarget(null)}
        setSelectedValue={(_items, _n, _c, _nickName, _t, _d, _dn, _ec, scmSiteId, projectCode) => {
          handleSalesSiteSelected(scmSiteId, projectCode);
        }}
        preSearchParams={{
          divisionId: String(popupTarget?.row.DIVISION_ID ?? ''),
          // Sales Site 호출은 AS-IS(cs:779)처럼 행의 SCM_SITE_ID/PROJECT_CODE(없는 값 표식 제거)·ITEM_ID 를
          //   실어 좁힌다. placeholder('/'·기존 '-')는 stripNoValuePlaceholder 로 빼 조회가 0건이 되지 않게 한다.
          salesSite: stripNoValuePlaceholder(popupTarget?.row.SCM_SITE_ID),
          projectCode: stripNoValuePlaceholder(popupTarget?.row.PROJECT_CODE),
          itemId: String(popupTarget?.row.ITEM_ID ?? ''),
        }}
        callFromCell
      />
    </>
  );
};
