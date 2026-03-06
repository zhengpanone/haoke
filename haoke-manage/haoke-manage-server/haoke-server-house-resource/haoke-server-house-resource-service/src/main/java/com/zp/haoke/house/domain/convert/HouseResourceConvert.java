package com.zp.haoke.house.domain.convert;

import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceDetailVO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface HouseResourceConvert {
    // 静态实例，用于非 Spring 环境
    HouseResourceConvert INSTANCE = Mappers.getMapper(HouseResourceConvert.class);


    HouseResourcePO toEntity(HouseResourceCreateDTO houseResourceCreateDTO);

    HouseResourceVO toVO(HouseResourcePO po);

    HouseResourceDetailVO toDetailVO(HouseResourcePO po);

    List<HouseResourceVO> toDTOList(List<HouseResourcePO> list);
}
