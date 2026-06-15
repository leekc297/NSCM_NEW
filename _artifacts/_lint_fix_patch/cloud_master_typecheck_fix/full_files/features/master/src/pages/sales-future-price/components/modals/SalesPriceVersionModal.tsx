import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import dayjs, { type Dayjs } from 'dayjs';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { DatePickerCalendar } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './SalesPriceVersionModal.module.scss';

// AS-IS DMF0020_SalesFuturePrice.cs btnSPVer_Click (.cs L3895~)
//   DMF0073_VersionBySalesPricePopup popVersion = new DMF0073_VersionBySalesPricePopup();
//   popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate);
//   popVersion.ShowDialog();
//
// AS-IS DMF0073_VersionBySalesPricePopup.cs (Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/POPUP/):
//   - SP : DMF0073_GET_VERSION_SALESPRICE
//   - 8 IN: divisionId / periodFrom / periodTo / type / flagDay / flagWeek / flagManual / description
//   - Validation: MSG00255 (선택 > 2개 — Sales Price 최대 2개), Silent guard (Day/Week/Manual 모두 미선택)
//
// 본 컴포넌트 = DMF0043_01 contribute-view 의 ContributeVersionModal 패턴 100% 적용:
//   CustomDialog type='modal' / customHeaderTitle / customContentArea / FlexGrid + handleConfirm
//   로딩 인디케이터 (isLoading) — 사용자 요구 2026-06-03

// SP body 결과 SELECT 절 (line 60~77) 실제 컬럼:
//   CODE / VERSION_NO / VERSION_DESCRIPTION / VERSION_TYPE / EDI_APPLY / VER_CRE_SEQ /
//   YYYYMMDD / CREATED_BY / CREATION_DATE / MONTHLY_ROLLING_FCST / EDITABLE / EDIT_YN
// (자매 화면 DMF0043_01 ContributeVersionModal 의 binding 과 동일 패턴)
interface VersionPopupRow {
  CODE?: string;
  VERSION_NO?: string;
  VERSION_DESCRIPTION?: string;
  VERSION_TYPE?: string;
  EDI_APPLY?: string;
  VER_CRE_SEQ?: number | string;
  YYYYMMDD?: string;
  CREATED_BY?: string;
  CREATION_DATE?: string;
  MONTHLY_ROLLING_FCST?: string;
  EDITABLE?: string;
  EDIT_YN?: string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  onApply: (versionIds: string) => void;
}

const DIVISION_FALLBACK: Array<{ value: string; label: string }> = [
  { value: '40', label: '40 (Mobility & IT Battery)' },
  { value: '81', label: '81 (ESS Battery)' },
  { value: '82', label: '82 (Power Tool)' },
];

