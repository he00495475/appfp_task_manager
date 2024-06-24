# appfp_task_manager

任務管理系統
***目前只有開發測試android，請用android***
- 任務管理(CRUD)(ps:軟D)
- 本地推播
- email登入、google登入

## 支援系統
- android

## 環境
- vscode 1.89.0
- flutter version: 3.19.6
- java 17.0.11
- gradle 8.8

## 安裝應用
- 執行命令 
1. flutter clean
2. flutter pub get
3. flutter run

## 使用第三方
- firestore 後端資料
- fire_auth email登入、google登入

## 現有功能
- 任務清單
  - 分類篩選
    - 全部、工作、個人
  
  - 排序
    - 截止日期升逆排序、建立日期升逆排序、優先升逆排序

  - 過濾
    - 已完成、逾期、高優先級
    
- 任務詳細
  - 可修改 截止日期、分類、優先順序、標題、描述、子任務(標記已完成、描述、刪除)

- 登入
  - email登入、google登入

- 推播
  # 根據新增修改當下的日期決定是否推播，時間小於當下則不推播。
  # 目前可推播但請求權限尚未完成，測試時請幫我手動打開權限。 
  # (應用程式資訊 -> 權限 -> '通知')

- 資料雲端同步
  - 線上同步
  - 離線模式(未完成)

