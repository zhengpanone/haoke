package com.zp.haoke.auth.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.enums.UserErrorCode;
import com.zp.haoke.auth.mapper.SysUserMapper;
import com.zp.haoke.auth.service.ISysUserService;
import com.zp.haoke.framework.core.exception.BizException;
import com.zp.haoke.framework.core.enums.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class SysUserServiceImpl implements ISysUserService, UserDetailsService {

    private final SysUserMapper sysUserMapper;

    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        SysUserPO user = sysUserMapper.selectList(
                Wrappers.<SysUserPO>lambdaQuery()
                        .eq(SysUserPO::getUsername, username)
                        .last("LIMIT 1")
        ).stream().findFirst().orElse(null);

        if (user == null) {
            throw new UsernameNotFoundException("用户不存在");
        }

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities("ROLE_USER") // 先写死，后面再扩展
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }

    public SysUserPO findByUsername(String username) {
        return Optional.ofNullable(
                sysUserMapper.selectOne(
                        Wrappers.<SysUserPO>lambdaQuery()
                                .eq(SysUserPO::getUsername, username)
                )
        ).orElseThrow(() -> new BizException(UserErrorCode.USER_NOT_FOUND));
    }


    public SysUserPO findById(String id) {
        return Optional.ofNullable(sysUserMapper.selectById(id))
                .orElseThrow(() -> new RuntimeException("用户不存在"));
    }

    public SysUserPO createUser(String username, String password, String email) {
        SysUserPO user = new SysUserPO();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        sysUserMapper.insert(user);
        return user;
    }
}
