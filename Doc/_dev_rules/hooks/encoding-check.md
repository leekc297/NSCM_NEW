# Hook — Encoding Check (UTF-8 보장)

> ⭐ **트리거**: 한글 포함 파일 작성/수정, 터미널 한글 출력 깨짐, VSCode 한글 mojibake.
> **목적**: 파일 인코딩 / 터미널 인코딩 / 외부 도구 인코딩 일관성 보장 (UTF-8 통일).

작성: 2026-05-28 (VSCode 한글 깨짐 재발 사고 반영)
관련 룰: `21_TROUBLESHOOTING.md` (기존 PowerShell 한글 항목 보강)
참고 메모리: `feedback_powershell_utf8.md`

---

## §1. 필수 설정 3계층

| 계층 | 파일 | 핵심 항목 |
|---|---|---|
| **VSCode 에디터** | `.vscode/settings.json` | `files.encoding: utf8`, file type 별 분기, `files.autoGuessEncoding: true` |
| **공통 (모든 editor)** | `.editorconfig` | `charset = utf-8`, file type 별 charset / EOL |
| **터미널 (PowerShell)** | `.vscode/settings.json` 의 terminal profile | `chcp 65001` + `[Console]::OutputEncoding = UTF8` + `$OutputEncoding = UTF8` (3중) |

### 표준 `.vscode/settings.json` (root)

```jsonc
{
  "files.encoding": "utf8",
  "files.autoGuessEncoding": true,
  "[sql]": { "files.encoding": "utf8" },
  "[json]": { "files.encoding": "utf8" },
  "[markdown]": { "files.encoding": "utf8" },
  "[typescript]": { "files.encoding": "utf8" },
  "[typescriptreact]": { "files.encoding": "utf8" },
  "[xml]": { "files.encoding": "utf8" },
  "[java]": { "files.encoding": "utf8" },
  "[yaml]": { "files.encoding": "utf8" },
  "[powershell]": { "files.encoding": "utf8bom" },   // ⚠ PowerShell 만 BOM 필수
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "terminal.integrated.profiles.windows": {
    "PowerShell": {
      "source": "PowerShell",
      "args": [
        "-NoExit",
        "-Command",
        "chcp 65001 | Out-Null; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = [System.Text.Encoding]::UTF8"
      ]
    }
  }
}
```

### 표준 `.editorconfig`

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true

[*.{sql,SQL}]
charset = utf-8
end_of_line = crlf

[*.{ps1,psm1,psd1}]
charset = utf-8-bom
end_of_line = crlf

[*.{bat,cmd}]
end_of_line = crlf
```

---

## §2. 검증 명령

### Step 1. VSCode settings 점검

```bash
grep -E "files\.encoding|charset" C:/Projects/NSCM/.vscode/settings.json
grep -E "files\.encoding|charset" C:/Projects/NSCM/nscm-fe/.vscode/settings.json
```

`files.encoding: utf8` 또는 `utf8bom` 출력 없으면 ❌ 누락.

### Step 2. 특정 파일 인코딩 감지

```bash
# Git Bash 의 file 명령
file -i C:/Projects/NSCM/_artifacts/dmf0007-customerpsi-seed.sql

# 기대: charset=utf-8
# 위험: charset=iso-8859-1 (= ASCII만), 또는 charset=unknown-8bit (= cp949 의심)
```

### Step 3. PowerShell 파일 읽기 (메모리 룰)

```powershell
# 한글 포함 파일은 반드시 -Encoding UTF8 명시
Get-Content -Path "<file>" -Encoding UTF8
```

`-Encoding UTF8` 없으면 cp949 로 읽혀 mojibake 발생.

---

## §3. 작성 시 의무

| 작성 도구 | 인코딩 의무 |
|---|---|
| Claude `Write` / `Edit` | 기본 UTF-8 no BOM ✓ (자동) |
| PowerShell `Out-File` / `Set-Content` | **`-Encoding utf8` 명시 필수** (없으면 UTF-16 LE BOM 으로 저장됨) |
| `cat << EOF > file` (Git Bash) | 기본 UTF-8 ✓ |
| VSCode 수동 저장 | settings 의 `files.encoding` 적용 (위 §1 설정 시 UTF-8) |

---

## §4. 사고 시 복구

### 깨진 파일이 표시만 잘못된 경우

1. VSCode 우하단 인코딩 표시 클릭 → `Reopen with Encoding` → 원본 인코딩 (cp949 / EUC-KR / Windows-949) 선택
2. 정상 표시 확인 후 → `Save with Encoding` → **UTF-8** 선택하여 영구 변환

### 깨진 채로 저장된 경우 (mojibake 영구화)

- `git status` → `git checkout -- <file>` 로 마지막 정상 커밋으로 복구
- 또는 백업 / 이전 버전에서 복원
- 새로 작성

---

## §5. 자동 점검 (TODO)

`pre-write.md` / `post-write.md` 에 다음 단계 통합:

```bash
# 한글 포함 파일 작성 후 file -i 로 charset=utf-8 확인
file -i "$WRITTEN_FILE" | grep -q "charset=utf-8" || echo "❌ ENCODING NOT UTF-8: $WRITTEN_FILE"
```

---

## §6. 변경 이력

- 2026-05-28: 작성. `.vscode/settings.json` 의 `files.encoding` 누락이 한글 깨짐 재발 주원인이었음. file type 별 분기 + `.editorconfig` 추가로 일관성 보장.
