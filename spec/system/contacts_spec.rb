require 'rails_helper'

RSpec.describe "オファー送信機能", type: :system do
  before do
    @product1 = FactoryBot.create(:product)
    @product2 = FactoryBot.create(:product)
    @contact = FactoryBot.build(:contact)
  end

  context "オファーを送信できる" do
    it "ログインユーザーは他ユーザーのポートフォリオ詳細画面からオファーを送ることができる" do
      # ポートフォリオ１のユーザーでログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product1.user.email
      fill_in 'パスワード', with: @product1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # トップページにポートフォリオ２の作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product2.title}"), href: product_path(@product2)
      # ポートフォリオ２の詳細画面にアクセスする
      visit product_path(@product2)
      # オファー画面へのリンクが存在することを確認する
      expect(page).to have_link('オファーメッセージを送る')
      # オファー送信画面へ遷移する
      visit new_user_contact_path(@product2.user.id)
      # 入力フォームが存在することを確認する
      expect(page).to have_selector('.contact-form')
      # フォームを入力する
      fill_in 'メッセージを入力...', with: @contact.message
      # オファーを送信する
      find('input[name="commit"]').click
      # 成功するとポートフォリオ２の詳細画面に遷移することを確認する
      expect(current_path).to eq user_path(@product2.user.id)
    end
  end
  context "オファーを送信できない" do
    it "ログインユーザーは自身に対してオファーを送信できない" do
      # ポートフォリオ１のユーザーでログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product1.user.email
      fill_in 'パスワード', with: @product1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # トップページにポートフォリオ１の作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product1.title}"), href: product_path(@product1)
      # ポートフォリオ1の詳細画面にアクセスする
      visit product_path(@product1)
      # オファー画面へのリンクが存在しないことを確認する
      expect(page).to have_no_link('オファーメッセージを送る')
    end
    it "未ログインユーザーはオファーを送信できない" do
      # トップページに遷移する
      visit root_path
      # ポートフォリオ１の作品名ボタンがあることを確認する
      expect(page).to have_link("#{@product1.title}"), href: product_path(@product1)
      # ポートフォリオ1の詳細画面にアクセスする
      visit product_path(@product1)
      # オファー画面へのリンクが存在しないことを確認する
      expect(page).to have_no_link('オファーメッセージを送る')
    end
  end
end

RSpec.describe "オファー一覧、詳細表示機能", type: :system do
  before do
    @product1 = FactoryBot.create(:product)
    @product2 = FactoryBot.create(:product)
    @contact = FactoryBot.create(:contact)
  end

  context "オファーの一覧表示を確認できる" do
    it 'ログインユーザーはマイページからオファー一覧画面と詳細画面へ遷移できる' do
      # ポートフォリオ１のユーザーでログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product1.user.email
      fill_in 'パスワード', with: @product1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # トップページにマイページへのリンクが存在することを確認する
      expect(page).to have_link('マイページ')
      # マイページへ遷移する
      visit user_path(@product1.user.id)
      # オファー一覧画面へのリンクが存在することを確認する
      expect(page).to have_link('オファーを確認する')
      # オファー一覧画面に遷移し、オファーを送信したユーザー名が存在することを確認する
      visit user_contacts_path(@product1.user.id)
      expect(page).to have_content("#{@contact.user.nickname}")
      # オファー詳細画面へのリンクの存在を確認する  
      expect(page).to have_link('内容を確認する')
      # オファー詳細画面へ遷移する
      visit user_contact_path(@contact.user_id,@contact.id)
      # オファーメッセージが存在することを確認する
      expect(page).to have_content("#{@contact.message}")
    end
  end

  context "オファーの一覧画面を確認できない" do
    it 'ログインユーザーは他のユーザーのオファー一覧画面に遷移することができない' do
      # ポートフォリオ１のユーザーでログインする
      visit new_user_session_path
      fill_in 'Eメール', with: @product1.user.email
      fill_in 'パスワード', with: @product1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # トップページにポートフォリオ２の作成ユーザーのボタンが存在することを確認する
      expect(page).to have_link("#{@product2.user.nickname}")
      # ポートフォリオ２を作成したユーザーの詳細画面へ遷移する
      visit user_path(@product2.user.id)
      # オファー一覧画面へのリンクが存在しないことを確認する
      expect(page).to have_no_link('オファーを確認する')
    end
    it "未ログインユーザーはオファー一覧画面に遷移できない" do
      # トップページに遷移する
      visit root_path
      # ポートフォリオ１の作成ユーザーボタンがあることを確認する
      expect(page).to have_link("#{@product1.user.nickname}")
      # ポートフォリオ1の詳細画面にアクセスする
      visit user_path(@product1.user.id)
      # オファー画面へのリンクが存在しないことを確認する
      expect(page).to have_no_link('オファーを確認する')
    end
  end
end
