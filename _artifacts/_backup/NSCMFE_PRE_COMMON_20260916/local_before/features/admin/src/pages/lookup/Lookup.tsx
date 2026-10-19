import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

// import { apiClient } from '@foundation/apis'; // AFTER_SAVE 호출 비활성과 함께 주석 (mutateDetail.onSuccess 참고)
import _ from '@foundation/lodash';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { LookupDetailGrid } from './components/LookupDetailGrid';
import { LookupForm } from './components/LookupForm';
import { LookupMasterGrid } from './components/LookupMasterGrid';
import type { RESPONSE_SET } from './lookup.constants';
import { MENU_ID, SHEETS } from './lookup.constants';
import styles from './Lookup.module.scss';
import {
  EMPTY_LOOKUP_DETAIL_ROW,
  EMPTY_LOOKUP_MASTER_ROW,
  findDuplicateDetailRow,
  findDuplicateMasterRow,
  pickSaveTarget,
  toDetailSaveRow,
} from './lookup.utils';
import { useLookupStore } from './useLookupStore';

export const Lookup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const masterGridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>>>();
  const masterGridFilterRef = useRef<FlexGridFilter>();
  const detailGridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>>>();
  const detailGridFilterRef = useRef<FlexGridFilter>();
  // 저장 시 세그먼트 원본값(UPDATE 키)을 읽기 위해 detail 그리드의 EditTracker 를 화면이 보관한다.
  const detailEditTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>>>();

  const filters = useLookupStore(state => state.filters);
  const searchParams = useLookupStore(state => state.searchParams);
  const isOpenSearchArea = useLookupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useLookupStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useLookupStore(state => state.fetchStaticColumns);
  const activeGrid = useLookupStore(state => state.activeGrid);
  const setFilters = useLookupStore(state => state.setFilters);
  const clearDetail = useLookupStore(state => state.clearDetail);
  const selectedLookupType = useLookupStore(state => state.selectedLookupType);
  const masterStaticColumns = useLookupStore(state => state.staticColumns.lookupMaster);
  const detailStaticColumns = useLookupStore(state => state.staticColumns.lookupDetail);

  const { saveWithValidation } = useSaveWithValidation();
  const queryClient = useQueryClient();
  const setToast = useMessageStore(state => state.setToast);

  const { data: masterData, refetch: refetchMaster } = useTabProcQuery<
    MENU_ID,
    SHEETS.LOOKUP_MASTER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
    filters: filters[SHEETS.LOOKUP_MASTER],
    enabled: !!filters[SHEETS.LOOKUP_MASTER],
  });

  const { data: detailData } = useTabProcQuery<MENU_ID, SHEETS.LOOKUP_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    filters: filters[SHEETS.LOOKUP_DETAIL],
    enabled: !!filters[SHEETS.LOOKUP_DETAIL],
  });

  const { mutate: mutateMaster } = useProcMutation<
    MENU_ID,
    SHEETS.LOOKUP_MASTER,
    RESPONSE_SET.SAVE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
  });

  const { mutate: mutateDetail } = useProcMutation<
    MENU_ID,
    SHEETS.LOOKUP_DETAIL,
    RESPONSE_SET.SAVE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    onSuccess: () => {
      // 저장 후처리(AS-IS SCM0003_AFTER_LOOKUP_MASTER_DETAIL) 호출 — 2026-08-28 비활성.
      //
      // 부를 대상이 DB 에 없다. 세 군데를 확인했다.
      //   ALL_OBJECTS OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%AFTER%LOOKUP%'  -> 0건
      //   SCM_ADM_MNU_BTN_MPG_M       MNU_ID='SYS0010'                       -> AFTER_SAVE 행 없음
      //   SCM_ADM_USER_GR_MNU_BTN_MPG_M MNU_ID='SYS0010'                     -> AFTER_SAVE 행 없음
      // 그래서 저장할 때마다 403 만 찍혔다. 권한을 줘도 프로시저가 없어 500 이 된다.
      //
      // 되살릴 값어치도 확인되지 않았다. AS-IS 는 이 SP 본문의 비즈니스 로직이 2025-02-10 에
      // 전부 주석 처리됐고, 같은 SP 를 부르던 SCP0120 은 호출 자체를 주석 처리해 뒀다.
      // 남는 동작이 배치 로그뿐이라 파리티상 잃는 것이 없다.
      //
      // 되살릴 때 함께 맞춰야 하는 것 (근거: __asis-mapping__.md §2):
      //   1. 메타 3종 등록 — SCM_ADM_MNU_BTN_MPG_M -> SCM_ADM_API_M -> SCM_ADM_PROC_M
      //   2. SAVE 권한이 있는 그룹 전부에 AFTER_SAVE 권한 부여
      //   3. 파라미터 이름 — BE makeProcedure 는 SCM_ADM_PROC_M.COL_NM 을 키로 body 에서 값을
      //      꺼내므로 이름이 어긋나면 예외 없이 null 이 들어간다. 사용자 ID 가 필요하면
      //      COL_NM 을 sesUserId 로 등록한다 (DAO 가 세션에서 자동 주입).
      //   4. p_program_id 는 AS-IS 가 'SCM0103' 고정 — 아래 코드의 MENU_ID('SYS0010') 와 다르다.
      //      SP 가 program_id 로 분기하면 다른 갈래를 탄다.
      //
      // void apiClient
      //   .post(`/${MENU_ID}/${SHEETS.LOOKUP_DETAIL}/AFTER_SAVE/call-proc`, {
      //     programId: MENU_ID,
      //     sheetName: selectedLookupType ?? '',
      //     debugMode: 'F',
      //   })
      //   .catch(() => {
      //     /* AS-IS DoAfterSave 빈 catch 정합 — non-blocking */
      //   });

      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    },
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const handleSubmit = () => {
    const next = { ...searchParams };
    if (_.isEqual(next, filters[SHEETS.LOOKUP_MASTER])) void refetchMaster();
    else setFilters();
    // 조회 시 하단 detail 그리드는 항상 clear (재조회 분기에서도 비워지도록)
    clearDetail();
    // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch (admin 변경 즉시 반영)
    void fetchStaticColumns();
  };

  const onInsert = () => {
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      if (!selectedLookupType) {
        void setAlert({
          type: 'alert',
          content: t('MSG00624', 'Please select a Lookup Type first.'),
        });
        return;
      }
      GridAction.addRow(detailGridRef.current, {
        ...EMPTY_LOOKUP_DETAIL_ROW,
        LOOKUP_TYPE: selectedLookupType,
        CRUD_TYPE: 'I',
      });
      return;
    }
    if (!masterGridRef.current) return;
    GridAction.addRow(masterGridRef.current, {
      ...EMPTY_LOOKUP_MASTER_ROW,
      LOOKUP_GROUP: filters[SHEETS.LOOKUP_MASTER]?.lookupGroup,
      CRUD_TYPE: 'I',
    });
  };

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 항목 비활성은 VALID_YN='N' 으로 처리).
  const onDelete = () => {
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      GridAction.removeRow(detailGridRef.current, true);
      return;
    }
    if (!masterGridRef.current) return;
    GridAction.removeRow(masterGridRef.current, true);
  };

  const alertDuplicate = () => {
    void setAlert({ type: 'alert', content: t('MSG00060', '_동일한 {0}이(가) 존재합니다.') });
  };

  const saveMaster = (rows: ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>[]) => {
    if (findDuplicateMasterRow(rows)) return alertDuplicate();
    // 상단은 UPDATE 키(LOOKUP_TYPE_KEY)를 조회 SP 가 LOOKUP_TYPE AS LOOKUP_TYPE_KEY 로 함께
    // 내려준다. 그래서 응답 행을 그대로 보내면 개명한 행도 원래 이름으로 대상을 찾는다 —
    // 하단(SEGMENT1_KEY~5)과 달리 화면이 키를 만들지 않는다.
    saveWithValidation(rows, masterStaticColumns, mutateMaster);
  };

  const saveDetail = (rows: ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>[]) => {
    if (findDuplicateDetailRow(rows)) return alertDuplicate();
    // 세그먼트를 수정한 행도 원래 값으로 대상을 찾도록 SEGMENT1_KEY~5 를 함께 싣는다.
    const originalValues = detailEditTrackerRef.current?.getOriginalValues();
    saveWithValidation(
      rows.map(row => toDetailSaveRow(row, originalValues?.get(row))),
      detailStaticColumns,
      mutateDetail
    );
  };

  /**
   * 저장 대상은 포커스가 아니라 **변경분이 있는 영역**으로 정한다.
   *
   * 종전에는 activeGrid(마지막으로 포커스가 갔던 그리드)만 봤다. 그래서 하단에 행을 넣은 뒤
   * 상단을 한 번 클릭하고 저장하면 상단이 대상이 되어, 상단에 변경이 없으면
   * "수정한 내용이 없습니다"가 뜨고 하단 신규행은 조용히 남았다. 상단에 변경이 있었다면
   * 상단만 저장되고 하단이 남는, 더 알아채기 어려운 쪽으로 흘렀다.
   *
   * 판정 기준인 CRUD_TYPE 은 그리드 행 앞의 상태 표시(I/M/D)와 같은 값이라, 화면에 표시가
   * 보이는 영역이 곧 저장 대상이 된다.
   *
   * 양쪽 다 변경분이 있으면 한 번에 한 영역만 저장되므로(SP 가 시트별로 갈린다) 포커스가 있는
   * 쪽을 저장하되, 남는 쪽이 있다는 것을 먼저 알린다.
   *
   * 주의: Insert/Delete 는 선택 행에 작용하므로 종전대로 activeGrid 를 따른다. 저장만 다르다.
   */
  const onSave = () => {
    const masterRows = masterData?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
    const detailRows = detailData?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];

    const { target, otherHasChanges } = pickSaveTarget(
      masterRows.length,
      detailRows.length,
      activeGrid
    );
    const run = () => (target === 'sub' ? saveDetail(detailRows) : saveMaster(masterRows));

    if (!otherHasChanges) return run();

    void (async () => {
      // TODO: 전용 MSG ID 등록 필요 — 지금은 코드 없이 fallback 문구만 쓴다.
      const proceed = await setAlert({
        type: 'confirm',
        content: t(
          '',
          '_다른 영역에도 저장하지 않은 변경이 있습니다. 지금 선택한 영역만 저장합니다. 계속할까요?'
        ),
      });
      if (proceed) run();
    })();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: onInsert,
    delete: onDelete,
    save: onSave,
    manual: false,
    upload: false,
  };

  // 건수는 각 영역 제목 줄에 따로 표시한다 — 상단 툴바 줄이 곧 master(Lookup Type) 제목 줄이므로
  // 포커스에 따라 숫자가 바뀌면 제목과 어긋난다. 툴바 동작 대상만 activeGrid 를 따른다.
  const masterCount = masterData?.o_rc?.length ?? 0;
  const detailCount = detailData?.o_rc?.length ?? 0;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <LookupForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={activeGrid === 'sub' ? detailGridRef : masterGridRef}
        gridFilter={activeGrid === 'sub' ? detailGridFilterRef : masterGridFilterRef}
        countGrid={masterGridRef}
        dataCount={masterCount}
        title={t('LBL00636', 'Lookup Type')}
        depth='h4'
        excelFileName='Lookup'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <div className={styles.outerModule}>
        <PanelGroup className={styles.tableWrapper} orientation='vertical'>
          <Panel defaultSize={70} minSize={20}>
            <LookupMasterGrid
              gridRef={masterGridRef}
              gridFilterRef={masterGridFilterRef}
              data={masterData?.o_rc ?? []}
            />
            {/* <div className={styles.masterGrid}>
            </div> */}
          </Panel>
          <PanelSeparator className={styles.splitBar} />
          <Panel defaultSize={30} minSize={15}>
            <div className={styles.innerModule}>
              <TitleArea
                isSubTitle
                title={t('LBL00637', 'Lookup Values')}
                depth='h4'
                totalCases={detailCount === 0 ? undefined : detailCount}
              />
              <LookupDetailGrid
                gridRef={detailGridRef}
                gridFilterRef={detailGridFilterRef}
                editTrackerRef={detailEditTrackerRef}
                data={detailData?.o_rc ?? []}
              />
              {/* <div className={styles.detailGrid}>
              </div> */}
            </div>
          </Panel>
        </PanelGroup>
      </div>
    </>
  );
};
