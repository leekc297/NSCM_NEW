import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  DIVISION_TYPE,
  type DivisionType,
} from '../capa-speed-plan.constants';
import type { ComboOption } from '../capa-speed-plan.types';
import type { CapaSpeedPlanCombos } from '../hooks/useCapaSpeedPlanCombos';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';

interface Props {
  combos: CapaSpeedPlanCombos;
  onSearch: () => void;
  onOpenItemPopup: () => void;
  /** Division 권한 0건 — 조회영역 전체 비활성(01 L-04). */
  disabled: boolean;
}

/**
 * 조회조건 13필드 (design 02 §1.1 / §5.1).
 *
 * 단 구성(hook #52): `conditions` 9필드(12-column 합 24 = 2단) + `extraConditions` 4필드(3단).
 * **순서는 잠정이다** — AS-IS Designer 의 `LayoutControlItem.Location` 과 `Control.Location` 이 서로
 * 다른 행 배정을 줘 정적 소스만으로 확정할 수 없다(01 §5 확인필요-1 / goal BLK-5 미해소).
 * 02 §1 인벤토리 순서를 채택했고 04 리포트에 "확인필요(사용자 축)"로 남겼다.
 *
 * 동적 가시성 2규칙의 **조건식 비대칭을 통일하지 않는다**(01 L-01/L-02):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = divisionType in {CELL, MODULE_PACK}
 * 두 식은 미선택(-1) 상태에서 갈리도록 AS-IS 가 일부러 다르게 쓴 것이다. "정리" 하면 파리티가 깨진다.
 *
 * 필수 조회조건은 만들지 않는다 — AS-IS `Required` 0건 / 라벨 `*` 0건이고 `checkRequiredOfSearch` 는
 * 사실상 Division 권한 게이트로만 동작한다(02 §4.4). Search 전 alert 신설 금지(F-21).
 */
export const CapaSpeedPlanForm = ({ combos, onSearch, onOpenItemPopup, disabled }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaSpeedPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaSpeedPlanStore(state => state.setSearchCondition);
  const setDivisionType = useCapaSpeedPlanStore(state => state.setDivisionType);
  const openSearchArea = useCapaSpeedPlanStore(state => state.openSearchArea);
  const planType = useCapaSpeedPlanStore(state => state.planType);

  const showOperation = sc.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType =
    sc.divisionType === DIVISION_TYPE.CELL || sc.divisionType === DIVISION_TYPE.MODULE_PACK;

  // 라디오 3옵션 — AS-IS rgrpDivisionType(Designer.cs:615~618) 순서 그대로.
  //   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로 매핑한다(자매 SCP0114 와 동일 판단).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 정확 매칭 LBL 이 없다(실측 2026-09-23: LBL00378 'Sub Module',
  //   LBL00379 'Module' 뿐). 엉뚱한 LBL 재사용 = 다국어 전량 불일치라 영문 표기를 유지하고 채번을
  //   04 리포트 확인필요로 남긴다(goal BLK-9, hook #114).
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      { label: 'Module/Pack', value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 — DivisionType(시트 전환축) / Division / Plan Month / Version / Plan Type */}
          {/* DivisionType 은 라벨이 없다 — AS-IS `lciDivisionType.TextVisible=false`(Designer.cs:700).
              `LBL00038`("Electrode")은 이 필드의 **선택지 하나**이지 필드명이 아니다. 라벨로 붙이면
              Electrode/Cell/Module-Pack 3지선다 앞에 "Electrode" 가 찍혀 오해를 만든다.
              같은 화면의 Plan Type(`TextVisible=false`)과 동일하게 빈 라벨로 둔다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionType}
                  options={divisionTypeOptions}
                  onChange={(_, picked) =>
                    setDivisionType((String(picked ?? '') || DIVISION_TYPE.CELL) as DivisionType)
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={combos.divisionOptions}
                  onChange={(_, picked) => setSearchCondition({ divisionId: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00053', '_Plan Month')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.version}
                  options={combos.versionOptions}
                  onChange={(_, picked) => setSearchCondition({ version: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00606', '_Version')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.versionSeq}
                  options={combos.versionSeqOptions}
                  onChange={(_, picked) => setSearchCondition({ versionSeq: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          {/* Plan Type — AS-IS `txtPlanType` 은 TextVisible=false(라벨 없음) + Enabled=false 인 파생 표시. */}
          <Grid size={1}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => <InputField fullWidth disabled value={planType} />}
            />
          </Grid>

          {/* 2단 — Status / Site / Plant / Building */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.progressStatus}
                  options={combos.statusOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({ progressStatus: String(picked ?? '') })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00015', '_Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sc.siteId}
                  options={combos.siteOptions}
                  // 상위 변경 시 하위는 항상 전체(ALL)로 리셋한다 — AS-IS 재바인딩이 체크를 지운다(F-16).
                  onChange={(_, picked) =>
                    setSearchCondition({
                      siteId: String(picked ?? ''),
                      plantId: 'ALL',
                      factoryId: 'ALL',
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00030', '_Plant')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sc.plantId}
                  options={combos.plantOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      plantId: String(picked ?? ''),
                      factoryId: 'ALL',
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 컨트롤명은 clbFactory 지만 AS-IS 표기는 "Building" 이다 — LBL00008(실측). "Factory" 아님. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00008', '_Building')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sc.factoryId}
                  options={combos.buildingOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      factoryId: String(picked ?? ''),
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 3단 — Line / Operation(동적) / Line Type(동적) / Item(팝업) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00010', '_Line')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sc.lineId}
                  options={combos.lineOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      lineId: String(picked ?? ''),
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            {showOperation && (
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00009', '_Operation')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sc.operationId}
                    options={combos.operationOptions}
                    onChange={(_, picked) =>
                      setSearchCondition({
                        operationId: String(picked ?? ''),
                        electrodeType: 'ALL',
                      })
                    }
                  />
                )}
              />
            )}
          </Grid>
          <Grid size={3}>
            {showElectrodeType && (
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00056', '_Line Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sc.electrodeType}
                    options={combos.lineTypeOptions}
                    onChange={(_, picked) =>
                      setSearchCondition({ electrodeType: String(picked ?? '') })
                    }
                  />
                )}
              />
            )}
          </Grid>
          {/* Item — 라벨이 DivisionType 으로 갈린다(01 L-03): Cell/MP = Basic Nickname / ELTR = Model.
              입력창 + 팝업 아이콘은 한 덩어리로 묶는다(hook #121 popupSearchField). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={
                showElectrodeType
                  ? t('LBL00054', '_Basic Nickname')
                  : t('LBL00669', '_Model')
              }
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  disabled={disabled}
                  onChange={event => setSearchCondition({ itemId: event.target.value })}
                  onDoubleClick={onOpenItemPopup}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={disabled}
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onOpenItemPopup} />
                        }
                      />
                    ),
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
