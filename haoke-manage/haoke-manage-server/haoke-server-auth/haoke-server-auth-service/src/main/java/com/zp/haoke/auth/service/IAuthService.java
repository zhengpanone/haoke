package com.zp.haoke.auth.service;

import com.zp.haoke.auth.domain.dto.LoginDTO;
import com.zp.haoke.auth.domain.vo.LoginVO;

public interface IAuthService {

    LoginVO login(LoginDTO request);

    void logout(String token);

    LoginVO refreshToken(String token);
}
