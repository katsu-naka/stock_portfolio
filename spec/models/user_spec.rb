require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end

    context 'ユーザー新規登録が成功する' do
      it '全ての項目が存在すれば登録できる' do
        expect(@user).to be_valid
      end
      it 'emailに@が存在すれば登録できる' do
        @user.email = 'aaa@aaa'
        expect(@user).to be_valid
      end
      it 'passwordが6文字以上であれば登録できる' do
        @user.password = 'aaaaaa1'
        @user.password_confirmation = 'aaaaaa1'
        expect(@user).to be_valid
      end
    end

    context 'ユーザー登録が失敗する' do
      it 'nicknameが空だと登録出来ない' do
        @user.nickname = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'emailが空だと登録出来ない' do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "重複したemailが存在する場合は登録出来ない" do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it 'passwordが空だと登録出来ない' do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it "passwordが5文字以下だと登録出来ない" do
        @user.password = 'aaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password", "Password is too short (minimum is 6 characters)")
      end
      it 'passwordが存在してもpassword_confirmationが空では登録出来ない' do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'first_nameが空だと登録出来ない' do
        @user.first_name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end
      it 'first_nameが全角文字以外だと登録出来ない' do
        @user.first_name = "aaa"
        @user.valid?
        expect(@user.errors.full_messages).to include("First name は全角で入力してください")
      end
      it 'last_nameが空だと登録出来ない' do
        @user.last_name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end
      it 'Last_nameが全角文字以外だと登録出来ない' do
        @user.last_name = "aaa"
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name は全角で入力してください")
      end
      it 'first_name_kanaが空だと登録出来ない' do
        @user.first_name_kana = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana can't be blank")
      end
      it 'first_name_kanaが全角カタカナ以外だと登録出来ない' do
        @user.first_name_kana = "山田"
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana は全角カタカナで入力してください")
      end
      it 'last_name_kanaが空だと登録出来ない' do
        @user.last_name_kana = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank")
      end
      it 'last_name_kanaが全角カタカナ以外だと登録出来ない' do
        @user.last_name_kana = "太郎"
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana は全角カタカナで入力してください")
      end
      it 'birthが空だと登録出来ない' do
        @user.birth = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth can't be blank")
      end
      it 'phone_numberが空だと登録出来ない' do
        @user.phone_number = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが半角数字以外だと登録出来ない' do
        @user.phone_number = "０９０００００１１１１"
        @user.valid?
        expect(@user.errors.full_messages).to include("Phone number は半角数字のみ入力してください")
      end
    end
  end
end
