import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import {
  BUCKET_CODE,
  COMBO,
  DIVISION_EE_INCLUDE,
  LBL,
  MSG,
  PERIOD_W52_OFFSET_DAYS,
} from '../global-psi-elec.constants';
import { useGlobalPsiElecStore } from '../useGlobalPsiElecStore';

interface Props {
  onSearch: () => void;
  // Model 팝업(ElecMaterialPopup) 오픈 — 페이지가 open state 소유(design 02 §4.6).
  onModelSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// AS-IS GetDayRange("52") 재현(design 02 §2-5) — from=planDate, to=planDate+363일(52*7-1). 로컬 Date 로 tz 무영향.
const addDaysYmd = (ymd: string, days: number): string => {
  if (!ymd || ymd.length !== 8) return '';
  const d = new Date(Number(ymd.slice(0, 4)), Number(ymd.slice(4, 6)) - 1, Number(ymd.slice(6, 8)));
  d.setDate(d.getDate() + days);
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const dd = String(d.getDate()).padStart(2, '0');
  return `${y}${m}${dd}`;
};

// AS-IS SCP0095_GlobalPSI_Elec.cs 조회조건 패널(design 01 §1 2행 + design 02 §5 매핑).
//   Row1: Division*(단일) / Company(다중) / Model(+팝업)   Row2: Plan-date*(cascade) / Period(from~to) / Bucket
//   6조건이 정확히 2행(≤8슬롯)이라 3단째 접힘(extraConditions) 불요 — SearchArea 자체 접기 토글로 충분(design 01 §3).
//   Division/Company selection 방식은 실측 SP 계약에 맞춘다(iter-3 A2 결정, asis.py 2026-09-26):
//     AS-IS SCP0095_GET_GLOBAL_PSI_ELEC 본문 = `A.DIVISION_ID = @p_division_id`(단일 등식, STRING_SPLIT 없음)
//       → Division 은 단일선택. TO-BE PKG_SCP0095 도 `DIVISION_ID = UPPER(P_DIVISION_ID)`(등식) 로 AS-IS 미러.
//       AS-IS UsrCombo 는 체크형이나 SP 가 등식이라 다중선택은 AS-IS 에서도 빈 결과(latent) — 단일선택이 regression-zero.
//     Company·Model(ELEC_MODEL) = `IN (STRING_SPLIT(@p_company/@p_item_id, ','))` → Company 는 다중선택(콤마조인) 유지.
//   두 콤보 모두 isAddALL=false(AS-IS BLUtils.GetDivisionEE(false)/Data.Common(...,false)) → allOption 미추가
//     (iter-3 A1): 'ALL' 센티널은 등식/IN 어느 쪽도 매치 0 이라 빈 그리드. Company 미선택('')은 SP 가 전체로 우회.
export const GlobalPsiElecForm = ({ onSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiElecStore(s => s.searchCondition);
  const set = useGlobalPsiElecStore(s => s.setSearchCondition);
  const setDivision = useGlobalPsiElecStore(s => s.setDivision);
  const openSearchArea = useGlobalPsiElecStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Division 소스풀 — Division_SCP(공유콤보, ATTRIBUTE3 반환). AS-IS GetDivisionEE = ATTRIBUTE3='EE' FE 후처리(§2-1 Option B).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // Company — COMPANY_EE 정적(파라미터 0, division cascade 아님). 값=COMPANY_NAME(CODE)/표시=COMPANY_ID(NAME).
  const [companies] = useTabComboQueries({ filters: [COMBO.COMPANY] });
  // Plan-date — DATE_WEEKLY division 종속 재조회(토큰 @divisionId 정확히). division 미선택이면 미조회.
  const [planDates] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_DATE, divisionId: sc.divisionId }],
  });

  // EE 전극만 유지(design 02 §2-1) — Division_SCP 가 ATTRIBUTE3 를 반환하므로 관대 가드 아님(no-op 회피).
  const divisionOptions = useMemo<Option[]>(
    () => toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) === DIVISION_EE_INCLUDE)),
    [divisions]
  );
  const companyOptions = toOptions(companies);
  const planDateOptions = toOptions(planDates);

  const bucketOptions: Option[] = [
    { label: t(LBL.BUCKET_DAILY, 'Daily'), value: BUCKET_CODE.DAILY },
    { label: t(LBL.BUCKET_WEEKLY, 'Weekly'), value: BUCKET_CODE.WEEKLY },
    { label: t(LBL.BUCKET_MONTHLY, 'Monthly'), value: BUCKET_CODE.MONTHLY },
  ];

  // 권한 Division 0 방어(design 01 §2 #1 SetDivisionAuthCheck) — EE 필터 결과 0건이면 권한 없음. 1회 alert + disable.
  const setAlert = useMessageStore.getState().setAlert;
  const alertedRef = useRef(false);
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
    if (!noDivisionAuth) alertedRef.current = false;
  }, [noDivisionAuth, setAlert, t]);

  // Plan-date 변경 = 하위 캘린더 파생(design 02 §3) — Period 기본 W52 재계산(AS-IS GetDayRange). 조회는 명시 Search.
  const applyPlanDate = (v: string) => {
    set({
      planStartYyyymmdd: v,
      fromYyyymmdd: v,
      toYyyymmdd: addDaysYmd(v, PERIOD_W52_OFFSET_DAYS),
    });
  };

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const multi = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (codes: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            multiple
            useClearIcon
            limitTags={1}
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row1 — Division*(단일, AS-IS SP 등식 계약) / Company(다중, IN STRING_SPLIT) / Model(+팝업) */}
          {single(
            t(LBL.DIVISION, 'Division'),
            sc.divisionId,
            divisionOptions,
            // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true,
            noDivisionAuth
          )}
          {multi(
            t(LBL.COMPANY, 'Company'),
            sc.company,
            companyOptions,
            v => set({ company: v }),
            false,
            noDivisionAuth
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, 'Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onModelSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Row2 — Plan-date*(cascade) / Period(from~to YYYYMMDD) / Bucket */}
          {single(
            t(LBL.PLAN_DATE, 'Plan Date'),
            sc.planStartYyyymmdd,
            planDateOptions,
            applyPlanDate,
            true,
            noDivisionAuth
          )}
          {/* Period(from~to) — 공용 PeriodField(캘린더 스냅/경계 검증 내장, design 02 §5). 기본값은 Plan-date
              변경 시 applyPlanDate 가 W52 산식(planDate+363일)으로 채운다. from+to 한 슬롯(gridSize 3). */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, 'Period')}
          />
          {single(
            t(LBL.BUCKET, 'Bucket'),
            sc.bucket,
            bucketOptions,
            // Bucket 변경 = D_/W_/M_ pivot visible 토글(design 03 §2.2) — 서버 재조회 없는 클라 전환.
            v => set({ bucket: v || BUCKET_CODE.WEEKLY }),
            false,
            noDivisionAuth
          )}
        </>
      }
    />
  );
};
