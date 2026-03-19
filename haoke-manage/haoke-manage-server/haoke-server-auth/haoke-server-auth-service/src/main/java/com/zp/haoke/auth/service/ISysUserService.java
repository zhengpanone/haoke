package com.zp.haoke.auth.service;

import com.zp.haoke.auth.domain.po.SysUserPO;

public interface ISysUserService {

    SysUserPO findByUsername(String username);

    SysUserPO findById(String id);

    SysUserPO createUser(String username, String password, String email);
}
