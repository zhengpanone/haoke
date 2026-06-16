package com.zp.haoke.auth.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zp.haoke.auth.domain.dto.ChangePasswordDTO;
import com.zp.haoke.auth.domain.convert.SysUserConvert;
import com.zp.haoke.auth.domain.dto.CreateUserDTO;
import com.zp.haoke.auth.domain.dto.PhoneBindDTO;
import com.zp.haoke.auth.domain.dto.PhoneCodeDTO;
import com.zp.haoke.auth.domain.dto.UpdateUserDTO;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.domain.vo.UserVO;
import com.zp.haoke.auth.enums.UserErrorCode;
import com.zp.haoke.auth.mapper.SysUserMapper;
import com.zp.haoke.auth.service.ISysUserService;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.enums.UserStatus;
import com.zp.haoke.framework.core.exception.BizException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@RequiredArgsConstructor
@Service
public class SysUserServiceImpl implements ISysUserService, UserDetailsService {

    private static final String DEV_PHONE_CODE = "123456";

    private final SysUserMapper sysUserMapper;

    private final PasswordEncoder passwordEncoder;

    private final SysUserConvert sysUserConvert;

    private final Map<String, PhoneCodeCache> phoneCodeCache = new ConcurrentHashMap<>();

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

        boolean disabled = UserStatus.DISABLE.name().equals(user.getStatus())
                || UserStatus.DELETED.name().equals(user.getStatus());
        boolean locked = UserStatus.LOCKED.name().equals(user.getStatus());

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities("ROLE_USER") // 先写死，后面再扩展
                .accountExpired(false)
                .accountLocked(locked)
                .credentialsExpired(false)
                .disabled(disabled)
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
                .orElseThrow(() -> new BizException(UserErrorCode.USER_NOT_FOUND));
    }

    public SysUserPO createUser(String username, String password, String email) {
        SysUserPO user = new SysUserPO();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        sysUserMapper.insert(user);
        return user;
    }

    /**
     * 创建用户
     */
    public UserVO createUser(CreateUserDTO request) {
        // 验证用户名是否已存在
//        if (sysUserMapper.existsByUsername(request.getUsername())) {
//            throw new RuntimeException("用户名已存在");
//        }
//
//        // 验证邮箱是否已存在
//        if (StringUtils.hasText(request.getEmail()) &&
//                sysUserMapper.existsByEmail(request.getEmail())) {
//            throw new RuntimeException("邮箱已存在");
//        }
//
//        // 验证手机号是否已存在
//        if (StringUtils.hasText(request.getPhone()) &&
//                sysUserMapper.existsByPhone(request.getPhone())) {
//            throw new RuntimeException("手机号已存在");
//        }

        // 创建用户实体
        SysUserPO user = new SysUserPO();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setAvatar(request.getAvatar());
        user.setNickname(StringUtils.hasText(request.getNickname())
                ? request.getNickname()
                : request.getUsername());
        user.setStatus(request.getStatus() == null ? UserStatus.ACTIVE.name() : request.getStatus().name());
//        user.setGender(request.getGender());
//        user.setType(request.getType());
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        sysUserMapper.insert(user);
        return sysUserConvert.toVO(user);
    }

    @Override
    public UserVO getUser(Long id) {
        return sysUserConvert.toVO(findById(String.valueOf(id)));
    }

    @Override
    public PageVO<UserVO> queryUsers(int page, int size) {
        long current = page < 1 ? 1 : page;
        long pageSize = size < 1 ? 20 : Math.min(size, 100);
        Page<SysUserPO> result = sysUserMapper.selectPage(
                Page.of(current, pageSize),
                Wrappers.<SysUserPO>lambdaQuery()
                        .ne(SysUserPO::getStatus, UserStatus.DELETED.name())
                        .orderByDesc(SysUserPO::getCreateTime)
        );
        return PageVO.of(result.convert(sysUserConvert::toVO));
    }

    @Override
    public UserVO updateUserStatus(Long id, String status) {
        UserStatus userStatus = parseStatus(status);
        SysUserPO user = findById(String.valueOf(id));
        user.setStatus(userStatus.name());
        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
        return sysUserConvert.toVO(user);
    }

    @Override
    public UserVO updateUser(Long id, UpdateUserDTO userDTO) {
        return updateUser(String.valueOf(id), userDTO);
    }

    @Override
    public void deleteUser(Long id) {
        sysUserMapper.deleteById(id);
    }

    /**
     * 更新用户
     */
    @Override
    public UserVO updateUser(String userId, UpdateUserDTO userDTO) {
        SysUserPO user = findById(userId);

        // 验证唯一性（排除当前用户）
//        if (sysUserMapper.existsByUsernameOrEmailOrPhoneExcludingId(
//                userDTO.getUsername(),
//                userDTO.getEmail(),
//                userDTO.getPhone(),
//                userId)) {
//            throw new RuntimeException("用户名、邮箱或手机号已存在");
//        }

        // 更新用户信息
        if (StringUtils.hasText(userDTO.getUsername())) {
            user.setUsername(userDTO.getUsername().trim());
        }
        if (StringUtils.hasText(userDTO.getPassword())) {
            user.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        }
        if (userDTO.getEmail() != null) {
            user.setEmail(emptyToNull(userDTO.getEmail()));
        }
        if (userDTO.getPhone() != null) {
            user.setPhone(emptyToNull(userDTO.getPhone()));
        }
        if (userDTO.getAvatar() != null) {
            user.setAvatar(emptyToNull(userDTO.getAvatar()));
        }
        if (userDTO.getNickname() != null) {
            user.setNickname(emptyToNull(userDTO.getNickname()));
        }
//        if (StringUtils.hasText(userDTO.getNickname())) {
//            user.setNickname(userDTO.getNickname());
//        }
//        if (userDTO.getGender() != null) {
//            user.setGender(userDTO.getGender());
//        }
//        if (userDTO.getStatus() != null) {
//            user.setStatus(userDTO.getStatus());
//        }
//        if (userDTO.getType() != null) {
//            user.setType(userDTO.getType());
//        }

        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
        return sysUserConvert.toVO(user);
    }

    @Override
    public void changePassword(String userId, ChangePasswordDTO request) {
        SysUserPO user = findById(userId);
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new BizException("当前密码不正确");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
    }

    @Override
    public String sendPhoneCode(PhoneCodeDTO request) {
        phoneCodeCache.put(
                request.getPhone(),
                new PhoneCodeCache(DEV_PHONE_CODE, LocalDateTime.now().plusMinutes(5))
        );
        return DEV_PHONE_CODE;
    }

    @Override
    public UserVO bindPhone(String userId, PhoneBindDTO request) {
        PhoneCodeCache cache = phoneCodeCache.get(request.getPhone());
        if (cache == null || cache.expiresAt().isBefore(LocalDateTime.now())
                || !cache.code().equals(request.getCode())) {
            throw new BizException("验证码错误或已过期");
        }

        SysUserPO existing = sysUserMapper.selectOne(
                Wrappers.<SysUserPO>lambdaQuery()
                        .eq(SysUserPO::getPhone, request.getPhone())
                        .ne(SysUserPO::getId, userId)
                        .last("LIMIT 1")
        );
        if (existing != null) {
            throw new BizException("手机号已被绑定");
        }

        SysUserPO user = findById(userId);
        user.setPhone(request.getPhone());
        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
        phoneCodeCache.remove(request.getPhone());
        return sysUserConvert.toVO(user);
    }

    @Override
    public UserVO unbindPhone(String userId) {
        SysUserPO user = findById(userId);
        user.setPhone(null);
        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
        return sysUserConvert.toVO(user);
    }

    private UserStatus parseStatus(String status) {
        if (!StringUtils.hasText(status)) {
            throw new BizException("用户状态不能为空");
        }
        String normalized = status.trim();
        for (UserStatus userStatus : UserStatus.values()) {
            if (userStatus.name().equalsIgnoreCase(normalized)
                    || userStatus.getCode().equals(normalized)) {
                return userStatus;
            }
        }
        throw new BizException("用户状态不合法");
    }

    private String emptyToNull(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private record PhoneCodeCache(String code, LocalDateTime expiresAt) {
    }
}
