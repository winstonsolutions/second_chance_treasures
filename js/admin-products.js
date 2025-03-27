// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 加载所有产品
    loadProducts();
    
    // 添加产品按钮点击事件
    document.getElementById('add-product-btn').addEventListener('click', function() {
        openProductModal();
    });
    
    // 产品表单提交事件
    document.getElementById('product-form').addEventListener('submit', function(e) {
        e.preventDefault();
        saveProduct();
    });
    
    // 取消按钮点击事件
    document.getElementById('cancel-btn').addEventListener('click', function() {
        closeProductModal();
    });
    
    // 关闭模态框按钮
    document.querySelector('.close').addEventListener('click', function() {
        closeProductModal();
    });
    
    // 取消删除按钮
    document.getElementById('cancel-delete-btn').addEventListener('click', function() {
        closeDeleteModal();
    });
});

// 加载所有产品
function loadProducts() {
    // 发送AJAX请求获取产品列表
    fetch('/api/admin/products')
        .then(response => response.json())
        .then(products => {
            displayProducts(products);
        })
        .catch(error => {
            console.error('加载产品失败:', error);
            alert('加载产品失败，请重试');
        });
}

// 显示产品列表
function displayProducts(products) {
    const tableBody = document.getElementById('products-table-body');
    tableBody.innerHTML = '';
    
    products.forEach(product => {
        const row = document.createElement('tr');
        
        row.innerHTML = `
            <td>${product.id}</td>
            <td><img src="${product.imageUrl || '/images/no-image.png'}" alt="${product.name}" class="product-thumbnail"></td>
            <td>${product.name}</td>
            <td>$${product.price.toFixed(2)}</td>
            <td>${product.status || 'N/A'}</td>
            <td>
                <button class="btn btn-small btn-edit" data-id="${product.id}">编辑</button>
                <button class="btn btn-small btn-delete" data-id="${product.id}">删除</button>
            </td>
        `;
        
        tableBody.appendChild(row);
    });
    
    // 为编辑按钮添加事件
    document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.getAttribute('data-id');
            editProduct(productId);
        });
    });
    
    // 为删除按钮添加事件
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.getAttribute('data-id');
            confirmDeleteProduct(productId);
        });
    });
}

// 打开产品编辑/添加模态框
function openProductModal(product = null) {
    const modal = document.getElementById('product-modal');
    const modalTitle = document.getElementById('modal-title');
    const form = document.getElementById('product-form');
    
    // 重置表单
    form.reset();
    
    if (product) {
        // 编辑现有产品
        modalTitle.textContent = '编辑产品';
        document.getElementById('product-id').value = product.id;
        document.getElementById('product-name').value = product.name;
        document.getElementById('product-price').value = product.price;
        document.getElementById('product-description').value = product.description || '';
        document.getElementById('product-image').value = product.imageUrl || '';
        document.getElementById('product-status').value = product.status || 'Like New';
    } else {
        // 添加新产品
        modalTitle.textContent = '添加产品';
        document.getElementById('product-id').value = '';
    }
    
    modal.style.display = 'block';
}

// 关闭产品模态框
function closeProductModal() {
    const modal = document.getElementById('product-modal');
    modal.style.display = 'none';
}

// 编辑产品
function editProduct(productId) {
    // 发送AJAX请求获取产品详情
    fetch(`/api/admin/products/${productId}`)
        .then(response => response.json())
        .then(product => {
            openProductModal(product);
        })
        .catch(error => {
            console.error('获取产品详情失败:', error);
            alert('获取产品详情失败，请重试');
        });
}

// 保存产品（添加或更新）
function saveProduct() {
    const productId = document.getElementById('product-id').value;
    
    const productData = {
        name: document.getElementById('product-name').value,
        price: parseFloat(document.getElementById('product-price').value),
        description: document.getElementById('product-description').value,
        imageUrl: document.getElementById('product-image').value,
        status: document.getElementById('product-status').value
    };
    
    const url = productId ? `/api/admin/products/${productId}` : '/api/admin/products';
    const method = productId ? 'PUT' : 'POST';
    
    // 发送AJAX请求保存产品
    fetch(url, {
        method: method,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(productData)
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(productId ? '产品更新成功！' : '产品添加成功！');
            closeProductModal();
            loadProducts(); // 重新加载产品列表
        } else {
            alert(result.message || '操作失败，请重试');
        }
    })
    .catch(error => {
        console.error('保存产品失败:', error);
        alert('保存产品失败，请重试');
    });
}

// 显示删除确认模态框
function confirmDeleteProduct(productId) {
    const modal = document.getElementById('delete-modal');
    
    // 为确认删除按钮添加事件
    document.getElementById('confirm-delete-btn').onclick = function() {
        deleteProduct(productId);
    };
    
    modal.style.display = 'block';
}

// 关闭删除确认模态框
function closeDeleteModal() {
    const modal = document.getElementById('delete-modal');
    modal.style.display = 'none';
}

// 删除产品
function deleteProduct(productId) {
    // 发送AJAX请求删除产品
    fetch(`/api/admin/products/${productId}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert('产品删除成功！');
            closeDeleteModal();
            loadProducts(); // 重新加载产品列表
        } else {
            alert(result.message || '删除失败，请重试');
        }
    })
    .catch(error => {
        console.error('删除产品失败:', error);
        alert('删除产品失败，请重试');
    });
} 