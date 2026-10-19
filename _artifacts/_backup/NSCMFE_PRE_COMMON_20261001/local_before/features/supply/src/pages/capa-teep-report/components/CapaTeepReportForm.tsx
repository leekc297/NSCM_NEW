import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  ALL_SENTINEL,
  DIVISION_TYPE,
  LBL_DIVISION,
  LBL_MODULE_PACK,
  LBL_VERSION,
  type DivisionType,
} from '../capa-teep-report.constants';
import type { ComboOption } from '../capa-teep-report.types';
import type { CapaTeepReportCombos } from '../hooks/useCapaTeepReportCombos';
import { useCapaTeepReportStore } from '../useCapaTeepReportStore';

interface Props {
  combos: CapaTeepReportCombos;
  onSearch: () => void;
  /** Division 권한 0건 — 조회영역 전체 비활성(01 L-04 / V-06). 필드별 disabled 산포 금지. */
  disabled: boolean;
}

/**
 * 조회조건 9필드 (design 02 §1 C1~C11 / §5.2).
 *
 * 단 구성(hook #52 / #83) — 12-column Grid 에서 `size=3` 기준 행당 4필드, 합계 24 = 정확히 2단이고
 * 3단째부터 `extraConditions` 로 분리한다(02 §5.2). **자체 expand state·자체 토글 버튼을 만들지 않는다**
 * — `SearchArea` 의 `extraConditions` prop 만 쓴다(축소 시 DOM 미생성).
 *   `conditions`      1단 = Div.(3) · Plan Month(3) · Ver.(3) · Operation group(3)          = 12
 *   `conditions`      2단 = Site(3) · Plant(3) · Building(3) · Line(3)                       = 12
 *   `extraConditions` 3단 = Operation(3) · Line Type(3) · Plan Type(3)                       = 9
 *
 * 동적 가시성 2규칙의 **조건식 비대칭을 통일하지 않는다**(01 L-01/L-02 / goal S-3):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = !(divisionType === 'MODULE_PACK' || divisionType === 'ELTR')
 * AS-IS 가 부정형이라 `=== 'CELL'` 로 단순화하면 미선택(-1) 상태에서 동작이 갈린다. 이 화면은 기본값을
 * `Electrode` 로 명시했지만(goal D-1) 규칙 자체는 AS-IS 형태를 유지한다.
 * **자매 SCP0105 는 MODULE_PACK 도 Line Type 표시**라 규칙이 다르다 — 복사 금지.
 *
 * **필수 조회조건을 만들지 않는다.** AS-IS `DataUtil.checkRequiredOfSearch` 의 두 번째 분기는
 * `LayoutControlItem.Text` 가 `*` 로 끝나는 항목만 검사하고 SCP0107 라벨 전건에 `*` 가 0건이라 사문이다
 * (01 §3 / 02 §4.4). 라벨에 `*` 를 붙이거나 Search 전 alert 를 신설하면 오히려 위반이다.
 */
