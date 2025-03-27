// 用户登录认证函数
function authenticateUser(email, password) {
    // 获取用户信息
    const user = getUserFromDatabase(email);
    
    // 验证用户是否存在
    if (!user) {
        return {success: false, message: "Invalid Email or password"};
    }
    
    // 验证密码
    if (!verifyPassword(password, user.passwordHash)) {
        return {success: false, message: "Invalid Email or password"};
    }
    
    // 登录成功，返回用户信息（包括角色）
    return {
        success: true,
        user: {
            id: user.id,
            email: user.email,
            role: user.role, // 确保返回角色信息
            // 其他需要的用户信息
        }
    };
}

// 登录后重定向函数
function redirectAfterLogin(user) {
    // 根据用户角色决定重定向到哪个页面
    if (user.role === 'admin') {
        // 重定向到管理员面板
        window.location.href = '/admin/dashboard';
    } else {
        // 重定向到普通用户页面
        window.location.href = '/user/dashboard';
    }
} 