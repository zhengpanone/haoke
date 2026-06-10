<script lang="ts" setup>
import type { FormInstance } from 'element-plus';
import type { HouseResource, HouseResourcePayload } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElDialog,
  ElForm,
  ElFormItem,
  ElInput,
  ElInputNumber,
  ElMessage,
  ElOption,
  ElPagination,
  ElPopconfirm,
  ElSelect,
  ElSpace,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import {
  createHouseResourceApi,
  deleteHouseResourceApi,
  queryHouseResourcePageApi,
  updateHouseResourceApi,
  updateHouseResourceStatusApi,
} from '#/api/haoke';

const statusOptions = [
  { label: '待审核', value: '1' },
  { label: '审核通过', value: '2' },
  { label: '审核不通过', value: '3' },
  { label: '已出租', value: '4' },
  { label: '已下架', value: '5' },
];

const query = reactive({
  keyword: '',
  maxRent: undefined as number | undefined,
  minRent: undefined as number | undefined,
  pageNum: 1,
  pageSize: 10,
  status: '',
});

const formRef = ref<FormInstance>();
const loading = ref(false);
const dialogVisible = ref(false);
const dialogTitle = ref('新增房源');
const rows = ref<HouseResource[]>([]);
const total = ref(0);

const form = reactive<HouseResourcePayload>({
  contact: '好客管家',
  coveredArea: 80,
  decoration: 1,
  estateId: '',
  floor: '8/18',
  houseDesc: '',
  houseType: '2室1厅1卫',
  mobile: '13800138000',
  orientation: 2,
  paymentMethod: 2,
  pic: '',
  rent: 5000,
  rentMethod: 1,
  status: '2',
  title: '',
});

function resetForm(row?: HouseResource) {
  dialogTitle.value = row ? '编辑房源' : '新增房源';
  Object.assign(form, {
    contact: row?.contact || '好客管家',
    coveredArea: row?.coveredArea || 80,
    decoration: row?.decoration ? Number(row.decoration) : 1,
    estateId: row?.estateId || '',
    floor: row?.floor || '8/18',
    houseDesc: row?.description || '',
    houseType: row?.houseType || '2室1厅1卫',
    id: row?.id,
    mobile: row?.mobile || '13800138000',
    orientation: row?.orientation ? Number(row.orientation) : 2,
    paymentMethod: row?.paymentMethod || 2,
    pic: row?.imageUrl || '',
    rent: Number(row?.rent || 5000),
    rentMethod: row?.rentMethod ? Number(row.rentMethod) : 1,
    status: row?.status || '2',
    title: row?.title || '',
  });
}

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryHouseResourcePageApi({
      keyword: query.keyword || undefined,
      maxRent: query.maxRent,
      minRent: query.minRent,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载房源失败');
  } finally {
    loading.value = false;
  }
}

function openCreate() {
  resetForm();
  dialogVisible.value = true;
}

function openEdit(row: unknown) {
  resetForm(row as HouseResource);
  dialogVisible.value = true;
}

async function submitForm() {
  await formRef.value?.validate();
  try {
    if (form.id) {
      await updateHouseResourceApi(form);
      ElMessage.success('房源已更新');
    } else {
      await createHouseResourceApi(form);
      ElMessage.success('房源已创建');
    }
    dialogVisible.value = false;
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '保存房源失败');
  }
}

async function changeStatus(row: unknown, status: string) {
  const item = row as HouseResource;
  try {
    await updateHouseResourceStatusApi(item.id, status);
    ElMessage.success('状态已更新');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '状态更新失败');
  }
}

async function removeRow(row: unknown) {
  const item = row as HouseResource;
  try {
    await deleteHouseResourceApi(item.id);
    ElMessage.success('房源已删除');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '删除房源失败');
  }
}

