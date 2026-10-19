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
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
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
  // 메인 화면 조회기간 (yyyymmdd 8자리) — 팝업 Period 기본값 원천.
  mainPeriod: { start: string; end: string };
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
export const VersionCutoffModal = ({ open, modalClose, divisionId, mainPeriod }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<MdfVersionRow>>(undefined);

  // 기간 기본값 = **메인 화면 조회기간 승계** (2026-09-02 사용자 요청으로 변경).
  //   구 동작: AS-IS VersionCutOffPopUp L106~108 의 자기 기본값(오늘 ~ 오늘+5개월)을 그대로 썼다
  //   (sStartDate = DateTime.Now / sEndDate = DateTime.Now.AddMonths(5) → drpPeriod.InitValue).
  //   메인 그리드와 같은 구간의 버전을 바로 보려는 사용 흐름에 맞춰 승계로 바꿨다 — AS-IS 와
  //   의도적으로 다른 지점이니 "AS-IS 1:1" 을 이유로 되돌리지 말 것.
  //   메인 값이 비어 있거나 8자리가 아닐 때만 AS-IS 기본값으로 떨어진다.
  const isYmd8 = (v: string) => /^\d{8}$/.test(v);
  const initialPeriod = () => ({
    from: isYmd8(mainPeriod.start) ? mainPeriod.start : dayjs().format('YYYYMMDD'),
    to: isYmd8(mainPeriod.end) ? mainPeriod.end : dayjs().add(5, 'month').format('YYYYMMDD'),
  });

  const { startYmd, endYmd } = useVersionCutoffModalStore(state => state.period);
  const setPeriod = useVersionCutoffModalStore(state => state.setPeriod);
  const [description, setDescription] = useState('');
  // 조회에 실리는 Description 은 Search 클릭 시점에만 확정한다(appliedDescription). 입력(description)은
  //   Cutoff 실행 인자(새 버전 설명)로만 즉시 반영되고, 타이핑이 그리드 조회를 다시 트리거하지 않는다.
  //   구: filters 가 description 을 직접 dep 으로 물어 키 입력마다 재조회 → 그리드가 실시간 필터되던
  //   것을 제거(2026-09-02 사용자 요청). AS-IS 도 조회(FindData)는 Find 클릭에서만 txtDes 를 싣는다.
  const [appliedDescription, setAppliedDescription] = useState('');
  const [running, setRunning] = useState(false);
  const [lastError, setLastError] = useState('');

  useEffect(() => {
    if (open) {
      const { from, to } = initialPeriod();
      setPeriod({ startYmd: from, endYmd: to });
      setDescription('');
      setAppliedDescription('');
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
  //   실행(Confirm)이 같은 입력칸을 공유하되, 조회는 Find 클릭 시점 값만 싣는다 (L281 · L333 · L529).
  //   여기서는 Search 시 확정된 appliedDescription 만 dep 으로 물어 타이핑 재조회를 막는다.
  const filters = useMemo(
    () => ({
      divisionId,
      versionDescription: appliedDescription,
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS txtType.Text)
      fromYyyymmdd: startYmd,
      toYyyymmdd: endYmd,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, appliedDescription, startYmd, endYmd, sesUserId]
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MDF_VERSION>({
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
  const loading = isLoading || isFetching;

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
            // 조회 버튼은 SearchArea 내장(onSearch)을 쓰고 실행 버튼(Cutoff/Close)은 하단 버튼줄에 둔다 —
            //   PriceBatchInputModal / ReplaceByCutoffModal 등 다른 팝업과 같은 배치다.
            //   구: 3종 모두 extraButtons 로 조회조건 줄에 두었는데(AS-IS Find-Confirm-Close 순 재현),
            //   버튼 그룹이 폭을 크게 먹어 조회조건 4칸이 눌려 필드가 제각각 좁아졌다 (2026-09-02 교정).
            searchButtonLabel={t('LBL00664', 'Search')}
            // Search 클릭에서만 Description 을 조회 필터로 확정한다(appliedDescription). 값이 바뀌면
            //   setState 로 쿼리 키가 바뀌어 자동 재조회되고, 그대로면 키가 안 바뀌므로 refetch 로만
            //   강제 재조회한다(둘 다 부르면 이중 요청이 나가므로 분기).
            onSearch={() => {
              const next = description.trim();
              if (next === appliedDescription) void refetch?.();
              else setAppliedDescription(next);
            }}
            conditions={
              // 조회조건 1행 = Div / Type / Description / Period (2026-09-02 AS-IS 배치로 정렬).
              //   AS-IS VersionCutOffPopUp 상단 줄 순서 그대로다 — Type(BP_M 고정 표시)까지 포함한다.
              //   Description 은 조회 필터이면서 동시에 **Cutoff 실행 인자**(새 버전의 설명)다 —
              //   AS-IS 도 조회(L281)와 실행(L333 · L529)이 같은 입력칸을 공유한다.
              //   배분 2+2+3+4 (+ Description offset 0.5칸 여백) — 4필드를 반드시 한 줄에 둔다 (2026-09-02).
              //   Period 가 달력 2개 각 110px 고정(periodSplit) + 라벨로 약 300px = 4칸을 먹으므로,
              //   나머지 8칸을 값 길이에 맞춰 나눈다. Div 는 division 코드(2~4자) 고정 표시라
              //   Type('BP_M' 고정)과 같은 2칸으로 좁혀 왼쪽에 붙인다 — 3칸이면 빈 입력칸이 넓어
              //   Div~Type 여백이 과하다는 지적(2026-09-02). 좁힌 Div/Type 묶음과 Description 사이는
              //   Description 의 offset 0.5칸으로 살짝 띄운다(붙으면 답답, 1칸은 과하다는 지적, 2026-09-02).
              //   Period 를 4칸 미만으로 줄이면 달력이 넘친다.
              //   라벨 폭은 commonStyles.formItem(HD 50px)으로 좁혀 입력칸을 확보한다.
              <>
                <Grid size={2}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                {/* Type — AS-IS txtType 과 동일하게 'BP_M' 고정 표시(입력 불가).
                    조회·실행 파라미터는 CUTOFF_VER_TYPE 상수를 그대로 쓴다. */}
                <Grid size={2}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00052', 'Type')}
                    labelAlign='right'
                    render={() => <InputField value={CUTOFF_VER_TYPE} disabled />}
                  />
                </Grid>
                {/* Type ~ Description 사이 여백 — offset 0.5칸(약 48px) (2026-09-02 사용자 요청:
                    빈 1칸은 과해 절반으로). offset 은 marginLeft=(offset/12)*100% 라 소수 허용. */}
                <Grid size={3} offset={0.5}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00608', 'Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                        placeholder='Version description'
                      />
                    )}
                  />
                </Grid>
                {/* Period — 부모 화면(BusinessPlanForm)과 동일한 카탈로그 PeriodField(일 달력).
                    AS-IS 도 일 단위 DateTimePicker 라 월 달력(usecase='month')으로 바꾸지 않는다.
                    화면값은 yyyymmdd 그대로 보관하고 SP 파라미터에서만 yyyymm 으로 자른다. */}
                <PeriodField
                  gridSize={4}
                  start={startYmd}
                  end={endYmd}
                  onChange={(start, end) => setPeriod({ startYmd: start, endYmd: end })}
                />
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            {/* 검색조회 로딩 스피너 — 위 Cutoff 실행(running) 스피너와 별개. */}
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <DataGrid<MdfVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>
          {lastError && <div className={styles.modalErrorBox}>{lastError}</div>}

          {/* 실행 버튼줄 — ReplaceByCutoffModal 과 동일 배치(하단 우측). */}
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Cutoff'
              iconComponent={<ControlConfirmIcon size='default' iconSize={20} />}
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
