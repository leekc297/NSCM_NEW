import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { useQueryClient } from '@foundation/query-client';
import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import { useContributeMainStore } from '../useContributeMainStore';

import styles from './VersionPopup.module.scss';

// AS-IS Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/POPUP/DMF0043_ContributeRatePopup.cs
//   - Designer.cs:326 — Form Text = "기여율 버전관리"
//   - FindData (.cs L194): DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP(p_yyyy)
//   - SaveData (.cs L240): DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (^ 구분 string bulk)
//   - InsertButton (.cs L308): siMain.Insert() + LockRange(VER_SEQ) — VER_SEQ 자동 채번
//   - DeleteButton (.cs L171): siMain.Delete()
// 2026-06-11: 사용자 요구 — EDIT 토글 제거. 항상 편집 가능 모드 + 추가/삭제/저장 즉시 동작

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

const isDirty = (r: VersionRow): boolean =>
  r.EDIT_FLAG === 'I' || r.EDIT_FLAG === 'U' || r.EDIT_FLAG === 'D';

const CREATED_BY = 'minyonglee1';

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
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGridType<VersionRow> | null>(null);
  const deletedRowsRef = useRef<VersionRow[]>([]);

  const [selectedYear, setSelectedYear] = useState<string>('');
  const [rows, setRows] = useState<VersionRow[]>([]);

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

  const { data: rateData, refetch } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.RATE_POPUP,
    tabId: MENU_ID,
    filters: { yyyy: selectedYear },
    enabled: open && !!selectedYear,
  });

  // ⚠️ useProcMutation array payload BE unfold 안 됨 (모든 IN NULL) → apiClient.post 직접 호출
  // (ContributeMain.tsx handleSave line 161~ 동일 패턴)

  // popup open + Year 콤보 default — AS-IS 의 yearPopup SP 첫 항목 ('ALL') 자동 선택
  // 'ALL' 선택 시 RATE_POPUP SP 가 전체 version 반환 (2019~2024 6 rows)
  useEffect(() => {
    if (!open) return;
    if (yearOptions.length === 0) return;
    if (selectedYear) return;
    const first = yearOptions[0];
    const code = String(first.CODE ?? first.NAME ?? '').trim();
    if (code) setSelectedYear(code);
  }, [open, yearOptions, selectedYear]);

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

  useEffect(() => {
    if (!open) {
      setSelectedYear('');
      setRows([]);
      deletedRowsRef.current = [];
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const handleFind = () => {
    if (!selectedYear) {
      void setAlert({ type: 'alert', content: 'Year 를 선택해주세요. (MSG00019)' });
      return;
    }
    void refetch?.();
  };

  const handleInsert = () => {
    // AS-IS .cs L308: siMain.Insert() — YYYY default 없이 빈 row 추가, 사용자가 grid 에서 직접 입력
    // 2026-06-11: selectedYear 가 4자리 숫자면 default 로 사용 (편의), 그 외 ('ALL' 등) 는 빈 값
    const defaultYYYY = /^\d{4}$/.test(selectedYear) ? selectedYear : '';
    const newRow: VersionRow = {
      VER_SEQ: '',
      YYYY: defaultYYYY,
      VERSION_NM: '',
      VALID_YN: 'Y',
      DESCRIPTION: '',
      EDIT_FLAG: 'I',
    };
    setRows(prev => [newRow, ...prev]);
    // wijmo 신규 row top 의 첫 editable cell (YYYY col 1) 자동 editing 시작
    setTimeout(() => {
      const g = gridRef.current;
      if (g) {
        g.select(0, 1);
        g.startEditing(true);
      }
    }, 50);
  };

  const handleDelete = () => {
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
          if (r.EDIT_FLAG === 'I') continue;
          deletedRowsRef.current.push({ ...r, EDIT_FLAG: 'D' });
          continue;
        }
        after.push(r);
      }
      return after;
    });
  };

  const handleSave = async () => {
    // wijmo: 진행 중 cell edit 강제 commit — cell 수정 후 Enter 안 누른 채 저장 클릭 시
    // row.binding=value 미반영 사고 방지 (사용자 신규 row 입력 흐름)
    gridRef.current?.finishEditing();
    // rows state + wijmo collectionView items 둘 다 source 로 사용 — 최신 신규 row 반영 보장
    const cvItems = (gridRef.current?.collectionView?.items as VersionRow[] | undefined) ?? [];
    const sourceRows = cvItems.length > rows.length ? cvItems : rows;
    const dirty = [...sourceRows.filter(isDirty), ...deletedRowsRef.current];
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '변경된 항목이 없습니다.' });
      return;
    }

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

    const ok = await setAlert({ type: 'confirm', content: `${dirty.length}건을 저장하시겠습니까? (MSG00004)` });
    if (!ok) return;

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

    // ContributeMain.tsx handleSave 와 동일 패턴 — top-level fields 직접 전달
    try {
      await apiClient.post(`/${MENU_ID}/version/SAVE/call-proc`, {
        activeFlag: trim(buf.activeFlag),
        verSeq: trim(buf.verSeq),
        yyyy: trim(buf.yyyy),
        versionNm: trim(buf.versionNm),
        description: trim(buf.description),
        validYn: trim(buf.validYn),
        createdBy: trim(buf.createdBy),
      });
      // (1) 화면 특화
      deletedRowsRef.current = [];
      // (2) invalidate — RATE_POPUP / YEAR_POPUP / 메인 grid version 콤보 등 DMF0043 전체
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      // (3) toast
      void setAlert({ type: 'alert', content: '저장이 완료되었습니다.' });
      // (4) refetch — 현재 popup 의 RATE_POPUP 즉시 force fetch
      void refetch?.();
    } catch {
      void setAlert({ type: 'alert', content: '저장 중 오류가 발생했습니다.' });
    }
  };

  const headerTitle = (
    <div className='headerContainer'>
      <div className='headerDot' />
      <h2 className='headerTitle'>기여율 버전관리</h2>
    </div>
  );

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
          <div className={styles.filterBar}>
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Year</span>
              <select
                className={styles.yearSelect}
                value={selectedYear}
                onChange={e => setSelectedYear(e.target.value)}
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
            >
              조회
            </button>
          </div>

          <div className={styles.gridWrapper}>
            <FlexGrid
              initialized={(g: FlexGridType<VersionRow>) => {
                gridRef.current = g;
                g.allowAddNew = false;
                g.allowDelete = false;
                g.isReadOnly = false;
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

          {/* EDIT 토글 제거 (2026-06-11) — 추가/삭제/저장 항상 동작 */}
          <div className={styles.actionBar}>
            <button
              type='button'
              className={styles.actionButton}
              onClick={handleInsert}
            >
              추가
            </button>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.danger}`}
              onClick={handleDelete}
            >
              삭제
            </button>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={() => void handleSave()}
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
