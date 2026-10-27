import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps, RawFlexGridColumnConfig } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SsoUserModal, type SsoUserRow, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { GroupUserInfoGrid } from './components/GroupUserInfoGrid';
import { GroupUserMainGrid } from './components/GroupUserMainGrid';
import { GroupUserUnitGrid } from './components/GroupUserUnitGrid';
import { DivisionModal } from './components/modals/DivisionModal';
import { MENU_ID, SHEETS, UNIT_TP_CD } from './group-user.constants';
import type { DivisionPopupRow } from './group-user.types';
import styles from './GroupUser.module.scss';
import { useGroupUserStore } from './useGroupUserStore';

type UnitRow = ResponseData<MENU_ID, SHEETS.DIVISION>;

const collectRowsWithSheet = (
  grid: FlexGrid | undefined,
  sheetName: string,
  extra: Record<string, unknown> = {}
): WijmoRowItem[] => {
  if (!grid) return [];
  const rows: WijmoRowItem[] = [];
  for (const element of grid.rows) {
    const item = element?.dataItem as (WijmoRowItem & { CRUD_TYPE?: string }) | undefined;
    if (!item?.CRUD_TYPE) continue;
    rows.push({ ...item, ...extra, SHT_NM: sheetName } as WijmoRowItem);
  }
  return rows;
};

// 공백만 있는 값도 미입력으로 본다 (useSaveWithValidation.isBlank 와 같은 규칙).
const isBlank = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

// UserInfo 행 필수값 — USER_ID, USER_NM (2026-10-08 사용자 결정: 화면 단에서만 막는다).
//   종전엔 화면·저장 SP 어디에도 필수 검사가 없고, 대상 컬럼이 DEFAULT ON NULL '-' 라 빈 값이 '-' 로 저장됐다.
//   헤더의 빨간 점은 칸 메타 INPUT_TP_CD='IM' 을 공용 DataGrid 가 그린 표시일 뿐이고, 저장 전 검증은 화면이
//   useSaveWithValidation 을 부르거나 직접 검사해야 동작한다 — 이 화면은 useProcMutation 을 바로 불러 통과됐다.
//   USER_NM 은 메타가 'S' 라 공용 훅(IM 기준)으로는 잡히지 않아 두 컬럼을 여기서 직접 본다.
const USER_INFO_REQUIRED: ReadonlyArray<{ colNm: string; fallbackLabel: string }> = [
  { colNm: 'USER_ID', fallbackLabel: 'User ID' },
  { colNm: 'USER_NM', fallbackLabel: 'User Name' },
];

