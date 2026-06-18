import { CellType, type FlexGrid as FlexGridType, type HitTestInfo } from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import dayjs, { type Dayjs } from 'dayjs';
import _ from 'lodash';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { DatePickerCalendar } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../contribute-view.constants';

import styles from './ContributeVersionModal.module.scss';

// AS-IS DMF0043_Contribute_View.cs btnSPVer_Click (.cs L453~471):
//   DMF0043_VersionPopup popVersion = new DMF0043_VersionPopup();
//   popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate);
//   popVersion.ShowDialog();
//   if (popVersion.sVersions != "") txtVersion.Text = popVersion.sVersions;
//
// AS-IS DMF0043_VersionPopup.cs (Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/POPUP/):
//   - InitControls (.cs L113): clbDivision (MyDivision), clbType (MDF_TYPE lookup)
//   - FindData (.cs L206): "DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP" 호출. 6 인자:
//       p_start_yyyymmdd / p_end_yyyymmdd / p_division_id / p_version_type / p_description
//       (p_created_by 주석 처리됨 — BE 자동 채움)
//   - SetItem (.cs L331): 선택 row 의 VERSION_NO 만 sVersions 변수로 전달
//
// SP body (PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP) WHERE 절 분석:
//   - DIVISION_ID = P_DIVISION_ID            (정확 일치)
//   - YYYYMMDD BETWEEN P_START AND P_END     (범위)
//   - VERSION_TYPE = P_VERSION_TYPE          (정확 일치! LIKE 아님 — 빈값 시 0건 위험)
//   - VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'  (빈값 OK)
//   - SEND_YN <> 'D'
// 결과 컬럼 (SP SELECT): VERSION_NO/VERSION_DESCRIPTION/VERSION_TYPE/VER_CRE_SEQ/YYYYMMDD/CREATED_BY/CREATION_DATE/EDIT_YN

interface VersionPopupRow {
  CODE?: string; // = VERSION_NO
  VERSION_NO?: string;
  VERSION_DESCRIPTION?: string;
  VERSION_TYPE?: string;
  VER_CRE_SEQ?: string | number;
  YYYYMMDD?: string;
  CREATED_BY?: string;
  CREATION_DATE?: string;
  EDIT_YN?: string;
}

interface Props {
  open: boolean;
  onClose: () => void;
  onSelect: (versionNo: string) => void; // AS-IS L468: txtVersion.Text = popVersion.sVersions
}

// AS-IS clbType (MDF_TYPE) lookup — DB 실제 값 (2026-06-01 진단 결과 반영)
// SCM_MGR.DM_MDF_VERSION 의 DIVISION_ID='40' VERSION_TYPE 분포:
//   REPORT_BP_M (Sales Plan Week)  : 176건
//   REPORT_BP_M (Business Plan Mon): 139건
//   REPORT_MF_D (MDF Daily)         : (다른 DIVISION_ID)
// SP body 의 VERSION_TYPE 정확 일치 필터 — 정확값 사용 의무
const VERSION_TYPE_OPTIONS: Array<{ value: string; label: string }> = [
  { value: 'REPORT_SP_W', label: 'REPORT_SP_W (Sales Plan Week)' },
  { value: 'REPORT_BP_M', label: 'REPORT_BP_M (Business Plan Month)' },
  { value: 'REPORT_MF_D', label: 'REPORT_MF_D (MDF Daily)' },
];

// AS-IS clbDivision (.cs L116, MyDivision lookup) — 정적 옵션 → 동적 lookup (사용자 요구 2026-06-02)
// `useTabComboQueries(['MyDivision'])` 로 사용자 권한 기반 전체 Division 동적 lookup
// (ItemByDivisionModal / ProjectByDivisionModal / customer-fcst-upload 등 공용 패턴)
// SP 호출 실패 시 fallback 4개 옵션
const DIVISION_FALLBACK: Array<{ value: string; label: string }> = [
  { value: '40', label: '40 (해외법인)' },
  { value: '10', label: '10' },
  { value: '20', label: '20' },
  { value: '30', label: '30' },
];

