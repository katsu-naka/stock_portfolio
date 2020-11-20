require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'オファー送信' do
    before do
      @contact = FactoryBot.build(:contact)
    end

    context 'オファー送信が成功する' do
      it "全ての項目が正しく入力されていれば送信できる" do
        expect(@contact).to be_valid
      end
    end
    
    context 'オファー送信が失敗する' do
      it "messageが空だと送信できない" do
        @contact.message = ""
        @contact.valid?
        expect(@contact.errors.full_messages).to include("Message can't be blank")
      end
    end
  end
end
