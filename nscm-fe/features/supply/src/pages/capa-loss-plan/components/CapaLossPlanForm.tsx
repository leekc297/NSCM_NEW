import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, Checkbox, FormItem, InputField, Radio, RadioGroup } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

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
 * 조회조건 14필드.
 *
 * 배치·기본값·DivisionType 컨트롤은 **사용자 제시 현재 AS-IS 캡처(2026-11-03)로 정정**했다
 * (설계/구 캡처 `asis-screenshot.png` 는 구버전 — 사용자 확인). **2줄 노출 + 3줄부터 접기**
 *   (SearchArea `conditions`/`extraConditions`, 사용자 지시 2026-11-04 — chevron 토글):
 *   [상시] 1행: **DivisionType 라디오 3종(좌)** · Item(Model/Basic Nickname + 돋보기) · Show Rate Columns
 *   [상시] 2행: Div · Plan Month · Version · PlanType(라벨 없는 읽기전용 `BP`) · Status · [SheetType]
 *   [접힘] 3행: Site · Plant · Building · Line
 *   [접힘] 4행(동적): Operation · Line Type  (Electrode 상태에선 둘 다 숨김)
 * DivisionType 은 AS-IS `rgrpDivisionType`(라디오)이라 공용 `@shared/lges` RadioGroup/Radio 로 재현
 *   (드롭다운 대체는 폐기 — 사용자 지시). 기본값 Electrode(constants `DEFAULT_DIVISION_TYPE=ELTR`).
 *
 * 동적 가시성 4규칙의 **조건식이 서로 다르다 — 통일·단순화 금지**(01 L-01/L-02/L-04/L-05):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = !(divisionType === MODULE_PACK || divisionType === ELTR)
 *   showSheetType     = progressStatus in {'1','2'}
 *   showShowRate      = !((progressStatus in {'1','2'}) && sheetType === 'LINE')
 *
 * 필수 조회조건은 만들지 않는다 — AS-IS `Required` 0건 / 라벨 `*` 0건이다(01 §3, 02 §4.4).
 */
