import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CUTOFF_VER_TYPE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import type { CutoffVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callCutoff } from '../../utils/business-plan.api';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
}

// ⭐ 화면 입력은 일(日) 단위 yyyymmdd 8 그대로 보관하고(AS-IS DateTimePicker 와 동일 — 1일/말일로
//   펼치지 않는다), SP 파라미터로 나갈 때만 앞 6자리를 잘라 yyyymm 계약을 지킨다 (2026-08-08 지시).
const toYm = (yyyymmdd: string): string => (/^\d{8}$/.test(yyyymmdd) ? yyyymmdd.slice(0, 6) : '');

// 버전 목록 grid 컬럼 (DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION 커서 — 조회 전용)
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 80 },
  { key: 'VERSION_NO', header: 'Version No', width: 140 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 260 },
  { key: 'VERSION_TYPE', header: 'Type', width: 80 },
  { key: 'CREATED_BY', header: 'Created By', width: 110 },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 140 },
];

// ⭐ Ver. Cutoff 모달 — AS-IS VersionCutOffPopUp(610줄) 1:1: 기존 버전 목록 조회
//   (DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION, versionType='BP_M') + 설명 입력 + Cutoff 실행
//   (DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF — division 단일, createdBy BE주입).
//   완료 안내 = MSG00675 '[Division ID : {0}] {1}' (AS-IS 00151). 권한 게이트 = 부모 hasButton('CUTOFF').
export const VersionCutoffModal = ({ open, modalClose, divisionId }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<CutoffVersionRow>>(undefined);

  // ⭐ 기간 기본값 = AS-IS VersionCutOffPopUp Form_Load L106~108 그대로 — **오늘 일자** ~ 같은 일자
  //   +5개월 (실측: 2026-08-08 ~ 2027-01-08). 월 1일/말일로 펼치지 않고, 부모 조회기간도 승계하지
  //   않는다 (2026-08-08 사용자 지시 + AS-IS 화면 실측). 열 때마다 재계산 — 자정을 넘겨도 '오늘' 기준.
  const defaultPeriod = () => ({
    from: dayjs().format('YYYYMMDD'),
    to: dayjs().add(5, 'month').format('YYYYMMDD'),
  });

  const [startYmd, setStartYmd] = useState(() => defaultPeriod().from);
  const [endYmd, setEndYmd] = useState(() => defaultPeriod().to);
  const [description, setDescription] = useState('');
  const [running, setRunning] = useState(false);
  const [lastError, setLastError] = useState('');

  useEffect(() => {
    if (open) {
      const { from, to } = defaultPeriod();
      setStartYmd(from);
      setEndYmd(to);
      setDescription('');
      setRunning(false);
      setLastError('');
    }
  }, [open]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId,
      yyyymmFrom: toYm(startYmd),
      yyyymmTo: toYm(endYmd),
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS LoadDataDiv L2857)
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, startYmd, endYmd, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CUTOFF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUTOFF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });
  const versionRows = useMemo<CutoffVersionRow[]>(
    () => (data as { data?: CutoffVersionRow[] } | undefined)?.data ?? [],
    [data]
  );

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      VERSION_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          fixed: false,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })
      ),
    []
  );

  // No. 코너 헤더 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, versionRows]);

  // ⭐ Cutoff 실행 — confirm 후 SP 호출 (division 단일. 결과 passthrough + MSG00675 완료 안내)
  const handleCutoff = async () => {
    if (running) return;
    // 실행 확인 — MSG00033 '실행하시겠습니까?' (2026-08-08 사내 등록. 구: 하드코딩 영문
    //   `Manual Cutoff (${divisionId})?`. Division 은 상단 Div 필드에 이미 고정 표시된다.)
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(MSG.EXECUTE_CONFIRM, '실행하시겠습니까?'),
    });
    if (!confirmed) return;
    setRunning(true);
    // Loading 토스트는 제거 — duration 3초 고정이라 실제 소요시간과 어긋난다. 진행 표시는 스피너가 맡는다.
    setLastError('');
    try {
      const res = await callCutoff(divisionId, description.trim(), CUTOFF_VER_TYPE, sesUserId);
      if (!res.ok) {
        const message = res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        // ⭐ SP 원문 오류는 alert 하나로는 읽기 어렵다 — 확인(confirm) 버튼과 결과 alert 의 확인 버튼이
        //   같은 자리라 클릭이 이어지면 그대로 닫히고, ORA 스택은 400px 다이얼로그에서 잘린다.
        //   ⇒ 모달 안에 남겨 두고(사용자가 읽고 복사 가능) 콘솔에도 기록한다.
        setLastError(message);
        console.error('[DMF0042] Ver. Cutoff 실패:', message);
        void setAlert({ type: 'alert', content: message });
        return;
      }
      // 완료 안내 — MSG00675 'Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}' (AS-IS 00151)
      void setAlert({
        type: 'alert',
        content: t(MSG.CUTOFF_DONE, '_Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}')
          .replace('{0}', divisionId)
          .replace('{1}', res.message ?? ''),
      });
      setDescription('');
      void refetch?.();
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={900}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Ver. Cutoff</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          {/* ⭐ 실행 스피너 — Cutoff SP 는 수 초~수십 초 걸린다. 3초 만에 사라지는 Loading 토스트로는
              "진행 중"이 안 읽혀 재클릭을 유발한다. 모달 전체를 덮는 스피너로 대체
              (FcstUploadModal / SavePricePeriodModal 과 동일 패턴 — placement='parent'). */}
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={running}
            placement='parent'
          />
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              // ⭐ 조회조건 = Div / Period 만 (2026-08-07 되돌림).
              //   Description 은 조회 필터가 아니라 **Cutoff 실행 인자**(새 버전의 설명)라 하단
              //   실행 버튼 옆으로 되돌렸다. 조회조건 자리에 두면 "이 값으로 거르는 건가"로 읽힌다.
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                {/* ⭐ Period — 부모 화면(BusinessPlanForm)과 동일한 카탈로그 PeriodField(일 달력).
                    AS-IS 도 일 단위 DateTimePicker 라 월 달력(usecase='month')으로 바꾸지 않는다.
                    화면값은 yyyymmdd 그대로 보관하고 SP 파라미터에서만 yyyymm 으로 자른다.
                    required={false} — 모달 Period 는 선택 필터(부모는 필수 조회조건). */}
                <PeriodField
                  gridSize={8}
                  start={startYmd}
                  end={endYmd}
                  onChange={(start, end) => {
                    setStartYmd(start);
                    setEndYmd(end);
                  }}
                />
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<CutoffVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>
          {lastError && <div className={styles.modalErrorBox}>{lastError}</div>}
          <div className={styles.modalActionRow}>
            <span className={styles.modalActionLabel}>Description</span>
            <InputField
              value={description}
              onChange={e => setDescription(e.target.value)}
              placeholder='Version description'
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Cutoff'
              disabled={running}
              onClick={() => void handleCutoff()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
