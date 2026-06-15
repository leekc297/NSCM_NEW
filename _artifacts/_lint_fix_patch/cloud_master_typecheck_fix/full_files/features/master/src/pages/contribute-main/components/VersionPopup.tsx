import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import { useContributeMainStore } from '../useContributeMainStore';

import styles from './VersionPopup.module.scss';

// AS-IS Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/POPUP/DMF0043_ContributeRatePopup.cs
//   - Designer.cs:326 — Form Text = "기여율 버전관리"
//   - InitSpread: DM.DMF0000_GET_COMMON_SPREAD_TITLE (sheet "ContributeRate", division "40")
//   - InitControls + GetYearData: DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP — Year listbox
//   - FindData (.cs L194): DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP(p_yyyy)
//   - SaveData (.cs L240): DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (^ 구분 string bulk)
//   - EditButton (.cs L174): siMain.SwitchLock() + LockColumn(0, VER_SEQ, true)  — VER_SEQ 까지 잠금 유지
//   - InsertButton (.cs L308): siMain.Insert() + LockRange(VER_SEQ) — 신규 행은 VER_SEQ 가 자동 채번
//   - DeleteButton (.cs L171): siMain.Delete()
//   - 권한 (.cs L111): NowGroupID in {ADMIN, DM ADMIN} → Edit/Insert/Save/Delete 가시. 그 외 hidden
//     → TODO: 현재 단순화로 항상 표시. 세션 권한 hook 후 분기 (룰 11 AUTH_SECURITY)

// 5 컬럼 정의 (.cs L57~61). VALID_YN 은 아래 VALID_YN_MAP 으로 dataMap 부여.
const COLUMN_DEFS = [
  { binding: 'VER_SEQ', header: 'Ver Seq', width: 90, readOnly: true },
  { binding: 'YYYY', header: 'Year', width: 90, readOnly: false },
  { binding: 'VERSION_NM', header: '버전명', width: 220, readOnly: false },
  { binding: 'VALID_YN', header: '유효여부', width: 90, readOnly: false },
  { binding: 'DESCRIPTION', header: '설명', width: 320, readOnly: false },
] as const;

interface VersionRow {
  VER_SEQ?: string | number;
  YYYY?: string;
  VERSION_NM?: string;
  VALID_YN?: string;
  DESCRIPTION?: string;
  EDIT_FLAG?: 'I' | 'U' | 'D' | '';
}

interface YearOption {
  CODE?: string | number;
  NAME?: string;
  NAME2?: string;
}

// AS-IS .cs L257: GetText(i, StringAction) == "" → continue (= EDIT_FLAG 미설정 행 skip)
// AS-IS .cs L255~273: 모든 dirty 행을 ^ 구분 string 으로 누적 → SAVE SP 1회 호출
const isDirty = (r: VersionRow): boolean =>
  r.EDIT_FLAG === 'I' || r.EDIT_FLAG === 'U' || r.EDIT_FLAG === 'D';

// TODO: 세션 userId 로 교체. 현재 로컬 minyonglee1 하드코딩.
const CREATED_BY = 'minyonglee1';

// VALID_YN 콤보 DataMap — Y/N 만 입력 가능
const VALID_YN_MAP = new DataMap(
  [
    { CODE: 'Y', NAME: 'Y' },
    { CODE: 'N', NAME: 'N' },
  ],
  'CODE',
  'NAME'
);

