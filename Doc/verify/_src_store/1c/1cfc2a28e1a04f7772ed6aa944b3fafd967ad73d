// 초기화 함수들을 담을 집합 (중복 등록 방지)
const resetters = new Set<() => void>();

// 스토어가 자신을 등록할 때 사용할 함수
export const registerStore = (resetFn: () => void) => {
  resetters.add(resetFn);
};

// 모든 스토어를 한 번에 리셋하는 함수
export const resetAllStores = () => {
  resetters.forEach(reset => reset());
};
