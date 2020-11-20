require 'rails_helper'

RSpec.describe "ポートフォリオ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @product = FactoryBot.build(:product)
  end

  context 'ポートフォリオ投稿ができる時' do
    it 'ログインしたユーザーは新規投稿ができる' do
    # ログインする
    visit new_user_session_path
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: @user.password
    find('input[name="commit"]').click
    # #新規ポートフォリオ作成ページへのリンクがあることを確認する
    expect(page).to have_content('ポートフォリオをアップロード')
    # 新規ポートフォリオ作成ページへ遷移する
    visit new_product_path
    # フォームに情報を入力する
    fill_in '作品名（必須）', with: @product.title
    fill_in '説明（任意）', with: @product.text
    fill_in 'GitHubのURL（任意）', with: @product.github_uri
    fill_in '作品のURL（任意）', with: @product.product_uri
    # 投稿ボタンをクリックするとproductモデルのカウントが１Upすることを確認する
    expect{
      find('input[name="commit"]').click
    }.to change { Product.count }.by(1)
    # 投稿完了後トップページに自動遷移し投稿したポートフォリオが存在することを確認する
    expect(page).to have_content(@product.title)
    end
  end

  context 'ポートフォリオ投稿が失敗するとき' do
    it 'ログインしていないと新規登録ページに遷移できない' do
      #トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがない
      expect(page).to have_content('ポートフォリオをアップロードするにはログインしてください')
    end
    it 'ポートフォリオ情報が正しく入力できていないと登録できない' do
      # ログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      # # 新規ポートフォリオ作成ページへのリンクがあることを確認する
      expect(page).to have_content('ポートフォリオをアップロード')
      # 新規ポートフォリオ作成ページへ遷移する
      visit new_product_path
      # フォームに空の情報を入力する
      fill_in '作品名（必須）', with: ""
      fill_in '説明（任意）', with: ""
      fill_in 'GitHubのURL（任意）', with: ""
      fill_in '作品のURL（任意）', with: ""
      # 投稿ボタンをクリックしてもポートフォリオが追加されずカウントUpしないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Product.count }.by(0)
      # 投稿に失敗し新規ポートフォリオ作成ページに留まることを確認する
      expect(current_path).to eq "/products"
    end
  end
end

RSpec.describe 'ポートフォリオ詳細', type: :system do
  before do
    @product = FactoryBot.create(:product)
  end
  it 'ログインしたユーザーはポートフォリオ詳細ページに遷移できる' do
    # ログインする
    visit new_user_session_path   
    fill_in 'Eメール', with: @product.user.email
    fill_in 'パスワード', with: @product.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # ポートフォリオ一覧画面に作品名ボタンがあることを確認する
    expect(page).to have_link("#{@product.title}"), href: product_path(@product)
    # 詳細ページに遷移する
    visit product_path(@product)
    # 詳細ページにポートフォリオの内容が含まれている
    expect(page).to have_content("#{@product.title}")
    expect(page).to have_content("#{@product.text}")
    # メッセージ用のフォームが存在する
    expect(page).to have_selector(".comment-form")
  end
  it '未ログインしたユーザーはポートフォリオ詳細ページに遷移できるがコメント欄は表示されない' do
    # トップページにアクセスする
    visit root_path
    # ポートフォリオ一覧画面に作品名ボタンがあることを確認する
    expect(page).to have_link("#{@product.title}"), href: product_path(@product)
    # 詳細ページに遷移する
    visit product_path(@product)
    # 詳細ページにポートフォリオの内容が含まれている
    expect(page).to have_content("#{@product.title}")
    expect(page).to have_content("#{@product.text}")
    # コメント用のフォームが存在しない
    expect(page).to have_no_selector(".comment-form")
  end
end

RSpec.describe 'ポートフォリオ編集', type: :system do
  before do
    @product = FactoryBot.create(:product)
  end
  context "ポートフォリオの編集が成功する" do
    it 'ログインしたユーザーは自分が投稿したポートフォリオの編集ができる' do
      # ポートフォリオ１を投稿したユーザーでログインする
      visit new_user_session_path   
      fill_in 'Eメール', with: @product.user.email
      fill_in 'パスワード', with: @product.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # ポートフォリオ詳細ページに編集ボタンがあることを確認する
      expect(page).to have_link("編集"), href: edit_product_path(@product)
      # 編集ページへ遷移する
      visit edit_product_path(@product)
      # 既に投稿済みのポートフォリオ内容がフォームに入っていることを確認する
      expect(
        find('#product_title').value
      ).to eq @product.title
      expect(
        find('#product_text').value
      ).to eq @product.text
      expect(
        find('#product_github_uri').value
      ).to eq @product.github_uri
      expect(
        find('#product_product_uri').value
      ).to eq @product.product_uri
      # ポートフォリオの作品名と説明を編集する
      fill_in 'product_title', with: "#{@product.title}+編集したタイトル"
      fill_in 'product_text', with: "#{@product.text}+編集したテキスト"
      # 編集してもproductモデルのカウントが変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Product.count }.by(0)
      # 更新後再度ポートフォリオ１詳細ページに遷移する
      expect(current_path).to eq product_path(@product)
      # 詳細ページの内容が更新されていることを確認する
      expect(page).to have_content("#{@product.title}+編集したタイトル")
      expect(page).to have_content("#{@product.text}+編集したテキスト")
      # トップページに遷移する
      visit root_path
      # トップページに先ほど更新した内容のポートフォリオが存在することを確認する
      expect(page).to have_content("#{@product.title}+編集したタイトル")
    end
  end
  context "ポートフォリオの編集が失敗する" do
    it 'ログインしていないとポートフォリオの編集画面に遷移できない' do
      # トップページに遷移する
      visit root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # ポートフォリオ詳細ページに編集ボタンが存在しないことを確認する
      expect(page).to have_no_link("編集"), href: edit_product_path(@product)
      # 直接パスを打ち込んでもページ遷移しないことを確認
      visit edit_product_path(@product)
      # ログイン画面に戻されたことを確認
      expect(page).to have_content('ログイン')
    end
  end
end

RSpec.describe 'ポートフォリオ削除', type: :system do
  before do
    @product = FactoryBot.create(:product)
  end
  context 'ポートフォリオが削除が成功する' do
    it 'ログインしたユーザーはポートフォリオ一覧詳細からポートフォリオの削除ができる' do
      # ポートフォリオを投稿したユーザーでログインする
      visit new_user_session_path   
      fill_in 'Eメール', with: @product.user.email
      fill_in 'パスワード', with: @product.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # ポートフォリオに削除ボタンがあることを確認する
      expect(page).to have_link("削除"), href: product_path(@product)
      # ポートフォリオを削除するとレコード数が１減ることを確認する
      expect{
        find_link('削除', href: product_path(@product)).click
      }.to change { Product.count }.by(-1)
      # トップページに遷移する
      visit root_path
      # トップページに削除したポートフォリオ内容が存在しないことを確認する
      expect(page).to have_no_content("#{@product.title}")
    end
  end
  context 'ポートフォリオの削除ができない時' do
    it 'ログインしていないユーザーはポートフォリオの削除ができない' do
      # トップページに遷移する
      visit root_path
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # 削除ボタンがないことを確認する
      expect(page).to have_no_link("削除"), href: product_path(@product)
    end
  end
end
