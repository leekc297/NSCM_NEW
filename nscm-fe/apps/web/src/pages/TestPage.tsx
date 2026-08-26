// 개발용 테스트 페이지 — 홈 화면에서 ?test=true 로 진입하면 대시보드 대신 이 컴포넌트가 렌더된다.
//   앱 셸(헤더·사이드바·MDI) 안에서 열리므로 전역 토스트/알림을 그대로 쓴다(Templates embedded).
//   메뉴/DB 를 건드리지 않고, 필요에 따라 이 파일(또는 Templates)의 소스를 고쳐 즉석 테스트한다.
//
// 진입: /home?test=true (또는 /view/home?test=true). 해제: 쿼리 제거 후 새로고침.
import { Templates } from './Templates';

export const TestPage = () => <Templates embedded />;
