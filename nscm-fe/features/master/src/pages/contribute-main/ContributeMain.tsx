import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery, useProcMutation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ContributeVersionModal } from '../../components';

import { ContributeMainGrid } from './components/ContributeMainGrid';
import { SearchBar } from './components/SearchBar';
import { MENU_ID, SHEETS, VALIDATION_MSG } from './contribute-main.constants';
import styles from './ContributeMain.module.scss';
import type { MainRow } from './types';
import { useContributeMainStore } from './useContributeMainStore';
import { findDataGuard, validChk, validChk2 } from './utils/validators';

export const ContributeMain = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const sessionUserId = useSessionStore(s => s.session.userId ?? '');

  const gridRef = useRef<FlexGrid<MainRow> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const filters = useContributeMainStore(s => s.filters);
  const searchParams = useContributeMainStore(s => s.searchParams);
  const setFilters = useContributeMainStore(s => s.setFilters);
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

  // 저장 — DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO (mutate 는 array 만 받아 BE unfold 안 됨 → handleSave 안 apiClient.post 직접)
  useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
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

  // AS-IS SaveData() 1:1 매핑 (DMF0043_Contribute_Main.cs L333~):
  //   - 수정 행 (EDIT_FLAG='M') 만 처리
  //   - chkYear=false → M# 셀, chkYear=true → Y# 셀 (As-Is L394~395)
  //   - RBU_0999 (구분 컬럼) skip (As-Is L388)
  //   - 모든 dirty cell 을 ^ 구분 string 으로 누적 → SP 1회 호출
  //   - contributionType = 같은 row + 같은 period 의 RBU_0999 셀 값 (As-Is RetConType L872)
  const handleSave = () => {
    const rows = (mainData?.o_rc1 ?? []) as MainRow[];
    const dirty = rows.filter(r => r.EDIT_FLAG === 'M');

    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CHANGE', '수정한 내용이 없습니다.') });
      return;
    }

    const v1 = validChk(dirty, searchParams.chkYear);
    if (!v1.ok) {
      void setAlert({
        type: 'alert',
        content: t(VALIDATION_MSG.RATIO_OUT_OF_RANGE, '입력 데이터의 합계가 100% 가 아닙니다.'),
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
      Object.entries(row).forEach(([key, val]) => {
        if (!key.startsWith(`${tag}#`)) return;
        const parts = key.split('#');
        if (parts.length !== 3) return;
        const [, period, osCorpCd] = parts;
        if (osCorpCd.indexOf('999') >= 0) return;
        const sQty = val == null ? '' : String(val);
        if (sQty === '') return;
        const conTypeKey = `${tag}#${period}#RBU_0999`;
        const conType = (row as Record<string, string>)[conTypeKey] ?? '';

        buf.activeFlag += '^' + (row.EDIT_FLAG ?? 'U');
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

    if (count === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CELL', '저장할 셀 값이 없습니다.') });
      return;
    }

    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: t(VALIDATION_MSG.SAVE_CONFIRM, '저장하시겠습니까?'),
      });
      if (!ok) return;
      const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);

      await apiClient
        .post(`/${MENU_ID}/ContributeMain/SAVE/call-proc`, {
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
        })
        .then(res => {
          //[E20260807-AUDIT] 저장 결과 판정 — axios 인터셉터가 오류도 resolve 하므로 status/code
          //   직접 판정 (정본 business-plan.api.ts:71~74). 실패 시 SP message passthrough.
          if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
            const message = (res.data as { message?: string })?.message?.trim();
            void setAlert({
              type: 'alert',
              content: message || t('MSG00003', '저장 중 오류가 발생했습니다.'),
            });
          } else {
            void setAlert({ type: 'alert', content: t('MSG00002', '저장이 완료되었습니다.') });
          }
          void refetch?.();
        })
        .catch(() => {
          //[E20260807-AUDIT] 네트워크 등 reject 도 실패 alert (기존 무통보 → 판정 추가)
          void setAlert({ type: 'alert', content: t('MSG00003', '저장 중 오류가 발생했습니다.') });
          void refetch?.();
        });
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
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SearchBar onSearch={handleSearch} />
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
      <div className={styles.gridContainer}>
        <ContributeMainGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
      </div>
      <ContributeVersionModal
        open={versionModalOpen}
        modalClose={() => setVersionModalOpen(false)}
      />
    </div>
  );
};
