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