export const VersionPopup = () => {
  const open = useContributeMainStore(s => s.versionPopupOpen);
  const setOpen = useContributeMainStore(s => s.setVersionPopupOpen);
  const setAlert = useMessageStore(s => s.setAlert);

  const gridRef = useRef<FlexGridType<VersionRow> | null>(null);
  // 삭제된 기존 행 (EDIT_FLAG='D') 보관 — Save 시 함께 전송
  // (INSERT 행은 화면에서 즉시 drop, 기존 행은 화면에서 hide + ref 에 누적)
  const deletedRowsRef = useRef<VersionRow[]>([]);

  const [selectedYear, setSelectedYear] = useState<string>('');
  const [editMode, setEditMode] = useState<boolean>(false);
  // Wijmo itemsSource 는 자체적으로 mutable 한 array — local rows state 로 추가/삭제/수정 관리
  const [rows, setRows] = useState<VersionRow[]>([]);

  // AS-IS InitControls + GetYearData (.cs L99, L371): Year 콤보 데이터
  const { data: yearData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.YEAR_POPUP,
    tabId: MENU_ID,
    filters: {},
    enabled: open,
  });

  const yearOptions = useMemo<YearOption[]>(
    () => (yearData?.o_rc1 ?? []) as unknown as YearOption[],
    [yearData]
  );

  // AS-IS FindData (.cs L194): DMF0043_GET_CONTRIBUTE_RATE_POPUP(p_yyyy)
  // sheet 매핑: ratePopup → P_DMF0043_RATE_GET → DMF0043_GET_CONTRIBUTE_RATE_POPUP
  const { data: rateData, refetch } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.RATE_POPUP,
    tabId: MENU_ID,
    filters: { yyyy: selectedYear },
    enabled: open && !!selectedYear,
  });

  // AS-IS SaveData (.cs L240): DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
  //   → sheet `version` 의 SAVE 액션 라우팅 (BE: P_DMF0043_VERSION_SAVE)
  const { mutate: saveVersion } = useProcMutation({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
  });

  // AS-IS .cs L84: Form_Load → FindData()  → Year 옵션 첫 항목 자동 선택
  useEffect(() => {
    if (!open) return;
    if (yearOptions.length === 0) return;
    if (selectedYear) return;
    const first = yearOptions[0];
    // ⛔ Oracle NUMBER → JS number 자동 변환 위험 (메모: feedback_no_type_cast_around_runtime).
    //   <select value> + setSelectedYear filter 모두 string 강제.
    const v = String(first.NAME2 ?? first.NAME ?? first.CODE ?? '');
    if (v) setSelectedYear(v.substring(0, 4));
  }, [open, yearOptions, selectedYear]);

  // 조회 결과 → rows state 동기화. EDIT_FLAG 초기화.
  useEffect(() => {
    const o = (rateData?.o_rc1 ?? []) as VersionRow[];
    setRows(
      o.map(r => ({
        ...r,
        VER_SEQ: r.VER_SEQ != null ? String(r.VER_SEQ) : '',
        YYYY: r.YYYY != null ? String(r.YYYY) : selectedYear,
        EDIT_FLAG: '',
      }))
    );
  }, [rateData, selectedYear]);

  // popup close 시 상태 초기화 — 다음 open 시 깨끗한 상태
  useEffect(() => {
    if (!open) {
      setEditMode(false);
      setSelectedYear('');
      setRows([]);
      deletedRowsRef.current = [];
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // AS-IS EditButton (.cs L174): siMain.SwitchLock() + LockColumn(0, VER_SEQ, true)
  //   → editMode 토글. VER_SEQ 는 readOnly 영구 유지 (COLUMN_DEFS).
  //   Wijmo: column.isReadOnly 를 editMode 따라 동적 변경.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    COLUMN_DEFS.forEach(def => {
      const col = g.columns.getColumn(def.binding);
      if (!col) return;
      if (def.readOnly) {
        col.isReadOnly = true; // VER_SEQ 영구 lock
      } else {
        col.isReadOnly = !editMode;
      }
    });
    g.invalidate();
  }, [editMode, rows]);

  // AS-IS btnButtonList Find (.cs L335): FindButton → FindData
  const handleFind = () => {
    if (!selectedYear) {
      // AS-IS .cs L200: MessageHelper.GMessageBox("MSG00019") — Year 미선택
      void setAlert({ type: 'alert', content: 'Year 를 선택해주세요. (MSG00019)' });
      return;
    }
    void refetch?.();
  };

  // AS-IS InsertButton (.cs L308): siMain.Insert() + LockRange(VER_SEQ)
  //   → 신규 행 추가. EDIT_FLAG='I'. VER_SEQ 는 SP 에서 자동 채번.
  const handleInsert = () => {
    // AS-IS .cs L310: if (IsLock(...) == false) → editMode 인 경우만 활성
    if (!editMode) {
      void setAlert({
        type: 'alert',
        content: 'Edit 모드에서만 행 추가가 가능합니다. (MSG00266 동등)',
      });
      return;
    }
    const newRow: VersionRow = {
      VER_SEQ: '',
      YYYY: selectedYear,
      VERSION_NM: '',
      VALID_YN: 'Y',
      DESCRIPTION: '',
      EDIT_FLAG: 'I',
    };
    setRows(prev => [newRow, ...prev]);
  };

  // AS-IS DeleteButton (.cs L169): siMain.Delete()
  //   → 선택 행 EDIT_FLAG='D'. INSERT 행은 즉시 drop, 기존 행은 hide + ref staging.
  const handleDelete = () => {
    if (!editMode) {
      void setAlert({ type: 'alert', content: 'Edit 모드에서만 행 삭제가 가능합니다.' });
      return;
    }
    const g = gridRef.current;
    if (!g) return;
    const selected = g.selectedItems;
    if (!selected || selected.length === 0) {
      void setAlert({ type: 'alert', content: '삭제할 행을 선택해주세요.' });
      return;
    }
    const targets = new Set(selected as VersionRow[]);
    setRows(prev => {
      const after: VersionRow[] = [];
      for (const r of prev) {
        if (targets.has(r)) {
          // INSERT 행: 서버 미반영 상태 → 그냥 drop
          if (r.EDIT_FLAG === 'I') continue;
          // 기존 행: D 마킹하여 ref staging — Save 시 함께 전송
          deletedRowsRef.current.push({ ...r, EDIT_FLAG: 'D' });
          continue;
        }
        after.push(r);
      }
      return after;
    });
  };

  // AS-IS Dsdm_Changed equivalent: cellEditEnded → EDIT_FLAG = 'U' 마킹 (단, INSERT 행은 'I' 유지)
  // ContributeMainGrid 와 동일 패턴 — initialized 콜백 안에서 addHandler.

  // AS-IS SaveData (.cs L240): ^ 구분 string bulk
  //   .cs L257: StringAction (EDIT_FLAG) 미설정 행 skip
  //   .cs L261~272: 모든 dirty 셀을 ^ 누적
  //   .cs L280~286: Remove(0,1) 로 leading ^ 제거 후 SP 호출
  const handleSave = async () => {
    if (!editMode) {
      void setAlert({ type: 'alert', content: 'Edit 모드에서만 저장이 가능합니다.' });
      return;
    }
    const dirty = [...rows.filter(isDirty), ...deletedRowsRef.current];
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '변경된 항목이 없습니다.' });
      return;
    }

    // 단순 validation: VERSION_NM 필수 + YYYY 4자리 (Insert/Update 만)
    for (const r of dirty) {
      if (r.EDIT_FLAG === 'D') continue;
      if (!r.YYYY || String(r.YYYY).length !== 4) {
        void setAlert({ type: 'alert', content: 'Year(YYYY) 는 4자리 숫자여야 합니다.' });
        return;
      }
      if (!r.VERSION_NM || String(r.VERSION_NM).trim() === '') {
        void setAlert({ type: 'alert', content: '버전명을 입력해주세요.' });
        return;
      }
      if (r.VALID_YN !== 'Y' && r.VALID_YN !== 'N') {
        void setAlert({ type: 'alert', content: '유효여부는 Y 또는 N 이어야 합니다.' });
        return;
      }
    }

    // AS-IS .cs L298: MSG00004 — 저장 전 확인
    const ok = await setAlert({ type: 'confirm', content: `${dirty.length}건을 저장하시겠습니까? (MSG00004)` });
    if (!ok) return;

    // AS-IS .cs L261~272: ^ 구분 누적 (각 행을 한 ^ 토큰으로)
    const buf = {
      activeFlag: '',
      verSeq: '',
      yyyy: '',
      versionNm: '',
      description: '',
      validYn: '',
      createdBy: '',
    };
    dirty.forEach(r => {
      buf.activeFlag += '^' + (r.EDIT_FLAG ?? '');
      buf.verSeq += '^' + String(r.VER_SEQ ?? '');
      buf.yyyy += '^' + String(r.YYYY ?? '');
      buf.versionNm += '^' + String(r.VERSION_NM ?? '');
      buf.description += '^' + String(r.DESCRIPTION ?? '');
      buf.validYn += '^' + String(r.VALID_YN ?? 'Y');
      buf.createdBy += '^' + CREATED_BY;
    });

    const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);

    saveVersion(
      [
        {
          activeFlag: trim(buf.activeFlag),
          verSeq: trim(buf.verSeq),
          yyyy: trim(buf.yyyy),
          versionNm: trim(buf.versionNm),
          description: trim(buf.description),
          validYn: trim(buf.validYn),
          createdBy: trim(buf.createdBy),
        },
      ] as unknown as (WijmoRowItem & { CRUD_TYPE?: string })[],
      {
        onSuccess: () => {
          void setAlert({ type: 'alert', content: '저장이 완료되었습니다.' });
          deletedRowsRef.current = [];
          setEditMode(false);
          void refetch?.();
        },
        onError: () => {
          void setAlert({ type: 'alert', content: '저장 중 오류가 발생했습니다.' });
        },
      }
    );
  };

  // AS-IS Designer.cs L326: Form.Text = "기여율 버전관리"
  const headerTitle = (
    <div className='headerContainer'>
      <div className='headerDot' />
      <h2 className='headerTitle'>기여율 버전관리</h2>
    </div>
  );

  // visible rows (D 마킹 행 제외 — INSERT 는 표시)
  const visibleRows = useMemo(() => rows.filter(r => r.EDIT_FLAG !== 'D'), [rows]);

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={() => setOpen(false)}
      disableButtonCancel
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContent}>
          {/* AS-IS clbYear (Designer.cs L188): Year ComboBox */}
          <div className={styles.filterBar}>
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Year</span>
              <select
                className={styles.yearSelect}
                value={selectedYear}
                onChange={e => setSelectedYear(e.target.value)}
                disabled={editMode}
              >
                <option value=''>선택</option>
                {yearOptions.map(o => {
                  const v = String(o.NAME2 ?? o.NAME ?? o.CODE ?? '').substring(0, 4);
                  return v ? (
                    <option key={String(o.CODE ?? v)} value={v}>
                      {v}
                    </option>
                  ) : null;
                })}
              </select>
            </div>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={handleFind}
              disabled={editMode}
            >
              조회
            </button>
          </div>

          {/* AS-IS spdMain (Designer.cs L265): FpSpread → Wijmo FlexGrid */}
          <div className={styles.gridWrapper}>
            <FlexGrid
              initialized={(g: FlexGridType<VersionRow>) => {
                gridRef.current = g;
                g.allowAddNew = false;
                g.allowDelete = false;
                g.isReadOnly = false; // 컬럼 단위로 isReadOnly 제어
                // AS-IS Dsdm_Changed: cell edit 종료 시 EDIT_FLAG='U' 마킹
                g.cellEditEnded.addHandler((_s, e) => {
                  const row = g.rows[e.row]?.dataItem as VersionRow | undefined;
                  if (!row) return;
                  if (row.EDIT_FLAG === 'I' || row.EDIT_FLAG === 'D') return;
                  row.EDIT_FLAG = 'U';
                });
              }}
              itemsSource={visibleRows}
              autoGenerateColumns={false}
              style={{ height: '100%' }}
            >
              {COLUMN_DEFS.map(def => (
                <FlexGridColumn
                  key={def.binding}
                  binding={def.binding}
                  header={def.header}
                  width={def.width}
                  isReadOnly={def.readOnly}
                  dataMap={def.binding === 'VALID_YN' ? VALID_YN_MAP : undefined}
                />
              ))}
            </FlexGrid>
          </div>

          {/* AS-IS btnButtonList (Designer.cs L109): Find / Edit / Insert / Save / Delete / Close */}
          <div className={styles.actionBar}>
            {editMode && <span className={styles.modeIndicator}>● Edit 모드</span>}
            <button
              type='button'
              className={`${styles.actionButton} ${editMode ? styles.editActive : styles.edit}`}
              onClick={() => setEditMode(prev => !prev)}
              title='Edit 모드 토글 (AS-IS siMain.SwitchLock)'
            >
              {editMode ? 'Edit 해제' : 'Edit'}
            </button>
            <button
              type='button'
              className={styles.actionButton}
              onClick={handleInsert}
              disabled={!editMode}
            >
              추가
            </button>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.danger}`}
              onClick={handleDelete}
              disabled={!editMode}
            >
              삭제
            </button>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={() => void handleSave()}
              disabled={!editMode}
            >
              저장
            </button>
            <button
              type='button'
              className={styles.actionButton}
              onClick={() => setOpen(false)}
            >
              닫기
            </button>
          </div>
        </div>
      }
    />
  );
};
