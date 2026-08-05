package com.lgcns.nscm.framework.utils;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.security.CustomUserDetails;

public class SecurityUtil {
	public static UserSession getUserSession() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return _getAuthenticationUserSession(authentication);
    }

	public static UserSession getUserSession(Authentication authentication) {
        return _getAuthenticationUserSession(authentication);
	}

	private static UserSession _getAuthenticationUserSession(Authentication authentication) {
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return new UserSession();
        }

        Object principal = authentication.getPrincipal();

        if (principal instanceof CustomUserDetails userDetails) {
            return UserSession.builder()
                    .userId(userDetails.getUserId())
                    .userNm(userDetails.getUserNm())
                    .userEngNm(userDetails.getUserEngNm())
                    .langCd(userDetails.getLangCd())
                    .menus(userDetails.getMenus())
                    .isGuest(userDetails.isGuest())
                    .groups(userDetails.getGroups())
                    .div(userDetails.getDiv())
                    .build();
        }

        return new UserSession();
	}

}
