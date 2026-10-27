import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../shipment-plan-fix.constants';
import { COMBO, ELECTRODE_LOOKUP, LBL } from '../shipment-plan-fix.constants';
import { useShipmentPlanFixStore } from '../useShipmentPlanFixStore';
import { isEeDivision } from '../utils/shipmentPlanFixVisibility';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 인벤토리 C1~C12 + cascade 그래프(§3).
//   cboDivision(최상위) → cboBizType(EE 여부로 OperationGroup(EE)_SCP 스왑, 재조회형). clbElecType 독립 다중.
//   SCP0024 와 달리 Plant Site/Line 콤보·클라 필터 없음(filterCalls 0, design 02 §2 주). cascade 는 Division→OperationGroup 1단.
//   EE 판정 = division ∈ FN_GET_DIVISION_DIV('EE') 목록(design 03 §2.7 실측) → 콤보 코드셋 선택(이름 대조 금지, convert-core §2.6).
export const ShipmentPlanFixForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanFixStore(s => s.searchCondition);
  const set = useShipmentPlanFixStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanFixStore(s => s.setDivision);
  const openSearchArea = useShipmentPlanFixStore(s => s.openSearchArea);

  const tabId = useTabid();

  const isEe = isEeDivision(sc.divisionId);

  // 콤보 — Division / OperationGroup(division EE 여부로 code 스왑) / Bucket.
  const [divisions, operationGroups, buckets] = useTabComboQueries({
    filters: [COMBO.DIVISION, isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP, COMBO.BUCKET],
  });
  // lookup — 전극타입(ELECTRODE_TYPE). Operation Group 은 아래 division 기반 콤보로만 공급한다.
  const [electrodes] = useTabLookupQueries({
    filters: [ELECTRODE_LOOKUP],
  });

  // lookup 행(SEGMENT1=CODE/SEGMENT2=NAME) → 드롭다운 옵션. ComboResponse 타입이 아니라 rec 캐스팅으로 읽는다.
  const lookupToOptions = (rows: readonly unknown[] | undefined): Option[] =>
    (rows ?? []).map(r => {
      const rec = r as Record<string, unknown>;
      return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
    });

  const divisionOptions = toOptions(divisions);
  // Operation Group = 항상 현재 division 기반(비EE=OperationGroup_SCP P/A, EE=OperationGroupEE_SCP A/E).
  //   AS-IS SetOperationGroupByDivision(cs:866) 와 동일 — 예: division 81(비EE)이면 Pack/Cell 만(Electrode 없음).
  //   종전 'divisionTouched 전 P/A/E 초기 lookup'은 비EE division 에서 Electrode 가 잘못 노출돼 제거(사용자 신고 2026-10-02).
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);
  const electrodeOptions = lookupToOptions(electrodes);

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(AS-IS setListBox(...,false) 첫 행 자동선택, cs:190).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드/스왑 후 현재 선택이 옵션에 없으면 첫 옵션(AS-IS setListBox(...,false)).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            disabled={disabled}
            // 빈 배열(= 필터 없음)은 'ALL' sentinel 로 되돌려 넘긴다(전체선택 상태 왕복 — 자매 규약).
            value={value.length ? value.join(',') : 'ALL'}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
              )
            }
          />
        )}
      />
    </Grid>
  );

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean
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
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 조회조건 2단 전건 상시 노출(접힘 없음) — design 02 §5.1 은 "3단째부터 extraConditions 분리"인데
      //   이 화면은 2단(7필드=4+3)이라 분리 대상이 없다. AS-IS 도 usrConditionPanel 에 전 조건을 상시
      //   노출한다(cs InitControls). 사용자 지시(2026-10-01): Bucket 과 Electrode 위치 교체.
      //   Row1: Division* / Operation Group* / Model/Nickname / Bucket
      //   Row2: Electrode / Period* / SUM
      conditions={
        <>
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true
          )}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            // Operation Group(bizType)은 GET SP 필수 등식(`AND A.BIZ_TYPE = :BIZ_TYPE`, null-branch 없음, SP body 실측)
            //   이라 Division 과 동일 필수 — required 표기로 방어 비대칭 해소(react-gap-audit GAP-07). 옵션 로드 시 첫옵션 자동선택.
            true
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            // AS-IS cs:201-210 — 비EE division 이면 Electrode 비활성(ControlValues="" + Enabled=false).
            //   EE division 에서만 전극타입 필터가 의미를 갖는다(gridSignals R-D). division 변경 시 store
            //   setDivision 이 electrodeTypes 를 비우므로 값 잔존이 없고, 여기선 비활성만 재현한다.
            !isEe
          )}
          {single(
            t(LBL.BUCKET, '_Bucket'),
            sc.bucket,
            bucketOptions,
            v => set({ bucket: v as BUCKET_TYPE })
          )}
          {/* 기간 — 공용 PeriodRangePicker(2개월 달력 팝업 + W26/W52 프리셋 내장). 값 형식 YYYYMMDD. */}
          <Grid size={3}>
            <PeriodRangePicker
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
              required
              className={commonStyles.formItem}
            />
          </Grid>
          {/* SUM 체크박스 — W_/M_ SUM 롤업 컬럼 가시성 토글(design 03 §2.6, 재조회 없음).
              FormItem 라벨 컬럼(140px)에 라벨을 올려 다른 필드와 동일한 간격 확보 —
              바로 앞 Period 와 붙어 보이던 문제 해소(자매 ShipmentPsiForm Sum 과 동형). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, '_Sum')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkSum} onChange={checked => set({ chkSum: checked })} />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
