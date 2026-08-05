import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabLookupQuery, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { callVersionAction, callVersionTransfer } from './version-modal.api';
import {
  isAdoptableType,
  isMvVisibleType,
  modeOfType,
  PARENT_REPORT_TYPE,
  VERSION_ACTION,
  VERSION_META_PROGRAM_ID,
  VERSION_META_SHEET_NAME,
  VERSION_MODE,
  VERSION_MSG,
  VERSION_SHEET,
  VERSION_TYPE_LOOKUP,
} from './version-modal.constants';
import styles from './VersionModal.module.scss';

/** 본 팝업을 공유하는 화면 — procedures.d.ts 에 'unitedVersion' 시트가 등재된 2 화면.
 *  ⚠ Extract<MenuId, ...> 사용 금지: RawProcedureMap 이 Base 의 문자열 인덱스 시그니처를
 *  extends 하므로 keyof ProcedureMap 은 string 으로 붕괴(리터럴 키 흡수) → Extract = never. */
export type VersionMenuId = 'DMF0044' | 'DMF0049';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 호출 화면 MENU_ID — SP 배선(unitedVersion)·EDIT_YN 권한 판정에 그대로 전달 */
  menuId: VersionMenuId;
  divisionId: string;
  /** 부모 화면 Report Type — Type 콤보 lookup 세트 결정 (AS-IS Form_Load(strDiv, strType)) */
  parentReportType: string;
  /** 버전 채택 — 부모 조회조건 Version 주입 */
  onSelect: (versionNo: string, label: string) => void;
}

/** SP 커서(P_DMF0044_GET_SALES_VERSION_POPUP O_RC1) 1행 — 컬럼 라벨/폭은 admin 메타가 소유 */
type VersionRow = ResponseData<'DMF0044', 'unitedVersion', 'data'>;

const YYYYMMDD = /^\d{8}$/;

