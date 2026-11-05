import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ExcelUploadModal } from './components/modals/ExcelUploadModal';
import { OspStockGrid } from './components/OspStockGrid';
import { PackHoldStockGrid } from './components/PackHoldStockGrid';
import { StockOspForm } from './components/StockOspForm';
import { useStockOspValidation } from './hooks/useStockOspValidation';
import {
  ADMIN_SHEET_NAME,
  EXCEL_FORM_HEADER,
  LBL,
  MENU_ID,
  MSG,
  PACK_DASH_DATE_COLUMNS,
  RESPONSE_KEY,
  SHEETS,
  TAB_INDEX,
} from './stock-osp.constants';
import type { OspStockRow, PackHoldStockRow } from './stock-osp.types';
import styles from './StockOspPage.module.scss';
import { useStockOspStore } from './useStockOspStore';
import { isHoldRow } from './utils/stock-osp.editLock';
import { buildSavePayload, callSavePack } from './utils/stock-osp.save';

// 날짜값(YYYYMMDD / YYYY-MM-DD HH:mm:ss 등) → 'YYYY-MM-DD'. 8자리가 안 되면 원값 유지.
const toDashDate = (v: unknown): unknown => {
  const raw = typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
  const d = raw.replace(/[^0-9]/g, '').slice(0, 8);
  return d.length === 8 ? `${d.slice(0, 4)}-${d.slice(4, 6)}-${d.slice(6, 8)}` : v;
};

