# -*- coding: utf-8 -*-
# SCP0104 사용자의견 DB 보완 2차 (2026-11-17) — P_SCP0104_SPLIT_CLOB 빈 값 · 끝 구분자 처리
# AS-IS dbo.String_Split 실측(11-17 09:5x AS-IS 개발 DB): '' → 1행, 'a^' → 2행, 'a^^b' → 3행.
# TO-BE 는 '' → 0행, 'a^' → 1행이라 빈 칸(Nickname·Lane Number 등)이 있는 행이 토큰 조인에서 빠져 저장되지 않았다(결과는 'S').
TYPE = 'PACKAGE BODY'


def M(t):
    return '/* 2026.11.17 SCP0104 보완: ' + t + ' */'


HUNKS = [
    ("    IF V_LEN = 0 THEN\n        RETURN;\n    END IF;",
     "    IF V_LEN = 0 THEN\n"
     "        " + M("빈 값도 1행(AS-IS dbo.String_Split 등가)") + "\n"
     "        INSERT INTO GT_SCP0104_ASGN_TOKEN ( SLOT_NO, NR, TOKEN ) VALUES ( P_SLOT_NO, 1, NULL );\n"
     "        RETURN;\n"
     "    END IF;",
     1),
    ("        IF V_FROM > V_LEN THEN\n            EXIT;\n        END IF;",
     "        IF V_FROM > V_LEN THEN\n"
     "            " + M("끝 구분자 뒤 빈 토큰 1행(AS-IS dbo.String_Split 등가)") + "\n"
     "            INSERT INTO GT_SCP0104_ASGN_TOKEN ( SLOT_NO, NR, TOKEN ) VALUES ( P_SLOT_NO, V_NR + 1, NULL );\n"
     "            EXIT;\n"
     "        END IF;",
     1),
]
TESTS = []
