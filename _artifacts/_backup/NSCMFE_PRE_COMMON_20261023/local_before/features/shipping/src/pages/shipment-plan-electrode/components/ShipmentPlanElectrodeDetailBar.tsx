import { PeriodField } from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Stack } from '@shared/mui';

import { LBL, LOOKUP, SHEETS } from '../shipment-plan-electrode.constants';
import styles from '../ShipmentPlanElectrode.module.scss';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';

interface Props {
  onDetailSearch: () => void; // btnSearch — 활성 Detail sheet 재조회
  // btnItemId2 → ItemByDivisionModal(page 소유). 상세 Material 팝업(AS-IS BtnMaterialId2_Click cs:824~).
  onItemSearch2: () => void;
  // btnRequestor → RequestorModal(page 소유). PlanDetail 전용(AS-IS BtnRequestor_Click cs:1812~).
  onRequestorSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 2차 조회조건 (usrLayoutControl3 — Detail 그리드 상단, design 03 §0):
//   활성 Detail sheet 별 필드셋 전환(detailFieldSet) — 각 상세 SP IN 집합을 그대로 노출(1차와 독립 축):
//     PlanDetail     : Model2 + Material2(팝업) + NickName2 + Requestor(팝업) + Shipment Date(drpPeriod2) + NEW + Search
//     StockDetail    : Material2(팝업) + NickName2 + Lot ID + Search
//     ShipmentResult : Result Type + Material2(팝업) + Shipment Date(drpPeriod3) + Search
//   Shipment Date 는 drpPeriod2(PlanDetail)·drpPeriod3(ShipmentResult) 가 별개 컨트롤이라 store 에
//     planDetailShip*/shipResultShip* 독립축을 둔다(setPlanDate 가 파생초기화, 이후 사용자 재편집 가능).
//   레이아웃: MUI 12칸 Grid(size 3×5=15 > 12 → 2줄 접힘) 대신 flex 한 줄(detailBarFields)로 두고
//     각 필드를 내용 폭 기준 flex item(detailBarField)으로 깐다. 라벨 컬럼 폭도 함께 좁혀
//     (detailBarFieldItem — commonStyles.formItem grid-template-columns override) PlanDetail
//     5필드가 한 줄에 들어오게 한다(필드 입력폭은 유지, 사용자 지시 2026-10-11).
export const ShipmentPlanElectrodeDetailBar = ({
  onDetailSearch,
  onItemSearch2,
  onRequestorSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const set = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const fieldSet = useShipmentPlanElectrodeStore(s => s.detailFieldSet);
  const activeSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE, 02 §5-1). FE 후필터 R 제외(설계 02 §5-1).
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.RESULT_TYPE] });
  const resultTypeOptions = toOptions((resultTypes ?? []).filter(r => str(r.CODE) !== 'R'));

  // Shipment Date 는 활성 sheet 에 따라 다른 독립축(drpPeriod2 vs drpPeriod3)을 바인딩한다.
  const isResult = activeSheet === SHEETS.SHIPMENT_RESULT;
  const shipFrom = isResult ? sc.shipResultShipFrom : sc.planDetailShipFrom;
  const shipTo = isResult ? sc.shipResultShipTo : sc.planDetailShipTo;
  const onShipChange = (start: string, end: string) =>
    set(isResult ? { shipResultShipFrom: start, shipResultShipTo: end } : { planDetailShipFrom: start, planDetailShipTo: end });

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      {/* 필드 좌→우 순서는 AS-IS usrLayoutControl3 컨트롤 Location.X 순서를 따른다(사용자 지시 2026-10-11):
          Shipment Date(94) → Model(620) → Material(789) → Nick Name(1014) → Requestor(1167)
          → Lot ID(1348) → Result Type(1537). 시트별 show/hide 후에도 이 축이 유지되도록 블록 순서 고정. */}
      <div className={styles.detailBarFields}>
        {/* Shipment Date — drpPeriod2(PlanDetail) / drpPeriod3(ShipmentResult) 독립축. 분리형 날짜 range.
            PeriodField 는 자체 Grid·label 포함 — flex 행에 맞추려 detailBarField 로 감싸고 라벨칸만 좁힌다. */}
        {fieldSet.shipmentDate && (
          <div className={`${styles.detailBarField} ${styles.detailBarDateField}`}>
            <PeriodField
              gridSize={12}
              label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
              start={shipFrom}
              end={shipTo}
              onChange={onShipChange}
            />
          </div>
        )}

        {/* Model — txtModel2 (PlanDetail 전용). P_MODEL_ID(저장 시 store 에서 ToUpper). */}
        {fieldSet.model && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.detailModelId}
                  onChange={e => set({ detailModelId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </div>
        )}

        {/* Material — txtItemId2 + btnItemId2 팝업(ItemByDivisionModal, page 소유). 3-sheet 공통.
            빈 반환 시 기존값 유지(AS-IS BtnMaterialId2_Click cs:824~836). */}
        {fieldSet.material && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.detailItemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch2} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ detailItemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </div>
        )}

        {/* Nick Name — txtNickName2 (PlanDetail/StockDetail). P_NICK_NAME(저장 시 store 에서 ToUpper). */}
        {fieldSet.nickName && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.NICK_NAME, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.detailNickName}
                  onChange={e => set({ detailNickName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </div>
        )}

        {/* Requestor — txtRequestor + btnRequestor 팝업(RequestorModal, page 소유, PlanDetail 전용).
            AS-IS 는 p_requestor 로 표시명을 전달 — 선택/직접입력 모두 표시명을 detailRequestor 에 둔다. */}
        {fieldSet.requestor && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.REQUESTOR, '_Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.detailRequestor}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onRequestorSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ detailRequestor: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </div>
        )}

        {/* Lot ID — txtLotID (StockDetail 전용). P_LOT_ID(ToUpper 없음). */}
        {fieldSet.lotId && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.LOT_ID, '_Lot ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.detailLotId}
                  onChange={e => set({ detailLotId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </div>
        )}

        {/* Result Type — clbResultType (ShipmentResult 전용, lookup FE 후필터 R 제외).
            AS-IS 는 UsrCheckedList(체크리스트) 다중선택 — 기본 P(Plan)+O(oWMS) 체크(cs:914~915).
            CSV join 으로 SP p_type 에 전달(From Site clbFromSite 와 동일 패턴). allOption 없음(AS-IS 에
            "전체" 행이 없어 미선택=빈 p_type 그대로 전달). */}
        {fieldSet.resultType && (
          <div className={styles.detailBarField}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
              label={t(LBL.RESULT_TYPE, '_Result Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  useClearIcon
                  limitTags={1}
                  value={sc.resultType.join(',')}
                  options={resultTypeOptions}
                  onChange={(_, picked) =>
                    set({ resultType: str(picked).split(',').filter(Boolean) })
                  }
                />
              )}
            />
          </div>
        )}
      </div>

      <Stack direction='row' className={styles.detailBarButtons}>
        {/* 신규행 추가는 공통 상단 툴바 INSERT 버튼으로만 한다(AS-IS InsertButton 오버라이드 재현).
            AS-IS 2차 조회조건 영역엔 별도 New 버튼이 없어 하단 전용 버튼을 제거했다(사용자 지시 2026-10-11). */}
        {/* Search — 활성 sheet 재조회(항상 표시). 라벨은 자매 Mobility&IT 하단 detail bar 와 동일하게
            SEARCH_GRID("Search")를 쓴다 — 상단 SearchArea 의 SEARCH("Search(F5)")와 구분(사용자 지시 2026-10-12). */}
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.SEARCH_GRID, '_Search')}
        </Button>
      </Stack>
    </Stack>
  );
};
