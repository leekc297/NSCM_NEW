# Hook — Module Duplication Check (`node_modules/node_modules/` 잔존 감지)

> ⭐ **트리거**: Wijmo / React / 기타 라이브러리의 import 변경, `pnpm install` 후 dev 서버 동작 이상.
> **목적**: pnpm 재설치 후 `node_modules/node_modules/` 잔존으로 인한 모듈 인스턴스 분리 (instanceof 실패) 사전 차단.

작성: 2026-05-28 (DMF0007 Wijmo MergeManager null 사고 반영)
관련 룰: `27_WIJMO_PIVOT_AND_MODULE.md §A`, `21_TROUBLESHOOTING.md`

---

## §1. 발동 조건

다음 중 하나라도 해당 시 본 hook 의 검증을 수행:

1. Wijmo (`@mescius/*`) 또는 React 관련 라이브러리 import 변경
2. `class X extends LibraryClass` 패턴 신규/수정
3. 런타임에 `instanceof` 검증 실패 가능성이 있는 setter 호출 (예: `grid.mergeManager`, `chart.itemsSource` 등)
4. `pnpm install` / `pnpm add` / `pnpm update` 실행 후
5. Vite dev 서버에서 module 관련 이상 동작 (HMR 실패, undefined export 등)

---

## §2. 검증 명령

### Step 1. 잔존 디렉토리 검사

```bash
# 잔존 여부 (0건 기대)
ls -d C:/Projects/NSCM/nscm-fe/node_modules/node_modules 2>/dev/null

# .pnpm 중복 확인 (특정 패키지 예시)
ls -d C:/Projects/NSCM/nscm-fe/node_modules/node_modules/.pnpm/@mescius+wijmo.grid* 2>/dev/null
```

**결과 해석**:
- 출력 있음 → ❌ **잔존 확정, 즉시 정리 필요**
- 출력 없음 → ✅ OK

### Step 2. Vite deps 캐시 stale 검사

```bash
# .vite/deps 생성 시각
ls -la C:/Projects/NSCM/nscm-fe/apps/web/node_modules/.vite/deps/ 2>/dev/null | head -3
# 최근 pnpm install 시각과 비교
stat C:/Projects/NSCM/nscm-fe/node_modules/.modules.yaml 2>/dev/null | grep Modify
```

`.vite/deps` 가 `.modules.yaml` 보다 오래되었으면 stale → 정리 필요.

### Step 3. 런타임 진단 (브라우저 DevTools)

```js
// Wijmo grid 사용 화면에서:
const grid = wijmo.Control.getControl(document.querySelector('.wj-flexgrid'));
console.table({
  allowDragging: grid.allowDragging,
  mergeManager_is_null: grid.mergeManager === null,
  mergeManagerClass: grid.mergeManager?.constructor?.name,
});
```

`allowDragging = 0` (handleInitialized 실행됨) AND `mergeManager === null` → module duplication 확정.

---

## §3. 보완 절차 (확정 시)

```bash
# 1) Vite dev 서버 중지 (TaskStop 또는 OS kill)
#    netstat -ano | grep ":3000.*LISTENING"  → PID 확인
#    Stop-Process -Id <PID> -Force

# 2) 잔존 디렉토리 + Vite deps 캐시 삭제
rm -rf C:/Projects/NSCM/nscm-fe/node_modules/node_modules
rm -rf C:/Projects/NSCM/nscm-fe/apps/web/node_modules/.vite

# 3) (선택) node_modules/.cache 도 삭제
rm -rf C:/Projects/NSCM/nscm-fe/node_modules/.cache

# 4) Vite 재기동 (메모리 룰: pnpm dev 금지)
cd C:/Projects/NSCM/nscm-fe/apps/web && ./node_modules/.bin/vite
```

> ⚠️ **pnpm install 은 hook 차단됨** (`block-dev-commands.ps1`). outer `node_modules` 가 정상 상태면 추가 install 불요. lockfile mismatch 의심 시에만 사용자에게 확인.

---

## §4. 자동 검증 통합 (TODO)

`pre-write.md` / `post-write.md` hook 에 다음 단계 추가 권장:

```bash
if [ -d "C:/Projects/NSCM/nscm-fe/node_modules/node_modules" ]; then
  echo "❌ MODULE DUPLICATION: nscm-fe/node_modules/node_modules exists. Run cleanup."
  exit 1
fi
```

---

## §5. 알려진 위반 사례

| 일자 | 사고 | 원인 | 보완 |
|---|---|---|---|
| 2026-05-28 | DMF0007 grid column header 세로 머지 미동작 | May 20 pnpm install 잔존 + May 26 재설치로 outer/inner `.pnpm` 양쪽 `@mescius/wijmo.grid` 존재 → `CustomMergeManager` 의 `MergeManager` 클래스 와 FlexGrid setter 의 `instanceof MergeManager` 클래스 불일치 → setter 가 null 강제 저장 | inner 디렉토리 + `.vite/deps` 삭제, Vite 재기동 |
