package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.po.HouseEstatePO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.mapper.HouseEstateMapper;
import com.zp.haoke.house.service.IHouseEstateService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author : zhengpanone
 * Date : 2026/3/16 22:26
 * Version : v1.0.0
 * Description: 房源管理服务类
 */
@Service
public class HouseEstateServiceImpl extends ServiceImpl<HouseEstateMapper, HouseEstatePO> implements IHouseEstateService {

    @Override
    public int createHouseEstate(HouseEstatePO houseEstatePO) {
        return 0;
    }

    @Override
    public HouseEstatePO queryById(String id) {
        return null;
    }

    @Override
    public int updateById(HouseEstateUpdateDTO houseEstateUpdateDTO) {
        return 0;
    }

    @Override
    public int deleteHouseEstate(String id) {
        return 0;
    }

    @Override
    public List<HouseEstateVO> queryPageList() {
        return List.of();
    }
}
