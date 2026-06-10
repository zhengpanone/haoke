export interface PageResult<T> {
  current: number;
  records: T[];
  size: number;
  total: number;
}

export interface HouseResource {
  id: string;
  title: string;
  estateId?: string;
  imageUrl?: string;
  rent?: number;
  rentMethod?: string;
  paymentMethod?: number;
  houseType?: string;
  coveredArea?: number;
  floor?: string;
  orientation?: string;
  decoration?: string;
  facilities?: string;
  description?: string;
  contact?: string;
  mobile?: string;
  status?: string;
  created?: string;
  updated?: string;
}

export interface HouseResourcePayload {
  id?: string;
  title: string;
  estateId: string;
  buildingNum?: string;
  buildingUnit?: string;
  buildingFloorNum?: string;
  rent: number;
  rentMethod: number;
  paymentMethod?: number;
  houseType: string;
  coveredArea?: number;
  useArea?: string;
  floor?: string;
  orientation?: number;
  decoration?: number;
  facilities?: string;
  pic?: string;
  houseDesc?: string;
  contact?: string;
  mobile?: string;
  time?: number;
  propertyCost?: string;
  status?: string;
}

export interface HouseResourceQuery {
  keyword?: string;
  maxRent?: number;
  minRent?: number;
  pageNum: number;
  pageSize: number;
  status?: string;
}

export interface NewsArticle {
  id: string;
  title: string;
  summary?: string;
  content?: string;
  coverUrl?: string;
  source?: string;
  status?: number;
  sort?: number;
  publishTime?: string;
  created?: string;
  updated?: string;
}

export interface NewsArticlePayload {
  id?: string;
  title: string;
  summary?: string;
  content: string;
  coverUrl?: string;
  source?: string;
  status?: number;
  sort?: number;
  publishTime?: string;
}

export interface NewsArticleQuery {
  pageNum: number;
  pageSize: number;
  status?: number;
  title?: string;
}

export interface AdminProfileQuery {
  income?: boolean;
  keyword?: string;
  pageNum: number;
  pageSize: number;
  recordType?: string;
  status?: string;
  userId?: string;
}

export interface StatusPayload {
  rejectReason?: string;
  status: string;
}

export interface ViewingRecord {
  address?: string;
  appointmentTime?: string;
  contactName?: string;
  contactPhone?: string;
  createTime?: string;
  houseId?: string;
  id: string;
  note?: string;
  status?: string;
  title?: string;
  updateTime?: string;
  userId?: string;
}

export interface HouseOrder {
  actionText?: string;
  address?: string;
  amount?: number;
  createTime?: string;
  houseId?: string;
  id: string;
  orderNo?: string;
  orderTime?: string;
  status?: string;
  title?: string;
  updateTime?: string;
  userId?: string;
}

export interface HouseFavorite {
  address?: string;
  createTime?: string;
  favoriteTime?: string;
  houseId?: string;
  id: string;
  imageUrl?: string;
  price?: number;
  tags?: string;
  title?: string;
  updateTime?: string;
  userId?: string;
}

export interface IdentityVerification {
  createTime?: string;
  id: string;
  idCardBack?: string;
  idCardFront?: string;
  idCardNo?: string;
  realName?: string;
  rejectReason?: string;
  reviewedAt?: string;
  status?: string;
  submittedAt?: string;
  updateTime?: string;
  userId?: string;
}

export interface HouseContract {
  contractNo?: string;
  createTime?: string;
  houseId?: string;
  id: string;
  orderId?: string;
  pdfUrl?: string;
  periodEnd?: string;
  periodStart?: string;
  signUrl?: string;
  status?: string;
  title?: string;
  updateTime?: string;
  userId?: string;
}

export interface UserWallet {
  balance?: number;
  createTime?: string;
  frozenAmount?: number;
  id: string;
  updateTime?: string;
  userId?: string;
}

export interface WalletRecord {
  amount?: number;
  createTime?: string;
  id: string;
  income?: boolean;
  recordTime?: string;
  recordType?: string;
  status?: string;
  title?: string;
  updateTime?: string;
  userId?: string;
}

export interface ContactChannel {
  description?: string;
  title?: string;
  type?: string;
  value?: string;
}
