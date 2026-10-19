// 월/주 SUM 헤더 더블클릭 드릴다운 — AS-IS SpreadInfo.SetDblClickColumnShowHide(GSCM.Windows.Forms/Class/SpreadInfo.cs:10838) 이식.
//   화면 쪽 chkAll 가드(.cs:3771)는 TO-BE 가 chkAll 을 항상 true 로 고정(2026-10-07)해 구현하지 않는다.
import { type DynColKind, dynColKindOf } from './shipment-plan-fg.editLock';

export interface DynColState {
  binding: string;
  visible: boolean;
}

// dynCols 는 그리드 표시 순서의 D_/W_/M_ 컬럼이다. 반환값은 바인딩별로 새로 강제할 visible 값이다.
//   M_ 헤더: 다음 M_ 직전까지 W_ 는 뒤집고, 보이는 D_ 만 숨긴다(숨겨진 D_ 는 건드리지 않는다).
//   W_ 헤더: 다음 W_/M_ 직전까지 D_ 를 뒤집는다.
export const computeDrillToggles = (headerBinding: string, dynCols: DynColState[]): Map<string, boolean> => {
  const result = new Map<string, boolean>();
  const headerKind: DynColKind | null = dynColKindOf(headerBinding);
  if (headerKind !== 'M' && headerKind !== 'W') return result;
  const start = dynCols.findIndex(c => c.binding === headerBinding);
  if (start < 0) return result;

  for (let i = start + 1; i < dynCols.length; i += 1) {
    const { binding, visible } = dynCols[i];
    const kind = dynColKindOf(binding);
    if (headerKind === 'M') {
      if (kind === 'M') break;
      if (kind === 'W') result.set(binding, !visible);
      else if (kind === 'D' && visible) result.set(binding, false);
    } else {
      if (kind === 'W' || kind === 'M') break;
      if (kind === 'D') result.set(binding, !visible);
    }
  }
  return result;
};
