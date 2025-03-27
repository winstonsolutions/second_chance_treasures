// 登录表单提交处理
document.getElementById('login-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    
    // 发送登录请求
    fetch('/api/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 登录成功，根据用户角色重定向
            if (data.user.role === 'admin') {
                window.location.href = '/admin/dashboard';
            } else {
                window.location.href = '/';  // 普通用户重定向到首页
            }
        } else {
            // 显示错误消息
            document.getElementById('login-error').textContent = data.message;
        }
    })
    .catch(error => {
        console.error('登录失败:', error);
        document.getElementById('login-error').textContent = '登录请求失败，请重试';
    });
}); 