// 단일 리스트 D&D 재정렬 순수 유틸 (ColumnLayoutList 전용).
export const computeReorder = (keys: string[], dragKey: string, targetKey: string): string[] => {
  const from = keys.indexOf(dragKey);
  const to = keys.indexOf(targetKey);
  if (from < 0 || to < 0 || from === to) return keys;
  const next = [...keys];
  next.splice(from, 1);
  next.splice(to, 0, dragKey);
  return next;
};
