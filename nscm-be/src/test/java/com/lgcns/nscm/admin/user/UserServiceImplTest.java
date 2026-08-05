package com.lgcns.nscm.admin.user;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.fail;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.lgcns.nscm.admin.auth.AuthService;

@SpringBootTest
class UserServiceImplTest {

    @Autowired
    private UserService userService;
    @Autowired
    private AuthService authService;

    @Test
    @DisplayName("DB 연동: 실제 유저 정보 조회 및 UserEntity 매핑 확인")
    void retrieveUserFromDbTest() throws Exception {
        // given
        String existingUserId = "minyonglee1";

        // when
        User user = userService.retrieveUser(existingUserId);

        // then
        if (user != null) {
            System.out.println("조회된 유저 아이디: " + user.getUserId());
            System.out.println("조회된 유저 이름: " + user.getUserNm());

            assertEquals(existingUserId, user.getUserId());
        } else {
            fail("DB에 테스트용 유저가 존재하지 않습니다. ID를 확인하세요.");
        }
    }

    @Test
    @DisplayName("DB 연동: 미등록 사용자 조회 시 예외 없이 null 을 반환한다")
    void retrieveUserReturnsNullWhenNotFound() throws Exception {
        // given: SCM_ADM_USER_M / SCM_MST_SSO_USER_INFO 어디에도 없는 사번
        String unknownUserId = "__NO_SUCH_USER_9999__";

        // when
        User user = userService.retrieveUser(unknownUserId);

        // then
        assertNull(user);
    }

    @Test
    @DisplayName("DB 연동: 특정 메뉴와 액션에 대한 권한 체크 쿼리 실행")
    void checkAuthorizationFromDbTest() throws Exception {
        // given
        String userId = "minyonglee1";
        String mnuId = "DMF0082";
        String shtNm = "";
        String mnuBtnCd = "SEARCH";

        // when & then
        assertDoesNotThrow(() -> {
            authService.checkMenuBtnAuth(userId, mnuId, shtNm, mnuBtnCd);
        }, "권한 체크 중 DB 에러나 로직 에러가 발생하면 안 됩니다.");
    }
}
