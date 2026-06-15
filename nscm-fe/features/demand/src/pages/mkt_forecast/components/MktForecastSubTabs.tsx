import { useState } from 'react';

import { TabItem, TabWrapper } from '@shared/components';

import type { SearchCondition } from '../mkt-forecast-master.types';
import { MktForecastCarSubGrid } from './MktForecastCarSubGrid';
import { MktForecastPsiSubGrid } from './MktForecastPsiSubGrid';

interface Props {
  searchCondition: SearchCondition;
  selectedProjectCode?: string;
  selectedItemId?: string;
}

// AS-IS DMF0003_1_MktFcst.cs L6825 splitContainer2_DoubleClick + btnUpDown_Click
//   - SubGrid 영역 (spdSub1 + spdSub2 + spdSub3) — 3 sub-sheet 통합
//   - PSI 분석 / Car Fcst 두 탭으로 분리 (Phase 4)
//
// Phase 4 적용:
//   - TabWrapper + TabItem 표준 컴포넌트
//   - 부모 메인 grid 의 선택 row 의 projectCode / itemId 전달 (drill-down)

export const MktForecastSubTabs = ({
  searchCondition,
  selectedProjectCode,
  selectedItemId,
}: Props) => {
  const [activeTabIndex, setActiveTabIndex] = useState<number>(0);
  const [carMaker, _setCarMaker] = useState<string>('ALL');

  return (
    <TabWrapper activeTabIndex={activeTabIndex} setActiveTabIndex={setActiveTabIndex}>
      <TabItem label='PSI 분석'>
        <MktForecastPsiSubGrid
          divisionId={searchCondition.divisionId}
          projectCode={selectedProjectCode}
          itemId={selectedItemId}
          fromYyyymmdd={searchCondition.startYyyymmdd}
          toYyyymmdd={searchCondition.endYyyymmdd}
        />
      </TabItem>
      <TabItem label='Car Forecast'>
        <MktForecastCarSubGrid
          divisionId={searchCondition.divisionId}
          carMaker={carMaker}
          fromYyyymmdd={searchCondition.startYyyymmdd}
          toYyyymmdd={searchCondition.endYyyymmdd}
        />
      </TabItem>
    </TabWrapper>
  );
};
