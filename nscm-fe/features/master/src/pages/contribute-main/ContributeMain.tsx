import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery, useProcMutation } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ContributeMainGrid } from './components/ContributeMainGrid';
import { ContributeRatePopup } from './components/ContributeRatePopup';
import { SearchBar } from './components/SearchBar';
import { VersionPopup } from './components/VersionPopup';
import { MENU_ID, SHEETS, VALIDATION_MSG } from './contribute-main.constants';
import styles from './ContributeMain.module.scss';
import type { MainRow } from './types';
import { useContributeMainStore } from './useContributeMainStore';
import { findDataGuard, validChk, validChk2 } from './utils/validators';

export const ContributeMain = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<MainRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useContributeMainStore(s => s.filters);
  const searchCondition = useContributeMainStore(s => s.searchCondition);
  const setFilter = useContributeMainStore(s => s.setFilter);
  const openSearchArea = useContributeMainStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeMainStore(s => s.setOpenSearchArea);
  const setVersionPopupOpen = useContributeMainStore(s => s.setVersionPopupOpen);
  const ratePopupOpen = useContributeMainStore(s => s.ratePopupOpen);
  const setRatePopupOpen = useContributeMainStore(s => s.setRatePopupOpen);

  // 메인 grid 조회 — DMF0043_GET_CONTRIBUTE_MAIN_DATA
  const { data: mainData, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchCondition.verSeq,
  });

  // 저장 — DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
  const { mutate: saveMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const handleSearch = () => {
    const guard = findDataGuard(searchCondition.verSeq);
    if (!guard.ok) {
      window.alert(`[${guard.msgCode}] 버전을 선택해주세요`);
      return;
    }
    setFilter();
    refetch?.();
  };

  const handleInsert = () => {
    const newRow: Partial<MainRow> = {
      DIVISION_ID: '40',
      VER_SEQ: searchCondition.verSeq,
      EDIT_FLAG: 'I',
    };
    if (gridRef.current) {
      const items = (mainData?.o_rc1 ?? []) as MainRow[];
      const next = [newRow as MainRow, ...items];
      gridRef.current.itemsSource = next;
      gridRef.current.invalidate();
    }
  };

  const handleDelete = () => {
    if (!gridRef.current) return;
    const selected = gridRef.current.selectedItems[0];
    if (selected) (selected as MainRow).EDIT_FLAG = 'D';
    gridRef.current.invalidate();
  };

  // AS-IS SaveData() 1:1 매핑 (DMF0043_Contribute_Main.cs L333~):
  //   - 수정 행 (EDIT_FLAG='M') 만 처리
  //   - chkYear=false → M# 셀, chkYear=true → Y# 셀 (As-Is L394~395)
  //   - RBU_0999 (구분 컬럼) skip (As-Is L388)
  //   - 빈 값 셀 skip
  //   - 모든 dirty cell 을 ^ 구분 string 으로 누적 → SP 1회 호출 (bulk)
  //   - contributionType = 같은 row + 같은 period 의 RBU_0999 셀 값 (As-Is RetConType L872)
  const handleSave = () => {
    // wijmo: 진행 중 cell edit 강제 commit — cell 수정 후 Enter 안 누른 채 저장 클릭 시
    // row.binding=value 미반영 사고 방지
    gridRef.current?.finishEditing();
    const rows = (mainData?.o_rc1 ?? []) as MainRow[];
    const dirty = rows.filter(r => r.EDIT_FLAG === 'M');
    const setAlert = useMessageStore.getState().setAlert;

    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '수정된 항목이 없습니다.' });
      return;
    }

    const v1 = validChk(dirty, searchCondition.chkYear);
    if (!v1.ok) {
      void setAlert({ type: 'alert', content: `[${v1.msgCode}] 입력 데이터의 합계가 100% 가 아닙니다.` });
      return;
    }
    const v2 = validChk2(dirty, searchCondition.chkYear);
    if (!v2.ok) {
      void setAlert({ type: 'alert', content: `[${v2.msgCode}] 필수값을 입력해주세요.` });
      return;
    }
    // AS-IS ^ 구분 누적 (Remove(0,1) 로 leading ^ 제거 패턴 동일)
    const tag = searchCondition.chkYear ? 'Y' : 'M';
    const buf = {
      activeFlag: '', verSeq: '', departmentId: '', deptId: '',
      endCustReport: '', soldtoCustReport: '', productGroup: '', dmBizType: '',
      yyyymm: '', osCorpCd: '', contributionType: '', contributionRatio: '',
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

        buf.activeFlag         += '^' + (row.EDIT_FLAG ?? 'U');
        buf.verSeq             += '^' + (row.VER_SEQ ?? searchCondition.verSeq);
        buf.departmentId       += '^' + (row.DEPARTMENT_ID ?? '');
        buf.deptId             += '^' + (row.DEPT_ID ?? '');
        buf.endCustReport      += '^' + (row.END_CUST_REPORT ?? '');
        buf.soldtoCustReport   += '^' + (row.SOLDTO_CUST_REPORT ?? '');
        // PRODUCT_GROUP: 사내 schema 의 SCM_MST_SITE_ITEM.REPORT_GROUP3 미존재로
        // 조회 시 '' 반환됨. SAVE 의 NOT NULL 분기에서 ORA-01400 → 'N' 으로 default
        buf.productGroup       += '^' + (row.PRODUCT_GROUP || 'N');
        buf.dmBizType          += '^' + (row.DM_BIZ_TYPE ?? '');
        buf.yyyymm             += '^' + period;
        buf.osCorpCd           += '^' + osCorpCd;
        buf.contributionType   += '^' + conType;
        buf.contributionRatio  += '^' + sQty;
        buf.createdBy          += '^' + 'minyonglee1';
        count++;
      });
    });

    if (count === 0) {
      void setAlert({ type: 'alert', content: '저장할 셀 값이 없습니다.' });
      return;
    }

    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: `[${VALIDATION_MSG.SAVE_CONFIRM}] 저장하시겠습니까?`,
      });
      if (!ok) return;
      const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);
      // useProcMutation mutate 는 array 만 받고 BE 가 array 의 element 를 top-level 로
      // unfold 하지 않음 → BE 가 모든 IN 파라미터 NULL 처리. As-Is 의 ^ 구분 bulk pattern 은
      // top-level fields 형태로만 동작. 따라서 apiClient.post 직접 호출 (mutate 우회).
      try {
        await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, {
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
        void setAlert({ type: 'alert', content: '저장이 완료되었습니다.' });
        refetch?.();
      } catch {
        void setAlert({ type: 'alert', content: '저장 중 오류가 발생했습니다.' });
      }
    })();
  };

  // Figma SVG (DMF0043_Table.svg) + figma_link.md + AS-IS DMF0043_Contribute_Main.cs
  // 참조 button 설계 (2026-06-01):
  //   F5  = 조회   (SearchBar 별도)
  //   F7  = 저장   (handleSave)
  //   F3  = Sort   (default — toggleColumnSort)
  //   F4  = Filter (default — toggleColumnFilter)
  //   F6  = Condition       (default — personalizeCondition)
  //   F10 = ResetCondition  (default — resetPersonalizedCondition)
  //   F8/F9 (insert/delete) : AS-IS .cs 가 EditButton/Lock 으로만 처리 → 명시적 버튼 비활성
  //   기여율 버전관리 : customButton (figma DMF0043 추가 버튼)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: handleSave,
    // F3/F4/F6/F10 : 명시 안 함 → SubTitle DefaultButtonActions 사용 (자동 활성)
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    {
      label: '기여율 버전관리',
      action: () => setVersionPopupOpen(true),
    },
  ];

  // handleInsert / handleDelete 는 AS-IS .cs 에 명시적 버튼 없음. 추후 비즈니스 요구 시 활성화.
  void handleInsert; void handleDelete;

  // 화면 진입 + Year 자동 선택 직후 자동 조회 trigger (AS-IS Form_Load + InitControls)
  useEffect(() => {
    if (searchCondition.verSeq && !filters[SHEETS.MAIN]) {
      setFilter();
    }
  }, [searchCondition.verSeq]);

  const rows = (mainData?.o_rc1 ?? []) as MainRow[];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <SearchBar
          onSearch={handleSearch}
          onOpenVersionPopup={() => setVersionPopupOpen(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeMain'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
        customButtons={customButtons}
      />
      <div className={styles.gridContainer}>
        <ContributeMainGrid gridRef={gridRef} data={rows} />
      </div>
      <ContributeRatePopup
        yyyy={searchCondition.yyyy}
        open={ratePopupOpen}
        onClose={() => setRatePopupOpen(false)}
      />
      <VersionPopup />
    </div>
  );
};