// ⭐ DMF0044 / DMF0049 공용 Version 팝업 — AS-IS DMF0044_United_VersionPopup(727행) 1:1.
//   두 화면이 동일 팝업 클래스를 공유(DMF0044_Sales_Reports.cs L1150 / DMF0049_Sales_ETC_Reports.cs L1236)
//   하므로 TO-BE 도 본 컴포넌트 1본을 공유한다.
//
//   ⭐ Type 값에 따른 2모드 (AS-IS ControlDisplay L503~578 — 캡쳐 DMF0044_VERSION[_CREATE].png):
//   - CREATE (Type ∈ SP_W / SP_M / BP_M) : Version Create + 이동계획(SP 계열만) + Close
//   - COPY   (Type ∈ REPORT_SP_W / REPORT_BP_M) : Transfer / Transfer Cancel / Version Delete /
//            Version Copy + 실적 포함·기준일 + 이동계획(REPORT_SP_W만) + 최신화 + OK + Close
//   Type 변경 시 grid 초기화 + 실적 포함 해제 (AS-IS clbType_SelectedIndexChanged L496).
export const VersionModal = ({
  open,
  modalClose,
  menuId,
  divisionId,
  parentReportType,
  onSelect,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<VersionRow>>(undefined);
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  // 조회조건 (입력 중 값) — 조회는 Find 버튼으로만 확정 (stale closure·인라인 filters 사고 방지)
  const [versionType, setVersionType] = useState(parentReportType);
  const [sdt, setSdt] = useState('');
  const [edt, setEdt] = useState('');
  const [description, setDescription] = useState('');
  // 확정된 조회조건 — useTabProcQuery filters 참조 안정화 원천
  const [applied, setApplied] = useState({ versionType: parentReportType, sdt: '', edt: '', description: '' });

  // 액션 옵션 (AS-IS chkResult / BasicDate / chkMV / MvMonth / chkUpdate)
  const [includeResult, setIncludeResult] = useState(false);
  const [basicDate, setBasicDate] = useState('');
  const [includeMv, setIncludeMv] = useState(false);
  const [mvMonth, setMvMonth] = useState('');
  const [updateLatest, setUpdateLatest] = useState(true); // AS-IS InitControls L127 chkUpdate=true

  const [running, setRunning] = useState(false);
  const [selectedIdx, setSelectedIdx] = useState(-1);

  const mode = modeOfType(versionType);
  const mvVisible = isMvVisibleType(versionType);

  // 열 때마다 AS-IS InitControls 기본값으로 복원 (기간 = 당월-1 ~ +5개월)
  useEffect(() => {
    if (!open) return;
    const initialSdt = dayjs().subtract(1, 'month').format('YYYYMMDD');
    const initialEdt = dayjs().add(5, 'month').format('YYYYMMDD');
    setVersionType(parentReportType);
    setSdt(initialSdt);
    setEdt(initialEdt);
    setDescription('');
    setApplied({ versionType: parentReportType, sdt: initialSdt, edt: initialEdt, description: '' });
    setIncludeResult(false);
    setBasicDate('');
    setIncludeMv(false);
    setMvMonth('');
    setUpdateLatest(true);
    setSelectedIdx(-1);
    setRunning(false);
  }, [open, parentReportType]);

  // Type 콤보 — 부모 Report Type 으로 lookup 세트 분기 (AS-IS InitControls L130~137)
  const typeLookup =
    parentReportType === PARENT_REPORT_TYPE.BP_M
      ? VERSION_TYPE_LOOKUP.BP
      : VERSION_TYPE_LOOKUP.SP;
  const { data: typeRows } = useTabLookupQuery({
    filters: { lookupType: typeLookup },
    enabled: open,
  });
  const typeOptions = useMemo(
    () =>
      (typeRows ?? []).map(r => ({
        label: String(r.NAME ?? r.CODE ?? ''),
        value: String(r.CODE ?? ''),
      })),
    [typeRows]
  );

  // ⭐ Grid 컬럼 = admin 동적 메타 (hook #113 — 하드코딩 금지). AS-IS GetSpdTitle L278 이
  //   p_program_id='DMF0044' 고정이므로 DMF0049 호출 시에도 DMF0044/MDFVerpopup 등록분을 읽는다.
  const { data: metaColumns } = useQuery<RawFlexGridColumnConfig[]>({
    queryKey: ['version-modal-column', VERSION_META_PROGRAM_ID, VERSION_META_SHEET_NAME, divisionId],
    queryFn: async () => {
      const res = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${VERSION_META_PROGRAM_ID}/column`,
        { sheetNm: VERSION_META_SHEET_NAME, divisionId }
      );
      return res.data.result ?? [];
    },
    enabled: open,
  });
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => metaColumns ?? [], [metaColumns]);

  // 조회 — PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP (7 IN / data·result 커서)
  const filters = useMemo(
    () => ({
      divisionId,
      sdt: applied.sdt,
      edt: applied.edt,
      versionType: applied.versionType,
      description: applied.description,
      userId: sesUserId,
      mnuId: menuId,
    }),
    [divisionId, applied, sesUserId, menuId]
  );
  const { data, refetch } = useTabProcQuery<VersionMenuId, typeof VERSION_SHEET>({
    menuId,
    sheetName: VERSION_SHEET,
    tabId: menuId,
    filters,
    enabled: open && YYYYMMDD.test(applied.sdt) && YYYYMMDD.test(applied.edt),
    queryOptions: { staleTime: 0 },
  });
  const versionRows = useMemo<VersionRow[]>(() => data?.data ?? [], [data]);

  const handleSearch = () => {
    if (!YYYYMMDD.test(sdt) || !YYYYMMDD.test(edt)) {
      void setAlert({ type: 'alert', content: t('LBL00013', 'Period') + ' : YYYYMMDD' });
      return;
    }
    const next = { versionType, sdt, edt, description };
    const unchanged =
      applied.versionType === next.versionType &&
      applied.sdt === next.sdt &&
      applied.edt === next.edt &&
      applied.description === next.description;
    if (unchanged) {
      void refetch?.();
      return;
    }
    setApplied(next);
  };

  // Type 변경 — grid 초기화 + 실적 포함 해제 (AS-IS L496~501). 재조회는 Find 버튼.
  const handleTypeChange = (next: string) => {
    setVersionType(next);
    setApplied(prev => ({ ...prev, versionType: next, sdt: '', edt: '' })); // enabled=false → grid 비움
    setIncludeResult(false);
    setBasicDate('');
    setSelectedIdx(-1);
  };

  // 실적 포함 — 체크 시 기준일 활성·오늘 + 최신화 강제 체크·잠금 (AS-IS chkResult_CheckedChanged L302)
  const handleIncludeResult = (checked: boolean) => {
    setIncludeResult(checked);
    if (checked) {
      setBasicDate(dayjs().format('YYYYMMDD'));
      setUpdateLatest(true);
    } else {
      setBasicDate('');
      setUpdateLatest(false);
    }
  };

  // 이동계획 — 체크 시 계획월 활성·전월 (AS-IS chkMV_CheckedChanged L713)
  const handleIncludeMv = (checked: boolean) => {
    setIncludeMv(checked);
    setMvMonth(checked ? dayjs().subtract(1, 'month').format('YYYYMM') : '');
  };

  const cellStr = (v: string | number | null | undefined) =>
    (v === null || v === undefined ? '' : String(v)).trim();

  const getSelectedRow = (): VersionRow | undefined => {
    const g = gridRef.current;
    const rowIndex = selectedIdx >= 0 ? selectedIdx : (g?.selection?.row ?? -1);
    return (g?.rows[rowIndex]?.dataItem as VersionRow | undefined) ?? versionRows[rowIndex];
  };

  // 버전 채택 — Type ∈ {REPORT_SP_W, REPORT_BP_M} 만 (AS-IS 더블클릭 L351 / btnOK L481)
  const adopt = (row: VersionRow | undefined) => {
    if (!row) return;
    if (!isAdoptableType(cellStr(row.VERSION_TYPE))) return;
    const versionNo = cellStr(row.VERSION_NO);
    if (versionNo === '') return;
    onSelect(versionNo, `${versionNo} ${cellStr(row.VERSION_DESCRIPTION)}`.trim());
    modalClose();
  };

  const handleGridDblClick = (ev: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(ev);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    setSelectedIdx(ht.row);
    adopt(g.rows[ht.row]?.dataItem as VersionRow | undefined);
  };

  // 행 선택 추적 + No. 코너 헤더 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    const selHandler = () => {
      const next = g.selection?.row ?? -1;
      setSelectedIdx(prev => (prev === next ? prev : next));
    };
    g.formatItem.addHandler(formatHandler);
    g.selectionChanged.addHandler(selHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.selectionChanged?.removeHandler(selHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, staticColumns, versionRows]);

  // ⭐ 액션 공통 — 행 선택 게이트 + SEND_YN 게이트 + confirm + SP 호출 (AS-IS btn*_Click L376~479)
  const runAction = async (action: string) => {
    if (running) return;
    const row = getSelectedRow();
    // 행 미선택 = 무동작 (AS-IS SingleCheck L323 — MSG00279 알림은 주석 처리돼 있어 파리티 유지)
    if (!row) return;
    const sendYn = cellStr(row.SEND_YN);
    const versionNo = cellStr(row.VERSION_NO);
    const rowVersionType = cellStr(row.VERSION_TYPE);
    const desc = description.trim(); // AS-IS 는 txtDesc 입력값을 그대로 전달 (grid 값 아님)

    // SEND_YN 게이트 (AS-IS 00318/00319/00320 → 사내 신규 00685/00686/00687)
    if (action === VERSION_ACTION.TRANSFER && sendYn !== 'N') {
      void setAlert({
        type: 'alert',
        content: t(VERSION_MSG.SEND_ONLY_N, '_SEND_YN 이 N 인 값만 전송할 수 있습니다.'),
      });
      return;
    }
    if (action === VERSION_ACTION.CANCEL && sendYn !== 'Y') {
      void setAlert({
        type: 'alert',
        content: t(VERSION_MSG.CANCEL_ONLY_Y, '_SEND_YN 이 Y 인 값만 취소할 수 있습니다.'),
      });
      return;
    }
    if (action === VERSION_ACTION.DELETE && sendYn !== 'N' && sendYn !== 'C') {
      void setAlert({
        type: 'alert',
        content: t(VERSION_MSG.DELETE_ONLY_NC, '_SEND_YN 이 N 또는 C 인 값만 삭제할 수 있습니다.'),
      });
      return;
    }

    // confirm — Cancel(00195) / Delete(00016) / Copy(00314, 실적 미포함 시에만)
    const confirmMsg =
      action === VERSION_ACTION.CANCEL
        ? t(VERSION_MSG.CANCEL_CONFIRM, '_취소하시겠습니까?')
        : action === VERSION_ACTION.DELETE
          ? t(VERSION_MSG.DELETE_CONFIRM, '_삭제 하시겠습니까?')
          : action === VERSION_ACTION.COPY && !includeResult
            ? t(VERSION_MSG.COPY_PLAN_ONLY, '_실적은 포함하지 않고, 계획만 복사하시겠습니까?')
            : '';
    if (confirmMsg) {
      const confirmed = await setAlert({ type: 'confirm', content: confirmMsg });
      if (!confirmed) return;
    }

    setRunning(true);
    try {
      const res =
        action === VERSION_ACTION.TRANSFER || action === VERSION_ACTION.CANCEL
          ? await callVersionTransfer(menuId, {
              divisionId,
              versionNo,
              versionType: rowVersionType,
              actionType: action,
            })
          : await callVersionAction(menuId, {
              divisionId,
              versionNo,
              versionDescription: desc,
              resultDate: includeResult ? basicDate : '',
              actionType: action,
              mvPlanYyyymm: includeMv && mvVisible ? mvMonth : '',
              updateYn: updateLatest ? 'Y' : 'N',
            });
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(VERSION_MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setAlert({ type: 'alert', content: t(VERSION_MSG.SAVED, '_성공적으로 저장되었습니다.') });
      void refetch?.();
    } finally {
      setRunning(false);
    }
  };

  const actionButton = (label: string, action: string) => (
    <Button
      appearance='outlined'
      priority='normal'
      size='medium'
      buttonLabel={label}
      disabled={running}
      onClick={() => void runAction(action)}
    />
  );

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1180}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00513', 'Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrapper}>
          {/* 조회조건 4 — Div(고정) / Type / Period / Description (hook #94 — 1단, 36px) */}
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00794', '_Type')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={versionType}
                        options={typeOptions}
                        onChange={(_, v) => handleTypeChange(String(v ?? ''))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={`${styles.fieldRow} ${styles.h36}`}>
                        <InputField
                          value={sdt}
                          onChange={e => setSdt(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                        <span>~</span>
                        <InputField
                          value={edt}
                          onChange={e => setEdt(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00799', '_Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />

          {/* 액션 바 — 모드별 버튼/옵션 (AS-IS ControlDisplay 가시성 규칙 1:1) */}
          <div className={styles.actionBar}>
            {mode === VERSION_MODE.CREATE
              ? actionButton(t('LBL00844', '_Version Create'), VERSION_ACTION.CREATE)
              : null}

            {mode === VERSION_MODE.COPY ? (
              <>
                {actionButton(t('LBL00845', '_Transfer'), VERSION_ACTION.TRANSFER)}
                {actionButton(t('LBL00846', '_Transfer Cancel'), VERSION_ACTION.CANCEL)}
                {actionButton(t('LBL00847', '_Version Delete'), VERSION_ACTION.DELETE)}
                {actionButton(t('LBL00848', '_Version Copy'), VERSION_ACTION.COPY)}
                <div className={styles.checkField}>
                  <Checkbox
                    labelText={t('LBL00849', '_Include Result')}
                    checked={includeResult}
                    onChange={handleIncludeResult}
                  />
                  <div className={styles.h36}>
                    <InputField
                      value={basicDate}
                      disabled={!includeResult}
                      onChange={e => setBasicDate(e.target.value)}
                      placeholder='YYYYMMDD'
                    />
                  </div>
                </div>
              </>
            ) : null}

            {/* 이동계획 — SP 계열 Type 만 노출 (AS-IS L520 / L557) */}
            {mvVisible ? (
              <div className={styles.checkField}>
                <Checkbox
                  labelText={t('LBL00850', '_MV Plan')}
                  checked={includeMv}
                  onChange={handleIncludeMv}
                />
                <div className={styles.h36}>
                  <InputField
                    value={mvMonth}
                    disabled={!includeMv}
                    onChange={e => setMvMonth(e.target.value)}
                    placeholder='YYYYMM'
                  />
                </div>
              </div>
            ) : null}

            {/* 최신화 — COPY 모드만 (AS-IS LayoutControl_Update). 실적 포함 시 강제 Y·잠금 */}
            {mode === VERSION_MODE.COPY ? (
              <Checkbox
                labelText={t('LBL00851', '_Latest')}
                checked={updateLatest}
                disabled={includeResult}
                onChange={setUpdateLatest}
              />
            ) : null}

            <div className={styles.actionBarSpacer} />

            {mode === VERSION_MODE.COPY ? (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='OK'
                onClick={() => adopt(getSelectedRow())}
              />
            ) : null}
            {/* ⚠️ Close = LBL00627 (LBL00062 는 'From Date' — 2026-07-30 오배정 실측 정정) */}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>

          <div className={styles.gridWrapper}>
            <DataGrid<VersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={staticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
              dblClick={handleGridDblClick}
            />
          </div>
        </div>
      }
    />
  );
};
