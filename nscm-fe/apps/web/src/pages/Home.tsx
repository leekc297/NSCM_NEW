import { HomeNscm } from './HomeNscm';
import { HomeSpms } from './HomeSpms';

/**
 * 시스템별 Home 선택.
 * VITE_SYSTEM_CD 는 Vite 빌드타임 상수 — NSCM/SPMS 배포가 각각 자기 .env 값으로 빌드된다.
 * 런타임 분기가 아니라 번들 단위로 고정된다.
 */
export const HomePage = () =>
  import.meta.env.VITE_SYSTEM_CD === 'SPMS' ? <HomeSpms /> : <HomeNscm />;
