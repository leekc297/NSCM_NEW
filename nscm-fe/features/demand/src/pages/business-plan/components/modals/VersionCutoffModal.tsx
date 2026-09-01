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
import type { MdfVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callCutoff } from '../../utils/business-plan.api';

import { useVersionCutoffModalStore } from './versionCutoffModalStore';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
}

// 화면 입력·SP 파라미터 모두 일(日) 단위 yyyymmdd 8자리다 (AS-IS DateTimePicker → drpPeriod.Value
//   .ToString("yyyyMMdd") 그대로). 1일/말일로 펼치거나 6자리로 자르지 않는다.

// 버전 목록 grid 컬럼 = AS-IS VersionCutOffPopUp InitSpread L190~198 8종 1:1
//   (Division / Version NO / Type / Description / Cutoff Date / Ver Seq / Update By / Update Date).
//   원천은 DMF0042_GET_DM_MDF_VERSION 커서 — Ver. Cutoff · Replace 두 팝업이 같은 커서를 공유한다.
//   금지: Description 을 Type 앞에 두기 / Created By·Creation Date 를 표시 컬럼으로 쓰기
//   (AS-IS 는 SELECT 에만 있고 그리드에는 Update By/Date 를 쓴다 — 2026-08-25 리뷰).
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 90, align: 'L' as const },
  { key: 'VERSION_NO', header: 'Version No', width: 150, align: 'L' as const },
  { key: 'VERSION_TYPE', header: 'Type', width: 70, align: 'C' as const },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 200, align: 'L' as const },
  { key: 'YYYYMMDD', header: 'Cutoff Date', width: 100, align: 'C' as const },
  { key: 'VER_CRE_SEQ', header: 'Ver Seq', width: 70, align: 'R' as const },
  { key: 'LAST_UPDATED_BY', header: 'Update By', width: 120, align: 'L' as const },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 160, align: 'C' as const },
];

// ⭐ Ver. Cutoff 모달 — AS-IS VersionCutOffPopUp(610줄) 1:1: 기존 버전 목록 조회
//   (DMF0042_GET_DM_MDF_VERSION, versionType='BP_M') + 설명 입력 + Cutoff 실행
//   (DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF — division 단일, createdBy BE주입).
//   완료 안내 = MSG00675 '[Division ID : {0}] {1}' (AS-IS 00151). 권한 게이트 = 부모 hasButton('CUTOFF').
export const VersionCutoffModal = ({ open, modalClose, divisionId }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<MdfVersionRow>>(undefined);

  // 기간 기본값 = **오늘 ~ 오늘+5개월** (AS-IS VersionCutOffPopUp L106~108 1:1):
  //     sStartDate = DateTime.Now / sEndDate = DateTime.Now.AddMonths(5) → drpPeriod.InitValue
  //   금지: 메인 화면 조회기간 승계. AS-IS 는 이 팝업의 기간을 메인과 무관하게 자기 기본값으로 연다
  //   (2026-08-25 실화면 대조 — 메인 2026.08.01~2027.02.28 인데 팝업은 2026-08-25~2027-01-25).
  const defaultPeriod = () => ({
    from: dayjs().format('YYYYMMDD'),
    to: dayjs().add(5, 'month').format('YYYYMMDD'),
  });

  const { startYmd, endYmd } = useVersionCutoffModalStore(state => state.period);
  const setPeriod = useVersionCutoffModalStore(state => state.setPeriod);
  const [description, setDescription] = useState('');
  const [running, setRunning] = useState(false);
  const [lastError, setLastError] = useState('');

  useEffect(() => {
    if (open) {
      const { from, to } = defaultPeriod();
      setPeriod({ startYmd: from, endYmd: to });
      setDescription('');
      setRunning(false);
      setLastError('');
    }
  }, [open]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  // 조회 = DMF0042_GET_DM_MDF_VERSION (AS-IS FindData L278~285 — Replace 팝업과 같은 SP).
  //   금지: DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION 호출. AS-IS 는 versionType 'BP_M' 분기에서
  //   이 SP 만 부르고, 그리드 8컬럼도 이 커서 기준이다 (2026-08-25 리뷰).
  //   파라미터 6종 — 기간은 **yyyymmdd 8자리 그대로** (MDF 계약 P_FROM/TO_YYYYMMDD).
  //   2번째 p_version_description 은 화면 Description 입력값이다 — AS-IS 는 조회(txtDes)와
  //   실행(Confirm)이 같은 입력칸을 공유한다 (L281 · L333 · L529).
  const filters = useMemo(
    () => ({
      divisionId,
      versionDescription: description.trim(),
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS txtType.Text)
      fromYyyymmdd: startYmd,
      toYyyymmdd: endYmd,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, description, startYmd, endYmd, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MDF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.MDF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });
  const versionRows = useMemo<MdfVersionRow[]>(
    () => (data as { data?: MdfVersionRow[] } | undefined)?.data ?? [],
    [data]
  );

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      VERSION_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          horzAlgnCd: c.align,
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
      size={1200}
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
                  onChange={(start, end) => setPeriod({ startYmd: start, endYmd: end })}
                />
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<MdfVersionRow>
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
