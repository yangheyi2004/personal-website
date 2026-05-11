// ===== 个人信息数据 =====
const personalData = {
    name: "杨和一",
    title: "不知道啊",
    bio: "热爱技术的DevOps工程师，专注于容器化、自动化运维和云原生技术。",
    email: "2791130991@qq.com",
    github: "github.com/yangheyi2004",
    linkedin: "无",
    
    // 项目数据
    projects: [
        {
            name: "CI/CD流水线平台",
            description: "使用Jenkins、GitLab和Docker搭建的自动化CI/CD平台，支持多环境部署和自动化测试。",
            icon: "🚀",
            tags: ["Jenkins", "Docker", "GitLab"]
        },
        {
            name: "公益助学网页（测试）",
            description: "熟悉前端开发流程，具备一定的前后端交互能力。",
            icon: "🚉",
            tags: ["web", "php", "mysql"]
        },
        {
            name: "网络工程基础",
            description: "华为认证，熟悉华为，思科设备的配置",
            icon: "🛜",
            tags: ["HCIA", "华为", "思科"]
        }
    ]
};

// ===== 页面加载完成后执行 =====
document.addEventListener('DOMContentLoaded', function() {
    // 加载最新项目（在首页）
    loadLatestProjects();
    
    // 更新部署信息
    updateDeployInfo();
    setInterval(updateDeployInfo, 1000);
    
    // 处理联系表单提交
    setupContactForm();
    
    // 高亮当前页面的导航菜单
    highlightCurrentNav();
});

// ===== 加载最新项目 =====
function loadLatestProjects() {
    const projectsContainer = document.getElementById('latest-projects');
    if (!projectsContainer) return;
    
    // 只显示前3个项目
    const latestProjects = personalData.projects.slice(0, 3);
    
    projectsContainer.innerHTML = latestProjects.map(project => `
        <div class="project-card">
            <div class="project-icon">${project.icon}</div>
            <h3>${project.name}</h3>
            <p class="project-description">${project.description}</p >
            <div class="project-tech">
                ${project.tags.map(tag => `<span class="tech-tag">${tag}</span>`).join('')}
            </div>
        </div>
    `).join('');
}

// ===== 更新部署信息 =====
function updateDeployInfo() {
    // 更新时间
    const deployTimeEl = document.getElementById('deploy-time');
    if (deployTimeEl) {
        const now = new Date();
        deployTimeEl.textContent = now.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        });
    }
    
    // 获取容器ID
    const containerIdEl = document.getElementById('container-id');
    if (containerIdEl) {
        fetch('/container-id')
            .then(response => response.text())
            .then(id => {
                containerIdEl.textContent = id.substring(0, 12);
            })
            .catch(() => {
                containerIdEl.textContent = 'local-dev';
            });
    }
}

// ===== 设置联系表单 =====
function setupContactForm() {
    const form = document.getElementById('message-form');
    if (!form) return;
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 获取表单数据
        const formData = new FormData(form);
        const data = Object.fromEntries(formData);
        
        // 显示成功消息
        alert('消息已发送！我会尽快回复你。');
        
        // 重置表单
        form.reset();
        
        // 在控制台显示表单数据（实际应用中这里会发送到后端）
        console.log('表单提交数据:', data);
    });
}

// ===== 高亮当前导航 =====
function highlightCurrentNav() {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    const navLinks = document.querySelectorAll('.nav-menu a');
    
    navLinks.forEach(link => {
        const linkPage = link.getAttribute('href');
        if (linkPage === currentPage) {
            link.classList.add('active');
        }
    });
}

// ===== 控制台欢迎信息 =====
console.log('%c👋 欢迎访问杨和一的个人网站', 'font-size: 16px; color: #667eea; font-weight: bold;');
console.log('%c当前版本: 1.1.6', 'color: #764ba2;');
console.log('%c部署时间: ' + new Date().toLocaleString(), 'color: #666;');