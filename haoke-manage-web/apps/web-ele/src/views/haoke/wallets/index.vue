<script lang="ts" setup>
import type { UserWallet, WalletRecord } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElDivider,
  ElForm,
  ElFormItem,
  ElInput,
  ElMessage,
  ElOption,
  ElPagination,
  ElSelect,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import { queryUserWalletsApi, queryWalletRecordsApi } from '#/api/haoke';

const recordTypeOptions = [
  { label: '充值', value: 'RECHARGE' },
  { label: '提现', value: 'WITHDRAW' },
  { label: '退款', value: 'REFUND' },
  { label: '服务费', value: 'SERVICE_FEE' },
];

const walletQuery = reactive({
  pageNum: 1,
  pageSize: 10,
  userId: '',
});

const recordQuery = reactive({
  income: undefined as boolean | undefined,
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  recordType: '',
  status: '',
  userId: '',
});

const recordLoading = ref(false);
const recordRows = ref<WalletRecord[]>([]);
const recordTotal = ref(0);
const walletLoading = ref(false);
const walletRows = ref<UserWallet[]>([]);
const walletTotal = ref(0);

async function fetchWallets() {
  walletLoading.value = true;
  try {
    const data = await queryUserWalletsApi({
      pageNum: walletQuery.pageNum,
      pageSize: walletQuery.pageSize,
      userId: walletQuery.userId || undefined,
    });
    walletRows.value = data.records || [];
    walletTotal.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载钱包失败');
  } finally {
    walletLoading.value = false;
  }
}

async function fetchRecords() {
  recordLoading.value = true;
  try {
    const data = await queryWalletRecordsApi({
      income: recordQuery.income,
      keyword: recordQuery.keyword || undefined,
      pageNum: recordQuery.pageNum,
      pageSize: recordQuery.pageSize,
      recordType: recordQuery.recordType || undefined,
      status: recordQuery.status || undefined,
      userId: recordQuery.userId || undefined,
    });
    recordRows.value = data.records || [];
    recordTotal.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载钱包流水失败');
  } finally {
    recordLoading.value = false;
  }
}

async function viewRecords(row: unknown) {
  const item = row as UserWallet;
  recordQuery.userId = item.userId || '';
  recordQuery.pageNum = 1;
  await fetchRecords();
}

function incomeLabel(value?: boolean) {
  return value ? '收入' : '支出';
}

function incomeType(value?: boolean) {
  return value ? 'success' : 'warning';
}

onMounted(async () => {
  await fetchWallets();
  await fetchRecords();
});
</script>

<template>
  <Page title="钱包管理">
    <div class="p-5">
      <ElCard shadow="never">
        <ElForm :inline="true" :model="walletQuery">
          <ElFormItem label="用户ID">
            <ElInput
              v-model="walletQuery.userId"
              clearable
              placeholder="输入用户ID"
            />
          </ElFormItem>
          <ElFormItem>
            <ElButton type="primary" @click="fetchWallets">查询账户</ElButton>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="walletLoading" :data="walletRows" stripe>
          <ElTableColumn label="用户ID" min-width="180" prop="userId" />
          <ElTableColumn label="可用余额" width="130">
            <template #default="{ row }"> ¥{{ row.balance || 0 }} </template>
          </ElTableColumn>
          <ElTableColumn label="冻结金额" width="130">
            <template #default="{ row }">
              ¥{{ row.frozenAmount || 0 }}
            </template>
          </ElTableColumn>
          <ElTableColumn label="更新时间" min-width="160" prop="updateTime" />
          <ElTableColumn fixed="right" label="操作" width="120">
            <template #default="{ row }">
              <ElButton link type="primary" @click="viewRecords(row)"
                >查看流水</ElButton
              >
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-4 flex justify-end">
          <ElPagination
            v-model:current-page="walletQuery.pageNum"
            v-model:page-size="walletQuery.pageSize"
            :page-sizes="[10, 20, 50]"
            :total="walletTotal"
            layout="total, sizes, prev, pager, next"
            @change="fetchWallets"
          />
        </div>

        <ElDivider />

        <ElForm :inline="true" :model="recordQuery">
          <ElFormItem label="用户ID">
            <ElInput
              v-model="recordQuery.userId"
              clearable
              placeholder="输入用户ID"
            />
          </ElFormItem>
          <ElFormItem label="关键词">
            <ElInput
              v-model="recordQuery.keyword"
              clearable
              placeholder="标题/类型"
            />
          </ElFormItem>
          <ElFormItem label="流水类型">
            <ElSelect
              v-model="recordQuery.recordType"
              clearable
              placeholder="全部"
              style="width: 140px"
            >
              <ElOption
                v-for="item in recordTypeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
          <ElFormItem label="收支">
            <ElSelect
              v-model="recordQuery.income"
              clearable
              placeholder="全部"
              style="width: 120px"
            >
              <ElOption label="收入" :value="true" />
              <ElOption label="支出" :value="false" />
            </ElSelect>
          </ElFormItem>
          <ElFormItem>
            <ElButton type="primary" @click="fetchRecords">查询流水</ElButton>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="recordLoading" :data="recordRows" stripe>
          <ElTableColumn label="用户ID" min-width="180" prop="userId" />
          <ElTableColumn label="标题" min-width="180" prop="title" />
          <ElTableColumn label="类型" width="120" prop="recordType" />
          <ElTableColumn label="收支" width="90">
            <template #default="{ row }">
              <ElTag :type="incomeType(row.income)">{{
                incomeLabel(row.income)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="金额" width="120">
            <template #default="{ row }"> ¥{{ row.amount || 0 }} </template>
          </ElTableColumn>
          <ElTableColumn label="状态" width="100" prop="status" />
          <ElTableColumn label="流水时间" min-width="160" prop="recordTime" />
        </ElTable>

        <div class="mt-4 flex justify-end">
          <ElPagination
            v-model:current-page="recordQuery.pageNum"
            v-model:page-size="recordQuery.pageSize"
            :page-sizes="[10, 20, 50]"
            :total="recordTotal"
            layout="total, sizes, prev, pager, next"
            @change="fetchRecords"
          />
        </div>
      </ElCard>
    </div>
  </Page>
</template>
