require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_link("新規登録"), href: new_user_registration_path 
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ニックネーム（表示名）', with: @user.nickname
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード（再入力）', with: @user.password_confirmation
      fill_in '姓', with: @user.last_name
      fill_in '名', with: @user.first_name
      fill_in 'セイ', with: @user.last_name_kana
      fill_in 'メイ', with: @user.first_name_kana
      find('#user_birth_1i').find('option[value="2000"]').select_option
      find('#user_birth_2i').find('option[value="1"]').select_option
      find('#user_birth_3i').find('option[value="1"]').select_option
      fill_in '電話番号', with: @user.phone_number
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # トップページにログアウトボタンが表示されることを確認する
      expect(page).to have_content("ログアウト")
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_link('新規登録')
      expect(page).to have_no_link('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_link("新規登録"), href: new_user_registration_path 
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ニックネーム（表示名）', with: ""
      fill_in 'Eメール', with: ""
      fill_in 'パスワード', with: ""
      fill_in 'パスワード（再入力）', with: ""
      fill_in '姓', with: ""
      fill_in '名', with: ""
      fill_in 'セイ', with: ""
      fill_in 'メイ', with: ""
      fill_in '電話番号', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end


RSpec.describe "ユーザーログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインが成功する' do
    it '正しい情報を入力すればログインができてトップページに遷移する' do
      # トップページに移動する
      visit root_path
      # トップページにログイン画面へ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # トップページに遷移する
      expect(current_path).to eq root_path
      # プルダウンメニューをクリックするととログアウトボタンが表示されることを確認する
      expect(page).to have_content("ログアウト")
      # 新規登録画面へ遷移するボタンや、ログイン画面に遷移するボタンがないか確認する
      expect(page).to have_no_link('新規登録')
      expect(page).to have_no_link('ログイン')
    end
  end
  context 'ログインが失敗する' do
    it '誤った情報ではログインできずログイン画面に留まる' do
      # トップページに移動する
      visit root_path
      # トップページにログイン画面へ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Eメール', with: ""
      fill_in 'パスワード', with: ""
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      #  ログインページに留まることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end