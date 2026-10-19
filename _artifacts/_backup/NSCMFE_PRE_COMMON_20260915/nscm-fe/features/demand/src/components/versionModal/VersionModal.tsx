import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs, { type Dayjs } from 'dayjs';
import { DivisionField, PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQuery, useTabProcQuery } from '@shared/hooks';
import {
  Button,
  Checkbox,
  DatePickerCalendar,
  FormItem,
  InputField,
  ProgressIndicator,
} from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { callVersionAction, callVersionTransfer } from './version-modal.api';
import {
  isAdoptableType,
  isMvVisibleType,
  modeOfType,
  PARENT_REPORT_TYPE,
  VERSION_ACTION,
  VERSION_BTN_CD,
  VERSION_META_PROGRAM_ID,
  VERSION_META_SHEET_NAME,
  VERSION_MODE,
  VERSION_MSG,
  VERSION_SHEET,
  VERSION_TYPE_LOOKUP,
} from './version-modal.constants';
import styles from './VersionModal.module.scss';
import { useVersionModalStore } from './versionModalStore';

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

// dayjs customParseFormat plugin 미등록 환경 → 하이픈 형태로 변환해서 파싱 (SearchFields.toDayjs 동일 규약)
const ymdToDayjs = (s: string): Dayjs | null =>
  YYYYMMDD.test(s) ? dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`) : null;
const ymToDayjs = (s: string): Dayjs | null =>
  /^\d{6}$/.test(s) ? dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-01`) : null;

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
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<VersionRow>>(undefined);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  // 조회조건 (입력 중 값) — 조회는 Find 버튼으로만 확정 (stale closure·인라인 filters 사고 방지)
  const [versionType, setVersionType] = useState(parentReportType);
  const [sdt, setSdt] = useState('');
  const [edt, setEdt] = useState('');
  const [description, setDescription] = useState('');
  // 확정된 조회조건 — useTabProcQuery filters 참조 안정화 원천
  const applied = useVersionModalStore(state => state.applied);
  const setApplied = useVersionModalStore(state => state.setApplied);

  // 액션 옵션 (AS-IS chkResult / BasicDate / chkMV / MvMonth / chkUpdate)
  const [includeResult, setIncludeResult] = useState(false);
  const [basicDate, setBasicDate] = useState('');
  const [includeMv, setIncludeMv] = useState(false);
  const [mvMonth, setMvMonth] = useState('');
  const [updateLatest, setUpdateLatest] = useState(true); // AS-IS InitControls L127 chkUpdate=true

  const [running, setRunning] = useState(false);
  const [selectedIdx, setSelectedIdx] = useState(-1);

  // ⭐ 권한 = MAIN UI 와 동일 메커니즘 (hook #125 §4.1). 그룹명 하드코딩·session.groupId 금지.
  //   AS-IS 는 팝업 액션을 ADMIN/DM ADMIN 으로 제한했고, 그 정책이 버튼권한 메타로 이관돼 있다
  //   (SCM_ADM_USER_GR_MNU_BTN_MPG_M 실측: ACTION/ACTION_BP/TRANSFER = ADMIN·DM ADMIN 만 보유,
  //    DM Viewer 는 미보유). 따라서 별도 판정식 없이 hasButton 만으로 AS-IS 파리티가 성립한다.
  const { hasButton } = useTabBtnPermissions({ menuId, enabled: open });
  const canAction = hasButton(VERSION_BTN_CD.ACTION); // Create / Copy / Delete
  const canTransfer = hasButton(VERSION_BTN_CD.TRANSFER); // Transfer / Transfer Cancel

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
    setApplied({
      versionType: parentReportType,
      sdt: initialSdt,
      edt: initialEdt,
      description: '',
    });
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
    parentReportType === PARENT_REPORT_TYPE.BP_M ? VERSION_TYPE_LOOKUP.BP : VERSION_TYPE_LOOKUP.SP;
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
    queryKey: [
      'version-modal-column',
      VERSION_META_PROGRAM_ID,
      VERSION_META_SHEET_NAME,
      divisionId,
    ],
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
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<
    VersionMenuId,
    typeof VERSION_SHEET
  >({
    menuId,
    sheetName: VERSION_SHEET,
    tabId: menuId,
    filters,
    enabled: open && YYYYMMDD.test(applied.sdt) && YYYYMMDD.test(applied.edt),
    queryOptions: { staleTime: 0 },
  });
  const versionRows = useMemo<VersionRow[]>(() => data?.data ?? [], [data]);
  const loading = isLoading || isFetching;

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
    setApplied({ ...applied, versionType: next, sdt: '', edt: '' }); // enabled=false → grid 비움
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
    // onSelect(versionNo, `${versionNo} ${cellStr(row.VERSION_DESCRIPTION)}`.trim());
    // 표시문 = VERSION_NO 만. VERSION_DESCRIPTION 을 붙이지 않는다 (2026-09-03 사용자 확정).
    //   붙이면 표시문과 조회키가 달라져, 사용자가 칸을 클릭하는 순간 VersionField 가 코드만
    //   남기도록 되돌리면서 설명이 사라진다(blur 복원 없음 = 비가역). 두 값을 같게 두면
    //   그 되돌림 자체가 발동하지 않는다.
    onSelect(versionNo, versionNo);
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
    // 권한 2중 방어 — 버튼을 숨겨도(노출 게이트) 실행 경로에서 한 번 더 막는다.
    //   AS-IS SaveButton 이 DefineProperty 와 별개로 그룹을 재검사하는 것과 같은 구조.
    const isTransferAction = action === VERSION_ACTION.TRANSFER || action === VERSION_ACTION.CANCEL;
    if (isTransferAction ? !canTransfer : !canAction) {
      void setAlert({ type: 'alert', content: t(VERSION_MSG.NO_AUTH, '_권한이 없습니다.') });
      return;
    }
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
      // 성공은 Toast, 실패/SP 메시지는 Alert (자매 화면 동일 규약)
      void setToast({
        message: t(VERSION_MSG.SAVED, '_성공적으로 저장되었습니다.'),
        type: 'success',
      });
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
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
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
              /* styles.searchGrid = display:contents 스코프 래퍼 — 4필드 라벨 열을 글자 폭에 맞춘다
                 (기본 100px 고정 라벨이 셀 폭을 먹어 Div 콤보가 잘리던 문제. scss 주석 참조).
                 칸 배분은 Div / Type / Period / Description 각 3칸 = 12칸 균등.
                 라벨이 고정 100px 이 아니라 글자 폭만 쓰므로 Period(달력 2개 = 110px x 2 + 구분자)도
                 3칸에 들어가고, 나머지 셋은 모두 종전보다 넓어진다. */
              <div className={styles.searchGrid}>
                {/* V-1 Division = 표준 카탈로그 DivisionField. AS-IS L119~120 `SelectedValue=_sDiv;
                    Enabled=false` 1:1 — 부모 확정값이라 비활성(값은 부모가 소유).
                    disabled 필수: onChange 를 no-op 으로 둔 것만으로는 목록이 열려 고를 수 있어
                    바꿀 수 있는 것처럼 보였다(고르면 값이 되돌아온다). 실제로 잠근다. */}
                <DivisionField
                  value={divisionId}
                  onChange={() => undefined}
                  gridSize={3}
                  disabled
                />
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
                {/* V-2 Period = 표준 카탈로그 PeriodField (AS-IS drpPeriod = UsrDateRangePicker) */}
                <PeriodField
                  start={sdt}
                  end={edt}
                  gridSize={3}
                  onChange={(s, e) => {
                    setSdt(s);
                    setEdt(e);
                  }}
                />
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
              </div>
            }
          />

          {/* 액션 바 — 모드별 옵션/버튼 (AS-IS ControlDisplay 가시성 규칙 1:1).
              배치는 왼쪽 옵션 · 오른쪽 버튼(spacer 로 분리), OK/Close 만 그리드 아래 우측에 둔다.
              표시할 것이 하나도 없는 조합에서는 빈 회색 바가 남지 않게 통째로 감춘다. */}
          {(mode === VERSION_MODE.COPY || mvVisible || canAction) && (
            <div className={styles.actionBar}>
              {mode === VERSION_MODE.COPY ? (
                <div className={styles.checkField}>
                  <Checkbox
                    labelText={t('LBL00849', '_Include Result')}
                    checked={includeResult}
                    onChange={handleIncludeResult}
                  />
                  {/* V-3 실적 기준일 = 표준 일자 컴포넌트 (AS-IS BasicDate = UsrDatePicker) */}
                  <div className={`${styles.datePickerFix} ${styles.actionDate}`}>
                    <DatePickerCalendar
                      usecase='date'
                      elevation
                      size='small'
                      format='YYYY.MM.DD'
                      disabled={!includeResult}
                      value={ymdToDayjs(basicDate)}
                      onChange={
                        ((date: Dayjs | null) => {
                          setBasicDate(date?.format('YYYYMMDD') ?? '');
                        }) as never
                      }
                    />
                  </div>
                </div>
              ) : null}

              {/* 이동계획 — SP 계열 Type 만 노출 (AS-IS L520 / L557) */}
              {mvVisible ? (
                <div className={styles.checkField}>
                  <Checkbox
                    labelText={t('LBL00850', '_MV Plan')}
                    checked={includeMv}
                    onChange={handleIncludeMv}
                  />
                  {/* V-4 이동계획 계획월 = 표준 년월 컴포넌트 (AS-IS MvMonth = UsrMonthPicker) */}
                  <div className={`${styles.datePickerFix} ${styles.actionDate}`}>
                    <DatePickerCalendar
                      usecase='month'
                      elevation
                      size='small'
                      disabled={!includeMv}
                      value={ymToDayjs(mvMonth)}
                      onChange={
                        ((date: Dayjs | null) => {
                          setMvMonth(date?.format('YYYYMM') ?? '');
                        }) as never
                      }
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

              {/* 여기서부터 우측 정렬 — 옵션과 액션 버튼을 좌우로 가른다 */}
              <div className={styles.actionBarSpacer} />

              {/* 권한 없는 액션 버튼은 숨긴다 (AS-IS Set_ButtonVisibleFalse 와 동일 방식) */}
              {mode === VERSION_MODE.CREATE && canAction
                ? actionButton(t('LBL00844', '_Version Create'), VERSION_ACTION.CREATE)
                : null}
              {mode === VERSION_MODE.COPY ? (
                <>
                  {canTransfer
                    ? actionButton(t('LBL00845', '_Transfer'), VERSION_ACTION.TRANSFER)
                    : null}
                  {canTransfer
                    ? actionButton(t('LBL00846', '_Transfer Cancel'), VERSION_ACTION.CANCEL)
                    : null}
                  {canAction
                    ? actionButton(t('LBL00847', '_Version Delete'), VERSION_ACTION.DELETE)
                    : null}
                  {canAction
                    ? actionButton(t('LBL00848', '_Version Copy'), VERSION_ACTION.COPY)
                    : null}
                </>
              ) : null}
            </div>
          )}

          {/* ⭐ 진행 스피너 (사용자 요구 2026-08-10) — Version Create / Copy / Delete / Transfer /
              Transfer Cancel 는 SP 가 원장 수십만 행을 쓰느라 수 초~수 분 걸린다. 그동안 버튼만
              disabled 되고 시각 피드백이 없어 "멈춘 것처럼" 보이던 문제.
              gridWrapper=position:relative 이므로 placement='parent' 로 grid 위 중앙에 표시한다
              (정본 = master/sales-future-price PriceBatchInputModal L1076~1083). */}
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={running}
              placement='parent'
            />
            {/* 검색조회 로딩 스피너 — 액션(running) 스피너와 별개로 그리드 조회 중에 표시. */}
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea
              title=''
              count={versionRows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<VersionRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={versionRows}
                staticColumns={staticColumns}
                autoGenerateColumns={false}
                allowSorting={false}
                dblClick={handleGridDblClick}
              />
            </ResultArea>
          </div>

          {/* OK / Close 는 그리드 아래 우측 (기존 VersionModal .modalButtonWrapper 와 동일 배치) */}
          <div className={styles.buttonWrapper}>
            {mode === VERSION_MODE.COPY ? (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='OK'
                onClick={() => adopt(getSelectedRow())}
              />
            ) : null}
            {/* 주의: Close = LBL00627 (LBL00062 는 'From Date' — 2026-07-30 오배정 실측 정정) */}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