export const ContributeVersionModal = ({ open, onClose, onSelect }: Props) => {
  const setAlert = useMessageStore(s => s.setAlert);
  const gridRef = useRef<FlexGridType<VersionPopupRow> | null>(null);

  // 사용자 권한 기반 전체 Division lookup (사용자 요구 2026-06-02)
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

  // AS-IS L457~459: 현재 시각 -3M ~ +3M (DatePickerCalendar date-range-multi)
  const [period, setPeriod] = useState<[Dayjs, Dayjs]>(() => [
    dayjs().subtract(3, 'month'),
    dayjs().add(3, 'month'),
  ]);
  // AS-IS clbDivision.ControlValues — Division dropdown (As-IS btnSPVer_Click 은 '40' 고정 전달)
  const [divisionId, setDivisionId] = useState<string>('40');
  // AS-IS clbType.ControlValues — Type dropdown (정확 일치 필터)
  // 'SP' default (View 화면이 Form_Load(true, "SP", ...) 로 호출하나, AS-IS InitControls 는 sCode 미사용 → 사용자 선택)
  const [versionType, setVersionType] = useState<string>('REPORT_BP_M');
  // AS-IS txtDes.Text — Description 자유 입력 (LIKE 검색)
  const [description, setDescription] = useState<string>('');

  // AS-IS L455: sDivision = "40"
  // PROC_M COL_NM 정합: startYyyymmdd / endYyyymmdd / divisionId / versionType / description
  //   (sesUserId / mnuId 는 BE 자동 채움)
  const filters = useMemo(
    () =>
      open
        ? {
            startYyyymmdd: period[0].format('YYYYMMDD'),
            endYyyymmdd: period[1]?.format('YYYYMMDD'),
            divisionId,
            versionType,
            description,
          }
        : undefined,
    [open, period, divisionId, versionType, description]
  );

  const { data, refetch: search } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION_POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });

  const rows = useMemo<VersionPopupRow[]>(
    () => (data?.o_rc1 ?? []) as unknown as VersionPopupRow[],
    [data]
  );

  // const { mutate } = useCallProcMutation<MENU_ID, SHEETS.VERSION_POPUP>({
  //   menuId: MENU_ID,
  //   sheetName: SHEETS.VERSION_POPUP,
  // });

  const onSearch = () => {
    if (_.isEmpty(filters?.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: '검색 기간 종료일을 선택해주세요.' });
      return;
    }
    void search();

    // mutate(filters as ProcRequest<MENU_ID, SHEETS.VERSION_POPUP>, {
    //   onSuccess: res => {
    //     console.log('res => ', res);
    //   },
    // });
  };

  // popup close 시 상태 초기화
  useEffect(() => {
    if (!open) {
      setPeriod([dayjs().subtract(3, 'month'), dayjs().add(3, 'month')]);
      setDivisionId('40');
      setVersionType('REPORT_SP_W');
      setDescription('');
    }
  }, [open]);

  // AS-IS L331~353 SetItem: 선택 row 의 VERSION_NO 만 sVersions 로 전달
  const handleConfirm = () => {
    const g = gridRef.current;
    if (!g) return;
    const selected = (g.selectedItems[0] ?? null) as VersionPopupRow | null;
    if (!selected) {
      // AS-IS MSG00279 (.cs L340): 버전은 1개만 선택해 주세요
      void setAlert({ type: 'alert', content: '버전은 1개만 선택해 주세요. (MSG00279)' });
      return;
    }
    // ⛔ NUMBER → String cast 의무 (메모: feedback_no_type_cast_around_runtime)
    const versionNo = String(selected.VERSION_NO ?? selected.CODE ?? '');
    if (!versionNo) {
      void setAlert({ type: 'alert', content: '유효한 Version No 가 없습니다.' });
      return;
    }
    onSelect(versionNo);
    onClose();
  };

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>SP Version 선택</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContent}>
          {/* AS-IS 조회 조건 영역: Division (.cs L116), Period (drpPeriod), Type (clbType), Description (txtDes) */}
          <div className={styles.filterBar}>
            {/* AS-IS clbDivision (.cs L116, MyDivision lookup) */}
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Division</span>
              <select
                className={styles.select}
                value={divisionId}
                onChange={e => setDivisionId(e.target.value)}
                disabled
              >
                {divisionOptions.map(o => (
                  <option key={o.value} value={o.value}>
                    {o.label}
                  </option>
                ))}
              </select>
            </div>
            {/* AS-IS drpPeriod (.cs L108, .cs L212~213): date range picker */}
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
            {/* AS-IS clbType (.cs L127, MDF_TYPE lookup) — SP body 정확 일치 필터 */}
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Type</span>
              <select
                className={styles.select}
                value={versionType}
                onChange={e => setVersionType(e.target.value)}
              >
                {VERSION_TYPE_OPTIONS.map(o => (
                  <option key={o.value} value={o.value}>
                    {o.label}
                  </option>
                ))}
              </select>
            </div>
            {/* AS-IS txtDes (.cs L240, LIKE 검색) */}
            <div className={styles.field}>
              <span className={styles.fieldLabel}>Description</span>
              <input
                className={styles.input}
                type='text'
                value={description}
                onChange={e => setDescription(e.target.value)}
                placeholder='버전 설명 부분일치 검색'
              />
            </div>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={onSearch}
            >
              조회
            </button>
          </div>

          {/* 버전 리스트 grid — AS-IS InitSpread_X (.cs L156) 의 8 컬럼 매핑 */}
          <div className={styles.gridWrapper}>
            <FlexGrid
              initialized={(g: FlexGridType<VersionPopupRow>) => {
                gridRef.current = g;
                g.isReadOnly = true;
                g.selectionMode = 1; // Row

                g.hostElement.addEventListener('dblclick', (e: MouseEvent) => {
                  // hitTest 메서드를 사용하여 마우스 클릭 위치의 가상 좌표 정보(HitTestInfo) 추출
                  const ht: HitTestInfo = g.hitTest(e);

                  // 사용자가 헤더가 아닌 '일반 데이터 셀(Cell)'을 더블클릭했는지 검증
                  if (ht.cellType === CellType.Cell) {
                    // 4. 더블클릭한 위치의 행(Row) 인덱스를 이용해 데이터 추출
                    const selectedRowIndex = ht.row;
                    const selectedRowData = g.rows[selectedRowIndex]
                      .dataItem as VersionPopupRow | null;

                    const versionNo = String(
                      selectedRowData?.VERSION_NO ?? selectedRowData?.CODE ?? ''
                    );
                    onSelect(versionNo);
                    onClose();
                  }
                });
              }}
              itemsSource={rows}
              autoGenerateColumns={false}
              className={styles.grid}
            >
              {/* AS-IS .cs L161~168 의 8 컬럼 (DIVISION_ID/VER_CRE_SEQ/YYYYMMDD 은 visible=false) */}
              <FlexGridColumn binding='VERSION_NO' header='Version' width={220} />
              <FlexGridColumn binding='VERSION_DESCRIPTION' header='Description' width={300} />
              <FlexGridColumn binding='VERSION_TYPE' header='Type' width={100} />
              <FlexGridColumn binding='MAX(CREATED_BY)' header='Create By' width={100} />
              <FlexGridColumn binding='MAX(CREATION_DATE)' header='Create Date' width={150} />
            </FlexGrid>
          </div>

          <div className={styles.actionBar}>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={handleConfirm}
            >
              선택
            </button>
            <button type='button' className={styles.actionButton} onClick={onClose}>
              닫기
            </button>
          </div>
        </div>
      }
    />
  );
};
