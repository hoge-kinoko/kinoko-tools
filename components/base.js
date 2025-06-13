// 外部リソースの設定
const EXTERNAL_RESOURCES = [
  {
    type: 'link',
    href: 'https://cdn.jsdelivr.net/npm/@materializecss/materialize@2.0.3-alpha/dist/css/materialize.min.css',
    rel: 'stylesheet'
  },
  {
    type: 'link',
    href: 'https://fonts.googleapis.com/icon?family=Material+Icons',
    rel: 'stylesheet'
  },
  {
    type: 'script',
    src: 'https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js'
  },
  {
    type: 'script',
    src: 'https://cdn.jsdelivr.net/npm/@materializecss/materialize@2.0.3-alpha/dist/js/materialize.min.js'
  }
];

// ヘッダーの設定
const HEADER_CONFIG = {
  brandName: 'キノ伝ほげぇツール',
  brandLink: '/kinoko-tools/index.html',
  navClass: 'nav-wrapper amber darken-1'
};

/**
 * 外部リソースを効率的に読み込む
 */
function loadExternalResources() {
  const fragment = document.createDocumentFragment();
  
  EXTERNAL_RESOURCES.forEach(resource => {
    const elem = document.createElement(resource.type);
    
    // リソースの属性を設定
    Object.entries(resource).forEach(([key, value]) => {
      if (key !== 'type') {
        elem[key] = value;
      }
    });
    
    fragment.appendChild(elem);
  });
  
  document.head.appendChild(fragment);
}

/**
 * ヘッダーを作成する
 */
function createHeader() {
  const headerElement = document.getElementById('header');
  if (!headerElement) {
    console.error('ヘッダー要素が見つかりません');
    return;
  }
  
  // header要素を作成
  const header = document.createElement('header');
  const nav = document.createElement('nav');
  const brandLogo = document.createElement('a');
  
  // 属性を設定
  nav.className = HEADER_CONFIG.navClass;
  brandLogo.className = 'brand-logo center';
  brandLogo.href = HEADER_CONFIG.brandLink;
  brandLogo.textContent = HEADER_CONFIG.brandName;
  
  // DOM構造を構築
  nav.appendChild(brandLogo);
  header.appendChild(nav);
  headerElement.appendChild(header);
}

/**
 * エラーハンドリング付きの初期化処理
 */
function initialize() {
  try {
    loadExternalResources();
    
    // DOMContentLoadedイベントで確実にヘッダーを作成
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', createHeader);
    } else {
      // 既にDOMが読み込まれている場合
      createHeader();
    }
  } catch (error) {
    console.error('初期化中にエラーが発生しました:', error);
  }
}

// 初期化を実行
initialize();