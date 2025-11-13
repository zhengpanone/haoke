package com.zp.haoke.house.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;

/**
 * @author : zhengpanone
 * Date : 2025/11/18 21:46
 * Version : v1.0.0
 * Description:
 */
public interface IHouseResourceService extends IService<HouseResourcePO> {

    int saveHouseResource(HouseResourceCreateDTO createDTO);
}
