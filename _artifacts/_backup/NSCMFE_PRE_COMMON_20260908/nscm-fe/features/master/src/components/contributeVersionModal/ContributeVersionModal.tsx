import type { CollectionView } from '@mescius/wijmo';
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useContext, useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import {
  DialogScopeContext,
  useDialogStore,
  useMessageStore,
  useSessionStore,
} from '@shared/stores';

import {
  MODAL_SHEET_DATA,
  MODAL_SHEET_YEAR,
  MODAL_VERSION,
} from './contribute-version-modal.constants';
import styles from './ContributeVersionModal.module.scss';
import { useContributeVersionModalStore } from './contributeVersionModalStore';

// AS-IS POPUP/DMF0043_ContributeRatePopup.cs (Designer.cs L326 "기여율 버전관리").
// - FindData L194: DMF0043_GET_CONTRIBUTE_RATE_POPUP(p_yyyy)
// - SaveData L240: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (^ 구분 bulk string)
// - InsertButton L308: VER_SEQ 자동 채번 + 신규 row top edit
// - DeleteButton L171: 선택 row 즉시 삭제 (신규는 splice, 기존은 CRUD_TYPE=D 마킹)
// 2026-06-19: #67 표준 5 파일 lift + FlexGrid JSX 제거 + DataGrid + GridAction + EditTracker 사용.

interface VersionRow extends WijmoRowItem {
  VER_SEQ: string | number;
  YYYY: string;
  VERSION_NM: string;
  VALID_YN: string;
  DESCRIPTION: string;
}

interface YearOption extends WijmoRowItem {
  CODE: string | number;
  NAME: string;
  NAME2: string;
}

interface ContributeVersionModalProps {
  open: boolean;
  modalClose: () => void;
}

/**
 * 팝업 안 그리드 단축키 — F8 = Insert / F9 = Delete.
 * 일반 화면의 공용 SubTitle 단축키(Hotkeys.F8='insert' / F9='delete')와 같은 계약이며,
 * 버튼 라벨은 그대로 두고 동작만 키보드로도 열어준다.
 *
 * 필수: 이 컴포넌트는 다이얼로그 안(customContentArea)에서 렌더돼야 한다 —
 *   DialogScopeContext.Provider 가 CustomDialog 내부에 있어서(CustomDialog.tsx:243),
 *   모달 컴포넌트 본문에서 useContext 하면 스코프가 항상 null 이다.
 *
 * 스코프 가드가 있어야 부모 화면 SubTitle 의 F8/F9 와 겹치지 않는다. 부모 SubTitle 도 같은
 *   isActiveScope 로 걸러지므로(SubTitle.tsx:237) 이 팝업이 최상위일 때는 여기만 동작한다.
 *   공용 DataGrid 의 팝업 F3/F4 자동 등록(DataGrid.tsx:757)과 동일한 규약이다.
 *   선례: features/demand/.../sales-reports/components/modals/ExchangeRateModal.tsx (InsertHotkey).
 */
const GridHotkeys = ({ onInsert, onDelete }: { onInsert: () => void; onDelete: () => void }) => {
  const scopeId = useContext(DialogScopeContext);
  const handlersRef = useRef({ onInsert, onDelete });
  handlersRef.current = { onInsert, onDelete };

  useEffect(() => {
    const handler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key !== 'F8' && keyboardEvent.key !== 'F9') return;
      if (!useDialogStore.getState().isActiveScope(scopeId)) return;
      // 브라우저 기본 동작·상위 리스너 차단 (공용 F4 처리와 같은 캡처 단계 규약)
      keyboardEvent.preventDefault();
      keyboardEvent.stopImmediatePropagation();
      if (keyboardEvent.key === 'F8') handlersRef.current.onInsert();
      else handlersRef.current.onDelete();
    };
    globalThis.window.addEventListener('keydown', handler, true);
    return () => globalThis.window.removeEventListener('keydown', handler, true);
  }, [scopeId]);

  return null;
};

