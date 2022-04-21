/*
 Navicat Premium Data Transfer

 Source Server         : node-etl-01
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : 192.168.32.128:3306
 Source Schema         : gmall

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 21/04/2022 13:54:22
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_info
-- ----------------------------
DROP TABLE IF EXISTS `activity_info`;
CREATE TABLE `activity_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `activity_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `activity_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动类型（1：满减，2：折扣）',
  `activity_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动描述',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_rule
-- ----------------------------
DROP TABLE IF EXISTS `activity_rule`;
CREATE TABLE `activity_rule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` int(11) NULL DEFAULT NULL COMMENT '类型',
  `activity_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动类型',
  `condition_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '满减金额',
  `condition_num` bigint(20) NULL DEFAULT NULL COMMENT '满减件数',
  `benefit_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '优惠金额',
  `benefit_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '优惠折扣',
  `benefit_level` bigint(20) NULL DEFAULT NULL COMMENT '优惠级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优惠规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_sku
-- ----------------------------
DROP TABLE IF EXISTS `activity_sku`;
CREATE TABLE `activity_sku`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` bigint(20) NULL DEFAULT NULL COMMENT '活动id ',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'sku_id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '活动参与商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_attr_info
-- ----------------------------
DROP TABLE IF EXISTS `base_attr_info`;
CREATE TABLE `base_attr_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性名称',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '分类id',
  `category_level` int(11) NULL DEFAULT NULL COMMENT '分类层级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `base_attr_value`;
CREATE TABLE `base_attr_value`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `value_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性值名称',
  `attr_id` bigint(20) NULL DEFAULT NULL COMMENT '属性id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 219 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '属性值表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_category1
-- ----------------------------
DROP TABLE IF EXISTS `base_category1`;
CREATE TABLE `base_category1`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '一级分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_category2
-- ----------------------------
DROP TABLE IF EXISTS `base_category2`;
CREATE TABLE `base_category2`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '二级分类名称',
  `category1_id` bigint(20) NULL DEFAULT NULL COMMENT '一级分类编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '二级分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_category3
-- ----------------------------
DROP TABLE IF EXISTS `base_category3`;
CREATE TABLE `base_category3`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '三级分类名称',
  `category2_id` bigint(20) NULL DEFAULT NULL COMMENT '二级分类编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '三级分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_dic
-- ----------------------------
DROP TABLE IF EXISTS `base_dic`;
CREATE TABLE `base_dic`  (
  `dic_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编号',
  `dic_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编码名称',
  `parent_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父编号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '修改日期'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_frontend_param
-- ----------------------------
DROP TABLE IF EXISTS `base_frontend_param`;
CREATE TABLE `base_frontend_param`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性名称',
  `delete_id` bigint(20) NULL DEFAULT NULL COMMENT '分类id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '前端数据保护表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_province
-- ----------------------------
DROP TABLE IF EXISTS `base_province`;
CREATE TABLE `base_province`  (
  `id` bigint(20) NULL DEFAULT NULL COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省名称',
  `region_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '大区id',
  `area_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行政区位码',
  `iso_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '国际编码',
  `iso_3166_2` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ISO3166编码'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_region
-- ----------------------------
DROP TABLE IF EXISTS `base_region`;
CREATE TABLE `base_region`  (
  `id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '大区id',
  `region_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '大区名称'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_sale_attr
-- ----------------------------
DROP TABLE IF EXISTS `base_sale_attr`;
CREATE TABLE `base_sale_attr`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '销售属性名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '基本销售属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for base_trademark
-- ----------------------------
DROP TABLE IF EXISTS `base_trademark`;
CREATE TABLE `base_trademark`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `tm_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性值',
  `logo_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌logo的图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '品牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cart_info
-- ----------------------------
DROP TABLE IF EXISTS `cart_info`;
CREATE TABLE `cart_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `cart_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '放入购物车时价格',
  `sku_num` int(11) NULL DEFAULT NULL COMMENT '数量',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片文件',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称 (冗余)',
  `is_checked` int(1) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `is_ordered` bigint(20) NULL DEFAULT NULL COMMENT '是否已经下单',
  `order_time` datetime(0) NULL DEFAULT NULL COMMENT '下单时间',
  `source_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源类型',
  `source_id` bigint(20) NULL DEFAULT NULL COMMENT '来源编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31053 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '购物车表 用户登录系统时更新冗余' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_banner
-- ----------------------------
DROP TABLE IF EXISTS `cms_banner`;
CREATE TABLE `cms_banner`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片地址',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '链接地址',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页banner表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comment_info
-- ----------------------------
DROP TABLE IF EXISTS `comment_info`;
CREATE TABLE `comment_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `nick_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `head_img` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单编号',
  `appraise` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评价 1 好评 2 中评 3 差评',
  `comment_txt` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评价内容',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1517018321705259013 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_info
-- ----------------------------
DROP TABLE IF EXISTS `coupon_info`;
CREATE TABLE `coupon_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物券编号',
  `coupon_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购物券名称',
  `coupon_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购物券类型 1 现金券 2 折扣券 3 满减券 4 满件打折券',
  `condition_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '满额数（3）',
  `condition_num` bigint(20) NULL DEFAULT NULL COMMENT '满件数（4）',
  `activity_id` bigint(20) NULL DEFAULT NULL COMMENT '活动编号',
  `benefit_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '减金额（1 3）',
  `benefit_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '折扣（2 4）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `range_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '范围类型 1、商品(spuid) 2、品类(三级分类id) 3、品牌',
  `limit_num` int(11) NOT NULL DEFAULT 0 COMMENT '最多领用次数',
  `taken_count` int(11) NOT NULL DEFAULT 0 COMMENT '已领用次数',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '可以领取的开始日期',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '可以领取的结束日期',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `expire_time` datetime(0) NULL DEFAULT NULL COMMENT '过期时间',
  `range_desc` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '范围描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优惠券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_range
-- ----------------------------
DROP TABLE IF EXISTS `coupon_range`;
CREATE TABLE `coupon_range`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物券编号',
  `coupon_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '优惠券id',
  `range_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '范围类型 1、商品(spuid) 2、品类(三级分类id) 3、品牌',
  `range_id` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优惠券范围表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_use
-- ----------------------------
DROP TABLE IF EXISTS `coupon_use`;
CREATE TABLE `coupon_use`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `coupon_id` bigint(20) NULL DEFAULT NULL COMMENT '购物券ID',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单ID',
  `coupon_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购物券状态（1：未使用 2：已使用）',
  `get_time` datetime(0) NULL DEFAULT NULL COMMENT '获取时间',
  `using_time` datetime(0) NULL DEFAULT NULL COMMENT '使用时间',
  `used_time` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `expire_time` datetime(0) NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43910 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优惠券领用表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for favor_info
-- ----------------------------
DROP TABLE IF EXISTS `favor_info`;
CREATE TABLE `favor_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户名称',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `is_cancel` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否已取消 0 正常 1 已取消',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1517018318890881106 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for financial_sku_cost
-- ----------------------------
DROP TABLE IF EXISTS `financial_sku_cost`;
CREATE TABLE `financial_sku_cost`  (
  `id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `busi_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务日期',
  `is_lastest` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否最近',
  `sku_cost` decimal(16, 2) NULL DEFAULT NULL COMMENT '商品结算成本',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单编号',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称（冗余)',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称（冗余)',
  `order_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '购买价格(下单时sku价格）',
  `sku_num` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购买个数',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `source_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源类型',
  `source_id` bigint(20) NULL DEFAULT NULL COMMENT '来源编号',
  `split_total_amount` decimal(16, 2) NULL DEFAULT NULL,
  `split_activity_amount` decimal(16, 2) NULL DEFAULT NULL,
  `split_coupon_amount` decimal(16, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13149 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_detail_activity
-- ----------------------------
DROP TABLE IF EXISTS `order_detail_activity`;
CREATE TABLE `order_detail_activity`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单id',
  `order_detail_id` bigint(20) NULL DEFAULT NULL COMMENT '订单明细id',
  `activity_id` bigint(20) NULL DEFAULT NULL COMMENT '活动ID',
  `activity_rule_id` bigint(20) NULL DEFAULT NULL COMMENT '活动规则',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '获取时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1675 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单明细购物券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_detail_coupon
-- ----------------------------
DROP TABLE IF EXISTS `order_detail_coupon`;
CREATE TABLE `order_detail_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单id',
  `order_detail_id` bigint(20) NULL DEFAULT NULL COMMENT '订单明细id',
  `coupon_id` bigint(20) NULL DEFAULT NULL COMMENT '购物券ID',
  `coupon_use_id` bigint(20) NULL DEFAULT NULL COMMENT '购物券领用id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '获取时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1453760692271210509 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单明细购物券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `consignee` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收件人电话',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `order_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单状态',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `payment_way` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款方式',
  `delivery_address` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `out_trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单交易编号（第三方支付用)',
  `trade_body` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单描述(第三方支付用)',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `expire_time` datetime(0) NULL DEFAULT NULL COMMENT '失效时间',
  `process_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '进度状态',
  `tracking_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单编号',
  `parent_order_id` bigint(20) NULL DEFAULT NULL COMMENT '父订单编号',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片路径',
  `province_id` int(20) NULL DEFAULT NULL COMMENT '地区',
  `activity_reduce_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '促销金额',
  `coupon_reduce_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '优惠券',
  `original_total_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '原价金额',
  `feight_fee` decimal(16, 2) NULL DEFAULT NULL COMMENT '运费',
  `feight_fee_reduce` decimal(16, 2) NULL DEFAULT NULL COMMENT '运费减免',
  `refundable_time` datetime(0) NULL DEFAULT NULL COMMENT '可退款日期（签收后30天）',
  `final_total_amount` decimal(16, 2) NULL DEFAULT NULL,
  `benefit_reduce_amount` decimal(16, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4931 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表 订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_refund_info
-- ----------------------------
DROP TABLE IF EXISTS `order_refund_info`;
CREATE TABLE `order_refund_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `refund_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退款类型',
  `refund_num` bigint(20) NULL DEFAULT NULL COMMENT '退货件数',
  `refund_amount` decimal(16, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refund_reason_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '原因类型',
  `refund_reason_txt` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '原因内容',
  `refund_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退款状态（0：待审批 1：已退款）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 759 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '退单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_status_log
-- ----------------------------
DROP TABLE IF EXISTS `order_status_log`;
CREATE TABLE `order_status_log`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(11) NULL DEFAULT NULL,
  `order_status` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `operate_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10507 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payment_info
-- ----------------------------
DROP TABLE IF EXISTS `payment_info`;
CREATE TABLE `payment_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `out_trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对外业务编号',
  `order_id` bigint(50) NULL DEFAULT NULL COMMENT '订单编号',
  `user_id` bigint(20) NULL DEFAULT NULL,
  `payment_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付类型（微信 支付宝）',
  `trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易编号',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `subject` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易内容',
  `payment_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `callback_time` datetime(0) NULL DEFAULT NULL COMMENT '回调时间',
  `callback_content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '回调信息',
  `alipay_trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `payment_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2590 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支付信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refund_payment
-- ----------------------------
DROP TABLE IF EXISTS `refund_payment`;
CREATE TABLE `refund_payment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `out_trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对外业务编号',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单编号',
  `sku_id` bigint(20) NULL DEFAULT NULL,
  `payment_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付类型（微信 支付宝）',
  `trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易编号',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `subject` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易内容',
  `refund_status` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退款状态',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `callback_time` datetime(0) NULL DEFAULT NULL COMMENT '回调时间',
  `callback_content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '回调信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_out_trade_no`(`out_trade_no`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '退款信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for seckill_goods
-- ----------------------------
DROP TABLE IF EXISTS `seckill_goods`;
CREATE TABLE `seckill_goods`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT 'spu_id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `sku_default_img` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价格',
  `cost_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '秒杀价格',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加日期',
  `check_time` datetime(0) NULL DEFAULT NULL COMMENT '审核日期',
  `status` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核状态',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `num` int(11) NULL DEFAULT NULL COMMENT '秒杀商品数',
  `stock_count` int(11) NULL DEFAULT NULL COMMENT '剩余库存数',
  `sku_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sku_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `sku_attr_value`;
CREATE TABLE `sku_attr_value`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_id` bigint(20) NULL DEFAULT NULL COMMENT '属性id（冗余)',
  `value_id` bigint(20) NULL DEFAULT NULL COMMENT '属性值id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `attr_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '属性名',
  `value_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '属性值名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'sku平台属性值关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sku_image
-- ----------------------------
DROP TABLE IF EXISTS `sku_image`;
CREATE TABLE `sku_image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称（冗余）',
  `img_url` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片路径(冗余)',
  `spu_img_id` bigint(20) NULL DEFAULT NULL COMMENT '商品图片id',
  `is_default` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 197 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存单元图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sku_info
-- ----------------------------
DROP TABLE IF EXISTS `sku_info`;
CREATE TABLE `sku_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '库存id(itemID)',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `price` decimal(10, 0) NULL DEFAULT NULL COMMENT '价格',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称',
  `sku_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品规格描述',
  `weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '重量',
  `tm_id` bigint(20) NULL DEFAULT NULL COMMENT '品牌(冗余)',
  `category3_id` bigint(20) NULL DEFAULT NULL COMMENT '三级分类id（冗余)',
  `sku_default_img` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认显示图片(冗余)',
  `is_sale` tinyint(3) NOT NULL DEFAULT 0 COMMENT '是否销售（1：是 0：否）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存单元表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sku_sale_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `sku_sale_attr_value`;
CREATE TABLE `sku_sale_attr_value`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '库存单元id',
  `spu_id` int(11) NULL DEFAULT NULL COMMENT 'spu_id(冗余)',
  `sale_attr_value_id` bigint(20) NULL DEFAULT NULL COMMENT '销售属性值id',
  `sale_attr_id` bigint(20) NULL DEFAULT NULL,
  `sale_attr_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sale_attr_value_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'sku销售属性值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for spu_image
-- ----------------------------
DROP TABLE IF EXISTS `spu_image`;
CREATE TABLE `spu_image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称',
  `img_url` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for spu_info
-- ----------------------------
DROP TABLE IF EXISTS `spu_info`;
CREATE TABLE `spu_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `spu_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品描述(后台简述）',
  `category3_id` bigint(20) NULL DEFAULT NULL COMMENT '三级分类id',
  `tm_id` bigint(20) NULL DEFAULT NULL COMMENT '品牌id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for spu_poster
-- ----------------------------
DROP TABLE IF EXISTS `spu_poster`;
CREATE TABLE `spu_poster`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(3) NOT NULL DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品海报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for spu_sale_attr
-- ----------------------------
DROP TABLE IF EXISTS `spu_sale_attr`;
CREATE TABLE `spu_sale_attr`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号(业务中无关联)',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `base_sale_attr_id` bigint(20) NULL DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性名称(冗余)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'spu销售属性' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for spu_sale_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `spu_sale_attr_value`;
CREATE TABLE `spu_sale_attr_value`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '销售属性值编号',
  `spu_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `base_sale_attr_id` bigint(20) NULL DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_value_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性值名称',
  `sale_attr_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性名称(冗余)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'spu销售属性值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `province_id` bigint(20) NULL DEFAULT NULL COMMENT '省份id',
  `user_address` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户地址',
  `consignee` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收件人',
  `phone_num` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `is_default` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否是默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `login_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `nick_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `passwd` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户密码',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户姓名',
  `phone_num` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `head_img` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `user_level` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户级别',
  `birthday` date NULL DEFAULT NULL COMMENT '用户生日',
  `gender` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别 M男,F女',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `status` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ware_info
-- ----------------------------
DROP TABLE IF EXISTS `ware_info`;
CREATE TABLE `ware_info`  (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `areacode` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ware_order_task
-- ----------------------------
DROP TABLE IF EXISTS `ware_order_task`;
CREATE TABLE `ware_order_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单编号',
  `consignee` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `delivery_address` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `payment_way` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款方式 1:在线付款 2:货到付款',
  `task_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作单状态',
  `order_body` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单描述',
  `tracking_no` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `ware_id` bigint(20) NULL DEFAULT NULL COMMENT '仓库编号',
  `task_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作单备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存工作单表 库存工作单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ware_order_task_detail
-- ----------------------------
DROP TABLE IF EXISTS `ware_order_task_detail`;
CREATE TABLE `ware_order_task_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称',
  `sku_num` int(11) NULL DEFAULT NULL COMMENT '购买个数',
  `task_id` bigint(20) NULL DEFAULT NULL COMMENT '工作单编号',
  `refund_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存工作单明细表 库存工作单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ware_sku
-- ----------------------------
DROP TABLE IF EXISTS `ware_sku`;
CREATE TABLE `ware_sku`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT 'skuid',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '仓库id',
  `stock` int(11) NULL DEFAULT NULL COMMENT '库存数',
  `stock_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存货名称',
  `stock_locked` int(11) NULL DEFAULT NULL COMMENT '锁定库存数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'sku与仓库关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for base_category_view
-- ----------------------------
DROP VIEW IF EXISTS `base_category_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `base_category_view` AS select `base_category3`.`id` AS `id`,`base_category1`.`id` AS `category1_id`,`base_category1`.`name` AS `category1_name`,`base_category2`.`id` AS `category2_id`,`base_category2`.`name` AS `category2_name`,`base_category3`.`id` AS `category3_id`,`base_category3`.`name` AS `category3_name` from ((`base_category1` join `base_category2` on((`base_category1`.`id` = `base_category2`.`category1_id`))) join `base_category3` on((`base_category2`.`id` = `base_category3`.`category2_id`)));

SET FOREIGN_KEY_CHECKS = 1;
