// ... (你已有的其他 require/import 语句)const communityPostRoutes = require('./routes/communityPostRoutes'); // 1. 引入社区路由

// ... (你已有的其他 app.use(...) 语句)

// 2. 使用社区路由
// 告诉 Express: 所有发往 /api/community 的请求，都由 communityPostRoutes 文件来处理
app.use('/api/community', communityPostRoutes);

// ... (你服务器的 app.listen(...) 代码)