export const ContributeVersionModal = ({ open, modalClose }: ContributeVersionModalProps) => {
  const { t } = useTranslation();

  const staticColumns = useContributeVersionModalStore(s => s.staticColumns);
  const fetchStaticColumns = useContributeVersionModalStore(s => s.fetchStaticColumns);
  const selectedYear = useContributeVersionModalStore(s => s.selectedYear);
  const setSelectedYear = useContributeVersionModalStore(s => s.setSelectedYear);
  const noFilters = useContributeVersionModalStore(s => s.noFilters);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const sessionUserId = useSessionStore(s => s.session.userId ?? '');
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGrid<VersionRow> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const editTrackerRef = useRef<EditTracker<VersionRow> | undefined>();
  const savingRef = useRef(false);

  const { data: yearData } = useTabProcQuery<MODAL_VERSION>({
    menuId: MODAL_VERSION,
    sheetName: MODAL_SHEET_YEAR,
    tabId: MODAL_VERSION,
    filters: noFilters,
    enabled: open,
  });

  const yearOptions = useMemo<YearOption[]>(
    () => (yearData?.o_rc1 ?? []) as YearOption[],
    [yearData]
  );

  // useTabProcQuery 는 filters 참조가 바뀌면 캐시를 버리고 재조회한다. 인라인 리터럴로
  // 넘기면 selectedYear 가 그대로여도 이 컴포넌트가 리렌더될 때마다(staticColumns 갱신 등)
  // 새 참조가 생겨 그리드가 깜빡였다 — useMemo 로 참조를 selectedYear 에 고정한다.
  const rateFilters = useMemo(() => ({ yyyy: selectedYear }), [selectedYear]);

  const {
    data: rateData,
    refetch,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_VERSION>({
    menuId: MODAL_VERSION,
    sheetName: MODAL_SHEET_DATA,
    tabId: MODAL_VERSION,
    filters: rateFilters,
    enabled: open && !!selectedYear,
  });
  const loading = isLoading || isFetching;

  const itemsSource = useMemo<VersionRow[]>(
    () =>
      ((rateData?.o_rc1 ?? []) as VersionRow[]).map(r => ({
        ...r,
        VER_SEQ: r.VER_SEQ != null ? String(r.VER_SEQ) : '',
        YYYY: r.YYYY != null ? String(r.YYYY) : selectedYear,
        // CRUD_TYPE 강제 set 금지 — EditTracker 가 storeChange 시 'M' / undefined 자체 마킹.
        // 'N' 등 임의 값 set 시 EditTracker._originalValues Map key 불일치 → dirty=0 사고.
      })),
    [rateData, selectedYear]
  );

  // popup open 시 staticColumns + Year combo default 첫 항목 자동 선택 (AS-IS 동일).
  // 열 때마다 컬럼 메타를 다시 받는다. 이 스토어는 sessionStorage 에 영속되므로(createPersistedStore)
  //   `initialized` 로 건너뛰면 관리자(UI Category Setup)에서 바꾼 설정이 브라우저 탭을 닫기 전까지
  //   영영 반영되지 않는다 — Year 를 FPNumber 로 바꿔도 문자가 계속 입력되던 원인이 이것이다.
  //   영속 캐시는 첫 프레임을 즉시 그리는 용도로 남기고, 최신값은 매 open 마다 덮어쓴다.
  useEffect(() => {
    if (!open) return;
    void fetchStaticColumns();
  }, [open]);

  useEffect(() => {
    if (!open) return;
    if (yearOptions.length === 0) return;
    if (selectedYear) return;
    const first = yearOptions[0];
    const code = String(first.CODE ?? first.NAME ?? '').trim();
    if (code) setSelectedYear(code);
  }, [open, yearOptions, selectedYear]);

  // sort indicator 사고 fix — wijmo column.allowSorting 기본 true → 모든 column 에
  // indicator 표시. F3(toggleColumnSort) 누르기 전엔 false 로 강제.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !open) return;
    grid.columns.forEach(col => {
      col.allowSorting = false;
    });
    grid.invalidate();
  }, [open, staticColumns, itemsSource]);

  const handleFind = () => {
    if (!selectedYear) {
      void setAlert({ type: 'alert', content: t('MSG00019', 'Year 를 선택해주세요.') });
      return;
    }
    void refetch?.();
  };

  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const defaultYYYY = /^\d{4}$/.test(selectedYear) ? selectedYear : '';
    GridAction.addRow(grid, {
      VER_SEQ: '',
      YYYY: defaultYYYY,
      VERSION_NM: '',
      VALID_YN: 'Y',
      DESCRIPTION: '',
    } satisfies Partial<VersionRow>);
  };

  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    // 선택 행이 없으면 공용 SubTitle 의 F9 와 같은 안내를 낸다 (조용한 무동작 방지).
    if (!GridAction.removeRow(grid)) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
    }
  };

  const handleSave = async () => {
    if (savingRef.current) return;
    savingRef.current = true;

    const grid = gridRef.current;
    if (!grid) {
      savingRef.current = false;
      return;
    }

    // dirty 검출 — itemsAdded/Edited/Removed + EditTracker 추적 row 의 합집합.
    grid.finishEditing();
    const items = grid.collectionView?.sourceCollection ?? [];
    const cv = grid.collectionView as CollectionView<VersionRow> | undefined;
    const trackedRows = Array.from(editTrackerRef.current?.getOriginalValues()?.keys() ?? []);
    const editedSet = new Set<VersionRow>([
      ...(cv?.itemsAdded?.slice() ?? []),
      ...(cv?.itemsEdited?.slice() ?? []),
      ...(cv?.itemsRemoved?.slice() ?? []),
      ...trackedRows,
    ] as VersionRow[]);
    editedSet.forEach(r => {
      if (!r.CRUD_TYPE || (r.CRUD_TYPE !== CRUD_TYPE.INSERT && r.CRUD_TYPE !== CRUD_TYPE.DELETE)) {
        r.CRUD_TYPE = CRUD_TYPE.MODIFY;
      }
    });
    const dirty = items.filter(r => r.CRUD_TYPE || editedSet.has(r));

    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CHANGE', '수정한 내용이 없습니다.') });
      savingRef.current = false;
      return;
    }

    for (const r of dirty) {
      if (r.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
      if (!r.YYYY || String(r.YYYY).length !== 4) {
        void setAlert({
          type: 'alert',
          content: t('MSG_YEAR_4DIGIT', 'Year(YYYY) 는 4자리 숫자여야 합니다.'),
        });
        savingRef.current = false;
        return;
      }
      if (!r.VERSION_NM || String(r.VERSION_NM).trim() === '') {
        void setAlert({
          type: 'alert',
          content: t('MSG_VERSION_NM_REQUIRED', '버전명을 입력해주세요.'),
        });
        savingRef.current = false;
        return;
      }
      if (r.VALID_YN !== 'Y' && r.VALID_YN !== 'N') {
        void setAlert({
          type: 'alert',
          content: t('MSG_VALID_YN_INVALID', '유효여부는 Y 또는 N 이어야 합니다.'),
        });
        savingRef.current = false;
        return;
      }
    }

    // 저장 confirm 없이 바로 저장한다 (사용자 지시) — 신규행/수정행 구분 없이 동일 경로.
    //   검증(위 필수값 루프)을 통과하면 Save 버튼 클릭 자체를 확정 의사로 본다.

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
      const flag =
        r.CRUD_TYPE === CRUD_TYPE.INSERT ? 'I' : r.CRUD_TYPE === CRUD_TYPE.MODIFY ? 'U' : 'D';
      buf.activeFlag += '^' + flag;
      buf.verSeq += '^' + String(r.VER_SEQ ?? '');
      buf.yyyy += '^' + String(r.YYYY ?? '');
      buf.versionNm += '^' + String(r.VERSION_NM ?? '');
      buf.description += '^' + String(r.DESCRIPTION ?? '');
      buf.validYn += '^' + String(r.VALID_YN ?? 'Y');
      buf.createdBy += '^' + sessionUserId;
    });

    const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);

    try {
      await apiClient.post(`/${MODAL_VERSION}/version/SAVE/call-proc`, {
        activeFlag: trim(buf.activeFlag),
        verSeq: trim(buf.verSeq),
        yyyy: trim(buf.yyyy),
        versionNm: trim(buf.versionNm),
        description: trim(buf.description),
        validYn: trim(buf.validYn),
        createdBy: trim(buf.createdBy),
      });
      // 저장 성공은 Toast (AGENTS.md 저장 피드백 규칙) — 확인 버튼을 누를 이유가 없다.
      void setToast({ type: 'success', message: t('MSG00002', '저장이 완료되었습니다.') });
      void queryClient.invalidateQueries({ queryKey: [MODAL_VERSION] });
      void refetch?.();
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00003', '저장 중 오류가 발생했습니다.') });
    } finally {
      savingRef.current = false;
    }
  };

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00604', 'Contribution Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          {/* 버튼 라벨은 그대로 두고 F8(Insert)/F9(Delete) 키 동작만 추가 — 아래 버튼과 같은 핸들러. */}
          <GridHotkeys onInsert={handleInsert} onDelete={handleDelete} />
          <SearchArea
            searchButtonLabel={t('LBL00722', '_Search')}
            onSearch={handleFind}
            conditions={
              <FormItem
                label={t('LBL00086', '_Year')}
                labelAlign='right'
                required
                width={487}
                labelSize='middle'
                render={() => (
                  <CustomDropdown
                    value={selectedYear}
                    options={yearOptions.map(o => ({
                      label: String(o.NAME2 ?? o.NAME ?? o.CODE),
                      value: String(o.CODE ?? ''),
                    }))}
                    onChange={(_: unknown, option: string) => {
                      const opt = yearOptions.find(o => String(o.CODE) === option);
                      setSelectedYear(String(opt?.CODE).substring(0, 4));
                    }}
                  />
                )}
              />
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <DataGrid<VersionRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={editTrackerRef}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00121', '_Insert')}
              onClick={handleInsert}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00108', '_Delete')}
              onClick={handleDelete}
            />
            <Button
              appearance='contained'
              buttonLabel={t('LBL00111', '_Save')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00107', '_Close')}
              onClick={() => modalClose()}
            />
          </div>
        </div>
      }
    />
  );
};
