import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, type MutableRefObject } from 'react';

/**
 * 그리드 날짜 컬럼의 표시·커밋 형식을 대시(`yyyy-MM-dd`)로 고정한다.
 *
 * 문제: 공용 `getFormat`(packages/foundation/src/utils/columnMapping.ts)이 FPDate·FPDateTime·
 *   FPDateText·FPDateMonth 컬럼에 `'yyyy.MM.dd'` 를 찍는다. 조회만 하면 서버가 문자열
 *   ('YYYY-MM-DD', 커서의 TO_CHAR)을 주고 Wijmo 가 컬럼 타입을 String 으로 추론해 format 을
 *   적용하지 않으므로 대시로 보인다. 그런데 달력(InputDate)으로 값을 고치거나 신규행에 입력하면
 *   셀 값이 **Date 객체**가 되고, 그때 format 이 적용되어 `'2026.10.26'` 이 된다.
 *   즉 같은 컬럼이 조회는 대시, 수정은 점으로 보이는 불일치다.
 *
 * 더 중요한 것은 표시가 아니라 **값**이다. String 컬럼에 Date 가 커밋되면 Wijmo 가 format 으로
 *   문자열화하므로 행 데이터 자체가 `'2026.10.26'` 이 되어 그대로 SP payload 로 흘러간다.
 *   (그래서 shipment-request-pack 의 save 유틸이 'YYYY-MM-DD'·'YYYY.MM.dd' 양쪽을 ymd8 로
 *    정규화하는 방어 코드를 갖고 있다 — 그 방어가 없는 화면은 점 형식이 그대로 나간다.)
 *
 * 왜 공용 상수를 안 고치는가: 공용을 바꾸면 메타 실측 기준 484개 컬럼·약 80개 화면이 한 번에
 *   바뀐다. 사용자 지시(2026-10-23, 2026-10-26 재확인)에 따라 공용 기본값은 건드리지 않고
 *   화면별로 opt-in 한다. 이 훅을 호출하지 않는 화면의 동작은 완전히 그대로다.
 *
 * 컬럼명을 나열하지 않는 이유: 세 화면만 해도 날짜 컬럼이 46개다(메타 실측). 이름 목록은 메타가
 *   바뀌면 조용히 낡는다. 대신 `getFormat` 이 찍은 점 형식을 가진 컬럼만 집어 바꾼다 —
 *   대상 선정 기준이 원인과 같은 곳(공용 getFormat)이라 메타가 늘어도 자동으로 따라온다.
 *
 * FPDateTime 도 `yyyy-MM-dd` 로 맞춘다(사용자 결정 2026-10-26: 날짜만 유지). 공용 getFormat 이
 *   이미 날짜만 찍고 있어 표시 모양은 그대로이고 구분자만 바뀐다 — 내일 dev 배포 영향 최소.
 *   주의: DateTime 셀을 편집하면 시각이 00:00:00 으로 잘리는 기존 부작용은 이 훅 밖의 문제다
 *   (편집기 InputDateTime 은 'yyyy-MM-dd HH:mm:ss' 인데 컬럼 format 이 날짜만이라 생긴다).
 *
 * @param gridRef  DataGrid 가 채우는 FlexGrid ref
 * @param resetKey 컬럼이 재생성되는 트리거(보통 columns prop). 바뀌면 다시 적용한다.
 */
const DOT_DATE_FORMAT = 'yyyy.MM.dd';
const DASH_DATE_FORMAT = 'yyyy-MM-dd';

/**
 * 그리드 1개에 대시 형식 고정을 붙이고 해제 함수를 돌려준다.
 *   시트별 그리드가 여러 개인 화면(Detail 탭)은 ref 마다 훅을 부를 수 없어 effect 안에서 이 함수를 쓴다.
 *   updatedLayout 핸들러 안에서 format 을 쓰면 다시 updatedLayout 이 돌 수 있으므로, 이미 목표 형식인
 *   컬럼은 건드리지 않는다(무한 루프 가드 — shipment-request-pack 선례와 같다).
 */
export const attachDashDateFormat = (grid: FlexGridType): (() => void) => {
  const apply = (): void => {
    for (const column of grid.columns) {
      if (column.format === DOT_DATE_FORMAT) {
        column.format = DASH_DATE_FORMAT;
      }
    }
  };

  apply();
  // 컬럼 재생성(메타 로드·동적 컬럼 교체) 뒤에도 유지되어야 한다.
  grid.updatedLayout.addHandler(apply);
  return () => {
    try {
      grid.updatedLayout?.removeHandler(apply);
    } catch {
      /* unmount race — 그리드가 먼저 파괴된 경우 */
    }
  };
};

export const usePinDashDateFormat = (
  gridRef: MutableRefObject<FlexGridType | undefined>,
  resetKey?: unknown
): void => {
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    return attachDashDateFormat(grid);
  }, [gridRef, resetKey]);
};
