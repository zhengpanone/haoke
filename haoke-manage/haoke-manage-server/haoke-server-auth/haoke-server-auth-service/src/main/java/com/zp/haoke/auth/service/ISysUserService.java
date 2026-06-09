package com.zp.haoke.auth.service;

import com.zp.haoke.auth.domain.dto.ChangePasswordDTO;
import com.zp.haoke.auth.domain.dto.CreateUserDTO;
import com.zp.haoke.auth.domain.dto.PhoneBindDTO;
import com.zp.haoke.auth.domain.dto.PhoneCodeDTO;
import com.zp.haoke.auth.domain.dto.UpdateUserDTO;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.domain.vo.UserVO;
import jakarta.validation.Valid;

public interface ISysUserService {

    SysUserPO findByUsername(String username);

    SysUserPO findById(String id);

    UserVO createUser(CreateUserDTO request);

    UserVO updateUser(Long id, @Valid UpdateUserDTO userDTO);

    UserVO updateUser(String id, @Valid UpdateUserDTO userDTO);

    void changePassword(String userId, @Valid ChangePasswordDTO request);

    String sendPhoneCode(@Valid PhoneCodeDTO request);

    UserVO bindPhone(String userId, @Valid PhoneBindDTO request);

    UserVO unbindPhone(String userId);

    void deleteUser(Long id);
}
