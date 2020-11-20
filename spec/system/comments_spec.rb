require 'rails_helper'

RSpec.describe "コメント送信機能", type: :system do
  before do
    @product = FactoryBot.create(:product)
    @comment = FactoryBot.create(:comment)
  end
  context "コメントが送信できる" do
    it "ログインユーザーはポートフォリオ詳細画面からコメントの送信ができる" do
      #ログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product.user.email
      fill_in 'パスワード', with: @product.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # 詳細ページにコメントフォームが存在するか確認する
      expect(page).to have_selector('.comment-form')
      # コメントフォームを入力する
      fill_in 'コメントを入力...', with: @comment.comment
      # コメントを送信する
      find('.comment-submit').click
      # 送信したコメントがコメント欄に存在するか確認する
      expect(page).to have_content("#{@comment.comment}")
    end
  end
  context "コメントが送信できない" do
    it "コメントを正しく入力しないとコメント送信ができない" do
      #ログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product.user.email
      fill_in 'パスワード', with: @product.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # 詳細ページにコメントフォームが存在するか確認する
      expect(page).to have_selector('.comment-form')
      # コメントフォームを空にする
      fill_in 'コメントを入力...', with: ""
      # コメントを送信する
      find('.comment-submit').click
      # 送信に失敗し詳細画面に留まる
      expect(page).to have_selector(".comment-form")
    end
    it '未ログインユーザーはポートフォリオ詳細画面でコメント欄が表示されずコメント送信できない' do
      # トップページに移動する
      visit root_path
      # ポートフォリオ一覧に作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product.title}"), href: product_path(@product)
      # ポートフォリオ詳細ページへ遷移する
      visit product_path(@product)
      # コメント用のフォームが存在しない
      expect(page).to have_no_selector(".comment-form")
    end
  end
end
