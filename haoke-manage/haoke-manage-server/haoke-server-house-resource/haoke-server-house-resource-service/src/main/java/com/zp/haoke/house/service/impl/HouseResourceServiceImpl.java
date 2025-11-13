package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import com.zp.haoke.house.mapper.HouseResourceMapper;
import com.zp.haoke.house.service.IHouseResourceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class HouseResourceServiceImpl extends ServiceImpl<HouseResourceMapper, HouseResourcePO> implements IHouseResourceService {

    private final HouseResourceMapper houseResourceMapper;

    @Override
    public int saveHouseResource(HouseResourceCreateDTO houseResourceCreateDTO) {
        return houseResourceMapper.insert(null);
    }

    @Override
    public HouseResourceVO queryById(String id) {
        return null;
    }

    @Override
    public IPage<HouseResourceVO> queryPageList() {
        return null;
    }

    @Override
    public Boolean deleteByIds(String id) {
        return null;
    }

    @Override
    public Boolean updateById(HouseResourceUpdateDTO houseResourceUpdateDTO) {
        return null;
    }
}
