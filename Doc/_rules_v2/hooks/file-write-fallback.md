# Hook — file-write-fallback (Write 실패 시 우회경로 의무)

> **트리거**: `Write` tool 호출 시 `Error writing file` 또는 `File has not been read yet` 에러 발생
>
> **사유**: Claude Code 의 안전 보호 (기존 파일 덮어쓰기 방지 — 사용자 작업 손실 위험)
>
> **목적**: 사용자 메시지 (2026-06-04) — "보안 문제로 Error writing file 이 발생하는 경우에는 우회경로를 통해서 필요한 저장 처리를 진행하도록 rule 보완"

---

## §0 트리거 패턴

### §0.1 자주 발생 사고

| 에러 메시지 | 사유 | 우회 방법 |
|---|---|---|
| `File has not been read yet. Read it first before writing to it.` | 기존 파일 존재 — Claude Code 안전 보호 | **(A) Read 먼저** → 내용 파악 → 의도 결정 |
| `Error writing file: permission denied` | OS / Antivirus 권한 | Bash `mv` / `cp` 또는 `python -c` 우회 |
| `Error writing file: disk full` | 디스크 공간 부족 | 사용자에게 보고 |
| `tool_use_error` (기타) | 일시적 캐시 / lock | Bash 우회 |

### §0.2 우선순위 (의무 결정)

**1. 신규 파일 작성 의도 + 기존 파일 발견 시** (가장 흔한 사고):
- 자동 덮어쓰기 절대 금지 (사용자 작업 손실 위험)
- 의무: (A) **Read 먼저** → 기존 내용 확인
- 결정:
  - 기존 파일이 룰 v2 표준과 **동일** → 그대로 사용 (Write 시도 안 함)
  - 기존 파일이 룰 v2 표준과 **다름** → Edit 으로 부분 수정 또는 사용자 확인 후 Write
  - 기존 파일이 **사용자 작업물** (이미 잘 동작) → 그대로 보존 + 룰 v2 cross-check 보고

**2. 기존 파일 수정 의도 + Write 실패**:
- Edit tool 사용 권장 (diff 만 적용)
- Edit 도 실패 시 — 사용자 확인 후 Write 사용

**3. OS / 권한 / 디스크 문제**:
- Bash 우회 (`mv` / `cp` / `python -c "open(f, 'w').write(content)"`)
- 또는 사용자에게 보고

---

## §1 우회경로 인벤토리

### §1.1 우선 — `Read` + `Edit` (안전한 fix)

```
1. Read tool 로 기존 파일 내용 확인
2. 룰 v2 표준과 비교 → 차이점 식별
3. Edit tool 로 부분 수정 (전체 덮어쓰기 X)
4. 결과 검증
```

→ Write 가 막혀도 **Edit 으로 부분 수정** 가능.

### §1.2 Bash mv / cp (다른 경로)

```bash
# 신규 파일을 임시 위치에 작성 후 mv
mkdir -p /tmp/safe-write
cat > /tmp/safe-write/temp.tsx << 'EOF'
... content ...
EOF
mv /tmp/safe-write/temp.tsx "$TARGET_PATH"

# 또는 cp (원본 보존)
cp /tmp/safe-write/temp.tsx "$TARGET_PATH"
```

→ Bash 의 권한 패턴 다름 — Write 실패 시도 cp 성공 가능.

### §1.3 Python 우회 (encoding 문제 시)

```bash
python -c "
content = '''
... 한글 + UTF-8 ...
'''
with open('$TARGET_PATH', 'w', encoding='utf-8') as f:
    f.write(content)
"
```

→ PowerShell 의 UTF-16 LE 기본 문제 시 (메모리 `feedback_powershell_utf8.md`).

### §1.4 IDE / 사용자 직접 작성

마지막 수단:
1. 모든 자동 작성 실패 → 사용자에게 명시 보고
2. 사용자가 직접 작성하도록 안내 (파일 경로 + 내용 출력)

---

## §2 우회 전 자기 점검

| # | 점검 항목 | 조치 |
|---:|---|---|
| 1 | **기존 파일 존재 여부** | `ls` 또는 Bash `test -f` 로 확인 |
| 2 | 기존 파일 내용 (이미 잘 동작?) | Read 로 확인 — **무작정 덮어쓰기 절대 금지** |
| 3 | 사용자 작업물 가능성 | git log 또는 사용자에게 확인 |
| 4 | 룰 v2 표준과의 일치 | cross-check 후 결정 |

→ **신규 작성 의도** 라도 **기존 파일이 잘 동작** 하면 **덮어쓰기 금지**. anti-simplification 의 반대편 (오버엔지니어링) 도 사고.

---

## §3 의사 결정 트리

```
Write tool 호출
└─ 에러 발생?
   ├─ No → 정상 진행
   └─ Yes
      ├─ "File has not been read yet"
      │  ├─ 1. Read tool 로 기존 파일 확인 (의무)
      │  ├─ 2. 기존 vs 의도한 내용 비교
      │  └─ 결정:
      │     ├─ (동일) → Write 안 함, 그대로 사용
      │     ├─ (부분 다름) → Edit tool 로 부분 수정
      │     ├─ (전면 재작성 필요) → 사용자 확인 후 Write
      │     └─ (사용자 작업물) → 보존 + cross-check 보고
      ├─ "permission denied"
      │  └─ Bash mv / cp 우회
      ├─ "disk full" / "encoding"
      │  └─ Bash python 우회 또는 사용자 보고
      └─ (기타)
         └─ Bash 우회 또는 사용자 보고
```

---

## §4 신규 화면 작업 시 권장 워크플로우

> 신규 화면 작성 (예: DMF0008 PoC) 시 의무 자기 점검:

```bash
# 1. 신규 화면 폴더 존재 여부 (사용자 작업물 가능성)
test -d "nscm-fe/features/{domain}/src/pages/{kebab-name}" && {
    echo "⚠️ 기존 폴더 존재 — Read 의무"
    # 모든 파일 list + Read 후 cross-check
    ls -la "nscm-fe/features/{domain}/src/pages/{kebab-name}"
}

# 2. 기존 파일 list
find "nscm-fe/features/{domain}/src/pages/{kebab-name}" -type f
```

→ **mkdir 또는 폴더 작업 직전 의무**.

---

## §5 적용 룰 cross-ref

| 항목 | 룰 / 메모리 |
|---|---|
| anti-simplification 의 반대편 (오버엔지니어링) | `anti-simplification.md` + Phase 6 PoC 의 룰 11 정정 |
| 사용자 작업물 보존 의무 | (Git 정책) |
| PowerShell UTF-8 인코딩 | 메모리 `feedback_powershell_utf8.md` |

---

## §6 메모리 트리거 신규 (메모리 통합 권장)

**메모리 신규 작성 권장** (사용자 트리거):
- `feedback_file_write_fallback.md` — Write 실패 시 우회경로 (Read → Edit / Bash / Python)
- 트리거: `"File has not been read yet"` / `"Error writing file"` 발생 시 자동 적용

---

## §7 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 사용자 요청 — Phase 7 PoC (DMF0008) 중 기존 파일 존재로 Write 실패 → 룰 보완 |
