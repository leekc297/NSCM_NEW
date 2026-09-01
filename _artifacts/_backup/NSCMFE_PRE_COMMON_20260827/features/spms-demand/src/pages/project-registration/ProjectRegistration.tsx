import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import { BUTTON_TYPE, CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, GridUtils } from '@foundation/utils';
import {
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  TabItem,
  TabWrapper,
  toColumnLayoutSettings,
} from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MyProjectGrid } from './components/MyProjectGrid';
import { ProjectGrid } from './components/ProjectGrid';
import { ProjectRegistrationForm } from './components/ProjectRegistrationForm';
import { MENU_ID, RESPONSE_SET, SHEET_INDEX, SHEETS } from './project-registration.constants';
import {
  buildProjectActionPayload,
  buildProjectSavePayload,
  collectCheckedRows,
  createProjectIdentifiers,
} from './project-registration.grid-utils';
import { isDraftRegStatus, isPendingRegStatus, REG_STATUS } from './project-registration.types';
import type { MyProjectRow, ProjectRow } from './project-registration.types';
import styles from './ProjectRegistration.module.scss';
import { useProjectRegistrationStore } from './useProjectRegistrationStore';

// SDM1010 — Project Registration (샘플 수요 > 프로젝트 관리 > 프로젝트 권한 등록).
// sales-site 와 달리 PROJECT(설계서 TAB1: 프로젝트 등록)/MY_PROJECT(설계서 TAB2: 나의 프로젝트
// 현황)는 상단-하단 master/detail 이 아니라 조회조건 하나를 공유하는 동급(peer) 탭이다
// — 각자 자기 SP/그리드/버튼바를 갖는다(자세한 이유는 project-registration.constants.ts 참고).
export const ProjectRegistration = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  // [1] Grid ref — 탭(PROJECT/MY_PROJECT) 2개, SHEET_INDEX 순서와 동일하게 배열로 관리한다.
  const gridRefs = [useRef<FlexGrid<ProjectRow>>(), useRef<FlexGrid<MyProjectRow>>()] as const;
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()] as const;

  // [2] Store selector — 개별 selector 로만 구독한다(객체 통째 destructuring 금지 규칙).
  const initialized = useProjectRegistrationStore(state => state.initialized);
  const filters = useProjectRegistrationStore(state => state.filters);
  const setProjectFilters = useProjectRegistrationStore(state => state.setProjectFilters);
  const setMyProjectFilters = useProjectRegistrationStore(state => state.setMyProjectFilters);
  const staticColumns = useProjectRegistrationStore(state => state.staticColumns);
  const originalStaticColumns = useProjectRegistrationStore(state => state.originalStaticColumns);
  const applyColumnLayout = useProjectRegistrationStore(state => state.applyColumnLayout);
  const fetchStaticColumns = useProjectRegistrationStore(state => state.fetchStaticColumns);
  const searchParams = useProjectRegistrationStore(state => state.searchParams);
  const openSearchArea = useProjectRegistrationStore(state => state.openSearchArea);
  const setOpenSearchArea = useProjectRegistrationStore(state => state.setOpenSearchArea);
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const queryClient = useQueryClient();

  // Column Setting(ColumnLayoutModal) — SubTitle customButtons 로 여는 팝업 open 상태.
  const [openColumnSetting, setOpenColumnSetting] = useState(false);

  // 현재 활성 탭 — SubTitle 의 버튼바(Insert/Delete/Save/등록요청/요청취소)가 이 값 기준으로
  // 어느 그리드에 작용할지 결정된다. 탭 클릭(TabWrapper) 또는 그리드 포커스(ProjectGrid/
  // MyProjectGrid 의 gotFocus) 양쪽에서 갱신된다.
  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.PROJECT);

  const { saveWithValidation } = useSaveWithValidation();

  // [3] 서버 통신 훅 — PROJECT(TAB1)/MY_PROJECT(TAB2) 각각 자기 filters 가 세팅됐을 때만 조회한다.
  const { data: projectData, refetch: refetchProject } = useTabProcQuery<MENU_ID, SHEETS.PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROJECT,
    tabId,
    filters: filters[SHEETS.PROJECT],
    enabled: !!filters[SHEETS.PROJECT],
  });
  const { data: myProjectData } = useTabProcQuery<MENU_ID, SHEETS.MY_PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.MY_PROJECT,
    tabId,
    filters: filters[SHEETS.MY_PROJECT],
    enabled: !!filters[SHEETS.MY_PROJECT],
  });
  // PROJECT(TAB1) 저장 전용 — MY_PROJECT(TAB2)는 저장/삭제가 <해당없음>이라 mutation 자체가 없다.
  const { mutate: mutateProject } = useProcMutation<MENU_ID, SHEETS.PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROJECT,
    tabId,
  });
  const { mutate: requestProject } = useProcMutation<MENU_ID, SHEETS.PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROJECT,
    procedureAction: BUTTON_TYPE.REQUEST,
    tabId,
    onSuccess: () => {
      setToast({ type: 'success', message: t('MSG00712', '_성공적으로 등록요청 되었습니다.') });
      void refetchProject();
    },
    onError: error => {
      void setAlert({
        type: 'alert',
        content: error?.message ?? t('MSG00711', '_등록요청에 실패하였습니다.'),
      });
    },
  });
  const { mutate: cancelProjectRequest } = useProcMutation<MENU_ID, SHEETS.PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROJECT,
    procedureAction: BUTTON_TYPE.CANCEL,
    tabId,
    onSuccess: () => {
      setToast({ type: 'success', message: t('MSG00002', '_Successfully saved!') });
      void refetchProject();
    },
    onError: error => {
      void setAlert({
        type: 'alert',
        content: error?.message ?? t('MSG00003', '_Failed to save.'),
      });
    },
  });

  // RESPONSE_SET enum 값을 그대로 bracket-index 하면 문자열 리터럴 키 타입과 어긋날 수 있어
  // (procedures.d.ts 에 SDM1010 등록 후 엄격 타입이 됨) 실제 키 이름으로 직접 접근한다.
  const projectRows = (projectData?.projectList as unknown as ProjectRow[] | undefined) ?? [];
  const myProjectRows =
    (myProjectData?.myProjectList as unknown as MyProjectRow[] | undefined) ?? [];

  const dataCountByTab: Record<SHEET_INDEX, number> = {
    [SHEET_INDEX.PROJECT]: projectRows.length,
    [SHEET_INDEX.MY_PROJECT]: myProjectRows.length,
  };

  // [4] Handler
  // 조회(F5/Search) — 현재 탭의 filters 를 확정하고 컬럼 메타를 다시 받는다.
  const handleSearch = () => {
    if (activeTab === SHEET_INDEX.PROJECT) {
      setProjectFilters();
      void fetchStaticColumns();
      return;
    }

    const toDate = (value: string) => {
      const normalized = /^\d{8}$/.test(value)
        ? `${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`
        : value;
      if (!/^\d{4}-\d{2}-\d{2}$/.test(normalized)) return null;
      const parsed = dayjs(normalized);
      return parsed.isValid() ? parsed : null;
    };
    const from = toDate(searchParams.regCompDateFr);
    const to = toDate(searchParams.regCompDateTo);
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t('MSG00097', '_Division 을 선택하세요.') });
      return;
    }
    if (!from || !to) {
      void setAlert({ type: 'alert', content: t('MSG00013', '_필수값을 입력하세요.') });
      return;
    }
    if (from.isAfter(to)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_조회 기간이 잘못되었습니다 (시작일 > 종료일).'),
      });
      return;
    }
    if (to.isAfter(from.add(3, 'year'))) {
      void setAlert({
        type: 'alert',
        content: t('MSG00164', '_조회 기간은 3년 이내로 입력해주세요.'),
      });
      return;
    }
    setMyProjectFilters();
    void fetchStaticColumns();
  };

  // 추가(F8) — PROJECT(TAB1) 그리드에 새 행을 삽입한다. 사업부는 현재 조회조건 값을 그대로 쓰고
  // 등록 상태는 항상 "작성중(DRAFT)"으로 시작한다(화면설계서 §확인사항 2.1.2 — 신규 입력만 편집 가능).
  const handleInsert = () => {
    const grid = gridRefs[SHEET_INDEX.PROJECT].current;
    if (!grid) return;
    // 요청 1: 신규 행 생성 시 DPJT_CODE/SEQ/KEY를 함께 채워 SAVE SP IN 파라미터로 보낸다.
    const identifiers = createProjectIdentifiers();
    GridAction.addRow(grid, {
      ...identifiers,
      DIVISION_ID: searchParams.divisionId,
      DIVISION_NAME: searchParams.divisionId,
      DPJT_REG_STATUS: REG_STATUS.WRITING,
      DPJT_REG_STATUS_NAME: t('LBL00876', '_Draft'),
      // 신규 row도 DPJT_KEY(TEMP_...)는 이미 있어 팝업을 열 수 있지만 링크 텍스트가 비어 안 보였다.
      DPJT_ATUH_REG_STR: t('LBL00875', '_Authority Registration'),
    });
  };

  // 삭제(F9) — 화면설계서 TAB1 §확인사항 4.1: 신규 입력 또는 "작성중" 상태만 삭제 가능.
  //   그 외 상태(승인대기/등록완료)가 선택에 섞여 있으면 통째로 막고 알림만 띄운다.
  const handleDelete = () => {
    const grid = gridRefs[SHEET_INDEX.PROJECT].current;
    if (!grid) return;
    const selected = GridUtils.getSelectedRows(grid) ?? [];
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    const blocked = selected.some(
      row => row.CRUD_TYPE !== CRUD_TYPE.CREATE && !isDraftRegStatus(row.DPJT_REG_STATUS)
    );
    if (blocked) {
      void setAlert({
        type: 'alert',
        content: t('MSG00706', '_승인대기, 등록완료 상태의 프로젝트는 삭제할 수 없습니다'),
      });
      return;
    }
    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00710', '_프로젝트를 삭제 하시겠습니까?'),
      });
      if (confirmed) GridAction.removeRow(grid);
    })();
  };

  // 저장(F7) — 변경된(CRUD_TYPE 마킹된) row 만 모아 필수값 검증 후 저장한다.
  //   중복값 검증은 SP 가 하고 실패 시 useProcMutation 의 기본 onError 가 그 메시지를 그대로 띄운다.
  const handleSave = () => {
    const grid = gridRefs[SHEET_INDEX.PROJECT].current;
    const saveData = GridUtils.getChangedRows(grid);
    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00001', '_저장 하시겠습니까?'),
      });
      if (confirmed) {
        // 요청 3: 필수값은 원본 행으로 검증하고, mutation에는 '^' bulk payload 한 건만 전달한다
        // (원본 N행 배열을 그대로 보내면 BE가 sesUserId^ 를 행 수만큼 반복 조인해 SP가 스칼라로
        //  받는 세션 유저ID가 깨진다 — project-registration.grid-utils.ts 의 buildProjectSavePayload 주석 참고).
        saveWithValidation(saveData, staticColumns[RESPONSE_SET.PROJECT], rows =>
          mutateProject(buildProjectSavePayload(rows))
        );
      }
    })();
  };

  // 등록요청(커스텀 버튼) — 체크박스로 고른 row 중 "작성중" + 이미 저장된(DPJT_CODE 존재) 것만
  // 대상이다(화면설계서 TAB1 §확인사항 5.1, §메시지 코드 B46).
  // REQUEST 액션도 useProcMutation으로 처리해 공통 프로시저 호출 흐름을 유지한다.
  const handleRequest = () => {
    const checked = collectCheckedRows(gridRefs[SHEET_INDEX.PROJECT].current);
    const targets = checked.filter(row => row.DPJT_KEY && isDraftRegStatus(row.DPJT_REG_STATUS));
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00709', '_선택한 항목이 존재하지 않습니다.') });
      return;
    }
    if (targets.length < checked.length) {
      void setAlert({
        type: 'alert',
        content: t('MSG00708', '_승인대기, 등록완료 상태의 프로젝트는 등록요청할 수 없습니다.'),
      });
      return;
    }
    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00709', '_프로젝트를 등록/변경 하시겠습니까?'),
      });
      if (!confirmed) return;
      requestProject(buildProjectActionPayload(targets));
    })();
  };

  // 요청취소(커스텀 버튼) — "승인대기" 상태만 대상이다(화면설계서 TAB1 §메시지 코드 B51).
  const handleCancelRequest = () => {
    const checked = collectCheckedRows(gridRefs[SHEET_INDEX.PROJECT].current);
    const targets = checked.filter(row => isPendingRegStatus(row.DPJT_REG_STATUS));
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00902', '_선택한 항목이 존재하지 않습니다.') });
      return;
    }
    if (targets.length < checked.length) {
      void setAlert({
        type: 'alert',
        content: t('MSG00707', '_작성중, 등록완료 상태의 프로젝트는 요청취소할 수 없습니다.'),
      });
      return;
    }
    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00713', '_프로젝트 등록요청을 취소 하시겠습니까?'),
      });
      if (!confirmed) return;
      cancelProjectRequest(buildProjectActionPayload(targets));
    })();
  };

  // [5] useEffect — 최초 진입 시 컬럼을 로드하고, 검색조건이 없는 TAB1은 즉시 조회한다.
  //   TAB1 은 별도 검색 버튼이 없어(폼 hidden), F10(검색조건 초기화)이 filters[PROJECT] 를
  //   비워도 스스로 재조회할 방법이 없다 — filters[PROJECT] 가 비면(최초 진입 포함) 즉시 다시 채운다.
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    if (!filters[SHEETS.PROJECT]) setProjectFilters();
  }, [tabId, filters[SHEETS.PROJECT]]);

  // [6] hotkeyConfig — PROJECT(TAB1) 는 편집 가능, MY_PROJECT(TAB2) 는 조회 전용
  //   (TAB2 §프로시저: 저장/삭제 <해당없음> → SubTitle 버튼 자체를 숨긴다).
  const hotkeyConfig: HotkeyConfig =
    activeTab === SHEET_INDEX.PROJECT
      ? {
          insert: handleInsert,
          delete: handleDelete,
          save: handleSave,
          search: handleSearch,
          manual: false,
          upload: false,
        }
      : {
          insert: false,
          delete: false,
          save: false,
          search: handleSearch,
          manual: false,
          upload: false,
        };

  // Column Setting(다른 화면과 동일 — sales-plan/mkt-fcst 등의 ColumnLayoutModal 패턴) 대상 시트.
  //   두 탭이 각자 staticColumns/RESPONSE_SET 을 갖고 있어 활성 탭 기준으로 대상을 바꾼다.
  const columnSettingSheet =
    activeTab === SHEET_INDEX.PROJECT ? RESPONSE_SET.PROJECT : RESPONSE_SET.MY_PROJECT;

  const columnSettingButton = {
    label: t('LBL00605', 'Column Setting'),
    title: t('LBL00605', 'Column Setting'),
    action: () => setOpenColumnSetting(true),
    iconComponent: <IcGridColumnSetup />,
    buttonLabel: '',
  };

  // 등록요청/요청취소는 표준 hotkey 세트에 없는 이 화면 전용 버튼이라 SubTitle 의 customButtons 로
  // 얹는다 — PROJECT(TAB1) 탭에서만 보인다(MY_PROJECT 는 조회 전용이라 대상 자체가 없음).
  // Column Setting 은 두 탭 모두에서 쓸 수 있다(조회 전용 그리드도 컬럼 표시/순서 개인화는 가능).
  const customButtons =
    activeTab === SHEET_INDEX.PROJECT
      ? [
          columnSettingButton,
          { label: t('LBL00865', '_등록요청'), action: handleRequest },
          { label: t('LBL00422', '_요청취소'), action: handleCancelRequest },
        ]
      : [columnSettingButton];

  // [7] JSX — MainTitle → Form(조회조건) → SubTitle(버튼바) → TabWrapper(PROJECT/MY_PROJECT)
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <MainTitle
          title={title}
          menuId={MENU_ID}
          openSearchArea={openSearchArea}
          disableSearchAreaToggle={activeTab === SHEET_INDEX.PROJECT}
          toggleOpenSearchArea={activeTab === SHEET_INDEX.PROJECT ? undefined : setOpenSearchArea}
        />
        <ProjectRegistrationForm
          hidden={activeTab === SHEET_INDEX.PROJECT}
          onSearch={handleSearch}
        />
        <SubTitle
          menuId={MENU_ID}
          grid={gridRefs[activeTab]}
          gridFilter={gridFilterRefs[activeTab]}
          dataCount={dataCountByTab[activeTab]}
          excelFileName='Project Registration'
          hotkeyConfig={hotkeyConfig}
          searchParam={searchParams}
          customButtons={customButtons}
        />
        {/* Column Setting — 공용 ColumnLayoutModal(표시/순서 + Width/Cell·Text Color) + titleSet 'C'
            영구 저장. sales-plan/mkt-fcst 등 다른 화면과 동일 패턴(구 ColumnSettingModal 사용 금지). */}
        <ColumnLayoutModal
          open={openColumnSetting}
          modalClose={() => setOpenColumnSetting(false)}
          menuId={MENU_ID}
          sheetName={columnSettingSheet}
          columnType='C'
          divisionId={searchParams.divisionId}
          fallbackColumns={staticColumns[columnSettingSheet].map(column => ({
            key: column.colNm,
            header: column.colLblNm ?? column.colNm,
            width: column.colWth ?? 100,
            display: column.display,
            personalizable: column.personalizable,
          }))}
          title={t('LBL00605', 'Column Setting')}
          leftTitle={t('LBL00764', 'Invisible')}
          rightTitle={t('LBL00765', 'Visible')}
          initialSettings={toColumnLayoutSettings(staticColumns[columnSettingSheet])}
          defaultSettings={toColumnLayoutSettings(originalStaticColumns[columnSettingSheet])}
          onSave={settings => {
            // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns 에 적용 → grid 즉시 갱신.
            applyColumnLayout(
              columnSettingSheet,
              settings.map(s => ({
                colNm: s.COLUMN_NAME,
                visible: s.USER_FLAG === 'Y',
                width: s.COL_WIDTH,
                cellColor: s.CELL_COLOR,
                textColor: s.TEXT_COLOR,
                order: s.SORT_ORDER_NO,
              }))
            );
            // (2) titleSet 'C' 영구 저장 — 표시 column + 순서 + 폭/색.
            const visible = settings.filter(s => s.USER_FLAG === 'Y');
            void saveTitleSet({
              menuId: MENU_ID,
              sheetName: columnSettingSheet,
              columnType: 'C',
              rows: visible.map((s, i) => ({
                name: s.COLUMN_NAME,
                sortOrderNo: i + 1,
                colWidth: s.COL_WIDTH,
                cellColor: s.CELL_COLOR,
                textColor: s.TEXT_COLOR,
              })),
            }).then(ok => {
              if (!ok) {
                void setAlert({
                  type: 'alert',
                  content: t('MSG00618', '_An error occurred while saving.'),
                });
                return;
              }
              // 팝업 titleSet 조회 캐시 무효화(필수, sales-plan 과 동일 이유) + admin 메타 재조회.
              void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
              void fetchStaticColumns();
            });
          }}
        />
      </div>
      <div className={styles.mainContent}>
        {/* activeTabIndex/setActiveTabIndex 로 controlled — 탭을 클릭해 바꿔도 activeTab state 가
            즉시 따라가야 SubTitle 버튼바가 바로 그 탭 기준으로 동작한다. */}
        <TabWrapper
          persist
          activeTabIndex={activeTab}
          setActiveTabIndex={index => {
            const nextTab = index as SHEET_INDEX;
            setActiveTab(nextTab);
            // Tab2(사업부 변경) 이 setSearchParams 에서 PROJECT filters 를 리셋시켜(§상위 조건
            // 초기화) Tab1 로 돌아와도 그리드가 빈 채로 남는다 — 여기서 자동 재조회한다.
            // 미저장 편집 중이면 덮어쓰지 않는다(refetch 가 draft row 를 지우는 문제, onAuthSaved 참고).
            if (
              nextTab === SHEET_INDEX.PROJECT &&
              !GridUtils.isDirty(gridRefs[SHEET_INDEX.PROJECT].current)
            ) {
              setProjectFilters();
              void fetchStaticColumns();
            }
          }}
        >
          <TabItem label={t('LBL00864', '_Project Registration')}>
            <ProjectGrid
              gridRef={gridRefs[SHEET_INDEX.PROJECT]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.PROJECT]}
              data={projectRows}
              setActiveTab={setActiveTab}
              // MY_PROJECT(TAB2) 조회 중엔 이 그리드를 dirty 집계에서 뺀다 — 둘은 조회조건만 공유하는
              // peer 탭이라 TAB2 조회가 TAB1 의 미저장 편집까지 물어 confirm 을 띄우면 안 된다.
              excludeFromDirtyCheck={activeTab !== SHEET_INDEX.PROJECT}
              // 미저장 편집(신규 row 포함)이 있는 동안 재조회하면 서버가 모르는 그 row가
              // itemsSource 교체로 통째로 사라진다 — dirty 면 재조회를 건너뛴다.
              onAuthSaved={() => {
                if (GridUtils.isDirty(gridRefs[SHEET_INDEX.PROJECT].current)) return;
                void refetchProject();
              }}
            />
          </TabItem>
          <TabItem label={t('LBL00870', '_My Project Status')}>
            <MyProjectGrid
              gridRef={gridRefs[SHEET_INDEX.MY_PROJECT]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.MY_PROJECT]}
              data={myProjectRows}
              setActiveTab={setActiveTab}
            />
          </TabItem>
        </TabWrapper>
      </div>
    </div>
  );
};
