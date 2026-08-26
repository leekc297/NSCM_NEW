/**
 * guard-offline.mjs — 루트 `pnpm run type-check` / `pnpm lint` 오실행 차단 (사용자 지시 2026-08-23).
 *
 * ## 왜 막나
 * 전역 pnpm(11.x)과 저장소 요구 버전(`packageManager: pnpm@10.28.2`)이 달라, pnpm 이 요구 버전을
 * **프로젝트 `.npmrc` 의 사내 넥서스(http://10.94.57.6:8081)** 에서 내려받으려 한다.
 * 사외망에서는 여기서 응답 없이 멈춘다 — 실수로 한 번 실행하면 몇 분을 버린다.
 *
 * ## 대신 쓰는 것
 *   powershell -File _artifacts\tools\fe-check.ps1 type-check
 * 이 래퍼는 요구 버전과 같은 pnpm 을 저장소 밖에서 PATH 앞에 세워 자동 전환 자체를 없앤다(네트워크 0).
 *
 * ## 사내망에서 종전대로 돌리려면
 *   pnpm run type-check:online   /   pnpm run lint:online
 */
const task = process.argv[2] ?? 'type-check';
const RED = '[31m';
const YELLOW = '[33m';
const CYAN = '[36m';
const OFF = '[0m';

const line = '='.repeat(78);
process.stderr.write(
  `\n${RED}${line}\n` +
    `⛔  pnpm run ${task} 은 이 환경에서 막혀 있습니다 (사외망 넥서스 미도달).\n` +
    `${line}${OFF}\n\n` +
    `${YELLOW}이유${OFF}\n` +
    `  전역 pnpm 과 저장소 요구 버전(pnpm@10.28.2)이 달라, pnpm 이 요구 버전을\n` +
    `  사내 넥서스(http://10.94.57.6:8081)에서 내려받으려다 응답 없이 멈춥니다.\n\n` +
    `${CYAN}대신 이렇게 실행하세요${OFF}\n` +
    `  powershell -File _artifacts\\_tools\\fe-check.ps1 ${task}\n` +
    `  powershell -File _artifacts\\_tools\\fe-check.ps1 ${task} -Filter @demand\n\n` +
    `${YELLOW}사내망에서 종전 방식이 필요하면${OFF}\n` +
    `  pnpm run ${task}:online\n\n`
);
process.exit(1);