export const SalesPriceVersionModal = ({ open, modalClose, defaultDivision, onApply }: Props) => {
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const gridRef = useRef<FlexGridType<VersionPopupRow> | null>(null);

  // 사용자 권한 기반 Division lookup (자매 화면 ContributeVersionModal 패턴)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    if (arr.length === 0) return DIVISION_FALLBACK;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  // AS-IS Period (-3M ~ +3M)
  const [period, setPeriod] = useState<[Dayjs, Dayjs]>(() => [
    dayjs().subtract(3, 'month'),
    dayjs().add(3, 'month'),
  ]);
  const [divisionId, setDivisionId] = useState<string>(defaultDivision);
  // AS-IS Day/Week/Manual checkbox (Sales Price 기본 Week)
  const [chkDay, setChkDay] = useState(false);
  const [chkWeek, setChkWeek] = useState(true);
  const [chkManual, setChkManual] = useState(false);
  const [description, setDescription] = useState<string>('');

  // popup open 시 default value reset
  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriod([dayjs().subtract(3, 'month'), dayjs().add(3, 'month')]);
      setChkDay(false);
      setChkWeek(true);
      setChkManual(false);
      setDescription('');
    }
  }, [open, defaultDivision]);

  // SP filter — DB SP signature 정확 매핑 (DMF0073_GET_VERSION_SALESPRICE 9 인자):
  //   P_START_YYYYMMDD / P_END_YYYYMMDD / P_CREATED_BY / P_DIVISION_ID
  //   P_VERSION_TYPE / P_DESCRIPTION / P_USER_ID / P_MENU_ID / O_RC1
  //   (sesUserId / mnuId 는 BE 자동 채움)
  // Day/Week/Manual 체크박스 → DB 실제 VERSION_TYPE 매핑.
  //   SP body 주석 line 10: `p_version_type DEFAULT 'SP_W'` (Sales Plan Week)
  //   AS-IS DMF0073 도메인 표준: 'SP_W' / 'SP_M' / 'SP_D' (Sales Price domain)
  //   다중 선택 시 ',' join — SP body `fn_string_split(p_version_type, ',')` 처리
  const versionTypes: string[] = [];
  if (chkDay) versionTypes.push('SP_D');
  if (chkWeek) versionTypes.push('SP_W');
  if (chkManual) versionTypes.push('SP_M');
  const versionType = versionTypes.length > 0 ? versionTypes.join(',') : 'SP_W';
  const filters = useMemo(
    () =>
      open
        ? {
            startYyyymmdd: period[0].format('YYYYMMDD'),
            endYyyymmdd: period[1].format('YYYYMMDD'),
            createdBy: '',
            divisionId,
            versionType,
            description,
          }
        : undefined,
    [open, divisionId, period, versionType, description],
  );

  // useTabProcQuery — enabled 가드 + isLoading 노출
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters,
    enabled: false, // Find 버튼 trigger
  });

  const rows = useMemo<VersionPopupRow[]>(
    () => (data?.o_rc1 ?? []) as VersionPopupRow[],
    [data],
  );

  const loading = isLoading || isFetching;

  const handleFind = () => {
    if (!chkDay && !chkWeek && !chkManual) {
      // AS-IS Silent guard
      void setToast({ message: 'Day / Week / Manual 중 1개 이상 선택해주세요', type: 'warning' });
      return;
    }
    void refetch?.();
  };

  // 선택 — DMF0043_01 ContributeVersionModal 패턴 (selectedItems 직접 사용)
  //   single row click 으로 grid 자체 선택 → Apply 클릭 시 selectedItems 사용
  //   selectionMode='ListBox' (2) — multiple selection 가능 (Ctrl/Shift)
  //   AS-IS MSG00255: Sales Price Version 최대 2개
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) {
      void setAlert({ type: 'alert', content: 'Grid 가 준비되지 않았습니다.' });
      return;
    }
    const selectedItems = g.selectedItems as VersionPopupRow[];
    if (!selectedItems || selectedItems.length === 0) {
      void setAlert({ type: 'alert', content: '[MSG00113] Version 을 선택해 주세요.' });
      return;
    }
    if (selectedItems.length > 2) {
      void setAlert({ type: 'alert', content: '[MSG00255] Sales Price Version 은 최대 2개까지 선택할 수 있습니다.' });
      return;
    }
    const versionNos = selectedItems
      .map(r => String(r.VERSION_NO ?? r.CODE ?? ''))
      .filter(Boolean);
    if (versionNos.length === 0) {
      void setAlert({ type: 'alert', content: '유효한 Version 이 선택되지 않았습니다.' });
      return;
    }
    onApply(versionNos.join(','));
    modalClose();
  };

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>Sales Price Version 선택</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 조회 조건 */}
          <div className={styles.filterBar}>
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Division</span>
              <select className={styles.select} value={divisionId} onChange={e => setDivisionId(e.target.value)}>
                {divisionOptions.map(o => (
                  <option key={o.value} value={o.value}>{o.label}</option>
                ))}
              </select>
            </div>
            <div className={styles.fieldWide}>
              <span className={styles.fieldLabel}>Period</span>
              <div className={styles.datePickerWrap}>
                <DatePickerCalendar
                  usecase='date-range-multi'
                  elevation
                  size='small'
                  value={period}
                  onChange={date => {
                    if (Array.isArray(date) && date.length === 2) {
                      setPeriod([date[0] as Dayjs, date[1] as Dayjs]);
                    }
                  }}
                />
              </div>
            </div>
            <div className={styles.field}>
              <label className={styles.checkboxLabel}>
                <input type='checkbox' checked={chkDay} onChange={e => setChkDay(e.target.checked)} /> Day
              </label>
              <label className={styles.checkboxLabel}>
                <input type='checkbox' checked={chkWeek} onChange={e => setChkWeek(e.target.checked)} /> Week
              </label>
              <label className={styles.checkboxLabel}>
                <input type='checkbox' checked={chkManual} onChange={e => setChkManual(e.target.checked)} /> Manual
              </label>
            </div>
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Description</span>
              <input
                className={styles.input}
                type='text'
                value={description}
                onChange={e => setDescription(e.target.value)}
                placeholder='버전 설명 부분일치'
              />
            </div>
            <button type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={handleFind}
              disabled={loading}>
              {loading ? '⏳ 조회 중...' : 'Find'}
            </button>
          </div>

          {/* 로딩 표시 + 결과 카운트 */}
          <div className={styles.statusBar}>
            {loading
              ? <span className={styles.loading}>⏳ 데이터 조회 중입니다. 잠시만 기다려 주세요...</span>
              : <span className={styles.count}>{rows.length} 행 조회됨 — 행 클릭으로 선택 (Ctrl/Shift 다중, 최대 2개). 더블클릭 시 즉시 적용</span>}
          </div>

          {/* Grid */}
          <div className={styles.gridWrapper}>
            <FlexGrid
              initialized={(g: FlexGridType<VersionPopupRow>) => {
                gridRef.current = g;
                g.isReadOnly = true;
                // SelectionMode.ListBox = 2 — 다중 row 선택 가능 (Ctrl/Shift)
                g.selectionMode = 2;
                // Double-click 즉시 적용 (wijmo 버전별 itemDoubleClick 가드 + DOM fallback)
                const dblG = (g as unknown as { itemDoubleClick?: { addHandler?: (fn: () => void) => void } }).itemDoubleClick;
                if (dblG && typeof dblG.addHandler === 'function') {
                  dblG.addHandler(() => handleApply());
                } else if (g.hostElement) {
                  g.hostElement.addEventListener('dblclick', () => handleApply());
                }
              }}
              itemsSource={rows}
              autoGenerateColumns={false}
              className={styles.grid}
            >
              {/* SP 결과 컬럼명 정확 매핑 (DMF0043_01 ContributeVersionModal 패턴) */}
              <FlexGridColumn binding='VERSION_NO' header='Version' width={240} />
              <FlexGridColumn binding='VERSION_DESCRIPTION' header='Description' width={300} />
              <FlexGridColumn binding='VERSION_TYPE' header='Type' width={80} />
              <FlexGridColumn binding='YYYYMMDD' header='Date' width={100} />
              <FlexGridColumn binding='CREATED_BY' header='Create By' width={100} />
              <FlexGridColumn binding='CREATION_DATE' header='Create Date' width={150} />
              <FlexGridColumn binding='EDITABLE' header='Editable' width={70} />
              <FlexGridColumn binding='MONTHLY_ROLLING_FCST' header='Monthly RF' width={100} />
            </FlexGrid>
          </div>

          {/* Action */}
          <div className={styles.actionBar}>
            <button type='button' className={`${styles.actionButton} ${styles.primary}`} onClick={handleApply}>
              선택 Apply
            </button>
            <button type='button' className={styles.actionButton} onClick={modalClose}>닫기</button>
          </div>
        </div>
      }
    />
  );
};
