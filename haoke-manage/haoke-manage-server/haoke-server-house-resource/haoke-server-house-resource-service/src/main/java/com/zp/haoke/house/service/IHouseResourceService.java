package com.zp.haoke.house.service;


import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import jakarta.validation.Valid;


public interface IHouseResourceService extends IService<HouseResourcePO> {
    /**
     * 创建房源
     * @param houseResourceCreateDTO
     * @return
     */
    int saveHouseResource(@Valid HouseResourceCreateDTO houseResourceCreateDTO);

    HouseResourceVO queryById(String id);

    IPage<HouseResourceVO> queryPageList();

    Boolean deleteByIds(String id);

    Boolean updateById(HouseResourceUpdateDTO houseResourceUpdateDTO);
}
