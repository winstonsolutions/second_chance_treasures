// 管理员权限验证中间件
function adminAuthMiddleware(req, res, next) {
    // 检查用户是否已登录
    if (!req.session.user) {
        // 未登录，重定向到登录页
        return res.redirect('/login');
    }
    
    // 检查用户是否有管理员权限
    if (req.session.user.role !== 'admin') {
        // 无权限，可以重定向到错误页或普通用户页
        return res.status(403).render('error', {
            message: '您没有权限访问此页面'
        });
    }
    
    // 有管理员权限，继续处理请求
    next();
}

// 路由配置
app.get('/admin/dashboard', adminAuthMiddleware, (req, res) => {
    // 渲染管理员面板
    res.render('admin/dashboard');
});

// 产品管理路由
app.get('/admin/products', adminAuthMiddleware, (req, res) => {
    // 获取所有产品并渲染产品管理页面
    const products = getAllProducts();
    res.render('admin/products', { products });
}); 