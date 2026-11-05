import dayjs from 'dayjs';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo } from 'react';

import type { ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  COMBO,
  EE_ATTRIBUTE,
  LBL,
  PERIOD_MONTHS_SPAN,
  STATUS_LOOKUP,
  TAB_INDEX,
} from '../stock-osp.constants';
import { useStockOspStore } from '../useStockOspStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // Division 권한 0건 여부를 페이지로 전달(조회 차단 게이트, design 02 §6-8).
  onDivisionAuth: (hasAuth: boolean) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 다중 콤보 'ALL'/공백 정규화 → 실코드 배열(전체선택 = 빈 배열, 부분선택만 유지).
const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// PACKER_HOLD_STATUS lookup → 옵션. BE /admin/lookup 응답 키는 CODE/NAME 이다(네트워크 실측 2026-10-14:
//   CODE=HOLD/RELEASE, NAME=Hold/Release). design 02 는 DB 원본 컬럼 SEGMENT1/2 로 적었으나 API 응답은
//   CODE/NAME 으로 내려오므로 여기서 CODE/NAME 을 읽어야 한다(SEGMENT1/2 로 읽으면 전 옵션 공백 → ALL만 노출).
const toStatusOptions = (rows: LookupResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// SCP0041 조회조건 (design 02 §1 인벤토리 7건, 탭 분기 §4):
//   공통: Division(FE 필터 ATTRIBUTE3!=='EE') / Plant Site(탭별 콤보 상이) / Model(ItemByDivisionModal 돋보기) / Period.
//   Pack 전용: Inspection(텍스트) / Status(PACKER_HOLD_STATUS lookup) / Cutoff Date(기간) — extraConditions 폴드.
//   Osp Plant Site = OSP1 ∪ SaleSite1 Merge / Pack Plant Site = PackerHoldStock1 단독(design 02 §Osp/§Pack).
export const StockOspForm = ({ onSearch, onItemSearch, onDivisionAuth }: Props) => {
  const { t } = useTranslation();

  const sc = useStockOspStore(s => s.searchCondition);
  const set = useStockOspStore(s => s.setSearchCondition);
  const setDivision = useStockOspStore(s => s.setDivision);
  const openSearchArea = useStockOspStore(s => s.openSearchArea);
  const activeTab = useStockOspStore(s => s.activeTab);
  const isPack = activeTab === TAB_INDEX.PACK;

  const tabId = useTabid();

  // 콤보 4종 + PERIOD_DEFAULT + Status lookup. Plant Site 는 탭에 따라 3개 소스가 달라 전부 조회하고 화면에서 합친다.
  //   Osp: OSP1(PLANT) ∪ SaleSite1(SALES) Merge / Pack: PackerHoldStock1(PLANT) 단독.
  //   PERIOD_DEFAULT = Osp 탭 Period 시작월 서버값(design 02 §4, 파라미터 없음).
  const [divisions, plantOsp, saleOsp, plantPack, periodDefaultRows] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.PLANT_SITE_OSP, divisionId: sc.divisionId },
      { comboId: COMBO.SALE_SITE_OSP, divisionId: sc.divisionId },
      { comboId: COMBO.PLANT_SITE_PACK, divisionId: sc.divisionId },
      COMBO.PERIOD_DEFAULT,
    ],
  });
  const [statusRows] = useTabLookupQueries({ filters: [STATUS_LOOKUP] });

  // 탭별 Period/Cutoff 기본값 — AS-IS SetChangedControl→setPeriod 가 탭 전환마다 재설정(cs:530~557).
  //   Pack: Period=now−3M~now+9M, Cutoff=now~now(GetDayRange, cs:567~574). 순수 클라 계산.
  //   Osp : Period=PERIOD_DEFAULT 일자~+11M. 서버 응답 전에는 오늘 기준 근사치로 먼저 채우고,
  //         아래 PERIOD_DEFAULT effect 가 FROM_VALUE 로 교정한다(project-route G6 동형).
  //   사용자 지시(2026-10-14): 탭 전환마다 재계산(AS-IS 일치) — 탭을 바꾸면 그 탭 기본값으로 되돌린다.
  useEffect(() => {
    if (isPack) {
      set({
        fromYyyymmdd: dayjs().subtract(3, 'month').format('YYYYMMDD'),
        toYyyymmdd: dayjs().add(9, 'month').format('YYYYMMDD'),
        cutoffFromYyyymmdd: dayjs().format('YYYYMMDD'),
        cutoffToYyyymmdd: dayjs().format('YYYYMMDD'),
      });
    } else {
      set({
        fromYyyymmdd: dayjs().format('YYYYMMDD'),
        toYyyymmdd: dayjs().add(PERIOD_MONTHS_SPAN, 'month').format('YYYYMMDD'),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isPack]);

  // Osp 탭 Period 서버 교정 — AS-IS cs:539~556: From=FROM_VALUE(일자 그대로) / To=GetDateAdd(From,+11M).
  //   FROM_VALUE 는 ISO_WEEK 당주 기준 일자(YYYYMMDD, debugGetCombo 실측 '20261012'). 월 절삭 없이
  //   일 단위 그대로 쓴다(AS-IS 완전 일치, 사용자 지시 2026-10-14). 6자리로 올 경우만 해당월 1일 보정.
  //   Pack 탭이거나 응답 전이면 no-op. 탭 전환 시 위 effect 가 근사치로 되돌린 뒤 이 effect 가 재교정.
  useEffect(() => {
    if (isPack) return;
    const raw = String(periodDefaultRows?.[0]?.FROM_VALUE ?? '');
    // 네이티브 지원 포맷(YYYY-MM-DD)으로 파싱 — customParseFormat 플러그인 전역확장 의존 회피.
    const iso =
      raw.length >= 8
        ? `${raw.slice(0, 4)}-${raw.slice(4, 6)}-${raw.slice(6, 8)}`
        : raw.length >= 6
          ? `${raw.slice(0, 4)}-${raw.slice(4, 6)}-01`
          : '';
    const from = dayjs(iso);
    if (!iso || !from.isValid()) return;
    set({
      fromYyyymmdd: from.format('YYYYMMDD'),
      toYyyymmdd: from.add(PERIOD_MONTHS_SPAN, 'month').format('YYYYMMDD'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isPack, periodDefaultRows]);

  // Division — AS-IS GetDivisionWithoutEE 재현: ATTRIBUTE3='EE'(전극) 사업부 제외(design 02 §2-1).
  const divisionOptions = useMemo(
    () =>
      toOptions(divisions).filter(o => {
        const row = (divisions ?? []).find(r => str(r.CODE) === o.value);
        return str(row?.ATTRIBUTE3).trim().toUpperCase() !== EE_ATTRIBUTE;
      }),
    [divisions]
  );

  // Plant Site 옵션 — 탭별 소스. Osp 는 두 콤보를 CODE 기준 합집합(중복 제거, OSP1 우선).
  const plantSiteOptions = useMemo<Option[]>(() => {
    if (isPack) return toOptions(plantPack);
    const merged = [...toOptions(plantOsp), ...toOptions(saleOsp)];
    const seen = new Set<string>();
    return merged.filter(o => (seen.has(o.value) ? false : (seen.add(o.value), true)));
  }, [isPack, plantOsp, saleOsp, plantPack]);

  const statusOptions = toStatusOptions(statusRows);

  // 권한 게이트 — Division 응답이 왔고(≠undefined) 0건이면 권한 없음(design 02 §6-8).
  //   MyDivision 권한조인(USER_GR_MNU_MPG_M) 2행 실측이라 정상 사용자는 통과(memory 트랜스퍼킬러 해소).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (divisions === undefined) return;
    onDivisionAuth(!noDivisionAuth);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // Division 첫 항목 자동 보정 — 초기값은 빈 값이라(세션 사업부 기본 금지, 사용자 지시 2026-10-14)
  //   권한목록 첫 항목으로 초기화된다(AS-IS setListBox index 0 선택 재현). 저장분 복원값이 유효하면 그대로 유지.
  useEffect(() => {
    if (divisionOptions.length === 0) return;
    if (!divisionOptions.some(o => o.value === sc.divisionId)) {
      set({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  // Division 변경 = 검색조건(Div·기간/Cutoff 날짜 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
  //   cascade 콤보(PlantSite)는 setDivision 이 plantSiteIds 를 비우고 useTabComboQueries divisionId 파라미터로 자동 재조회.
  //   조회(Search) 버튼이 이미 타는 공통 가드와 동일 경로('search').
  const onDivisionChange = (value: string) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) setDivision(value);
    });
  };

  const model = (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(LBL.MODEL, '_Model/Nickname')}
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
                  disabled={noDivisionAuth}
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={onItemSearch}
                />
              ),
            }}
            onChange={e => set({ itemId: e.target.value })}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  // Pack 전용 조회조건(Inspection/Status/Cutoff Date) — Osp 탭엔 없음(undefined). Pack 탭 7칸(=2단 이내)이라
  //   접이식(extraConditions) 대상 아님(SRCH-02: 8칸 초과만 분리). conditions 2행째로 상시 노출 → 탭 전환 시 바로 보임
  //   (design 02 §4 탭별 조회조건 가시성 분기 / §6-5 Pack 탭 전용 노출).
  //   배치 순서: Cutoff Date → Inspection → Status(사용자 지시 2026-10-28).
  const packExtra = isPack ? (
    <>
      <PeriodField
        gridSize={3}
        start={sc.cutoffFromYyyymmdd}
        end={sc.cutoffToYyyymmdd}
        onChange={(start, end) => set({ cutoffFromYyyymmdd: start, cutoffToYyyymmdd: end })}
        label={t(LBL.CUTOFF_DATE, '_Cutoff Date')}
      />
      <Grid size={3}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.INSPECTION, '_Inspection')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={sc.inspectionId}
              disabled={noDivisionAuth}
              onChange={e => set({ inspectionId: e.target.value })}
              onKeyDown={e => e.key === 'Enter' && onSearch()}
            />
          )}
        />
      </Grid>
      <Grid size={3}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.STATUS, '_Status')}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              allOption
              useClearIcon
              value={sc.status}
              options={statusOptions}
              disabled={noDivisionAuth}
              onChange={(_, picked) => set({ status: pickMulti(picked).join(',') })}
            />
          )}
        />
      </Grid>
    </>
  ) : undefined;

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — FE 필터 ATTRIBUTE3!=='EE'(design 02 §2-1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, picked) => onDivisionChange(str(picked))}
                />
              )}
            />
          </Grid>
          {/* Plant Site — 다중선택 + ALL. Osp=OSP1∪SaleSite1 / Pack=PackerHoldStock1 (design 02 §Osp/§Pack) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={noDivisionAuth}
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) => set({ plantSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>
          {/* Model/Nickname — 텍스트 + 돋보기(메1 MaterialByDivisionModal, 사용자 지시 2026-10-14) */}
          {model}
          {/* Inventory Date — 조회 기간(design 02 §1, Osp=재고일자 YYYYMMDD / Pack=HOLD 날짜 필터).
              사용자 지시 2026-10-14: Period→Inventory Date 로 표기. 다국어 미처리·영문 고정(LBL 신규생성 안 함). */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label='Inventory Date'
          />
          {/* Pack 전용(Cutoff Date/Inspection/Status) — Pack 탭에서만 2행째로 노출(Osp 탭=undefined) */}
          {packExtra}
        </>
      }
    />
  );
};
