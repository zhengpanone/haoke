package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.house.domain.dto.FavoriteCreateDTO;
import com.zp.haoke.house.domain.dto.HouseOrderCreateDTO;
import com.zp.haoke.house.domain.dto.IdentityVerificationSubmitDTO;
import com.zp.haoke.house.domain.dto.ProfilePageQueryDTO;
import com.zp.haoke.house.domain.dto.ViewingRecordCreateDTO;
import com.zp.haoke.house.domain.dto.WalletTradeDTO;
import com.zp.haoke.house.domain.po.HouseContractPO;
import com.zp.haoke.house.domain.po.HouseFavoritePO;
import com.zp.haoke.house.domain.po.HouseOrderPO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.po.HouseViewingRecordPO;
import com.zp.haoke.house.domain.po.UserIdentityVerificationPO;
import com.zp.haoke.house.domain.po.UserWalletPO;
import com.zp.haoke.house.domain.po.WalletRecordPO;
import com.zp.haoke.house.domain.vo.ContactChannelVO;
import com.zp.haoke.house.domain.vo.HouseContractVO;
import com.zp.haoke.house.domain.vo.HouseFavoriteVO;
import com.zp.haoke.house.domain.vo.HouseOrderVO;
import com.zp.haoke.house.domain.vo.IdentityVerificationVO;
import com.zp.haoke.house.domain.vo.ViewingRecordVO;
import com.zp.haoke.house.domain.vo.WalletOverviewVO;
import com.zp.haoke.house.domain.vo.WalletRecordVO;
import com.zp.haoke.house.mapper.HouseContractMapper;
import com.zp.haoke.house.mapper.HouseFavoriteMapper;
import com.zp.haoke.house.mapper.HouseOrderMapper;
import com.zp.haoke.house.mapper.HouseResourceMapper;
import com.zp.haoke.house.mapper.HouseViewingRecordMapper;
import com.zp.haoke.house.mapper.UserIdentityVerificationMapper;
import com.zp.haoke.house.mapper.UserWalletMapper;
import com.zp.haoke.house.mapper.WalletRecordMapper;
import com.zp.haoke.house.service.IProfileFeatureService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProfileFeatureServiceImpl implements IProfileFeatureService {
    private static final BigDecimal ZERO = BigDecimal.ZERO;

    private final HouseViewingRecordMapper viewingRecordMapper;
    private final HouseOrderMapper houseOrderMapper;
    private final HouseFavoriteMapper houseFavoriteMapper;
    private final UserIdentityVerificationMapper identityVerificationMapper;
    private final HouseContractMapper houseContractMapper;
    private final UserWalletMapper userWalletMapper;
    private final WalletRecordMapper walletRecordMapper;
    private final HouseResourceMapper houseResourceMapper;

    @Override
    public PageVO<ViewingRecordVO> queryViewingRecords(String userId, ProfilePageQueryDTO queryDTO) {
        LambdaQueryWrapper<HouseViewingRecordPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HouseViewingRecordPO::getUserId, userId)
                .eq(StringUtils.isNotBlank(queryDTO.getStatus()), HouseViewingRecordPO::getStatus, queryDTO.getStatus())
                .orderByDesc(HouseViewingRecordPO::getAppointmentTime)
                .orderByDesc(HouseViewingRecordPO::getCreateTime);
        return PageVO.of(viewingRecordMapper.selectPage(genericPage(queryDTO), wrapper).convert(this::toViewingRecordVO));
    }

    @Override
    public ViewingRecordVO createViewingRecord(String userId, ViewingRecordCreateDTO createDTO) {
        HouseResourcePO house = findHouse(createDTO.getHouseId());
        HouseViewingRecordPO po = new HouseViewingRecordPO();
        po.setUserId(userId);
        po.setHouseId(createDTO.getHouseId());
        po.setTitle(defaultText(createDTO.getTitle(), house == null ? "看房预约" : house.getTitle()));
        po.setAddress(defaultText(createDTO.getAddress(), buildHouseAddress(house)));
        po.setAppointmentTime(createDTO.getAppointmentTime() == null ? LocalDateTime.now().plusDays(1) : createDTO.getAppointmentTime());
        po.setContactName(defaultText(createDTO.getContactName(), house == null ? "好客客服" : house.getContact()));
        po.setContactPhone(defaultText(createDTO.getContactPhone(), house == null ? "400-800-8888" : house.getMobile()));
        po.setStatus("PENDING");
        po.setNote(defaultText(createDTO.getNote(), "预约已提交，请保持电话畅通"));
        viewingRecordMapper.insert(po);
        return toViewingRecordVO(po);
    }

    @Override
    public PageVO<HouseOrderVO> queryOrders(String userId, ProfilePageQueryDTO queryDTO) {
        LambdaQueryWrapper<HouseOrderPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HouseOrderPO::getUserId, userId)
                .eq(StringUtils.isNotBlank(queryDTO.getStatus()), HouseOrderPO::getStatus, queryDTO.getStatus())
                .orderByDesc(HouseOrderPO::getOrderTime)
                .orderByDesc(HouseOrderPO::getCreateTime);
        return PageVO.of(houseOrderMapper.selectPage(genericPage(queryDTO), wrapper).convert(this::toHouseOrderVO));
    }

    @Override
    public HouseOrderVO createOrder(String userId, HouseOrderCreateDTO createDTO) {
        HouseResourcePO house = findHouse(createDTO.getHouseId());
        HouseOrderPO po = new HouseOrderPO();
        po.setUserId(userId);
        po.setHouseId(createDTO.getHouseId());
        po.setOrderNo("HK" + DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(LocalDateTime.now()));
        po.setTitle(defaultText(createDTO.getTitle(), house == null ? "租房订单" : house.getTitle() + "租房订单"));
        po.setAddress(defaultText(createDTO.getAddress(), buildHouseAddress(house)));
        po.setAmount(createDTO.getAmount() == null ? ZERO : createDTO.getAmount());
        po.setStatus(defaultText(createDTO.getStatus(), "PENDING_SIGN"));
        po.setActionText(defaultText(createDTO.getActionText(), "去签约"));
        po.setOrderTime(LocalDateTime.now());
        houseOrderMapper.insert(po);
        return toHouseOrderVO(po);
    }

    @Override
    public PageVO<HouseFavoriteVO> queryFavorites(String userId, ProfilePageQueryDTO queryDTO) {
        LambdaQueryWrapper<HouseFavoritePO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HouseFavoritePO::getUserId, userId)
                .orderByDesc(HouseFavoritePO::getFavoriteTime)
                .orderByDesc(HouseFavoritePO::getCreateTime);
        return PageVO.of(houseFavoriteMapper.selectPage(genericPage(queryDTO), wrapper).convert(this::toHouseFavoriteVO));
    }

    @Override
    public HouseFavoriteVO createFavorite(String userId, FavoriteCreateDTO createDTO) {
        if (StringUtils.isBlank(createDTO.getHouseId())) {
            throw new IllegalArgumentException("房源ID不能为空");
        }

        HouseFavoritePO existed = houseFavoriteMapper.selectOne(new LambdaQueryWrapper<HouseFavoritePO>()
                .eq(HouseFavoritePO::getUserId, userId)
                .eq(HouseFavoritePO::getHouseId, createDTO.getHouseId())
                .last("limit 1"));
        if (existed != null) {
            return toHouseFavoriteVO(existed);
        }

        HouseResourcePO house = findHouse(createDTO.getHouseId());
        HouseFavoritePO po = new HouseFavoritePO();
        po.setUserId(userId);
        po.setHouseId(createDTO.getHouseId());
        po.setTitle(defaultText(createDTO.getTitle(), house == null ? "收藏房源" : house.getTitle()));
        po.setAddress(defaultText(createDTO.getAddress(), buildHouseAddress(house)));
        po.setPrice(createDTO.getPrice() == null ? houseRent(house) : createDTO.getPrice());
        po.setTags(defaultText(createDTO.getTags(), "整租,随时看房"));
        po.setImageUrl(defaultText(createDTO.getImageUrl(), firstImage(house)));
        po.setFavoriteTime(LocalDateTime.now());
        houseFavoriteMapper.insert(po);
        return toHouseFavoriteVO(po);
    }

    @Override
    public Boolean deleteFavorite(String userId, String houseId) {
        if (StringUtils.isBlank(houseId)) {
            return false;
        }
        return houseFavoriteMapper.delete(new LambdaQueryWrapper<HouseFavoritePO>()
                .eq(HouseFavoritePO::getUserId, userId)
                .eq(HouseFavoritePO::getHouseId, houseId)) > 0;
    }

    @Override
    public Boolean isFavorite(String userId, String houseId) {
        if (StringUtils.isBlank(houseId)) {
            return false;
        }
        Long count = houseFavoriteMapper.selectCount(new LambdaQueryWrapper<HouseFavoritePO>()
                .eq(HouseFavoritePO::getUserId, userId)
                .eq(HouseFavoritePO::getHouseId, houseId));
        return count != null && count > 0;
    }

    @Override
    public IdentityVerificationVO getIdentityVerification(String userId) {
        UserIdentityVerificationPO po = identityVerificationMapper.selectOne(new LambdaQueryWrapper<UserIdentityVerificationPO>()
                .eq(UserIdentityVerificationPO::getUserId, userId)
                .last("limit 1"));
        return po == null ? emptyIdentityVerification() : toIdentityVerificationVO(po);
    }

    @Override
    public IdentityVerificationVO submitIdentityVerification(String userId, IdentityVerificationSubmitDTO submitDTO) {
        UserIdentityVerificationPO po = identityVerificationMapper.selectOne(new LambdaQueryWrapper<UserIdentityVerificationPO>()
                .eq(UserIdentityVerificationPO::getUserId, userId)
                .last("limit 1"));
        if (po == null) {
            po = new UserIdentityVerificationPO();
            po.setUserId(userId);
        }
        po.setRealName(submitDTO.getRealName());
        po.setIdCardNo(submitDTO.getIdCardNo());
        po.setIdCardFront(submitDTO.getIdCardFront());
        po.setIdCardBack(submitDTO.getIdCardBack());
        po.setStatus("REVIEWING");
        po.setRejectReason(null);
        po.setSubmittedAt(LocalDateTime.now());
        po.setReviewedAt(null);
        if (po.getId() == null) {
            identityVerificationMapper.insert(po);
        } else {
            identityVerificationMapper.updateById(po);
        }
        return toIdentityVerificationVO(po);
    }

    @Override
    public PageVO<HouseContractVO> queryContracts(String userId, ProfilePageQueryDTO queryDTO) {
        LambdaQueryWrapper<HouseContractPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HouseContractPO::getUserId, userId)
                .eq(StringUtils.isNotBlank(queryDTO.getStatus()), HouseContractPO::getStatus, queryDTO.getStatus())
                .orderByDesc(HouseContractPO::getCreateTime);
        return PageVO.of(houseContractMapper.selectPage(genericPage(queryDTO), wrapper).convert(this::toHouseContractVO));
    }

    @Override
    public HouseContractVO getContract(String userId, String id) {
        HouseContractPO po = houseContractMapper.selectOne(new LambdaQueryWrapper<HouseContractPO>()
                .eq(HouseContractPO::getUserId, userId)
                .eq(HouseContractPO::getId, id)
                .last("limit 1"));
        if (po == null) {
            throw new IllegalArgumentException("合同不存在");
        }
        return toHouseContractVO(po);
    }

    @Override
    public WalletOverviewVO getWallet(String userId) {
        UserWalletPO wallet = getOrCreateWallet(userId);
        WalletOverviewVO vo = new WalletOverviewVO();
        vo.setBalance(wallet.getBalance());
        vo.setFrozenAmount(wallet.getFrozenAmount());
        vo.setRecords(walletRecordMapper.selectList(new LambdaQueryWrapper<WalletRecordPO>()
                .eq(WalletRecordPO::getUserId, userId)
                .orderByDesc(WalletRecordPO::getRecordTime)
                .orderByDesc(WalletRecordPO::getCreateTime)
                .last("limit 20"))
                .stream()
                .map(this::toWalletRecordVO)
                .toList());
        return vo;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public WalletOverviewVO recharge(String userId, WalletTradeDTO tradeDTO) {
        BigDecimal amount = validAmount(tradeDTO);
        UserWalletPO wallet = getOrCreateWallet(userId);
        wallet.setBalance(wallet.getBalance().add(amount));
        userWalletMapper.updateById(wallet);
        createWalletRecord(userId, "RECHARGE", defaultText(tradeDTO.getTitle(), "钱包充值"), amount, true);
        return getWallet(userId);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public WalletOverviewVO withdraw(String userId, WalletTradeDTO tradeDTO) {
        BigDecimal amount = validAmount(tradeDTO);
        UserWalletPO wallet = getOrCreateWallet(userId);
        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new IllegalArgumentException("钱包余额不足");
        }
        wallet.setBalance(wallet.getBalance().subtract(amount));
        userWalletMapper.updateById(wallet);
        createWalletRecord(userId, "WITHDRAW", defaultText(tradeDTO.getTitle(), "余额提现"), amount, false);
        return getWallet(userId);
    }

    @Override
    public List<ContactChannelVO> queryContactChannels() {
        return List.of(
                new ContactChannelVO("phone", "客服热线", "400-800-8888", "工作日 09:00-21:00"),
                new ContactChannelVO("email", "客服邮箱", "service@haoke.com", "订单、合同、钱包问题可发送邮件"),
                new ContactChannelVO("address", "办公地址", "北京市朝阳区望京科技园 18 号", "欢迎预约到访")
        );
    }

    private <T> Page<T> genericPage(ProfilePageQueryDTO queryDTO) {
        long pageNum = queryDTO.getPageNum() == null || queryDTO.getPageNum() < 1 ? 1 : queryDTO.getPageNum();
        long pageSize = queryDTO.getPageSize() == null || queryDTO.getPageSize() < 1 ? 10 : Math.min(queryDTO.getPageSize(), 100);
        return Page.of(pageNum, pageSize);
    }

    private HouseResourcePO findHouse(String houseId) {
        if (StringUtils.isBlank(houseId)) {
            return null;
        }
        return houseResourceMapper.selectById(houseId);
    }

    private String buildHouseAddress(HouseResourcePO house) {
        if (house == null) {
            return "";
        }
        return defaultText(house.getEstateId(), "") + " " + defaultText(house.getBuildingNum(), "") + defaultText(house.getBuildingUnit(), "");
    }

    private BigDecimal houseRent(HouseResourcePO house) {
        if (house == null || house.getRent() == null) {
            return ZERO;
        }
        return BigDecimal.valueOf(house.getRent());
    }

    private String firstImage(HouseResourcePO house) {
        if (house == null || StringUtils.isBlank(house.getPic())) {
            return "https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg";
        }
        return house.getPic().split(",")[0];
    }

    private String defaultText(String value, String fallback) {
        return StringUtils.isBlank(value) ? fallback : value;
    }

    private BigDecimal validAmount(WalletTradeDTO tradeDTO) {
        BigDecimal amount = tradeDTO.getAmount();
        if (amount == null || amount.compareTo(ZERO) <= 0) {
            throw new IllegalArgumentException("金额必须大于 0");
        }
        return amount;
    }

    private UserWalletPO getOrCreateWallet(String userId) {
        UserWalletPO wallet = userWalletMapper.selectOne(new LambdaQueryWrapper<UserWalletPO>()
                .eq(UserWalletPO::getUserId, userId)
                .last("limit 1"));
        if (wallet != null) {
            wallet.setBalance(wallet.getBalance() == null ? ZERO : wallet.getBalance());
            wallet.setFrozenAmount(wallet.getFrozenAmount() == null ? ZERO : wallet.getFrozenAmount());
            return wallet;
        }
        wallet = new UserWalletPO();
        wallet.setUserId(userId);
        wallet.setBalance(ZERO);
        wallet.setFrozenAmount(ZERO);
        userWalletMapper.insert(wallet);
        return wallet;
    }

    private void createWalletRecord(String userId, String type, String title, BigDecimal amount, boolean income) {
        WalletRecordPO record = new WalletRecordPO();
        record.setUserId(userId);
        record.setRecordType(type);
        record.setTitle(title);
        record.setAmount(amount);
        record.setIncome(income);
        record.setStatus("SUCCESS");
        record.setRecordTime(LocalDateTime.now());
        walletRecordMapper.insert(record);
    }

    private ViewingRecordVO toViewingRecordVO(HouseViewingRecordPO po) {
        ViewingRecordVO vo = new ViewingRecordVO();
        vo.setId(po.getId());
        vo.setHouseId(po.getHouseId());
        vo.setTitle(po.getTitle());
        vo.setAddress(po.getAddress());
        vo.setAppointmentTime(po.getAppointmentTime());
        vo.setContactName(po.getContactName());
        vo.setContactPhone(po.getContactPhone());
        vo.setStatus(po.getStatus());
        vo.setStatusText(viewingStatusText(po.getStatus()));
        vo.setNote(po.getNote());
        return vo;
    }

    private HouseOrderVO toHouseOrderVO(HouseOrderPO po) {
        HouseOrderVO vo = new HouseOrderVO();
        vo.setId(po.getId());
        vo.setHouseId(po.getHouseId());
        vo.setOrderNo(po.getOrderNo());
        vo.setTitle(po.getTitle());
        vo.setAddress(po.getAddress());
        vo.setAmount(po.getAmount());
        vo.setStatus(po.getStatus());
        vo.setStatusText(orderStatusText(po.getStatus()));
        vo.setActionText(defaultText(po.getActionText(), "查看详情"));
        vo.setOrderTime(po.getOrderTime());
        return vo;
    }

    private HouseFavoriteVO toHouseFavoriteVO(HouseFavoritePO po) {
        HouseFavoriteVO vo = new HouseFavoriteVO();
        vo.setId(po.getId());
        vo.setHouseId(po.getHouseId());
        vo.setTitle(po.getTitle());
        vo.setAddress(po.getAddress());
        vo.setPrice(po.getPrice());
        vo.setTags(StringUtils.isBlank(po.getTags()) ? Collections.emptyList() : Arrays.stream(po.getTags().split(",")).map(String::trim).filter(StringUtils::isNotBlank).toList());
        vo.setImageUrl(po.getImageUrl());
        vo.setFavoriteTime(po.getFavoriteTime());
        return vo;
    }

    private IdentityVerificationVO toIdentityVerificationVO(UserIdentityVerificationPO po) {
        IdentityVerificationVO vo = new IdentityVerificationVO();
        vo.setId(po.getId());
        vo.setRealName(po.getRealName());
        vo.setIdCardNo(maskIdCard(po.getIdCardNo()));
        vo.setStatus(po.getStatus());
        vo.setStatusText(identityStatusText(po.getStatus()));
        vo.setRejectReason(po.getRejectReason());
        vo.setSubmittedAt(po.getSubmittedAt());
        vo.setReviewedAt(po.getReviewedAt());
        return vo;
    }

    private IdentityVerificationVO emptyIdentityVerification() {
        IdentityVerificationVO vo = new IdentityVerificationVO();
        vo.setStatus("NOT_SUBMITTED");
        vo.setStatusText("未认证");
        return vo;
    }

    private HouseContractVO toHouseContractVO(HouseContractPO po) {
        HouseContractVO vo = new HouseContractVO();
        vo.setId(po.getId());
        vo.setHouseId(po.getHouseId());
        vo.setOrderId(po.getOrderId());
        vo.setContractNo(po.getContractNo());
        vo.setTitle(po.getTitle());
        vo.setPeriodStart(po.getPeriodStart());
        vo.setPeriodEnd(po.getPeriodEnd());
        vo.setStatus(po.getStatus());
        vo.setStatusText(contractStatusText(po.getStatus()));
        vo.setPdfUrl(po.getPdfUrl());
        vo.setSignUrl(po.getSignUrl());
        return vo;
    }

    private WalletRecordVO toWalletRecordVO(WalletRecordPO po) {
        WalletRecordVO vo = new WalletRecordVO();
        vo.setId(po.getId());
        vo.setRecordType(po.getRecordType());
        vo.setTitle(po.getTitle());
        vo.setAmount(po.getAmount());
        vo.setIncome(po.getIncome());
        vo.setStatus(po.getStatus());
        vo.setStatusText(walletRecordStatusText(po.getStatus()));
        vo.setRecordTime(po.getRecordTime());
        return vo;
    }

    private String maskIdCard(String idCardNo) {
        if (StringUtils.isBlank(idCardNo) || idCardNo.length() < 8) {
            return idCardNo;
        }
        return idCardNo.substring(0, 4) + "**********" + idCardNo.substring(idCardNo.length() - 4);
    }

    private String viewingStatusText(String status) {
        return switch (defaultText(status, "")) {
            case "PENDING" -> "待看房";
            case "COMPLETED" -> "已看房";
            case "CANCELLED" -> "已取消";
            default -> "看房记录";
        };
    }

    private String orderStatusText(String status) {
        return switch (defaultText(status, "")) {
            case "PENDING_SIGN" -> "待签约";
            case "PAID" -> "已支付";
            case "COMPLETED" -> "已完成";
            case "CANCELLED" -> "已取消";
            default -> "处理中";
        };
    }

    private String identityStatusText(String status) {
        return switch (defaultText(status, "")) {
            case "NOT_SUBMITTED" -> "未认证";
            case "REVIEWING" -> "审核中";
            case "VERIFIED" -> "已认证";
            case "REJECTED" -> "未通过";
            default -> "未认证";
        };
    }

    private String contractStatusText(String status) {
        return switch (defaultText(status, "")) {
            case "PENDING_SIGN" -> "待签署";
            case "SIGNED" -> "已签署";
            case "ARCHIVED" -> "已归档";
            case "TERMINATED" -> "已终止";
            default -> "处理中";
        };
    }

    private String walletRecordStatusText(String status) {
        return "SUCCESS".equals(status) ? "成功" : "处理中";
    }
}
