// 세션(브라우저 메모리) 범위 "최근에 사용한 색" 스토어.
//   모든 ColorPickerButton 인스턴스가 공유. 페이지 새로고침 시 초기화(영구 저장 아님).
const MAX_RECENT = 10;

let recent: string[] = [];
const listeners = new Set<() => void>();

export const getRecentColors = (): string[] => recent;

export const pushRecentColor = (hex: string): void => {
  if (!hex) return;
  recent = [hex, ...recent.filter(c => c !== hex)].slice(0, MAX_RECENT);
  listeners.forEach(l => l());
};

export const subscribeRecent = (cb: () => void): (() => void) => {
  listeners.add(cb);
  return () => {
    listeners.delete(cb);
  };
};