export const CapaLossPlanForm = ({ combos, onSearch, onOpenItemPopup, disabled }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaLossPlanStore(state => state.setSearchCondition);
  const setDivision = useCapaLossPlanStore(state => state.setDivision);
  const setDivisionType = useCapaLossPlanStore(state => state.setDivisionType);
  const setProgressStatus = useCapaLossPlanStore(state => state.setProgressStatus);
  const openSearchArea = useCapaLossPlanStore(state => state.openSearchArea);
  const planType = useCapaLossPlanStore(state => state.planType);

  const tabId = useTabid();

  const showOperation = sc.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType = !(
    sc.divisionType === DIVISION_TYPE.MODULE_PACK || sc.divisionType === DIVISION_TYPE.ELTR
  );
  const isCutoff =
    sc.progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    sc.progressStatus === PROGRESS_STATUS.SECOND_CUTOFF;
  const showSheetType = isCutoff;
  const showShowRate = !(isCutoff && sc.sheetType === SHEET_TYPE.LINE);

  // DivisionType 3옵션 — AS-IS rgrpDivisionType(Designer.cs:737~740) 순서 그대로(Electrode=idx0).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 LBL01143(KO/EN/CN) 등재 확인(2026-11-04 ora.py 실측) → t() 적용.
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      { label: t('LBL01143', 'Module/Pack'), value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  // SheetType 옵션 — AS-IS 가 `Items.Add("MODEL"/"LINE")` 로 코드 하드코딩(02 §2.4). 값은 `_sheet_status`
  //   계산 키라 변경 금지. 표시 문구도 AS-IS 가 코드값 그대로다.
  //   lookup/CMBO 미등록 유지 파리티 확정(I-14 — 2026-11-04 사용자 확정). MODEL/LINE 은 2개 고정
  //   계산키라 DB lookup 등록해도 기능·표시 동일(ora.py 실측: SheetType 전용 CMBO 0건) → 하드코딩 유지.
  const sheetTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: SHEET_TYPE.MODEL, value: SHEET_TYPE.MODEL },
      { label: SHEET_TYPE.LINE, value: SHEET_TYPE.LINE },
    ],
    []
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1행 — DivisionType(라디오) · Item(Model/Basic Nickname + 팝업) · Show Rate Columns */}
          {/* DivisionType — AS-IS rgrpDivisionType. 라벨 없음(선택지 "Electrode" 를 필드명으로 붙이면 안 됨). */}
          {/* 1행 간격은 사용자 제공 샘플(2026-11-03)의 margin-left 그대로 — 라디오/Show Rate/Div 를
              균등 분포시키는 값(라디오 70 · Show Rate 100 · Div 120). 라벨 없는 라디오를 라벨칸만큼 민다. */}
          <Grid size={3} sx={{ ml: '70px' }}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => (
                <RadioGroup
                  row
                  sx={{
                    flexWrap: 'nowrap',
                    '& .MuiFormControlLabel-root': { mr: 1 },
                    '& .MuiFormControlLabel-label': { whiteSpace: 'nowrap' },
                  }}
                  value={sc.divisionType}
                  onChange={(_, picked) =>
                    setDivisionType((String(picked ?? '') || DIVISION_TYPE.ELTR) as DivisionType)
                  }
                >
                  {divisionTypeOptions.map(o => (
                    <Radio key={o.value} value={o.value} labelText={o.label} disabled={disabled} />
                  ))}
                </RadioGroup>
              )}
            />
          </Grid>
          {/* Item — 라벨이 DivisionType 으로 갈린다(01 L-03): Cell/Module-Pack = Basic Nickname /
              Electrode = Model. 조건은 `!== ELTR`(showOperation) 이다(SCP0105 와 갈리는 지점).
              입력창 + 팝업 아이콘 한 덩어리(hook #121 popupSearchField). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={showOperation ? t('LBL00054', '_Basic Nickname') : t('LBL00669', '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={disabled}
                  // 대소문자 변환 금지 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지.
                  onChange={event => setSearchCondition({ nickName: event.target.value })}
                  onDoubleClick={onOpenItemPopup}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={disabled}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onOpenItemPopup}
                      />
                    ),
                  }}
                />
              )}
            />
          </Grid>
          {/* Show Rate Columns — 초기 체크 true(캡처 ☑, decisions §B-3). 고정칸(숨김 시 빈칸).
              토글 대상 `M_00` 가 TVF 0건 생성이라 눌러도 화면 불변인 게 AS-IS 파리티(03 R-02). */}
          {/* Show Rate — 샘플 margin-left 100px(1행 균등 분포). */}
          <Grid size={2} sx={{ ml: '100px' }}>
            {showShowRate && (
              <FormItem
                className={commonStyles.formItem}
                label=''
                render={() => (
                  <div style={{ whiteSpace: 'nowrap' }}>
                    <Checkbox
                      disabled={disabled}
                      checked={sc.showRate}
                      labelText={t('LBL01117', '_Show Rate Columns')}
                      onChange={checked => setSearchCondition({ showRate: Boolean(checked) })}
                    />
                  </div>
                )}
              />
            )}
          </Grid>

          {/* Div — 1행 마지막. 샘플 margin-left 120px + size 4 — margin 이 박스 폭을 깎으므로 칸을 4로 키워
              아래 Site 콤보(size 3)와 박스 폭을 맞춘다(4칸 − 라벨 − margin120 ≈ Site 박스). 이후 Plan Month
              부터 2행(Plan Month · Version · PlanType(BP) · Status · [SheetType] · Site). */}
          <Grid size={4} sx={{ ml: '120px' }}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={combos.divisionOptions}
                  // Division 변경 = 검색조건(Div·DivisionType 제외) + 그리드 초기화. 편집중(dirty)이면
                  //   MSG00704 confirm 후에만, 취소 시 controlled 콤보가 이전 Div 로 복귀.
                  onChange={(_, picked) => {
                    const next = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(next);
                    });
                  }}
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
          {/* Plan Type — AS-IS `txtPlanType` TextVisible=false(라벨 없음) + Enabled=false 파생 표시(캡처 `BP`). */}
          <Grid size={1}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => <InputField fullWidth disabled value={planType} />}
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
                  // Status 1회 변경이 SheetType 가시성 + Operation/LineType 재구성 + ShowRate 가시성 +
                  //   그리드 비움을 함께 일으킨다 — store 액션 하나로 묶는다(02 §5.4).
                  onChange={(_, picked) => setProgressStatus(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          {/* SheetType — 라벨 없음(AS-IS `TextVisible=false`, 01 L-04). 컷오프(1/2차) 상태에서만 렌더. */}
          {showSheetType && (
            <Grid size={2}>
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
                        // SheetType 변경도 Operation·Line Type 만 재구성(02 §0 #9, F-20).
                        operationId: 'ALL',
                        electrodeType: 'ALL',
                      })
                    }
                  />
                )}
              />
            </Grid>
          )}
        </>
      }
      extraConditions={
        <>
          {/* 3행(접힘, 3줄부터 접기 — 2026-11-04) — Site · Plant · Building · Line. 상위 변경 시 하위는 항상 ALL 리셋(F-21). */}
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
          {/* 컨트롤명은 clbFactory 지만 AS-IS 표기는 "Building"(LBL00008). "Factory" 아님. */}
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

          {/* 4행 — Operation · Line Type (동적). Electrode 에선 둘 다 숨김 → 캡처(1~3행)와 동일.
              마지막 요소라 조건부 렌더가 앞 행 정렬을 깨지 않는다. */}
          {showOperation && (
            <Grid size={3}>
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
            </Grid>
          )}
          {showElectrodeType && (
            <Grid size={3}>
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
                    onChange={(_, picked) => setSearchCondition({ electrodeType: String(picked ?? '') })}
                  />
                )}
              />
            </Grid>
          )}
        </>
      }
    />
  );
};
