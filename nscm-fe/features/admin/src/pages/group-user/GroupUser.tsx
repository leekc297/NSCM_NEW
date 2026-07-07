import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { GroupUserInfoGrid } from './components/GroupUserInfoGrid';
import { GroupUserMainGrid } from './components/GroupUserMainGrid';
import { GroupUserUnitGrid } from './components/GroupUserUnitGrid';
import { MENU_ID, SHEETS, UNIT_TP_CD } from './group-user.constants';
import styles from './GroupUser.module.scss';
import { useGroupUserStore } from './useGroupUserStore';

const collectRowsWithSheet = (
  grid: FlexGrid | undefined,
  sheetName: string,
  extra: Record<string, unknown> = {}
): WijmoRowItem[] => {
  if (!grid) return [];
  const rows: WijmoRowItem[] = [];
  for (let i = 0; i < grid.rows.length; i += 1) {
    const item = grid.rows[i]?.dataItem as (WijmoRowItem & { CRUD_TYPE?: string }) | undefined;
    if (!item?.CRUD_TYPE) continue;
    rows.push({ ...item, ...extra, SHT_NM: sheetName } as WijmoRowItem);
  }
  return rows;
};

export const GroupUser = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const mainGridRef = useRef<FlexGrid>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const userGridRef = useRef<FlexGrid>();
  const userGridFilterRef = useRef<FlexGridFilter>();
  const divisionGridRef = useRef<FlexGrid>();
  const divisionGridFilterRef = useRef<FlexGridFilter>();
  // 마지막 포커스/선택 그리드 — 상단 SubTitle Insert/Delete 가 이 그리드에 적용
  const activeSheetRef = useRef<SHEETS>(SHEETS.MAIN);

  const filters = useGroupUserStore(state => state.filters);
  const setMainFilter = useGroupUserStore(state => state.setMainFilter);
  const fetchStaticColumns = useGroupUserStore(state => state.fetchStaticColumns);
  const staticColumns = useGroupUserStore(state => state.staticColumns);
  const selectedUserGrId = useGroupUserStore(state => state.selectedUserGrId);
  const selectedUserId = useGroupUserStore(state => state.selectedUserId);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.USER_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_INFO,
    tabId,
    filters: filters[SHEETS.USER_INFO],
    enabled: !!filters[SHEETS.USER_INFO],
  });
  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters: filters[SHEETS.DIVISION],
    enabled: !!filters[SHEETS.DIVISION],
  });

  const { mutate: mutateSave } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  useEffect(() => {
    void fetchStaticColumns();
    if (!filters[SHEETS.MAIN]) setMainFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // — 권한 (useTabBtnPermissions — admin SYS0009 Menu Button 동적) —
  const canInsert = hasButton('INSERT');
  const canDelete = hasButton('DELETE');
  const canSave = hasButton('SAVE');
  const canSearch = hasButton('SEARCH');

  // — CRUD (상단 SubTitle 툴바 F8/F9 — activeSheetRef = 마지막 포커스/선택 그리드 대상) —
  const onInsert = () => {
    if (activeSheetRef.current === SHEETS.USER_INFO) {
      if (!selectedUserGrId) {
        void setAlert({ type: 'alert', content: t('MSG00625', '_먼저 Group 을 선택해 주십시오.') });
        return;
      }
      if (userGridRef.current) {
        GridAction.addRow(userGridRef.current, { USER_GR_ID: selectedUserGrId, USE_YN: 'Y' });
      }
      return;
    }
    if (activeSheetRef.current === SHEETS.DIVISION) {
      if (!selectedUserGrId || !selectedUserId) {
        void setAlert({
          type: 'alert',
          content: t('MSG00626', '_먼저 Group 과 User 를 선택해 주십시오.'),
        });
        return;
      }
      if (divisionGridRef.current) {
        GridAction.addRow(divisionGridRef.current, {
          USER_GR_ID: selectedUserGrId,
          USER_ID: selectedUserId,
          UNIT_TP_CD: UNIT_TP_CD.DIVISION,
          UPPR_UNIT_ID: '-',
          EDIT_YN: 'Y',
          USE_YN: 'Y',
        });
      }
      return;
    }
    if (mainGridRef.current) GridAction.addRow(mainGridRef.current, { USE_YN: 'Y' });
  };
  const onDelete = () => {
    if (activeSheetRef.current === SHEETS.USER_INFO) {
      if (userGridRef.current) GridAction.removeRow(userGridRef.current, true);
      return;
    }
    if (activeSheetRef.current === SHEETS.DIVISION) {
      if (divisionGridRef.current) GridAction.removeRow(divisionGridRef.current, false);
      return;
    }
    if (mainGridRef.current) GridAction.removeRow(mainGridRef.current, true);
  };

  // — SAVE (3 sheet 통합 — main/userInfo/division CRUD row) —
  const onSave = () => {
    const mainRows = collectRowsWithSheet(mainGridRef.current, SHEETS.MAIN);
    const userRows = collectRowsWithSheet(userGridRef.current, SHEETS.USER_INFO, {
      USER_GR_ID: selectedUserGrId,
    });
    const divRows = collectRowsWithSheet(divisionGridRef.current, SHEETS.DIVISION, {
      USER_GR_ID: selectedUserGrId,
      USER_ID: selectedUserId,
      UNIT_TP_CD: UNIT_TP_CD.DIVISION,
    });
    const payload = [...mainRows, ...userRows, ...divRows];
    if (payload.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00627', '_변경 사항이 없습니다.') });
      return;
    }
    mutateSave(payload as ResponseData<MENU_ID, SHEETS.MAIN>[], {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      },
    });
  };

  const handleSearch = () => {
    setMainFilter();
    void fetchStaticColumns();
  };
  const hotkeyConfig: HotkeyConfig = {
    search: canSearch ? handleSearch : false,
    save: canSave ? onSave : false,
    insert: canInsert ? onInsert : false,
    delete: canDelete ? onDelete : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      {/* Figma 5934:143433 — 상단 검색조건 없음 + 그리드 헤더 버튼 없음 (figma-layout-parity-mandatory #90) */}
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainData?.o_rc1?.length ?? 0}
        excelFileName='GroupUser'
        hotkeyConfig={hotkeyConfig}
      />
      {/* 좌: GROUP INFO(전체높이) | 우: 상단 USER INFO + 하단 DIVISION */}
      <div className={styles.contents}>
        <div className={styles.leftCol}>
          <TitleArea isSubTitle title={t('LBL00357', 'Group Info')} depth='h4' />
          <GroupUserMainGrid
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            data={mainData?.o_rc1 ?? []}
            onFocus={() => (activeSheetRef.current = SHEETS.MAIN)}
          />
        </div>
        <div className={styles.rightCol}>
          <div className={styles.rightTop}>
            <TitleArea isSubTitle title={t('LBL00658', 'User Info')} depth='h4' />
            <GroupUserInfoGrid
              gridRef={userGridRef}
              gridFilterRef={userGridFilterRef}
              data={userData?.o_rc1 ?? []}
              onFocus={() => (activeSheetRef.current = SHEETS.USER_INFO)}
            />
          </div>
          <div className={styles.rightBottom}>
            <div className={styles.module}>
              <TitleArea isSubTitle title={t('LBL00641', 'Division')} depth='h4' />
              <GroupUserUnitGrid
                gridRef={divisionGridRef}
                gridFilterRef={divisionGridFilterRef}
                data={divisionData?.o_rc1 ?? []}
                staticColumns={staticColumns[SHEETS.DIVISION]}
                onFocus={() => (activeSheetRef.current = SHEETS.DIVISION)}
              />
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
