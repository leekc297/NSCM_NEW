import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  DIVISION_TYPE,
  PROGRESS_STATUS,
  SHEET_TYPE,
  type DivisionType,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { ComboOption } from '../capa-loss-plan.types';
import type { CapaLossPlanCombos } from '../hooks/useCapaLossPlanCombos';
import { useCapaLossPlanStore } from '../useCapaLossPlanStore';

interface Props {
  combos: CapaLossPlanCombos;
  onSearch: () => void;
  onOpenItemPopup: () => void;
  /** Division 권한 0건 — 조회영역 전체 비활성(01 L-07). */
  disabled: boolean;
}

/**
 * 조회조건 14필드 (design 02 §1.1 / decisions.md §B-2).
 *
 * 배치는 **AS-IS 실행화면 캡처로 확정**됐다(`human-doc/asis-screenshot.png`, decisions §B-2) —
 * 설계 단계의 "Designer 두 좌표 충돌(확인필요-1)" 은 해소됐고 (B) `Control.Location` 안이 정본이다.
 *   1행: Div · Plan Month · Version · PlanType(라벨 없는 읽기전용 `BP`) · Status · [SheetType] ·
 *        *우측* DivisionType 라디오 3종
 *   2행: Site · Plant · Building · Line
 *   3행: Operation · Line Type · Basic Nickname(+돋보기) · Show Rate Columns
 * 단 구성(hook #52·#83): `conditions` = 1·2행 / `extraConditions` = 3행 + 펼침 토글.
 *
 * 동적 가시성 4규칙의 **조건식이 서로 다르다 — 통일·단순화 금지**(01 L-01/L-02/L-04/L-05):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = !(divisionType === MODULE_PACK || divisionType === ELTR)
 *                       -> `=== 'CELL'` 로 바꾸면 미선택(-1) 동작이 달라진다.
 *                          **SCP0105 는 MODULE_PACK 도 표시라 규칙 자체가 다르다**(02 §0 #11)
 *   showSheetType     = progressStatus in {'1','2'}
 *   showShowRate      = !((progressStatus in {'1','2'}) && sheetType === 'LINE')
 *
 * 필수 조회조건은 만들지 않는다 — AS-IS `Required` 0건 / 라벨 `*` 0건이다(01 §3, 02 §4.4).
 * 라벨에 `*` 를 붙이거나 Search 전 alert 를 신설하면 실패한다(F-28).
 */
