import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { CSSProperties, MouseEventHandler, ReactNode, RefObject } from 'react';

// @lges/design-system 의 SubTitleDepthType 과 동일하나 @shared/lges 에서 re-export 되지 않아 로컬 정의.
type SubTitleDepthType = 'h3' | 'h4' | 'h5';

export type ResultAreaProps = {
  /** 그리드 본문(DataGrid 등). 남은 공간을 모두 채운다. */
  children: ReactNode;

  /** 영역 제목. 주면 상단에 TitleArea(isSubTitle) 헤더를 렌더하고, 생략하면 그리드만 채운다. */
  title?: string;
  /** 제목 depth. 기본 'h4'. */
  depth?: SubTitleDepthType;
  /** 제목 우측 건수. 0/undefined 면 미표시. gridRef 를 주면 필터 적용 시 이 값 대신 실제 표시 건수를 보여준다. */
  count?: number;
  /**
   * 필터 반영 건수 계산 대상 그리드(선택). 주면 F4/헤더 필터로 좁혀진 실제 표시 건수를
   * count 대신 보여준다. gridFilterRef 와 함께 줘야 필터 적용/해제 이벤트를 구독한다.
   */
  gridRef?: RefObject<FlexGrid | undefined>;
  /** gridRef 그리드에 붙은 FlexGridFilter. gridRef 와 함께 준다. */
  gridFilterRef?: RefObject<FlexGridFilter | undefined>;
  /** 제목 우측 버튼 영역(이 영역 전용 추가/삭제 등). */
  rightButtons?: ReactNode;

  /**
   * 이 영역이 차지할 비율. 생략하면 남은 공간 전부(`1 1 0`).
   *   - 숫자 = grow 비율. **형제들의 합이 10** 이 되게 준다 — 6:4, 7:3, 5:5, 3단이면 4:3:3.
   *     (5:3 처럼 합이 10 이 아니면 실제로는 62.5%/37.5% 라 코드만 보고 오해하게 된다.)
   *   - 고정 크기는 CSS 원형 문자열로 — `'0 0 180px'`.
   */
  flex?: number | CSSProperties['flex'];
  /** 헤더와 그리드 사이 간격(px). 기본 4. */
  gap?: number;

  /**
   * 이 영역 안을 클릭했을 때(capture 단계라 그리드 내부 클릭도 잡힌다).
   * 그리드가 여럿인 화면에서 SubTitle 의 Excel/Sort/Filter 대상 그리드를 추적하는 용도.
   */
  onClickCapture?: MouseEventHandler<HTMLDivElement>;

  className?: string;
  style?: CSSProperties;
};

/** 배치 방향. 'column'/'row' 는 CSS 용어 하위호환('vertical'/'horizontal' 과 동일). */
export type ResultAreaDirection = 'vertical' | 'horizontal' | 'column' | 'row';

export type ResultAreaGroupProps = {
  /** ResultArea(및 중첩 ResultArea.Group) 자식들. */
  children: ReactNode;
  /** 자식 배치 방향. 'vertical'(위/아래, 기본) | 'horizontal'(좌/우). */
  direction?: ResultAreaDirection;
  /** 자식 사이 간격(px). 기본 4, 좌우 분할은 24 권장. split 일 때는 드래그 바가 간격을 대신하므로 무시된다. */
  gap?: number;

  /**
   * 자식 경계를 드래그해 크기를 조절할 수 있게 한다(react-resizable-panels).
   * 각 자식의 `flex` 숫자가 초기 비율이 되고(생략하면 균등), 이후 사용자가 끌어서 바꾼다.
   */
  split?: boolean;
  /** split 일 때 각 영역의 최소 크기(%). 기본 10. */
  minSize?: number;
  /** 그룹 자체가 차지할 비율(자식 비율은 각 ResultArea 의 flex). ResultAreaProps.flex 와 동일 규칙. */
  flex?: number | CSSProperties['flex'];
  className?: string;
  style?: CSSProperties;
};

/** ResultArea 내부에서 그리드 ref 를 노출해야 할 때 쓰는 헬퍼 타입(선택). */
export type ResultAreaGridRef<T = unknown> = RefObject<T | undefined>;