export const CapaTeepReportForm = ({ combos, onSearch, disabled }: Props) => {
  const { t } = useTranslation();

  const sp = useCapaTeepReportStore(state => state.searchParams);
  const setSearchParams = useCapaTeepReportStore(state => state.setSearchParams);
  const setSearchParamsWithLineTypeRefresh = useCapaTeepReportStore(
    state => state.setSearchParamsWithLineTypeRefresh
  );
  const openSearchArea = useCapaTeepReportStore(state => state.openSearchArea);
  const planType = useCapaTeepReportStore(state => state.planType);

  const showOperation = sp.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType = !(
    sp.divisionType === DIVISION_TYPE.MODULE_PACK || sp.divisionType === DIVISION_TYPE.ELTR
  );

  /**
   * Operation group 3항목 — AS-IS `rgrpDivisionType`(dsn:526~529) 순서 그대로.
   * 카탈로그 지시가 "선택·단일" 이고 NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로
   * 매핑한다(자매 SCP0104/0105/0106/0108/0114 동일 판단, 02 §5.2).
   * 이 축은 콤보가 아니라 **화면 모드 스위치**라 옵션 값(`ELTR`/`CELL`/`MODULE_PACK`)이 화면 상수인 것이
   * 정답이다 — AS-IS 원천도 Designer 리터럴이라 hook #87 §L(콤보 옵션 하드코딩 금지) 미해당이다.
   * 표시 라벨은 3항목 전건 `t()` 경유가 규약이며 `LBL01143`("Module/Pack")은 ora.py 실측 등록 확인분이다.
   */
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', { defaultValue: 'Electrode' }), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', { defaultValue: 'Cell' }), value: DIVISION_TYPE.CELL },
      {
        label: t(LBL_MODULE_PACK, { defaultValue: 'Module/Pack' }),
        value: DIVISION_TYPE.MODULE_PACK,
      },
    ],
    [t]
  );

  /**
   * Division / Plan Month / Version / Operation group 변경 = AS-IS `RefreshAll()` 경로다 —
   * **하위 6축 전부 `ALL` 리셋 + Line Type 목록 축 갱신**(02 §3.2 / §5.4). 단일 커밋으로 묶는다
   * (상위 변경 시 하위를 개별 `setState` 로 쪼개지 말 것 — hook #5 §1.2).
   * 그리드 비움·헤더 재구성은 `hooks/useCapaTeepReportConditionEffects` 가 담당한다(연쇄로 2회 비우지 않는다).
   */
  const resetAllAxes = {
    siteId: ALL_SENTINEL,
    plantId: ALL_SENTINEL,
    factoryId: ALL_SENTINEL,
    lineId: ALL_SENTINEL,
    operationId: ALL_SENTINEL,
    electrodeType: ALL_SENTINEL,
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 — Div. / Plan Month / Ver. / Operation group */}
          {/* Division 은 **다중선택 + ALL** 이다(clbDivision = 체크리스트, 02 §1.1) — 자매 화면의
              단일 콤보를 복사하면 AS-IS 의 다중 사업부 조회 경로가 사라진다.
              라벨 코드는 카탈로그 확정값 `LBL00001`("Div.") 이다 — AS-IS Designer 문자열 `Division`
              (LBL00641)은 카탈로그 rename 규칙상 미채택이다(02 §4.5.1 / §5.1 #3 / hook #112 §4-1,
              iter-2 R-03). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL_DIVISION, { defaultValue: 'Div.' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sp.divisionId}
                  options={combos.divisionOptions}
                  onChange={(_, picked) =>
                    setSearchParamsWithLineTypeRefresh({
                      divisionId: String(picked ?? ''),
                      // 후보가 갈리므로 Plan Month/Version 을 비우고 콤보 훅 effect 가 첫 행으로 되돌린다.
                      verId: '',
                      verSeq: '',
                      ...resetAllAxes,
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00053', { defaultValue: 'Plan Month' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.verId}
                  options={combos.versionOptions}
                  onChange={(_, picked) =>
                    setSearchParamsWithLineTypeRefresh({
                      verId: String(picked ?? ''),
                      verSeq: '',
                      ...resetAllAxes,
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* Ver. — 라벨은 AS-IS Designer Text `Version` = `LBL00606` 다. 카탈로그 표기 `Ver.` 는
              `SCM_ADM_MSG_M` 에 문구가 0건이라 근사 코드를 재사용하지 않는다(hook #114 / goal D-4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL_VERSION, { defaultValue: 'Version' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.verSeq}
                  options={combos.versionSeqOptions}
                  onChange={(_, picked) =>
                    setSearchParamsWithLineTypeRefresh({
                      verSeq: String(picked ?? ''),
                      ...resetAllAxes,
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* Operation group — 라벨은 카탈로그 확정 명칭 `Operation group`(`LBL00027`) 이다.
              AS-IS `lciDivisionType.TextVisible=false`(01 §1.1 / L-19) 와 카탈로그 정본(02 §5.1 #1)이
              충돌하는 축인데, 충돌 시 카탈로그가 승한다(hook #112 §4-1, iter-2 R-02).
              `LBL00038`("Electrode")은 이 필드의 **선택지 하나**이지 필드명이 아니다 — 라벨로 붙이면
              3지선다 앞에 "Electrode" 가 찍힌다.
              이 축 변경은 마스터 콤보 자체를 갈아끼우는 **재조회**다(comboId 스위치 = goal S-5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', { defaultValue: 'Operation group' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.divisionType}
                  options={divisionTypeOptions}
                  onChange={(_, picked) =>
                    setSearchParamsWithLineTypeRefresh({
                      divisionType: (String(picked ?? '') ||
                        DIVISION_TYPE.ELTR) as DivisionType,
                      ...resetAllAxes,
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* 2단 — Site / Plant / Building / Line.
              상위 변경 시 하위 선택을 비운다 — AS-IS `setListBox` 재바인딩이 체크를 지운다(02 §3.4).
              단 **Line Type 은 건드리지 않는다**: `clbSite`~`clbLine` 핸들러가 `RefreshElectrodeType` 를
              호출하지 않아(cs:1676~1705) 재바인딩이 없고 체크가 유지된다(02 §3.2 비대칭 1). 여기서 같이
              비우면 `p_electrode_type` 후보가 넓어져 조회 결과가 AS-IS 와 달라진다. Line Type 을 비우는
              경로는 Operation 변경과 위 4축(RefreshAll) 변경뿐이다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00015', { defaultValue: 'Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sp.siteId}
                  options={combos.siteOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      siteId: String(picked ?? ''),
                      plantId: ALL_SENTINEL,
                      factoryId: ALL_SENTINEL,
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00030', { defaultValue: 'Plant' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sp.plantId}
                  options={combos.plantOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      plantId: String(picked ?? ''),
                      factoryId: ALL_SENTINEL,
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 컨트롤명은 `clbFactory` 지만 AS-IS 표기는 "Building" 이다 — LBL00008(실측). "Factory" 아님. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00008', { defaultValue: 'Building' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sp.factoryId}
                  options={combos.buildingOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      factoryId: String(picked ?? ''),
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00010', { defaultValue: 'Line' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={disabled}
                  value={sp.lineId}
                  options={combos.lineOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      lineId: String(picked ?? ''),
                      operationId: ALL_SENTINEL,
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
          {/* 3단 — Operation(동적) / Line Type(동적) / Plan Type(파생 표시).
              조건부 가시성은 `extraConditions` 안에서 조건부 렌더로 재현한다 — 축소 시 DOM 미생성
              (hook #52 §7). 숨겨도 선택값은 유지되며 GET 파라미터에 계속 실린다(goal D-6 / V-05). */}
          <Grid size={3}>
            {showOperation && (
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00009', { defaultValue: 'Operation' })}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sp.operationId}
                    options={combos.operationOptions}
                    // Operation -> Line Type 만 재구성(cascade 말단, 02 §3.2 #9).
                    onChange={(_, picked) =>
                      setSearchParamsWithLineTypeRefresh({
                        operationId: String(picked ?? ''),
                        electrodeType: ALL_SENTINEL,
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
                label={t('LBL00056', { defaultValue: 'Line Type' })}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sp.electrodeType}
                    options={combos.lineTypeOptions}
                    // cascade 말단 — 아무것도 트리거하지 않는다(`clbElectrodeType` 배선 0건, 02 §3.2).
                    onChange={(_, picked) =>
                      setSearchParams({ electrodeType: String(picked ?? '') })
                    }
                  />
                )}
              />
            )}
          </Grid>
          {/* Plan Type — AS-IS `txtPlanType` 은 `TextVisible=false`(라벨 없음) + `Enabled=false`,
              `TabStop=false` 인 파생 표시다(02 §4.4). 콤보가 아니고 조회 파라미터도 아니다.
              `readOnly` 로 둔다(`disabled` 아님 — 값은 읽혀야 한다). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => <InputField fullWidth readOnly value={planType} />}
            />
          </Grid>
        </>
      }
    />
  );
};
