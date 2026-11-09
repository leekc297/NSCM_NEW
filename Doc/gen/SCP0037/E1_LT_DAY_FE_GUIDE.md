# SCP0037 Operation LT — FE 보완 가이드 (DB MODE · 직접 수정 안 함) · 2026-11-07

## 1. E1 LT(Day) 최대 100 초과 입력 허용 (CheckList v16 조치필요 V-eed95e79)
- 실측(E2E 11-07 01:26): 신규행 LT_DAY '1.5'→'' OK · 'ab'→'' OK · '0'→'' OK · **'101' → '101' NG**(최대 100 초과가 셀에 남음)
- AS-IS: `SCP0037_OperationLT.cs:242` `SetReNumerCellType(siMain, LT_DAY, 1, 0, 100)` = NumberCellType Min 1 · DecimalPlaces 0 · **Max 100** (SpreadInfo.cs:13772-13856) — 범위 밖 입력 거부
- TO-BE 위치: `nscm-fe/features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx:42-53`
  - 현재
    ```ts
    const isValidLtDay = (raw: unknown): boolean => {
      const text = s(raw).trim();
      if (text === '') return true;
      const n = Number(text);
      return Number.isInteger(n) && n > 0;
    };
    ```
  - 변경(최대 100 추가 — 주석의 AS-IS 재현 범위와 일치)
    ```ts
    const LT_DAY_MAX = 100; // AS-IS SetReNumerCellType(siMain, LT_DAY, 1, 0, 100) 의 Max
    const isValidLtDay = (raw: unknown): boolean => {
      const text = s(raw).trim();
      if (text === '') return true;
      const n = Number(text);
      return Number.isInteger(n) && n > 0 && n <= LT_DAY_MAX;
    };
    ```
  - 이유: 주석(42-46행)은 `(1, 0, 100)` 재현을 선언했지만 상한 검사가 빠져 있다. 거부 시 동작(MSG00699 알림 후 편집 전 값 복원)은 기존 경로 그대로.
- 검증: 신규행 LT_DAY 에 101 입력 → 알림 후 이전 값 복원 · 100 입력 → 허용 · CheckList E1 행(V-eed95e79) 재측정 PASS. DB 메타(SHEET_COLUMNS LT_DAY)에는 최소/최대 칸이 없어 DB 로는 해결 불가.

## 2. F5 기존행 Delete (V-85ec81e0) — 결함 아님(검사기 T140 수정)
- AS-IS `DeleteButton` 은 `action == CAppSetting.FlagI` 일 때만 `siMain.Delete()` (.cs:294-296) = 기존행 무동작 · TO-BE `OperationLT.tsx:136` 도 INSERT 행만 삭제 → 동일. 'M' 은 앞선 LT_DAY 편집 상태.
