import { useCallback, useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  GM_DIVISION_LOOKUP_TYPE,
  MENU_ID,
  MSG,
  MSG_FALLBACK,
  PARAMETER_NORMAL,
  PLAN_ID_INFO_RESPONSE_SET,
  SHEETS,
  SYS_PLAN_TYPE_SCP,
  SYS_PROD_LOOKUP_TYPE,
  SYS_SHIP_LOOKUP_TYPE,
  TGT_DIVS_PACK,
} from '../plan-control.constants';
import type { PlanIdCreateContext } from '../plan-control.types';
import { str, toComboOptions } from '../utils/planControl.activity';

import styles from './PlanIdCreatePopup.module.scss';

interface Props {
  // null 이면 닫힘. 값이 있으면 생성(planId='')·조회(planId 있음) 모드로 연다.
  context: PlanIdCreateContext | null;
  onClose: () => void;
  // 저장 성공(AS-IS DialogResult.OK) — Plan ID 재조회 + 메인 재조회를 호출부가 수행한다(cs:1064-1072).
  onSaved: () => void;
}

type Option = { label: string; value: string };

// GET 커서가 주는 날짜는 'YYYY-MM-DD'(frozenInfo TO_CHAR) 또는 'YYYYMMDD'(planInfo 테이블 원본)가
//   섞여 온다. 둘 다 Dayjs 로 정규화한다(표시·검증 공통). 빈 값/형식 불명은 null.
const toDate = (value: unknown): ReturnType<typeof dayjs> | null => {
  const s = str(value).trim();
  if (/^\d{8}$/.test(s)) return dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`);
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) return dayjs(s.slice(0, 10));
  return null;
};
// 저장 파라미터는 전부 yyyyMMdd(AS-IS .Replace("-","")). null 은 ''(No Frozen 등).
const toYmd = (date: ReturnType<typeof dayjs> | null): string => (date ? date.format('YYYYMMDD') : '');

const EMPTY: ComboResponse[] = [];

// SCP0123_PlanIDCreatePopup — A002 Create Plan ID 팝업. 생성 모드(planId='')는 초기정보로 폼을
//   채우고 Create 로 저장한다. 조회 모드(planId 있음)는 기생성 Plan ID 상세를 읽기전용으로 보여준다.
//   인터페이스(GET/SAVE)는 FE call-proc 로만 배선한다 — BE·엔진은 이미 배포됨(화면단 작업).
export const PlanIdCreatePopup = ({ context, onClose, onSaved }: Props) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const sessionUserId = useSessionStore(state => state.session.userId);

  const open = context !== null;
  const viewMode = !!context?.planId; // 기생성 Plan ID 조회 = 전 필드 읽기전용(AS-IS Set_PlanID_Info)
  const isPack = context?.tgtDivsCd === TGT_DIVS_PACK; // 'P' 아니면 Cell 숨김 + Prod→Cell 저장 치환

  // 초기정보(GET 5커서) + 콤보 후보.
  const [prodSysOptions, setProdSysOptions] = useState<Option[]>([]);
  const [shipSysOptions, setShipSysOptions] = useState<Option[]>([]);
  const [fpPlanList, setFpPlanList] = useState<ComboResponse[]>(EMPTY);
  const [scpPlanList, setScpPlanList] = useState<ComboResponse[]>(EMPTY);

  // 폼 값.
  const [prodCd, setProdCd] = useState('');
  const [prodPlanId, setProdPlanId] = useState('');
  const [shipCd, setShipCd] = useState('');
  const [shipPlanId, setShipPlanId] = useState('');
  const [horizonEnd, setHorizonEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [fcstVersion, setFcstVersion] = useState('');
  const [prodEnd, setProdEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [cellEnd, setCellEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [shipEnd, setShipEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [desc, setDesc] = useState('');
  const [prodNoFrozen, setProdNoFrozen] = useState(false);
  const [cellNoFrozen, setCellNoFrozen] = useState(false);
  const [shipNoFrozen, setShipNoFrozen] = useState(false);
  // frozenInfo 기본값(No Frozen 해제 시 복원) — tgt 일치 행의 prod/ship frozen date.
  const [defaultProdEnd, setDefaultProdEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [defaultShipEnd, setDefaultShipEnd] = useState<ReturnType<typeof dayjs> | null>(null);
  const [saving, setSaving] = useState(false);

  const planStart = useMemo(() => toDate(context?.planStartYyyymmdd), [context?.planStartYyyymmdd]);
  const planStartText = planStart ? planStart.format('YYYY-MM-DD') : '';

  // RefreshPlanId — 선택 System(plan_type)에 맞는 Plan ID 후보. SCP 면 scpPlanList 전건,
  //   그 외(FP/SSP)는 fpPlanList 의 PLAN_TYPE 필터(AS-IS RefreshPlanId cs:400-412).
  const planIdOptionsFor = useCallback(
    (sysCd: string): Option[] =>
      sysCd === SYS_PLAN_TYPE_SCP
        ? toComboOptions(scpPlanList)
        : toComboOptions(fpPlanList.filter(row => str(row.PLAN_TYPE) === sysCd)),
    [fpPlanList, scpPlanList]
  );
  const prodPlanOptions = useMemo(() => planIdOptionsFor(prodCd), [planIdOptionsFor, prodCd]);
  const shipPlanOptions = useMemo(() => planIdOptionsFor(shipCd), [planIdOptionsFor, shipCd]);

  // 열릴 때 1회: 콤보 + 초기정보 조회 후 폼을 채운다.
  useEffect(() => {
    if (!context) return;
    let cancelled = false;

    const load = async () => {
      try {
        const [prodSysRaw, shipSysRaw, gmDivs] = await Promise.all([
          apiClient.getCombo({ comboId: 'LookupCommon', lookupType: SYS_PROD_LOOKUP_TYPE }),
          apiClient.getCombo({ comboId: 'LookupCommon', lookupType: SYS_SHIP_LOOKUP_TYPE }),
          apiClient.getCombo({ comboId: 'LookupCommon', lookupType: GM_DIVISION_LOOKUP_TYPE }),
        ]);
        const res = await apiClient.callProc<MENU_ID, SHEETS.PLAN_ID_INFO>(
          MENU_ID,
          SHEETS.PLAN_ID_INFO,
          BUTTON_TYPE.SEARCH,
          {
            divisionId: context.divisionId,
            planGroupId: context.planGroupId,
            planStartYyyymmdd: context.planStartYyyymmdd,
            planId: context.planId,
          }
        );
        if (cancelled) return;

        // GM(일단위 Rolling) Division 은 생성 시 Frozen Plan 후보에서 SCP 를 제외한다(AS-IS cs:115-125).
        //   조회 모드는 저장된 값 표시이므로 제외하지 않는다.
        const isGm =
          !viewMode &&
          (gmDivs).some(row => str(row.CODE) === context.divisionId);
        const filterScp = (rows: ComboResponse[]): ComboResponse[] =>
          isGm ? rows.filter(row => str(row.CODE) !== SYS_PLAN_TYPE_SCP) : rows;
        const prodSys = filterScp(prodSysRaw);
        const shipSys = filterScp(shipSysRaw);

        const result = res.code === '0' ? res.result : undefined;
        const horizon = result?.[PLAN_ID_INFO_RESPONSE_SET.HORIZON]?.[0];
        const frozen = result?.[PLAN_ID_INFO_RESPONSE_SET.FROZEN] ?? [];
        const fpList = result?.[PLAN_ID_INFO_RESPONSE_SET.FP_PLAN] ?? [];
        const scpList = result?.[PLAN_ID_INFO_RESPONSE_SET.SCP_PLAN] ?? [];
        const planInfo = result?.[PLAN_ID_INFO_RESPONSE_SET.PLAN_INFO]?.[0];

        setProdSysOptions(toComboOptions(prodSys));
        setShipSysOptions(toComboOptions(shipSys));
        setFpPlanList(fpList as ComboResponse[]);
        setScpPlanList(scpList as ComboResponse[]);

        // Horizon / Version.
        setHorizonEnd(toDate(horizon?.HORIZON_END_DATE));
        setFcstVersion(str(horizon?.VERSION_NO));

        // Frozen 기본값 — tgt_divis_cd 와 일치하는 OPERATION_GROUP 행의 날짜.
        const match = frozen.find(row => str(row.OPERATION_GROUP) === context.tgtDivsCd);
        const dProd = match ? toDate(match.PROD_FROZEN) : dayjs();
        const dShip = match ? toDate(match.SHIP_FROZEN) : dayjs();
        setDefaultProdEnd(dProd);
        setDefaultShipEnd(dShip);
        setProdEnd(dProd);
        setCellEnd(dProd);
        setShipEnd(dShip);

        // System 기본 선택 = 첫 후보(AS-IS SelectedIndex=0). Plan ID 는 그 후보의 첫 항목.
        const prodOpts = toComboOptions(prodSys);
        const shipOpts = toComboOptions(shipSys);
        const firstProdCd = prodOpts[0]?.value ?? '';
        const firstShipCd = shipOpts[0]?.value ?? '';
        const firstPlanId = (sysCd: string): string =>
          (sysCd === SYS_PLAN_TYPE_SCP
            ? toComboOptions(scpList as ComboResponse[])
            : toComboOptions((fpList as ComboResponse[]).filter(r => str(r.PLAN_TYPE) === sysCd)))[0]
            ?.value ?? '';

        if (viewMode && planInfo) {
          // 조회 모드 — 저장값으로 덮고 전 필드 잠근다(AS-IS Set_PlanID_Info cs:202-263).
          setProdCd(str(planInfo.PROD_REF_SYS_DIVS_CD));
          setProdPlanId(str(planInfo.PROD_REF_SYS_PLAN_ID));
          setShipCd(str(planInfo.SHIP_REF_SYS_DIVS_CD));
          setShipPlanId(str(planInfo.SHIP_REF_SYS_PLAN_ID));
          setDesc(str(planInfo.OPMZ_PLAN_DESC));
          setHorizonEnd(toDate(planInfo.PLAN_END_YYYYMMDD));
          setProdNoFrozen(str(planInfo.PROD_NO_FROZEN_YN) === 'Y');
          setCellNoFrozen(str(planInfo.CELL_NO_FROZEN_YN) === 'Y');
          setShipNoFrozen(str(planInfo.SHIP_NO_FROZEN_YN) === 'Y');
          const pProdEnd = toDate(planInfo.PMDU_PROD_FRZ_END_YYYYMMDD);
          const pCellEnd = toDate(planInfo.CELL_PROD_FRZ_END_YYYYMMDD);
          setShipEnd(toDate(planInfo.SHIP_FRZ_END_YYYYMMDD));
          // Cell/전극(비Pack)은 Cell 값을 Prod 칸에 투영한다(AS-IS cs:244-248).
          if (!isPack) {
            setProdEnd(pCellEnd);
            setCellEnd(pCellEnd);
            setProdNoFrozen(str(planInfo.CELL_NO_FROZEN_YN) === 'Y');
          } else {
            setProdEnd(pProdEnd);
            setCellEnd(pCellEnd);
          }
        } else {
          setProdCd(firstProdCd);
          setShipCd(firstShipCd);
          setProdPlanId(firstPlanId(firstProdCd));
          setShipPlanId(firstPlanId(firstShipCd));
          setDesc('');
          setProdNoFrozen(false);
          setCellNoFrozen(false);
          setShipNoFrozen(false);
        }
      } catch {
        if (!cancelled) void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '_System error.') });
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
    // 열릴 때의 컨텍스트만 쓴다(생성자 고정 7인자).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [context]);

  // System 변경 → Plan ID 후보 재계산 + 첫 항목 선택(AS-IS SelectedIndexChanged). 조회 모드는 잠겨 미발생.
  const handleProdCdChange = (value: string) => {
    setProdCd(value);
    setProdPlanId(planIdOptionsFor(value)[0]?.value ?? '');
  };
  const handleShipCdChange = (value: string) => {
    setShipCd(value);
    setShipPlanId(planIdOptionsFor(value)[0]?.value ?? '');
  };

  // No Frozen 토글 — 체크 시 해당 종료일 비우고 잠금, 해제 시 기본값 복원(AS-IS ChkXxx_CheckedChanged).
  const toggleNoFrozen =
    (
      setChecked: (v: boolean) => void,
      setDate: (d: ReturnType<typeof dayjs> | null) => void,
      fallback: ReturnType<typeof dayjs> | null
    ) =>
    (checked: boolean) => {
      setChecked(checked);
      setDate(checked ? null : fallback);
    };

  const closeAndReset = () => {
    onClose();
  };

  const saveData = async () => {
    if (!context || saving) return;

    // 저장 파라미터(AS-IS SaveData cs:457-488). start 는 전부 planStart(Horizon/Prod/Cell/Ship Start).
    const planStartYmd = toYmd(planStart);
    let prodFrzEnd = prodNoFrozen ? '' : toYmd(prodEnd);
    let cellFrzEnd = cellNoFrozen ? '' : toYmd(cellEnd);
    const shipFrzEnd = shipNoFrozen ? '' : toYmd(shipEnd);
    let prodNoFrzYn = prodNoFrozen ? 'Y' : 'N';
    let cellNoFrzYn = cellNoFrozen ? 'Y' : 'N';
    const shipNoFrzYn = shipNoFrozen ? 'Y' : 'N';

    // Cell/전극(비Pack)은 Prod 입력을 Cell 로 저장하고 Prod 는 비운다(AS-IS cs:480-488).
    if (!isPack) {
      cellFrzEnd = prodFrzEnd;
      cellNoFrzYn = prodNoFrzYn;
      prodFrzEnd = '';
      prodNoFrzYn = 'N';
    }

    // Frozen Period 검증 — 시작(planStart) > 종료면 중단(AS-IS cs:490-526, MSG00108).
    const invalid = (end: string): boolean =>
      !!planStartYmd && !!end && dayjs(planStartYmd, 'YYYYMMDD').isAfter(dayjs(end, 'YYYYMMDD'));
    if (invalid(prodFrzEnd) || invalid(cellFrzEnd) || invalid(shipFrzEnd)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_PERIOD, '_Invalid period (start > end).') });
      return;
    }

    setSaving(true);
    try {
      const res = await apiClient.post<{ code?: string | number; message?: string }>(
        `/${MENU_ID}/${SHEETS.PLAN_ID_CREATE}/${BUTTON_TYPE.SAVE}/call-proc`,
        {
          divisionId: context.divisionId,
          planGrId: context.planGroupId,
          planGrName: context.planGroupName,
          prsCd: context.prsCd,
          planStartYyyymmdd: planStartYmd,
          planEndYyyymmdd: toYmd(horizonEnd),
          dmdVerId: fcstVersion,
          prodRefSysDivsCd: prodCd,
          prodRefSysPlanId: prodPlanId,
          prodFrzStartYyyymmdd: planStartYmd,
          prodFrzEndYyyymmdd: prodFrzEnd,
          cellProdFrzStartYyyymmdd: planStartYmd,
          cellProdFrzEndYyyymmdd: cellFrzEnd,
          shipRefSysDivsCd: shipCd,
          shipRefSysPlanId: shipPlanId,
          shipFrzStartYyyymmdd: planStartYmd,
          shipFrzEndYyyymmdd: shipFrzEnd,
          pramTyCd: PARAMETER_NORMAL,
          planDesc: desc.trim(),
          prodNoFrzYn,
          cellNoFrzYn,
          shipNoFrzYn,
          // 23번째 sesUserId — /call-proc 세션 자동주입 없음(메인 SAVE 와 동일, FE 가 직접 싣는다).
          sesUserId: sessionUserId ?? '',
        }
      );
      const body = res.data as { code?: string | number; message?: string } | undefined;
      // false-success 판별 — 인터셉터가 4xx/5xx 도 resolve 한다(convert-core §2.4).
      if (res.status >= 400 || Number(body?.code)) {
        void setToast({
          type: 'error',
          message: str(body?.message) || t(MSG.SAVE_FAILED, '_Save failed.'),
        });
        return;
      }
      void setToast({ type: 'success', message: t(MSG.SAVE_EXECUTED, MSG_FALLBACK[MSG.SAVE_EXECUTED]) });
      onSaved();
      closeAndReset();
    } catch {
      void setToast({ type: 'error', message: t(MSG.SAVE_FAILED, '_Save failed.') });
    } finally {
      setSaving(false);
    }
  };

  // 날짜 필드 공통 렌더(표시 YYYY-MM-DD). 읽기전용·No Frozen 잠금은 disabled 로.
  const dateField = (
    value: ReturnType<typeof dayjs> | null,
    onChange: (d: ReturnType<typeof dayjs> | null) => void,
    disabled: boolean
  ) => (
    <DatePickerCalendar
      usecase='date'
      size='small'
      elevation
      disabled={disabled}
      value={value}
      onChange={(((d: ReturnType<typeof dayjs> | null) => onChange(d)) as never)}
    />
  );

  // AS-IS 범위형 날짜: [시작(읽기전용)] ~ [종료(DatePicker)] + No Frozen 체크(선택).
  //   AS-IS SCP0123_PlanIDCreatePopup 의 Plan Horizon/Pack~Module/Cell/Period 레이아웃 재현.
  const rangeField = (
    startText: string,
    endValue: ReturnType<typeof dayjs> | null,
    onEndChange: (d: ReturnType<typeof dayjs> | null) => void,
    disabled: boolean,
    noFrozen?: boolean,
    onToggleNoFrozen?: (checked: boolean) => void
  ) => (
    <div className={styles.rangeWrap}>
      <div className={styles.dateRange}>
        <InputField value={startText} disabled />
        <span className={styles.tilde}>~</span>
        {dateField(endValue, onEndChange, disabled || !!noFrozen)}
      </div>
      {onToggleNoFrozen && (
        <Checkbox
          labelText='No Frozen'
          checked={!!noFrozen}
          disabled={disabled}
          onChange={onToggleNoFrozen}
        />
      )}
    </div>
  );

  const ro = viewMode; // 조회 모드 공통 잠금

  return (
    <CustomDialog
      open={open}
      size={620}
      height={520}
      type='modal'
      position='basic'
      handleClose={closeAndReset}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL01149', '_Plan ID')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          {/* Plan Info. — Plan Group / Plan Horizon(범위) / FCST Version (AS-IS Plan Info. 섹션) */}
          <div className={styles.section}>
            <div className={styles.sectionTitle}>Plan Info.</div>
            <div className={styles.grid}>
              <FormItem
                label='Plan Group'
                labelAlign='right'
                render={() => <InputField fullWidth value={context?.planGroupName ?? ''} disabled />}
              />
              <FormItem
                label='Plan Horizon'
                labelAlign='right'
                render={() => rangeField(planStartText, horizonEnd, setHorizonEnd, ro)}
              />
              <FormItem
                label='FCST Version'
                labelAlign='right'
                render={() => <InputField fullWidth value={fcstVersion} disabled />}
              />
            </div>
          </div>

          {/* Prod. Frozen — 좌: Plan Type/Plan ID, 우: Pack/Module/Cell(범위) 병렬(AS-IS 줄맞춤) */}
          <div className={styles.section}>
            <div className={styles.sectionTitle}>Prod. Frozen</div>
            <div className={styles.grid}>
              <FormItem
                label='Plan Type'
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={prodCd}
                    options={prodSysOptions}
                    disabled={ro}
                    onChange={(_, picked) => handleProdCdChange(String(picked ?? ''))}
                  />
                )}
              />
              <FormItem
                label={isPack ? 'Pack/Module' : 'Period'}
                labelAlign='right'
                render={() =>
                  rangeField(
                    planStartText,
                    prodEnd,
                    setProdEnd,
                    ro,
                    prodNoFrozen,
                    toggleNoFrozen(setProdNoFrozen, setProdEnd, defaultProdEnd)
                  )
                }
              />
              <FormItem
                label='Plan ID'
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={prodPlanId}
                    options={prodPlanOptions}
                    disabled={ro}
                    onChange={(_, picked) => setProdPlanId(String(picked ?? ''))}
                  />
                )}
              />
              {isPack && (
                <FormItem
                  label='Cell'
                  labelAlign='right'
                  render={() =>
                    rangeField(
                      planStartText,
                      cellEnd,
                      setCellEnd,
                      ro,
                      cellNoFrozen,
                      toggleNoFrozen(setCellNoFrozen, setCellEnd, defaultProdEnd)
                    )
                  }
                />
              )}
            </div>
          </div>

          {/* Ship. Frozen — 좌: Plan Type/Plan ID, 우: Period(범위) 병렬(AS-IS 줄맞춤) */}
          <div className={styles.section}>
            <div className={styles.sectionTitle}>Ship. Frozen</div>
            <div className={styles.grid}>
              <FormItem
                label='Plan Type'
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={shipCd}
                    options={shipSysOptions}
                    disabled={ro}
                    onChange={(_, picked) => handleShipCdChange(String(picked ?? ''))}
                  />
                )}
              />
              <FormItem
                label='Period'
                labelAlign='right'
                render={() =>
                  rangeField(
                    planStartText,
                    shipEnd,
                    setShipEnd,
                    ro,
                    shipNoFrozen,
                    toggleNoFrozen(setShipNoFrozen, setShipEnd, defaultShipEnd)
                  )
                }
              />
              <FormItem
                label='Plan ID'
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={shipPlanId}
                    options={shipPlanOptions}
                    disabled={ro}
                    onChange={(_, picked) => setShipPlanId(String(picked ?? ''))}
                  />
                )}
              />
            </div>
          </div>

          {/* Parameter / Desc. (AS-IS 하단) */}
          <div className={styles.grid}>
            <FormItem
              label='Parameter'
              labelAlign='right'
              render={() => <InputField fullWidth value={PARAMETER_NORMAL} disabled />}
            />
            <FormItem
              label='Desc.'
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={desc}
                  disabled={ro}
                  onChange={event => setDesc(event.target.value)}
                />
              )}
            />
          </div>

          <div className={styles.buttonWrapper}>
            {/* 조회 모드는 Create 를 숨긴다(AS-IS btnCreatePlan.Enabled=false). */}
            {!viewMode && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='Create Plan'
                disabled={saving}
                onClick={() => void saveData()}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={closeAndReset}
            />
          </div>
        </div>
      }
    />
  );
};
