import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE, CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient, useMutation } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ContributeVersionModal } from '../../components';

import { ContributeMainGrid } from './components/ContributeMainGrid';
import { SearchBar } from './components/SearchBar';
import { MENU_ID, SHEETS, VALIDATION_MSG } from './contribute-main.constants';
import type { MainRow } from './types';
import { useContributeMainStore } from './useContributeMainStore';
import { findDataGuard, formatPeriodLabel, validChk, validChk2 } from './utils/validators';

export const ContributeMain = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const sessionUserId = useSessionStore(s => s.session.userId ?? '');

  const gridRef = useRef<FlexGrid<MainRow> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const editTrackerRef = useRef<EditTracker<MainRow> | undefined>();

  const filters = useContributeMainStore(s => s.filters);
  const searchParams = useContributeMainStore(s => s.searchParams);
  const setFilters = useContributeMainStore(s => s.setFilters);
  const clearFilters = useContributeMainStore(s => s.clearFilters);
  const fetchStaticColumns = useContributeMainStore(s => s.fetchStaticColumns);
  const initialized = useContributeMainStore(s => s.initialized);
  const openSearchArea = useContributeMainStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeMainStore(s => s.setOpenSearchArea);

  const [versionModalOpen, setVersionModalOpen] = useState<boolean>(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 메인 grid 조회 — DMF0043_GET_CONTRIBUTE_MAIN_DATA
  const { data: mainData, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchParams.verSeq,
  });

  // 저장 — DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO.
  //   공용 useProcMutation 을 못 쓴다: mutationFn 이 row 배열을 받아 callMutationProc 으로 보내는데
  //   이 SP 는 '^' 로 이어붙인 스칼라 13개를 받는다 (BE unfold 대상이 아님).
  //   그래도 useMutation 으로 감싸는 이유는 전역 로딩 스피너다 — MDIContainer 의
  //   useIsBusy([tabId]) 가 tabId 로 시작하는 query/mutation 만 세므로, apiClient.post 를
  //   직접 부르면 저장 중에 스피너가 돌지 않는다. mutationKey 규약은 useProcMutation·
  //   useSalesSiteProjectModelSave 와 동일하게 [tabId, sheetName, SAVE, {}].
  const { mutateAsync: saveContributeMain } = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, BUTTON_TYPE.SAVE, {}],
    // 저장은 멱등하지 않다 — 실패분 재전송은 중복 반영으로 이어질 수 있어 재시도하지 않는다
    // (전역 기본값은 mutations.retry: 1).
    retry: 0,
    mutationFn: (payload: Record<string, string>) =>
      apiClient.post<unknown, Record<string, string>>(
        `/${MENU_ID}/ContributeMain/SAVE/call-proc`,
        payload
      ),
  });

  const handleSearch = () => {
    const guard = findDataGuard(searchParams.verSeq);
    if (!guard.ok) {
      void setAlert({
        type: 'alert',
        content: t(VALIDATION_MSG.VERSION_REQUIRED, '버전을 선택해주세요.'),
      });
      return;
    }
    setFilters();
    void fetchStaticColumns();
    void refetch?.();
  };

  // Grid 초기화 규약 — ContributeView / CustomerFcstUpload(DMF0014) resetGrid 1:1.
  //   호출 지점: Year 변경 (SearchBar onYearChange).
  //   화면에 남은 결과는 이전 Year 로 조회한 것이라 바뀐 조회조건과 어긋난다. 미저장 편집도 함께
  //   버린다 — 남겨 두면 바뀐 전제(Year)로 저장된다. 자동 재조회하지 않는다(재조회는 Search 로만).
  //   clearFilters() 로 filters 가 사라지면 useTabProcQuery 가 disabled + queryKey 변경 → rows 가
  //   빈 배열이 된다.
  //   removeQueries([tabId]) 필수 — 전역 staleTime=Infinity 라 이전 Year 로 되돌려 Search 하면
  //   캐시가 그대로 돌아온다. queryKey 는 [tabId, sheetName, action, filters] 라 tabId prefix 로 지운다.
  //   itemsSource 직접 비우기 — 위 두 줄은 다음 render 에서 반영된다. 그리드 컨트롤에 남아 있는
  //   행을 그 자리에서 지워, 데이터가 사라지는 시점이 render 타이밍에 좌우되지 않게 한다.
  const resetGrid = () => {
    editTrackerRef.current?.clearChanges();
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    if (gridRef.current) gridRef.current.itemsSource = [];
  };

  // AS-IS SaveData() 1:1 매핑 (DMF0043_Contribute_Main.cs L333~):
  //   - 수정 행 (CRUD_TYPE='M') 만 처리 — EDIT_FLAG 는 행 잠금 판정값이라 마커로 쓰지 않는다
  //   - chkYear=false → M# 셀, chkYear=true → Y# 셀 (As-Is L394~395)
  //   - RBU_0999 (구분 컬럼) skip (As-Is L388)
  //   - 모든 dirty cell 을 ^ 구분 string 으로 누적 → SP 1회 호출
  //   - contributionType = 같은 row + 같은 period 의 RBU_0999 셀 값 (As-Is RetConType L872)
  const handleSave = () => {
    const rows = (mainData?.o_rc1 ?? []) as MainRow[];
    const dirty = rows.filter(r => r.CRUD_TYPE === CRUD_TYPE.MODIFY);

    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CHANGE', '수정한 내용이 없습니다.') });
      return;
    }

    const v1 = validChk(dirty, searchParams.chkYear);
    if (!v1.ok) {
      // 어느 기간이 몇으로 합산됐는지 붙인다 — 화면에 보이는 달은 100 인데 스크롤 밖의 다른 달이
      //   걸린 경우, 기간 없이 "100% 가 아닙니다" 만 뜨면 사용자가 오탐과 구분할 수 없다.
      const detail =
        v1.period == null ? '' : ` (${formatPeriodLabel(v1.period)}: ${(v1.sum ?? 0).toFixed(2)})`;
      void setAlert({
        type: 'alert',
        content:
          t(VALIDATION_MSG.RATIO_OUT_OF_RANGE, '입력 데이터의 합계가 100% 가 아닙니다.') + detail,
      });
      return;
    }
    const v2 = validChk2(dirty, searchParams.chkYear);
    if (!v2.ok) {
      void setAlert({
        type: 'alert',
        content: t(VALIDATION_MSG.REQUIRED_DIVISION, '필수값을 입력해주세요.'),
      });
      return;
    }

    const tag = searchParams.chkYear ? 'Y' : 'M';
    const buf = {
      activeFlag: '',
      verSeq: '',
      departmentId: '',
      deptId: '',
      endCustReport: '',
      soldtoCustReport: '',
      productGroup: '',
      dmBizType: '',
      yyyymm: '',
      osCorpCd: '',
      contributionType: '',
      contributionRatio: '',
      createdBy: '',
    };
    let count = 0;
    dirty.forEach(row => {
      // ⭐ 2026-08-11 — 값이 있는 셀만 보내던 것을 "입력한 period 는 8개 RBU 전부" 로 바꾼다.
      //   AS-IS 스프레드는 빈 셀이 0.00 이라 편집한 달의 RBU 가 통째로 넘어갔고 SP 도 그 전제로
      //   짜여 있다. TO-BE 는 SP 응답의 NULL 셀이 payload 에서 빠져 1월만 입력하면 셀 1개만
      //   넘어가고 SQL 이 깨졌다. → 입력이 하나라도 있는 period 안의 빈 셀은 '0' 으로 채운다.
      //   손대지 않은 달은 그대로 제외 (전 기간을 0 으로 덮어쓰지 않는다).
      const rbuCodes = new Set<string>();
      const touchedPeriods = new Set<string>();
      Object.entries(row).forEach(([key, val]) => {
        if (!key.startsWith(`${tag}#`)) return;
        const parts = key.split('#');
        if (parts.length !== 3) return;
        const [, period, osCorpCd] = parts;
        if (osCorpCd.indexOf('999') >= 0) return; // 구분 컬럼은 ratio 대상 아님
        rbuCodes.add(osCorpCd);
        if (val != null && val !== '') touchedPeriods.add(period);
      });

      [...touchedPeriods].sort().forEach(period => {
        const conTypeKey = `${tag}#${period}#RBU_0999`;
        const conType = (row as Record<string, string>)[conTypeKey] ?? '';

        [...rbuCodes].sort().forEach(osCorpCd => {
          // MainRow 의 인덱스 시그니처가 WijmoPrimitive 라 별도 캐스팅 없이 안전하게 문자열화된다.
          const val = row[`${tag}#${period}#${osCorpCd}`];
          const sQty = val == null || val === '' ? '0' : String(val);

          // SP 로 가는 activeFlag 는 기존과 동일한 'M' 을 유지한다 (마커를 CRUD_TYPE 으로
          // 옮겼을 뿐 전송값을 바꾸지 않는다 — SP 계약 변경 금지).
          buf.activeFlag += '^' + (row.CRUD_TYPE ?? CRUD_TYPE.MODIFY);
          buf.verSeq += '^' + (row.VER_SEQ ?? searchParams.verSeq);
          buf.departmentId += '^' + (row.DEPARTMENT_ID ?? '');
          buf.deptId += '^' + (row.DEPT_ID ?? '');
          buf.endCustReport += '^' + (row.END_CUST_REPORT ?? '');
          buf.soldtoCustReport += '^' + (row.SOLDTO_CUST_REPORT ?? '');
          buf.productGroup += '^' + (row.PRODUCT_GROUP ?? '');
          buf.dmBizType += '^' + (row.DM_BIZ_TYPE ?? '');
          buf.yyyymm += '^' + period;
          buf.osCorpCd += '^' + osCorpCd;
          buf.contributionType += '^' + conType;
          buf.contributionRatio += '^' + sQty;
          buf.createdBy += '^' + sessionUserId;
          count++;
        });
      });
    });

    if (count === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CELL', '저장할 셀 값이 없습니다.') });
      return;
    }

    void (async () => {
      // 저장 confirm 없이 바로 저장한다 (사용자 지시 2026-08-23) — 다른 화면과 동일한 규약.
      //   위 검증(변경 유무 / 합계 100% / 필수값 / 대상 셀 0건)을 통과하면 Save 클릭 자체를
      //   확정 의사로 본다. 실패만 Alert 로 알리고 성공은 Toast (AGENTS.md 저장 피드백 규칙).
      const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);

      try {
        const res = await saveContributeMain({
          activeFlag: trim(buf.activeFlag),
          verSeq: trim(buf.verSeq),
          departmentId: trim(buf.departmentId),
          deptId: trim(buf.deptId),
          endCustReport: trim(buf.endCustReport),
          soldtoCustReport: trim(buf.soldtoCustReport),
          productGroup: trim(buf.productGroup),
          dmBizType: trim(buf.dmBizType),
          yyyymm: trim(buf.yyyymm),
          osCorpCd: trim(buf.osCorpCd),
          contributionType: trim(buf.contributionType),
          contributionRatio: trim(buf.contributionRatio),
          createdBy: trim(buf.createdBy),
        });
        // 팝업(setAlert) 대신 toast 로 통일 — useCustomQueryClient 저장 완료 메시지와 방식 통일 (SalesSite 참고)
        if (res.status === 200) {
          setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
        } else {
          setToast({
            type: 'error',
            message: t(CRUD_MSG.SAVE_ERROR.id, CRUD_MSG.SAVE_FAIL.fallback),
          });
        }
      } catch {
        setToast({
          type: 'error',
          message: t(CRUD_MSG.SAVE_ERROR.id, CRUD_MSG.SAVE_FAIL.fallback),
        });
      } finally {
        // 성패와 무관하게 재조회 — 부분 반영 여부를 화면이 추측하지 않게 서버 상태로 맞춘다.
        void refetch?.();
      }
    })();
  };

  // 동적 권한 (admin SYS0009 USE_YN + USER_GR 권한 동시 반영). hasButton('SEARCH'/'SAVE') 적용.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    {
      label: t('LBL00604', '_Contribution Version'),
      action: () => setVersionModalOpen(true),
    },
  ];

  // 화면 진입 + Year 자동 선택 직후 자동 조회 trigger (AS-IS Form_Load + InitControls)
  // useEffect(() => {
  //   if (searchParams.verSeq && !filters[SHEETS.MAIN]) {
  //     setFilters();
  //   }
  // }, [searchParams.verSeq]);

  // 화면 mount 시 admin SHEET_COLUMNS (BASE 6 컬럼) 동적 fetch.
  useEffect(() => {
    console.log('initialized', initialized);
    if (!initialized) void fetchStaticColumns();
  }, [initialized]);

  const rows = useMemo(() => (mainData?.o_rc1 ?? []) as MainRow[], [mainData]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SearchBar onSearch={handleSearch} onYearChange={resetGrid} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeMain'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />
      <ContributeMainGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
      />
      <ContributeVersionModal
        open={versionModalOpen}
        modalClose={() => setVersionModalOpen(false)}
      />
    </>
  );
};
