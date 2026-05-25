package com.zp.haoke.auth.service;

import com.zp.haoke.auth.domain.dto.LoginDTO;
import com.zp.haoke.auth.domain.vo.LoginVO;
import com.zp.haoke.auth.domain.vo.UserInfoVO;

public interface IAuthService {

    LoginVO login(LoginDTO request);

    void logout(String token);

    LoginVO refreshToken(String token);

    UserInfoVO userInfo(String token);
}
