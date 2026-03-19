package com.zp.haoke.auth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zp.haoke.auth.domain.po.SysUserPO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SysUserMapper extends BaseMapper<SysUserPO> {
}
