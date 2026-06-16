package com.zp.haoke.auth.service;

import com.zp.haoke.auth.domain.dto.ChangePasswordDTO;
import com.zp.haoke.auth.domain.dto.CreateUserDTO;
import com.zp.haoke.auth.domain.dto.PhoneBindDTO;
import com.zp.haoke.auth.domain.dto.PhoneCodeDTO;
import com.zp.haoke.auth.domain.dto.UpdateUserDTO;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.domain.vo.UserVO;
import com.zp.haoke.framework.core.domain.response.PageVO;
import jakarta.validation.Valid;

public interface ISysUserService {

    SysUserPO findByUsername(String username);

    SysUserPO findById(String id);

    UserVO getUser(Long id);

    PageVO<UserVO> queryUsers(int page, int size);

    UserVO updateUserStatus(Long id, String status);

    UserVO createUser(CreateUserDTO request);

    UserVO updateUser(Long id, @Valid UpdateUserDTO userDTO);

    UserVO updateUser(String id, @Valid UpdateUserDTO userDTO);

    void changePassword(String userId, @Valid ChangePasswordDTO request);

    String sendPhoneCode(@Valid PhoneCodeDTO request);

    UserVO bindPhone(String userId, @Valid PhoneBindDTO request);

    UserVO unbindPhone(String userId);

    void deleteUser(Long id);
}
