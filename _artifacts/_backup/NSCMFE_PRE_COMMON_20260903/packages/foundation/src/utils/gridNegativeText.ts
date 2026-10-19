/**
 * 음수 셀 = 빨간 글자 — 그리드 공통 규약 (REQ:CHAT-20260820-6).
 *
 * mkt-fcst / demand-manager / contribute-view / sales-reports / etc-sales-reports 가 각자
 * 같은 코드를 로컬에 복사해 두고 있던 것을 한곳으로 모은 정본이다.
 *
 * 왜 공용 DataGrid 가 아니라 헬퍼인가:
 *   DataGrid 는 grid 생성 시점에 formatItem 핸들러를 붙이고, 화면 그리드는 그 뒤(useEffect)에
 *   붙는다. Wijmo 는 등록 순서대로 실행하므로 화면 핸들러가 항상 나중에 돈다 — 개인화 Text Color
 *   처럼 화면이 color 를 직접 쓰거나 지우는 순간 DataGrid 가 칠한 음수색이 조용히 사라진다.
 *   게다가 "음수 빨강 vs 개인화 Text Color" 우선순위는 화면마다 판단이 갈린다.
 *   그래서 색·해제 규칙만 여기서 단일화하고, 호출 위치(우선순위)는 화면 formatItem 이 정한다.
 */

// 음수 값 글자색 — 전 화면 동일 톤.
export const NEGATIVE_TEXT_COLOR = '#c0392b';

/** 셀 표시값 → 숫자. 콤마 제거, 숫자가 아니면 0 (문자/코드 컬럼은 자연히 음수 판정에서 빠진다). */
export const toGridNumber = (value: unknown): number => {
  if (value == null || value === '') return 0;
  const n =
    typeof value === 'number'
      ? value
      : Number(
          (typeof value === 'string' ? value : String(value as string | number)).replace(/,/g, '')
        );
  return Number.isFinite(n) ? n : 0;
};

/**
 * 음수면 빨간 글자, 아니면 원복.
 *
 * 필수: 음수가 아닐 때 반드시 지운다 — Wijmo 는 셀 DOM 을 재사용하므로 칠하기만 하면
 * 스크롤 뒤 엉뚱한 셀에 색이 남는다.
 * 필수: important 로 넣는다 — 편집/잠금 셀 클래스(.wj-cell-editable / .wj-cell-non-editable)가
 * color 를 !important 로 잡고 있어 일반 인라인 색은 밀린다.
 */
export const paintNegativeText = (cell: HTMLElement, value: number): void => {
  if (value < 0) cell.style.setProperty('color', NEGATIVE_TEXT_COLOR, 'important');
  else cell.style.removeProperty('color');
};
