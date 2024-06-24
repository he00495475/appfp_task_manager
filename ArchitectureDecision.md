# 決策使用
  - MVVM 
    原因：
    - 較好維護的架構進行開發
    - 前後端分離 
    - 有助於分工及維護
  - firebase
    原因：
    - 提供關聯性功能，例如：離線資料、線上同步
    - 開發更有效率且完善
    - 實作的內容模組化，方便其他專案開發
    - 安全性驗證登入

# 架構
- extension 
  # 常用enum
- helper
  # 快速取得靜態資料
- models
  # 固定傳輸欄位
- service
  # api快速串接
- viewModels
  # 主要邏輯、使用model與後端索取資料(防止欄位疏漏、快速找碴問題)
- views
  # 將api接收資料以model形式快速帶入套版
- widgets
  # 將多次使用的widget封裝

# 資料表
- tasks 主任務
  - id
  - title 標題
  - description 描述
  - createDate 建立日期
  - dueDate 截止日期
  - isCompleted 已完成
  - isDeleted 已刪除(軟刪除)
  - category 分類
  - priority 優先級
  - userId 登入id
  - uuid 裝置唯一識別
- subTasks 子任務
  - id
  - title 標題
  - isCompleted 已完成
  - taskId 主任務id

- priority 優先級
- category 任務分類



