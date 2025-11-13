package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.mapper.HouseResourceMapper;
import com.zp.haoke.house.service.IHouseResourceService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * @author : zhengpanone
 * Date : 2025/11/24 20:52
 * Version : v1.0.0
 * Description:
 */
@Service
@AllArgsConstructor
public class HouseResourceServiceImpl extends ServiceImpl<HouseResourceMapper, HouseResourcePO> implements IHouseResourceService {
    @Override
    public int saveHouseResource(HouseResourceCreateDTO createDTO) {
        return 0;
    }
}