/** 필수값이 빈 첫 컬럼의 화면 라벨(없으면 undefined). 라벨은 칸 메타 colLblNm 우선 — 헤더에서 본 이름과 같게. */
const findMissingUserRequired = (
  rows: WijmoRowItem[],
  columns: RawFlexGridColumnConfig[] | undefined
): string | undefined => {
  for (const row of rows) {
    const missing = USER_INFO_REQUIRED.find(c => isBlank(row[c.colNm]));
    if (missing) {
      return columns?.find(c => c.colNm === missing.colNm)?.colLblNm || missing.fallbackLabel;
    }
  }
  return undefined;
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

  const filters = useGroupUserStore(state => state.filters);
  const setMainFilter = useGroupUserStore(state => state.setMainFilter);
  const fetchStaticColumns = useGroupUserStore(state => state.fetchStaticColumns);
  const userInfoColumns = useGroupUserStore(state => state.staticColumns[SHEETS.USER_INFO]);
  const selectedUserGrId = useGroupUserStore(state => state.selectedUserGrId);
  const selectedUserId = useGroupUserStore(state => state.selectedUserId);

  const focusSheet = useGroupUserStore(state => state.focusSheet);

  const [openDivisionModal, setOpenDivisionModal] = useState<boolean>(false);
  // UserInfo 행 추가용 사용자 찾기 팝업(멀티 선택) — AS-IS InsertRow(GroupUserInfo.cs L786~811)가
  //   UserInfoPopup 을 먼저 띄우고 SelectedUserInfoList 전부를 행으로 넣던 동작.
  const [openUserInsertModal, setOpenUserInsertModal] = useState<boolean>(false);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: SHEETS.MAIN,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.USER_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_INFO,
    tabId: SHEETS.USER_INFO,
    filters: filters[SHEETS.USER_INFO],
    enabled: !!filters[SHEETS.USER_INFO],
  });
  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId: SHEETS.DIVISION,
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
    if (focusSheet === SHEETS.USER_INFO) {
      if (!selectedUserGrId) {
        void setAlert({ type: 'alert', content: t('MSG00625', '_먼저 Group 을 선택해 주십시오.') });
        return;
      }
      // 빈 행을 넣지 않고 사용자 찾기 팝업을 먼저 띄운다 — 고른 사람 전부가 행으로 들어간다
      //   (2026-10-08 통합테스트 지적 "한 명씩 되풀이", AS-IS 1:1). 종전엔 빈 행 추가 후 User ID 칸 더블클릭으로 1명씩.
      if (userGridRef.current) setOpenUserInsertModal(true);
      return;
    }
    if (focusSheet === SHEETS.DIVISION) {
      if (!selectedUserGrId || !selectedUserId) {
        void setAlert({
          type: 'alert',
          content: t('MSG00626', '_먼저 Group 과 User 를 선택해 주십시오.'),
        });
        return;
      }
      if (divisionGridRef.current) {
        setOpenDivisionModal(true);
      }
      return;
    }
    if (mainGridRef.current) GridAction.addRow(mainGridRef.current, { USE_YN: 'Y' });
  };
  const onDelete = () => {
    if (focusSheet === SHEETS.USER_INFO) {
      if (userGridRef.current) GridAction.removeRow(userGridRef.current, false);
      return;
    }
    if (focusSheet === SHEETS.DIVISION) {
      if (divisionGridRef.current) GridAction.removeRow(divisionGridRef.current, false);
      return;
    }
    if (mainGridRef.current) GridAction.removeRow(mainGridRef.current, false);
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

    // UserInfo 필수값(User ID / User Name) 미입력 차단 — 신규·수정 행 모두. 첫 1건만 알린다.
    //   문구는 공용 저장 검증과 같은 MSG00429 "{0} 값은 필수 입력 항목입니다."
    const missingLabel = findMissingUserRequired(userRows, userInfoColumns);
    if (missingLabel) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${missingLabel}]`
        ),
      });
      return;
    }

    mutateSave(payload as ResponseData<MENU_ID, SHEETS.MAIN>[], {
      onSuccess: () => {
        // 데이터가 변경된 그리드만 다시 조회 할 수 있도록 처리
        if (mainRows.length > 0) {
          void queryClient.invalidateQueries({ queryKey: [SHEETS.MAIN] });
        }
        if (userRows.length > 0) {
          void queryClient.invalidateQueries({ queryKey: [SHEETS.USER_INFO] });
        }
        if (divRows.length > 0) {
          void queryClient.invalidateQueries({ queryKey: [SHEETS.DIVISION] });
        }
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

  const closeDivisionModal = () => {
    setOpenDivisionModal(false);
  };

  // 사용자 찾기 팝업(멀티) OK — 선택한 사용자마다 UserInfo 신규 행 1개 (AS-IS InsertRow defaultData 1:1:
  //   GroupID / UserID / UserName / UserName_E / Dept_Name / UseYN='Y'). 이미 그리드에 있는 USER_ID 는 건너뛴다
  //   (SCM_ADM_USER_GR_MPG_M PK = USER_GR_ID + USER_ID — 중복이면 저장이 깨진다). 삭제 표시(D)된 기존 행을
  //   다시 고르면 삭제를 취소한다(Division 팝업 selectDivisionModal 과 같은 규칙).
  const insertUsersFromModal = (users: SsoUserRow[]) => {
    const grid = userGridRef.current;
    if (!grid) return;
    const collection = grid.collectionView.sourceCollection as Array<{
      USER_ID?: string;
      CRUD_TYPE?: string;
    }>;
    const pickedIds = new Set(users.map(u => String(u.USER_ID)));
    collection.forEach(item => {
      if (item.CRUD_TYPE === 'D' && item.USER_ID && pickedIds.has(String(item.USER_ID))) {
        item.CRUD_TYPE = '';
      }
    });
    const existingIds = new Set(collection.map(item => String(item.USER_ID ?? '')));
    const newRows = users
      .filter(u => !existingIds.has(String(u.USER_ID)))
      .map(u => ({
        USER_GR_ID: selectedUserGrId,
        USER_ID: u.USER_ID,
        USER_NM: u.USER_NM,
        USER_ENG_NM: u.USER_ENG_NM,
        DEPT_NM: u.DEPT_NM,
        USE_YN: 'Y',
      }));
    // 한 번에 splice — 행마다 addRow 를 부르면 앵커가 갱신되지 않아 삽입 순서가 선택 순서와 어긋난다(addRowSet 주석).
    if (newRows.length > 0) GridAction.addRowSet(grid, newRows as never);
    grid.collectionView.refresh();
  };

  const selectDivisionModal = (divisionList: DivisionPopupRow[]) => {
    if (divisionGridRef.current) {
      const collectionView = divisionGridRef.current.collectionView;
      const collection = collectionView.sourceCollection as UnitRow[];

      // 팝업에서 선택한 값 중에 삭제 대상으로 지정한 데이터가 있으면 삭제를 취소하는 것으로 판단하여 삭제 플래스 삭제.
      collection.forEach(item => {
        if (item.CRUD_TYPE === 'D') {
          divisionList.forEach(div => {
            if (item.UNIT_ID === div.CODE && item.UNIT_NM === div.NAME) {
              item.CRUD_TYPE = '';
            }
          });
        }
      });

      const excludeIds = new Set(collection.map(item => item.UNIT_ID));
      const newDivisionList = divisionList.filter(div => !excludeIds.has(div.CODE));

      for (const newDiv of newDivisionList) {
        GridAction.addRow(divisionGridRef.current, {
          USER_GR_ID: selectedUserGrId,
          USER_ID: selectedUserId,
          UNIT_TP_CD: UNIT_TP_CD.DIVISION,
          UNIT_ID: newDiv.CODE,
          UNIT_NM: newDiv.NAME,
          UPPR_UNIT_ID: '-',
          EDIT_YN: 'Y',
          USE_YN: 'Y',
        });
      }
    }
    setOpenDivisionModal(false);
  };

  const GroupGrid = useMemo(() => {
    return (
      <GroupUserMainGrid
        gridRef={mainGridRef}
        gridFilterRef={mainGridFilterRef}
        data={mainData?.o_rc1 ?? []}
      />
    );
  }, [mainGridRef, mainGridFilterRef, mainData]);

  const UserGrid = useMemo(() => {
    return (
      <GroupUserInfoGrid
        gridRef={userGridRef}
        gridFilterRef={userGridFilterRef}
        data={userData?.o_rc1 ?? []}
      />
    );
  }, [userGridRef, userGridFilterRef, userData]);

  const DivisionGrid = useMemo(() => {
    return (
      <GroupUserUnitGrid
        gridRef={divisionGridRef}
        gridFilterRef={divisionGridFilterRef}
        data={divisionData?.o_rc1 ?? []}
      />
    );
  }, [divisionGridRef, divisionGridFilterRef, divisionData]);

  const getGridRef = () => {
    if (focusSheet === SHEETS.DIVISION) {
      return divisionGridRef;
    } else if (focusSheet === SHEETS.USER_INFO) {
      return userGridRef;
    } else {
      return mainGridRef;
    }
  };

  const getGridFilterRef = () => {
    if (focusSheet === SHEETS.DIVISION) {
      return divisionGridFilterRef;
    } else if (focusSheet === SHEETS.USER_INFO) {
      return userGridFilterRef;
    } else {
      return mainGridFilterRef;
    }
  };

  // 건수는 각 영역 제목 줄에 따로 표시한다 — 3개 그리드가 동시에 보이는 화면이라 상단 툴바
  // 줄의 건수 배지가 어느 그리드를 가리키는지 모호해지므로 숨기고, 영역별로 나눠 표시한다
  // (AuthRequest.tsx / Lookup.tsx 와 동일 패턴).
  const groupCount = mainData?.o_rc1?.length ?? 0;
  const userCount = userData?.o_rc1?.length ?? 0;
  const divisionCount = divisionData?.o_rc1?.length ?? 0;

  return (
    <>
      {/* 화면 설계 확정 — 상단 검색조건 없음 + 그리드 헤더 버튼 없음 */}
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <SubTitle
        menuId={MENU_ID}
        grid={getGridRef()}
        gridFilter={getGridFilterRef()}
        dataCount={groupCount}
        hideTotalCases
        excelFileName='GroupUser'
        hotkeyConfig={hotkeyConfig}
      />
      {/* 좌: GROUP INFO(전체높이) | 우: 상단 USER INFO + 하단 DIVISION */}
      <div className={styles.contents}>
        <div className={styles.leftCol}>
          <TitleArea
            isSubTitle
            title={t('LBL00357', 'Group Info')}
            depth='h4'
            totalCases={groupCount === 0 ? undefined : groupCount}
          />
          {GroupGrid}
        </div>
        <div className={styles.rightCol}>
          <div className={styles.rightTop}>
            <TitleArea
              isSubTitle
              title={t('LBL00658', 'User Info')}
              depth='h4'
              totalCases={userCount === 0 ? undefined : userCount}
            />
            {UserGrid}
          </div>
          <div className={styles.rightBottom}>
            <div className={styles.module}>
              <TitleArea
                isSubTitle
                title={t('LBL00641', 'Division')}
                depth='h4'
                totalCases={divisionCount === 0 ? undefined : divisionCount}
              />
              {DivisionGrid}
            </div>
          </div>
        </div>
        <DivisionModal
          open={openDivisionModal}
          onClose={closeDivisionModal}
          onSelect={selectDivisionModal}
        />
        {/* UserInfo 행 추가 — 사용자 찾기(멀티 체크) 후 선택 전부 행으로. 등록 사용자(ssoUserYn='N') 기준은
            GroupUserInfoGrid 의 단건 팝업과 동일. setSelectedValue 는 멀티 모드에서 호출되지 않지만 필수 prop. */}
        <SsoUserModal
          open={openUserInsertModal}
          modalClose={() => setOpenUserInsertModal(false)}
          multiCheckbox
          setSelectedValues={insertUsersFromModal}
          setSelectedValue={() => undefined}
          ssoUserYn='N'
        />
      </div>
    </>
  );
};
