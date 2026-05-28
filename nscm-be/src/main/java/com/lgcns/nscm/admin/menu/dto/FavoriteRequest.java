package com.lgcns.nscm.admin.menu.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FavoriteRequest {
	private String mnuId;
	private boolean favorite;
}
