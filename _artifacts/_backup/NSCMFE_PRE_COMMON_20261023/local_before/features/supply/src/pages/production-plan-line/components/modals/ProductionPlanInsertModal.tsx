import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { Button, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { LBL, MENU_ID, MSG, SHEETS } from '../../production-plan-line.constants';
import { MOCK_MAIN_ENABLED } from '../../production-plan-line.mock'; // ⚠ 임시 개발용 목데이터
import { isEeDivision } from '../../utils/productionPlanLineEditLock';

import styles from './ProductionPlanInsertModal.module.scss';

// AS-IS SCM0002_ProductionPlanInsertPopup(공통 라인배정 팝업) 을 화면 전용 모달로 재현(design 01 R5, M1).
//   흐름: Model→Plant Site→Line 캐스케이드로 신규 라인을 배정(EE 는 Origin Div 선행) → 행 추가(다건) →
//   저장 시 행별 newCheck(중복/TactTime 검증 S/L/T) 통과 후 savePopup 저장 → 부모 재조회.
//   데이터 원천(ora.py 실측 2026-10-02):
//     - Item 후보  : combo ItemProdPlanLinePopup_SCP(@divisionId,@operationGroup,@originDivisionId)
//                    → CODE(itemId)/NAME/PLANT_SITE_ID/SITE_DESCRIPTION/NICK_NAME/ITEM_TYPE/OPERATION_ID/DIVISION_ID/OSP_YN
//     - Line 후보  : combo LineProdPlanLinePopup_SCP(@divisionId,@operationGroup,@plantSiteId,@operationId,@originDivisionId,@itemId)
//     - Origin Div : combo OriginDivFromFinalItem_SCP(@itemId) (EE 전용)
//     - 검증 SP    : newCheck=P_SCP0013_GET_LINE_NEW_CHECK(9 IN) / 저장 SP=savePopup=P_SCP0013_SAVE_LINE_POPUP(sesUserId BE 주입)
//   PROC_M 파라미터 키(COL_NM) 실측: divisionId·planDate·planType·seq·itemId·lineId·operationGroup·scmSiteId·originDivisionId.

interface Option {
  label: string;
  value: string;
}

// ItemProdPlanLinePopup_SCP 반환 행(= AS-IS dtItemPlant).
interface ItemPlantRow {
  CODE?: string; // ITEM_ID
  NAME?: string;
  PLANT_SITE_ID?: string;
  SITE_DESCRIPTION?: string;
  NICK_NAME?: string;
  ITEM_TYPE?: string;
  OPERATION_ID?: string;
  DIVISION_ID?: string; // originDivisionId 원천(EE)
  OSP_YN?: string;
}

// 저장 대기 라인 행(화면에 추가된 신규 라인). _key = 리스트 안정 key(중복 행 허용 대비).
interface StagedRow {
  _key?: number;
  originDivisionId: string;
  itemId: string;
  nickName: string;
  itemType?: string; // 스테이징 표 Item Type 컬럼(화면설계서 R37). 추가 시 선택 Item 행에서 채운다.
  plantSiteId: string;
  plantSiteName: string;
  operationId: string;
  lineId: string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  // newCheck/savePopup 공통 파라미터 원천 — 부모 조회조건(design 01 R5 cs:866-871).
  params: {
    divisionId: string;
    operationGroupId: string;
    planStartYyyymmdd: string;
    planType: string;
    planSeq: string;
  };
  // 저장 성공 후 부모 재조회(AS-IS FindData_Main). 취소(modalClose)는 저장 없이 닫는다.
  onSaved: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const ProductionPlanInsertModal = ({ open, modalClose, params, onSaved }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const isEe = isEeDivision(params.divisionId);

  const requiredMsg = (label: string): string =>
    t(MSG.REQUIRED_FIELD, '_{0} is required.').replace('{0}', label);

  const [itemPlantRows, setItemPlantRows] = useState<ItemPlantRow[]>([]);
  const [originDivOptions, setOriginDivOptions] = useState<Option[]>([]);
  const [lineOptions, setLineOptions] = useState<Option[]>([]);
  // 편집 중 행(캐스케이드 단일 행) — 추가 버튼으로 staged 로 승격.
  const [draft, setDraft] = useState<StagedRow>({
    originDivisionId: isEe ? '' : params.divisionId,
    itemId: '',
    nickName: '',
    plantSiteId: '',
    plantSiteName: '',
    operationId: '',
    lineId: '',
  });
  const [staged, setStaged] = useState<StagedRow[]>([]);
  const [saving, setSaving] = useState(false);
  const keyRef = useRef(0);

  // 팝업 오픈 시 Item 후보 조회(division/opGroup). originDivisionId 는 빈값(전체) — 행별 origin div 로 좁힌다.
  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    const load = async () => {
      try {
        const rows = await apiClient.getCombo({
          comboId: 'ItemProdPlanLinePopup_SCP',
          divisionId: params.divisionId,
          operationGroup: params.operationGroupId,
          originDivisionId: '',
        });
        if (!cancelled) setItemPlantRows(rows as unknown as ItemPlantRow[]);
      } catch {
        if (!cancelled) setItemPlantRows([]);
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
  }, [open, params.divisionId, params.operationGroupId]);

  // 팝업 재오픈/닫힘 시 상태 초기화.
  useEffect(() => {
    if (open) return;
    setStaged([]);
    setLineOptions([]);
    setOriginDivOptions([]);
    setDraft({
      originDivisionId: isEe ? '' : params.divisionId,
      itemId: '',
      nickName: '',
      plantSiteId: '',
      plantSiteName: '',
      operationId: '',
      lineId: '',
    });
  }, [open, isEe, params.divisionId]);

  const itemOptions = useMemo<Option[]>(() => {
    const seen = new Set<string>();
    const opts: Option[] = [];
    for (const r of itemPlantRows) {
      const code = str(r.CODE);
      if (!code || seen.has(code)) continue;
      seen.add(code);
      opts.push({ value: code, label: str(r.NAME) || code });
    }
    return opts;
  }, [itemPlantRows]);

  // 선택 Item(+EE 면 originDiv) 기준 Plant Site 후보 — AS-IS dtItemPlant.Select(CODE=item[ AND DIVISION_ID=originDiv]).
  const plantOptions = useMemo<Option[]>(() => {
    if (!draft.itemId) return [];
    const opts: Option[] = [];
    const seen = new Set<string>();
    for (const r of itemPlantRows) {
      if (str(r.CODE) !== draft.itemId) continue;
      if (isEe && draft.originDivisionId && str(r.DIVISION_ID) !== draft.originDivisionId) continue;
      const code = str(r.PLANT_SITE_ID);
      if (!code || seen.has(code)) continue;
      seen.add(code);
      opts.push({ value: code, label: str(r.SITE_DESCRIPTION) || code });
    }
    return opts;
  }, [itemPlantRows, draft.itemId, draft.originDivisionId, isEe]);

  // Item 선택 — nick/itemType 세팅, plant/line 초기화. EE 면 Origin Div 후보 조회.
  const onItemChange = async (itemId: string) => {
    const row = itemPlantRows.find(r => str(r.CODE) === itemId);
    setDraft(d => ({
      ...d,
      itemId,
      nickName: str(row?.NICK_NAME),
      plantSiteId: '',
      plantSiteName: '',
      operationId: '',
      lineId: '',
      ...(isEe ? { originDivisionId: '' } : {}),
    }));
    setLineOptions([]);
    if (isEe && itemId) {
      try {
        const rows = await apiClient.getCombo({ comboId: 'OriginDivFromFinalItem_SCP', itemId });
        setOriginDivOptions((rows as unknown as { CODE?: string; NAME?: string }[]).map(r => ({ value: str(r.CODE), label: str(r.NAME) || str(r.CODE) })));
      } catch {
        setOriginDivOptions([]);
      }
    }
  };

  const onOriginDivChange = (originDivisionId: string) => {
    setDraft(d => ({ ...d, originDivisionId, plantSiteId: '', plantSiteName: '', operationId: '', lineId: '' }));
    setLineOptions([]);
  };

  // Plant Site 선택 — operationId 파생 후 Line 후보 조회. AS-IS(SCM0002_ProductionPlanInsertPopup.cs:683-706)
  //   는 OSP·비OSP 를 구분하지 않고 둘 다 LineProdPlanLinePopup 로 실제 라인을 로드한다. OSP 의 '-' 단일
  //   세팅은 2007-02-07(소스 주석 '200207') 에 주석처리된 死코드다 — 이전 포팅이 그 死코드를 되살려 OSP
  //   품목(div82/Pack 257/340)의 Line 을 '-' 로 막았던 것을 제거한다. OSP 품도 실제 라인이 있다(함수
  //   FN_SCP_LINE_PROD_PLAN_LINE_POPUP 가 K2P11 등 반환). 이제 OSP·비OSP 동일 경로로 실제 라인을 조회한다.
  const onPlantChange = async (plantSiteId: string) => {
    const row = itemPlantRows.find(
      r => str(r.CODE) === draft.itemId && str(r.PLANT_SITE_ID) === plantSiteId
    );
    const operationId = str(row?.OPERATION_ID);
    setDraft(d => ({ ...d, plantSiteId, plantSiteName: str(row?.SITE_DESCRIPTION) || plantSiteId, operationId, lineId: '' }));
    try {
      const rows = await apiClient.getCombo({
        comboId: 'LineProdPlanLinePopup_SCP',
        divisionId: params.divisionId,
        operationGroup: params.operationGroupId,
        plantSiteId,
        operationId,
        originDivisionId: draft.originDivisionId,
        itemId: draft.itemId,
      });
      setLineOptions((rows as unknown as { CODE?: string; NAME?: string }[]).map(r => ({ value: str(r.CODE), label: str(r.NAME) || str(r.CODE) })));
    } catch {
      setLineOptions([]);
    }
  };

  // 행 추가 — 필수(Origin Div[EE]/Model/Plant Site/Line) 검증 후 staged 로 승격, draft 리셋.
  const handleAdd = () => {
    if (isEe && !draft.originDivisionId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.DIVISION, '_Origin Div')) });
      return;
    }
    if (!draft.itemId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.MODEL, '_Model')) });
      return;
    }
    if (!draft.plantSiteId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.PLANT_SITE, '_Plant Site')) });
      return;
    }
    if (!draft.lineId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.LINE, '_Line')) });
      return;
    }
    const itemRow = itemPlantRows.find(r => str(r.CODE) === draft.itemId);
    setStaged(rows => [
      ...rows,
      { ...draft, itemType: str(itemRow?.ITEM_TYPE), _key: keyRef.current++ },
    ]);
    setDraft({
      originDivisionId: isEe ? '' : params.divisionId,
      itemId: '',
      nickName: '',
      plantSiteId: '',
      plantSiteName: '',
      operationId: '',
      lineId: '',
    });
    setLineOptions([]);
  };

  const handleRemove = (idx: number) => setStaged(rows => rows.filter((_, i) => i !== idx));

  // 저장 — 행별 newCheck(S=정상/L=이미등록/T=TactTime없음) 통과 후 savePopup. 하나라도 실패 시 중단.
  const handleSave = async () => {
    if (staged.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_TARGET, '_No row to save.') });
      return;
    }
    setSaving(true);
    try {
      for (const row of staged) {
        if (MOCK_MAIN_ENABLED) continue; // ⚠ 임시: mock 시 newCheck/savePopup SP 생략, 전부 정상(S) 저장으로 간주
        const common = {
          divisionId: params.divisionId,
          planDate: params.planStartYyyymmdd,
          planType: params.planType,
          seq: params.planSeq,
          itemId: row.itemId,
          lineId: row.lineId,
          operationGroup: params.operationGroupId,
          scmSiteId: row.plantSiteId,
          originDivisionId: row.originDivisionId,
        };
        // 1) newCheck — O_RC1 첫 컬럼 상태코드(AS-IS Rows[0][0]): S 정상 / L 이미등록 / T TactTime 없음.
        const checkRes = await apiClient.callProc<MENU_ID, SHEETS.NEW_CHECK>(
          MENU_ID,
          SHEETS.NEW_CHECK,
          'SEARCH',
          common
        );
        if (Number(checkRes.code)) {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
          return;
        }
        const checkRow = ((checkRes.result as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [])[0];
        const status = checkRow ? str(Object.values(checkRow)[0]) : '';
        const detail = checkRow ? str(Object.values(checkRow)[1]) : `${row.plantSiteId}/${row.lineId}/${row.itemId}`;
        if (status !== 'S') {
          // L=이미 등록 / T=Tact Time 미등록 / 그 외=시스템오류 (AS-IS MSG00263/00264/00042).
          const content =
            status === 'L'
              ? t('MSG00263', '_Production plan already registered.\n{0}').replace('{0}', detail)
              : status === 'T'
                ? t('MSG00264', '_Tact Time is not registered.\n{0}').replace('{0}', detail)
                : t(MSG.SAVE_FAIL, '_Failed to save.');
          void setAlert({ type: 'alert', content });
          return;
        }
        // 2) savePopup — 저장(sesUserId 는 BE @LoginUser 주입이라 미전달).
        const saveRes = await apiClient.callProc<MENU_ID, SHEETS.SAVE_POPUP>(
          MENU_ID,
          SHEETS.SAVE_POPUP,
          'SAVE',
          common
        );
        if (Number(saveRes.code)) {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
          return;
        }
      }
      // 저장 성공(TO-BE MSG00002 "Saved successfully." — constants MSG 역매핑 주석 참조).
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      onSaved();
      modalClose();
    } catch {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      size={900}
      height={400}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.NEW, '_New')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrap}>
          {/* 고정 컨텍스트(부모 조회조건) + 캐스케이드 입력 행 */}
          <Grid container spacing={1} alignItems='flex-end'>
            {isEe && (
              <Grid size={2}>
                <FormItem
                  className={commonStyles.formItem}
                  label={t(LBL.DIVISION, '_Origin Div')}
                  labelAlign='right'
                  required
                  render={() => (
                    <CustomDropdown
                      value={draft.originDivisionId}
                      options={originDivOptions}
                      onChange={(_, picked) => onOriginDivChange(str(picked))}
                    />
                  )}
                />
              </Grid>
            )}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL, '_Model')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={draft.itemId}
                    options={itemOptions}
                    onChange={(_, picked) => void onItemChange(str(picked))}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLANT_SITE, '_Plant Site')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={draft.plantSiteId}
                    options={plantOptions}
                    disabled={!draft.itemId || (isEe && !draft.originDivisionId)}
                    onChange={(_, picked) => void onPlantChange(str(picked))}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.LINE, '_Line')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={draft.lineId}
                    options={lineOptions}
                    disabled={!draft.plantSiteId}
                    onChange={(_, picked) => setDraft(d => ({ ...d, lineId: str(picked) }))}
                  />
                )}
              />
            </Grid>
            <Grid size={1}>
              <Button appearance='outlined' priority='normal' size='medium' buttonLabel='＋' onClick={handleAdd} />
            </Grid>
          </Grid>

          {/* 추가된 라인 목록(저장 대기) — 화면설계서 R37 컬럼 규정의 표(AS-IS SCM0002 FpSpread 복원). */}
          <div className={styles.stagedWrap}>
            <table className={styles.stagedTable}>
              <thead>
                <tr>
                  <th className={styles.numCell}>No</th>
                  <th>{t(LBL.PLAN_DATE, '_Plan Date')}</th>
                  <th>{t(LBL.PLAN_TYPE, '_Plan Type')}</th>
                  <th>{t(LBL.SEQ, '_Seq')}</th>
                  <th>{t(LBL.DIVISION, '_Div')}</th>
                  {isEe && <th>Origin Div</th>}
                  <th>{t(LBL.OPERATION_GROUP, '_Operation Group')}</th>
                  <th>{t(LBL.MODEL, '_Model')}</th>
                  <th>{t(LBL.NICK_NAME, '_Nick Name')}</th>
                  <th>Item Type</th>
                  <th>{t(LBL.PLANT_SITE, '_Plant Site')}</th>
                  <th>{t(LBL.LINE, '_Line')}</th>
                  <th className={styles.actionCell} />
                </tr>
              </thead>
              <tbody>
                {staged.map((row, idx) => (
                  <tr key={row._key}>
                    <td className={styles.numCell}>{idx + 1}</td>
                    <td>{params.planStartYyyymmdd}</td>
                    <td>{params.planType}</td>
                    <td>{params.planSeq}</td>
                    <td>{params.divisionId}</td>
                    {isEe && <td>{row.originDivisionId}</td>}
                    <td>{params.operationGroupId}</td>
                    <td>{row.itemId}</td>
                    <td>{row.nickName}</td>
                    <td>{row.itemType}</td>
                    <td>{row.plantSiteName}</td>
                    <td>{row.lineId}</td>
                    <td className={styles.actionCell}>
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel='×'
                        onClick={() => handleRemove(idx)}
                      />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <Stack direction='row' spacing={1} justifyContent='flex-end' marginTop={1}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, '_Save')}
              disabled={saving || staged.length === 0}
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
