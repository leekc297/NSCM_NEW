"""[E20261019-000071] 치환 정의 단일 원천 (사내 적용본 대조 · 클라우드 패키지 생성기 공용)

적용: HEAD 시작 ~ TAIL 끝 구간을 OPEN/CLOSE 로 감싸고, 구간 안의 '/*' → '\\*' , '*/' → '*\\' (블록주석 중첩 불가 PLS-00103 회피)
원복: OPEN~CLOSE 사이를 역치환하고 OPEN/CLOSE 제거
"""
MARK = "E20261019-000071"
MARK_N = 2

HEAD = (
    "    ------------------------------------------------------------------------------------------\n"
    "    -- [PJ2024-50611] 소형 매출 프로세스 개선\n"
    "    ------------------------------------------------------------------------------------------\n"
    "    IF p_division_id = '40' THEN\n"
)
TAIL = (
    "            UPDATE SET A.QTY = A.QTY * B.RATIO--(B.QTY / B.SUM_QTY)-- 2025.01.23 0 나누기 오류 수정\n"
    "            ;\n"
    "        END IF;\n"
    "    END IF;\n"
)
OPEN = (
    "    --[E20261019-000071]_Sales Plan Waterfall 데이터 RTF 중복 현상 (START)\n"
    "    -- 불필요한 로직으로 주석처리한다.\n"
    "    -- (블록 내 NO_PARALLEL 힌트는 블록주석 중첩 불가(PLS-00103)로 역슬래시 표기로 바꿈)\n"
    "    /*\n"
)
CLOSE = (
    "    */\n"
    "    --[E20261019-000071]_Sales Plan Waterfall 데이터 RTF 중복 현상(END)\n"
)


def apply_ops(src: str) -> str:
    assert MARK not in src, "이미 적용"
    assert src.count(HEAD) == 1 and src.count(TAIL) == 1
    s = src.index(HEAD); e = src.index(TAIL) + len(TAIL)
    assert s < e
    blk = src[s:e]
    assert "\\*" not in blk and "*\\" not in blk
    blk = blk.replace("/*", "\\*").replace("*/", "*\\")
    return src[:s] + OPEN + blk + CLOSE + src[e:]


def rollback_ops(src: str) -> str:
    assert src.count(OPEN) == 1 and src.count(CLOSE) == 1
    s = src.index(OPEN); e = src.index(CLOSE)
    blk = src[s + len(OPEN):e].replace("\\*", "/*").replace("*\\", "*/")
    return src[:s] + blk + src[e + len(CLOSE):]
