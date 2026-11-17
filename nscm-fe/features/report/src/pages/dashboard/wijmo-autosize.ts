import type { Control } from '@mescius/wijmo';

// Wijmo 컨트롤(FlexChart/FlexGrid)은 생성 시점의 host 크기로 한 번 레이아웃된다.
//   그 뒤 컨테이너가 바뀌면(브라우저 줌·창 리사이즈·그리드 행 높이 재계산) 스스로 다시 맞추지
//   않아 SVG 가 옛 크기로 남고 overflow:hidden 패널에서 잘린다. host 를 ResizeObserver 로 관찰해
//   크기가 바뀔 때마다 invalidate() 로 재-fit 시키고, cleanup 에서 관찰 해제 + 컨트롤 dispose.
export const attachAutoSize = (control: Control, host: HTMLElement): (() => void) => {
  const observer = new ResizeObserver(() => control.invalidate());
  observer.observe(host);
  return () => {
    observer.disconnect();
    control.dispose();
  };
};
