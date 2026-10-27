import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import { attachRowNoHeader } from '@foundation/utils';
import { DataGrid, CustomDialog, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';
import { useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../mkt-fcst.constants';
import styles from '../../MktFcst.module.scss';
import { toCellStr } from '../../utils/mkt-fcst.prContext';

import { PR_DETAIL_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 PRPopup (AS-IS DMF0003_PRPopup.cs).
//   트리거: 메인 grid 우클릭 contextMenu Request_PR(.cs L5689) / View_PR(L5746) / Add_History.
//   GET: prPopup sheet SEARCH → DMF0003_GET_PRPOPUP (14 IN + O_RC1 DETAIL / O_RC2 HEADER / O_RC3 ERR_MSG).
//   SAVE: prPopup sheet SAVE → DMF0003_SAVE_PRPOPUP (20 IN + R_REQUEST_NO/R_ERROR_MSG).
//     - Request_PR : PR Header/Purchasing Mgr/Group 입력 후 발행 (^delim 다건, AS-IS L346~402).
//     - View_PR    : 기 발행 PR read-only.
export interface PrModalParams {
  popupType: 'Request_PR' | 'View_PR' | 'Add_History';
  divisionId: string;
  projectCode: string;
  scmSiteId: string; // ^delim 다건
  itemId: string; // ^delim 다건
  domExp: string;
  fcstType: string;
  incoterms: string;
  plantSiteId: string;
  yyyymmdd: string; // ^delim 다건
  planQty: string; // ^delim 다건
}

interface PrModalProps {
  open: boolean;
  modalClose: () => void;
  params: PrModalParams | null;
  onSaved?: () => void;
}

export const PrModal = ({ open, modalClose, params, onSaved }: PrModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.PR_POPUP>>>();
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // ⭐ 격차⑦ (2026-07-03) — SAVE 성공 후 AS-IS(L419~421)처럼 View_PR 전환 + 재조회 + 팝업 유지.
  //   effectiveType 이 조회/편집성의 단일 기준 (params.popupType 은 진입값).
  const [effectiveType, setEffectiveType] = useState<PrModalParams['popupType']>('View_PR');
  useEffect(() => {
    if (open && params) setEffectiveType(params.popupType);
  }, [open, params]);
  const isReadOnly = effectiveType === 'View_PR';

  // PR Header 입력 영역 (Request_PR / Add_History 시 편집)
  const [prHeader, setPrHeader] = useState('');
  const [puchMgr, setPuchMgr] = useState('');
  const [puchGroup, setPuchGroup] = useState('');

  // useTabProcQuery 는 filters 참조가 바뀌면 캐시를 버리고 재조회한다. 인라인
  // 리터럴로 넘기면 prHeader/puchMgr/puchGroup 입력 같은 무관한 로컬 state가 바뀔
  // 때마다 새 참조가 생겨 그리드가 깜빡였다 — useMemo 로 참조를 실제 조건에 고정한다.
  const filters = useMemo(
    () => ({
      popupType: open && params ? effectiveType : '',
      requestNo: '',
      divisionId: params?.divisionId ?? '',
      projectCode: params?.projectCode ?? '',
      scmSiteId: params?.scmSiteId ?? '',
      itemId: params?.itemId ?? '',
      domExp: params?.domExp ?? '',
      fcstType: params?.fcstType ?? '',
      incoterms: params?.incoterms ?? '',
      plantSiteId: params?.plantSiteId ?? '',
      yyyymmdd: params?.yyyymmdd ?? '',
      planQty: params?.planQty ?? '',
    }),
    [open, params, effectiveType]
  );

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.PR_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.PR_POPUP,
    tabId: 'PrModal',
    filters,
    enabled: open && !!params,
  });

  const detailRows = data?.o_rc1 ?? [];
  const header = data?.o_rc2?.[0];
  const errMsg = data?.o_rc3?.[0]?.ERR_MSG;

  // ⭐ 격차① (2026-07-03) — AS-IS Edit 해제 컬럼 1:1 (L280~289):
  //   Request_PR : STORAGE_PLANT_ID / SLOC / ITEM_DETAIL 편집.
  //   Add_History: 위 3종 + QTY 추가 편집 (L282~284).
  //   View_PR    : 전체 read-only.
  const gridColumns = useMemo(() => {
    if (effectiveType === 'View_PR') return PR_DETAIL_COLUMNS;
    const editable = new Set(
      effectiveType === 'Add_History'
        ? ['STORAGE_PLANT_ID', 'SLOC', 'ITEM_DETAIL', 'QTY']
        : ['STORAGE_PLANT_ID', 'SLOC', 'ITEM_DETAIL']
    );
    return PR_DETAIL_COLUMNS.map(c =>
      editable.has(c.colNm) ? { ...c, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL } : c
    );
  }, [effectiveType]);

  // O_RC3 ERR_MSG 존재 → 안내 후 닫기 (AS-IS L487~494).
  useEffect(() => {
    if (!open) return;
    if (errMsg && String(errMsg).trim()) {
      void setAlert({ type: 'alert', content: String(errMsg) });
      modalClose();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [errMsg, open]);

  // 헤더(O_RC2) → 입력 필드 동기화 (AS-IS SetChangeRequestInfo, L518~529).
  useEffect(() => {
    if (header) {
      setPrHeader(String(header.PR_HEADER ?? ''));
      setPuchMgr(String(header.PUCH_MGR ?? ''));
      setPuchGroup(String(header.PUCH_GROUP ?? ''));
    } else {
      setPrHeader('');
      setPuchMgr('');
      setPuchGroup('');
    }
  }, [header]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, detailRows]);

  // SAVE — DMF0003_SAVE_PRPOPUP. ^delim 다건은 GET filters(이미 ^delim)를 재사용 (AS-IS L346~402).
  //   useProcMutation 은 array unfold → top-level ^delim payload 부적합. apiClient.post 직접 (memory
  //   feedback_save_sp_bulk_payload_apiclient_post). createdBy 는 BE 세션 자동(PROC_M createdBy).
  const handleSave = async () => {
    if (!params) return;
    const ok = await setAlert({
      type: 'confirm',
      content: t('MSG00649', '_Issue PR?'),
    });
    if (!ok) return;

    // detailRows(O_RC1) 의 행 단위 ^delim 재구성 (AS-IS i 루프 L346~372).
    const detail = detailRows as Record<string, unknown>[];
    const join = (key: string) => detail.map(r => toCellStr(r[key])).join('^');
    const payload = {
      popupType: effectiveType,
      itemSeq: detail.map((_r, i) => String(i + 1)).join('^'),
      divisionId: detail.map(() => params.divisionId).join('^'),
      projectCode: detail.map(() => params.projectCode).join('^'),
      scmSiteId: join('SCM_SITE_ID'),
      itemId: join('ITEM_ID'),
      domExp: detail.map(() => params.domExp).join('^'),
      fcstType: detail.map(() => params.fcstType).join('^'),
      incoterms: detail.map(() => params.incoterms).join('^'),
      plantSiteId: detail.map(() => params.plantSiteId).join('^'),
      yyyymmdd: detail.map(r => toCellStr(r.YYYYMMDD).replace(/-/g, '')).join('^'),
      uom: join('ITEM_UOM'),
      planQty: join('QTY'),
      storageId: join('SLOC'),
      storagePlantId: join('STORAGE_PLANT_ID'),
      puchMgr: detail.map(() => puchMgr).join('^'),
      puchGroup: detail.map(() => puchGroup).join('^'),
      prHeader: detail.map(() => prHeader).join('^'),
      prItemDetail: join('ITEM_DETAIL'),
      createdBy: useSessionStore.getState().session.userId ?? '',
    };

    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.PR_POPUP}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00651', '_Failed to issue PR.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      // ⭐ 격차⑦ — AS-IS L418~421 1:1: 성공(건수 표기) → View_PR 전환 + 재조회, **팝업 유지**.
      void setToast({
        message: `${t('MSG00650', '_PR issued.')} (${detail.length})`,
        type: 'success',
      });
      onSaved?.();
      if (effectiveType === 'View_PR') void refetch?.();
      else setEffectiveType('View_PR'); // filters.popupType 변경 → react-query 자동 재조회
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00651', '_Failed to issue PR.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00696', '_PR Request')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            conditions={
              <>
                {/* ⭐ 격차② — AS-IS 헤더 표시 4필드 (SetChangeRequestInfo L520~525): Request No /
                    Division / Requested By / Request Date — O_RC2 전체 동기화(표시 전용). */}
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00744', '_Request No')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={String(header?.REQUEST_NO ?? '')} />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00641', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={String(header?.DIVISION_NAME ?? '')} />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00746', '_Requested By')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={String(header?.REQUESTED_BY ?? '')} />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00747', '_Request Date')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={String(header?.REQUEST_DATE ?? '')} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00697', '_PR Header')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled={isReadOnly}
                        value={prHeader}
                        onChange={e => setPrHeader(e.target.value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00698', '_Purchasing Mgr')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled={isReadOnly}
                        value={puchMgr}
                        onChange={e => setPuchMgr(e.target.value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00699', '_Purchasing Group')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled={isReadOnly}
                        value={puchGroup}
                        onChange={e => setPuchGroup(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.modalGridWrapper}>
            {/* ⭐ 격차① — isReadOnly 하드코딩 제거. popupType 별 편집 컬럼(inputTpCd) 로 제어
                (Add_History = QTY 포함 편집, AS-IS L282~284). key 로 컬럼 rebuild. */}
            <ResultArea
              title=''
              count={detailRows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MENU_ID, SHEETS.PR_POPUP>>
                key={effectiveType}
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly={isReadOnly}
                staticColumns={gridColumns}
                itemsSource={detailRows}
              />
            </ResultArea>
          </div>
          <div className={styles.modalButtonWrapper}>
            {!isReadOnly && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='Save'
                onClick={handleSave}
              />
            )}
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