export const CapaLossPlanForm = ({ combos, onSearch, onOpenItemPopup, disabled }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaLossPlanStore(state => state.setSearchCondition);
  const setDivisionType = useCapaLossPlanStore(state => state.setDivisionType);
  const setProgressStatus = useCapaLossPlanStore(state => state.setProgressStatus);
  const openSearchArea = useCapaLossPlanStore(state => state.openSearchArea);
  const planType = useCapaLossPlanStore(state => state.planType);

  const showOperation = sc.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType = !(
    sc.divisionType === DIVISION_TYPE.MODULE_PACK || sc.divisionType === DIVISION_TYPE.ELTR
  );
  const isCutoff =
    sc.progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    sc.progressStatus === PROGRESS_STATUS.SECOND_CUTOFF;
  const showSheetType = isCutoff;
  const showShowRate = !(isCutoff && sc.sheetType === SHEET_TYPE.LINE);

  // 라디오 3옵션 — AS-IS rgrpDivisionType(Designer.cs:733~743) 순서 그대로.
  //   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로 매핑한다(자매 SCP0105/0114 동일 판단).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 정확 매칭 LBL 이 없다(02 §4.5 #17 실측: LBL00378 'Sub Module',
  //   LBL00379 'Module' 뿐). 엉뚱한 LBL 재사용 = 다국어 전량 불일치라 영문 표기를 유지하고 채번을
  //   04 리포트 확인필요로 남긴다(goal BLK-7, hook #114). SCP0105 와 **공유 채번** 대상이다.
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', { defaultValue: 'Electrode' }), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', { defaultValue: 'Cell' }), value: DIVISION_TYPE.CELL },
      { label: 'Module/Pack', value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  // SheetType 옵션 — AS-IS 가 `Items.Add("MODEL"/"LINE")` 로 **코드 하드코딩**한다(02 §2.4).
  //   TO-BE lookup/CMBO 에 대응 0건이라 화면 상수로 둔다(hook #87 §L 와 충돌 — 04 확인필요).
  //   **값 자체는 `_sheet_status` 계산 키라 변경 금지.** 표시 문구도 AS-IS 가 코드값 그대로다.
  const sheetTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: SHEET_TYPE.MODEL, value: SHEET_TYPE.MODEL },
      { label: SHEET_TYPE.LINE, value: SHEET_TYPE.LINE },
    ],
    []
  );

  // 1행 합 12 유지 — SheetType 이 뜨면 Version 칸을 1 줄여 자리를 만든다(DivisionType 은 항상 우측 3).
  const versionSize = showSheetType ? 1 : 2;

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1행 — Div / Plan Month / Version / PlanType / Status / [SheetType] / DivisionType */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
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
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00053', { defaultValue: 'Plan Month' })}
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
          <Grid size={versionSize}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00606', { defaultValue: 'Version' })}
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
          {/* Plan Type — AS-IS `txtPlanType` 은 TextVisible=false(라벨 없음) + Enabled=false 인 파생 표시.
              캡처의 작은 회색 박스(`BP`)가 이것이다(decisions §B-2). 콤보가 아니다. */}
          <Grid size={1}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => <InputField fullWidth disabled value={planType} />}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', { defaultValue: 'Status' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.progressStatus}
                  options={combos.statusOptions}
                  // Status 1회 변경이 SheetType 가시성 + Operation/LineType 재구성 + ShowRate 가시성 +
                  //   그리드 비움을 **함께** 일으켜야 한다 — store 액션 하나로 묶는다(02 §5.4).
                  onChange={(_, picked) => setProgressStatus(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          {/* SheetType — 라벨을 붙이지 않는다. AS-IS `ucpSheetType.Text="Status"` 지만
              `TextVisible=false` 라 화면에 안 뜬다(01 L-04). 붙이면 "Status" 라벨이 2개가 된다. */}
          {showSheetType && (
            <Grid size={1}>
              <FormItem
                className={commonStyles.formItem}
                label=''
                render={() => (
                  <CustomDropdown
                    disabled={disabled}
                    value={sc.sheetType}
                    options={sheetTypeOptions}
                    onChange={(_, picked) =>
                      setSearchCondition({
                        sheetType: (String(picked ?? '') || SHEET_TYPE.MODEL) as SheetType,
                        // SheetType 변경도 Operation·Line Type 만 재구성한다(02 §0 #9, F-20).
                        operationId: 'ALL',
                        electrodeType: 'ALL',
                      })
                    }
                  />
                )}
              />
            </Grid>
          )}
          {/* DivisionType — 1행 **우측 정렬**이며 좌측 필드들과 같은 줄이다(decisions §B-2).
              라벨이 없다(`lciDivisionType.TextVisible=false`). `LBL00038`("Electrode")은 이 필드의
              **선택지 하나**이지 필드명이 아니다 — 라벨로 붙이면 3지선다 앞에 "Electrode" 가 찍힌다. */}
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

          {/* 2행 — Site / Plant / Building / Line. 상위 변경 시 하위는 항상 ALL 리셋(F-21). */}
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
                  value={sc.siteId}
                  options={combos.siteOptions}
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
              label={t('LBL00030', { defaultValue: 'Plant' })}
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
              label={t('LBL00008', { defaultValue: 'Building' })}
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
              label={t('LBL00010', { defaultValue: 'Line' })}
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
        </>
      }
      extraConditions={
        <>
          {/* 3행 — Operation(동적) / Line Type(동적) / Basic Nickname(팝업) / Show Rate Columns */}
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
                label={t('LBL00056', { defaultValue: 'Line Type' })}
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
          {/* Item — 라벨이 DivisionType 으로 갈린다(01 L-03): Cell/Module-Pack = Basic Nickname /
              Electrode = Model. **`showElectrodeType`(Cell 전용)을 조건으로 쓰면 Module/Pack 에서
              "Model" 이 떠서 틀린다** — 조건은 `!== ELTR` 이다(SCP0105 와 갈리는 지점).
              입력창 + 팝업 아이콘은 한 덩어리로 묶는다(hook #121 popupSearchField). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={
                showOperation
                  ? t('LBL00054', { defaultValue: 'Basic Nickname' })
                  : t('LBL00669', { defaultValue: 'Model' })
              }
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={disabled}
                  // 대소문자 변환을 넣지 않는다 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지.
                  onChange={event => setSearchCondition({ nickName: event.target.value })}
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
          {/* Show Rate Columns — 초기 체크 상태 `true`(캡처 `☑`, decisions §B-3).
              단 토글 대상인 `M_00`(개선율) 컬럼을 TVF 가 **0건 생성**하므로 눌러도 화면이 바뀌지
              않는 것이 AS-IS 파리티다(03 R-02, V-19). 동작을 "만들어 주지" 않는다. */}
          <Grid size={3}>
            {showShowRate && (
              <FormItem
                className={commonStyles.formItem}
                label=''
                render={() => (
                  <Checkbox
                    disabled={disabled}
                    checked={sc.showRate}
                    labelText={t('LBL01117', { defaultValue: 'Show Rate Columns' })}
                    onChange={checked => setSearchCondition({ showRate: Boolean(checked) })}
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
