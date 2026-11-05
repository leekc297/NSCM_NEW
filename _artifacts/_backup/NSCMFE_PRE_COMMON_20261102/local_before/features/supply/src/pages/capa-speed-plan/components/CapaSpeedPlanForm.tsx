import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

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
 * 레이아웃 — SCP0105 조회조건 매핑표 순서, 12-column 자동 wrap → 3단. 앞 2단은 항상 노출하고
 * 3단은 접는다(SearchArea extraConditions, chevron 토글 — 자매 SCP0104 동일 패턴, 사용자 요청
 * 2026-10-27). 기본 접힘.
 *   1단(conditions)      Operation group · Item(Basic Nickname/Model 동적) · Div · Plan Month
 *   2단(conditions)      Ver.(+Plan Type 파생) · Status · Site · Plant
 *   3단(extraConditions) Building · Line · Operation(동적) · Line Type(동적)
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
  const setDivision = useCapaSpeedPlanStore(state => state.setDivision);
  const setDivisionType = useCapaSpeedPlanStore(state => state.setDivisionType);
  const openSearchArea = useCapaSpeedPlanStore(state => state.openSearchArea);
  const planType = useCapaSpeedPlanStore(state => state.planType);

  const tabId = useTabid();

  // 미저장 편집 이탈 가드 — 그리드를 초기화하는 조회조건 콤보(Division·DivisionType·Version·
  //   VersionSeq·Status)는 편집중(dirty)이면 MSG00704 confirm 을 통과한 뒤에만 상태를 바꾼다.
  //   취소 시 store 상태가 그대로라 controlled 콤보가 이전 값으로 복귀하고, 초기화 effect
  //   (useCapaSpeedPlanConditionEffects (2)(3a)(3b))도 dep 불변이라 돌지 않는다(commit 51d4e9fa 패턴).
  //   Site/Plant/Building/Line/Operation/LineType cascade 콤보는 그리드를 비우지 않으므로 가드 대상 아님.
  const guardDirty = (apply: () => void) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) apply();
    });
  };

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
          {/* 1단 — Operation group / Material / Div / Plan Month */}
          {/* DivisionType 라벨 = "Operation group"(LBL00027). AS-IS 는 `lciDivisionType.TextVisible=false`
              로 라벨이 없었으나, TO-BE 조회조건 설계(SCP0105 매핑표)가 필드명 "Operation group" 을
              부여한다 — 선택지(Electrode/Cell/Module-Pack)가 아니라 공정그룹 축을 가리키는 필드명이다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionType}
                  options={divisionTypeOptions}
                  onChange={(_, picked) =>
                    guardDirty(() =>
                      setDivisionType(
                        (String(picked ?? '') || DIVISION_TYPE.CELL) as DivisionType
                      )
                    )
                  }
                />
              )}
            />
          </Grid>
          {/* Item — 라벨이 Operation group(DivisionType)별 동적이다(AS-IS 01 L-03 파리티, 자매 SCP0104
              동일): Cell/Module-Pack = Basic Nickname(LBL00054) / Electrode = Material(LBL00021).
              조건은 `showOperation`(= divisionType !== ELTR). AS-IS Electrode 는 Model(LBL00669)이었으나
              사용자 지시 2026-10-28 로 Electrode 라벨만 Material(LBL00021)로 변경(필드는 항상 노출, 라벨만 전환).
              입력창 + 팝업 아이콘은 한 덩어리(hook #121 popupSearchField). 선택은 다중(팝업 multiSelect →
              콤마결합) — CapaSpeedPlanItemPopup 참조. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={showOperation ? t('LBL00054', '_Basic Nickname') : t('LBL00021', '_Material')}
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
          {/* Div 라벨은 리터럴 'Div' — LBL00001 EN/CN="Div."(마침표)지만 AS-IS·이 화면은 "Div"다.
              공유 메시지(141화면 사용)라 전역 수정하지 않기로 함(사용자 결정 2026-10-27, SCP0105만) —
              같은 파일 'Ver.'/'Module/Pack' 리터럴 선례. 정식 LBL 채번 시 t() 로 교체. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='Div'
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={combos.divisionOptions}
                  // Division 변경 = 검색조건(Div·DivisionType 제외) + 그리드 초기화(store setDivision).
                  onChange={(_, picked) => guardDirty(() => setDivision(String(picked ?? '')))}
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
                  onChange={(_, picked) =>
                    guardDirty(() => setSearchCondition({ version: String(picked ?? '') }))
                  }
                />
              )}
            />
          </Grid>

          {/* 2단 — Version(+Plan Type) / Status / Site / Plant */}
          {/* Version(Seq) + Plan Type 를 한 칸(size=3)에 Box flex 50:50 으로 묶는다 — 자매 SCP0104/0108
              패턴(사용자 확정 2026-10-26). size=2+1 로 쪼개면 조회조건 그리드(전 칸 size=3·min-width 290)가
              뒤틀려 콤보 폭이 들쭉날쭉해진다(사용자 지적 2026-10-27). Version 라벨 "Ver." 는 리터럴
              (사용자 결정): `SCM_ADM_MSG_M` 에 "Ver." 0건이고 근사코드 LBL00031="Version." 재사용은 표기
              불일치라 신규 채번 대신 하드코딩(같은 파일 'Module/Pack' 선례). 정식 LBL 채번 시 t() 로 교체.
              Plan Type 은 조회 파라미터가 아니라 파생 표시다(`txtPlanType.Enabled=false`). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='Ver.'
              labelAlign='right'
              render={() => (
                <Box sx={{ display: 'flex', gap: 0.5, width: '100%', minWidth: 0 }}>
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <CustomDropdown
                      disabled={disabled}
                      value={sc.versionSeq}
                      options={combos.versionSeqOptions}
                      onChange={(_, picked) =>
                        guardDirty(() =>
                          setSearchCondition({ versionSeq: String(picked ?? '') })
                        )
                      }
                    />
                  </Box>
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <InputField fullWidth disabled value={planType} />
                  </Box>
                </Box>
              )}
            />
          </Grid>
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
                    guardDirty(() =>
                      setSearchCondition({ progressStatus: String(picked ?? '') })
                    )
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
        </>
      }
      extraConditions={
        <>
          {/* 3단 — Building / Line / Operation(동적) / Line Type(동적) */}
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
        </>
      }
    />
  );
};
