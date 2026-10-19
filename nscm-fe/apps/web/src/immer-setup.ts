import { enableMapSet } from 'immer';

// immer 11 은 Map/Set 를 draft 하려면 플러그인을 명시적으로 켜야 한다. 전역 스토어
//   (useMotherStore 의 registory 가 Map)나 Set/Map 을 담는 스토어의 set() 가 그 Map/Set 를
//   draft 하는 순간 필요하며, 미호출 시 그 액션이 통째로
//   "[Immer] The plugin for 'MapSet' has not been loaded" 예외를 던진다.
//   어떤 스토어의 produce 보다도 먼저 켜져야 하므로 진입점 최상단에서 부른다(dayjs-setup 과 동일 패턴).
enableMapSet();