// AS-IS GSCM.SCP.Forms.UIL SCP0041_StockOSP — 2 시트(Osp Stock 조회 / Pack Hold Stock HOLD행 편집).
//   설계: .atlas/gscm-design/SCP0041/design/00~03 · convert-flow/{goal,plan}.md. 매핑: __asis-mapping__.md.
//   NSCM 표준: 그리드 상시 편집(Edit 토글 미이식, convert-core §2.1(11)) — Pack DIR='HOLD' 행만 조건부 편집.
//   저장은 Pack 전용(P_SCP0041_SAVE_PACKER_HOLD_STOCK, action='M'). Osp 는 조회+Excel Upload 만(INSERT/DELETE 없음).
export const StockOspPage = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const userId = useSessionStore.getState().session.userId ?? '';
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { isReversed, validateBeforeSave } = useStockOspValidation();

  // 탭별 그리드 ref (hook #97 — 공통 버튼은 활성 탭 그리드로 라우팅).
  const ospGridRef = useRef<FlexGrid>();
  const packGridRef = useRef<FlexGrid>();
  const ospFilterRef = useRef<FlexGridFilter>();
  const packFilterRef = useRef<FlexGridFilter>();
  const ospTrackerRef = useRef<EditTracker>();
  const packTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);

  const sc = useStockOspStore(s => s.searchCondition);
  const setSearchCondition = useStockOspStore(s => s.setSearchCondition);
  const filters = useStockOspStore(s => s.filters);
  const setFilter = useStockOspStore(s => s.setFilter);
  const clearFilters = useStockOspStore(s => s.clearFilters);
  const openSearchArea = useStockOspStore(s => s.openSearchArea);
  const setOpenSearchArea = useStockOspStore(s => s.setOpenSearchArea);
  const activeTab = useStockOspStore(s => s.activeTab);
  const setActiveTab = useStockOspStore(s => s.setActiveTab);
  const staticColumns = useStockOspStore(s => s.staticColumns);
  const fetchStaticColumns = useStockOspStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = useStockOspStore(s => s.restoreSearchConditions);
  const initialized = useStockOspStore(s => s.initialized);

  const isPack = activeTab === TAB_INDEX.PACK;
  const activeSheet = isPack ? SHEETS.PACK : SHEETS.OSP;

  const [openItem, setOpenItem] = useState(false);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  // Division 권한 게이트(null=로딩). false 면 조회 차단(design 02 §6-8).
  const [divisionAuth, setDivisionAuth] = useState<boolean | null>(null);

  const { data: ospData } = useTabProcQuery<MENU_ID, SHEETS.OSP>({
    menuId: MENU_ID,
    sheetName: SHEETS.OSP,
    tabId,
    filters: filters[SHEETS.OSP],
    enabled: !!filters[SHEETS.OSP],
  });
  const { data: packData, refetch: refetchPack } = useTabProcQuery<MENU_ID, SHEETS.PACK>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACK,
    tabId,
    filters: filters[SHEETS.PACK],
    enabled: !!filters[SHEETS.PACK],
  });

  const ospRows = useMemo<OspStockRow[]>(() => ospData?.[RESPONSE_KEY] ?? [], [ospData]);
  // Pack 날짜 3컬럼은 YYYY-MM-DD 문자열로 맞춰 그리드 표시와 엑셀이 같은 값을 쓰게 한다(저장은 toYmd 로 8자리 변환).
  const packRows = useMemo<PackHoldStockRow[]>(
    () =>
      (packData?.[RESPONSE_KEY] ?? []).map(r => {
        const row = { ...r } as Record<string, unknown>;
        for (const key of PACK_DASH_DATE_COLUMNS) row[key] = toDashDate(row[key]);
        return row as PackHoldStockRow;
      }),
    [packData]
  );

  // mount 1회 admin 컬럼 메타 fetch(양 시트) + keep-alive 탭 stale filters 자동발사 방지.
  //   + 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 폼에 적용, 없으면 기본값 유지. 형제 파리티.
  useEffect(() => {
    if (!initialized) void fetchStaticColumns([SHEETS.OSP, SHEETS.PACK]);
    clearFilters();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    if (divisionAuth === false) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    // 활성 탭 시트만 조회(hook #97 — 공통 버튼 활성 탭 라우팅).
    setFilter(activeSheet);
    void fetchStaticColumns([activeSheet]);
  };

  // 탭 전환 — 활성 탭 라우팅. 편집 pending 은 보존(파기 아님). 자동 재조회 없음(Search 버튼만).
  const handleTabChange = (index: number) => {
    setActiveTab(index as TAB_INDEX);
  };

  // R3 역전 원복 후 별도 저장검증 필요 없음(그리드가 값 원복). onReversed 는 alert 만 담당.
  const onReversed = useCallback(() => {
    void setAlert({ type: 'alert', content: t(MSG.DATE_REVERSAL, '_시작일이 종료일보다 클 수 없습니다.') });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 날짜셀 입력형식 무효(달력에 없는 날짜) — 그리드가 커밋 취소, 여기선 alert 만(MSG00611).
  const onInvalidDate = useCallback(() => {
    void setAlert({
      type: 'alert',
      content: t(MSG.INVALID_DATE_FORMAT, '_유효한 날짜 형식이 아닙니다. (YYYYMMDD)'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const doSave = async (dirty: Record<string, unknown>[]) => {
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const payload = buildSavePayload(dirty, userId);
      if (!payload) return;
      const result = await callSavePack(payload);
      if (result.ok) {
        setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '_저장되었습니다.'),
        });
        packTrackerRef.current?.clearChanges();
        // 저장 성공 후 재조회 — filters 불변이라 refetch 직접 호출 허용(nscm-patterns §5 예외).
        void refetchPack();
      } else {
        void setAlert({
          type: 'alert',
          content: result.errorMessage || t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
      }
    } finally {
      savingRef.current = false;
    }
  };

  // Pack 전용 저장(design 03 §3 R4): finishEditing → dirty(CRUD_TYPE) HOLD 행 수집 →
  //   날짜역전 재검증(R4) → 필수값 검증 → '^' bulk 저장(action='M').
  const handleSave = () => {
    const grid = packGridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE && isHoldRow(r));
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // R4 — 저장 직전 날짜역전 재검증(위반 시 alert·중단).
    if (!validateBeforeSave(dirty)) return;
    // 필수 컬럼(메타 M) 검증 통과 후 '^' bulk 저장.
    saveWithValidation(dirty as unknown as PackHoldStockRow[], staticColumns[SHEETS.PACK] ?? [], () => {
      void doSave(dirty);
    });
  };

  // 툴바 — 활성 탭 라우팅(hook #97). SAVE 는 Pack 탭 전용(Osp 는 저장 없음).
  //   INSERT/DELETE/EDIT 는 DB 미등록(01_layout §4-B) — hasButton 으로 일관 게이트(§4 체크#2 미노출도 정합).
  //     hasButton 이 false 이므로 미노출. 등록되면 R4/R5 판정대로 NO-OP(() => undefined)로 노출된다
  //     (키 생략·리터럴 false 금지 — 공용 SubTitle 기본 addRow/removeRow 부활 방지, skill §3).
  //   UPLOAD(Osp Excel Upload, R7)는 공용 upload 훅이 아니라 customButtons + ExcelUploadModal 로 배선한다
  //     (DistributionRoute 선례 — 파일선택 팝업 1-Step). Osp 탭 전용(AS-IS Osp 탭 버튼), hasButton('UPLOAD') 게이트.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: isPack && hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  // Excel 양식 다운로드(Osp Stock 탭 전용) — AS-IS MenuEtcFileDownButton("StockOSP_ExcelForm.xls") 대체.
  //   양식 헤더가 고정(SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 실측)이라 서버 조회 없이 클라에서 생성한다
  //   (flat 업로드 — pivot GET_EXCEL_FORM proc 불요, hook #135 excel-form-upload-standard). 헤더만 있는 빈 양식.
  const handleFormDownload = () => {
    const columns = EXCEL_FORM_HEADER.split('|').map(h => ({ header: h, key: h }));
    // void GridAction.flatExcelDownload([], columns, 'StockOsp_ExcelForm');
    // 입력칸을 텍스트 서식으로 — 날짜가 엑셀 날짜로 바뀌어 'TueOct13' 처럼 저장되는 문제 방지.
    void GridAction.flatExcelDownload([], columns, 'StockOsp_ExcelForm', undefined, {
      textColumns: true,
    });
  };

  // Osp 탭 전용 Excel 2종 — Excel Form → Excel Upload 순(hook #135 §6, 정본 DMF0082 배치). 각각 자체 hasButton 게이트:
  //   FORM_DATA(양식 다운로드, API_ID=P_SCP0041_UPLOAD placeholder — 클라 액션이라 FE 미호출) ·
  //   UPLOAD(업로드, API_ID=P_SCP0041_UPLOAD → SP P_SCP0041_STOCK_OSP_EXCEL_UPLOAD). DB 실측 2026-10-14.
  const customButtons = !isPack
    ? [
        ...(hasButton('FORM_DATA')
          ? [
              {
                label: t(LBL.EXCEL_FORM, '_Excel Form'),
                action: handleFormDownload,
                iconComponent: <FileExceldownloadIcon />,
                iconPosition: 'leading' as const,
              },
            ]
          : []),
        ...(hasButton('UPLOAD')
          ? [
              {
                label: t(LBL.EXCEL_UPLOAD, '_Excel Upload'),
                action: () => setOpenExcelUpload(true),
                iconComponent: <FileExceluploadIcon />,
                iconPosition: 'leading' as const,
              },
            ]
          : []),
      ]
    : [];

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <MainTitle
          title={title}
          menuId={MENU_ID}
          openSearchArea={openSearchArea}
          toggleOpenSearchArea={setOpenSearchArea}
        />
        <StockOspForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onDivisionAuth={setDivisionAuth}
        />
        <SubTitle
          menuId={MENU_ID}
          grid={isPack ? packGridRef : ospGridRef}
          gridFilter={isPack ? packFilterRef : ospFilterRef}
          dataCount={isPack ? packRows.length : ospRows.length}
          excelFileName='StockOsp'
          useHotkey={true}
          hotkeyConfig={hotkeyConfig}
          customButtons={customButtons}
          searchParam={sc}
        />
      </div>

      <div className={styles.mainContent}>
        <TabWrapper
          persist
          activeTabIndex={activeTab}
          setActiveTabIndex={index => handleTabChange(index)}
        >
          {/* 탭 라벨 = 설계서 시트명(SHT_NM). i18n 코드 미채번 — 임의 채번 금지(hook #114). */}
          <TabItem label='Osp Stock'>
            <OspStockGrid
              rows={ospRows}
              gridRef={ospGridRef}
              gridFilterRef={ospFilterRef}
              editTrackerRef={ospTrackerRef}
              staticColumns={staticColumns[SHEETS.OSP] ?? []}
            />
          </TabItem>
          <TabItem label='Pack Hold Stock'>
            <PackHoldStockGrid
              rows={packRows}
              gridRef={packGridRef}
              gridFilterRef={packFilterRef}
              editTrackerRef={packTrackerRef}
              staticColumns={staticColumns[SHEETS.PACK] ?? []}
              isReversed={isReversed}
              onReversed={onReversed}
              onInvalidDate={onInvalidDate}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* Model/Nickname 돋보기 — 메1 MaterialByDivisionModal(COM0013). 사용자 지시 2026-10-14:
          AS-IS 모3(ItemByDivisionModal COM0008)에서 메1로 교체(Model/Nickname 통합 픽커 패턴, 자매 화면 동일).
          콤마 다중 itemId 반영. scpModuleType=호출 화면 ID(SP Operation Group 분기 기준). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />

      {/* Excel 업로드 팝업(Osp Stock, R7) — 검증(mode=0) 후 onSave(mode=1) 적재, 저장 성공 후 '다시 조회하시겠습니까?'
          Yes 시 Osp 재조회(iter-2 GAP-A / 옵션1). onUploaded 은 refetch 가 아니라 setFilter 로 filters[OSP] 참조를
          새로 만들어 재조회한다 — refetch(동일 queryKey)는 플레이키하게 스킵되지만 setFilter→useLayoutEffect
          removeQueries 경로는 Search 버튼과 동일하게 매번 확정적으로 재요청한다. */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={() => setOpenExcelUpload(false)}
        onUploaded={() => setFilter(SHEETS.OSP)}
        onSave={async () => {
          // PKG_SCP0041.P_SCP0041_STOCK_OSP_EXCEL_UPLOAD(mode=1) — 검증 통과분 DB 원장 반영(2번째 호출).
          //   라우팅 (SCP0041,'Osp Stock',UPLOAD_SAVE) → P_SCP0041_UPLOAD → 업로드 SP (SCM_ADM_MNU_BTN_MPG_M·
          //   SCM_ADM_API_M 실측 2026-10-14, USE_YN='Y'). P_CREATED_BY=세션 = mode=0 스테이징 키와 동일.
          try {
            const res = await apiClient.post<Record<string, unknown>>(
              `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.OSP]}/UPLOAD_SAVE/call-proc`,
              {
                mode: 1,
                createdBy: userId,
                programId: MENU_ID,
                sheetName: ADMIN_SHEET_NAME[SHEETS.OSP],
              }
            );
            const code = Number((res.data as { code?: string })?.code ?? 0);
            const inner = (
              res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] }
            )?.o_result_cursor?.[0];
            // SP 반환 CODE!='0' = 실패(전량 게이트 위반 등) — MSG passthrough
            if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
              return { ok: false, message: inner?.MSG || (res.data as { message?: string })?.message };
            }
            return { ok: true };
          } catch (e) {
            return { ok: false, message: e instanceof Error ? e.message : undefined };
          }
        }}
      />
    </div>
  );
};