function statusLabel(value?: string) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: string) {
  return value === '2' ? 'success' : value === '5' ? 'info' : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="推荐房源管理">
    <div class="p-5">
      <ElCard shadow="never">
        <ElForm :inline="true" :model="query">
          <ElFormItem label="关键词">
            <ElInput
              v-model="query.keyword"
              clearable
              placeholder="标题/户型/描述"
            />
          </ElFormItem>
          <ElFormItem label="状态">
            <ElSelect
              v-model="query.status"
              clearable
              placeholder="全部"
              style="width: 140px"
            >
              <ElOption
                v-for="item in statusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
          <ElFormItem label="租金">
            <ElInputNumber
              v-model="query.minRent"
              :min="0"
              placeholder="最低"
              style="width: 130px"
            />
            <span class="mx-2 text-gray-400">-</span>
            <ElInputNumber
              v-model="query.maxRent"
              :min="0"
              placeholder="最高"
              style="width: 130px"
            />
          </ElFormItem>
          <ElFormItem>
            <ElSpace>
              <ElButton type="primary" @click="fetchData">查询</ElButton>
              <ElButton @click="openCreate">新增房源</ElButton>
            </ElSpace>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="房源标题" min-width="220" prop="title" />
          <ElTableColumn label="租金" width="110">
            <template #default="{ row }"> ¥{{ row.rent || 0 }} </template>
          </ElTableColumn>
          <ElTableColumn label="户型" prop="houseType" width="130" />
          <ElTableColumn label="面积" width="100">
            <template #default="{ row }">
              {{ row.coveredArea || '-' }}㎡
            </template>
          </ElTableColumn>
          <ElTableColumn label="状态" width="120">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn fixed="right" label="操作" width="260">
            <template #default="{ row }">
              <ElSpace>
                <ElButton link type="primary" @click="openEdit(row)"
                  >编辑</ElButton
                >
                <ElButton link type="success" @click="changeStatus(row, '2')"
                  >通过</ElButton
                >
                <ElButton link type="warning" @click="changeStatus(row, '5')"
                  >下架</ElButton
                >
                <ElPopconfirm
                  title="确认删除该房源？"
                  @confirm="removeRow(row)"
                >
                  <template #reference>
                    <ElButton link type="danger">删除</ElButton>
                  </template>
                </ElPopconfirm>
              </ElSpace>
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-4 flex justify-end">
          <ElPagination
            v-model:current-page="query.pageNum"
            v-model:page-size="query.pageSize"
            :page-sizes="[10, 20, 50]"
            :total="total"
            layout="total, sizes, prev, pager, next"
            @change="fetchData"
          />
        </div>
      </ElCard>
    </div>

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="720px">
      <ElForm ref="formRef" :model="form" label-width="96px">
        <ElFormItem label="标题" prop="title" required>
          <ElInput v-model="form.title" maxlength="100" />
        </ElFormItem>
        <ElFormItem label="楼盘ID" prop="estateId" required>
          <ElInput v-model="form.estateId" />
        </ElFormItem>
        <ElFormItem label="租金/户型" required>
          <ElInputNumber v-model="form.rent" :min="1" />
          <ElInput
            v-model="form.houseType"
            class="ml-3"
            placeholder="2室1厅1卫"
            style="width: 180px"
          />
        </ElFormItem>
        <ElFormItem label="面积/楼层">
          <ElInputNumber v-model="form.coveredArea" :min="1" />
          <ElInput
            v-model="form.floor"
            class="ml-3"
            placeholder="8/18"
            style="width: 180px"
          />
        </ElFormItem>
        <ElFormItem label="租赁/装修">
          <ElSelect v-model="form.rentMethod" style="width: 140px">
            <ElOption label="整租" :value="1" />
            <ElOption label="合租" :value="2" />
          </ElSelect>
          <ElSelect v-model="form.decoration" class="ml-3" style="width: 140px">
            <ElOption label="精装" :value="1" />
            <ElOption label="简装" :value="2" />
            <ElOption label="毛坯" :value="3" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="封面图">
          <ElInput v-model="form.pic" placeholder="图片 URL" />
        </ElFormItem>
        <ElFormItem label="联系人">
          <ElInput v-model="form.contact" style="width: 180px" />
          <ElInput v-model="form.mobile" class="ml-3" style="width: 200px" />
        </ElFormItem>
        <ElFormItem label="状态">
          <ElSelect v-model="form.status" style="width: 140px">
            <ElOption
              v-for="item in statusOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="描述">
          <ElInput v-model="form.houseDesc" :rows="4" type="textarea" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" @click="submitForm">保存</ElButton>
      </template>
    </ElDialog>
  </Page>
</template>
