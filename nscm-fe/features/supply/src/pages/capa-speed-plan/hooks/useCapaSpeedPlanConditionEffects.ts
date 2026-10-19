import type { MutableRefObject } from 'react';
import { useEffect, useRef } from 'react';

import type { EditTracker } from '@foundation/utils';

import type { DivisionType } from '../capa-speed-plan.constants';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';

interface UseCapaSpeedPlanConditionEffectsParams {
  tabId: string;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  divisionId: string;
  divisionType: DivisionType;
  version: string;
  versionSeq: string;
  progressStatus: string;
}

/**
 * 조회조건 변경에 따른 초기화·헤더 재조회 — AS-IS 는 5개 콤보(Division·DivisionType·Version·
 * VersionSeq·Status)의 `SelectedIndexChanged` 가 **전부** `BeforeFindData()`(cs:2041~2048 =
 * `InitSpread()` 시트 클리어 -> `RefreshSheetHeader(true)` 헤더 재조회 -> `RefreshColumnsVisible()`)
 * 를 부른다. Page 인라인이던 effect 4종을 모아 분리했다(구조 룰 #9 — Page 는 조립만 한다).
 *
 * effect 선언 순서가 곧 AS-IS 실행 순서다: (2)(3) 이 그리드를 비운 **뒤** (4) 가 헤더를 다시 만든다.
 */
export const useCapaSpeedPlanConditionEffects = ({
  tabId,
  editTrackerRef,
  divisionId,
  divisionType,
  version,
  versionSeq,
  progressStatus,
}: UseCapaSpeedPlanConditionEffectsParams) => {
  const clearFilters = useCapaSpeedPlanStore(state => state.clearFilters);
  const restoreSearchConditions = useCapaSpeedPlanStore(state => state.restoreSearchConditions);
  const refreshSpreadTitle = useCapaSpeedPlanStore(state => state.refreshSpreadTitle);
  const fetchStaticColumns = useCapaSpeedPlanStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCapaSpeedPlanStore(state => state.fetchStaticMeasures);
  const clearUserColumnLayout = useCapaSpeedPlanStore(state => state.clearUserColumnLayout);
  const initialized = useCapaSpeedPlanStore(state => state.initialized);

  // (1) 진입 — 자동조회 금지. keep-alive 잔여 filters 무효화 + 메타 1회 fetch(nscm-patterns §5-7).
  //   F6 로 저장한 조회조건을 복원한다(새로고침/재진입 1회, basic-check #3). searchCondition 만 patch,
  //   filters 불변이라 진입 자동조회 게이트는 유지된다. 저장측은 Page 의 SubTitle `searchParam={sc}`.
  useEffect(() => {
    clearFilters();
    void restoreSearchConditions();
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  /**
   * (2) Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5).
   * 컬럼 메타는 division 스코프라 여기서 새 division 을 인자로 넘겨 재조회한다 — producer 안에서
   * `get()` 으로 읽으면 커밋 전 이전 값이라 컬럼셋이 한 스텝 밀린다.
   * 개인화(titleSet)는 division 축이 없는 1벌이라 컬럼셋이 바뀌면 비운다.
   */
  const prevDivisionRef = useRef(divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === divisionId) return;
    prevDivisionRef.current = divisionId;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    clearUserColumnLayout();
    void fetchStaticColumns(divisionId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionId]);

  /**
   * (3a) DivisionType(Cell/Module Pack/Electrode) 변경 = 시트 전환 = CRUD 마킹 초기화 의무(01 V-04).
   * store 의 `setDivisionType` 이 하위 6축 ALL 리셋 + filters/applied 를 되돌리지만
   * `EditTracker` 는 ref 라 store 밖에 있다 — 여기서 함께 비우지 않으면 ASSEMBLY 에서 고친 기록이
   * ELTR 로 넘어가 dirty 오탐이 난다(시트마다 컬럼셋이 다르므로 저장 페이로드도 오염된다).
   */
  const prevDivisionTypeRef = useRef(divisionType);
  useEffect(() => {
    if (prevDivisionTypeRef.current === divisionType) return;
    prevDivisionTypeRef.current = divisionType;
    editTrackerRef.current?.clearChanges();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionType]);

  /**
   * (3b) Version / Version(Seq) / Status 변경 = 그리드 초기화 의무.
   * 이 3축을 빼면 구버전 데이터가 그리드에 남은 채 Edit 게이트만 새 버전 기준으로 재계산돼
   * (버전 A 조회 -> Version 콤보만 B 로 변경) CUTOFF 데이터가 편집·저장된다.
   */
  const prevVersionKeyRef = useRef(`${version}|${versionSeq}|${progressStatus}`);
  useEffect(() => {
    const versionKey = `${version}|${versionSeq}|${progressStatus}`;
    if (prevVersionKeyRef.current === versionKey) return;
    prevVersionKeyRef.current = versionKey;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [version, versionSeq, progressStatus]);

  /**
   * (4) 기간 헤더 선행 재조회 — AS-IS `CreateSpread()`(Form_Load, cs:1300~1310)와 위 콤보 경로의
   * `BeforeFindData()` 가 둘 다 `RefreshSheetHeader(true)` -> `GetSpdTitle()`(cs:1312~1335)을 부른다.
   * **조회 버튼에 묶인 것은 그리드 데이터뿐**이므로(F-19) 헤더는 Search 없이도 최신이어야 한다
   * (03 V-11/V-15 — 이게 빠지면 Version 만 바꿨을 때 헤더가 이전 버전 기준으로 남는다).
   * `p_from_yyyymm` 은 Version(Plan Month)에서만 파생되므로 그 축만 본다 — 나머지 4콤보 경로는
   * 헤더 내용이 같아 store 가 참조를 유지한다(컬럼 재조립 없음).
   */
  useEffect(() => {
    refreshSpreadTitle();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [version]);
};
